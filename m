Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C38C4CB197
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243412AbiCBVxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:53:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbiCBVxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:53:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C462A8;
        Wed,  2 Mar 2022 13:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TTmCl82JqLan3QsNgtCR8eCTt45Umy9DiqQwuLlp+nY=; b=KfoYwSU15wZdPny08l3cV8PBZu
        suXZGirPexQrDgbQX5uGJbU7Df1yJ1ktmLv0jS0sAZKNx+pJdixfgD4R/TDEPqhbqI3BfNt42pheu
        RjmWCL0DlPB+78SrZXIMGba7JmRb0PQyQQUHkbneh6Acx7Xd1qd6fXDaMXTTVqKiOH3qxy3tAQDOa
        GvCaN0q6n5SXSqbjf6rmf5n5+sqFBgieDDlbNUI+aO5wXsxAJTiY1flBdSrbSaeah/4c62cT3Q8Hb
        UXbPO8ixKuUhGo/2c7lCT4NM75T9VeG9xmm8CWBJ8Utbrwowego6iSKFJmRdAIxORzhTRN/ip1tN8
        MLIdp1Fg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPWt7-004R35-C3; Wed, 02 Mar 2022 21:52:01 +0000
Date:   Wed, 2 Mar 2022 13:52:01 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        NeilBrown <neilb@suse.de>, Vasily Averin <vvs@virtuozzo.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Linux MM <linux-mm@kvack.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH RFC] net: memcg accounting for veth devices
Message-ID: <Yh/nAUkt8iZlvQdc@bombadil.infradead.org>
References: <a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com>
 <YhzeCkXEvga7+o/A@bombadil.infradead.org>
 <20220301180917.tkibx7zpcz2faoxy@google.com>
 <Yh5lyr8dJXmEoFG6@bombadil.infradead.org>
 <87wnhdwg75.fsf@email.froward.int.ebiederm.org>
 <Yh6PPPqgPxJy+Jvx@bombadil.infradead.org>
 <87ilswwh1x.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilswwh1x.fsf@email.froward.int.ebiederm.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 08:43:54AM -0600, Eric W. Biederman wrote:
> Luis Chamberlain <mcgrof@kernel.org> writes:
> 
> > On Tue, Mar 01, 2022 at 02:50:06PM -0600, Eric W. Biederman wrote:
> >> I really have not looked at this pids controller.
> >> 
> >> So I am not certain I understand your example here but I hope I have
> >> answered your question.
> >
> > During experimentation with the above stress-ng test case, I saw tons
> > of thread just waiting to do exit:
> 
> You increment the count of concurrent threads after a no return function
> in do_exit.  Since the increment is never reached the count always goes
> down and eventually the warning prints.
> 
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 80c4a67d2770..653ca7ebfb58 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -881,6 +894,9 @@ void __noreturn do_exit(long code)
> >  
> >  	lockdep_free_task(tsk);
> >  	do_task_dead();
> 
> The function do_task_dead never returns.
> 
> > +
> > +	atomic_inc(&exit_concurrent_max);
> > +	wake_up(&exit_wq);
> >  }
> >  EXPORT_SYMBOL_GPL(do_exit);

Doh thanks!

  Luis
