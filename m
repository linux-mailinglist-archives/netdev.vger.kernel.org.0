Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3027904E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgIYS1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729725AbgIYS1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:27:12 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601058431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=iL0bUDw4mzTbRn0mPQir1H2iMDlMMQuuu3RzcEtjrtI=;
        b=dgpuCv+8dB6wxiu6EDvBDFqYvs+Rq3+h90h6S8oZKWh4C/vW4cToCXEsoX9c2pGZfSAYRL
        jENKoGxIRlnx/rIwWT3xHoXe7VhHC43uS1MhGs8fgWudsRXxLSjj79FUYg0/S+ASKv7wd6
        VTxUxugKJTtsaGKv199QuVinsdoawm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-wptPqlM6OdSLHFgjXOJGwA-1; Fri, 25 Sep 2020 14:27:07 -0400
X-MC-Unique: wptPqlM6OdSLHFgjXOJGwA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B23E1084C97;
        Fri, 25 Sep 2020 18:27:05 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA0A578831;
        Fri, 25 Sep 2020 18:27:03 +0000 (UTC)
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
Subject: [PATCH v3 1/4] sched/isolation: API to get number of housekeeping CPUs
Date:   Fri, 25 Sep 2020 14:26:51 -0400
Message-Id: <20200925182654.224004-2-nitesh@redhat.com>
In-Reply-To: <20200925182654.224004-1-nitesh@redhat.com>
References: <20200925182654.224004-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

