Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893D260D56D
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 22:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiJYUTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 16:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiJYUTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 16:19:07 -0400
X-Greylist: delayed 67 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Oct 2022 13:19:05 PDT
Received: from relay04.th.seeweb.it (relay04.th.seeweb.it [IPv6:2001:4b7a:2000:18::165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BAC7D7BC;
        Tue, 25 Oct 2022 13:19:05 -0700 (PDT)
Received: from cp.tophost.it (vm1054.cs12.seeweb.it [217.64.195.253])
        by m-r1.th.seeweb.it (Postfix) with ESMTPA id 1239F1F8DD;
        Tue, 25 Oct 2022 22:19:04 +0200 (CEST)
MIME-Version: 1.0
Date:   Tue, 25 Oct 2022 23:03:07 +0300
From:   Jami Kettunen <jami.kettunen@somainline.org>
To:     Caleb Connolly <caleb.connolly@linaro.org>
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Alex Elder <elder@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: ipa: fix v3.1 resource limit masks
In-Reply-To: <20221024210336.4014983-2-caleb.connolly@linaro.org>
References: <20221024210336.4014983-1-caleb.connolly@linaro.org>
 <20221024210336.4014983-2-caleb.connolly@linaro.org>
User-Agent: Roundcube Webmail/1.4.6
Message-ID: <1b3438b9c5c33eeae0f648843ab0eb10@somainline.org>
X-Sender: jami.kettunen@somainline.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.10.2022 00:03, Caleb Connolly wrote:
> The resource group limits for IPA v3.1 mistakenly used 6 bit wide mask
> values, when the hardware actually uses 8. Out of range values were
> silently ignored before, so the IPA worked as expected. However the
> new generalised register definitions introduce stricter checking here,
> they now cause some splats and result in the value 0 being written
> instead. Fix the limit bitmask widths so that the correct values can be
> written.
> 
> Fixes: 1c418c4a929c ("net: ipa: define resource group/type IPA register 
> fields")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>

Tested-by: Jami Kettunen <jami.kettunen@somainline.org>

> ---
>  drivers/net/ipa/reg/ipa_reg-v3.1.c | 96 ++++++++++--------------------
>  1 file changed, 32 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/net/ipa/reg/ipa_reg-v3.1.c
> b/drivers/net/ipa/reg/ipa_reg-v3.1.c
> index 116b27717e3d..0d002c3c38a2 100644
> --- a/drivers/net/ipa/reg/ipa_reg-v3.1.c
> +++ b/drivers/net/ipa/reg/ipa_reg-v3.1.c
> @@ -127,112 +127,80 @@ static const u32 ipa_reg_counter_cfg_fmask[] = {
>  IPA_REG_FIELDS(COUNTER_CFG, counter_cfg, 0x000001f0);
> 
>  static const u32 ipa_reg_src_rsrc_grp_01_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>  };
> 
>  IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_01_RSRC_TYPE, 
> src_rsrc_grp_01_rsrc_type,
>  		      0x00000400, 0x0020);
> 
>  static const u32 ipa_reg_src_rsrc_grp_23_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>  };
> 
>  IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_23_RSRC_TYPE, 
> src_rsrc_grp_23_rsrc_type,
>  		      0x00000404, 0x0020);
> 
>  static const u32 ipa_reg_src_rsrc_grp_45_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>  };
> 
>  IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_45_RSRC_TYPE, 
> src_rsrc_grp_45_rsrc_type,
>  		      0x00000408, 0x0020);
> 
>  static const u32 ipa_reg_src_rsrc_grp_67_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>  };
> 
>  IPA_REG_STRIDE_FIELDS(SRC_RSRC_GRP_67_RSRC_TYPE, 
> src_rsrc_grp_67_rsrc_type,
>  		      0x0000040c, 0x0020);
> 
>  static const u32 ipa_reg_dst_rsrc_grp_01_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>  };
> 
>  IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_01_RSRC_TYPE, 
> dst_rsrc_grp_01_rsrc_type,
>  		      0x00000500, 0x0020);
> 
>  static const u32 ipa_reg_dst_rsrc_grp_23_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>  };
> 
>  IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_23_RSRC_TYPE, 
> dst_rsrc_grp_23_rsrc_type,
>  		      0x00000504, 0x0020);
> 
>  static const u32 ipa_reg_dst_rsrc_grp_45_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>  };
> 
>  IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_45_RSRC_TYPE, 
> dst_rsrc_grp_45_rsrc_type,
>  		      0x00000508, 0x0020);
> 
>  static const u32 ipa_reg_dst_rsrc_grp_67_rsrc_type_fmask[] = {
> -	[X_MIN_LIM]					= GENMASK(5, 0),
> -						/* Bits 6-7 reserved */
> -	[X_MAX_LIM]					= GENMASK(13, 8),
> -						/* Bits 14-15 reserved */
> -	[Y_MIN_LIM]					= GENMASK(21, 16),
> -						/* Bits 22-23 reserved */
> -	[Y_MAX_LIM]					= GENMASK(29, 24),
> -						/* Bits 30-31 reserved */
> +	[X_MIN_LIM]					= GENMASK(7, 0),
> +	[X_MAX_LIM]					= GENMASK(15, 8),
> +	[Y_MIN_LIM]					= GENMASK(23, 16),
> +	[Y_MAX_LIM]					= GENMASK(31, 24),
>  };
> 
>  IPA_REG_STRIDE_FIELDS(DST_RSRC_GRP_67_RSRC_TYPE, 
> dst_rsrc_grp_67_rsrc_type,
