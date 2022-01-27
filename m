Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3D449E16E
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240781AbiA0Lpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:45:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240776AbiA0Lpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:45:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643283952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P1x/bsWZnepqjTHWiF0eiQUP2G8wsP+Rexb59jZRYaY=;
        b=a1v9p+ONVzdtsJXoxdgNnp467JsNp55BYklueEeI479SofAbaM5/n/k5iVKpYrgCZ1asG3
        Vj0n+84/20HyGFOmzblYBIj3kC4y5D7GvgRxLRoqDay6dGXV+T5O7TZ5GE8XyT+QQWbM0H
        pnH/JYgpm2gYs2C8Bjj9VD8DSmC7Imo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-npvD7r0ROie9C7n0iOtwvg-1; Thu, 27 Jan 2022 06:45:51 -0500
X-MC-Unique: npvD7r0ROie9C7n0iOtwvg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 584D01091DA0;
        Thu, 27 Jan 2022 11:45:50 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 960636E4B7;
        Thu, 27 Jan 2022 11:45:40 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next 2/5] ptp: increase maximum adjustment of virtual clocks.
Date:   Thu, 27 Jan 2022 12:45:33 +0100
Message-Id: <20220127114536.1121765-3-mlichvar@redhat.com>
In-Reply-To: <20220127114536.1121765-1-mlichvar@redhat.com>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
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

