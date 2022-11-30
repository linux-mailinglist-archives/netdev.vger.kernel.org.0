Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC1863D6F2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiK3NlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiK3NlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:41:11 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF72C66E;
        Wed, 30 Nov 2022 05:41:10 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 276E2C021; Wed, 30 Nov 2022 14:41:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669815671; bh=wK7gil3l4vmYRUAOnl5jdLn8zStI0QDqyB8y/TsL16M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FdFDD6Uz58G4iRZYHOyKH6RPc/FVo2Z/25c6IOj77hlSR4lgSNQibJ5NI7LISZfuB
         oZzJ9Jf/ufYOZUx98saQMf8Xcap4QeWw/9dSAoSh1YEJYnaOlyVHUKdSn3pSkLJ18p
         ys4sYTWU+9+efnM7FqXQz6eZTpyENMJ2ATuOgTVNX3f10P0BU1nMgKJolGVEE+Pt29
         ZbQqfGbOMdhB9oW8WY/CqV45uCbqkW9ADEsWyaZ4vcH9qkLymHttA1AwNhVe583h2Q
         N3r4OvbfCrasV1124k/BujUe9iYC369pK8NOLgpYdj6zPefrLaWUcW8dWXfjdYZfMr
         8ah4ydg3AlGXQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 974EFC009;
        Wed, 30 Nov 2022 14:41:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669815670; bh=wK7gil3l4vmYRUAOnl5jdLn8zStI0QDqyB8y/TsL16M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r+BMqFUF9WKhW5PNf+DWOmHLbcJkGyHVAL+R0MLQ1Kr8M5FadO0kfkdjfObPHvptQ
         9cf4j3/m2WOGjbVJEiFZMmm6CS3Wl1BcTFCIo0xmk3tXpSKxFWW8v8SHBnRArkuR81
         /r/azHxfNFtp3PmgW6PpqE2ETOiz81BS+KPkmX1ZEfHFj0TQc6keWXfr2WhaiQB7CZ
         Ef5tYMo/68sm1fkgXC+xHTRQ2Hq0n6ZbV3ji/yu3bK53rOqpU564liR5kuSXBAYj1p
         EYVtRIPGEGWZnLxLgJHe6KfqJbjpVBoU/m/wroLxtroq4bOiWtxvWmESWsfag/tCMC
         bb1NFfFdU4QaQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 2100fd79;
        Wed, 30 Nov 2022 13:40:55 +0000 (UTC)
Date:   Wed, 30 Nov 2022 22:40:40 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Schspa Shi <schspa@gmail.com>, ericvh@gmail.com, lucho@ionkov.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Message-ID: <Y4ddWNXozZyH+fnc@codewreck.org>
References: <20221129162251.90790-1-schspa@gmail.com>
 <2356667.R3SNuAaExM@silver>
 <Y4dSfYoU6F8+D8ac@codewreck.org>
 <4084178.bTz7GqEF8p@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4084178.bTz7GqEF8p@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Wed, Nov 30, 2022 at 02:25:59PM +0100:
> > I'm also not convinced it'd fix anything here, we're not talking about a
> > real server but about a potential attacker -- if a reply comes in with
> > the next tag while we're allocating it, we'll get the exact same problem
> > as we have right now.
> > Frankly, 9p has no security at all so I'm not sure this is something we
> > really need to worry about, but bugs are bugs so we might as well fix
> > them if someone has the time for that...
> > 
> > Anyway, I can appreciate that logs will definitely be easier to read, so
> > an option to voluntarily switch to cyclic allocation would be more than
> > welcome as a first step and shouldn't be too hard to do...
> 
> I would actually do it the other way around: generating continuous sequential
> tags by default and only reverting back to dense tags if requested by mount
> option.
> 
> Is there any server implementation known to rely on current dense tag
> generation?

No, I thought ganesha did when we discussed it last time, but checked
just now and it appears to be correct.

I had a quick look at other servers I have around (diod uses a plain
list, libixp uses a bucket list like ganesha...), but there are so many
9p servers out here that I'm far from keeping track...

Happy to give it a try and see who complains...

> If there is really some exotic server somewhere that uses e.g. a simple
> constant size array to lookup tags and nobody is able to replace that array by
> a hash table or something for whatever reason, then I am pretty sure that
> server is limited at other ends as well (e.g. small 'msize'). So what we could
> do is adjusting the default behaviour according to the other side and allow to
> explicitly set both sequential and dense tags by mount option (i.e. not just
> a boolean mount option).

Well, TVERSION doesn't have much negotiation capability aside of msize,
not sure what to suggest here...
