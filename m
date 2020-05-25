Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF6A1E11B5
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 17:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404122AbgEYP2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 11:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403999AbgEYP2Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 11:28:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B44D92071A;
        Mon, 25 May 2020 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590420503;
        bh=3X4sQ7kcpAcBdWmFPLh2z6FUnu+whu05DPLM1j+9VQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0bBuzBY5wC1xcpMo04SVEVYyNO8F3N5GWqP7oDFDTbPCo3EUisqzVks3B99I4/hdY
         /iEgGaONpIC9cmuYkN8WpvOyZ6fzMILw87y7sn4R0VuCPQebUSBI+bsP0/+gZVHcVq
         /FsxUauOXD8YIvXLhbH0AjW3jJDp8Sul7gdt/vF0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jdF1Z-00FC3W-Mv; Mon, 25 May 2020 16:28:21 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 May 2020 16:28:21 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        Mark Rutland <Mark.Rutland@arm.com>, will@kernel.org,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        Wei Chen <Wei.Chen@arm.com>, nd <nd@arm.com>
Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
In-Reply-To: <HE1PR0802MB2555E64BD5C076E5AF08E644F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
 <20200524021106.GC335@localhost>
 <306951e4945b9e486dc98818ba24466d@kernel.org>
 <HE1PR0802MB2555E64BD5C076E5AF08E644F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <b5b4266f6bdac6c4921ab1a577b8e343@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: Jianyong.Wu@arm.com, richardcochran@gmail.com, netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com, Mark.Rutland@arm.com, will@kernel.org, Suzuki.Poulose@arm.com, Steven.Price@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com, Justin.He@arm.com, Wei.Chen@arm.com, nd@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-25 15:18, Jianyong Wu wrote:
> Hi Marc,
> 
>> -----Original Message-----
>> From: Marc Zyngier <maz@kernel.org>
>> Sent: Monday, May 25, 2020 5:17 PM
>> To: Richard Cochran <richardcochran@gmail.com>; Jianyong Wu
>> <Jianyong.Wu@arm.com>
>> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
>> tglx@linutronix.de; pbonzini@redhat.com; 
>> sean.j.christopherson@intel.com;
>> Mark Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
>> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>; linux-
>> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
>> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
>> <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>; nd <nd@arm.com>
>> Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user
>> choose which counter to return
>> 
>> On 2020-05-24 03:11, Richard Cochran wrote:
>> > On Fri, May 22, 2020 at 04:37:23PM +0800, Jianyong Wu wrote:
>> >> In general, vm inside will use virtual counter compered with host use
>> >> phyical counter. But in some special scenarios, like nested
>> >> virtualization, phyical counter maybe used by vm. A interface added
>> >> in ptp_kvm driver to offer a mechanism to let user choose which
>> >> counter should be return from host.
>> >
>> > Sounds like you have two time sources, one for normal guest, and one
>> > for nested.  Why not simply offer the correct one to user space
>> > automatically?  If that cannot be done, then just offer two PHC
>> > devices with descriptive names.
>> 
>> There is no such thing as a distinction between nested or non-nested.
>> Both counters are available to the guest at all times, and said guest 
>> can
>> choose whichever it wants to use. So the hypervisor (KVM) has to 
>> support
>> both counters as a reference.
>> 
> It's great that we can decide which counter to return in guest kernel.
> So we can abandon these code, including patch 9/11 and 10/11, that
> expose the interface to userspace to do the decision.
> 
>> For a Linux guest, we always know which reference we're using (the 
>> virtual
>> counter). So it is pointless to expose the choice to userspace at all.
>> 
> So, we should throw these code of deciding counter type in linux
> driver away and just keep the hypercall service of providing both
> virtual counter and physical counter in linux to server non-linux
> guest.
> Am I right?

Exactly. We control Linux, and so far nothing is using the physical
counter directly. It is only using the virtual counter.
On the other side, this is *only* Linux. Other operating systems
will need to pick the reference clock that matches their own.
If one day we change Linux to use the physical counter, we'll
have to do the same thing.

         M.
-- 
Jazz is not dead. It just smells funny...
