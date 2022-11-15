Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44016629160
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiKOFJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKOFJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:09:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3FF14085
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:09:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE08EB811FF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD17C433D6;
        Tue, 15 Nov 2022 05:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668488938;
        bh=bBPdVJBnQflcUos860RsE9Maik4P+Mc7RQiwH/m90FQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Khrc7B0yZonEQ1V07JxaEdOZ700mxv+4bKUYxqy6qka4PV3faSKkT5COqRHlHYIkd
         +03vXjqgjJ4aFB19dYXrr9WNVBanTPosuVcoXqiuGDCJxTvwf4b0eRijI+nEkP6NzE
         OWhaaQwsGsLc3UjVPRntTDpK/kbkWiDAMRpu9GY+RzCLQVotmSLME6J83nEwsm0S4Q
         CQ+BCTEiS5EK37D++bd/n7m8sga1CS2RJh6e5bk0/VDzZ9RHSXaMqgsaw7Y9kepiZL
         DyGAeLe/83pxL/X6VB9rdoRfVSsKFy95DkPiSvOaF94dSna9S8bM16Ek1PNwpT7eWI
         QFZ4sxjuzA5qA==
Date:   Mon, 14 Nov 2022 21:08:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jiri@nvidia.com, anthony.l.nguyen@intel.com,
        alexandr.lobakin@intel.com, sridhar.samudrala@intel.com,
        wojciech.drewek@intel.com, lukasz.czapnik@intel.com,
        shiraz.saleem@intel.com, jesse.brandeburg@intel.com,
        mustafa.ismail@intel.com, przemyslaw.kitszel@intel.com,
        piotr.raczynski@intel.com, jacob.e.keller@intel.com,
        david.m.ertman@intel.com, leszek.kaliszczuk@intel.com
Subject: Re: [PATCH net-next 12/13] ice, irdma: prepare reservation of MSI-X
 to reload
Message-ID: <20221114210856.0d76bb2c@kernel.org>
In-Reply-To: <20221114125755.13659-13-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
        <20221114125755.13659-13-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 13:57:54 +0100 Michal Swiatkowski wrote:
> Move MSI-X number for LAN and RDMA to structure to have it in one
> place. Use req_msix to store how many MSI-X for each feature user
> requested. Structure msix is used to store the current number of MSI-X.
> 
> The MSI-X number needs to be adjust if kernel doesn't support that many
> MSI-X or if hardware doesn't support it. Rewrite MSI-X adjustment
> function to use it in both cases.
> 
> Use the same algorithm like previously. First allocate minimum MSI-X for
> each feature than if there is enough MSI-X distribute it equally between
> each one.

drivers/net/ethernet/intel/ice/ice_lib.c:455: warning: Function parameter or member 'vsi' not described in 'ice_vsi_alloc_def'
drivers/net/ethernet/intel/ice/ice_lib.c:455: warning: Excess function parameter 'vsi_type' description in 'ice_vsi_alloc_def'
drivers/net/ethernet/intel/ice/ice_main.c:4026:9: warning: variable 'err' is uninitialized when used here [-Wuninitialized]
        return err;
               ^~~
drivers/net/ethernet/intel/ice/ice_main.c:4001:29: note: initialize the variable 'err' to silence this warning
        int v_wanted, v_actual, err, i;
                                   ^
                                    = 0
