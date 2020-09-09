Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1402D263445
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIIRR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:17:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730136AbgIIP2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599665241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gs37dOVi+JtPJIOcRlbiuS4yc0tVwgOrDIKR6DvjZsg=;
        b=ELo1IuN3W69uOF1bLLhAiv0JEr7VDU6Uux4mX5t2cxEI48o4aoO9tqn2/5NYSt0sFE2BPv
        fehbmx3yZ3+WsinZUfwfMUbuCoY0/OzcMxIDRLhxOR8ToGiB/IB4VvoqTf/cJz9wy8nrFe
        w1iITctnUoSsk6sNK0HifwM2mDyZ74I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-TXrChhS4M9CSP5cyc0jy3Q-1; Wed, 09 Sep 2020 11:09:06 -0400
X-MC-Unique: TXrChhS4M9CSP5cyc0jy3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96B2C873084;
        Wed,  9 Sep 2020 15:09:04 +0000 (UTC)
Received: from wsfd-advnetlab06.anl.lab.eng.bos.redhat.com (wsfd-advnetlab06.anl.lab.eng.bos.redhat.com [10.19.107.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 277E027BD2;
        Wed,  9 Sep 2020 15:09:03 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com
Subject: [RFC][Patch v1 1/3] sched/isolation: API to get num of hosekeeping CPUs
Date:   Wed,  9 Sep 2020 11:08:16 -0400
Message-Id: <20200909150818.313699-2-nitesh@redhat.com>
In-Reply-To: <20200909150818.313699-1-nitesh@redhat.com>
References: <20200909150818.313699-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new API num_housekeeping_cpus(), that can be used to retrieve
the number of housekeeping CPUs by reading an atomic variable
__num_housekeeping_cpus. This variable is set from housekeeping_setup().

This API is introduced for the purpose of drivers that were previously
relying only on num_online_cpus() to determine the number of MSIX vectors
to create. In an RT environment with large isolated but a fewer
housekeeping CPUs this was leading to a situation where an attempt to
move all of the vectors corresponding to isolated CPUs to housekeeping
CPUs was failing due to per CPU vector limit.

If there are no isolated CPUs specified then the API returns the number
of all online CPUs.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 include/linux/sched/isolation.h |  7 +++++++
 kernel/sched/isolation.c        | 23 +++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cc9f393e2a70..94c25d956d8a 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -25,6 +25,7 @@ extern bool housekeeping_enabled(enum hk_flags flags);
 extern void housekeeping_affine(struct task_struct *t, enum hk_flags flags);
 extern bool housekeeping_test_cpu(int cpu, enum hk_flags flags);
 extern void __init housekeeping_init(void);
+extern unsigned int num_housekeeping_cpus(void);
 
 #else
 
@@ -46,6 +47,12 @@ static inline bool housekeeping_enabled(enum hk_flags flags)
 static inline void housekeeping_affine(struct task_struct *t,
 				       enum hk_flags flags) { }
 static inline void housekeeping_init(void) { }
+
+static unsigned int num_housekeeping_cpus(void)
+{
+	return num_online_cpus();
+}
+
 #endif /* CONFIG_CPU_ISOLATION */
 
 static inline bool housekeeping_cpu(int cpu, enum hk_flags flags)
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 5a6ea03f9882..7024298390b7 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -13,6 +13,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 static cpumask_var_t housekeeping_mask;
 static unsigned int housekeeping_flags;
+static atomic_t __num_housekeeping_cpus __read_mostly;
 
 bool housekeeping_enabled(enum hk_flags flags)
 {
@@ -20,6 +21,27 @@ bool housekeeping_enabled(enum hk_flags flags)
 }
 EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
+/*
+ * num_housekeeping_cpus() - Read the number of housekeeping CPUs.
+ *
+ * This function returns the number of available housekeeping CPUs
+ * based on __num_housekeeping_cpus which is of type atomic_t
+ * and is initialized at the time of the housekeeping setup.
+ */
+unsigned int num_housekeeping_cpus(void)
+{
+	unsigned int cpus;
+
+	if (static_branch_unlikely(&housekeeping_overridden)) {
+		cpus = atomic_read(&__num_housekeeping_cpus);
+		/* We should always have at least one housekeeping CPU */
+		BUG_ON(!cpus);
+		return cpus;
+	}
+	return num_online_cpus();
+}
+EXPORT_SYMBOL_GPL(num_housekeeping_cpus);
+
 int housekeeping_any_cpu(enum hk_flags flags)
 {
 	int cpu;
@@ -131,6 +153,7 @@ static int __init housekeeping_setup(char *str, enum hk_flags flags)
 
 	housekeeping_flags |= flags;
 
+	atomic_set(&__num_housekeeping_cpus, cpumask_weight(housekeeping_mask));
 	free_bootmem_cpumask_var(non_housekeeping_mask);
 
 	return 1;
-- 
2.27.0

