Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9157D6DBF74
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjDIKd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIKdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:33:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AC14689
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:33:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A67B561360
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887C1C433A7;
        Sun,  9 Apr 2023 10:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681036433;
        bh=jfH3xAKdzetozjlPkiNYb9TwyrG13HO/lg7417hKVMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FjnCe57fp6wd+6dOTDZVEY+HGdwYQ883xoDGkEzKyjDCGmXsrwh30wxNMxpWdnEWi
         L8pXgqKkJTtdc3y9z3oZu88vqHdBOWalSht2XwCUX1EZ+Xp3UWlfhqadEwgdXPCeRC
         67ELUnLJPAMGhjlGOda9u8mQ71v9QSLfTqJ55Jck/VuMeORqocfplxYVx9SJgQ2Pyr
         CgVT/bgcLn2fkj+KHsmmWXMUJCTYH3+dHdZJBIO94nlIfIVTMY9oOuEMNUR1eK8QC6
         ljOb+edJyqCKljO32zuO+Xf70chiKCEY+wKNJuhfKORBGmEW6cUsFORqc49dA9TX2M
         Pf48E2UUkZRsA==
Date:   Sun, 9 Apr 2023 13:33:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com,
        pmenzel@molgen.mpg.de, aleksander.lobakin@intel.com,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v4 2/5] ice: remove redundant Rx field from rule
 info
Message-ID: <20230409103349.GK14869@unreal>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-3-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407165219.2737504-3-michal.swiatkowski@linux.intel.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:52:16PM +0200, Michal Swiatkowski wrote:
> Information about the direction is currently stored in sw_act.flag.
> There is no need to duplicate it in another field.
> 
> Setting direction flag doesn't mean that there is a match criteria for
> direction in rule. It is only a information for HW from where switch id
> should be collected (VSI or port). In current implementation of advance
> rule handling, without matching for direction meta data, we can always
> set one the same flag and everything will work the same.
> 
> Ability to match on direction meta data will be added in follow up
> patches.
> 
> Recipe 0, 3 and 9 loaded from package has direction match
> criteria, but they are handled in other function.
> 
> Move ice_adv_rule_info fields to avoid holes.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_eswitch.c |  1 -
>  drivers/net/ethernet/intel/ice/ice_switch.c  | 22 ++++++++++----------
>  drivers/net/ethernet/intel/ice/ice_switch.h  |  8 +++----
>  drivers/net/ethernet/intel/ice/ice_tc_lib.c  |  5 -----
>  4 files changed, 14 insertions(+), 22 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
