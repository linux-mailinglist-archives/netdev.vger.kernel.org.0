Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4196A3507D6
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhCaUJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236426AbhCaUJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:18 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A067C061574;
        Wed, 31 Mar 2021 13:09:18 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j3so23682967edp.11;
        Wed, 31 Mar 2021 13:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PDNfoQw+IpfzvKELX6GQsBs9cKWa/BPLH9uWiBL9lZ8=;
        b=O8jRz+s7iFHpGmulSLyivZIGYA4FgojdBNqedeyFV2ymTwv7xIcQVIcxch6Ybi91px
         873dw9JKPoqIYBIcUAY3ttDEzhHih/DoVElMAfTjPcFXX92dqMIyrFA4P3PLpmLvSvBD
         QeWZK3uUPP7peGY9qgJ9QK1nmetvVX/Reyi8XelLp1VD1ldM50OKW7mBJDWkeVgye8HU
         jB4fDR8VnODvn8zHwAzX1bpq5iCVAvyg9WZZfIYrItzbkmYY1RMKsUwi+SbgnNYKLDpp
         WJaKQwcWLeKUYmHwlLz8AYCteYr4hM70d3VJqEv6e1vHtXQr1ZLoUTfBBC7n/TeFAtoI
         wVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PDNfoQw+IpfzvKELX6GQsBs9cKWa/BPLH9uWiBL9lZ8=;
        b=RitdD7e19SMl8pgoy0bvaZUBykIsKjT+i7PVZ5dqnc3Q9EHpia9VZpQGjqwae3t3E4
         VI+WUNuuxtUU+ZkCpFCbESTGDBQ8B9bzR9C9eFQLIT0G9qw/Cdv6ND8t5kv+OsUHjPk8
         XhLVn5xUllFx5mzgRUexSQMOfAMN6ivjXC9ljN4pEsXQqbAtCyl5atzVZdPMCsmwed2A
         8bGbTGINJMwAUqsWifitkx1KTLzHquUrUCJZLo7dhWcqi7/La6VVJW4jLwkMFw4KSeLf
         dXBA1RS2s7jx2XPjjRQDFjSfhV4THhAperv+6VbjAIWfDad9ISEXVRUVw97wWMH9FGI/
         ZtrQ==
X-Gm-Message-State: AOAM530bT7u/n2CT2h1soG4cD9ivyizHMYTeOCzaLHZf7kWLK7wpin6H
        u5Z6kgfX/Q9tYl4Ao9rryMIJLTE2APw=
X-Google-Smtp-Source: ABdhPJxwAZQi5bldl57IvYLB71XHOnUFsZQvVDBhYk1gpgSca+bsCXIcFUOd5I2JZNKlrIvf6EKzPA==
X-Received: by 2002:aa7:dcc7:: with SMTP id w7mr5752368edu.255.1617221357052;
        Wed, 31 Mar 2021 13:09:17 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 3/9] net: enetc: add a dedicated is_eof bit in the TX software BD
Date:   Wed, 31 Mar 2021 23:08:51 +0300
Message-Id: <20210331200857.3274425-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the transmit path, if we have a scatter/gather frame, it is put into
multiple software buffer descriptors, the last of which has the skb
pointer populated (which is necessary for rearming the TX MSI vector and
for collecting the two-step TX timestamp from the TX confirmation path).

At the moment, this is sufficient, but with XDP_TX, we'll need to
service TX software buffer descriptors that don't have an skb pointer,
however they might be final nonetheless. So add a dedicated bit for
final software BDs that we populate and check explicitly. Also, we keep
looking just for an skb when doing TX timestamping, because we don't
want/need that for XDP.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 7 +++----
 drivers/net/ethernet/freescale/enetc/enetc.h | 1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index b2071b8dc316..37d2d142a744 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -157,6 +157,7 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 	temp_bd.flags = flags;
 	*txbd = temp_bd;
 
+	tx_ring->tx_swbd[i].is_eof = true;
 	tx_ring->tx_swbd[i].skb = skb;
 
 	enetc_bdr_idx_inc(tx_ring, &i);
@@ -316,8 +317,6 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 	do_tstamp = false;
 
 	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
-		bool is_eof = !!tx_swbd->skb;
-
 		if (unlikely(tx_swbd->check_wb)) {
 			struct enetc_ndev_priv *priv = netdev_priv(ndev);
 			union enetc_tx_bd *txbd;
@@ -335,7 +334,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		if (likely(tx_swbd->dma))
 			enetc_unmap_tx_buff(tx_ring, tx_swbd);
 
-		if (is_eof) {
+		if (tx_swbd->skb) {
 			if (unlikely(do_tstamp)) {
 				enetc_tstamp_tx(tx_swbd->skb, tstamp);
 				do_tstamp = false;
@@ -355,7 +354,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 		}
 
 		/* BD iteration loop end */
-		if (is_eof) {
+		if (tx_swbd->is_eof) {
 			tx_frm_cnt++;
 			/* re-arm interrupt source */
 			enetc_wr_reg_hot(tx_ring->idr, BIT(tx_ring->index) |
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 773e412b9f4e..d9e75644b89c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -25,6 +25,7 @@ struct enetc_tx_swbd {
 	u8 is_dma_page:1;
 	u8 check_wb:1;
 	u8 do_tstamp:1;
+	u8 is_eof:1;
 };
 
 #define ENETC_RX_MAXFRM_SIZE	ENETC_MAC_MAXFRM_SIZE
-- 
2.25.1

