Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138292309D9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgG1MU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbgG1MU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:20:57 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E70C061794;
        Tue, 28 Jul 2020 05:20:54 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so18104990wrw.1;
        Tue, 28 Jul 2020 05:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tGckZViZqITBAI3FDO/Tnn1YZuHd5jwWQSY9Uj6T4mQ=;
        b=C+HG3I3feTxibI/VstyFEzM9n687g46g7iSi7eN5cUcuMD+2sBqsTOllUtB7PKngaZ
         nhFtFyDF6TloVcPFiLFQ8bvSSN1k8p9DrMEnt1oE1lyoKTYrmCVYmtf6HrrtVja5ln0t
         zzCnh9bzOXP5vv2oj2Y3523FCniSTHhA5S/GxKOETKSmn4sUS3Y3KxO5pMR5Kp/QT9rj
         +pWXgy35suxKetcSLZyuqLD0z0x5EVHbKYOmwnPzY79HK8blTyU+FQTgDLl1U3tBBzKw
         RMVBaJu7DF+9tNjAbQZf5NvzOIp7XeT1tGdPYM7art+Re6t1WW1eyb2uVSXtrJ3jIifl
         ZNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tGckZViZqITBAI3FDO/Tnn1YZuHd5jwWQSY9Uj6T4mQ=;
        b=qeKRhqruW3f0v9Z/OxEJHnEFs56ePMPcyBLm+3kkPrJohD38NL/5Hl0tDYhvzJ0xrA
         edW41Vlb4CIZECJXmfyF5IpUFbqskrH3GMvuNJox2Ml7oMvGrKhpQXvQDApOPDFOr7lj
         PpxviUayeA32k48Pd1rDJyVTTqHmBPKITOrNcHrAuJazyIKZF05wlR3UByP6GFsp06Xr
         2v4gyPhb3ZcrNNhejJpFB5bFeDLvEvn1NwnOo484ITdbR+Ofmc7BJ3DdMfE+YR+CRIjj
         hj+f4DGEUMDaf7psBGer/KFnnn3kRyq321eAvQRB7JmeXv5usB88J8eAEjYIg3CxjKSK
         M4tA==
X-Gm-Message-State: AOAM532SaX8HoAVCtOrz+slifuRnusjvTHfSlCYjBoj9TVwyMcTcTnFh
        8j686SufT4V2gES9ZeRjcsM=
X-Google-Smtp-Source: ABdhPJxoQOXWN1PiAi1gcZFqlLd3qbBzOJ2zch5QKJat1ZFDxbzmX3puX4rxb/iXc3VnmQn6IHcjkg==
X-Received: by 2002:a5d:6452:: with SMTP id d18mr24371165wrw.284.1595938853447;
        Tue, 28 Jul 2020 05:20:53 -0700 (PDT)
Received: from ubuntu18_1.cisco.com ([173.38.220.51])
        by smtp.gmail.com with ESMTPSA id 65sm19279463wre.6.2020.07.28.05.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:20:52 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrea.mayer@uniroma2.it, Ahmed Abdelsalam <ahabdels@gmail.com>
Subject: [net-next] seg6: using DSCP of inner IPv4 packets
Date:   Tue, 28 Jul 2020 12:20:44 +0000
Message-Id: <20200728122044.1900-1-ahabdels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows copying the DSCP from inner IPv4 header to the
outer IPv6 header, when doing SRv6 Encapsulation.

This allows forwarding packet across the SRv6 fabric based on their
original traffic class.

Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
---
 net/ipv6/seg6_iptunnel.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index e0e9f48ab14f..9753d10c4a51 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -110,6 +110,7 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	struct dst_entry *dst = skb_dst(skb);
 	struct net *net = dev_net(dst->dev);
 	struct ipv6hdr *hdr, *inner_hdr;
+	struct iphdr *inner_ipv4_hdr;
 	struct ipv6_sr_hdr *isrh;
 	int hdrlen, tot_len, err;
 	__be32 flowlabel;
@@ -121,7 +122,11 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	if (unlikely(err))
 		return err;
 
-	inner_hdr = ipv6_hdr(skb);
+	if (skb->protocol == htons(ETH_P_IPV6))
+		inner_hdr = ipv6_hdr(skb);
+	else
+		inner_ipv4_hdr = ip_hdr(skb);
+
 	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr);
 
 	skb_push(skb, tot_len);
@@ -138,6 +143,10 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
 			     flowlabel);
 		hdr->hop_limit = inner_hdr->hop_limit;
+	} else if (skb->protocol == htons(ETH_P_IP)) {
+		ip6_flow_hdr(hdr, inner_ipv4_hdr->tos, flowlabel);
+		hdr->hop_limit = inner_ipv4_hdr->ttl;
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	} else {
 		ip6_flow_hdr(hdr, 0, flowlabel);
 		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
-- 
2.17.1

