Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84042AA7C5
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgKGTqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGTqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 14:46:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F385F2087E;
        Sat,  7 Nov 2020 19:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604778414;
        bh=GSYj0T3ZU5qbZhDmav8Cwd53QSbWb+ZEycZBHD4VXUA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Oy+JIVHBEfgdzjJTDJMriNInWU7lkc8WLgbEd7DwN12c0/PgwPdMccscYSpWvPg8b
         p9ALOSDA72dsUfe1z669v7PxJ5wqZydMQmGa2+ewSVt2sB4q6J6feSZv6laYu7vQW/
         +BGgvITFY61x6th1FdOxehnbhvD2SlIkrL4MWu9k=
Date:   Sat, 7 Nov 2020 11:46:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yi-Hung Wei <yihung.wei@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] openvswitch: Fix upcall
 OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS
Message-ID: <20201107114653.5cec9929@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604448694-19351-1-git-send-email-yihung.wei@gmail.com>
References: <1604448694-19351-1-git-send-email-yihung.wei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 16:11:34 -0800 Yi-Hung Wei wrote:
> TUNNEL_GENEVE_OPT is set on tun_flags in struct sw_flow_key when
> a packet is coming from a geneve tunnel no matter the size of geneve
> option is zero or not.  On the other hand, TUNNEL_VXLAN_OPT or
> TUNNEL_ERSPAN_OPT is set when the VXLAN or ERSPAN option is available.
> Currently, ovs kernel module only generates
> OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS when the tun_opts_len is non-zero.
> As a result, for a geneve packet without tun_metadata, when the packet
> is reinserted from userspace after upcall, we miss the TUNNEL_GENEVE_OPT
> in the tun_flags on struct sw_flow_key, and that will further cause
> megaflow matching issue.
> 
> This patch changes the way that we deal with the upcall netlink message
> generation to make sure the geneve tun_flags is set consistently
> as the packet is firstly received from the geneve tunnel in order to
> avoid megaflow matching issue demonstrated by the following flows.
> This issue is only observed on ovs kernel datapath.
> 
> Consider the following two flows, and the two cases.
> * flow1: icmp traffic from gnv0 to gnv1, without any tun_metadata
> * flow2: icmp traffic form gnv0 to gnv1 with tun_metadata0
> 
> Case 1)
> Send flow2 first, and then send flow1.  When both flows are running,
> both the following two flows are hit, which is expected.
> 
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x1/0xff action=output:gnv1
> 
> Case 2)
> Send flow1 first, then send flow2.  When both flows are running,
> only the following flow is hit.
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> 
> Example flows)
> 
> table=0, arp, actions=NORMAL
> table=0, in_port=gnv1, icmp, action=ct(table=1)
> table=0, in_port=gnv0, icmp  action=move:NXM_NX_TUN_METADATA0[0..7]->NXM_NX_REG9[0..7], resubmit(,1)
> table=1, in_port=gnv1, icmp, action=output:gnv0
> table=1, in_port=gnv0, icmp  action=ct(table=2)
> table=2, priority=300, in_port=gnv0, icmp, ct_state=+trk+new, action=ct(commit),output:gnv1
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
> table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x1/0xff action=output:gnv1
> 
> Fixes: fc4099f17240 ("openvswitch: Fix egress tunnel info.")
> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>

Wouldn't it make more sense to make GENEVE behave like the other
tunnels rather than hack this logic into consumer of the flag?

Please make sure that you CC authors of the patch you're fixing 
and the maintainers of the code you're changing.

./scripts/get_maintainer.pl is your friend.
