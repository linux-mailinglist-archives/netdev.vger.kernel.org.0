Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C35605230
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJSVpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiJSVpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:45:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8B3100BFE
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:45:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3D0DB825A8
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 21:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B520FC433C1;
        Wed, 19 Oct 2022 21:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666215936;
        bh=xK2LKxhBPocv8yvh8gfXWEa4J4Nrbeiiam+NFDCv0Ww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WhFOxcf0VuOg9xL15+hZg0W6oT0JjmgiDG+2fY3a2L+M2d5ED9Y7Te5scoKVqJWcV
         9L9QRKSqfQ0Eq0ooGMOkI+EfIxXT3k4NIqttZqgpl9dLjFn1QA7uDw4ee89zUgfMxT
         c2GnnawgyvMzBwwwrXGOk+f5zEKT4BfmhBy9iG9P2cBG5SNVZ5HqsfjoJ6NpLNkUeU
         MVKT53UmvRbKczIZCyFsloTVeH188J9Cr1xVGULxVr7d6oRly/TJDbzb3Sj3/FuZnq
         LtoAhKkei1QrwST6MEJfyZL6xGP6GHW/aWlqHbPJ9dpnNhPX0yfX694K4XiYne+c93
         65rzjqu2lKEcA==
Date:   Wed, 19 Oct 2022 14:45:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <davem@davemloft.net>, <johannes@sipsolutions.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
Subject: Re: [PATCH net-next 05/13] genetlink: check for callback type at op
 load time
Message-ID: <20221019144534.04d22ced@kernel.org>
In-Reply-To: <61006364-2cde-3b9d-8a6f-6e7daf99c55f@intel.com>
References: <20221018230728.1039524-1-kuba@kernel.org>
        <20221018230728.1039524-6-kuba@kernel.org>
        <61006364-2cde-3b9d-8a6f-6e7daf99c55f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Oct 2022 14:33:39 -0700 Jacob Keller wrote:
> > +static int
> >  genl_cmd_full_to_split(struct genl_split_ops *op,
> >  		       const struct genl_family *family,
> >  		       const struct genl_ops *full, u8 flags)
> >  {
> > +	if ((flags & GENL_CMD_CAP_DO && !full->doit) ||
> > +	    (flags & GENL_CMD_CAP_DUMP && !full->dumpit)) {
> > +		memset(op, 0, sizeof(*op));
> > +		return -ENOENT;
> > +	}
> > +  
> 
> Should this check that exactly one of GENL_CMD_CAP_DO and
> GENL_CMD_CAP_DUMP is set? Or is some earlier flow enforcing this?

I check at registration time that the family-provided flags only 
have one of those two set. Internally, inside genetlink.c it'd be 
a programming error to request both at the same time, IOW it'd be
defensive programming to check for it.
