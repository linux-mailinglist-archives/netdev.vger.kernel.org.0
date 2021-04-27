Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A84036C058
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbhD0HoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:44:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54430 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234964AbhD0HoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 03:44:15 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lbINQ-0008Em-Br; Tue, 27 Apr 2021 15:43:24 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lbINN-0002DQ-QE; Tue, 27 Apr 2021 15:43:21 +0800
Date:   Tue, 27 Apr 2021 15:43:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     harald@skogtun.org, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BISECTED] 5.12 hangs at reboot
Message-ID: <20210427074321.callv22dm4drb2jn@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjjBEkOdj=C2HxjFu0zaKT46Yw52t7PyCCYFRaFdu57Sw@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> At a guess, there is some other sequence that takes the rtnl lock, and
> then takes the wiphy_lock inside of it, and we have a ABBA deadlock.

The most common cause of these lockups is a stray reference on
some kind of a network object, e.g., a socket or some such.  This
then causes the underlying network device to be reference counted
and triggers a lock-up if that network device needs to be removed.

> I _hate_ that stupid rtnl lock. It's come up before. Several times.
> It's probably the most broken lock in the kernel.

Yes, it's the networking equivalent of the BKL.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
