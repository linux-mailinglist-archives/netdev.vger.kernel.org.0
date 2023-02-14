Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5D3695AB7
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 08:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjBNHju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 02:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjBNHjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 02:39:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF6619F2A;
        Mon, 13 Feb 2023 23:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 130876145E;
        Tue, 14 Feb 2023 07:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B999C433D2;
        Tue, 14 Feb 2023 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676360387;
        bh=1ENQPyNW69vjbBA2shwFOSxlyq+MMylF+mpCTZgZ798=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WFVCTV2VIhJXWdXZQgz37nagwpHBVehOndcmirazJUlgpnWt1fY4MGzdFRQfIzdJz
         T1PqYSMk/haLIuQnX53hTkWrpRhjCxxPS72vzclcVpRZbcKo8Idvm2HbrbPN3eKQxA
         7CyvsE8OpKstad5I+FUJyXVWYCjkekKfgB07dGHfwoW+2EbPk3JNTyM+K/pvsZkJUs
         n1H0xf68o7G1ezfNsg0RjYBxBvz8AWIR+Vduuv+no2+EWvHIRwYbCmo5dt1jWUvqAt
         o36FwjOPdJn+uWD2ln9TjJaDSHn1kYh5nQeU2A7FolKYNWkTOt0GVyDDR2P6HcWodu
         61d8le4/E1j4g==
Date:   Tue, 14 Feb 2023 09:39:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v7 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <Y+s6vrDLkpLRwtx3@unreal>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
 <20230213183428.10734-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213183428.10734-3-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 06:34:22PM +0000, alejandro.lucero-palau@amd.com wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Add devlink info support for ef100. The information reported is obtained
> through the MCDI interface with the specific meaning defined in new
> documentation file.
> 
> Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  Documentation/networking/devlink/index.rst |   1 +
>  Documentation/networking/devlink/sfc.rst   |  57 +++
>  MAINTAINERS                                |   1 +
>  drivers/net/ethernet/sfc/efx_devlink.c     | 459 +++++++++++++++++++++
>  drivers/net/ethernet/sfc/efx_devlink.h     |  17 +
>  drivers/net/ethernet/sfc/mcdi.c            |  72 ++++
>  drivers/net/ethernet/sfc/mcdi.h            |   3 +
>  7 files changed, 610 insertions(+)
>  create mode 100644 Documentation/networking/devlink/sfc.rst

<...>

> +static void efx_devlink_info_running_v2(struct efx_nic *efx,
> +					struct devlink_info_req *req,
> +					unsigned int flags, efx_dword_t *outbuf)
> +{
> +	char buf[EFX_MAX_VERSION_INFO_LEN];
> +	union {
> +		const __le32 *dwords;
> +		const __le16 *words;
> +		const char *str;
> +	} ver;
> +	struct rtc_time build_date;
> +	unsigned int build_id;
> +	size_t offset;
> +#ifdef CONFIG_RTC_LIB
> +	u64 tstamp;
> +#endif

If you are going to resubmit the series.

Documentation/process/coding-style.rst
  1140 21) Conditional Compilation
  1141 ---------------------------
....
  1156 If you have a function or variable which may potentially go unused in a
  1157 particular configuration, and the compiler would warn about its definition
  1158 going unused, mark the definition as __maybe_unused rather than wrapping it in
  1159 a preprocessor conditional.  (However, if a function or variable *always* goes
  1160 unused, delete it.)

Thanks
