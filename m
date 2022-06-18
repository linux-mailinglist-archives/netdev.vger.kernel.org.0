Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7DF55069B
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiFRTlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 15:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiFRTlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 15:41:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCBC13D1C;
        Sat, 18 Jun 2022 12:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=a0bL49uOiCfKwT3pkrVPnT1ka4/B28/6uyQ2X04Z2uE=; b=v7sWJzFOGdSYdZIqrUgltulDvB
        4OYLCiBKpTU/gxVWoe7+5BZDCThsZIpeVflFB2hKb9xef5S9oR1IzVv/TIPNZ8352DZ7L4y2H9bjc
        Jmm3lucQ5r46W+jh0YPPdpufOhL0oc+6u/z1/HnxocLAcrLExQk/tV+r89h7h2rJBW7HkWMzNVF0q
        +WIbMin/lIE9rFhhyDjKdL9OzkPDDLx9So6dRWroeqd+o2BLMeRQMd+jBz8OKtZA/L9fXvpViA0ij
        3FOXifV7VGCmCrmPC9jPkGMAJgjGydG1JnS8N8FfoYeqV3urXj5BnPigDS9O7tvXEKOSK4e67Qkxt
        5/OlBqAw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2eIt-003s30-RQ; Sat, 18 Jun 2022 19:40:19 +0000
Date:   Sat, 18 Jun 2022 20:40:19 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ralph Corderoy <ralph@inputplus.co.uk>
Cc:     Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH v2] Implement close-on-fork
Message-ID: <Yq4qIxh5QnhQZ0SJ@casper.infradead.org>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
 <20220618114111.61EC71F981@orac.inputplus.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220618114111.61EC71F981@orac.inputplus.co.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 18, 2022 at 12:41:11PM +0100, Ralph Corderoy wrote:
> Hi Nate,
> 
> > One manifestation of this is a race conditions in system(), which
> > (depending on the implementation) is non-atomic in that it first calls
> > a fork() and then an exec().
> 
> The need for O_CLOFORK might be made more clear by looking at a
> long-standing Go issue, i.e. unrelated to system(3), which was started
> in 2017 by Russ Cox when he summed up the current race-condition
> behaviour of trying to execve(2) a newly created file:
> https://github.com/golang/go/issues/22315.  I raised it on linux-kernel
> in 2017, https://marc.info/?l=linux-kernel&m=150834137201488, and linked
> to a proposed patch from 2011, ‘[PATCH] fs: add FD_CLOFORK and
> O_CLOFORK’ by Changli Gao.  As I said, long-standing.

The problem is that people advocating for O_CLOFORK understand its
value, but not its cost.  Other google employees have a system which has
literally millions of file descriptors in a single process.  Having to
maintain this extra state per-fd is a cost they don't want to pay
(and have been quite vocal about earlier in this thread).

Fundamentally, fork()+exec() is a terrible model.  Mind you, so is
spawn().  I haven't seen a good model yet.
