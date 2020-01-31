Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A314F135
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgAaRW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:22:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:41014 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgAaRW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 12:22:58 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 09:22:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="428774593"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 31 Jan 2020 09:22:55 -0800
Date:   Fri, 31 Jan 2020 11:15:43 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Henry Tieman <henry.w.tieman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] ice: Fix a couple off by one bugs
Message-ID: <20200131101543.GA4872@ranger.igk.intel.com>
References: <20200131045658.ahliv7jvubpwoeru@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131045658.ahliv7jvubpwoeru@kili.mountain>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 07:56:59AM +0300, Dan Carpenter wrote:
> The hw->blk[blk]->es.ref_count[] array has hw->blk[blk].es.count
> elements.  It gets allocated in ice_init_hw_tbls().  So the > should be
> >= to prevent accessing one element beyond the end of the array.
> 
> Fixes: 2c61054c5fda ("ice: Optimize table usage")

You should also provide:
Fixes: 31ad4e4ee1e4 ("ice: Allocate flow profile")

prof_id can be 0 so thanks for catching this. You can take my:
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
> index 99208946224c..38a7041fe774 100644
> --- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
> +++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
> @@ -1950,7 +1950,7 @@ ice_free_prof_id(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
>  static enum ice_status
>  ice_prof_inc_ref(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
>  {
> -	if (prof_id > hw->blk[blk].es.count)
> +	if (prof_id >= hw->blk[blk].es.count)
>  		return ICE_ERR_PARAM;
>  
>  	hw->blk[blk].es.ref_count[prof_id]++;
> @@ -1991,7 +1991,7 @@ ice_write_es(struct ice_hw *hw, enum ice_block blk, u8 prof_id,
>  static enum ice_status
>  ice_prof_dec_ref(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
>  {
> -	if (prof_id > hw->blk[blk].es.count)
> +	if (prof_id >= hw->blk[blk].es.count)
>  		return ICE_ERR_PARAM;
>  
>  	if (hw->blk[blk].es.ref_count[prof_id] > 0) {
> -- 
> 2.11.0
> 
