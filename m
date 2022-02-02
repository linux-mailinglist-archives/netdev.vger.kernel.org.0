Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274844A6DDD
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245501AbiBBJeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:34:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22927 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245490AbiBBJeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:34:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643794449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCQxt+DlrP6jBps06XU6yTGWy1bywWrL1evURxYuoGM=;
        b=aF6nw/vbacBxmFAFDlm5ehcZbdjar36XxgKvuMtZUE+n4Y00h3gwbDe/e1nqNyE/Isdw2u
        7Ue5RIHExkVeoGuGekDGmSgcYQcPrFvrn1chOCIqgiPsxOrPRgPMJ/EBs4JPh/vuRg2ry9
        uZVJc6AB8viADkS0ZiIItaTIl0ad6Xk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-W9TKzwSWOtC_TofEFZXtdg-1; Wed, 02 Feb 2022 04:34:07 -0500
X-MC-Unique: W9TKzwSWOtC_TofEFZXtdg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8DB58144E2;
        Wed,  2 Feb 2022 09:34:06 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD013E2C1;
        Wed,  2 Feb 2022 09:34:05 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCHv2 net-next 2/4] ptp: increase maximum adjustment of virtual clocks.
Date:   Wed,  2 Feb 2022 10:33:56 +0100
Message-Id: <20220202093358.1341391-3-mlichvar@redhat.com>
In-Reply-To: <20220202093358.1341391-1-mlichvar@redhat.com>
References: <20220202093358.1341391-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the maximum frequency offset of virtual clocks to 50% to enable
faster slewing corrections.

This value cannot be represented as scaled ppm when long has 32 bits,
but that is already the case for other drivers, even those that provide
the adjfine() function, i.e. 32-bit applications are expected to check
for the limit.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/ptp/ptp_vclock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index ab1d233173e1..5aa2b32d9dc7 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -84,8 +84,7 @@ static long ptp_vclock_refresh(struct ptp_clock_info *ptp)
 static const struct ptp_clock_info ptp_vclock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "ptp virtual clock",
-	/* The maximum ppb value that long scaled_ppm can support */
-	.max_adj	= 32767999,
+	.max_adj	= 500000000,
 	.adjfine	= ptp_vclock_adjfine,
 	.adjtime	= ptp_vclock_adjtime,
 	.gettime64	= ptp_vclock_gettime,
-- 
2.34.1

