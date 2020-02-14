Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6D515DA2F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgBNPDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:35 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50068 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729548AbgBNPDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:33 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF0pSf019341;
        Fri, 14 Feb 2020 07:03:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Gk5LjXR2PMuA7pGrx1T6Vou8+AMg86nBlWs5ojnG0T4=;
 b=iPqICOOVWViLEo3ZeEl9V13E2u2Gwopy61B5gsOvY3M9dzK3DH19SmBTOROf4XfGVOCv
 WixqZieldigf7fEuFVL1YEqi8s+/6RzV9MqPl3gmZZ++SYbW287NnL5FDom/ZLO5GTzy
 txFi/XDZMZ5UMtmEn9EqVUZfIbLKZapk7koozmmMZDt7b8oKcKTBrcuj0rl+41nrgkTy
 tUxt+pE51BY/CenzDrnmqleXMy6Q/cjQLGIvTRFsDcmcmISUJP82PKYtwS6L3jmCh90x
 mtGp5OUG3+Ufkw2TZq2aV9Ru6hIfPaInxaizt9kLqpIgU5hj2oFpmTzqHMvHLiw310uS YQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2n5mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:30 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:27 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:27 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id E693B3F7045;
        Fri, 14 Feb 2020 07:03:25 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 09/18] net: macsec: add support for getting offloaded stats
Date:   Fri, 14 Feb 2020 18:02:49 +0300
Message-ID: <20200214150258.390-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

report sw stats only if offloaded stats are not supported

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 331 +++++++++++++++++++++++++++++--------------
 include/net/macsec.h |  24 ++++
 2 files changed, 250 insertions(+), 105 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 01da47b47f64..0ee647238996 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -76,17 +76,6 @@ struct gcm_iv {
 	__be32 pn;
 };
 
-struct macsec_dev_stats {
-	__u64 OutPktsUntagged;
-	__u64 InPktsUntagged;
-	__u64 OutPktsTooLong;
-	__u64 InPktsNoTag;
-	__u64 InPktsBadTag;
-	__u64 InPktsUnknownSCI;
-	__u64 InPktsNoSCI;
-	__u64 InPktsOverrun;
-};
-
 #define MACSEC_VALIDATE_DEFAULT MACSEC_VALIDATE_STRICT
 
 struct pcpu_secy_stats {
@@ -2494,207 +2483,324 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static int copy_tx_sa_stats(struct sk_buff *skb,
-			    struct macsec_tx_sa_stats __percpu *pstats)
+static void get_tx_sa_stats(struct net_device *dev, int an,
+			    struct macsec_tx_sa *tx_sa,
+			    struct macsec_tx_sa_stats *sum)
 {
-	struct macsec_tx_sa_stats sum = {0, };
+	struct macsec_dev *macsec = macsec_priv(dev);
+	int err = -EOPNOTSUPP;
 	int cpu;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops) {
+			ctx.sa.assoc_num = an;
+			ctx.sa.tx_sa = tx_sa;
+			ctx.stats.tx_sa_stats = sum;
+			ctx.secy = &macsec_priv(dev)->secy;
+			err = macsec_offload(ops->mdo_get_tx_sa_stats, &ctx);
+		}
+	}
+
+	if (err != -EOPNOTSUPP)
+		return;
+
 	for_each_possible_cpu(cpu) {
-		const struct macsec_tx_sa_stats *stats = per_cpu_ptr(pstats, cpu);
+		const struct macsec_tx_sa_stats *stats =
+			per_cpu_ptr(tx_sa->stats, cpu);
 
-		sum.OutPktsProtected += stats->OutPktsProtected;
-		sum.OutPktsEncrypted += stats->OutPktsEncrypted;
+		sum->OutPktsProtected += stats->OutPktsProtected;
+		sum->OutPktsEncrypted += stats->OutPktsEncrypted;
 	}
+}
 
-	if (nla_put_u32(skb, MACSEC_SA_STATS_ATTR_OUT_PKTS_PROTECTED, sum.OutPktsProtected) ||
-	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_OUT_PKTS_ENCRYPTED, sum.OutPktsEncrypted))
+static int copy_tx_sa_stats(struct sk_buff *skb, struct macsec_tx_sa_stats *sum)
+{
+	if (nla_put_u32(skb, MACSEC_SA_STATS_ATTR_OUT_PKTS_PROTECTED,
+			sum->OutPktsProtected) ||
+	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_OUT_PKTS_ENCRYPTED,
+			sum->OutPktsEncrypted))
 		return -EMSGSIZE;
 
 	return 0;
 }
 
-static noinline_for_stack int
-copy_rx_sa_stats(struct sk_buff *skb,
-		 struct macsec_rx_sa_stats __percpu *pstats)
+static void get_rx_sa_stats(struct net_device *dev,
+			    struct macsec_rx_sc *rx_sc, int an,
+			    struct macsec_rx_sa *rx_sa,
+			    struct macsec_rx_sa_stats *sum)
 {
-	struct macsec_rx_sa_stats sum = {0, };
+	struct macsec_dev *macsec = macsec_priv(dev);
+	int err = -EOPNOTSUPP;
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		const struct macsec_rx_sa_stats *stats = per_cpu_ptr(pstats, cpu);
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops) {
+			ctx.sa.assoc_num = an;
+			ctx.sa.rx_sa = rx_sa;
+			ctx.stats.rx_sa_stats = sum;
+			ctx.secy = &macsec_priv(dev)->secy;
+			ctx.rx_sc = rx_sc;
+			err = macsec_offload(ops->mdo_get_rx_sa_stats, &ctx);
+		}
+	}
 
-		sum.InPktsOK         += stats->InPktsOK;
-		sum.InPktsInvalid    += stats->InPktsInvalid;
-		sum.InPktsNotValid   += stats->InPktsNotValid;
-		sum.InPktsNotUsingSA += stats->InPktsNotUsingSA;
-		sum.InPktsUnusedSA   += stats->InPktsUnusedSA;
+	if (err != -EOPNOTSUPP)
+		return;
+
+	for_each_possible_cpu(cpu) {
+		const struct macsec_rx_sa_stats *stats =
+			per_cpu_ptr(rx_sa->stats, cpu);
+
+		sum->InPktsOK         += stats->InPktsOK;
+		sum->InPktsInvalid    += stats->InPktsInvalid;
+		sum->InPktsNotValid   += stats->InPktsNotValid;
+		sum->InPktsNotUsingSA += stats->InPktsNotUsingSA;
+		sum->InPktsUnusedSA   += stats->InPktsUnusedSA;
 	}
+}
 
-	if (nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_OK, sum.InPktsOK) ||
-	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_INVALID, sum.InPktsInvalid) ||
-	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_NOT_VALID, sum.InPktsNotValid) ||
-	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_NOT_USING_SA, sum.InPktsNotUsingSA) ||
-	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_UNUSED_SA, sum.InPktsUnusedSA))
+static int copy_rx_sa_stats(struct sk_buff *skb,
+			    struct macsec_rx_sa_stats *sum)
+{
+	if (nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_OK, sum->InPktsOK) ||
+	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_INVALID,
+			sum->InPktsInvalid) ||
+	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_NOT_VALID,
+			sum->InPktsNotValid) ||
+	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_NOT_USING_SA,
+			sum->InPktsNotUsingSA) ||
+	    nla_put_u32(skb, MACSEC_SA_STATS_ATTR_IN_PKTS_UNUSED_SA,
+			sum->InPktsUnusedSA))
 		return -EMSGSIZE;
 
 	return 0;
 }
 
-static noinline_for_stack int
-copy_rx_sc_stats(struct sk_buff *skb, struct pcpu_rx_sc_stats __percpu *pstats)
+static void get_rx_sc_stats(struct net_device *dev,
+			    struct macsec_rx_sc *rx_sc,
+			    struct macsec_rx_sc_stats *sum)
 {
-	struct macsec_rx_sc_stats sum = {0, };
+	struct macsec_dev *macsec = macsec_priv(dev);
+	int err = -EOPNOTSUPP;
 	int cpu;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops) {
+			ctx.stats.rx_sc_stats = sum;
+			ctx.secy = &macsec_priv(dev)->secy;
+			ctx.rx_sc = rx_sc;
+			err = macsec_offload(ops->mdo_get_rx_sc_stats, &ctx);
+		}
+	}
+
+	if (err != -EOPNOTSUPP)
+		return;
+
 	for_each_possible_cpu(cpu) {
 		const struct pcpu_rx_sc_stats *stats;
 		struct macsec_rx_sc_stats tmp;
 		unsigned int start;
 
-		stats = per_cpu_ptr(pstats, cpu);
+		stats = per_cpu_ptr(rx_sc->stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
-		sum.InOctetsValidated += tmp.InOctetsValidated;
-		sum.InOctetsDecrypted += tmp.InOctetsDecrypted;
-		sum.InPktsUnchecked   += tmp.InPktsUnchecked;
-		sum.InPktsDelayed     += tmp.InPktsDelayed;
-		sum.InPktsOK          += tmp.InPktsOK;
-		sum.InPktsInvalid     += tmp.InPktsInvalid;
-		sum.InPktsLate        += tmp.InPktsLate;
-		sum.InPktsNotValid    += tmp.InPktsNotValid;
-		sum.InPktsNotUsingSA  += tmp.InPktsNotUsingSA;
-		sum.InPktsUnusedSA    += tmp.InPktsUnusedSA;
+		sum->InOctetsValidated += tmp.InOctetsValidated;
+		sum->InOctetsDecrypted += tmp.InOctetsDecrypted;
+		sum->InPktsUnchecked   += tmp.InPktsUnchecked;
+		sum->InPktsDelayed     += tmp.InPktsDelayed;
+		sum->InPktsOK          += tmp.InPktsOK;
+		sum->InPktsInvalid     += tmp.InPktsInvalid;
+		sum->InPktsLate        += tmp.InPktsLate;
+		sum->InPktsNotValid    += tmp.InPktsNotValid;
+		sum->InPktsNotUsingSA  += tmp.InPktsNotUsingSA;
+		sum->InPktsUnusedSA    += tmp.InPktsUnusedSA;
 	}
+}
 
+static int copy_rx_sc_stats(struct sk_buff *skb, struct macsec_rx_sc_stats *sum)
+{
 	if (nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_OCTETS_VALIDATED,
-			      sum.InOctetsValidated,
+			      sum->InOctetsValidated,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_OCTETS_DECRYPTED,
-			      sum.InOctetsDecrypted,
+			      sum->InOctetsDecrypted,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_UNCHECKED,
-			      sum.InPktsUnchecked,
+			      sum->InPktsUnchecked,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_DELAYED,
-			      sum.InPktsDelayed,
+			      sum->InPktsDelayed,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_OK,
-			      sum.InPktsOK,
+			      sum->InPktsOK,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_INVALID,
-			      sum.InPktsInvalid,
+			      sum->InPktsInvalid,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_LATE,
-			      sum.InPktsLate,
+			      sum->InPktsLate,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_NOT_VALID,
-			      sum.InPktsNotValid,
+			      sum->InPktsNotValid,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_NOT_USING_SA,
-			      sum.InPktsNotUsingSA,
+			      sum->InPktsNotUsingSA,
 			      MACSEC_RXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_UNUSED_SA,
-			      sum.InPktsUnusedSA,
+			      sum->InPktsUnusedSA,
 			      MACSEC_RXSC_STATS_ATTR_PAD))
 		return -EMSGSIZE;
 
 	return 0;
 }
 
-static noinline_for_stack int
-copy_tx_sc_stats(struct sk_buff *skb, struct pcpu_tx_sc_stats __percpu *pstats)
+static void get_tx_sc_stats(struct net_device *dev,
+			    struct macsec_tx_sc_stats *sum)
 {
-	struct macsec_tx_sc_stats sum = {0, };
+	struct macsec_dev *macsec = macsec_priv(dev);
+	int err = -EOPNOTSUPP;
 	int cpu;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops) {
+			ctx.stats.tx_sc_stats = sum;
+			ctx.secy = &macsec_priv(dev)->secy;
+			err = macsec_offload(ops->mdo_get_tx_sc_stats, &ctx);
+		}
+	}
+
+	if (err != -EOPNOTSUPP)
+		return;
+
 	for_each_possible_cpu(cpu) {
 		const struct pcpu_tx_sc_stats *stats;
 		struct macsec_tx_sc_stats tmp;
 		unsigned int start;
 
-		stats = per_cpu_ptr(pstats, cpu);
+		stats = per_cpu_ptr(macsec_priv(dev)->secy.tx_sc.stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
-		sum.OutPktsProtected   += tmp.OutPktsProtected;
-		sum.OutPktsEncrypted   += tmp.OutPktsEncrypted;
-		sum.OutOctetsProtected += tmp.OutOctetsProtected;
-		sum.OutOctetsEncrypted += tmp.OutOctetsEncrypted;
+		sum->OutPktsProtected   += tmp.OutPktsProtected;
+		sum->OutPktsEncrypted   += tmp.OutPktsEncrypted;
+		sum->OutOctetsProtected += tmp.OutOctetsProtected;
+		sum->OutOctetsEncrypted += tmp.OutOctetsEncrypted;
 	}
+}
 
+static int copy_tx_sc_stats(struct sk_buff *skb, struct macsec_tx_sc_stats *sum)
+{
 	if (nla_put_u64_64bit(skb, MACSEC_TXSC_STATS_ATTR_OUT_PKTS_PROTECTED,
-			      sum.OutPktsProtected,
+			      sum->OutPktsProtected,
 			      MACSEC_TXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_TXSC_STATS_ATTR_OUT_PKTS_ENCRYPTED,
-			      sum.OutPktsEncrypted,
+			      sum->OutPktsEncrypted,
 			      MACSEC_TXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_TXSC_STATS_ATTR_OUT_OCTETS_PROTECTED,
-			      sum.OutOctetsProtected,
+			      sum->OutOctetsProtected,
 			      MACSEC_TXSC_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_TXSC_STATS_ATTR_OUT_OCTETS_ENCRYPTED,
-			      sum.OutOctetsEncrypted,
+			      sum->OutOctetsEncrypted,
 			      MACSEC_TXSC_STATS_ATTR_PAD))
 		return -EMSGSIZE;
 
 	return 0;
 }
 
-static noinline_for_stack int
-copy_secy_stats(struct sk_buff *skb, struct pcpu_secy_stats __percpu *pstats)
+static void get_secy_stats(struct net_device *dev, struct macsec_dev_stats *sum)
 {
-	struct macsec_dev_stats sum = {0, };
+	struct macsec_dev *macsec = macsec_priv(dev);
+	int err = -EOPNOTSUPP;
 	int cpu;
 
+	/* If h/w offloading is available, propagate to the device */
+	if (macsec_is_offloaded(macsec)) {
+		const struct macsec_ops *ops;
+		struct macsec_context ctx;
+
+		ops = macsec_get_ops(macsec, &ctx);
+		if (ops) {
+			ctx.stats.dev_stats = sum;
+			ctx.secy = &macsec_priv(dev)->secy;
+			err = macsec_offload(ops->mdo_get_dev_stats, &ctx);
+		}
+	}
+
+	if (err != -EOPNOTSUPP)
+		return;
+
 	for_each_possible_cpu(cpu) {
 		const struct pcpu_secy_stats *stats;
 		struct macsec_dev_stats tmp;
 		unsigned int start;
 
-		stats = per_cpu_ptr(pstats, cpu);
+		stats = per_cpu_ptr(macsec_priv(dev)->stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&stats->syncp);
 			memcpy(&tmp, &stats->stats, sizeof(tmp));
 		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
 
-		sum.OutPktsUntagged  += tmp.OutPktsUntagged;
-		sum.InPktsUntagged   += tmp.InPktsUntagged;
-		sum.OutPktsTooLong   += tmp.OutPktsTooLong;
-		sum.InPktsNoTag      += tmp.InPktsNoTag;
-		sum.InPktsBadTag     += tmp.InPktsBadTag;
-		sum.InPktsUnknownSCI += tmp.InPktsUnknownSCI;
-		sum.InPktsNoSCI      += tmp.InPktsNoSCI;
-		sum.InPktsOverrun    += tmp.InPktsOverrun;
+		sum->OutPktsUntagged  += tmp.OutPktsUntagged;
+		sum->InPktsUntagged   += tmp.InPktsUntagged;
+		sum->OutPktsTooLong   += tmp.OutPktsTooLong;
+		sum->InPktsNoTag      += tmp.InPktsNoTag;
+		sum->InPktsBadTag     += tmp.InPktsBadTag;
+		sum->InPktsUnknownSCI += tmp.InPktsUnknownSCI;
+		sum->InPktsNoSCI      += tmp.InPktsNoSCI;
+		sum->InPktsOverrun    += tmp.InPktsOverrun;
 	}
+}
 
+static int copy_secy_stats(struct sk_buff *skb, struct macsec_dev_stats *sum)
+{
 	if (nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_OUT_PKTS_UNTAGGED,
-			      sum.OutPktsUntagged,
+			      sum->OutPktsUntagged,
 			      MACSEC_SECY_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_UNTAGGED,
-			      sum.InPktsUntagged,
+			      sum->InPktsUntagged,
 			      MACSEC_SECY_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_OUT_PKTS_TOO_LONG,
-			      sum.OutPktsTooLong,
+			      sum->OutPktsTooLong,
 			      MACSEC_SECY_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_NO_TAG,
-			      sum.InPktsNoTag,
+			      sum->InPktsNoTag,
 			      MACSEC_SECY_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_BAD_TAG,
-			      sum.InPktsBadTag,
+			      sum->InPktsBadTag,
 			      MACSEC_SECY_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_UNKNOWN_SCI,
-			      sum.InPktsUnknownSCI,
+			      sum->InPktsUnknownSCI,
 			      MACSEC_SECY_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_NO_SCI,
-			      sum.InPktsNoSCI,
+			      sum->InPktsNoSCI,
 			      MACSEC_SECY_STATS_ATTR_PAD) ||
 	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_OVERRUN,
-			      sum.InPktsOverrun,
+			      sum->InPktsOverrun,
 			      MACSEC_SECY_STATS_ATTR_PAD))
 		return -EMSGSIZE;
 
@@ -2755,7 +2861,12 @@ static noinline_for_stack int
 dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	  struct sk_buff *skb, struct netlink_callback *cb)
 {
+	struct macsec_tx_sc_stats tx_sc_stats = {0, };
+	struct macsec_tx_sa_stats tx_sa_stats = {0, };
+	struct macsec_rx_sc_stats rx_sc_stats = {0, };
+	struct macsec_rx_sa_stats rx_sa_stats = {0, };
 	struct macsec_dev *macsec = netdev_priv(dev);
+	struct macsec_dev_stats dev_stats = {0, };
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 	struct nlattr *txsa_list, *rxsc_list;
 	struct macsec_rx_sc *rx_sc;
@@ -2786,7 +2897,9 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	attr = nla_nest_start_noflag(skb, MACSEC_ATTR_TXSC_STATS);
 	if (!attr)
 		goto nla_put_failure;
-	if (copy_tx_sc_stats(skb, tx_sc->stats)) {
+
+	get_tx_sc_stats(dev, &tx_sc_stats);
+	if (copy_tx_sc_stats(skb, &tx_sc_stats)) {
 		nla_nest_cancel(skb, attr);
 		goto nla_put_failure;
 	}
@@ -2795,7 +2908,8 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 	attr = nla_nest_start_noflag(skb, MACSEC_ATTR_SECY_STATS);
 	if (!attr)
 		goto nla_put_failure;
-	if (copy_secy_stats(skb, macsec_priv(dev)->stats)) {
+	get_secy_stats(dev, &dev_stats);
+	if (copy_secy_stats(skb, &dev_stats)) {
 		nla_nest_cancel(skb, attr);
 		goto nla_put_failure;
 	}
@@ -2817,22 +2931,15 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			goto nla_put_failure;
 		}
 
-		if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
-		    nla_put_u32(skb, MACSEC_SA_ATTR_PN, tx_sa->next_pn) ||
-		    nla_put(skb, MACSEC_SA_ATTR_KEYID, MACSEC_KEYID_LEN, tx_sa->key.id) ||
-		    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, tx_sa->active)) {
-			nla_nest_cancel(skb, txsa_nest);
-			nla_nest_cancel(skb, txsa_list);
-			goto nla_put_failure;
-		}
-
 		attr = nla_nest_start_noflag(skb, MACSEC_SA_ATTR_STATS);
 		if (!attr) {
 			nla_nest_cancel(skb, txsa_nest);
 			nla_nest_cancel(skb, txsa_list);
 			goto nla_put_failure;
 		}
-		if (copy_tx_sa_stats(skb, tx_sa->stats)) {
+		memset(&tx_sa_stats, 0, sizeof(tx_sa_stats));
+		get_tx_sa_stats(dev, i, tx_sa, &tx_sa_stats);
+		if (copy_tx_sa_stats(skb, &tx_sa_stats)) {
 			nla_nest_cancel(skb, attr);
 			nla_nest_cancel(skb, txsa_nest);
 			nla_nest_cancel(skb, txsa_list);
@@ -2840,6 +2947,16 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 		}
 		nla_nest_end(skb, attr);
 
+		if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
+		    nla_put_u32(skb, MACSEC_SA_ATTR_PN, tx_sa->next_pn) ||
+		    nla_put(skb, MACSEC_SA_ATTR_KEYID, MACSEC_KEYID_LEN,
+			    tx_sa->key.id) ||
+		    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, tx_sa->active)) {
+			nla_nest_cancel(skb, txsa_nest);
+			nla_nest_cancel(skb, txsa_list);
+			goto nla_put_failure;
+		}
+
 		nla_nest_end(skb, txsa_nest);
 	}
 	nla_nest_end(skb, txsa_list);
@@ -2873,7 +2990,9 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 			nla_nest_cancel(skb, rxsc_list);
 			goto nla_put_failure;
 		}
-		if (copy_rx_sc_stats(skb, rx_sc->stats)) {
+		memset(&rx_sc_stats, 0, sizeof(rx_sc_stats));
+		get_rx_sc_stats(dev, rx_sc, &rx_sc_stats);
+		if (copy_rx_sc_stats(skb, &rx_sc_stats)) {
 			nla_nest_cancel(skb, attr);
 			nla_nest_cancel(skb, rxsc_nest);
 			nla_nest_cancel(skb, rxsc_list);
@@ -2912,7 +3031,9 @@ dump_secy(struct macsec_secy *secy, struct net_device *dev,
 				nla_nest_cancel(skb, rxsc_list);
 				goto nla_put_failure;
 			}
-			if (copy_rx_sa_stats(skb, rx_sa->stats)) {
+			memset(&rx_sa_stats, 0, sizeof(rx_sa_stats));
+			get_rx_sa_stats(dev, rx_sc, i, rx_sa, &rx_sa_stats);
+			if (copy_rx_sa_stats(skb, &rx_sa_stats)) {
 				nla_nest_cancel(skb, attr);
 				nla_nest_cancel(skb, rxsa_list);
 				nla_nest_cancel(skb, rxsc_nest);
diff --git a/include/net/macsec.h b/include/net/macsec.h
index 5ccdb2bc84df..bfcd9a23cb71 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -58,6 +58,17 @@ struct macsec_tx_sc_stats {
 	__u64 OutOctetsEncrypted;
 };
 
+struct macsec_dev_stats {
+	__u64 OutPktsUntagged;
+	__u64 InPktsUntagged;
+	__u64 OutPktsTooLong;
+	__u64 InPktsNoTag;
+	__u64 InPktsBadTag;
+	__u64 InPktsUnknownSCI;
+	__u64 InPktsNoSCI;
+	__u64 InPktsOverrun;
+};
+
 /**
  * struct macsec_rx_sa - receive secure association
  * @active:
@@ -194,6 +205,13 @@ struct macsec_context {
 			struct macsec_tx_sa *tx_sa;
 		};
 	} sa;
+	union {
+		struct macsec_tx_sc_stats *tx_sc_stats;
+		struct macsec_tx_sa_stats *tx_sa_stats;
+		struct macsec_rx_sc_stats *rx_sc_stats;
+		struct macsec_rx_sa_stats *rx_sa_stats;
+		struct macsec_dev_stats  *dev_stats;
+	} stats;
 
 	u8 prepare:1;
 };
@@ -220,6 +238,12 @@ struct macsec_ops {
 	int (*mdo_add_txsa)(struct macsec_context *ctx);
 	int (*mdo_upd_txsa)(struct macsec_context *ctx);
 	int (*mdo_del_txsa)(struct macsec_context *ctx);
+	/* Statistics */
+	int (*mdo_get_dev_stats)(struct macsec_context *ctx);
+	int (*mdo_get_tx_sc_stats)(struct macsec_context *ctx);
+	int (*mdo_get_tx_sa_stats)(struct macsec_context *ctx);
+	int (*mdo_get_rx_sc_stats)(struct macsec_context *ctx);
+	int (*mdo_get_rx_sa_stats)(struct macsec_context *ctx);
 };
 
 void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa);
-- 
2.17.1

