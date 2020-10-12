Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1736228B26C
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387752AbgJLKkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 06:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387632AbgJLKkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 06:40:47 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0110CC0613CE;
        Mon, 12 Oct 2020 03:40:46 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 6A40AC009; Mon, 12 Oct 2020 12:40:45 +0200 (CEST)
Date:   Mon, 12 Oct 2020 12:40:30 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: 9p: initialize sun_server.sun_path to have
 addr's value only when addr is valid
Message-ID: <20201012104030.GA888@nautica>
References: <20201012042404.2508-1-anant.thazhemadam@gmail.com>
 <20201012075910.GA17745@nautica>
 <147004bd-5cff-6240-218d-ebd80a9b48a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <147004bd-5cff-6240-218d-ebd80a9b48a1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Anant Thazhemadam wrote on Mon, Oct 12, 2020:
> You mentioned how a fully zeroed address isn't exactly faulty. By extension, wouldn't that
> mean that an address that simply begins with a 0 isn't faulty as well?

That is correct.
If you have a look at the unix(7) man page that describes AF_UNIX, it
describes what 'abstract' addresses are and unix_mkname() in linux's
net/unix/af_unix.c shows how it's handled.

> This is an interesting point, because if the condition is modified to checking for addr[0] directly,
> addresses that simply begin with 0 (but have more non-zero content following) wouldn't be
> copied over either, right?

Yes, we would reject any address that starts with a nul byte -- but that
is already exactly what your patch does with strlen() already: a '\0' at
the start of the string is equivalent to strlen(addr) == 0.
The only difference is that checking for addr[0] won't run through all
the string if it doesn't start with a nul byte; but this is a one-time
thing at mount so it really doesn't matter.

> In the end, it comes down to what you define as a "valid" value that sun_path can have.
> We've already agreed that a fully zeroed address wouldn't qualify as a valid value for sun_path.
> Are addresses that aren't fully zeroed, but only begin with a 0 also to be considered as an
> unacceptable value for sun_path?

Yes, because the strcpy() a few lines below would copy nothing, leaving
sun_server.sun_path uninitialized like your example.

At that point you could ask why not "fix" that strcpy to properly copy
the address passed instead but that doesn't really make sense given
where 'addr' comes from: it's passed from userspace as a nul-terminated
string, so nothing after the first '\0' is valid.

There probably are ways to work around that (e.g. iproute's ss will
display abstract addresses with a leading '@' instead) but given nobody
ever seemed to care I think it's safe to just return EINVAL there like
you did ; there's nothing wrong with your patch as far as I'm concerned.

-- 
Dominique
