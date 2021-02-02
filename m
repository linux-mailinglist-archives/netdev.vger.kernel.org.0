Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D370830BF4B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhBBNYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:24:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231670AbhBBNX4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:23:56 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B675B64F5D;
        Tue,  2 Feb 2021 13:23:14 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6veC-00BV0O-Nn; Tue, 02 Feb 2021 13:23:12 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Feb 2021 13:23:12 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, steven.price@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
Subject: Re: [PATCH v16 3/9] ptp: Reorganize ptp_kvm module to make it
 arch-independent.
In-Reply-To: <20201209060932.212364-4-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <20201209060932.212364-4-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <bd371ba17f40bd114b87f284f3537ec4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 06:09, Jianyong Wu wrote:
> Currently, ptp_kvm modules implementation is only for x86 which 
> includes
> large part of arch-specific code.  This patch moves all of this code
> into a new arch related file in the same directory.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  drivers/ptp/Makefile                        |  1 +
>  drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} | 84 +++++-------------
>  drivers/ptp/ptp_kvm_x86.c                   | 96 +++++++++++++++++++++
>  include/linux/ptp_kvm.h                     | 16 ++++
>  4 files changed, 135 insertions(+), 62 deletions(-)
>  rename drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c} (60%)
>  create mode 100644 drivers/ptp/ptp_kvm_x86.c
>  create mode 100644 include/linux/ptp_kvm.h
> 

[...]

> diff --git a/include/linux/ptp_kvm.h b/include/linux/ptp_kvm.h
> new file mode 100644
> index 000000000000..6f104b1967bb
> --- /dev/null
> +++ b/include/linux/ptp_kvm.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Virtual PTP 1588 clock for use with KVM guests
> + *
> + * Copyright (C) 2017 Red Hat Inc.
> + */
> +
> +#ifndef _PTP_KVM_H_
> +#define _PTP_KVM_H_
> +
> +int kvm_arch_ptp_init(void);
> +int kvm_arch_ptp_get_clock(struct timespec64 *ts);
> +int kvm_arch_ptp_get_crosststamp(u64 *cycle,
> +		struct timespec64 *tspec, struct clocksource **cs);

You probably want some forward declarations for timespec64 and
clocksource, so that this include file is standalone.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
