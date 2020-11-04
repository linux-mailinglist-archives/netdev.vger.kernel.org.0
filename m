Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F8C2A5AE8
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 01:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbgKDALl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 19:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729866AbgKDALl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 19:11:41 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4332AC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 16:11:41 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id g11so2886672pll.13
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 16:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=M5dyxk00EUi5nsJLqKIv0ilpqpkj+h/iOALw2hVQx/c=;
        b=odMhejInl2vZemN55IFmT9BZF4xy64J5yjW6ZRFrWHm14avhBLHAcZzsntWdUb1Ncq
         vSk78wj27mG9gVxx7pNYrC/4zNxclli01U454mwd0T/0kdf1FK5c2PsvMFggiDj78qqt
         jbMAhV8xlZZ2vCdjrffhRUqb+sKgnfbUoUt7bcKjzqUiHsyPaNwrgS51mYI/F3lSMq3J
         EuYnRLSGifFGF12dg6u3ti2+BgEHOamQgXopT2a8h10O/f2WnB44NAbqf14W3T5428rx
         7UNY5hmVaJtb7INXxhcw6ImeFYzL0DsaZScVHecrux+Fzs5ol9NiQxdRoHgD3O0pibaz
         A93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=M5dyxk00EUi5nsJLqKIv0ilpqpkj+h/iOALw2hVQx/c=;
        b=UctFaC9rGy46bUrV1e2qrbG/4UGZ2ckfnO5EFaszW93DUKPKAKwE3NXZP1A0U9UVXx
         4MzA5x7LS45z3o5rvT71KRPQYyvjt5wtKo0Ax8iGYGx5bHuQJaEuCNfUuPIcGmW173gd
         e+nZ7TbNHOQHpQSgFWfdsUoIYw62Ru0Ux9k5RNzs5DAGzLV01O1ARZpF0u6JdHvXd1Fo
         3FSm4qPZKQ7d/b8WCbshgEdNPyB/HCwGp7RxhaSoJQewljlFNLzAumoNIIzPANUeQZ6N
         Y0aSsa3N1s5/lCV7RD+54JdUcTvs21IUNB/SpZhxptY3r+bOb+4s+93s5eKworfc+qFZ
         rNmA==
X-Gm-Message-State: AOAM531I2otyL/L9aXE/00LEuORRZAVFcGqY4NpQgNIH3aSHKr5VOmZh
        pLgqzPCN2TRVy81D8YzcKz0UVJ+PUZY=
X-Google-Smtp-Source: ABdhPJwAeyDYXSFeWF0000mav+wuU0ifWICzX1SbNqy1sZ4sQdjUBSxjGE5H2JxBwXvmGdrb2Rnd1Q==
X-Received: by 2002:a17:902:eb14:b029:d6:5a66:aa31 with SMTP id l20-20020a170902eb14b02900d65a66aa31mr25755803plb.53.1604448700552;
        Tue, 03 Nov 2020 16:11:40 -0800 (PST)
Received: from vm-main.eng.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id u4sm128054pga.36.2020.11.03.16.11.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2020 16:11:40 -0800 (PST)
From:   Yi-Hung Wei <yihung.wei@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH net] openvswitch: Fix upcall OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS
Date:   Tue,  3 Nov 2020 16:11:34 -0800
Message-Id: <1604448694-19351-1-git-send-email-yihung.wei@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TUNNEL_GENEVE_OPT is set on tun_flags in struct sw_flow_key when
a packet is coming from a geneve tunnel no matter the size of geneve
option is zero or not.  On the other hand, TUNNEL_VXLAN_OPT or
TUNNEL_ERSPAN_OPT is set when the VXLAN or ERSPAN option is available.
Currently, ovs kernel module only generates
OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS when the tun_opts_len is non-zero.
As a result, for a geneve packet without tun_metadata, when the packet
is reinserted from userspace after upcall, we miss the TUNNEL_GENEVE_OPT
in the tun_flags on struct sw_flow_key, and that will further cause
megaflow matching issue.

This patch changes the way that we deal with the upcall netlink message
generation to make sure the geneve tun_flags is set consistently
as the packet is firstly received from the geneve tunnel in order to
avoid megaflow matching issue demonstrated by the following flows.
This issue is only observed on ovs kernel datapath.

Consider the following two flows, and the two cases.
* flow1: icmp traffic from gnv0 to gnv1, without any tun_metadata
* flow2: icmp traffic form gnv0 to gnv1 with tun_metadata0

Case 1)
Send flow2 first, and then send flow1.  When both flows are running,
both the following two flows are hit, which is expected.

table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x1/0xff action=output:gnv1

Case 2)
Send flow1 first, then send flow2.  When both flows are running,
only the following flow is hit.
table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1

Example flows)

table=0, arp, actions=NORMAL
table=0, in_port=gnv1, icmp, action=ct(table=1)
table=0, in_port=gnv0, icmp  action=move:NXM_NX_TUN_METADATA0[0..7]->NXM_NX_REG9[0..7], resubmit(,1)
table=1, in_port=gnv1, icmp, action=output:gnv0
table=1, in_port=gnv0, icmp  action=ct(table=2)
table=2, priority=300, in_port=gnv0, icmp, ct_state=+trk+new, action=ct(commit),output:gnv1
table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x0/0xff action=output:gnv1
table=2, priority=200, in_port=gnv0, icmp, ct_state=+trk+est, reg9=0x1/0xff action=output:gnv1

Fixes: fc4099f17240 ("openvswitch: Fix egress tunnel info.")
Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
---
 net/openvswitch/flow_netlink.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 9d3e50c4d29f..b03ec6a1a1fa 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -912,13 +912,13 @@ static int __ip_tun_to_nlattr(struct sk_buff *skb,
 	if ((output->tun_flags & TUNNEL_OAM) &&
 	    nla_put_flag(skb, OVS_TUNNEL_KEY_ATTR_OAM))
 		return -EMSGSIZE;
-	if (swkey_tun_opts_len) {
-		if (output->tun_flags & TUNNEL_GENEVE_OPT &&
-		    nla_put(skb, OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS,
+	if (output->tun_flags & TUNNEL_GENEVE_OPT) {
+		if (nla_put(skb, OVS_TUNNEL_KEY_ATTR_GENEVE_OPTS,
 			    swkey_tun_opts_len, tun_opts))
 			return -EMSGSIZE;
-		else if (output->tun_flags & TUNNEL_VXLAN_OPT &&
-			 vxlan_opt_to_nlattr(skb, tun_opts, swkey_tun_opts_len))
+	} else if (swkey_tun_opts_len) {
+		if (output->tun_flags & TUNNEL_VXLAN_OPT &&
+		    vxlan_opt_to_nlattr(skb, tun_opts, swkey_tun_opts_len))
 			return -EMSGSIZE;
 		else if (output->tun_flags & TUNNEL_ERSPAN_OPT &&
 			 nla_put(skb, OVS_TUNNEL_KEY_ATTR_ERSPAN_OPTS,
-- 
2.7.4

