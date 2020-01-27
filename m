Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51AB14A148
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgA0J5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:12 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41521 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:12 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so4666191pfw.8
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5VIfIibANwl5rfEFMKkcvCiSoUPWXBV6pjQ2Bk4kGd4=;
        b=NVHmfd9TVOk66LcHu3MZYApuERmjPRPVPig4sJLa3nSyWtIVWOfsJmAwfmynfvgGni
         OIiyNRr0Az+Uqwrj8lMA3Qd3pIRWgBlAASWepJqmPufCtAIvchxzBu6kyMxT+w9L9UT2
         MShve3cUeW0wXRcHcIw3xFSj2XnyKjP91Gpew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5VIfIibANwl5rfEFMKkcvCiSoUPWXBV6pjQ2Bk4kGd4=;
        b=PYi0HjZIr2nU9prs+OI/YJbKMXsg1b0ovL9KVpLh/xfwxpkqC3in3afGRoQzKsDYrZ
         76v3SjeJo1Fyzd96PaiIM4d/ha/GwNY6ewg2SsD64HLPRHD87YeX4POlDBfdReCBRnyc
         yk9f+BBvmX6o8tfGp+TAgNswtNfchuem7Ccz58Sl/OC+/mECSCn5OmoMGcBlrOnZX961
         SIIDWaOg2XImHEjXryUxYmpypI5fb4mUxGs9btNveIVYpbQqbO97+jSOh8FScQWRxXIr
         R6WhafZz0xOBeWsyLEYXPLNh4Fnf+ldDhuXWER9tv3HyvkevOYM5vNAs/h0EIHalWFrs
         QutA==
X-Gm-Message-State: APjAAAWB+1c4xOwwoq7ggAbMhKqWDyzsfpNGtTmAJqMHmaxqBDSV2grl
        GB26pY1sYumtA5UgFcoIakj/8A==
X-Google-Smtp-Source: APXvYqyR/eM7XVGe1hy5oW29c/+r6/07iVYLCgR20kQ3e7XcMegMBFvmwprOQFjgqSfnKm6MuO9keQ==
X-Received: by 2002:a65:66d7:: with SMTP id c23mr19258837pgw.40.1580119031320;
        Mon, 27 Jan 2020 01:57:11 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:10 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 07/15] bnxt_en: Disable workaround for lost interrupts on 575XX B0 and newer chips.
Date:   Mon, 27 Jan 2020 04:56:19 -0500
Message-Id: <1580118987-30052-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware bug has been fixed on B0 and newer chips, so disable the
workaround on these chips.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 +++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7d53672..676f4da 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7288,6 +7288,7 @@ static int bnxt_hwrm_ver_get(struct bnxt *bp)
 		bp->hwrm_max_ext_req_len = HWRM_MAX_REQ_LEN;
 
 	bp->chip_num = le16_to_cpu(resp->chip_num);
+	bp->chip_rev = resp->chip_rev;
 	if (bp->chip_num == CHIP_NUM_58700 && !resp->chip_rev &&
 	    !resp->chip_metal)
 		bp->flags |= BNXT_FLAG_CHIP_NITRO_A0;
@@ -10057,7 +10058,8 @@ static void bnxt_timer(struct timer_list *t)
 		}
 	}
 
-	if ((bp->flags & BNXT_FLAG_CHIP_P5) && netif_carrier_ok(dev)) {
+	if ((bp->flags & BNXT_FLAG_CHIP_P5) && !bp->chip_rev &&
+	    netif_carrier_ok(dev)) {
 		set_bit(BNXT_RING_COAL_NOW_SP_EVENT, &bp->sp_event);
 		bnxt_queue_sp_work(bp);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index f143354..cda434b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1457,6 +1457,8 @@ struct bnxt {
 #define CHIP_NUM_58804		0xd804
 #define CHIP_NUM_58808		0xd808
 
+	u8			chip_rev;
+
 #define BNXT_CHIP_NUM_5730X(chip_num)		\
 	((chip_num) >= CHIP_NUM_57301 &&	\
 	 (chip_num) <= CHIP_NUM_57304)
-- 
2.5.1

