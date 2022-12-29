Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0D36589C7
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 07:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiL2Gwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 01:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiL2Gwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 01:52:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EEE10B6F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 22:52:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1E63B81914
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 06:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4F8C433EF;
        Thu, 29 Dec 2022 06:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672296747;
        bh=ar5Ln/zeZvhIZOtZvlaeNUbx5poenTwf0jNsx+IyzbA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cQY62tHDjFznbEhi3jg/tEoG4ylIB5EmXhD/Lvmu8Dpa6cep0BqabBwq1Oncix+B2
         101vmeSOf/2FV7/uyBp/cekl5FLhb91VY8fkn3DhCQOikoDfj2+SnSxMU+wY8FPeC2
         gQJef07bctc5JlXqfda2xR4LWly1ejmF7U9TevdIYpWwGSVPrZJSUf92DlY0OaegY4
         UMblZcXNi4oXQx4ZyQJDF+HiW+sFYlua+twhILTlH+CfInjIpLbgfy7SmSiDD3UKaV
         4jmWjMZ2KQBkhLWk0nfcxA1hO1uyzBU3pqwa4/cXd09WWPf6KVQzH0WIubFpcDcRWu
         1kbcI0YXjItqw==
Date:   Thu, 29 Dec 2022 08:52:23 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Caleb Sander <csander@purestorage.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Joern Engel <joern@purestorage.com>,
        Alok Prasad <palok@marvell.com>
Subject: Re: [PATCH net v2] qed: allow sleep in qed_mcp_trace_dump()
Message-ID: <Y605JxeB0c21zeI8@unreal>
References: <71c526c6bf99171fef334ab9d51f78777e7b9df5.camel@redhat.com>
 <20221228220045.101647-1-csander@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228220045.101647-1-csander@purestorage.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 03:00:46PM -0700, Caleb Sander wrote:
> By default, qed_mcp_cmd_and_union() delays 10us at a time in a loop
> that can run 500K times, so calls to qed_mcp_nvm_rd_cmd()
> may block the current thread for over 5s.
> We observed thread scheduling delays over 700ms in production,
> with stacktraces pointing to this code as the culprit.

Please add stacktrace to the commit message.

> 
> qed_mcp_trace_dump() is called from ethtool, so sleeping is permitted.
> It already can sleep in qed_mcp_halt(), which calls qed_mcp_cmd().
> Add a "can sleep" parameter to qed_find_nvram_image() and
> qed_nvram_read() so they can sleep during qed_mcp_trace_dump().
> qed_mcp_trace_get_meta_info() and qed_mcp_trace_read_meta(),
> called only by qed_mcp_trace_dump(), allow these functions to sleep.
> I can't tell if the other caller (qed_grc_dump_mcp_hw_dump()) can sleep,
> so keep b_can_sleep set to false when it calls these functions.
> 
> Signed-off-by: Caleb Sander <csander@purestorage.com>
> Acked-by: Alok Prasad <palok@marvell.com>
> Fixes: c965db4446291 ("qed: Add support for debug data collection")

Fixes line should be before *-by tags.

> ---
>  drivers/net/ethernet/qlogic/qed/qed_debug.c | 28 +++++++++++++++------
>  1 file changed, 20 insertions(+), 8 deletions(-)

Please add changelog here while you are resending patches.

Thanks

> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> index 86ecb080b153..cdcead614e9f 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
> @@ -1830,11 +1830,12 @@ static void qed_grc_clear_all_prty(struct qed_hwfn *p_hwfn,
>  /* Finds the meta data image in NVRAM */
>  static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
>  					    struct qed_ptt *p_ptt,
>  					    u32 image_type,
>  					    u32 *nvram_offset_bytes,
> -					    u32 *nvram_size_bytes)
> +					    u32 *nvram_size_bytes,
> +					    bool b_can_sleep)
>  {
>  	u32 ret_mcp_resp, ret_mcp_param, ret_txn_size;
>  	struct mcp_file_att file_att;
>  	int nvm_result;
>  
> @@ -1844,11 +1845,12 @@ static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
>  					DRV_MSG_CODE_NVM_GET_FILE_ATT,
>  					image_type,
>  					&ret_mcp_resp,
>  					&ret_mcp_param,
>  					&ret_txn_size,
> -					(u32 *)&file_att, false);
> +					(u32 *)&file_att,
> +					b_can_sleep);
>  
>  	/* Check response */
>  	if (nvm_result || (ret_mcp_resp & FW_MSG_CODE_MASK) !=
>  	    FW_MSG_CODE_NVM_OK)
>  		return DBG_STATUS_NVRAM_GET_IMAGE_FAILED;
> @@ -1871,11 +1873,13 @@ static enum dbg_status qed_find_nvram_image(struct qed_hwfn *p_hwfn,
>  
>  /* Reads data from NVRAM */
>  static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
>  				      struct qed_ptt *p_ptt,
>  				      u32 nvram_offset_bytes,
> -				      u32 nvram_size_bytes, u32 *ret_buf)
> +				      u32 nvram_size_bytes,
> +				      u32 *ret_buf,
> +				      bool b_can_sleep)
>  {
>  	u32 ret_mcp_resp, ret_mcp_param, ret_read_size, bytes_to_copy;
>  	s32 bytes_left = nvram_size_bytes;
>  	u32 read_offset = 0, param = 0;
>  
> @@ -1897,11 +1901,11 @@ static enum dbg_status qed_nvram_read(struct qed_hwfn *p_hwfn,
>  		if (qed_mcp_nvm_rd_cmd(p_hwfn, p_ptt,
>  				       DRV_MSG_CODE_NVM_READ_NVRAM, param,
>  				       &ret_mcp_resp,
>  				       &ret_mcp_param, &ret_read_size,
>  				       (u32 *)((u8 *)ret_buf + read_offset),
> -				       false))
> +				       b_can_sleep))
>  			return DBG_STATUS_NVRAM_READ_FAILED;
>  
>  		/* Check response */
>  		if ((ret_mcp_resp & FW_MSG_CODE_MASK) != FW_MSG_CODE_NVM_OK)
>  			return DBG_STATUS_NVRAM_READ_FAILED;
> @@ -3378,11 +3382,12 @@ static u32 qed_grc_dump_mcp_hw_dump(struct qed_hwfn *p_hwfn,
>  	/* Read HW dump image from NVRAM */
>  	status = qed_find_nvram_image(p_hwfn,
>  				      p_ptt,
>  				      NVM_TYPE_HW_DUMP_OUT,
>  				      &hw_dump_offset_bytes,
> -				      &hw_dump_size_bytes);
> +				      &hw_dump_size_bytes,
> +				      false);
>  	if (status != DBG_STATUS_OK)
>  		return 0;
>  
>  	hw_dump_size_dwords = BYTES_TO_DWORDS(hw_dump_size_bytes);
>  
> @@ -3395,11 +3400,13 @@ static u32 qed_grc_dump_mcp_hw_dump(struct qed_hwfn *p_hwfn,
>  	/* Read MCP HW dump image into dump buffer */
>  	if (dump && hw_dump_size_dwords) {
>  		status = qed_nvram_read(p_hwfn,
>  					p_ptt,
>  					hw_dump_offset_bytes,
> -					hw_dump_size_bytes, dump_buf + offset);
> +					hw_dump_size_bytes,
> +					dump_buf + offset,
> +					false);
>  		if (status != DBG_STATUS_OK) {
>  			DP_NOTICE(p_hwfn,
>  				  "Failed to read MCP HW Dump image from NVRAM\n");
>  			return 0;
>  		}
> @@ -4121,11 +4128,13 @@ static enum dbg_status qed_mcp_trace_get_meta_info(struct qed_hwfn *p_hwfn,
>  	    (*running_bundle_id ==
>  	     DIR_ID_1) ? NVM_TYPE_MFW_TRACE1 : NVM_TYPE_MFW_TRACE2;
>  	return qed_find_nvram_image(p_hwfn,
>  				    p_ptt,
>  				    nvram_image_type,
> -				    trace_meta_offset, trace_meta_size);
> +				    trace_meta_offset,
> +				    trace_meta_size,
> +				    true);
>  }
>  
>  /* Reads the MCP Trace meta data from NVRAM into the specified buffer */
>  static enum dbg_status qed_mcp_trace_read_meta(struct qed_hwfn *p_hwfn,
>  					       struct qed_ptt *p_ptt,
> @@ -4137,11 +4146,14 @@ static enum dbg_status qed_mcp_trace_read_meta(struct qed_hwfn *p_hwfn,
>  	u32 signature;
>  
>  	/* Read meta data from NVRAM */
>  	status = qed_nvram_read(p_hwfn,
>  				p_ptt,
> -				nvram_offset_in_bytes, size_in_bytes, buf);
> +				nvram_offset_in_bytes,
> +				size_in_bytes,
> +				buf,
> +				true);
>  	if (status != DBG_STATUS_OK)
>  		return status;
>  
>  	/* Extract and check first signature */
>  	signature = qed_read_unaligned_dword(byte_buf);
> -- 
> 2.25.1
> 
