Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E8E5F43E3
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 15:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiJDNEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 09:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJDNEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 09:04:14 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB923DFA9;
        Tue,  4 Oct 2022 06:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=dVELfXXKaUTmoJi2M9apcMe3aQMNvoEJTLoWDD56CtU=; b=QUwLAfMLOiMchFX/9mW7ciLofG
        a/OkgpR/X5Z24OhzCyY86Fo+bwBchjMffoz8li4DQ9wRiIWtsI+bEDEXlCPl5JDarnfvdCIJlcjOZ
        fm7ewLLvjRKUyTEhHY38bRbmddwGsylLIAdPLhF90nLO9ceyb8xwk9LptYwE4MVr46TsOWkZp36S+
        SfL0oVdJLuqM1RpW1xWWkW2SzQUhElcVverDWHm1lUYvmH5zJ26Hx97p95iL+yTYSORthBUhcLPuz
        o5NEv9w19B0DiqB6jpLnhlGjRhANsqfbx2YCiZgwZCK0FjKUo4znXg44vQm50H+BQomTjrTqpGC3S
        1+EW6vVNW8Di/WESbPl4J5ppmOwz+aD9N88BOQ9NE+0BcfDflSLkP1xJqpaR+3rDCWA6SMGC+vhXv
        ZmAgqIKF4tQH5znwGs0+Yc0v7xCV6qOG47jy/HfaQ6u7vY/qMtBw/5godIJq8KraBGvcPAEi6L7jY
        wBqxW2d6yyip/Nt1dhcRMOap8Z+saxLiovKkMPG+ydo9rfTA22UPYKcS391aET4i+HDu6fLQLpj1s
        Mn7Z5a6hffG9pt7Donok4gWSEKIKfs688ldwXsXjXCYDeNwwIzqQsVZUxRbe1huh7NZ0vk1pNqYS3
        kxfLSRr1TQjHTr/IyoSsWLyw2H5kEoTK5vB2YBBTs=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Leon Romanovsky <leon@kernel.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org,
        syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/2] 9p: destroy client in symmetric order
Date:   Tue, 04 Oct 2022 15:03:08 +0200
Message-ID: <4813311.ZYo2F6apM6@silver>
In-Reply-To: <YzV5J9NmL7hijFTR@unreal>
References: <cover.1664442592.git.leonro@nvidia.com> <YzVzjR4Yz3Oo3JS+@codewreck.org>
 <YzV5J9NmL7hijFTR@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Donnerstag, 29. September 2022 12:53:27 CEST Leon Romanovsky wrote:
> On Thu, Sep 29, 2022 at 07:29:33PM +0900, Dominique Martinet wrote:
> > Leon Romanovsky wrote on Thu, Sep 29, 2022 at 12:37:56PM +0300:
> > > Make sure that all variables are initialized and released in correct
> > > order.
> > 
> > Haven't tried running or compiling, comments out of my head that might
> > be wrong below
> > 
> > > Reported-by: syzbot+de52531662ebb8823b26@syzkaller.appspotmail.com
> > 
> > You're adding this report tag but I don't see how you fix that failure.
> > What you need is p9_tag_cleanup(clnt) from p9_client_destroy -- I assume
> > this isn't possible for any fid to be allocated at this point so the fid
> > destroying loop is -probably- optional.
> > 
> > I would assume it is needed from p9_client_version failures.
> > 
> > > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> > > ---
> > > 
> > >  net/9p/client.c | 37 ++++++++++++-------------------------
> > >  1 file changed, 12 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/net/9p/client.c b/net/9p/client.c
> > > index aaa37b07e30a..8277e33506e7 100644
> > > --- a/net/9p/client.c
> > > +++ b/net/9p/client.c
> > > @@ -179,7 +179,6 @@ static int parse_opts(char *opts, struct p9_client
> > > *clnt)> > 
> > >  				goto free_and_return;
> > >  			
> > >  			}
> > > 
> > > -			v9fs_put_trans(clnt->trans_mod);
> > 
> > Pretty sure you'll be "leaking transports" if someone tries to pass
> > trans=foo multiple times; this can't be removed...(continues below)...
> 
> It is pity, you are right.
> 
> Thanks

Hi Leon,

have you planned a v2 on this? Just asking, so that we know whether to go 
forward.

Best regards,
Christian Schoenebeck


