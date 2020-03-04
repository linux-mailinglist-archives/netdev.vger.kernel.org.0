Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A576179741
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgCDRxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:53:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37705 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730045AbgCDRxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 12:53:55 -0500
Received: from mail-wr1-f71.google.com ([209.85.221.71])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <andrea.righi@canonical.com>)
        id 1j9YDR-0005BL-Em
        for netdev@vger.kernel.org; Wed, 04 Mar 2020 17:53:53 +0000
Received: by mail-wr1-f71.google.com with SMTP id u18so1148963wrn.11
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 09:53:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=tgXnocXG+jZrTeViaEPQZMOPzJF0dDDQTUKioSbPZLw=;
        b=WfunjDtHHfaoU/AChukRBFAf8he+wddG+Vc+n8UG6RBSM1I1WXkGrHFQQw4WsRjAOG
         LwiYCrgreL22unBmHtqu/AO+O83wet13MVDXpu7r4HN7GmQ7lBiPCNBK13mqy+PMPB9i
         qbVYK+ICbsxvZ/HaUD6jjKYu4nJHW/se8UIQclt4xIMu8kulncB1xQguEimtnBUAJIiS
         CUYwT/csiPa5Hn2gDM60aQQ+bFu1KWjuDdEZzsNsB6Uho3c/VEY1TyQI/WMPjqc5eqmv
         mzxr2pAl1OG9hb6Z2uJ/amARcAywsbDTbXgtY6uTdrVpOExGdXrMHec4Xyzx6bZUpW4+
         UnCw==
X-Gm-Message-State: ANhLgQ0EbbYxBgmCX7APjjNZAuRCEKTUxUTKe1faNlz+P7HwnvXaRBAL
        ExO4Kjm02fNtg9lnpr6efIjk9i82YSAy4BWDkQRx69m/iIBlr0b2G3MDXQe3yiJsWknJIX93EcA
        gIdMbi73cYhAF4hFtsYAcgaiWxdZ53V7yVw==
X-Received: by 2002:a05:600c:4151:: with SMTP id h17mr4964393wmm.189.1583344433066;
        Wed, 04 Mar 2020 09:53:53 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuL6fP8UzU9Yr2dI0/WuSEUIxMfCycwldfogtODqrI3DPCrLXBqrb8HQ1spg4nDeYKW00haZQ==
X-Received: by 2002:a05:600c:4151:: with SMTP id h17mr4964377wmm.189.1583344432781;
        Wed, 04 Mar 2020 09:53:52 -0800 (PST)
Received: from localhost (host96-127-dynamic.32-79-r.retail.telecomitalia.it. [79.32.127.96])
        by smtp.gmail.com with ESMTPSA id b10sm5469093wmh.48.2020.03.04.09.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:53:52 -0800 (PST)
Date:   Wed, 4 Mar 2020 18:53:50 +0100
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladis Dronov <vdronov@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ptp: free ptp clock properly
Message-ID: <20200304175350.GB267906@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a bug in ptp_clock_unregister() where ptp_clock_release() can
free up resources needed by posix_clock_unregister() to properly destroy
a related sysfs device.

Fix this by calling posix_clock_unregister() in ptp_clock_release().

See also:
commit 75718584cb3c ("ptp: free ptp device pin descriptors properly").

BugLink: https://bugs.launchpad.net/bugs/1864754
Fixes: a33121e5487b ("ptp: fix the race between the release of ptp_clock and cdev")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 drivers/ptp/ptp_clock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index ac1f2bf9e888..12951023d0c6 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -171,6 +171,7 @@ static void ptp_clock_release(struct device *dev)
 	struct ptp_clock *ptp = container_of(dev, struct ptp_clock, dev);
 
 	ptp_cleanup_pin_groups(ptp);
+	posix_clock_unregister(&ptp->clock);
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	ida_simple_remove(&ptp_clocks_map, ptp->index);
@@ -303,8 +304,6 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
 	if (ptp->pps_source)
 		pps_unregister_source(ptp->pps_source);
 
-	posix_clock_unregister(&ptp->clock);
-
 	return 0;
 }
 EXPORT_SYMBOL(ptp_clock_unregister);
-- 
2.25.0

