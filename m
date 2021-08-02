Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EED3DE08C
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhHBUUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHBUUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC8C76100A;
        Mon,  2 Aug 2021 20:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627935632;
        bh=7kWcXJ8N/T/jkZjiss2bkWQF4T6OW/383ybYRdbGORE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QwJFRjEmSk59htRDW6cGjkVTreJ1uZbsGPgIW9MWlX6xkP/TK/ZLZerkmu8xOtwI6
         tSumtzOrsDGvHO+MwhAGYthMuKqTirSefG+PP9b04wMcpGAXDT8ai+kdmPnLgVZRaj
         +It/ufcocJSJGO1O/96lonTsuzJ/ymI47lLQsEbxzIzJsR5pBeTq82PyT+EAsq+Mb/
         QZgRhQpJ9IrHCR+azN8N8C8c1tYbAI6asGleBIxquxXEog7nSfF7TLZBg3oLVdaym4
         jw6R/UFWLrohlJpF4/Q8Zv5TGDKvp44wwPz2KvFloxp4DRXTi7+sMIStMEjmU/Czgx
         Hc/DKoRCwDurw==
Date:   Mon, 2 Aug 2021 13:20:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Ahern <dsahern@kernel.org>, ciorneiioana@gmail.com,
        Yajun Deng <yajun.deng@linux.dev>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next] ipv4: Fix refcount warning for new fib_info
Message-ID: <20210802132031.2331e6b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <21559c43-d034-2352-efe4-b366d659da7c@gmail.com>
References: <20210802160221.27263-1-dsahern@kernel.org>
        <332304e5-7ef7-d977-a777-fd513d6e7d26@tessares.net>
        <21559c43-d034-2352-efe4-b366d659da7c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Aug 2021 12:04:01 -0600 David Ahern wrote:
> On 8/2/21 11:58 AM, Matthieu Baerts wrote:
> > Hi David,
> > 
> > On 02/08/2021 18:02, David Ahern wrote:  
> >> Ioana reported a refcount warning when booting over NFS:
> >>
> >> [    5.042532] ------------[ cut here ]------------
> >> [    5.047184] refcount_t: addition on 0; use-after-free.
> >> [    5.052324] WARNING: CPU: 7 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0xa4/0x150
> >> ...
> >> [    5.167201] Call trace:
> >> [    5.169635]  refcount_warn_saturate+0xa4/0x150
> >> [    5.174067]  fib_create_info+0xc00/0xc90
> >> [    5.177982]  fib_table_insert+0x8c/0x620
> >> [    5.181893]  fib_magic.isra.0+0x110/0x11c
> >> [    5.185891]  fib_add_ifaddr+0xb8/0x190
> >> [    5.189629]  fib_inetaddr_event+0x8c/0x140
> >>
> >> fib_treeref needs to be set after kzalloc. The old code had a ++ which
> >> led to the confusion when the int was replaced by a refcount_t.  
> > 
> > Thank you for the patch!
> > 
> > My CI was also complaining of not being able to run kernel selftests [1].
> > Your patch fixes the issue, thanks!
> > 
> > Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> >   
> 
> Given how easily it is to trigger the warning, I get the impression the
> original was an untested patch.

Yeah :( In hindsight any refcount patch which doesn't contain a
refcount_set() is suspicious. Thanks for the quick fix, applied!
