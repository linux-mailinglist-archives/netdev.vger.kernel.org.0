Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47912F8D03
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 11:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbhAPKqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 05:46:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725979AbhAPKp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 05:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610793871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tNOciZF/XtlQMzlzttmcPN56lbsPPPGp9MQouxHwNhw=;
        b=ZNqfpUHb/OoMe9F3gob5Y1GaGB6RJvR5ROaA3goDzTTvcZDonbPMC4nDQtY20OEm668hpu
        UBwaWV2Xs6e+yhOHCU5rvX/mtZ6u6bKVg5MOXukn7GfMEvrkLD5WJ9m+8H7ng1knPU5kha
        +BZpvqs/6R8VGSn5OtW00AeRF9LxGk4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-fLLbFuyZNUSzbS_Rp3EAvg-1; Sat, 16 Jan 2021 05:44:26 -0500
X-MC-Unique: fLLbFuyZNUSzbS_Rp3EAvg-1
Received: by mail-wr1-f71.google.com with SMTP id e12so5440100wrp.10
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 02:44:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tNOciZF/XtlQMzlzttmcPN56lbsPPPGp9MQouxHwNhw=;
        b=bLmwiLsc81UmWzofVJeS34Xnio34wB6JQ6Nu2DIGIESzL3gKl8WOPeo821dGuLUvNs
         QAlYw13+C1gmJdDeeLrLTGBk1tRZucLTV9yRgNuE9/awbvDLB3ODaiyfrwXzrozqoEd0
         ylgt3/m+ok+e9vw0CVrvts0BnHliqzY1lSmvh6QytiSivyM9WUqT1XgIdxtac6gyHBcp
         Q9uN9pV5OaOXTH08tO5CIpWgDHM15vuZ+DVs7QOTJ4oICDxz3a19oTemSmXfjp0IEFqy
         lMXsst4zVQcZrIbUn5p9UJhDurxecGBPfHehlr5vSX/zFl21iKSJEDsYVwRS2TSvAJOp
         VsZA==
X-Gm-Message-State: AOAM532kr5W5AAZ8NLVr2blolFBeQSBMlfgfumshX5EFRXNKMrPbUnz6
        iSPbneypVIwX9XqmYTBjpFo+aRz7FVMBdZ6gVqEDTAIbHPG/mIlccFwNbpgEhisD2WlmQGhORgM
        2uY7niLq0612G8AoH
X-Received: by 2002:a5d:4ece:: with SMTP id s14mr17108155wrv.427.1610793865580;
        Sat, 16 Jan 2021 02:44:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFLGc/Y5dSgAsKf067j9zGaLw3HwHfYgoZ/IpMGoKsyeAlWexMDj/wJ7036NNKQCQcucFguQ==
X-Received: by 2002:a5d:4ece:: with SMTP id s14mr17108142wrv.427.1610793865440;
        Sat, 16 Jan 2021 02:44:25 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id y13sm19062577wrl.63.2021.01.16.02.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 02:44:24 -0800 (PST)
Date:   Sat, 16 Jan 2021 11:44:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net 1/2] udp: mask TOS bits in udp_v4_early_demux()
Message-ID: <34f99dc0d1d339a3ee7caa40597ebc8313e4774d.1610790904.git.gnault@redhat.com>
References: <cover.1610790904.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1610790904.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udp_v4_early_demux() is the only function that calls
ip_mc_validate_source() with a TOS that hasn't been masked with
IPTOS_RT_MASK.

This results in different behaviours for incoming multicast UDPv4
packets, depending on if ip_mc_validate_source() is called from the
early-demux path (udp_v4_early_demux) or from the regular input path
(ip_route_input_noref).

ECN would normally not be used with UDP multicast packets, so the
practical consequences should be limited on that side. However,
IPTOS_RT_MASK is used to also masks the TOS' high order bits, to align
with the non-early-demux path behaviour.

Reproducer:

  Setup two netns, connected with veth:
  $ ip netns add ns0
  $ ip netns add ns1
  $ ip -netns ns0 link set dev lo up
  $ ip -netns ns1 link set dev lo up
  $ ip link add name veth01 netns ns0 type veth peer name veth10 netns ns1
  $ ip -netns ns0 link set dev veth01 up
  $ ip -netns ns1 link set dev veth10 up
  $ ip -netns ns0 address add 192.0.2.10 peer 192.0.2.11/32 dev veth01
  $ ip -netns ns1 address add 192.0.2.11 peer 192.0.2.10/32 dev veth10

  In ns0, add route to multicast address 224.0.2.0/24 using source
  address 198.51.100.10:
  $ ip -netns ns0 address add 198.51.100.10/32 dev lo
  $ ip -netns ns0 route add 224.0.2.0/24 dev veth01 src 198.51.100.10

  In ns1, define route to 198.51.100.10, only for packets with TOS 4:
  $ ip -netns ns1 route add 198.51.100.10/32 tos 4 dev veth10

  Also activate rp_filter in ns1, so that incoming packets not matching
  the above route get dropped:
  $ ip netns exec ns1 sysctl -wq net.ipv4.conf.veth10.rp_filter=1

  Now try to receive packets on 224.0.2.11:
  $ ip netns exec ns1 socat UDP-RECVFROM:1111,ip-add-membership=224.0.2.11:veth10,ignoreeof -

  In ns0, send packet to 224.0.2.11 with TOS 4 and ECT(0) (that is,
  tos 6 for socat):
  $ echo test0 | ip netns exec ns0 socat - UDP-DATAGRAM:224.0.2.11:1111,bind=:1111,tos=6

  The "test0" message is properly received by socat in ns1, because
  early-demux has no cached dst to use, so source address validation
  is done by ip_route_input_mc(), which receives a TOS that has the
  ECN bits masked.

  Now send another packet to 224.0.2.11, still with TOS 4 and ECT(0):
  $ echo test1 | ip netns exec ns0 socat - UDP-DATAGRAM:224.0.2.11:1111,bind=:1111,tos=6

  The "test1" message isn't received by socat in ns1, because, now,
  early-demux has a cached dst to use and calls ip_mc_validate_source()
  immediately, without masking the ECN bits.

Fixes: bc044e8db796 ("udp: perform source validation for mcast early demux")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/udp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7103b0a89756..69ea76578abb 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2555,7 +2555,8 @@ int udp_v4_early_demux(struct sk_buff *skb)
 		 */
 		if (!inet_sk(sk)->inet_daddr && in_dev)
 			return ip_mc_validate_source(skb, iph->daddr,
-						     iph->saddr, iph->tos,
+						     iph->saddr,
+						     iph->tos & IPTOS_RT_MASK,
 						     skb->dev, in_dev, &itag);
 	}
 	return 0;
-- 
2.21.3

