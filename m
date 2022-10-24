Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAAC60BA0A
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbiJXUY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiJXUXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:23:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A1B53D03
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EBE0B815FB
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 12:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AE5C433C1;
        Mon, 24 Oct 2022 12:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666613555;
        bh=poBH5LVNwRO8o25lSW4LUN4hfa8IFc+799xDpC5kuU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kFcqyElFqmU7qe9rsMwONa/0wtqPFeI28lTY6sZv6XxcNhBoCGGJLQcLP6I3RuC/5
         vDkDFBjbxeSn+lqQqns3xSzP1Sy6diIqIOqBotmafKKm9RXQrYvIQNYYcN7D25p2ki
         tKKNDJe50MAi4Q+liehR8jOVWDtSUkZ+cyOCSpcjWoKtDYPEZzYjnQZzWR3/TdQXgL
         mLM+98CIeuccdPVx8+9Kk59mMGMU2EfYcmhI6gfee9lclYZ0+YPjfSpURVUM0Fsq4S
         bikCYepeHMgrtNEHFoK8Onkl/DNABAUKa/0MlCCH4tBWfvUyeO9+84xsjv1OSXYb2x
         bS6HVrBpSiHSQ==
Date:   Mon, 24 Oct 2022 15:12:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net-next 1/5] ionic: replay VF attributes after fw crash
 recovery
Message-ID: <Y1aBL+jfY8uXS9Yx@unreal>
References: <20221024101717.458-1-snelson@pensando.io>
 <20221024101717.458-2-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024101717.458-2-snelson@pensando.io>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 03:17:13AM -0700, Shannon Nelson wrote:
> The VF attributes that the user has set into the FW through
> the PF can be lost over a FW crash recovery.  Much like we
> already replay the PF mac/vlan filters, we now add a replay
> in the recovery path to be sure the FW has the up-to-date
> VF configurations.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  .../net/ethernet/pensando/ionic/ionic_lif.c   | 70 +++++++++++++++++++
>  1 file changed, 70 insertions(+)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 19d4848df17d..5d593198ad72 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -2562,6 +2562,74 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
>  	return ret;
>  }
>  
> +static void ionic_vf_attr_replay(struct ionic_lif *lif)
> +{
> +	struct ionic_vf_setattr_cmd vfc = { 0 };

There is no need in 0 for {} installations.

<...>

> +			(void)ionic_set_vf_config(ionic, i, &vfc);

No need to cast return type of function, it is not kernel style.

Thanks
