Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F31727B49E
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgI1SgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726500AbgI1SgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:36:20 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601318178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=iL0bUDw4mzTbRn0mPQir1H2iMDlMMQuuu3RzcEtjrtI=;
        b=I0UWEWPBKgynHrcG7x2mu74D7cUGGhIH07sUiUIgCvO+RxHn0oECHJcdAz/qykeoZSLXYE
        dQEbHqQv94xAD9AEYUdOBaEWQnbr9vKu4ugqD68pk4Gcd9653Mo9t/2cXxvIXWGAJJUIMF
        RhYyiK4uq0U8qoO53vsl3GEvXM6FsAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-QOoB4A-NNji0hBs9kJXzaw-1; Mon, 28 Sep 2020 14:36:14 -0400
X-MC-Unique: QOoB4A-NNji0hBs9kJXzaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28462ADC25;
        Mon, 28 Sep 2020 18:36:08 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E07860C13;
        Mon, 28 Sep 2020 18:36:06 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, nitesh@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: [PATCH v4 1/4] sched/isolation: API to get number of housekeeping CPUs
Date:   Mon, 28 Sep 2020 14:35:26 -0400
Message-Id: <20200928183529.471328-2-nitesh@redhat.com>
In-Reply-To: <20200928183529.471328-1-nitesh@redhat.com>
References: <20200928183529.471328-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new API housekeeping_num_online_cpus(), that can be used to
retrieve the number of online housekeeping CPUs based on the housekeeping
flag passed by the caller.

Some of the consumers for this API are the device drivers that were
previously relying only on num_online_cpus() to determine the number of
MSIX vectors to create. In real-time environments to minimize interruptions
to isolated CPUs, all device-specific IRQ vectors are often moved to the
housekeeping CPUs, having excess vectors could cause housekeeping CPU to
run out of IRQ vectors.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 include/linux/sched/isolation.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cc9f393e2a70..e021b1846c1d 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -57,4 +57,13 @@ static inline bool housekeeping_cpu(int cpu, enum hk_flags flags)
 	return true;
 }
 
+static inline unsigned int housekeeping_num_online_cpus(enum hk_flags flags)
+{
+#ifdef CONFIG_CPU_ISOLATION
+	if (static_branch_unlikely(&housekeeping_overridden))
+		return cpumask_weight(housekeeping_cpumask(flags));
+#endif
+	return num_online_cpus();
+}
+
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.18.2

