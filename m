Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E894A275F93
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgIWSRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:17:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726667AbgIWSRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 14:17:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600885060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=0T1Uh3UwpP4BgdwzDRoRFpQxgh2o5L+P6husKrn72sA=;
        b=ZXLonv/6mMeyq8A8sZHsbLO2IN29o66hDnZkbPEZ5RCrSZP7VX6+Xs5X3Uoch0C8bJV+Z2
        qhIncgtGzSnyejapbsOMu3SO+cPf7KhDYVslmKtYe+AJJZIS6XBNeAoKj4jUTI84cCEFz1
        PqSBN46gW+HMDWoNyArJla7uyPJPXIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-0cfgVWp3PuyEcRa8Ao44zg-1; Wed, 23 Sep 2020 14:17:37 -0400
X-MC-Unique: 0cfgVWp3PuyEcRa8Ao44zg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5F3164094;
        Wed, 23 Sep 2020 18:17:34 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE4DD5C1C7;
        Wed, 23 Sep 2020 18:17:32 +0000 (UTC)
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
Subject: [PATCH v2 2/4] sched/isolation: Extend nohz_full to isolate managed IRQs
Date:   Wed, 23 Sep 2020 14:11:24 -0400
Message-Id: <20200923181126.223766-3-nitesh@redhat.com>
In-Reply-To: <20200923181126.223766-1-nitesh@redhat.com>
References: <20200923181126.223766-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend nohz_full feature set to include isolation from managed IRQS. This
is required specifically for setups that only uses nohz_full and still
requires isolation for maintaining lower latency for the listed CPUs.

Having this change will ensure that the kernel functions that were using
HK_FLAG_MANAGED_IRQ to derive cpumask for pinning various jobs/IRQs do not
enqueue anything on the CPUs listed under nohz_full.

Suggested-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 kernel/sched/isolation.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 5a6ea03f9882..9df9598a9e39 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -141,7 +141,7 @@ static int __init housekeeping_nohz_full_setup(char *str)
 	unsigned int flags;
 
 	flags = HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER | HK_FLAG_RCU |
-		HK_FLAG_MISC | HK_FLAG_KTHREAD;
+		HK_FLAG_MISC | HK_FLAG_KTHREAD | HK_FLAG_MANAGED_IRQ;
 
 	return housekeeping_setup(str, flags);
 }
-- 
2.18.2

