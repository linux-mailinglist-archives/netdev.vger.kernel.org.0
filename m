Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC49A49E170
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240785AbiA0LqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:46:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24418 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240786AbiA0LqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643283960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sG7YUXpPRl6RONBOQknLLzz4wjgiShFuatkXsXcovdo=;
        b=Cyjzqwg6BidsudegKkxH2Np7XBlFMiFsQ4Fj3HpoXamFEQoe38pBwjdrWN/ZFSmdcB1NvY
        +DPJlC9KbmXB9M0X+1KdELuPqR9H40jQpC447kTWFKPeV0ApocKeJeN1gqgtw43LYMWIIh
        6Q3KOj+SJ3ipwj/JcHo6VPwj0puZGjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-6ltsihxdOMS0rX6DSaat_A-1; Thu, 27 Jan 2022 06:45:54 -0500
X-MC-Unique: 6ltsihxdOMS0rX6DSaat_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA22A1091DA1;
        Thu, 27 Jan 2022 11:45:53 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2E0B6E4A9;
        Thu, 27 Jan 2022 11:45:50 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next 3/5] ptp: add gettimex64() to virtual clocks.
Date:   Thu, 27 Jan 2022 12:45:34 +0100
Message-Id: <20220127114536.1121765-4-mlichvar@redhat.com>
In-Reply-To: <20220127114536.1121765-1-mlichvar@redhat.com>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the physical clock has the gettimex64() function, provide a
gettimex64() wrapper in the virtual clock to enable more accurate
and stable synchronization.

This adds support for the PTP_SYS_OFFSET_EXTENDED ioctl.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_vclock.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 5aa2b32d9dc7..2f0b46386176 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -57,6 +57,30 @@ static int ptp_vclock_gettime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
+			       struct timespec64 *ts,
+			       struct ptp_system_timestamp *sts)
+{
+	struct ptp_vclock *vclock = info_to_vclock(ptp);
+	struct ptp_clock *pptp = vclock->pclock;
+	struct timespec64 pts;
+	unsigned long flags;
+	int err;
+	u64 ns;
+
+	err = pptp->info->gettimex64(pptp->info, &pts, sts);
+	if (err)
+		return err;
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	ns = timecounter_cyc2time(&vclock->tc, timespec64_to_ns(&pts));
+	spin_unlock_irqrestore(&vclock->lock, flags);
+
+	*ts = ns_to_timespec64(ns);
+
+	return 0;
+}
+
 static int ptp_vclock_settime(struct ptp_clock_info *ptp,
 			      const struct timespec64 *ts)
 {
@@ -87,7 +111,6 @@ static const struct ptp_clock_info ptp_vclock_info = {
 	.max_adj	= 500000000,
 	.adjfine	= ptp_vclock_adjfine,
 	.adjtime	= ptp_vclock_adjtime,
-	.gettime64	= ptp_vclock_gettime,
 	.settime64	= ptp_vclock_settime,
 	.do_aux_work	= ptp_vclock_refresh,
 };
@@ -123,6 +146,10 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 
 	vclock->pclock = pclock;
 	vclock->info = ptp_vclock_info;
+	if (pclock->info->gettimex64)
+		vclock->info.gettimex64 = ptp_vclock_gettimex;
+	else
+		vclock->info.gettime64 = ptp_vclock_gettime;
 	vclock->cc = ptp_vclock_cc;
 
 	snprintf(vclock->info.name, PTP_CLOCK_NAME_LEN, "ptp%d_virt",
-- 
2.34.1

