Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EED51499B6
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgAZJDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:42 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41797 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbgAZJDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:40 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so3423534pfw.8
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BsU5eUAUtDx980IIueh5IHnsjobmFAjuDQZA4jiYaeQ=;
        b=KjHkFmFzVDzsnfHXm2Ch0tuKcqxUXmPrnSZs1NFgK5JN+6Z4EVJ8VPFWDNNBhsEvEx
         NhfO1FzjKTAxLTdLPnXKBTcgtHjTZ4AcFrd4p2dn/oGmC/w/Wy1eCEpzdT6pICui1wA7
         R1S5Gbe+3sFz2XwZWTPwSfhHykamaXC1YDr3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BsU5eUAUtDx980IIueh5IHnsjobmFAjuDQZA4jiYaeQ=;
        b=a8ZrfB/RaYRoQbDj16BPBqDhi2+djF2Fq2PCpfD2/SEyfL0hzD/KjAyjePJhcSIBQN
         q0HVsnREXS3Fyin53YPJ5u4m71eNcj1x0bq/G9t1Zu3pkNVDR6uivr6G0gPTtKG/4P4/
         KL2KyKJ0jkH16xuiI71NDcQThoyMuSKZRLWewJ3/4TG3TaWuJv0VVX+xzV55AyfK5M9P
         DetcrWgKWdWTjrHFirIRQAc5V4xHytOk1QUmX1wBi5Dnnceg8SfoBDDqghxvD1JdjP3m
         RvS1A0WO7ZsAP4sChVSOXgZdBO6f2z2lzA3yZaTMSp4cEcUpnWSekWpaNsSwZaqe62pR
         F2Pw==
X-Gm-Message-State: APjAAAUT5G+jcTv8bDZYXv2ixuu1BSDuTftJu+nkfT3+yVsPo63OAA0d
        5WBFT4pJnwIZDKEzEKPFBKaMfAt9Zw8=
X-Google-Smtp-Source: APXvYqzQ9HMN0bfpSbq/v8T8kLP/DRy+1QnHyVcamDudfgYBb+xa3xe/uWaH4PsUmyD9TlLRPx9HxQ==
X-Received: by 2002:a63:a53:: with SMTP id z19mr13263896pgk.267.1580029419858;
        Sun, 26 Jan 2020 01:03:39 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:39 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 08/16] bnxt_en: Disable workaround for lost interrupts on 575XX B0 and newer chips.
Date:   Sun, 26 Jan 2020 04:03:02 -0500
Message-Id: <1580029390-32760-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
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
index 534bc9e..cb2b833 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1458,6 +1458,8 @@ struct bnxt {
 #define CHIP_NUM_58804		0xd804
 #define CHIP_NUM_58808		0xd808
 
+	u8			chip_rev;
+
 #define BNXT_CHIP_NUM_5730X(chip_num)		\
 	((chip_num) >= CHIP_NUM_57301 &&	\
 	 (chip_num) <= CHIP_NUM_57304)
-- 
2.5.1

