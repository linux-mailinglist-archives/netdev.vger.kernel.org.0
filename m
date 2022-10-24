Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A1460A7E2
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 15:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbiJXNAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 09:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbiJXM7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 08:59:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A4D9A2B0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 05:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5047C61333
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 12:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3347DC433D7;
        Mon, 24 Oct 2022 12:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666613790;
        bh=Xx5tTP3pvNhKb1i5IJPWHoMmha+2D4WmXgj5im+1Dk8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rWXaO9ofLYJF7plkMdpLW11trYt0IEoYzrNRHrEfAgrBOJalDPb7hwi9EggttVBEJ
         21mNAn5Bly3saDl6sKRghOCw8y5BgifGpy3ADwEc/7pTzlfZS4PPF4+eC+Ok26IrYF
         04hFwUrF6K8TBActU4r1jeUBfh188SFhwCLesQEYrscC1cXr1faEQX+3Hu6FARncws
         O7aJRIPrLBB0npJf91jEMsjenUDwFIQmy9r0W8OIPqF30Lhn22w+9ZnKqaENcXTZjC
         xghDIKqJkH4WFLygi7E23W82SsJy3xMLh49ALqBNGuh4hKJjMnU8kHSay7HbN+mtQb
         utWEZ0bKwm/fw==
Date:   Mon, 24 Oct 2022 15:16:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net-next 3/5] ionic: new ionic device identity level and
 VF start control
Message-ID: <Y1aCGgypfvK/+iwn@unreal>
References: <20221024101717.458-1-snelson@pensando.io>
 <20221024101717.458-4-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024101717.458-4-snelson@pensando.io>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 03:17:15AM -0700, Shannon Nelson wrote:
> A new ionic dev_cmd is added to the interface in ionic_if.h,
> with a new capabilities field in the ionic device identity to
> signal its availability in the FW.  The identity level code is
> incremented to '2' to show support for this new capabilities
> bitfield.
> 
> If the driver has indicated with the new identity level that
> it has the VF_CTRL command, newer FW will wait for the start
> command before starting the VFs after a FW update or crash
> recovery.
> 
> This patch updates the driver to make use of the new VF start
> control in fw_up path to be sure that the PF has set the user
> attributes on the VF before the FW allows the VFs to restart.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  .../net/ethernet/pensando/ionic/ionic_dev.c   | 20 +++++++++
>  .../net/ethernet/pensando/ionic/ionic_dev.h   |  3 ++
>  .../net/ethernet/pensando/ionic/ionic_if.h    | 41 +++++++++++++++++++
>  .../net/ethernet/pensando/ionic/ionic_lif.c   |  2 +
>  .../net/ethernet/pensando/ionic/ionic_main.c  |  2 +-
>  5 files changed, 67 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> index 9d0514cfeb5c..20a0d87c9fce 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
> @@ -481,6 +481,26 @@ int ionic_dev_cmd_vf_getattr(struct ionic *ionic, int vf, u8 attr,
>  	return err;
>  }
>  
> +void ionic_vf_start(struct ionic *ionic, int vf)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.vf_ctrl.opcode = IONIC_CMD_VF_CTRL,
> +	};
> +
> +	if (!(ionic->ident.dev.capabilities & cpu_to_le64(IONIC_DEV_CAP_VF_CTRL)))
> +		return;
> +
> +	if (vf == -1) {
> +		cmd.vf_ctrl.ctrl_opcode = IONIC_VF_CTRL_START_ALL;
> +	} else {
> +		cmd.vf_ctrl.ctrl_opcode = IONIC_VF_CTRL_START;
> +		cmd.vf_ctrl.vf_index = cpu_to_le16(vf);
> +	}

<...>

> +	ionic_vf_start(ionic, -1)

I see only call with "-1" in this series. It is better to add code when
it is actually used.

Thanks
