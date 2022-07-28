Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464D1584405
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiG1QQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiG1QQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41FC70E4A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E3E461C16
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 16:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3217BC433C1;
        Thu, 28 Jul 2022 16:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659025006;
        bh=ux/7YHZxUFIWKl+XvHkxFh5UY4K7waamoKYm9/SALgw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KpdWX3X4Hlwif1DyyunemnB+GQaUvfguTYMds4Hooa/uqDTqOpRVvcenKvIeDGJwY
         ATZrgrJ/CM3GVE7kkLM8sv41ndi6hcY4z8Z/nw+WMOz58Qn/0a8c4vmR2S4FnAFldv
         OW1d76PgWzYzPEacKALkrsghPye5F7WgBtbqy6Cp7iXF2S7tQ7Wp4p9AfHWBIaMlwq
         nR79zhZc6tFjVToKKXhITNRcrhzRrQUVDss3gun7oW2iYNU0L88Ovi6Ml6cc+EF0P4
         MqKdM1cq6OLi7VNd2MaBs750Rb9UvYucfTu+KysvHdHfKDb2wBFhP0Vtr47QLA7/P/
         pooOxZcjmufEw==
Date:   Thu, 28 Jul 2022 09:16:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/9] net: devlink: remove region snapshots list
 dependency on devlink->lock
Message-ID: <20220728091645.7ffef7da@kernel.org>
In-Reply-To: <YuJN1SYkPR33trcs@nanopsycho>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
        <1658941416-74393-3-git-send-email-moshe@nvidia.com>
        <20220727190156.0ec856ae@kernel.org>
        <YuJN1SYkPR33trcs@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 10:50:29 +0200 Jiri Pirko wrote:
> >> So resolve this by removing dependency on devlink->lock for region
> >> snapshots list consistency and introduce new mutex to ensure it.  
> >
> >I was hoping to avoid per-subobject locks. What prevents us from
> >depending on the instance lock here (once the driver is converted)?  
> 
> The fact that it could be called in mlx4 from both devl locked and
> unlocked context. Basically whenever CMD to fw is called.

Ok, I guess mlx4 uses regions as proto-health reporters so too hard of
a battle to fight. Please update the commit message tho.

> What is wrong in small locks here and there when they are sufficient?

The more locks the less obvious the semantics and ordering of locking
are.
