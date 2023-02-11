Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396EF692D8E
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjBKDQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKDQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:16:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65F519F33
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:16:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5199B61EA0
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51464C433EF;
        Sat, 11 Feb 2023 03:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676085367;
        bh=vUIADas+t3jcb4/76eRImJL4t8weowmILCu1SF2tigg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OIM4nxhXCbY11PrsNl0dVQnCvRvcIwtVwWA1P1y6lJzXe7CBBpJfIJzo9JwvL8ZAz
         3DDobETntf3OF8VAjX4A+XJYuzOzfAceVtm+WF2Y/Vqqo0RRSaW1hnwRbg7eHQNX+v
         FF9lmXXcZTwElqdI911pFgkJBSmNxvRO4jhxeR85zC0zE+uNr7rQEUstwDWf+v4suO
         8Rw/QU5PvUBLbLTes/XK2Zzak91sLWWivT3hgSFxOSz+cuYi39mtzKZyGcPEqQfdmk
         NTYWAgZrVa6M2ukZYD6Q/mHl35fRiQVR+9h2OUebB2FRsTqsb9GWcxcWWmN32/yaQK
         42kMW4lt8YTfQ==
Date:   Fri, 10 Feb 2023 19:16:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com" 
        <syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2 net 1/1] tipc: fix kernel warning when sending SYN
 message
Message-ID: <20230210191606.29b8db03@kernel.org>
In-Reply-To: <DB9PR05MB907893AE1AECD3CA1F91D40F88D99@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230208070759.462019-1-tung.q.nguyen@dektech.com.au>
        <b36e496792de3d1811ea38f19588e5a5b32a9d2c.camel@redhat.com>
        <DB9PR05MB907893AE1AECD3CA1F91D40F88D99@DB9PR05MB9078.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Feb 2023 11:10:16 +0000 Tung Quang Nguyen wrote:
> >>  	msg_set_size(mhdr, msz);
> >>
> >> +	if (!dsz)
> >> +		iov_iter_init(&m->msg_iter, ITER_SOURCE, NULL, 0, 0);  
> >
> >It looks like the root cause of the problem is that not all (indirect)
> >callers of tipc_msg_build() properly initialize the iter.
> >
> >tipc_connect() is one of such caller, but AFAICS even tipc_accept() can
> >reach tipc_msg_build() without proper iter initialization - via
> >__tipc_sendstream -> __tipc_sendmsg.
> >
> >I think it's better if you address the issue in relevant callers,
> >avoiding unneeded and confusing code in tipc_msg_build().  
>
> I am fully aware of callers (without initializing iovec) of this
> function. My intention was to make as less change as possible.

General kernel guidance is to fix things "right" (i.e. so that the fix
doesn't have to be refactored later). 

> Do you think using  iov_iter_kvec() instead in the callers make sense
> if I go for what you suggested ?

I think so. These are the potential culprits?

$ git grep 'struct msghdr [^*]*;' -- net/tipc/
net/tipc/socket.c:      struct msghdr m = {NULL,};
net/tipc/socket.c:      struct msghdr m = {NULL,};
net/tipc/topsrv.c:      struct msghdr msg;
net/tipc/topsrv.c:      struct msghdr msg = {};
