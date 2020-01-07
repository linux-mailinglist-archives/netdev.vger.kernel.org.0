Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68E313378B
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 00:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbgAGXkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 18:40:21 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:10701 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgAGXkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 18:40:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578440421; x=1609976421;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=fKBHoK09YZBwiKXNN6RfSgjFeH+5bNsX0xukKXYpamw=;
  b=jtucKk9KpH1S+Gr6UTTFJA3H6DCGSi9EwFkg6puLDX3NzKrkR1YoS5yo
   QlEpLYn1XW2pQWeAXOh6TxZcOvZTAYIlZUvZcYotpj4hcr4qT7C679aj/
   ltKBcPJ+wNO6rtP0Sw16gS/g/yBn+6y++a0pphXSK+jAUMcy7oHjJQwVQ
   s=;
IronPort-SDR: +5WXZR3aQI5IaNTfkU7fCO+qrdocNvSC8Btqi8thp07FiCmMP6fRqrvnOSUa1k56Gzc7llX4Wq
 QvHj7bPazjDg==
X-IronPort-AV: E=Sophos;i="5.69,407,1571702400"; 
   d="scan'208";a="17325704"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 07 Jan 2020 23:40:10 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id E3EF9C2E0A;
        Tue,  7 Jan 2020 23:40:07 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:39:47 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 7 Jan 2020 23:39:47 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1236.3 via Frontend Transport; Tue, 7 Jan 2020 23:39:47 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id E3FD440E65; Tue,  7 Jan 2020 23:39:46 +0000 (UTC)
Date:   Tue, 7 Jan 2020 23:39:46 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <boris.ostrovsky@oracle.com>,
        <jgross@suse.com>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, <kamatam@amazon.com>,
        <sstabellini@kernel.org>, <konrad.wilk@oracle.co>,
        <roger.pau@citrix.com>, <axboe@kernel.dk>, <davem@davemloft.net>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <peterz@infradead.org>, <eduval@amazon.com>, <sblbir@amazon.com>,
        <anchalag@amazon.com>, <xen-devel@lists.xenproject.org>,
        <vkuznets@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        <dwmw@amazon.co.uk>, <fllinden@amaozn.com>
CC:     <anchalag@amazon.com>
Subject: [RFC PATCH V2 03/11] x86/xen: Introduce new function to map
Message-ID: <20200107233946.GA18143@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a small function which re-uses shared page's PA allocated
during guest initialization time in reserve_shared_info() and not
allocate new page during resume flow.
It also  does the mapping of shared_info_page by calling
xen_hvm_init_shared_info() to use the function.

Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 arch/x86/xen/enlighten_hvm.c | 7 +++++++
 arch/x86/xen/xen-ops.h       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index e138f7de52d2..75b1ec7a0fcd 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -27,6 +27,13 @@
 
 static unsigned long shared_info_pfn;
 
+void xen_hvm_map_shared_info(void)
+{
+	xen_hvm_init_shared_info();
+	if (shared_info_pfn)
+		HYPERVISOR_shared_info = __va(PFN_PHYS(shared_info_pfn));
+}
+
 void xen_hvm_init_shared_info(void)
 {
 	struct xen_add_to_physmap xatp;
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 45a441c33d6d..d84c357994bd 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -56,6 +56,7 @@ void xen_enable_syscall(void);
 void xen_vcpu_restore(void);
 
 void xen_callback_vector(void);
+void xen_hvm_map_shared_info(void);
 void xen_hvm_init_shared_info(void);
 void xen_unplug_emulated_devices(void);
 
-- 
2.15.3.AMZN

