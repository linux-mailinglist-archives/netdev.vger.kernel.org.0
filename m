Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7837303AB5
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 11:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404388AbhAZKtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 05:49:08 -0500
Received: from foss.arm.com ([217.140.110.172]:32954 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404244AbhAZKsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 05:48:23 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 105B3D6E;
        Tue, 26 Jan 2021 02:47:38 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.45.247])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B147F3F66B;
        Tue, 26 Jan 2021 02:47:36 -0800 (PST)
Date:   Tue, 26 Jan 2021 10:47:34 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Preemptible idr_alloc() in QRTR code
Message-ID: <20210126104734.GB80448@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When fuzzing arm64 with Syzkaller, I'm seeing some splats where
this_cpu_ptr() is used in the bowels of idr_alloc(), by way of
radix_tree_node_alloc(), in a preemptible context:

| BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor.1/32582
| caller is debug_smp_processor_id+0x24/0x30
| CPU: 3 PID: 32582 Comm: syz-executor.1 Not tainted 5.11.0-rc4-next-20210125-00001-gf57e7edf910d #3
| Hardware name: linux,dummy-virt (DT)
| Call trace:
|  dump_backtrace+0x0/0x4a8
|  show_stack+0x34/0x88
|  dump_stack+0x1d4/0x2a0
|  check_preemption_disabled+0x1b8/0x210
|  debug_smp_processor_id+0x24/0x30
|  radix_tree_node_alloc.constprop.17+0x26c/0x3d0
|  radix_tree_extend+0x200/0x420
|  idr_get_free+0x63c/0xa38
|  idr_alloc_u32+0x164/0x2a0
|  __qrtr_bind.isra.8+0x350/0x658
|  qrtr_bind+0x18c/0x218
|  __sys_bind+0x1fc/0x238
|  __arm64_sys_bind+0x78/0xb0
|  el0_svc_common+0x1ac/0x4c8
|  do_el0_svc+0xfc/0x150
|  el0_svc+0x24/0x38
|  el0_sync_handler+0x134/0x180
|  el0_sync+0x154/0x180

It's not clear to me whether this is a bug in the caller or a bug the
implementation of idr_alloc(). The kerneldoc for idr_alloc() mentions
that callers must provide their own locking (and in this case a mutex is
used), but doesn't mention that preemption must be disabled.

Is this an intentional requirement that's simply missing from the
documentation and requires a change to the QRTR code, or is this
something to fix within the bowels of idr_alloc() and its callees?

Thanks,
Mark.
