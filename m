Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00CE627264
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 21:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiKMUBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 15:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbiKMUBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 15:01:43 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 950221005F;
        Sun, 13 Nov 2022 12:01:41 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 7DF7922934;
        Sun, 13 Nov 2022 22:01:39 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id F3D112292F;
        Sun, 13 Nov 2022 22:01:37 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id B61733C0437;
        Sun, 13 Nov 2022 22:01:37 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 2ADK1abh076983;
        Sun, 13 Nov 2022 22:01:37 +0200
Date:   Sun, 13 Nov 2022 22:01:36 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
cc:     netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] ipv4: fix source address and gateway mismatch under
 multiple default gateways
In-Reply-To: <dd75da01-ef55-cd4f-4e8c-12c6b5cc4ab7@huawei.com>
Message-ID: <dae35070-bb8b-c110-f398-7431c243c87@ssi.bg>
References: <20221026032017.3675060-1-william.xuanziyang@huawei.com> <5e0249d-b6e1-44fa-147b-e2af65e56f64@ssi.bg> <dd75da01-ef55-cd4f-4e8c-12c6b5cc4ab7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sat, 29 Oct 2022, Ziyang Xuan (William) wrote:

> > On Wed, 26 Oct 2022, Ziyang Xuan wrote:
> > 
> >> We found a problem that source address doesn't match with selected gateway
> >> under multiple default gateways. The reproducer is as following:
> >>
> >> Setup in client as following:
> >>
> >> $ ip link add link eth2 dev eth2.71 type vlan id 71
> >> $ ip link add link eth2 dev eth2.72 type vlan id 72
> >> $ ip addr add 192.168.71.41/24 dev eth2.71
> >> $ ip addr add 192.168.72.41/24 dev eth2.72
> >> $ ip link set eth2.71 up
> >> $ ip link set eth2.72 up
> >> $ route add -net default gw 192.168.71.1 dev eth2.71
> >> $ route add -net default gw 192.168.72.1 dev eth2.72
> > 
> > 	Second route goes to first position due to the
> > prepend operation for the route add command. That is
> > why 192.168.72.41 is selected.
> > 
> >> Add a nameserver configuration in the following file:
> >> $ cat /etc/resolv.conf
> >> nameserver 8.8.8.8
> >>
> >> Setup in peer server as following:
> >>
> >> $ ip link add link eth2 dev eth2.71 type vlan id 71
> >> $ ip link add link eth2 dev eth2.72 type vlan id 72
> >> $ ip addr add 192.168.71.1/24 dev eth2.71
> >> $ ip addr add 192.168.72.1/24 dev eth2.72
> >> $ ip link set eth2.71 up
> >> $ ip link set eth2.72 up
> >>
> >> Use the following command trigger DNS packet in client:
> >> $ ping www.baidu.com
> >>
> >> Capture packets with tcpdump in client when ping:
> >> $ tcpdump -i eth2 -vne
> >> ...
> >> 20:30:22.996044 52:54:00:20:23:a9 > 52:54:00:d2:4f:e3, ethertype 802.1Q (0x8100), length 77: vlan 71, p 0, ethertype IPv4, (tos 0x0, ttl 64, id 25407, offset 0, flags [DF], proto UDP (17), length 59)
> >>     192.168.72.41.42666 > 8.8.8.8.domain: 58562+ A? www.baidu.com. (31)
> >> ...
> >>
> >> We get the problem that IPv4 saddr "192.168.72.41" do not match with
> >> selected VLAN device "eth2.71".
> > 
> > 	The problem could be that source address is selected
> > once and later used as source address in following routing lookups.
> > 
> > 	And your routing rules do not express the restriction that
> > both addresses can not be used for specific route. If you have
> > such restriction which is common, you should use source-specific routes:
> 
> Hi Julian,
> 
> Thank you for your quick reply.
> 
> Can we make some work to make the restriction "both addresses can not be used for specific route" in code but in consciousness?

	No good idea about this. Not sure if the new 'nexthop'
object is suitable for such policy.

Regards

--
Julian Anastasov <ja@ssi.bg>

