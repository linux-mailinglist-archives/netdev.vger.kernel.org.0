Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C75E214FC2C
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 08:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgBBHmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 02:42:13 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52784 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgBBHmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 02:42:10 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep11so4867679pjb.2
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 23:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lf1oHoMxRf8OrFlWfCMBKGW7n3HL8ujiHpTtmZTT7yA=;
        b=T5FzA+ajA7XoPjv1WptMEFAVHrupNIYlfcZLiEHDVx3E0LKuXlvwbohIN2sKXyPM8e
         8rrIPTo9AThFoiw0/4JCW+yvWleaUumhYJ1ahO6zc9wJyLGPHgA/dxKc7UDJ5f5sqEFF
         U50aHQgFkqO5/Hk9ouxXr75GsUolQ4/lvLlt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lf1oHoMxRf8OrFlWfCMBKGW7n3HL8ujiHpTtmZTT7yA=;
        b=MDpx461Xt/+FfIatW+LfmRWaHyoflFgwx0SnB3B1GfhKq1w9oph3WI/Gz9u1Td8Fr5
         t+PR4zxuZQiWjkt0oGKf3RbcHg3I5Vu8LhLRsMBQmb+xevEApL4ngYCj0oPcMTgVuY1c
         h4QZ10EnPRwIEljNODayg9FDahvrPTg8Fwj+Q9JE/lRotFd8N5U0sFoNQYxANLGKYQde
         Bt3uVi38zTY4A2DgfLiS2FMl9DTPZONgIk1x2ZVT4C/6iUowQ5AgXKXQL15BM288MP15
         0bpFE0ID6wIyhbX7lGuWITrxW5v2sGlU1ODPeS/ctg63Gj2Y9ClcZO17CtRixMhNunV5
         kGyA==
X-Gm-Message-State: APjAAAW6YRazm3vUnWjEII9Rra7eV4oOUJ6xMdJhX6WNCTwGEE9f4AwQ
        jSOmqipujI+d4rkUDuo2iCDd7aP8R6Y=
X-Google-Smtp-Source: APXvYqwonMBbP5NVEUWzfSTCJgG0lfHJZ3T8hoskyZC4d2lvFnP2aRHbi7cgTp8NolKJrHCVc2DNsg==
X-Received: by 2002:a17:90a:db0b:: with SMTP id g11mr21651308pjv.140.1580629328456;
        Sat, 01 Feb 2020 23:42:08 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y21sm16223162pfm.136.2020.02.01.23.42.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Feb 2020 23:42:08 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 4/4] bnxt_en: Fix TC queue mapping.
Date:   Sun,  2 Feb 2020 02:41:38 -0500
Message-Id: <1580629298-20071-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
References: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver currently only calls netdev_set_tc_queue when the number of
TCs is greater than 1.  Instead, the comparison should be greater than
or equal to 1.  Even with 1 TC, we need to set the queue mapping.

This bug can cause warnings when the number of TCs is changed back to 1.

Fixes: 7809592d3e2e ("bnxt_en: Enable MSIX early in bnxt_init_one().")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cea6033..597e6fd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7893,7 +7893,7 @@ static void bnxt_setup_msix(struct bnxt *bp)
 	int tcs, i;
 
 	tcs = netdev_get_num_tc(dev);
-	if (tcs > 1) {
+	if (tcs) {
 		int i, off, count;
 
 		for (i = 0; i < tcs; i++) {
-- 
2.5.1

