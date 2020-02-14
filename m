Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACEB15FA9D
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBNX2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:28:37 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:1236 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727976AbgBNX2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 18:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1581722917; x=1613258917;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=XFd2LTl25ne3kMWrL/YPna7uVttvsKNxoFQR8TCvE9E=;
  b=m0a62/lKKLCqMlQYPcsCumDyvtuTauNQVD6L5UwkutcOiVZvd078XFM8
   DlDNWxn5Xvj1kG7gqOKOJNpPw3+ZVsKfayPQd8MhIHUb68E8Jh42wok7P
   HOkZIEbFOF/8UjAerb3YePdKAakmk+Ikxw7g+Qo/HpVw3ZFOFQtqklxMz
   w=;
IronPort-SDR: Uq4xL82dqRbjGX7NdFvnD6eSDrEZWhgkJv2ITzh9uXV0XvYsU1YnSahYNjBZ0qyDvhYKBxVhJc
 Teid1lqAMnhQ==
X-IronPort-AV: E=Sophos;i="5.70,442,1574121600"; 
   d="scan'208";a="26559030"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 14 Feb 2020 23:28:35 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 3AFE1A23FF;
        Fri, 14 Feb 2020 23:28:27 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:28:07 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 14 Feb 2020 23:28:07 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1236.3 via Frontend Transport; Fri, 14 Feb 2020 23:28:07 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 500DF4028E; Fri, 14 Feb 2020 23:28:07 +0000 (UTC)
Date:   Fri, 14 Feb 2020 23:28:07 +0000
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
        <fllinden@amaozn.com>, <benh@kernel.crashing.org>
Subject: [RFC PATCH v3 12/12] PM / hibernate: update the resume offset on
 SNAPSHOT_SET_SWAP_AREA
Message-ID: <4659d20be8f27e40ef39adfa06b0c759c2d6cd78.1581721799.git.anchalag@amazon.com>
References: <cover.1581721799.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1581721799.git.anchalag@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksei Besogonov <cyberax@amazon.com>

The SNAPSHOT_SET_SWAP_AREA is supposed to be used to set the hibernation
offset on a running kernel to enable hibernating to a swap file.
However, it doesn't actually update the swsusp_resume_block variable. As
a result, the hibernation fails at the last step (after all the data is
written out) in the validation of the swap signature in
mark_swapfiles().

Before this patch, the command line processing was the only place where
swsusp_resume_block was set.

Signed-off-by: Aleksei Besogonov <cyberax@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 kernel/power/user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index 77438954cc2b..d396e313cb7b 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -374,8 +374,12 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			if (swdev) {
 				offset = swap_area.offset;
 				data->swap = swap_type_of(swdev, offset, NULL);
-				if (data->swap < 0)
+				if (data->swap < 0) {
 					error = -ENODEV;
+				} else {
+					swsusp_resume_device = swdev;
+					swsusp_resume_block = offset;
+				}
 			} else {
 				data->swap = -1;
 				error = -EINVAL;
-- 
2.24.1.AMZN

