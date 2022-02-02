Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86BE4A6DE0
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245508AbiBBJeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:34:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42739 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245514AbiBBJeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:34:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643794454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pLh1utzc6mQ6v2rAw51I9loSNOSb76Yh+mkGV0PLwVQ=;
        b=fIHkKdxNDRHcxhvqHLxmLp3ItCrRgl42q3RrbJ4dFksQxil4Xdn2A/tsPcJnwU7r2k/PjX
        l51vF0pOj7Bnt711ZGcu5z5U4ah4bBLSXBtoaOMdssVHh1W3FaGFgfZCqDxJP9BvWnu2h6
        yH8A6NKOhiB52SoTlZDtpN2DZoUlfYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-57gIxMmAMJe5Qlg7lHvaLw-1; Wed, 02 Feb 2022 04:34:09 -0500
X-MC-Unique: 57gIxMmAMJe5Qlg7lHvaLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20FC983DD20;
        Wed,  2 Feb 2022 09:34:08 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28FB6E2C1;
        Wed,  2 Feb 2022 09:34:07 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCHv2 net-next 3/4] ptp: add gettimex64() to virtual clocks.
Date:   Wed,  2 Feb 2022 10:33:57 +0100
Message-Id: <20220202093358.1341391-4-mlichvar@redhat.com>
In-Reply-To: <20220202093358.1341391-1-mlichvar@redhat.com>
References: <20220202093358.1341391-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the physical clock has the gettimex64() function, provide a
gettimex64() wrapper in the virtual clock to enable more accurate
and stable synchronization.

This adds support for the PTP_SYS_OFFSET_EXTENDED ioctl.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
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

