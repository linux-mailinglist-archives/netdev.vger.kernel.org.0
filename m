Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8806E0E5C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjDMNRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjDMNRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F241A266;
        Thu, 13 Apr 2023 06:17:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC2CC63E39;
        Thu, 13 Apr 2023 13:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6812C433D2;
        Thu, 13 Apr 2023 13:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681391850;
        bh=7uIdzByMCPIBnJwGBw9YRimVbN0v8WEcqNv51/alYJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=REpMDWaIBoLA+IPnRO57KORI9zHTj2xncqoTk5RkrSSPU6NQ7dPvhfKkz2aSHQ5qq
         1jv2sNAXAJfapTbAJFjM8/4kpyvTe3Erv6AfIwWTeJ94CKu4jzS8olCfG9arOtjH2x
         Ua97KXyVwxbpgkZdfhIE3CtVckFUPBiUraFqB3qaQpjb/FdsXAF5HG8ic31ry+Yn/I
         ig4XygzltSNgmZAg8aoA6eRDNsTFjzGkK8IgTFAUdkE+zfC4fbJH7Zi67sNgh+dhNE
         1DGQtGlhqBicsBrg0ewL8HMW15yHQSkz+/waHqeiJ6rNRjFUfAHv+urJLP/r1YYkOR
         rU9ihvvN8gbzQ==
Date:   Thu, 13 Apr 2023 16:17:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH v1] ice: add CGU info to devlink info callback
Message-ID: <20230413131726.GQ17993@unreal>
References: <20230412133811.2518336-1-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412133811.2518336-1-arkadiusz.kubalewski@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 03:38:11PM +0200, Arkadiusz Kubalewski wrote:
> If Clock Generation Unit and dplls are present on NIC board user shall
> know its details.
> Provide the devlink info callback with a new:
> - fixed type object `cgu.id` - hardware variant of onboard CGU
> - running type object `fw.cgu` - CGU firmware version
> - running type object `fw.cgu.build` - CGU configuration build version
> 
> These information shall be known for debugging purposes.
> 
> Test (on NIC board with CGU)
> $ devlink dev info <bus_name>/<dev_name> | grep cgu
>         cgu.id 8032
>         fw.cgu 6021
>         fw.cgu.build 0x1030001
> 
> Test (on NIC board without CGU)
> $ devlink dev info <bus_name>/<dev_name> | grep cgu -c
> 0
> 
> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
> ---
>  Documentation/networking/devlink/ice.rst     | 14 +++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.c | 30 ++++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_main.c    |  5 +++-
>  drivers/net/ethernet/intel/ice/ice_ptp_hw.c  | 12 ++++----
>  drivers/net/ethernet/intel/ice/ice_type.h    |  9 +++++-
>  5 files changed, 62 insertions(+), 8 deletions(-)

<...>

>  Flash Update
>  ============
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index bc44cc220818..06fe895739af 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -193,6 +193,33 @@ ice_info_pending_netlist_build(struct ice_pf __always_unused *pf,
>  		snprintf(ctx->buf, sizeof(ctx->buf), "0x%08x", netlist->hash);
>  }
>  
> +static void ice_info_cgu_id(struct ice_pf *pf, struct ice_info_ctx *ctx)
> +{
> +	if (ice_is_feature_supported(pf, ICE_F_CGU)) {
> +		struct ice_hw *hw = &pf->hw;
> +
> +		snprintf(ctx->buf, sizeof(ctx->buf), "%u", hw->cgu.id);
> +	}

Please use kernel coding style - success oriented flow

struct ice_hw *hw = &pf->hw;

if (!ice_is_feature_supported(pf, ICE_F_CGU))
  return;

snprintf(ctx->buf, sizeof(ctx->buf), "%u", hw->cgu.id);


However, it will be nice to have these callbacks only if CGU is
supported, in such way you won't need any of ice_is_feature_supported()
checks.

Thanks
