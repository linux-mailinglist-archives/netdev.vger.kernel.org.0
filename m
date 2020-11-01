Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD232A1CA0
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 08:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgKAHnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 02:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgKAHnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 02:43:07 -0500
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8FFE208A9;
        Sun,  1 Nov 2020 07:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604216586;
        bh=qp7HDhOZNF9cCr2O01GugOZ4lkhXue/Od24USAgscpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pTJKakq/BSuUPfzoaIBbvyMOlwYO06+ondNa5cVl2/Ln4vOSoNOggCommoc/aXEuy
         XjTSia9iGweL3fM8G7qaLMgp39Y0l6qNDWjAYanp31Pd3K7DclfzkxnYgz4Y58WOuV
         XnMDmVZvdNeeLJp8JIGooMQ0NCVqDMScHO+x7Zg0=
Date:   Sun, 1 Nov 2020 15:43:01 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     mkl@pengutronix.de, robh+dt@kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 1/6] firmware: imx: always export SCU symbols
Message-ID: <20201101074300.GF31601@dragon>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
 <20201021052437.3763-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021052437.3763-2-qiangqing.zhang@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 01:24:32PM +0800, Joakim Zhang wrote:
> From: Liu Ying <victor.liu@nxp.com>
> 
> Always export SCU symbols for both SCU SoCs and non-SCU SoCs to avoid
> build error.
> 
> Signed-off-by: Liu Ying <victor.liu@nxp.com>
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  include/linux/firmware/imx/ipc.h      | 15 +++++++++++++++

Could you rebase it to my imx/drivers branch?  There is one patch from
Peng Fan that already changed ipc.h.

Shawn

>  include/linux/firmware/imx/svc/misc.h | 23 +++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/include/linux/firmware/imx/ipc.h b/include/linux/firmware/imx/ipc.h
> index 891057434858..300fa253fc30 100644
> --- a/include/linux/firmware/imx/ipc.h
> +++ b/include/linux/firmware/imx/ipc.h
> @@ -34,6 +34,7 @@ struct imx_sc_rpc_msg {
>  	uint8_t func;
>  };
>  
> +#if IS_ENABLED(CONFIG_IMX_SCU)
>  /*
>   * This is an function to send an RPC message over an IPC channel.
>   * It is called by client-side SCFW API function shims.
> @@ -55,4 +56,18 @@ int imx_scu_call_rpc(struct imx_sc_ipc *ipc, void *msg, bool have_resp);
>   * @return Returns an error code (0 = success, failed if < 0)
>   */
>  int imx_scu_get_handle(struct imx_sc_ipc **ipc);
> +
> +#else
> +static inline int
> +imx_scu_call_rpc(struct imx_sc_ipc *ipc, void *msg, bool have_resp)
> +{
> +	return -EIO;
> +}
> +
> +static inline int imx_scu_get_handle(struct imx_sc_ipc **ipc)
> +{
> +	return -EIO;
> +}
> +#endif
> +
>  #endif /* _SC_IPC_H */
> diff --git a/include/linux/firmware/imx/svc/misc.h b/include/linux/firmware/imx/svc/misc.h
> index 031dd4d3c766..d255048f17de 100644
> --- a/include/linux/firmware/imx/svc/misc.h
> +++ b/include/linux/firmware/imx/svc/misc.h
> @@ -46,6 +46,7 @@ enum imx_misc_func {
>   * Control Functions
>   */
>  
> +#if IS_ENABLED(CONFIG_IMX_SCU)
>  int imx_sc_misc_set_control(struct imx_sc_ipc *ipc, u32 resource,
>  			    u8 ctrl, u32 val);
>  
> @@ -55,4 +56,26 @@ int imx_sc_misc_get_control(struct imx_sc_ipc *ipc, u32 resource,
>  int imx_sc_pm_cpu_start(struct imx_sc_ipc *ipc, u32 resource,
>  			bool enable, u64 phys_addr);
>  
> +#else
> +static inline int
> +imx_sc_misc_set_control(struct imx_sc_ipc *ipc, u32 resource,
> +			u8 ctrl, u32 val)
> +{
> +	return -EIO;
> +}
> +
> +static inline int
> +imx_sc_misc_get_control(struct imx_sc_ipc *ipc, u32 resource,
> +			u8 ctrl, u32 *val)
> +{
> +	return -EIO;
> +}
> +
> +static inline int imx_sc_pm_cpu_start(struct imx_sc_ipc *ipc, u32 resource,
> +				      bool enable, u64 phys_addr)
> +{
> +	return -EIO;
> +}
> +#endif
> +
>  #endif /* _SC_MISC_API_H */
> -- 
> 2.17.1
> 
