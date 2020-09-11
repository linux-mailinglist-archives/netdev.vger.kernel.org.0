Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF2E2669C7
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 22:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgIKUxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 16:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgIKUx1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 16:53:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BC70221EB;
        Fri, 11 Sep 2020 20:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599857606;
        bh=7sUDuRPFgYgAfOKSsZBtuWPQtORE2Lqc+qdgMOhLECw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j4C/uEaTbYmkPxfVovH4lGRpYCTVWQk+g6LoVAafMtFKVo3jslkH737FcPjUOlQ0e
         neIFKf/dPlTJ8okCMkNCmx7bZi7WlPm8dcpB4gvtYWSJpqeuKKNCTi2E76F4gO/GQ3
         545xBBXSwAz4IcEbTOriXo631MnsOBawCedne+mE=
Date:   Fri, 11 Sep 2020 13:53:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <skardach@marvell.com>
Cc:     <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] octeontx2-af: add support for custom KPU
 entries
Message-ID: <20200911135324.6418b50c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911132124.7420-4-skardach@marvell.com>
References: <20200911132124.7420-1-skardach@marvell.com>
        <20200911132124.7420-4-skardach@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 15:21:24 +0200 skardach@marvell.com wrote:
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> index 6bfb9a9d3003..fe164b85adfb 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> @@ -148,7 +148,7 @@ struct npc_kpu_profile_cam {
>  	u16 dp1_mask;
>  	u16 dp2;
>  	u16 dp2_mask;
> -};
> +} __packed;
>  
>  struct npc_kpu_profile_action {
>  	u8 errlev;
> @@ -168,7 +168,7 @@ struct npc_kpu_profile_action {
>  	u8 mask;
>  	u8 right;
>  	u8 shift;
> -};
> +} __packed;
>  
>  struct npc_kpu_profile {
>  	int cam_entries;
> @@ -323,6 +323,15 @@ struct npc_mcam_kex {
>  	u64 intf_ld_flags[NPC_MAX_INTF][NPC_MAX_LD][NPC_MAX_LFL];
>  } __packed;
>  
> +struct npc_kpu_fwdata {
> +	int	entries;
> +	/* What follows is:
> +	 * struct npc_kpu_profile_cam[entries];
> +	 * struct npc_kpu_profile_action[entries];
> +	 */
> +	u8	data[0];
> +} __packed;

Why do you mark a structure with a single int member as __packed?

Please drop all the __packed attrs you add in this series.

>  module_param(mkex_profile, charp, 0000);
>  MODULE_PARM_DESC(mkex_profile, "MKEX profile name string");
>  
> +static char *kpu_profile; /* KPU profile name */
> +module_param(kpu_profile, charp, 0000);
> +MODULE_PARM_DESC(kpu_profile, "KPU profile name string");

Why do you need a module parameter for this?

Just decide on a filename, always request it, and if user doesn't want
to load a special profile you'll get a -ENOENT and move on.
