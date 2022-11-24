Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C79637057
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 03:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKXCUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 21:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXCUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 21:20:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C6A7C00B
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 18:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A456D61FB9
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84F4C433D6;
        Thu, 24 Nov 2022 02:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669256436;
        bh=sX12PsRTV+/jtCQnrWAHSifPO0S/4AT3GgYK/qSzKPE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZGJ6FFag4rZ9jALrWNEi6BphwNql0cCr7b3qbV7GVisOex5QoVgG3R+E4Olce//9p
         79xSC91+3j9KSolPxm9gmlUDl05s1pKUQYjK9emHZkUmf6LkgECKy7ccozRhnFgEpL
         pZiuTfNeDkBLNUxU20HbECRFONvziuK4+lg6wtzvSrxEZJYSEqqBogRc7p2gWFPFJB
         jFsxhzvmquN6WsBnikzglg5gb26r8dFlFDnLIEs141bna5OaVBM85LBG72xl3lTMvZ
         i1lrUT8LoPEzK4m6vCh5X7XlxcECzIBtjLlDkekohQLfQ4C4Q+2JPvNfaV6NljSDgS
         hevPG9Y4jBnPA==
Date:   Wed, 23 Nov 2022 18:20:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <20221123182034.3914e03a@kernel.org>
In-Reply-To: <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
        <Y3zdaX1I0Y8rdSLn@unreal>
        <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
        <Y30dPRzO045Od2FA@unreal>
        <20221122122740.4b10d67d@kernel.org>
        <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
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

On Wed, 23 Nov 2022 14:40:24 +0800 Yang Yingliang wrote:
> >   	if (err)
> > -		goto err_dl_unregister;
> > +		goto err_resource_unregister;
> >   	nsim_devlink_set_params_init_values(nsim_dev, devlink);
> >   
> > +	/* here, because params API still expect devlink to be unregistered */
> > +	devl_register(devlink);
> > +  
> devlink_set_features() called at last in probe() also needs devlink is 
> not registered.

You can move the devlink_set_features() up. It's also a leftover,
it was preventing reload from happening before probe has finished.
Now the instance is locked until probe is done so there is no race.
