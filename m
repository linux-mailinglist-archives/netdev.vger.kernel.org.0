Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B26933DA75
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238716AbhCPRPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 13:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239119AbhCPROr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 13:14:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B1F565087;
        Tue, 16 Mar 2021 17:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615914884;
        bh=CDcD1dQBr2YIU2/9H6b3fgSvWCMP+J7RvXYb+uxHbnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y9HRoKOYVyBxyp8v3oNq6vGc4ugf+1ST8l3ZE1inyHrkrtVRnJZTd3Htff9hGDUnw
         2ZHB9v/He710SJABH+YHBfy1sVLLaK7ChvAAWtXVeI3IkJaGItGSkG5ota+7NBdNw7
         f8LY7YFWDpv1LMX7EePMyl5anq5eJviQpRN3tkMmrCZWSawPsHv7pHyQmVBuUdvu2R
         WSvpIFhGaUZzQkdsSy6fOayzU9cD0TnFz/6Kh0MKFTJ1GcJXJDZHMXSqmJJG80GvRq
         8JI0XWr8QsF/eiqg75c4ap4zZM9lzZYEV+WIOVadLQRZEJvdNdgDio5XI70/qO54ya
         ceUsIWyG5uFFw==
Date:   Tue, 16 Mar 2021 10:14:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Assmann <sassmann@kpanic.de>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, lihong.yang@intel.com,
        jesse.brandeburg@intel.com, slawomirx.laba@intel.com,
        nicholas.d.nunley@intel.com
Subject: Re: [PATCH] iavf: fix locking of critical sections
Message-ID: <20210316101443.56b87cf6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316100141.53551-1-sassmann@kpanic.de>
References: <20210316100141.53551-1-sassmann@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 11:01:41 +0100 Stefan Assmann wrote:
> To avoid races between iavf_init_task(), iavf_reset_task(),
> iavf_watchdog_task(), iavf_adminq_task() as well as the shutdown and
> remove functions more locking is required.
> The current protection by __IAVF_IN_CRITICAL_TASK is needed in
> additional places.
> 
> - The reset task performs state transitions, therefore needs locking.
> - The adminq task acts on replies from the PF in
>   iavf_virtchnl_completion() which may alter the states.
> - The init task is not only run during probe but also if a VF gets stuck
>   to reinitialize it.
> - The shutdown function performs a state transition.
> - The remove function perorms a state transition and also free's
>   resources.
> 
> iavf_lock_timeout() is introduced to avoid waiting infinitely
> and cause a deadlock. Rather unlock and print a warning.
> 
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>

I personally think that the overuse of flags in Intel drivers brings
nothing but trouble. At which point does it make sense to just add a
lock / semaphore here rather than open code all this with no clear
semantics? No code seems to just test the __IAVF_IN_CRITICAL_TASK flag,
all the uses look like poor man's locking at a quick grep. What am I
missing?
