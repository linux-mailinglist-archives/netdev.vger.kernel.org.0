Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB63FC8B4
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKNOTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:19:16 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:40789 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfKNOTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 09:19:16 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iVFxe-00046J-A5; Thu, 14 Nov 2019 15:19:02 +0100
Date:   Thu, 14 Nov 2019 15:19:01 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jianyong Wu <jianyong.wu@arm.com>
cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
        will@kernel.org, suzuki.poulose@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
Subject: Re: [RFC PATCH v7 4/7] time: Add mechanism to recognize clocksource
 in time_get_snapshot
In-Reply-To: <20191114121358.6684-5-jianyong.wu@arm.com>
Message-ID: <alpine.DEB.2.21.1911141507010.2507@nanos.tec.linutronix.de>
References: <20191114121358.6684-1-jianyong.wu@arm.com> <20191114121358.6684-5-jianyong.wu@arm.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019, Jianyong Wu wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> In some scenario like return device time to ptp_kvm guest,
> we need identify the current clocksource outside core time code.
> A mechanism added to recognize the current clocksource
> by export clocksource id in time_get_snapshot.

Can you please replace that with the following:

 System time snapshots are not conveying information about the current
 clocksource which was used, but callers like the PTP KVM guest
 implementation have the requirement to evaluate the clocksource type to
 select the appropriate mechanism.

 Introduce a clocksource id field in struct clocksource which is by default
 set to CSID_GENERIC (0). Clocksource implementations can set that field to
 a value which allows to identify the clocksource.

 Store the clocksource id of the current clocksource in the
 system_time_snapshot so callers can evaluate which clocksource was used to
 take the snapshot and act accordingly.

> diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
> new file mode 100644
> index 000000000000..93bec8426c44
> --- /dev/null
> +++ b/include/linux/clocksource_ids.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_CLOCKSOURCE_IDS_H
> +#define _LINUX_CLOCKSOURCE_IDS_H
> +
> +/* Enum to give clocksources a unique identifier */
> +enum clocksource_ids {
> +	CSID_GENERIC		= 0,
> +	CSID_ARM_ARCH_COUNTER,

This should only add the infrastructure with just CSID_GENERIC in place.

The ARM_ARCH variant needs to come in a seperate patch which adds the enum
and uses it in the corresponding driver. Seperate means a patch doing only
that and nothing else, i.e. not hidden in some other patch which actually
makes use of it.

Thanks,

	tglx
