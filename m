Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75E04BC579
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 06:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiBSFDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 00:03:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiBSFDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 00:03:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CAC66231
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 21:03:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41519B82545
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 05:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABB5C004E1;
        Sat, 19 Feb 2022 05:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645247010;
        bh=bNIvby34CuigM2PSk6JYLnnb13kvfmVggRGp1IJZkRU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=biDS3BUnqBFJgDDT+12b6zzhwpeJZNNEA0AhU0UZSEF1bM5SmNfMVxZ+47Pb9zpEI
         LTwzL3FQ3EOa2HzXjuiKFgB9peY/v/Ra5xysAPvof0ZjdKJacwukXqvS5WJbyUchag
         gVUChBC791zfntTxd4LypZfi4RcZ/sHPtR8S2r00jd1s7BW1wKfOuQnMgqc/re+Xl7
         RQbVOnwPsnIOfiQ4hXwASFgMmIWl3V2FojSQ40ZtFNnCfnftJMdec9csfeJmEWjcD1
         IVKiU6KbBaa/LICXXYNyhr+maDgxMsj4ZoloiITj8N6bTFwmdL71ZUTbw9hk1uFO3v
         h4j/4db6vm67Q==
Date:   Fri, 18 Feb 2022 21:03:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        wojciech.drewek@intel.com, davem@davemloft.net,
        pablo@netfilter.org, laforge@gnumonks.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v6 6/7] ice: Fix FV offset searching
Message-ID: <20220218210328.4420a768@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220218145339.7322-1-marcin.szycik@linux.intel.com>
References: <20220218145048.6718-1-marcin.szycik@linux.intel.com>
        <20220218145339.7322-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 15:53:39 +0100 Marcin Szycik wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> Checking only protocol ids while searching for correct FVs can lead to a
> situation, when incorrect FV will be added to the list. Incorrect means
> that FV has correct protocol id but incorrect offset.
> 
> Call ice_get_sw_fv_list with ice_prot_lkup_ext struct which contains all
> protocol ids with offsets.
> 
> With this modification allocating and collecting protocol ids list is
> not longer needed.
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
> index 38fe0a7e6975..9746db6e19b5 100644
> --- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
> +++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
> @@ -1884,7 +1884,7 @@ ice_get_sw_fv_bitmap(struct ice_hw *hw, enum ice_prof_type req_profs,
>   * allocated for every list entry.
>   */
>  int
> -ice_get_sw_fv_list(struct ice_hw *hw, u8 *prot_ids, u16 ids_cnt,
> +ice_get_sw_fv_list(struct ice_hw *hw, struct ice_prot_lkup_ext *lkups,
>  		   unsigned long *bm, struct list_head *fv_list)
>  {
>  	struct ice_sw_fv_list_entry *fvl;

drivers/net/ethernet/intel/ice/ice_flex_pipe.c:1889: warning: Function parameter or member 'lkups' not described in 'ice_get_sw_fv_list'
drivers/net/ethernet/intel/ice/ice_flex_pipe.c:1889: warning: Excess function parameter 'prot_ids' description in 'ice_get_sw_fv_list'
drivers/net/ethernet/intel/ice/ice_flex_pipe.c:1889: warning: Excess function parameter 'ids_cnt' description in 'ice_get_sw_fv_list'

There's another one in the next patch.
