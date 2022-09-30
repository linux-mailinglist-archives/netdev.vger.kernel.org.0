Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035025F119A
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 20:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiI3S2V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Sep 2022 14:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiI3S2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 14:28:19 -0400
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168121B0523;
        Fri, 30 Sep 2022 11:28:15 -0700 (PDT)
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay03.hostedemail.com (Postfix) with ESMTP id 8783CA0529;
        Fri, 30 Sep 2022 18:28:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id 04CC918;
        Fri, 30 Sep 2022 18:28:03 +0000 (UTC)
Message-ID: <8fdc337ca11ddfbca35de824e833a4cd69e624ce.camel@perches.com>
Subject: Re: [PATCH] net: prestera: acl: Add check for kmemdup
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, pabeni@redhat.com,
        davem@davemloft.net, tchornyi@marvell.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri, 30 Sep 2022 11:28:09 -0700
In-Reply-To: <20220930095828.771d1ad5@kernel.org>
References: <20220930050317.32706-1-jiasheng@iscas.ac.cn>
         <20220930072952.2d337b3a@kernel.org>
         <e9a52823ea98a0e4a23c38e83d7872faed8c1d6c.camel@perches.com>
         <20220930084431.508ce665@kernel.org>
         <76e4463b9ea5946e7af045363d888b966ba5e209.camel@perches.com>
         <20220930095828.771d1ad5@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 04CC918
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: u97awime47qnf6s6m1s1kj1hfd4dyw1r
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18ahilX3LXnQGMCNj92nIrnBNRw0mCUl3M=
X-HE-Tag: 1664562483-520278
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-30 at 09:58 -0700, Jakub Kicinski wrote:
> On Fri, 30 Sep 2022 09:43:54 -0700 Joe Perches wrote:
> > > > There's no great way to identify "author" or "original submitter"
> > > > and frequently the "original submitter" isn't a maintainer anyway.  
> > > 
> > > Confusing sentence. We want for people who s-o-b'd the commit under
> > > Fixes to be CCed.  
> > 
> > If a file or a file modified by a patch is listed in the MAINTAINERS,
> > git history isn't used unless --git is specified.
> > 
> > For a patch, maybe the author and other SOBs of a commit specified
> > by a "Fixes:" line SHA-1 in the commit message could be added automatically.
> 
> Yes, git history isn't used, but the Fixes tag are consulted already
> AFAICT. We just need to steer people towards running the script on 
> the patch.
> 
> $ git format-patch net/main~..net/main -o /tmp/
> /tmp/0001-eth-alx-take-rtnl_lock-on-resume.patch
> 
> $ grep Fixes /tmp/0001-eth-alx-take-rtnl_lock-on-resume.patch
> Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
> 
> $ git show 4a5fe57e7751 --pretty='%an <%ae>' --no-patch 
> Johannes Berg <johannes@sipsolutions.net>
> 
> $ ./scripts/get_maintainer.pl  /tmp/0001-eth-alx-take-rtnl_lock-on-resume.patch | grep blame
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS,commit_signer:2/4=50%,blamed_fixes:1/1=100%)
> Johannes Berg <johannes@sipsolutions.net> (blamed_fixes:1/1=100%)

Yeah, you kinda ruined my reveal.  It already does that.

Of course I did that 3 years ago and I forgot about it.

cheers, Joe
