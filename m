Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E967730C057
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhBBNzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:55:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233248AbhBBNwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:52:51 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F05B64FC8;
        Tue,  2 Feb 2021 13:43:50 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6vy8-00BVL3-Fe; Tue, 02 Feb 2021 13:43:48 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Feb 2021 13:43:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, steven.price@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
Subject: Re: [PATCH v16 8/9] doc: add ptp_kvm introduction for arm64 support
In-Reply-To: <20201209060932.212364-9-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
 <20201209060932.212364-9-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <abe1ea58ddd13e43e62c25103e05fcf0@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 06:09, Jianyong Wu wrote:
> PTP_KVM implementation depends on hypercall using SMCCC. So we
> introduce a new SMCCC service ID. This doc explains how does the
> ID define and how does PTP_KVM works on arm/arm64.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>  Documentation/virt/kvm/api.rst         |  9 +++++++
>  Documentation/virt/kvm/arm/index.rst   |  1 +
>  Documentation/virt/kvm/arm/ptp_kvm.rst | 31 +++++++++++++++++++++++
>  Documentation/virt/kvm/timekeeping.rst | 35 ++++++++++++++++++++++++++
>  4 files changed, 76 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst
> 
> diff --git a/Documentation/virt/kvm/api.rst 
> b/Documentation/virt/kvm/api.rst
> index e00a66d72372..3769cc2f7d9c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6390,3 +6390,12 @@ When enabled, KVM will disable paravirtual
> features provided to the
>  guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
>  (0x40000001). Otherwise, a guest may use the paravirtual features
>  regardless of what has actually been exposed through the CPUID leaf.
> +
> +8.27 KVM_CAP_PTP_KVM
> +--------------------
> +
> +:Architectures: arm64
> +
> +This capability indicates that KVM virtual PTP service is supported in 
> host.
> +It must company with the implementation of KVM virtual PTP service in 
> host
> +so VMM can probe if there is the service in host by checking this 
> capability.

This reads a bit odd. I came up with the following:

+This capability indicates that the KVM virtual PTP service is
+supported in the host. A VMM can check whether the service is
+available to the guest on migration.


> diff --git a/Documentation/virt/kvm/arm/index.rst
> b/Documentation/virt/kvm/arm/index.rst
> index 3e2b2aba90fc..78a9b670aafe 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -10,3 +10,4 @@ ARM
>     hyp-abi
>     psci
>     pvtime
> +   ptp_kvm
> diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst
> b/Documentation/virt/kvm/arm/ptp_kvm.rst
> new file mode 100644
> index 000000000000..d729c1388a5c
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
> @@ -0,0 +1,31 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +PTP_KVM support for arm/arm64
> +=============================
> +
> +PTP_KVM is used for time sync between guest and host in a high 
> precision.
> +It needs to get the wall time and counter value from the host and
> transfer these
> +to guest via hypercall service. So one more hypercall service has been 
> added.
> +
> +This new SMCCC hypercall is defined as:

It won't be new anymore the minute this is merged.

> +
> +* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001
> +
> +As both 32 and 64-bits ptp_kvm client should be supported, we choose
> SMC32/HVC32
> +calling convention.
> +
> +ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
> +
> +    =============    ==========    ==========
> +    Function ID:     (uint32)      0x86000001
> +    Arguments:       (uint32)      ARM_PTP_PHY_COUNTER(1) or
> ARM_PTP_VIRT_COUNTER(0)
> +                                   which indicate acquiring physical 
> counter or
> +                                   virtual counter respectively.
> +    Return Value:    val0(uint32)  NOT_SUPPORTED(-1) or upper 32 bits
> of wall clock time(64-bits).
> +                     val1(uint32)  Lower 32 bits of wall clock time.
> +                     val2(uint32)  Upper 32 bits of counter 
> cycle(64-bits).
> +                     val3(uint32)  Lower 32 bits of counter cycle.
> +    Endianness:                    No Restrictions.
> +    =============    ==========    ==========
> +
> +More info see section 5 in Documentation/virt/kvm/timekeeping.rst.

I've tidied this up like this:

diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst 
b/Documentation/virt/kvm/arm/ptp_kvm.rst
index d729c1388a5c..68cffb50d8bf 100644
--- a/Documentation/virt/kvm/arm/ptp_kvm.rst
+++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
@@ -3,29 +3,23 @@
  PTP_KVM support for arm/arm64
  =============================

-PTP_KVM is used for time sync between guest and host in a high 
precision.
-It needs to get the wall time and counter value from the host and 
transfer these
-to guest via hypercall service. So one more hypercall service has been 
added.
-
-This new SMCCC hypercall is defined as:
+PTP_KVM is used for high precision time sync between host and guests.
+It relies on transferring the wall clock and counter value from the
+host to the guest using a KVM-specific hypercall.

  * ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001

-As both 32 and 64-bits ptp_kvm client should be supported, we choose 
SMC32/HVC32
-calling convention.
-
-ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
+This hypercall uses the SMC32/HVC32 calling convention:

+ARM_SMCCC_HYP_KVM_PTP_FUNC_ID
      =============    ==========    ==========
      Function ID:     (uint32)      0x86000001
-    Arguments:       (uint32)      ARM_PTP_PHY_COUNTER(1) or 
ARM_PTP_VIRT_COUNTER(0)
-                                   which indicate acquiring physical 
counter or
-                                   virtual counter respectively.
-    Return Value:    val0(uint32)  NOT_SUPPORTED(-1) or upper 32 bits 
of wall clock time(64-bits).
-                     val1(uint32)  Lower 32 bits of wall clock time.
-                     val2(uint32)  Upper 32 bits of counter 
cycle(64-bits).
-                     val3(uint32)  Lower 32 bits of counter cycle.
+    Arguments:       (uint32)      KVM_PTP_VIRT_COUNTER(0)
+                                   KVM_PTP_PHYS_COUNTER(1)
+    Return Values:   (int32)       NOT_SUPPORTED(-1) on error, or
+                     (uint32)      Upper 32 bits of wall clock time 
(r0)
+                     (uint32)      Lower 32 bits of wall clock time 
(r1)
+                     (uint32)      Upper 32 bits of counter (r2)
+                     (uint32)      Lower 32 bits of counter (r3)
      Endianness:                    No Restrictions.
      =============    ==========    ==========
-
-More info see section 5 in Documentation/virt/kvm/timekeeping.rst.

> diff --git a/Documentation/virt/kvm/timekeeping.rst
> b/Documentation/virt/kvm/timekeeping.rst
> index 21ae7efa29ba..c81383e38372 100644
> --- a/Documentation/virt/kvm/timekeeping.rst
> +++ b/Documentation/virt/kvm/timekeeping.rst
> @@ -13,6 +13,7 @@ Timekeeping Virtualization for X86-Based 
> Architectures
>     2) Timing Devices
>     3) TSC Hardware
>     4) Virtualization Problems
> +   5) KVM virtual PTP clock
> 
>  1. Overview
>  ===========
> @@ -643,3 +644,37 @@ by using CPU utilization itself as a signalling
> channel.  Preventing such
>  problems would require completely isolated virtual time which may not 
> track
>  real time any longer.  This may be useful in certain security or QA 
> contexts,
>  but in general isn't recommended for real-world deployment scenarios.
> +
> +5. KVM virtual PTP clock
> +========================
> +
> +NTP (Network Time Protocol) is often used to sync time in a VM. 
> Unfortunately,
> +the precision of NTP is limited due to unknown delays in the network.
> +
> +KVM virtual PTP clock (PTP_KVM) offers another way to sync time in VM; 
> use the
> +host's clock rather than one from a remote machine. Having a 
> synchronization
> +mechanism for the virtualization environment allows us to keep all the 
> guests
> +running on the same host in sync.
> +In general, the delay of communication between host and guest is quite
> +small, so ptp_kvm can offer time sync precision up to in order of 
> nanoseconds.
> +Please keep in mind that ptp_kvm just limits itself to be a channel 
> which
> +transmits the remote clock from host to guest. An application, eg. 
> chrony, is
> +needed in usersapce of VM in order to set the guest time.
> +
> +After ptp_kvm is initialized, there will be a new device node under 
> /dev called
> +ptp%d. A guest userspace service, like chrony, can use this device to 
> get host
> +walltime, sometimes also counter cycle, which depends on the service 
> it calls.
> +Then this guest userspace service can use those data to do the time 
> sync for
> +the guest.
> +The following is the work flow of ptp_kvm:
> +
> +a) time sync service in guest userspace call ioctl on ptp device 
> /dev/ptp%d.
> +b) ptp_kvm module in guest receives this request then invokes 
> hypercall to
> +   route into host kernel to request host's walltime/counter cycle.
> +c) ptp_kvm hypercall service on the host responds to the request and 
> sends data
> +   back.
> +d) ptp in guest copies the data to userspace.
> +
> +ptp_kvm consists of components running on the guest and host. Step 2
> consists of
> +a guest driver making a hypercall whilst step 3 involves the
> hypervisor responding
> +with information.

I don't think we need any of this here, as the whole file
focuses on x86-specific issues for timekeeping. If we want
to document KVM PTP, this should probably be a separate document.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
