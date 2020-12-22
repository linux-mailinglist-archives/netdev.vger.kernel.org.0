Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2722E0DCB
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 18:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgLVRU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 12:20:26 -0500
Received: from smtp5.emailarray.com ([65.39.216.39]:62189 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgLVRU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 12:20:26 -0500
Received: (qmail 18214 invoked by uid 89); 22 Dec 2020 17:19:43 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 22 Dec 2020 17:19:43 -0000
Date:   Tue, 22 Dec 2020 09:19:40 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH 05/12 v2 RFC] skbuff: replace sock_zerocopy_put() with
 skb_zcopy_put()
Message-ID: <20201222171940.ijpuhkuxhvk33czg@bsd-mbp.dhcp.thefacebook.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-6-jonathan.lemon@gmail.com>
 <CAF=yD-L0uqGHp3u0Oi_eJYZAJ2r8EeaWihiKbK3RVwSTLK87Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-L0uqGHp3u0Oi_eJYZAJ2r8EeaWihiKbK3RVwSTLK87Dg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 09:42:40AM -0500, Willem de Bruijn wrote:
> On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > From: Jonathan Lemon <bsd@fb.com>
> >
> > Replace sock_zerocopy_put with the generic skb_zcopy_put()
> > function.  Pass 'true' as the success argument, as this
> > is identical to no change.
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> uarg->zerocopy may be false if sock_zerocopy_put_abort is called from
> tcp_sendmsg_locked

Yes, it may well be false.  The original logic goes:

   sock_zerocopy_put_abort()
   sock_zerocopy_put()
   sock_zerocopy_callback(..., success = uarg->zerocopy)
     if (success)

The new logic is now:

   sock_zerocopy_put_abort()
   sock_zerocopy_callback(..., success = true)
     uarg->zerocopy = uarg->zerocopy & success
     if (uarg->zerocopy)

The success value ls latched into uarg->zerocopy, and any failure
is persistent.  Hence my comment about passing 'true' not changing
the logic.
-- 
Jonathan
