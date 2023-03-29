Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1479D6CD88C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjC2LgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC2Lf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:35:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB3640DC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5C88B822DD
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDC6C433EF;
        Wed, 29 Mar 2023 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680089755;
        bh=z/x7LnEKtW9FQfCWGQ8ALFdFf+D3mta8rcpYAy1Iy3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A+Ms2xkVBRYr61Wan4XUIfxUpH1PPns1a7VAh0+cCcqAopcBivhA2YK/me/IGcPhD
         FCwmdiRfGD/Kh84qVjUWEpxxLbPyaDdzplZ/8WlVo1dg0/hxzUdI5HjdG4mCyEXNj1
         ecPSmnGjPxtvvag7GNvHb3cjVcr/r9kfVBkvvCZqdnHiiUgcOVNypXz9UgrYPDL2Tb
         6jPNUFupOsc0OujXEYfzIBH1cx9PTG7Zns9paOCMLYwKQmpmFXvztzPR7JV8jvprJC
         Gn0HJPyha/9YQ05f7lBndWZW/qmul/09Ku8QF/wcR/BqhDC/C9JwtSi8s+9rNfHpxc
         ZIpRyFR45Vj5A==
Date:   Wed, 29 Mar 2023 14:35:51 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Piotr Raczynski <piotr.raczynski@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        michal.swiatkowski@intel.com, shiraz.saleem@intel.com,
        jacob.e.keller@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, aleksander.lobakin@intel.com,
        lukasz.czapnik@intel.com
Subject: Re: [PATCH net-next v3 0/8] ice: support dynamic interrupt allocation
Message-ID: <20230329113551.GN831478@unreal>
References: <20230323122440.3419214-1-piotr.raczynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323122440.3419214-1-piotr.raczynski@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:24:32PM +0100, Piotr Raczynski wrote:
> This patchset reimplements MSIX interrupt allocation logic to allow dynamic
> interrupt allocation after MSIX has been initially enabled. This allows
> current and future features to allocate and free interrupts as needed and
> will help to drastically decrease number of initially preallocated
> interrupts (even down to the API hard limit of 1). Although this patchset
> does not change behavior in terms of actual number of allocated interrupts
> during probe, it will be subject to change.
> 
> First few patches prepares to introduce dynamic allocation by moving
> interrupt allocation code to separate file and update allocation API used
> in the driver to the currently preferred one.
> 
> Due to the current contract between ice and irdma driver which is directly
> accessing msix entries allocated by ice driver, even after moving away from
> older pci_enable_msix_range function, still keep msix_entries array for
> irdma use.
> 
> Next patches refactors and removes redundant code from SRIOV related logic
> as it also make it easier to move away from static allocation scheme.
> 
> Last patches actually enables dynamic allocation of MSIX interrupts. First,
> introduce functions to allocate and free interrupts individually. This sets
> ground for the rest of the changes even if that patch still allocates the
> interrupts from the preallocated pool. Since this patch starts to keep
> interrupt details in ice_q_vector structure we can get rid of functions
> that calculates base vector number and register offset for the interrupt
> as it is equal to the interrupt index. Only keep separate register offset
> functions for the VF VSIs.
> 
> Next, replace homegrown interrupt tracker with much simpler xarray based
> approach. As new API always allocate interrupts one by one, also track
> interrupts in the same manner.
> 
> Lastly, extend the interrupt tracker to deal both with preallocated and
> dynamically allocated vectors and use pci_msix_alloc_irq_at and
> pci_msix_free_irq functions. Since not all architecture supports dynamic
> allocation, check it before trying to allocate a new interrupt.
> 
> As previously mentioned, this patchset does not change number of initially
> allocated interrupts during init phase but now it can and will likely be
> changed.
> 
> Patch 1-3 -> move code around and use newer API
> Patch 4-5 -> refactor and remove redundant SRIOV code
> Patch 6   -> allocate every interrupt individually
> Patch 7   -> replace homegrown interrupt tracker with xarray
> Patch 8   -> allow dynamic interrupt allocation
> 
> Change history:
> v1 -> v2:
> - ice: refactor VF control VSI interrupt handling
>   - move ice_get_vf_ctrl_vsi to ice_lib.c (ice_vf_lib.c depends on
>     CONFIG_PCI_IOV)
> v2 -> v3:
> - ice: refactor VF control VSI interrupt handling
>   - revert v2 change and add no-op function in case of CONFIG_PCI_IOV=n
> - ice: add dynamic interrupt allocation
>   - fix commit message
> 
> Piotr Raczynski (8):
>   ice: move interrupt related code to separate file
>   ice: use pci_irq_vector helper function
>   ice: use preferred MSIX allocation api
>   ice: refactor VF control VSI interrupt handling
>   ice: remove redundant SRIOV code
>   ice: add individual interrupt allocation
>   ice: track interrupt vectors with xarray
>   ice: add dynamic interrupt allocation
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
