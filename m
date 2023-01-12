Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216EA66796C
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240401AbjALPgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbjALPfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:35:39 -0500
X-Greylist: delayed 158343 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Jan 2023 07:26:12 PST
Received: from netgeek.ovh (ks.netgeek.ovh [IPv6:2001:41d0:a:271e::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D985FAF;
        Thu, 12 Jan 2023 07:26:12 -0800 (PST)
Received: from quaddy.sgn (unknown [IPv6:2a01:cb19:83f8:d500:21d:60ff:fedb:90ab])
        by ks.netgeek.ovh (Postfix) with ESMTPSA id F372B152;
        Thu, 12 Jan 2023 16:26:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=netgeek.ovh;
        s=default; t=1673537171;
        bh=3etuJSk1QFYh09LyrRX3nJ+AUux/LmBLhAzOGdCxjwU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=mOWUIxS3WNMLPOwYovm3Xk70mdgT9DVAy0MWW4cIhIu+1nboaVb4ebub//9kSo2ip
         iZjpyfHIggBvbCIk9uWXJMu4BX1IZuxAxoX9vUSbS42Oek7zT03f0bmEvbzRaaoASH
         CqGYtRJZBdFzMBAvE24YtRVP9R5O109e0GShsMubIpE3St7wF4qS5vhY8CeKTJ3iLu
         lKWrPIkjKHhbZnWzFEhqo4tTDseQtIf+qzIci0XNdY5zHwr5RSDjyeIwfDFhiPUNf3
         W0oH2m08PMkJWGoHCd2b66a4M8OyDjglT/YnG8A8lThImNG1zJar3S/49s+f2tC7Im
         F48lTVf/cgWNw==
Date:   Thu, 12 Jan 2023 16:27:35 +0100
From:   =?unknown-8bit?B?SGVydsOp?= Boisse <admin@netgeek.ovh>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, admin@netgeek.ovh,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net/af_packet: fix tx skb network header on
 SOCK_RAW sockets over VLAN device
Message-ID: <Y8Am5wAxC48N12PE@quaddy.sgn>
References: <20230110191725.22675-1-admin@netgeek.ovh>
 <20230110191725.22675-2-admin@netgeek.ovh>
 <fa5895ae62e0f9c1eb8f662295ca920d1da7e88f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa5895ae62e0f9c1eb8f662295ca920d1da7e88f.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello,

On Thu, Jan 12, 2023 at 01:48:51PM +0100, Paolo Abeni wrote:
> I'm unsure I read correctly the use case: teh user-space application is
> providing an L2 header and is expecting the Linux stack to add a vlan
> tag? Or the linux application is sending packets on top of a vlan
> device and desire no tag on the egress packet? or something else?

The userland app does not care about the device being a VLAN one or not. Just a regular Ethernet device on which to send raw frames.
This means the app provides a standard 14 byte Ethernet header on the socket and does not matter about any VLAN tag.

Then, the goal is to be able to alter those packets at the qdisc level with tc filters.
But, when such packets are sent on top of a VLAN device whose real device does not support VLAN tx offloading, the bad position of the skb network header makes this task impossible.

To give a concrete example, here are few commands to show the problem easily:

# modprobe dummy
# ip link add link dummy0 dummy0.832 type vlan id 832
# tc qdisc replace dev dummy0.832 root handle 1: prio
# tc filter del dev dummy0.832
# tc filter add dev dummy0.832 parent 1: prio 1 protocol ip u32 match u8 0 0 action pedit pedit munge ip tos set 0xc0
# ip link set dummy0 up
# ip link set dummy0.832 up

Then start an application that uses AF_PACKET+SOCK_RAW sockets over the VLAN device:

# dhclient -v dummy0.832

If you look at the emitted packets on dummy0, you will see that the 0xc0 byte of the IPv4 TOS/DSCP field is not set.
Instead, the 0xc0 tos byte is written 4 bytes too far, in the last byte of the IPv4 Identification field.


Hervé

