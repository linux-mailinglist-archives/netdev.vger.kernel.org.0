Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5DA21866B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgGHLy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgGHLyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:54:24 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B47C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:54:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j4so46229785wrp.10
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sjBNJpLJcyHJz3EqTemVzpSJrCcVeC4xpv3nzU6YQdQ=;
        b=c82K2ntXM6n463yiZWkF2QsbFbsWBiW80fD/vn4QjFkqywUjnY5JW8fZk6x8dAos26
         O5jfEV+NGuvC+R10Hx93L7sKaJLQmt3SFNK7gEWplib7XU4MOqrICudRkhsPV3UrO3lq
         k056DiM6hIDuZwG/Tfu0ft1/1FHDSEOmgLRYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sjBNJpLJcyHJz3EqTemVzpSJrCcVeC4xpv3nzU6YQdQ=;
        b=IuAUQ2AH2yBDecaU16GkXWRmS8zsuXUSER7qF6VljXTY7QR1JwKIrQkU9m5aC2/+B7
         VCMGhdFJtQVC+v8iW8RdnFZ80uxtH8EsqyL9npNpWdspS+RCK4i0ecmWA627d4nZeVvG
         Zo3aiaEZudFOkTk4m0NviIOenueBmgcRUnejyqVJnPT9OkgSQUvEulQRVoFxOy9DYlPV
         ZO9OtZoaC2akQ/WoWCAfqELsrwpXqfTgIDZl05UOvAGAHNaJZ/InBlUldZW4YXFitakq
         XY5znRrv+ut68rWd+PxfKEB7ApNX6U/9PUieoNnrGayFB95+AIbO1uhz2iZp6sJFkubN
         qhfg==
X-Gm-Message-State: AOAM530WLxMxN5PiE7Fr4ae3W9fq4iQGkAZz6uAREBu32G7N89+pyvZk
        FUjohHvdyOuZOwP+asBJ+EjxVg==
X-Google-Smtp-Source: ABdhPJzPTDJT5cdGcLZzXX4NAZBR8lXSG7kmudCf0IIOgMWubrKl4SSCEanlt6Jrfd05o34BhA6FCw==
X-Received: by 2002:adf:ce8d:: with SMTP id r13mr62432595wrn.392.1594209262934;
        Wed, 08 Jul 2020 04:54:22 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm6352888wrh.54.2020.07.08.04.54.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:54:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v4 2/9] bnxt_en: Fix up bnxt_get_rxfh_indir_size().
Date:   Wed,  8 Jul 2020 07:53:54 -0400
Message-Id: <1594209241-1692-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix up bnxt_get_rxfh_indir_size() to return the proper current RSS
table size for P5 chips.  Change it to non-static so that bnxt.c
can use it to get the table size.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 6 +++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 6b88143..995de93 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1273,8 +1273,12 @@ static int bnxt_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return rc;
 }
 
-static u32 bnxt_get_rxfh_indir_size(struct net_device *dev)
+u32 bnxt_get_rxfh_indir_size(struct net_device *dev)
 {
+	struct bnxt *bp = netdev_priv(dev);
+
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		return ALIGN(bp->rx_nr_rings, BNXT_RSS_TABLE_ENTRIES_P5);
 	return HW_HASH_INDEX_SIZE;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
index ce7585ff..dddbca1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
@@ -86,6 +86,7 @@ struct hwrm_dbg_cmn_output {
 
 extern const struct ethtool_ops bnxt_ethtool_ops;
 
+u32 bnxt_get_rxfh_indir_size(struct net_device *dev);
 u32 _bnxt_fw_to_ethtool_adv_spds(u16, u8);
 u32 bnxt_fw_to_ethtool_speed(u16);
 u16 bnxt_get_fw_auto_link_speeds(u32);
-- 
1.8.3.1

