Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90698611D50
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 00:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJ1WQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 18:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJ1WQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 18:16:52 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A1C24AE36;
        Fri, 28 Oct 2022 15:16:50 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id n18so4968055qvt.11;
        Fri, 28 Oct 2022 15:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ERWyhTXJWw0g6FYpMVzuwjT5hcLIVbpWXsp+/9eskIE=;
        b=U4B805hx+7PT9WdBN1PIfS+4FyzPSXzzI4LnaC5SStVVp9SuGHhWhtsxOI4B4WgYqU
         qmZslWZDVnP6xXVjXalzdTIW1HMczdfm60hlVsCgroyVjt+pz0cgnqwU3hXJK1f3hNm8
         gaEexrcFyviE2KEs4vo4MmBzV1Jvhw+i6pXLAgcE4c1BYQMr8PAhxsHCehSMtyJMBq2I
         81pjae/egxmmelHkbWR/PnneaVBtscH3hZSskgdO5OrGXFGWtQoV52a8lWjJI9hXpOZt
         u3na1l8hJL5vdBueFyEUMy62Yp6pXLdJBGpIHreRDPCu1+NgZniQibwGG6EmuKhSzV6S
         GsCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ERWyhTXJWw0g6FYpMVzuwjT5hcLIVbpWXsp+/9eskIE=;
        b=dQ8syWG1nPMQJGeg1Wp8pocxvwo+0pyXt4T/fkx6wCACvYzjL60tCLDmc3YtOU4ir5
         7kfy+ufakVvrvISRgvQqaWXeQSOIyIwzo5s0jbAnUHpFU30cllF3A4dCsLot4FaXeDTq
         fStg0jx0tUIvG9oZK/WXf3Bg5hQ18ztxOSOE0trGNaajU9r+FrJ9zh1N5ceu19dFI0xc
         RMcPkey9p5aoLzRHoN0V55Cntb633Iwp+1kqaDTl/ujmkbkzw1ZuSMtjMJNdzUoBU4HM
         cZfl0kLaPXdLvMnrz+JgpNY6xz6S9G6657b+BbXSIZXp0wb01CZgPfcj91IPWhLI4Wta
         m3oA==
X-Gm-Message-State: ACrzQf0O9a336cOU52o2AV/spgJdd9F80itC98rLgauxPe7Ok4gu2KgR
        6tY97BsnvxH4vWVVxOaE5GHcbaPw7jUmaQ==
X-Google-Smtp-Source: AMsMyM4kcVsc06fUTIE7CENi+T4+7C4cI0MJd1lSHCgnFGlFr1dHfdvyDXBjQhx+LVZBZ/9k+maWQg==
X-Received: by 2002:a05:6214:d6e:b0:4b9:692d:c486 with SMTP id 14-20020a0562140d6e00b004b9692dc486mr1482258qvs.104.1666995409332;
        Fri, 28 Oct 2022 15:16:49 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b17-20020ac844d1000000b003a4d5fed8c3sm2928320qto.85.2022.10.28.15.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 15:16:48 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: systemport: Add support for RDMA overflow statistic counter
Date:   Fri, 28 Oct 2022 15:16:42 -0700
Message-Id: <20221028221643.3207713-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RDMA overflows can happen if the Ethernet controller does not have
enough bandwidth allocated at the memory controller level, report RDMA
overflows and deal with saturation, similar to the RBUF overflow
counter.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Change-Id: I718d806832f807e0d578c252810ba88637e5f5b4
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 11 +++++++++++
 drivers/net/ethernet/broadcom/bcmsysport.h | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 425d6ccd5413..95449bf034ac 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -295,6 +295,8 @@ static const struct bcm_sysport_stats bcm_sysport_gstrings_stats[] = {
 	/* RBUF misc statistics */
 	STAT_RBUF("rbuf_ovflow_cnt", mib.rbuf_ovflow_cnt, RBUF_OVFL_DISC_CNTR),
 	STAT_RBUF("rbuf_err_cnt", mib.rbuf_err_cnt, RBUF_ERR_PKT_CNTR),
+	/* RDMA misc statistics */
+	STAT_RDMA("rdma_ovflow_cnt", mib.rdma_ovflow_cnt, RDMA_OVFL_DISC_CNTR),
 	STAT_MIB_SOFT("alloc_rx_buff_failed", mib.alloc_rx_buff_failed),
 	STAT_MIB_SOFT("rx_dma_failed", mib.rx_dma_failed),
 	STAT_MIB_SOFT("tx_dma_failed", mib.tx_dma_failed),
@@ -333,6 +335,7 @@ static inline bool bcm_sysport_lite_stat_valid(enum bcm_sysport_stat_type type)
 	case BCM_SYSPORT_STAT_NETDEV64:
 	case BCM_SYSPORT_STAT_RXCHK:
 	case BCM_SYSPORT_STAT_RBUF:
+	case BCM_SYSPORT_STAT_RDMA:
 	case BCM_SYSPORT_STAT_SOFT:
 		return true;
 	default:
@@ -436,6 +439,14 @@ static void bcm_sysport_update_mib_counters(struct bcm_sysport_priv *priv)
 			if (val == ~0)
 				rbuf_writel(priv, 0, s->reg_offset);
 			break;
+		case BCM_SYSPORT_STAT_RDMA:
+			if (!priv->is_lite)
+				continue;
+
+			val = rdma_readl(priv, s->reg_offset);
+			if (val == ~0)
+				rdma_writel(priv, 0, s->reg_offset);
+			break;
 		}
 
 		j += s->stat_sizeof;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 5af16e5f9ad0..335cf6631db5 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -290,6 +290,7 @@ struct bcm_rsb {
 
 #define RDMA_WRITE_PTR_HI		0x1010
 #define RDMA_WRITE_PTR_LO		0x1014
+#define RDMA_OVFL_DISC_CNTR		0x1018
 #define RDMA_PROD_INDEX			0x1018
 #define  RDMA_PROD_INDEX_MASK		0xffff
 
@@ -565,6 +566,7 @@ struct bcm_sysport_mib {
 	u32 rxchk_other_pkt_disc;
 	u32 rbuf_ovflow_cnt;
 	u32 rbuf_err_cnt;
+	u32 rdma_ovflow_cnt;
 	u32 alloc_rx_buff_failed;
 	u32 rx_dma_failed;
 	u32 tx_dma_failed;
@@ -581,6 +583,7 @@ enum bcm_sysport_stat_type {
 	BCM_SYSPORT_STAT_RUNT,
 	BCM_SYSPORT_STAT_RXCHK,
 	BCM_SYSPORT_STAT_RBUF,
+	BCM_SYSPORT_STAT_RDMA,
 	BCM_SYSPORT_STAT_SOFT,
 };
 
@@ -627,6 +630,14 @@ enum bcm_sysport_stat_type {
 	.reg_offset = ofs, \
 }
 
+#define STAT_RDMA(str, m, ofs) { \
+	.stat_string = str, \
+	.stat_sizeof = sizeof(((struct bcm_sysport_priv *)0)->m), \
+	.stat_offset = offsetof(struct bcm_sysport_priv, m), \
+	.type = BCM_SYSPORT_STAT_RDMA, \
+	.reg_offset = ofs, \
+}
+
 /* TX bytes and packets */
 #define NUM_SYSPORT_TXQ_STAT	2
 
-- 
2.25.1

