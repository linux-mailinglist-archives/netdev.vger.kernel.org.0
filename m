Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95B267BA18
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbjAYTCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbjAYTCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:02:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58969CDCB;
        Wed, 25 Jan 2023 11:02:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17F46B81B8C;
        Wed, 25 Jan 2023 19:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F3DC433D2;
        Wed, 25 Jan 2023 19:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674673348;
        bh=RP5Va6toXXyTmcOr/ME//AhDzcNFVNsgf8+hwufjGl0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OvZAxPfjKXDdktK4TkpLMXDuL4L107cdVVZ70PnwD568R3gI+0pb9bt8L790fN2cO
         0EzUCDa6kkq9wiKJndJf4Ce6tFT6lhgwjkri5ihpOt5PBf3p67zOOvnwlXLab5eFiw
         uZz5SAcXwp6zfrhiZf/23QjiJL41EE2/yvMvIZlRFcS1aFtBfMB9pePhbuhwV2FK7R
         hQpP731ZhIaxFfP/jW1ElFNHHCWNw/avRemfV0YMNfl7cCLsdJEHKf/4DubkALGlhv
         kj8g0I5R7tiLa4hLJtPKkhQ2xpa25WBjEdydJD/flvD/WZ/xs/m4FQa5IQoWyJqlYh
         hCmuU/ozTe4xg==
Date:   Wed, 25 Jan 2023 11:02:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next v1 01/10] xfrm: extend add policy callback to
 set failure reason
Message-ID: <20230125110226.66dc7eeb@kernel.org>
In-Reply-To: <c182cae29914fa19ce970859e74234d3de506853.1674560845.git.leon@kernel.org>
References: <cover.1674560845.git.leon@kernel.org>
        <c182cae29914fa19ce970859e74234d3de506853.1674560845.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan 2023 13:54:57 +0200 Leon Romanovsky wrote:
> -	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp);
> +	err = dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
>  	if (err) {
>  		xdo->dev = NULL;
>  		xdo->real_dev = NULL;
>  		xdo->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
>  		xdo->dir = 0;
>  		netdev_put(dev, &xdo->dev_tracker);
> -		NL_SET_ERR_MSG(extack, "Device failed to offload this policy");

In a handful of places we do:

if (!extack->msg)
	NL_SET_ERR_MSG(extack, "Device failed to offload this policy");

in case the device did not provide the extack.
Dunno if it's worth doing here.
