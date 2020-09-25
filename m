Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC547279047
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgIYS1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:27:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbgIYS1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:27:12 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601058431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=yrgq/KDevcEQJ6jt8mLwCRUIhO0cbeAMHgxfCLcgTj0=;
        b=eQucHJhxTzAFYrMf126p7iHOFLiqel4bOiWljTGYahNvmgWIZWac9RLXFaY5dYQuGfUpDf
        5JIHtumHIrL8qeV0gaC63dljdmgB3isr07y8dFEfItRkyuEiaoKqaXckW8kWyIV4JV17pg
        13/X59VDCZUNEye3CfhNE7rmEEoFJ7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-tQ7tu0ImMQCu12jq-NJWBw-1; Fri, 25 Sep 2020 14:27:09 -0400
X-MC-Unique: tQ7tu0ImMQCu12jq-NJWBw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 363341084C96;
        Fri, 25 Sep 2020 18:27:07 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 849337882D;
        Fri, 25 Sep 2020 18:27:05 +0000 (UTC)
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
Subject: [PATCH v3 2/4] sched/isolation: Extend nohz_full to isolate managed IRQs
Date:   Fri, 25 Sep 2020 14:26:52 -0400
Message-Id: <20200925182654.224004-3-nitesh@redhat.com>
In-Reply-To: <20200925182654.224004-1-nitesh@redhat.com>
References: <20200925182654.224004-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend nohz_full feature set to include isolation from managed IRQS. This
is required specifically for setups that only uses nohz_full and still
requires isolation for maintaining lower latency for the listed CPUs.

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

