Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9065F1033
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiI3QoT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Sep 2022 12:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiI3QoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:44:11 -0400
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFCE1D7BFF;
        Fri, 30 Sep 2022 09:44:02 -0700 (PDT)
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay03.hostedemail.com (Postfix) with ESMTP id 84EE9A01CA;
        Fri, 30 Sep 2022 16:44:00 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id 11C3C20025;
        Fri, 30 Sep 2022 16:43:50 +0000 (UTC)
Message-ID: <76e4463b9ea5946e7af045363d888b966ba5e209.camel@perches.com>
Subject: Re: [PATCH] net: prestera: acl: Add check for kmemdup
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, pabeni@redhat.com,
        davem@davemloft.net, tchornyi@marvell.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri, 30 Sep 2022 09:43:54 -0700
In-Reply-To: <20220930084431.508ce665@kernel.org>
References: <20220930050317.32706-1-jiasheng@iscas.ac.cn>
         <20220930072952.2d337b3a@kernel.org>
         <e9a52823ea98a0e4a23c38e83d7872faed8c1d6c.camel@perches.com>
         <20220930084431.508ce665@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 11C3C20025
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: 61ufoabfa7a45mcu4iki6kenwd33xat9
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX198I0hx4mTrSvxM4pQ8CA9Ck5yCI/sE/Eo=
X-HE-Tag: 1664556230-106461
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-30 at 08:44 -0700, Jakub Kicinski wrote:
> On Fri, 30 Sep 2022 08:20:47 -0700 Joe Perches wrote:
> > IMO: If Volodymyr wants to be a maintainer here, he should put
> > his email as an entry in the MAINTAINERS file for the subsystem.
> 
> It's about Fixes tags, unfortunately having everyone of note listed 
> in MAINTAINERS is pretty much impossible. Even tho we are trying.
> 
> > > > Maybe there is a problem of the script that misses one.  
> > 
> > I don't think so.  Maybe you have more evidence...
> 
> I'll CC you when I tell people to CC authors of patches under Fixes
> going forward, I don't have a list going back.
> 
> > > > Anyway, I have already submitted the same patch and added
> > > > "vmytnyk@marvell.com" this time.  
> > > 
> > > Ha! So you do indeed use it in a way I wasn't expecting :S
> > > Thanks for the explanation.
> > > 
> > > Joe, would you be okay to add a "big fat warning" to get_maintainer
> > > when people try to use the -f flag?  
> > 
> > No, not really.  -f isn't required when the file is in git anyway.
> 
> Ah. Yeah. I'd make it error out when run on a source file without -f :S
> 
> > > Maybe we can also change the message
> > > that's displayed when the script is run without arguments to not
> > > mention -f?  
> > 
> > I think that's a poor idea as frequently the script isn't used
> > on patches but simply to identify the maintainers of a particular
> > file or subsystem.
> 
> Identify the maintainers and report a bug, or something else? As a
> maintainer I can tell you that I don't see bug reports as often as I
> see trivial patches from noobs which miss CCs. And I personally don't
> think I ever used get_maintainer on anything else than a patch.
> 
> > > We're getting quite a few fixes which don't CC author, I'm guessing
> > > Jiasheng's approach may be a common one.  
> > 
> > There's no great way to identify "author" or "original submitter"
> > and frequently the "original submitter" isn't a maintainer anyway.
> 
> Confusing sentence. We want for people who s-o-b'd the commit under
> Fixes to be CCed.

If a file or a file modified by a patch is listed in the MAINTAINERS,
git history isn't used unless --git is specified.

For a patch, maybe the author and other SOBs of a commit specified
by a "Fixes:" line SHA-1 in the commit message could be added automatically.


