Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81B047F15A
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 23:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhLXWop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLXWoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 17:44:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF1AC061401
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 14:44:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23F0A612BE
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 22:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAB9C36AE8;
        Fri, 24 Dec 2021 22:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640385882;
        bh=kSRGkQxqetJL9SOE+CQCHr70XtSxVdOEWuWZzZvyyVg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q33+MMMCB+LFTbPc0QaFrgcUuDZXOBDAcocZBtyqTsgnggUZxZbBgXBEIomr9Nhnb
         FULkUEZwdV1SXUFap62bEYBxDlEcdmjoq76z62P8oRLjSbOLkjUQaNfN672UoKnR/6
         fgqPUopyAFq/9mD63tdljNKBq+FK2oWC8kwcl19GS6pLmXB9SjfIQVUaagsyPg1JsR
         ++QGlt5BwbcSnUnsusZmDR0ZlsHJrjmTtF2RRK7wfxL4B/Cwdska4eQc9TY/AIBTXK
         eyM7/FNBxAYob4sufpObYiXp8r6CXGTlkSYVcNtMZVuXs8NGJIOOq9Gx8L/3Omr2ej
         sAV9390D2K+9Q==
Date:   Fri, 24 Dec 2021 14:44:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [net-next v7 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
Message-ID: <20211224144441.534559e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAM_iQpUhNmmxyPXjyRBKzjVkreu0WXvoyOTdxT0pdjUBsFkx6A@mail.gmail.com>
References: <20211224164926.80733-1-xiangxia.m.yue@gmail.com>
        <20211224164926.80733-3-xiangxia.m.yue@gmail.com>
        <CAM_iQpUhNmmxyPXjyRBKzjVkreu0WXvoyOTdxT0pdjUBsFkx6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 11:28:45 -0800 Cong Wang wrote:
> On Fri, Dec 24, 2021 at 8:49 AM <xiangxia.m.yue@gmail.com> wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch allows user to select queue_mapping, range
> > from A to B. And user can use skbhash, cgroup classid
> > and cpuid to select Tx queues. Then we can load balance
> > packets from A to B queue. The range is an unsigned 16bit
> > value in decimal format.
> >
> > $ tc filter ... action skbedit queue_mapping skbhash A B
> >
> > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > is enhanced with flags:
> > * SKBEDIT_F_TXQ_SKBHASH
> > * SKBEDIT_F_TXQ_CLASSID
> > * SKBEDIT_F_TXQ_CPUID  
> 
> NACK.
> 
> These values can either obtained from user-space, or is nonsense
> at all.

Can you elaborate? What values can be obtained from user space?
What is nonsense?

> Sorry, we don't accept enforcing such bad policies in kernel. Please
> drop this patch.

Again, unclear what your objection is. There's plenty similar
functionality in TC. Please be more specific.
