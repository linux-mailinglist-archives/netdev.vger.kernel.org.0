Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02954274A7C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgIVU6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIVU6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 16:58:09 -0400
Received: from localhost (lfbn-ncy-1-588-162.w81-51.abo.wanadoo.fr [81.51.203.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6503623600;
        Tue, 22 Sep 2020 20:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600808288;
        bh=TAvOwxdUSSf8dMLys+bd/PzI7Tqp/e7DVoXkrTOUAiI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qj13ocgnkXJAez0TGZR3gQzFaRpUp8hb6SZtLcZ+PxAr+4PzcI5QwU8Jjf5wbgjzl
         7Tr7hS5Muy52iGsanhGHHpU6A2UWkmI7QeZwOU0nH6M7qHcoOC539vS+i2dZF2eHxi
         q4bZ5SoYnZ3KPN/P13yJbNL5RRWMHMysML8FKMYc=
Date:   Tue, 22 Sep 2020 22:58:06 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jerinj@marvell.com, mathias.nyman@intel.com, jiri@nvidia.com
Subject: Re: [RFC][Patch v1 1/3] sched/isolation: API to get num of
 hosekeeping CPUs
Message-ID: <20200922205805.GD5217@lenoir>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-2-nitesh@redhat.com>
 <20200921234044.GA31047@lenoir>
 <fd48e554-6a19-f799-b273-e814e5389db9@redhat.com>
 <20200922100817.GB5217@lenoir>
 <b0608566-21c6-8fc9-4615-aa00099f6d04@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0608566-21c6-8fc9-4615-aa00099f6d04@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 09:50:55AM -0400, Nitesh Narayan Lal wrote:
> On 9/22/20 6:08 AM, Frederic Weisbecker wrote:
> TBH I don't have a very strong case here at the moment.
> But still, IMHO, this will force the user to have both managed irqs and
> nohz_full in their environments to avoid these kinds of issues. Is that how
> we would like to proceed?

Yep that sounds good to me. I never know how much we want to split each and any
of the isolation features but I'd rather stay cautious to separate HK_FLAG_TICK
from the rest, just in case running in nohz_full mode ever becomes interesting
alone for performance and not just latency/isolation.

But look what you can do as well:

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


"nohz_full=" has historically gathered most wanted isolation features. It can
as well isolate managed irqs.


> > And then can we rename it to housekeeping_num_online()?
> 
> It could be just me, but does something like hk_num_online_cpus() makes more
> sense here?

Sure, that works as well.

Thanks.
