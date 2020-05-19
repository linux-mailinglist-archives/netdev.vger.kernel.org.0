Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24FD81DA588
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgESX3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:29:22 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:65261 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESX3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1589930961; x=1621466961;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=tsY3KKFSv8tIe/IlzAFXH+9mav4/7deKA0fP8gv9p2Q=;
  b=vmMjaxgHOywhPJlAoNX9xeMAU8OPxh5hG+wSL9v+0UCtVxxJpwgckF4x
   Kmf2XF7s3XGF6YSf1agN9mq5SGKNLPB4UaWDnGLwyeNMqu/8KtbY0DdXC
   uAEq2LkXD9Ka1KN4wP/16mThzWMdBa3MRkJScJepwGftD4nb47gOYnKMG
   k=;
IronPort-SDR: OuWSF/7THtiGViFkEIVnxtJ6/3N1YwtQJST5wNdhAbY4Qz78HugXzY7+6VAKZad4uN2yJc0PFS
 vqxB8NkWeCbg==
X-IronPort-AV: E=Sophos;i="5.73,411,1583193600"; 
   d="scan'208";a="31244299"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 19 May 2020 23:29:20 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 5678B2410A6;
        Tue, 19 May 2020 23:29:13 +0000 (UTC)
Received: from EX13D05UWC001.ant.amazon.com (10.43.162.82) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:28:55 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC001.ant.amazon.com (10.43.162.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 19 May 2020 23:28:55 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 19 May 2020 23:28:55 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 5905D40712; Tue, 19 May 2020 23:28:55 +0000 (UTC)
Date:   Tue, 19 May 2020 23:28:55 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.com>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwmw@amazon.co.uk>,
        <benh@kernel.crashing.org>
Subject: [PATCH 09/12] x86/xen: save and restore steal clock
Message-ID: <6f39a1594a25ab5325f34e1e297900d699cd92bf.1589926004.git.anchalag@amazon.com>
References: <cover.1589926004.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1589926004.git.anchalag@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Munehisa Kamata <kamatam@amazon.com>

Save steal clock values of all present CPUs in the system core ops
suspend callbacks. Also, restore a boot CPU's steal clock in the system
core resume callback. For non-boot CPUs, restore after they're brought
up, because runstate info for non-boot CPUs are not active until then.

Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 arch/x86/xen/suspend.c | 13 ++++++++++++-
 arch/x86/xen/time.c    |  3 +++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/suspend.c b/arch/x86/xen/suspend.c
index 784c4484100b..dae0f74f5390 100644
--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -91,12 +91,20 @@ void xen_arch_suspend(void)
 static int xen_syscore_suspend(void)
 {
 	struct xen_remove_from_physmap xrfp;
-	int ret;
+	int cpu, ret;
 
 	/* Xen suspend does similar stuffs in its own logic */
 	if (xen_suspend_mode_is_xen_suspend())
 		return 0;
 
+	for_each_present_cpu(cpu) {
+		/*
+		 * Nonboot CPUs are already offline, but the last copy of
+		 * runstate info is still accessible.
+		 */
+		xen_save_steal_clock(cpu);
+	}
+
 	xrfp.domid = DOMID_SELF;
 	xrfp.gpfn = __pa(HYPERVISOR_shared_info) >> PAGE_SHIFT;
 
@@ -118,6 +126,9 @@ static void xen_syscore_resume(void)
 
 	pvclock_resume();
 
+	/* Nonboot CPUs will be resumed when they're brought up */
+	xen_restore_steal_clock(smp_processor_id());
+
 	gnttab_resume();
 }
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index c8897aad13cd..33d754564b09 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -545,6 +545,9 @@ static void xen_hvm_setup_cpu_clockevents(void)
 {
 	int cpu = smp_processor_id();
 	xen_setup_runstate_info(cpu);
+	if (cpu)
+		xen_restore_steal_clock(cpu);
+
 	/*
 	 * xen_setup_timer(cpu) - snprintf is bad in atomic context. Hence
 	 * doing it xen_hvm_cpu_notify (which gets called by smp_init during
-- 
2.24.1.AMZN

