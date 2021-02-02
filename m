Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D930230C1BD
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 15:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbhBBOa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 09:30:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234005AbhBBOTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 09:19:51 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D925E64E2B;
        Tue,  2 Feb 2021 14:15:17 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6wSZ-00BVy2-W6; Tue, 02 Feb 2021 14:15:16 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Feb 2021 14:15:15 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com, richardcochran@gmail.com,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        Andre.Przywara@arm.com, steven.price@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
Subject: Re: [PATCH v16 0/9] Enable ptp_kvm for arm/arm64
In-Reply-To: <20201209060932.212364-1-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <74108ee1d0021acbdd7aed5b467e5432@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jianyong.wu@arm.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com, steven.price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, justin.he@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 06:09, Jianyong Wu wrote:
> Currently, we offen use ntp (sync time with remote network clock)
> to sync time in VM. But the precision of ntp is subject to network 
> delay
> so it's difficult to sync time in a high precision.
> 
> kvm virtual ptp clock (ptp_kvm) offers another way to sync time in VM,
> as the remote clock locates in the host instead of remote network 
> clock.
> It targets to sync time between guest and host in virtualization
> environment and in this way, we can keep the time of all the VMs 
> running
> in the same host in sync. In general, the delay of communication 
> between
> host and guest is quiet small, so ptp_kvm can offer time sync precision
> up to in order of nanosecond. Please keep in mind that ptp_kvm just
> limits itself to be a channel which transmit the remote clock from
> host to guest and leaves the time sync jobs to an application, eg. 
> chrony,
> in usersapce in VM.
> 
> How ptp_kvm works:
> After ptp_kvm initialized, there will be a new device node under
> /dev called ptp%d. A guest userspace service, like chrony, can use this
> device to get host walltime, sometimes also counter cycle, which 
> depends
> on the service it calls. Then this guest userspace service can use 
> those
> data to do the time sync for guest.
> here is a rough sketch to show how kvm ptp clock works.
> 
> |----------------------------|              
> |--------------------------|
> |       guest userspace      |              |          host            
> |
> |ioctl -> /dev/ptp%d         |              |                          
> |
> |       ^   |                |              |                          
> |
> |----------------------------|              |                          
> |
> |       |   | guest kernel   |              |                          
> |
> |       |   V      (get host walltime/counter cycle)                   
> |
> |      ptp_kvm -> hypercall - - - - - - - - - - ->hypercall service    
> |
> |                         <- - - - - - - - - - - -                     
> |
> |----------------------------|              
> |--------------------------|
> 
> 1. time sync service in guest userspace call ptp device through 
> /dev/ptp%d.
> 2. ptp_kvm module in guest receives this request then invoke hypercall 
> to route
> into host kernel to request host walltime/counter cycle.
> 3. ptp_kvm hypercall service in host response to the request and send 
> data back.
> 4. ptp (not ptp_kvm) in guest copy the data to userspace.
> 
> This ptp_kvm implementation focuses itself to step 2 and 3 and step 2 
> works
> in guest comparing step 3 works in host kernel.

FWIW, and in order to speed up the review, I've posted a reworked
version[0] of this series with changes that address the comments
I had for on v16.

Thanks,

         M.

[0] https://lore.kernel.org/r/20210202141204.3134855-1-maz@kernel.org
-- 
Jazz is not dead. It just smells funny...
