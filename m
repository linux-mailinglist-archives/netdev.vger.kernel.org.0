Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5913275F9D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgIWSSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:18:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726460AbgIWSRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:17:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600885057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=7UUuowF4weSLiWMwKfPo+YyNGAQzoPK/8GZlRbYkNkk=;
        b=KA3VRitDiP+qno/A4DjahMLAfJpwGzfsLcQQv5H5B1iKss+5UG5ohjZRXw3rH42GTwxLpr
        OA+1ggs6/ViRSkyaTX7N/zaGRNVNyijgDanDjyf98XwlwPm8bZhjv5zOz6lOfbAvjUUr/I
        VVLLcrqUkvhd33Q8qmAX2ALdbvV6rSA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-MU8ey5c0MkewCvWXYfJEOw-1; Wed, 23 Sep 2020 14:17:35 -0400
X-MC-Unique: MU8ey5c0MkewCvWXYfJEOw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3350802B70;
        Wed, 23 Sep 2020 18:17:32 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDE755C1C7;
        Wed, 23 Sep 2020 18:17:30 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, nitesh@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com,
        mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org
Subject: [PATCH v2 1/4] sched/isolation: API to get housekeeping online CPUs
Date:   Wed, 23 Sep 2020 14:11:23 -0400
Message-Id: <20200923181126.223766-2-nitesh@redhat.com>
In-Reply-To: <20200923181126.223766-1-nitesh@redhat.com>
References: <20200923181126.223766-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new API hk_num_online_cpus(), that can be used to
retrieve the number of online housekeeping CPUs that are meant to handle
managed IRQ jobs.

This API is introduced for the drivers that were previously relying only
on num_online_cpus() to determine the number of MSIX vectors to create.
In an RT environment with large isolated but fewer housekeeping CPUs this
was leading to a situation where an attempt to move all of the vectors
corresponding to isolated CPUs to housekeeping CPUs were failing due to
per CPU vector limit.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 include/linux/sched/isolation.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cc9f393e2a70..2e96b626e02e 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -57,4 +57,17 @@ static inline bool housekeeping_cpu(int cpu, enum hk_flags flags)
 	return true;
 }
 
+static inline unsigned int hk_num_online_cpus(void)
+{
+#ifdef CONFIG_CPU_ISOLATION
+	const struct cpumask *hk_mask;
+
+	if (static_branch_unlikely(&housekeeping_overridden)) {
+		hk_mask = housekeeping_cpumask(HK_FLAG_MANAGED_IRQ);
+		return cpumask_weight(hk_mask);
+	}
+#endif
+	return cpumask_weight(cpu_online_mask);
+}
+
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.18.2

