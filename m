Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170523CF8DE
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhGTKvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhGTKvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 06:51:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F07F61009;
        Tue, 20 Jul 2021 11:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626780719;
        bh=g5h9qwV+O0jeP4o7dg28ixbAOs+6DWETy2RB79PqrNs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=prpOYeBtr8bEBFx8EMkIGbqmr8EoFOhOZgrBtbInEugnl5GwlHwq88H6uECHSjfhp
         7hktVHu4NMkSQk4iCQtIB+32UArVawN66gEzPUnaXJk6LrpDMC0jlY9tyFgrmM29db
         UdhitvfNIyjOiY+kY/bDuLdMHOA/3WamM7EHaEqZOqT+84lDmwL4bcG5XOvNPNBSxZ
         PYlbwowM0QhNjH0xt7kjeXCiK955ZBJ72ZLJIIGTsHpo8zHYjUHopOQpE4Fw6bl6od
         ZagP5jxGutEPYwDafB/EU5ZbKcu5oQC54rxZuk59S/d+Bbog+fL+/1LtxtzkfStt1Y
         vsJfCMVXeTvQw==
Date:   Tue, 20 Jul 2021 13:31:53 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Stefan Assmann <sassmann@kpanic.de>,
        netdev@vger.kernel.org,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 3/3] iavf: fix locking of critical sections
Message-ID: <20210720133153.0f13c92a@cakuba>
In-Reply-To: <20210719163154.986679-4-anthony.l.nguyen@intel.com>
References: <20210719163154.986679-1-anthony.l.nguyen@intel.com>
        <20210719163154.986679-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 09:31:54 -0700, Tony Nguyen wrote:
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
> - The remove function performs a state transition and also free's
>   resources.
> 
> iavf_lock_timeout() is introduced to avoid waiting infinitely
> and cause a deadlock. Rather unlock and print a warning.

I have a vague recollection of complaining about something like this
previously. Why not use a normal lock? Please at the very least include
an explanation in the commit message.

If you use bit locks you should use the _lock and _unlock flavours of
the bitops.
