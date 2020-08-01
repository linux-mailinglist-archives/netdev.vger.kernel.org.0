Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B886234F55
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 03:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHABu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 21:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHABu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 21:50:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBEEC06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 18:50:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA4F311E58FB8;
        Fri, 31 Jul 2020 18:34:11 -0700 (PDT)
Date:   Fri, 31 Jul 2020 18:49:45 -0700 (PDT)
Message-Id: <20200731.184945.122924084405339233.davem@davemloft.net>
To:     roopa@cumulusnetworks.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next v2] rtnetlink: add support for protodown reason
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596242041-14347-1-git-send-email-roopa@cumulusnetworks.com>
References: <1596242041-14347-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Jul 2020 18:34:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>
Date: Fri, 31 Jul 2020 17:34:01 -0700

> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> netdev protodown is a mechanism that allows protocols to
> hold an interface down. It was initially introduced in
> the kernel to hold links down by a multihoming protocol.
> There was also an attempt to introduce protodown
> reason at the time but was rejected. protodown and protodown reason
> is supported by almost every switching and routing platform.
> It was ok for a while to live without a protodown reason.
> But, its become more critical now given more than
> one protocol may need to keep a link down on a system
> at the same time. eg: vrrp peer node, port security,
> multihoming protocol. Its common for Network operators and
> protocol developers to look for such a reason on a networking
> box (Its also known as errDisable by most networking operators)
> 
> This patch adds support for link protodown reason
> attribute. There are two ways to maintain protodown
> reasons.
> (a) enumerate every possible reason code in kernel
>     - A protocol developer has to make a request and
>       have that appear in a certain kernel version
> (b) provide the bits in the kernel, and allow user-space
> (sysadmin or NOS distributions) to manage the bit-to-reasonname
> map.
> 	- This makes extending reason codes easier (kind of like
>       the iproute2 table to vrf-name map /etc/iproute2/rt_tables.d/)
> 
> This patch takes approach (b).
> 
> a few things about the patch:
> - It treats the protodown reason bits as counter to indicate
> active protodown users
> - Since protodown attribute is already an exposed UAPI,
> the reason is not enforced on a protodown set. Its a no-op
> if not used.
> the patch follows the below algorithm:
>   - presence of reason bits set indicates protodown
>     is in use
>   - user can set protodown and protodown reason in a
>     single or multiple setlink operations
>   - setlink operation to clear protodown, will return -EBUSY
>     if there are active protodown reason bits
>   - reason is not included in link dumps if not used
> 
> example with patched iproute2:
> $cat /etc/iproute2/protodown_reasons.d/r.conf
> 0 mlag
> 1 evpn
> 2 vrrp
> 3 psecurity
> 
> $ip link set dev vxlan0 protodown on protodown_reason vrrp on
> $ip link set dev vxlan0 protodown_reason mlag on
> $ip link show
> 14: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
> DEFAULT group default qlen 1000
>     link/ether f6:06:be:17:91:e7 brd ff:ff:ff:ff:ff:ff protodown on <mlag,vrrp>
> 
> $ip link set dev vxlan0 protodown_reason mlag off
> $ip link set dev vxlan0 protodown off protodown_reason vrrp off
> 
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
> v2 - remove unnecessary helper dev_get_proto_down_reason
>      - move dev->proto_down_reason to use an existing hole in struct net_device

Applied, thank you.
