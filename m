Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5030549EF15
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344004AbiA0X6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:58:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:60126 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229658AbiA0X6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 18:58:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643327883; x=1674863883;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=fpwF/2DVAAP8AAH04cnzwc4Y7K3i/YIceEmdmUOEQmE=;
  b=RQtr5/yo6A2CHhhaCPEDG5V/nHZgEBIT3iW+hN60CneUNHb0ITnihxO7
   GB2NKHpTY3zGofpLHlLEai4lKN/aAtWhDxtIfkMuLF9ZtbwRnSjZHtj1w
   IOPMarpwJjAfSYPo1TQ7e6DOETlHGoeABbU0FhdkIyZtEAlms6Ml9B7Cc
   wuE/ov7Hu7oaDCVl7CyRWXB5MyEHvPTkprhIZfKSA4H7SO+HBvCjExJqa
   rl1OeTzs6n8oioE9gb63bGBlbI8EQPXGYqwXLHvomshvD319dyHgBhQaG
   7NgGgv2GMXr+bCqP2DDcW0KES/dao8Vg9KlsbSY/xqN2INZWZ/gQ0Mqu8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="310311526"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="310311526"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 15:58:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="535896348"
Received: from rlward-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.255.84])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 15:58:02 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>, netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 1/5] ptp: unregister virtual clocks when
 unregistering physical clock.
In-Reply-To: <20220127114536.1121765-2-mlichvar@redhat.com>
References: <20220127114536.1121765-1-mlichvar@redhat.com>
 <20220127114536.1121765-2-mlichvar@redhat.com>
Date:   Thu, 27 Jan 2022 15:58:02 -0800
Message-ID: <87czkcn33p.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miroslav Lichvar <mlichvar@redhat.com> writes:

> When unregistering a physical clock which has some virtual clocks,
> unregister the virtual clocks with it.
>
> This fixes the following oops, which can be triggered by unloading
> a driver providing a PTP clock when it has enabled virtual clocks:
>
> BUG: unable to handle page fault for address: ffffffffc04fc4d8
> Oops: 0000 [#1] PREEMPT SMP NOPTI
> RIP: 0010:ptp_vclock_read+0x31/0xb0
> Call Trace:
>  timecounter_read+0xf/0x50
>  ptp_vclock_refresh+0x2c/0x50
>  ? ptp_clock_release+0x40/0x40
>  ptp_aux_kworker+0x17/0x30
>  kthread_worker_fn+0x9b/0x240
>  ? kthread_should_park+0x30/0x30
>  kthread+0xe2/0x110
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork+0x22/0x30
>
> Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
> Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
> Cc: Yangbo Lu <yangbo.lu@nxp.com>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> ---

I am not against this change, but I think this problem was discussed
before and the suggestions were to fix it differently:

https://lore.kernel.org/all/20210807144332.szyazdfl42abwzmd@skbuf/


Cheers,
-- 
Vinicius
