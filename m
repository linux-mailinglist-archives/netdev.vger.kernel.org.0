Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708EC33DEC0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhCPU3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhCPU3G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 16:29:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 139AD64F4F;
        Tue, 16 Mar 2021 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615926546;
        bh=TuJaPcwrfUA7TXfbw1a2CWd9tWR8XLxVu8BUD6hKzIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fX5nm3C5F53SWHQYb5x0e+mhhqgomMtlujkx26zVPy0zsTiy82RqBpz0Pyn4KC41z
         u28pGdh1mD8m+odmDqJe86UL/9ePgNZT82c7Nfvwx8OFm1ik5okJhXvs93x0v2V/ej
         dh4J3gXT4sQO2o/EadirgkPwMm3+B5NijomT/yL2ZaVJnqhVh9eTCJECFRTIwryDDF
         hRo99gv3szUmA0Xhcsth6BiDZbNmnjJs2B2fUelWoxDPayJeAZUXMhCvlzcval82Bj
         Fki4nXM01JVvmh2C3ppQt21Hrr3pYJSGNywsc19ydXTcbmkjq5/ospfNZc5Wdbh85c
         MN4sF4E/Zo4gQ==
Date:   Tue, 16 Mar 2021 13:29:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Assmann <sassmann@kpanic.de>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, lihong.yang@intel.com,
        jesse.brandeburg@intel.com, slawomirx.laba@intel.com,
        nicholas.d.nunley@intel.com
Subject: Re: [PATCH] iavf: fix locking of critical sections
Message-ID: <20210316132905.5d0f90dd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <44b3f5f0-93f8-29e2-ab21-5fd7cc14c755@kpanic.de>
References: <20210316100141.53551-1-sassmann@kpanic.de>
        <20210316101443.56b87cf6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <44b3f5f0-93f8-29e2-ab21-5fd7cc14c755@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 18:27:10 +0100 Stefan Assmann wrote:
> On 16.03.21 18:14, Jakub Kicinski wrote:
> > On Tue, 16 Mar 2021 11:01:41 +0100 Stefan Assmann wrote:  
> >> To avoid races between iavf_init_task(), iavf_reset_task(),
> >> iavf_watchdog_task(), iavf_adminq_task() as well as the shutdown and
> >> remove functions more locking is required.
> >> The current protection by __IAVF_IN_CRITICAL_TASK is needed in
> >> additional places.
> >>
> >> - The reset task performs state transitions, therefore needs locking.
> >> - The adminq task acts on replies from the PF in
> >>   iavf_virtchnl_completion() which may alter the states.
> >> - The init task is not only run during probe but also if a VF gets stuck
> >>   to reinitialize it.
> >> - The shutdown function performs a state transition.
> >> - The remove function perorms a state transition and also free's
> >>   resources.
> >>
> >> iavf_lock_timeout() is introduced to avoid waiting infinitely
> >> and cause a deadlock. Rather unlock and print a warning.
> >>
> >> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>  
> > 
> > I personally think that the overuse of flags in Intel drivers brings
> > nothing but trouble. At which point does it make sense to just add a
> > lock / semaphore here rather than open code all this with no clear
> > semantics? No code seems to just test the __IAVF_IN_CRITICAL_TASK flag,
> > all the uses look like poor man's locking at a quick grep. What am I
> > missing?
> 
> I agree with you that the locking could be done with other locking
> mechanisms just as good. I didn't invent the current method so I'll let
> Intel comment on that part, but I'd like to point out that what I'm
> making use of is fixing what is currently in the driver.

Right, I should have made it clear that I don't blame you for the
current state of things. Would you mind sending a patch on top of 
this one to do a conversion to a semaphore? 

Intel folks any opinions?
