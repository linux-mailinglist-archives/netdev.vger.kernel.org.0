Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A80663D61
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbjAJJ5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238264AbjAJJ5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:57:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009C74F13E;
        Tue, 10 Jan 2023 01:57:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0B84B80FED;
        Tue, 10 Jan 2023 09:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACA6C433F0;
        Tue, 10 Jan 2023 09:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673344648;
        bh=LBzK5nBoEJR99O8wtGXtQYNy7sxo8GbARbZALPMRedE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=alOcSdHooOHjkSRa7MVR7vCKkWouHEMYcEZaVYgctLSo8NTAbtJOqY/ErgWZnKpAn
         /MLCea1OLBJAc/aGbS08IW8htZaeTJU7nFp08YoZXLtHQDJaK02Vt6WffpuMZ8sDDy
         mfek+6pBd15fe44oS9EBZh0Slkbjusw46D/g860Fx+YsJi+vB/4LzvjHeglGpC1H95
         wc1Z3NPCBV2LsZuOoM+5YgEdfuZcY1vlmNF526CpzJ8WfrtYF7RWx48x5eoRHt0RmZ
         K2ogr8PAG5rGhg0090WBsHDoSphbo2gJD5TeVIt7dRUDwZ6WbV2vTG2j2odMt8+Mkd
         PiuVLzefFGhig==
Date:   Tue, 10 Jan 2023 11:57:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com
Subject: Re: [net PATCH] octeontx2-pf: Fix resource leakage in VF driver
 unbind
Message-ID: <Y702hDZk3veZzt+b@unreal>
References: <20230109061325.21395-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109061325.21395-1-hkelam@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 11:43:25AM +0530, Hariprasad Kelam wrote:
> resources allocated like mcam entries to support the Ntuple feature
> and hash tables for the tc feature are not getting freed in driver
> unbind. This patch fixes the issue.

It is not clear where in otx2vf_probe() these resource are allocated.
Please add the stack trace to the commit message.

Thanks

> 
> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> index 86653bb8e403..7f8ffbf79cf7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> @@ -758,6 +758,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
>  	if (vf->otx2_wq)
>  		destroy_workqueue(vf->otx2_wq);
>  	otx2_ptp_destroy(vf);
> +	otx2_mcam_flow_del(vf);
> +	otx2_shutdown_tc(vf);
>  	otx2vf_disable_mbox_intr(vf);
>  	otx2_detach_resources(&vf->mbox);
>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
> -- 
> 2.17.1
> 
