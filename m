Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126936A6B2A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 11:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjCAK6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 05:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCAK6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 05:58:04 -0500
X-Greylist: delayed 543 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Mar 2023 02:57:53 PST
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD101FEE
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 02:57:52 -0800 (PST)
Received: from momiji.horms.nl (2a02-a46e-7b6b-703-d63d-7eff-fe99-ac9d.fixed6.kpn.net [IPv6:2a02:a46e:7b6b:703:d63d:7eff:fe99:ac9d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id 38D5D20090;
        Wed,  1 Mar 2023 10:48:48 +0000 (UTC)
Received: by momiji.horms.nl (Postfix, from userid 7100)
        id 76487940476; Wed,  1 Mar 2023 11:48:47 +0100 (CET)
Date:   Wed, 1 Mar 2023 11:48:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH net] ionic: catch failure from devlink_alloc
Message-ID: <Y/8tj+bqGG1g5InQ@vergenet.net>
References: <20230301013623.32226-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301013623.32226-1-shannon.nelson@amd.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.7 at zeeaster
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 05:36:23PM -0800, Shannon Nelson wrote:
> Add a check for NULL on the alloc return.  If devlink_alloc() fails and
> we try to use devlink_priv() on the NULL return, the kernel gets very
> unhappy and panics. With this fix, the driver load will still fail,
> but at least it won't panic the kernel.
> 
> Fixes: 919d13a7e455 ("devlink: Set device as early as possible")

Although the reference commit touched the devlink_alloc() line,
I think the bug was already there, introduced by:

df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")

The code change looks good to me :)

> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index e6ff757895ab..4ec66a6be073 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -61,6 +61,8 @@ struct ionic *ionic_devlink_alloc(struct device *dev)
>  	struct devlink *dl;
>  
>  	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic), dev);
> +	if (!dl)
> +		return NULL;
>  
>  	return devlink_priv(dl);
>  }
> -- 
> 2.17.1
> 
