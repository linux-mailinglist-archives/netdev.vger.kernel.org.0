Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85BA49E172
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbiA0LqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:46:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240786AbiA0LqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:46:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643283966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDbTLHNTV72OAYvNxfm6AHdNXZ6OKHdc08mMN+K/M2g=;
        b=FMeXdiZzEGz39bdh7t6RphM/Db5rLKYyxFuSd4bHWyC32QL79M3FFiATZk1FFOCJldFKS1
        7DAJrfq9itw2HHOEvNBY5WZMW+U89WOOnZ0ChIxlHkQkQszsySMF8UnFIVvehKn8kfUp6O
        KUFZF3wJ9eJpurs4mEniZpRkt9rmIBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-BqH0NZfsPBeiSYBtx-DMWA-1; Thu, 27 Jan 2022 06:46:03 -0500
X-MC-Unique: BqH0NZfsPBeiSYBtx-DMWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37E1B839A42;
        Thu, 27 Jan 2022 11:46:02 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E89D6E4A9;
        Thu, 27 Jan 2022 11:45:55 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next 5/5] ptp: start virtual clocks at current system time.
Date:   Thu, 27 Jan 2022 12:45:36 +0100
Message-Id: <20220127114536.1121765-6-mlichvar@redhat.com>
In-Reply-To: <20220127114536.1121765-1-mlichvar@redhat.com>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a virtual clock is being created, initialize the timecounter to the
current system time instead of the Unix epoch to avoid very large steps
when the clock will be synchronized.

Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_vclock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index cb179a3ea508..5a24a5128013 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -187,7 +187,8 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 		return NULL;
 	}
 
-	timecounter_init(&vclock->tc, &vclock->cc, 0);
+	timecounter_init(&vclock->tc, &vclock->cc,
+			 ktime_to_ns(ktime_get_real()));
 	ptp_schedule_worker(vclock->clock, PTP_VCLOCK_REFRESH_INTERVAL);
 
 	return vclock;
-- 
2.34.1

