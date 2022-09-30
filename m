Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECA95F105C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiI3Q6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiI3Q6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:58:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CC51D84BB;
        Fri, 30 Sep 2022 09:58:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0014623C9;
        Fri, 30 Sep 2022 16:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A31C433D6;
        Fri, 30 Sep 2022 16:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664557110;
        bh=aHM2nMDTmZpEcstufxGATsDimAceO6QE08Ynuw9qzjs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WOLBdYAiimv8MbQXWWt3CmkSL+OA2K0lXsaSE6tnShn5apMSdpc0ZMGe5YzzjXfD9
         hh6o6ur8QKapeJA3Vhcgplhk3DqpPzH6sdUZNy2XDrsU5IQuHjPIkR/GMQrF3WBzoI
         /Sh8YqY9Mvnxe3QJL2xUMloaFK68JDDw4wbi23rnc/HQ4Dn/NUY8icRh9rCSRa+t+u
         hBbYKdlF80QysnhSHV2Z86/aRjjlF9onicfZTP+PXWkmvAKU1J69wavHgvkcW4xsn6
         dg2ey7LrSSBE8ua1S78lyZS3w1cS1/uw0/Di/qwro+mMKgZqqmO6yz9Yav/wm241nU
         kQeW/7vHGsadg==
Date:   Fri, 30 Sep 2022 09:58:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, pabeni@redhat.com,
        davem@davemloft.net, tchornyi@marvell.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: prestera: acl: Add check for kmemdup
Message-ID: <20220930095828.771d1ad5@kernel.org>
In-Reply-To: <76e4463b9ea5946e7af045363d888b966ba5e209.camel@perches.com>
References: <20220930050317.32706-1-jiasheng@iscas.ac.cn>
        <20220930072952.2d337b3a@kernel.org>
        <e9a52823ea98a0e4a23c38e83d7872faed8c1d6c.camel@perches.com>
        <20220930084431.508ce665@kernel.org>
        <76e4463b9ea5946e7af045363d888b966ba5e209.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 09:43:54 -0700 Joe Perches wrote:
> > > There's no great way to identify "author" or "original submitter"
> > > and frequently the "original submitter" isn't a maintainer anyway.  
> > 
> > Confusing sentence. We want for people who s-o-b'd the commit under
> > Fixes to be CCed.  
> 
> If a file or a file modified by a patch is listed in the MAINTAINERS,
> git history isn't used unless --git is specified.
> 
> For a patch, maybe the author and other SOBs of a commit specified
> by a "Fixes:" line SHA-1 in the commit message could be added automatically.

Yes, git history isn't used, but the Fixes tag are consulted already
AFAICT. We just need to steer people towards running the script on 
the patch.

$ git format-patch net/main~..net/main -o /tmp/
/tmp/0001-eth-alx-take-rtnl_lock-on-resume.patch

$ grep Fixes /tmp/0001-eth-alx-take-rtnl_lock-on-resume.patch
Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")

$ git show 4a5fe57e7751 --pretty='%an <%ae>' --no-patch 
Johannes Berg <johannes@sipsolutions.net>

$ ./scripts/get_maintainer.pl  /tmp/0001-eth-alx-take-rtnl_lock-on-resume.patch | grep blame
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS,commit_signer:2/4=50%,blamed_fixes:1/1=100%)
Johannes Berg <johannes@sipsolutions.net> (blamed_fixes:1/1=100%)
