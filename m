Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F1442A8FB
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237589AbhJLQAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237494AbhJLQAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED65461105;
        Tue, 12 Oct 2021 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054330;
        bh=ML3+Wt+Gyf2AnH9iMdE3LcG4Csto5f7/O0LmMmz7iRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vxq4ZOWqZRaDdNoiE+sWuMw4GiSD9N1OvIPb85PwVcDWEX2TcAqImmh99TTfXF1L0
         Mx2gu3txIJWvuHrHTrpBM/F9z5yjV7Kl2DXbCdyte8y4F6PZ8GCo9Z+JOX199Ln8Nm
         kf0yyUwzV39e0e8EB8bXHrNDhgjevpC4fnCH9uMJCS+F0yuRFNnXVqVDSv+RvAYXRV
         AzU4G5M6DhQMduxHSSlfePWlmKYeAZWO/GjE18DMkS08NCU90h/Nb15XlJ5/phJ/Uj
         LG8L17FaHjMJO0nBUAwRJ8APVxSX3JT7lT2otEi8lnzcROxFZGOqtd/Y+C+4fnCvNH
         kiVNBdtu4ByPw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ralf@linux-mips.org, jreuter@yaina.de,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, linux-hams@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/6] ipv6: constify dev_addr passing
Date:   Tue, 12 Oct 2021 08:58:38 -0700
Message-Id: <20211012155840.4151590-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012155840.4151590-1-kuba@kernel.org>
References: <20211012155840.4151590-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for netdev->dev_addr being constant
make all relevant arguments in ndisc constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/ndisc.h | 2 +-
 net/ipv6/addrconf.c | 4 ++--
 net/ipv6/ndisc.c    | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 38e4094960ce..04341d86585d 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -137,7 +137,7 @@ struct ndisc_options *ndisc_parse_options(const struct net_device *dev,
 					  u8 *opt, int opt_len,
 					  struct ndisc_options *ndopts);
 
-void __ndisc_fill_addr_option(struct sk_buff *skb, int type, void *data,
+void __ndisc_fill_addr_option(struct sk_buff *skb, int type, const void *data,
 			      int data_len, int pad);
 
 #define NDISC_OPS_REDIRECT_DATA_SPACE	2
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c6a90b7bbb70..d4fae16deec4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2237,12 +2237,12 @@ static int addrconf_ifid_6lowpan(u8 *eui, struct net_device *dev)
 
 static int addrconf_ifid_ieee1394(u8 *eui, struct net_device *dev)
 {
-	union fwnet_hwaddr *ha;
+	const union fwnet_hwaddr *ha;
 
 	if (dev->addr_len != FWNET_ALEN)
 		return -1;
 
-	ha = (union fwnet_hwaddr *)dev->dev_addr;
+	ha = (const union fwnet_hwaddr *)dev->dev_addr;
 
 	memcpy(eui, &ha->uc.uniq_id, sizeof(ha->uc.uniq_id));
 	eui[0] ^= 2;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 4b098521a44c..184190b9ea25 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -142,7 +142,7 @@ struct neigh_table nd_tbl = {
 };
 EXPORT_SYMBOL_GPL(nd_tbl);
 
-void __ndisc_fill_addr_option(struct sk_buff *skb, int type, void *data,
+void __ndisc_fill_addr_option(struct sk_buff *skb, int type, const void *data,
 			      int data_len, int pad)
 {
 	int space = __ndisc_opt_addr_space(data_len, pad);
@@ -165,7 +165,7 @@ void __ndisc_fill_addr_option(struct sk_buff *skb, int type, void *data,
 EXPORT_SYMBOL_GPL(__ndisc_fill_addr_option);
 
 static inline void ndisc_fill_addr_option(struct sk_buff *skb, int type,
-					  void *data, u8 icmp6_type)
+					  const void *data, u8 icmp6_type)
 {
 	__ndisc_fill_addr_option(skb, type, data, skb->dev->addr_len,
 				 ndisc_addr_option_pad(skb->dev->type));
-- 
2.31.1

