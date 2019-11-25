Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A785810913B
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbfKYPrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:47:51 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:50298 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728454AbfKYPru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:47:50 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iZGaS-00029Q-Ac; Mon, 25 Nov 2019 16:47:40 +0100
To:     Jianyong Wu <jianyong.wu@arm.com>
Subject: Re: [RFC PATCH v8 3/8] ptp: Reorganize =?UTF-8?Q?ptp=5Fkvm=20modu?=  =?UTF-8?Q?les=20to=20make=20it=20arch-independent=2E?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 Nov 2019 15:47:40 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <netdev@vger.kernel.org>, <yangbo.lu@nxp.com>,
        <john.stultz@linaro.org>, <tglx@linutronix.de>,
        <pbonzini@redhat.com>, <sean.j.christopherson@intel.com>,
        <richardcochran@gmail.com>, <mark.rutland@arm.com>,
        <will@kernel.org>, <suzuki.poulose@arm.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <steve.capper@arm.com>, <kaly.xin@arm.com>, <justin.he@arm.com>,
        <nd@arm.com>
In-Reply-To: <20191125104506.36850-4-jianyong.wu@arm.com>
References: <20191125104506.36850-1-jianyong.wu@arm.com>
 <20191125104506.36850-4-jianyong.wu@arm.com>
Message-ID: <a13a4f9554f36a46781308358fc63519@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, mark.rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, steve.capper@arm.com, kaly.xin@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-11-25 10:45, Jianyong Wu wrote:
> Currently, ptp_kvm modules implementation is only for x86 which 
> includs
> large part of arch-specific code.  This patch move all of those code
> into new arch related file in the same directory.
>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/ptp/Makefile                        |  1 +
>  drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 77 +++++-------------
>  drivers/ptp/ptp_kvm_x86.c                   | 87 
> +++++++++++++++++++++
>  include/asm-generic/ptp_kvm.h               | 12 +++
>  4 files changed, 118 insertions(+), 59 deletions(-)
>  rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (63%)
>  create mode 100644 drivers/ptp/ptp_kvm_x86.c
>  create mode 100644 include/asm-generic/ptp_kvm.h

[...]

> diff --git a/include/asm-generic/ptp_kvm.h 
> b/include/asm-generic/ptp_kvm.h
> new file mode 100644
> index 000000000000..e5dd386f6664
> --- /dev/null
> +++ b/include/asm-generic/ptp_kvm.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + *  Virtual PTP 1588 clock for use with KVM guests
> + *
> + *  Copyright (C) 2019 ARM Ltd.

I think you should live the original copyright assignment here.
This really isn't anything new.

> + *  All Rights Reserved
> + */
> +
> +int kvm_arch_ptp_init(void);
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts);
> +int kvm_arch_ptp_get_crosststamp(unsigned long *cycle,
> +		struct timespec64 *tspec, void *cs);

Why is this include file in asm-generic? This isn't a kernel-wide API.

I think it should be sitting in drivers/ptp, as it is only shared 
between
the generic and arch-specific stuff.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
