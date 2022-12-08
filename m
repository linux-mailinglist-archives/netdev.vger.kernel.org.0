Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8826E646BC5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiLHJWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLHJWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:22:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A9209A1
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:22:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91FD461E04
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 09:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203CDC433C1;
        Thu,  8 Dec 2022 09:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670491359;
        bh=/YYV5L1U7q7Pmey8gNiCOOfgX2dWcdZ7ZfnrOAxcyt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EWKQah3gEn1BZpW3dRgu7cOsym6s27D8CTEhm5aH/uTQ4RJkMgjs/VyXe7/5J1Owy
         QrqEloL1FpkiStZHy+uMV27IyZPTA770D7aJG/pKaSIQOSHcq3F8jXxrsdPb1mkjGk
         5cVE+0iAi/VYdRqggfUwfo8F8rOrv4N8FlKM4AJVw1HAgGh2WafQwQg3bobMHLYW1v
         bEA0N6ZwvL+OMc8EQCjwywXY+uxleejd4DwN/ibVLGm/t6FMVvZXQ+y5t+YdSsTup8
         VPl7tuuN/pTQfFfc7ni1x8tvZwy2SgrqSmAOv+q0mpu05L+cXw34cE6KOWPK4dQqjK
         ubWOw1UJCklsw==
Date:   Thu, 8 Dec 2022 11:22:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next v2 09/15] ice: protect init and calibrating
 check in ice_ptp_request_ts
Message-ID: <Y5Gs27MjJ1RrkVld@unreal>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-10-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207210937.1099650-10-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 01:09:31PM -0800, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> When requesting a new timestamp, the ice_ptp_request_ts function does not
> hold the Tx tracker lock while checking init and calibrating. This means
> that we might issue a new timestamp request just after the Tx timestamp
> tracker starts being deinitialized. This could lead to incorrect access of
> the timestamp structures. Correct this by moving the init and calibrating
> checks under the lock, and updating the flows which modify these fields to
> use the lock.
> 
> Note that we do not need to hold the lock while checking for tx->init in
> ice_ptp_tstamp_tx. This is because the teardown function will use
> synchronize_irq after clearing the flag to ensure that the threaded
> interrupt completes. Either a) the tx->init flag will be cleared before the
> ice_ptp_tx_tstamp function starts, thus it will exit immediately, or b) the
> threaded interrupt will be executing and the synchronize_irq will wait
> until the threaded interrupt has completed at which point we know the init
> field has definitely been set and new interrupts will not execute the Tx
> timestamp thread function.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 36 ++++++++++++++++++++----
>  drivers/net/ethernet/intel/ice/ice_ptp.h |  2 +-
>  2 files changed, 32 insertions(+), 6 deletions(-)

Much better, thanks
