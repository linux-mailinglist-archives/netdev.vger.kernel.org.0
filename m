Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551CB212C48
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 20:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgGBSYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 14:24:05 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:64061 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgGBSYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 14:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1593714244; x=1625250244;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=8xWBYHNSqyc0rRCT8ma4wuwSS0bbWLxvstPp4v8IEIQ=;
  b=dKwhQogBiG38kRTV9cIxd2hom5FJS8v1BFqS6UlOfR57ptUdWzxE/iiV
   mTxaYJTeEdY9x/aImJn/3xuLNCyKdhwBR3jGW7U/JorU0bhdpGqCosQEg
   Ncys7NAKZfTYovy7dr2XjxoPh7UQpVSQhu/var/BACXMorIbV8yq9HCm8
   8=;
IronPort-SDR: sDAToUmcQVKVwVu9eMz0u6grcT4hSIwmjgpl1XIY45YPsfIMhKSq5/2gBLD4pbIvjcoFAEP58A
 Z+Jgig/wdQNw==
X-IronPort-AV: E=Sophos;i="5.75,305,1589241600"; 
   d="scan'208";a="39714105"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 02 Jul 2020 18:24:03 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 23592A25CA;
        Thu,  2 Jul 2020 18:23:55 +0000 (UTC)
Received: from EX13D05UWC001.ant.amazon.com (10.43.162.82) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 18:23:37 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D05UWC001.ant.amazon.com (10.43.162.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 2 Jul 2020 18:23:37 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 2 Jul 2020 18:23:37 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 5F90C40844; Thu,  2 Jul 2020 18:23:37 +0000 (UTC)
Date:   Thu, 2 Jul 2020 18:23:37 +0000
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
Subject: [PATCH v2 11/11] PM / hibernate: update the resume offset on
 SNAPSHOT_SET_SWAP_AREA
Message-ID: <20200702182337.GA3762@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <cover.1593665947.git.anchalag@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1593665947.git.anchalag@amazon.com>
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

[Anchal Agarwal: Changelog: Resolved patch conflict as code fragmented to
snapshot_set_swap_area]

Signed-off-by: Aleksei Besogonov <cyberax@amazon.com>
Signed-off-by: Munehisa Kamata <kamatam@amazon.com>
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
---
 kernel/power/user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index d5eedc2baa2a..e1209cefc103 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -242,8 +242,12 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
 		return -EINVAL;
 	}
 	data->swap = swap_type_of(swdev, offset, &bdev);
-	if (data->swap < 0)
+	if (data->swap < 0) {
 		return -ENODEV;
+	} else {
+		swsusp_resume_device = swdev;
+		swsusp_resume_block = offset;
+	}
 
 	data->bd_inode = bdev->bd_inode;
 	bdput(bdev);
-- 
2.20.1

