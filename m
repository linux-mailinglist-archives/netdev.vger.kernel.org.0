Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F954A6DDC
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245494AbiBBJeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:34:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245490AbiBBJeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:34:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643794447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kvw3A4kLvM+9YuqN3GP+UKXZ/GE7uMv84QECUb/bI3s=;
        b=g3Jh4ciqkjiXKPyRCHmpOpG+hLfJ1KAlk7KuzxZBKX2cVIoac+vq0mXZ03pUzeh50WktJB
        /bovx0Bs0nyFSzza+thiWsD1eMGJ+77dWoP+DVCS2REuc+VgqaLC6xBre5NJC3eqkT9WJy
        FKcPeejrmoJ48GSt/2nASs94MHS2jNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-CsKocY41MfSVPGGS9fZIYA-1; Wed, 02 Feb 2022 04:34:06 -0500
X-MC-Unique: CsKocY41MfSVPGGS9fZIYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93D991124C42;
        Wed,  2 Feb 2022 09:34:05 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA871E2C1;
        Wed,  2 Feb 2022 09:34:00 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCHv2 net-next 1/4] ptp: unregister virtual clocks when unregistering physical clock.
Date:   Wed,  2 Feb 2022 10:33:55 +0100
Message-Id: <20220202093358.1341391-2-mlichvar@redhat.com>
In-Reply-To: <20220202093358.1341391-1-mlichvar@redhat.com>
References: <20220202093358.1341391-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When unregistering a physical clock which has some virtual clocks,
unregister the virtual clocks with it.

This fixes the following oops, which can be triggered by unloading
a driver providing a PTP clock when it has enabled virtual clocks:

BUG: unable to handle page fault for address: ffffffffc04fc4d8
Oops: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:ptp_vclock_read+0x31/0xb0
Call Trace:
 timecounter_read+0xf/0x50
 ptp_vclock_refresh+0x2c/0x50
 ? ptp_clock_release+0x40/0x40
 ptp_aux_kworker+0x17/0x30
 kthread_worker_fn+0x9b/0x240
 ? kthread_should_park+0x30/0x30
 kthread+0xe2/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/ptp/ptp_clock.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 0e4bc8b9329d..b6f2cfd15dd2 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -317,11 +317,18 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 }
 EXPORT_SYMBOL(ptp_clock_register);
 
+static int unregister_vclock(struct device *dev, void *data)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+
+	ptp_vclock_unregister(info_to_vclock(ptp->info));
+	return 0;
+}
+
 int ptp_clock_unregister(struct ptp_clock *ptp)
 {
 	if (ptp_vclock_in_use(ptp)) {
-		pr_err("ptp: virtual clock in use\n");
-		return -EBUSY;
+		device_for_each_child(&ptp->dev, NULL, unregister_vclock);
 	}
 
 	ptp->defunct = 1;
-- 
2.34.1

