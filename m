Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C461B93EB
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgDZUZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgDZUZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 16:25:09 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB15C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:09 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k18so6106218pll.6
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 13:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d6/IlLhSTXDkNsxTnLLbS3vO/IiKqymKmqMkJyim7Ds=;
        b=Wht7p8JKosar52bugCwa5WzxKidQdIQLW1AczMy+i2FoCBh2KS9FvVWAMbepW3bSIs
         5/5c4DwdKU0P73cLprXIofLi6UuR5IbCyt7yJpbqHk1+0MiIdyTyoxpmbVkTwrbp1hJn
         0ymOwnhL3ZTW5ml+741Hr1Eqr+lnitLs0yalI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d6/IlLhSTXDkNsxTnLLbS3vO/IiKqymKmqMkJyim7Ds=;
        b=GNGAikpxf9RdxD7dOTZVYDD5cX87BQIe5PVAdpK2EZB+SzzL36i61AsySw5FoZCMfv
         w15H27663cBPWvfqSj4Wxix5UAsRriJ6IyPLHfefaf3lTkIXiTR+Jd4qp0nNUqFzlzRk
         nHscIe2m+EoQufxIKcs8TJ8sUr5MHWnk0SbZxVAfxNKqEHQ56SZm+rCZtimqUgTQJf8m
         5irCRdqLYZjCfJLrBQULOqhpWLjsA3IZT3//jkYFkJK4oAgKP+BNnfRtOoPrPSKqtvq/
         CjSjs24YmQS1d5JMQaKqHsCudIWXZUPw1Fuo0ju0iUCF58zcypxJytmAU60jbtZimzs8
         x+Nw==
X-Gm-Message-State: AGi0PuZPUo96t6MIxJnM2nwjnUIspp3O7TeD1wfSIc3P5hQZzakGTICz
        XGZNWGUEYOaCiksybHTeqEalpl3BlTk=
X-Google-Smtp-Source: APiQypJQjEDoiW9KrPqDst65jHwfZ76uNsgiGoZ9kC/WCPPsLxnTAQVj3DbpxPkxJdlKCqIFyRF10w==
X-Received: by 2002:a17:902:8a89:: with SMTP id p9mr19861653plo.286.1587932708766;
        Sun, 26 Apr 2020 13:25:08 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a136sm10862103pfa.99.2020.04.26.13.25.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Apr 2020 13:25:08 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 3/5] bnxt_en: Improve AER slot reset.
Date:   Sun, 26 Apr 2020 16:24:40 -0400
Message-Id: <1587932682-1212-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
References: <1587932682-1212-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the slot reset sequence by disabling the device to prevent bad
DMAs if slot reset fails.  Return the proper result instead of always
PCI_ERS_RESULT_RECOVERED to the caller.

Fixes: 6316ea6db93d ("bnxt_en: Enable AER support.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fead64f..d8db08e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12212,12 +12212,15 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		bnxt_ulp_start(bp, err);
 	}
 
-	if (result != PCI_ERS_RESULT_RECOVERED && netif_running(netdev))
-		dev_close(netdev);
+	if (result != PCI_ERS_RESULT_RECOVERED) {
+		if (netif_running(netdev))
+			dev_close(netdev);
+		pci_disable_device(pdev);
+	}
 
 	rtnl_unlock();
 
-	return PCI_ERS_RESULT_RECOVERED;
+	return result;
 }
 
 /**
-- 
2.5.1

