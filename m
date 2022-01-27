Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05E849E16F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbiA0Lp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:45:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240785AbiA0Lp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643283957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3U3lZnv2taoPJ7iI5c30DVn9gDpy+KRd+ExrBb4Jie4=;
        b=OYKMn2lNzrOTyu6Z7O4/0aaFzzdWAFvrKT2cd5dieoZdUyjlV3hPPqjTPLFmEDWFfp3vmb
        5SGU9+IDivd01qqiRpanM9i6llMO7Kby41Nxav00eh1bef6ijzTyeQDfOV/gt9rxCEbElw
        bKgQk++xml3eQ95l96gzSdfH0BORno4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-TL-7Yak9NzmaUy7whLulVg-1; Thu, 27 Jan 2022 06:45:56 -0500
X-MC-Unique: TL-7Yak9NzmaUy7whLulVg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F07D84DA40;
        Thu, 27 Jan 2022 11:45:55 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C1776E4A9;
        Thu, 27 Jan 2022 11:45:54 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next 4/5] ptp: add getcrosststamp() to virtual clocks.
Date:   Thu, 27 Jan 2022 12:45:35 +0100
Message-Id: <20220127114536.1121765-5-mlichvar@redhat.com>
In-Reply-To: <20220127114536.1121765-1-mlichvar@redhat.com>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the physical clock supports cross timestamping (it has the
getcrosststamp() function), provide a wrapper in the virtual clock to
enable cross timestamping.

This adds support for the PTP_SYS_OFFSET_PRECISE ioctl.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_vclock.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 2f0b46386176..cb179a3ea508 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -95,6 +95,28 @@ static int ptp_vclock_settime(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
+				     struct system_device_crosststamp *xtstamp)
+{
+	struct ptp_vclock *vclock = info_to_vclock(ptp);
+	struct ptp_clock *pptp = vclock->pclock;
+	unsigned long flags;
+	int err;
+	u64 ns;
+
+	err = pptp->info->getcrosststamp(pptp->info, xtstamp);
+	if (err)
+		return err;
+
+	spin_lock_irqsave(&vclock->lock, flags);
+	ns = timecounter_cyc2time(&vclock->tc, ktime_to_ns(xtstamp->device));
+	spin_unlock_irqrestore(&vclock->lock, flags);
+
+	xtstamp->device = ns_to_ktime(ns);
+
+	return 0;
+}
+
 static long ptp_vclock_refresh(struct ptp_clock_info *ptp)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
@@ -150,6 +172,8 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 		vclock->info.gettimex64 = ptp_vclock_gettimex;
 	else
 		vclock->info.gettime64 = ptp_vclock_gettime;
+	if (pclock->info->getcrosststamp)
+		vclock->info.getcrosststamp = ptp_vclock_getcrosststamp;
 	vclock->cc = ptp_vclock_cc;
 
 	snprintf(vclock->info.name, PTP_CLOCK_NAME_LEN, "ptp%d_virt",
-- 
2.34.1

