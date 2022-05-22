Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F985304EF
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 19:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349687AbiEVRdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 13:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238490AbiEVRdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 13:33:02 -0400
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3522C659;
        Sun, 22 May 2022 10:33:01 -0700 (PDT)
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id A0C633F4; Sun, 22 May 2022 12:33:00 -0500 (CDT)
Date:   Sun, 22 May 2022 12:33:00 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
        selinux@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Aring <aahringo@redhat.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 8/8] net: use new capable_or functionality
Message-ID: <20220522173300.GA24324@mail.hallyn.com>
References: <20220217145003.78982-2-cgzones@googlemail.com>
 <20220502160030.131168-1-cgzones@googlemail.com>
 <20220502160030.131168-7-cgzones@googlemail.com>
 <20220509171509.GB28406@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220509171509.GB28406@mail.hallyn.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 12:15:09PM -0500, Serge E. Hallyn wrote:
> On Mon, May 02, 2022 at 06:00:29PM +0200, Christian Göttsche wrote:
> > Use the new added capable_or function in appropriate cases, where a task
> > is required to have any of two capabilities.
> > 
> > Reorder CAP_SYS_ADMIN last.
> > 
> > Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> 
> Thanks, for 2-8:
> 
> Reviewed-by: Serge Hallyn <serge@hallyn.com>
> 
> though I'd still like to talk about the name :)

Just checking in - is this being discussed elsewhere?

> > ---
> >  net/caif/caif_socket.c | 2 +-
> >  net/unix/scm.c         | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
> > index 2b8892d502f7..60498148126c 100644
> > --- a/net/caif/caif_socket.c
> > +++ b/net/caif/caif_socket.c
> > @@ -1036,7 +1036,7 @@ static int caif_create(struct net *net, struct socket *sock, int protocol,
> >  		.usersize = sizeof_field(struct caifsock, conn_req.param)
> >  	};
> >  
> > -	if (!capable(CAP_SYS_ADMIN) && !capable(CAP_NET_ADMIN))
> > +	if (!capable_or(CAP_NET_ADMIN, CAP_SYS_ADMIN))
> >  		return -EPERM;
> >  	/*
> >  	 * The sock->type specifies the socket type to use.
> > diff --git a/net/unix/scm.c b/net/unix/scm.c
> > index aa27a02478dc..821be80e6c85 100644
> > --- a/net/unix/scm.c
> > +++ b/net/unix/scm.c
> > @@ -99,7 +99,7 @@ static inline bool too_many_unix_fds(struct task_struct *p)
> >  	struct user_struct *user = current_user();
> >  
> >  	if (unlikely(user->unix_inflight > task_rlimit(p, RLIMIT_NOFILE)))
> > -		return !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN);
> > +		return !capable_or(CAP_SYS_RESOURCE, CAP_SYS_ADMIN);
> >  	return false;
> >  }
> >  
> > -- 
> > 2.36.0
