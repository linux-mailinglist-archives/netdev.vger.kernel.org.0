Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70F4625DD5
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 16:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiKKPGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 10:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbiKKPEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 10:04:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8859670195;
        Fri, 11 Nov 2022 07:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DE5B8262F;
        Fri, 11 Nov 2022 15:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285ECC433C1;
        Fri, 11 Nov 2022 15:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668178928;
        bh=RHFd6lZBWi3UidtHgAb7H5B7CyFXKaoJYUnzOJpdDKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wZKtfKCvtkAHcRqegBZ5rvf2fSNNT5Jp9nsa7tHBLJ1FunZbXoHExBErfTh3zuzNX
         r4hkvCOmTK0QrFH0l20rbMnWE8AU+P8nmZyOgzviFZBoh2abXcFzInYkCbLbS13H++
         MWXzls89wSjwmcEEze0qkRehIsJUzk/MHeWbOui4=
Date:   Fri, 11 Nov 2022 16:02:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     haozhe.chang@mediatek.com
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@linux.intel.com>,
        Liu Haijun <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Shang XiaoJing <shangxiaojing@huawei.com>,
        "open list:INTEL WWAN IOSM DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:REMOTE PROCESSOR MESSAGING (RPMSG) WWAN CONTROL..." 
        <linux-remoteproc@vger.kernel.org>,
        "open list:USB SUBSYSTEM" <linux-usb@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, lambert.wang@mediatek.com,
        xiayu.zhang@mediatek.com, hua.yang@mediatek.com
Subject: Re: [PATCH v3] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Message-ID: <Y25j7fTdvCRqr26k@kroah.com>
References: <20221111100840.105305-1-haozhe.chang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221111100840.105305-1-haozhe.chang@mediatek.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 06:08:36PM +0800, haozhe.chang@mediatek.com wrote:
> From: haozhe chang <haozhe.chang@mediatek.com>
> 
> wwan_port_fops_write inputs the SKB parameter to the TX callback of
> the WWAN device driver. However, the WWAN device (e.g., t7xx) may
> have an MTU less than the size of SKB, causing the TX buffer to be
> sliced and copied once more in the WWAN device driver.
> 
> This patch implements the slicing in the WWAN subsystem and gives
> the WWAN devices driver the option to slice(by frag_len) or not. By
> doing so, the additional memory copy is reduced.
> 
> Meanwhile, this patch gives WWAN devices driver the option to reserve
> headroom in fragments for the device-specific metadata.
> 
> Signed-off-by: haozhe chang <haozhe.chang@mediatek.com>
> 
> ---
> Changes in v2
>   -send fragments to device driver by skb frag_list.
> 
> Changes in v3
>   -move frag_len and headroom_len setting to wwan_create_port.
> ---
>  drivers/net/wwan/iosm/iosm_ipc_port.c  |  3 +-
>  drivers/net/wwan/mhi_wwan_ctrl.c       |  2 +-
>  drivers/net/wwan/rpmsg_wwan_ctrl.c     |  2 +-
>  drivers/net/wwan/t7xx/t7xx_port_wwan.c | 34 +++++++--------
>  drivers/net/wwan/wwan_core.c           | 59 ++++++++++++++++++++------
>  drivers/net/wwan/wwan_hwsim.c          |  2 +-
>  drivers/usb/class/cdc-wdm.c            |  2 +-
>  include/linux/wwan.h                   |  6 ++-
>  8 files changed, 73 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_port.c b/drivers/net/wwan/iosm/iosm_ipc_port.c
> index b6d81c627277..dc43b8f0d1af 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_port.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_port.c
> @@ -63,7 +63,8 @@ struct iosm_cdev *ipc_port_init(struct iosm_imem *ipc_imem,
>  	ipc_port->ipc_imem = ipc_imem;
>  
>  	ipc_port->iosm_port = wwan_create_port(ipc_port->dev, port_type,
> -					       &ipc_wwan_ctrl_ops, ipc_port);
> +					       &ipc_wwan_ctrl_ops, 0, 0,
> +					       ipc_port);

How is 0, 0 a valid option here?

and if it is a valid option, shouldn't you just have 2 different
functions, one that needs these values and one that does not?  That
would make it more descriptive as to what those options are, and ensure
that you get them right.

> @@ -112,7 +117,6 @@ void wwan_port_rx(struct wwan_port *port, struct sk_buff *skb);
>   */
>  void wwan_port_txoff(struct wwan_port *port);
>  
> -
>  /**

Unneeded change.

thanks,

greg k-h
