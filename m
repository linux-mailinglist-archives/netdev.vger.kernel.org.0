Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B9662915E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiKOFIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiKOFIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:08:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFAF765D
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:08:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19018B811FF
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7F4C433C1;
        Tue, 15 Nov 2022 05:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668488907;
        bh=UQm5ePsKWUbiHJq57qNre2xNT2+8tQVZsGFCGqRXI/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JXzN0Nuvt0+7Cd65DZwjtZQp4L6w3DMahhKBI/POKLIIYJUpfjFjm/4tkRoS5FWju
         CL/LEy/GLYI7wWgoAg+8zaUd5FzamNJAAsIn+suyGmJSawOXc1jEmmaEI+s2ml5w2I
         2zDkAj4eq9Oqj8UkC2ahRVYMDN9QVx6Jv+PO60eBLqaq/3WT5tPezC1DZnYgBz7Sgk
         lya8OAujQbr3/z+yNWKLF41+AxjQwrWhL+7T6ZDFNezSkoka5TrRT7F24trDnSe9As
         ceHUkAA5hrGmifAJX9mXqsUsPW360ycq93z5+bIhkoOXIroS8BpBLoXeYIvgDpu17H
         7RvsZlKcS9mqw==
Date:   Mon, 14 Nov 2022 21:08:25 -0800
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
Subject: Re: [PATCH net-next 04/13] ice: split ice_vsi_setup into smaller
 functions
Message-ID: <20221114210825.5c12894c@kernel.org>
In-Reply-To: <20221114125755.13659-5-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
        <20221114125755.13659-5-michal.swiatkowski@linux.intel.com>
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

On Mon, 14 Nov 2022 13:57:46 +0100 Michal Swiatkowski wrote:
> Main goal is to reuse the same functions in VSI config and rebuild
> paths.
> To do this split ice_vsi_setup into smaller pieces and reuse it during
> rebuild.
> 
> ice_vsi_alloc() should only alloc memory, not set the default values
> for VSI.
> Move setting defaults to separate function. This will allow config of
> already allocated VSI, for example in reload path.
> 
> The path is mostly moving code around without introducing new
> functionality. Functions ice_vsi_cfg() and ice_vsi_decfg() were
> added, but they are using code that already exist.
> 
> Use flag to pass information about VSI initialization during rebuild
> instead of using boolean value.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Co-developed-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

nit:

drivers/net/ethernet/intel/ice/ice_lib.c:459: warning: Function parameter or member 'vsi' not described in 'ice_vsi_alloc_def'
drivers/net/ethernet/intel/ice/ice_lib.c:459: warning: Excess function parameter 'vsi_type' description in 'ice_vsi_alloc_def'

Sorry, didn't get to actually reviewing because of the weekend backlog.
Will do tomorrow.
