Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C233148DA
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhBIGaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:30:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230269AbhBIG3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 01:29:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E32A64E8C;
        Tue,  9 Feb 2021 06:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612852147;
        bh=K25iNb1rh/gKqTgVFxTrczRoT/80KSzESkfb4xiDHGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ROzKHV0WvQyqm0TqNeLV451j7H2by4fBMbh/KpzDqOujh/YETWJy1TMwt+09dGQ5D
         bdqpP9MHLesiNBJX0UYV1KKFsDAo7wmhHJj/wtZfTy/Y0XZ+wcD3hMg/ZBsEhrrxd3
         OK3cL1CjSBRvDNpCllE0rRKHKGP2v/BNJ8xedzFm0GMtXnKazheben2CggXvCBieZT
         9JTRkxaeSOYba7uPvzpA0gajjvuyi0vn6jo931wkN9GXUohqf9X08C+GvWWK7gEfkF
         7EHjVTHgLgdhFFLn7gr0HmWASiojTWwGgNn6dZkldtceQkIYJeMRTyus+CUwexrl70
         oemYj382SND3A==
Date:   Tue, 9 Feb 2021 08:29:03 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210209062903.GA139298@unreal>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207082654.GC4656@unreal>
 <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com>
 <20210208185323.11c2bacf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <af35d535-8d58-3cf3-60e3-1764e409308b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af35d535-8d58-3cf3-60e3-1764e409308b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 08:20:29PM -0700, David Ahern wrote:
> On 2/8/21 7:53 PM, Jakub Kicinski wrote:
> > On Mon, 8 Feb 2021 19:24:05 -0700 David Ahern wrote:
> >> On 2/8/21 11:41 AM, Jakub Kicinski wrote:
> >>> On Sun, 7 Feb 2021 10:26:54 +0200 Leon Romanovsky wrote:
> >>>> There is a check that len is not larger than zs and users can't give
> >>>> large buffer.
> >>>>
> >>>> I would say that is pretty safe to write "if (zc.reserved)".
> >>>
> >>> Which check? There's a check which truncates (writes back to user space
> >>> len = min(len, sizeof(zc)). Application can still pass garbage beyond
> >>> sizeof(zc) and syscall may start failing in the future if sizeof(zc)
> >>> changes.
> >>
> >> That would be the case for new userspace on old kernel. Extending the
> >> check to the end of the struct would guarantee new userspace can not ask
> >> for something that the running kernel does not understand.
> >
> > Indeed, so we're agreeing that check_zeroed_user() is needed before
> > original optlen from user space gets truncated?
> >
>
> I thought so, but maybe not. To think through this ...
>
> If current kernel understands a struct of size N, it can only copy that
> amount from user to kernel. Anything beyond is ignored in these
> multiplexed uAPIs, and that is where the new userspace on old kernel falls.
>
> Known value checks can only be done up to size N. In this case, the
> reserved field is at the end of the known struct size, so checking just
> the field is fine. Going beyond the reserved field has implications for
> extensions to the API which should be handled when those extensions are
> added.

It is handled.
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/tcp.c#n4155
		if (len > sizeof(zc)) {
			len = sizeof(zc);
			if (put_user(len, optlen))
				return -EFAULT;
		}

Thanks

>
> So, in short I think the "if (zc.reserved)" is correct as Leon noted.
