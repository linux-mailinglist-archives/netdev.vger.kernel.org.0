Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB652413DB5
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhIUWwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhIUWwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 18:52:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DA1C61050;
        Tue, 21 Sep 2021 22:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632264680;
        bh=3ONQKUYvtn5dC7DhJm1qgCJp51KqQSq7kMakzqrJxSI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HVYgkHne0NugeW6AzZYDzwAz8c8B+qiyMehw29xO98gv/Lu9RGJFYLZRj9gUXHyVN
         NDZY3s0LI+2uatQmrR8G4ilnyTrkxig3hvFaauI7STD/BzfybydaP3Yf2+uqCwpIpm
         K8VUIZ6D8iQmL/i6FjA2mHExW4kpkb1vbBJ9WyoAx7O7j9dh4yizh25rJNpzPtp/8F
         GgGTnWGycZ3GFQI4AHLmvReaUYfN9cg5GFxawQ8CG6l71gunH+NsG1um+Lq4zOqVmy
         AXmVKmVT8BXeG6XEpsmRBuS9KLvmew+PlKwTHuTbX2SawS6P/NDD2eWyPkuVdqbpP5
         5YGVdjSE5Ntqg==
Date:   Tue, 21 Sep 2021 15:51:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
Message-ID: <20210921155118.439c0aa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87czp13718.fsf@toke.dk>
References: <87o88l3oc4.fsf@toke.dk>
        <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
        <87ilyt3i0y.fsf@toke.dk>
        <CAADnVQKi_u6yZnsxEagNTv-XWXtLPpXwURJH0FnGFRgt6weiww@mail.gmail.com>
        <87czp13718.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Sep 2021 00:20:19 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Neither of those are desirable outcomes, I think; and if we add a
> >> separate "XDP multi-buff" switch, we might as well make it system-wide=
? =20
> >
> > If we have an internal flag 'this driver supports multi-buf xdp' cannot=
 we
> > make xdp_redirect to linearize in case the packet is being redirected
> > to non multi-buf aware driver (potentially with corresponding non mb aw=
are xdp
> > progs attached) from mb aware driver? =20
>=20
> Hmm, the assumption that XDP frames take up at most one page has been
> fundamental from the start of XDP. So what does linearise mean in this
> context? If we get a 9k packet, should we dynamically allocate a
> multi-page chunk of contiguous memory and copy the frame into that, or
> were you thinking something else?

My $.02 would be to not care about redirect at all.

It's not like the user experience with redirect is anywhere close=20
to amazing right now. Besides (with the exception of SW devices which
will likely gain mb support quickly) mixed-HW setups are very rare.
If the source of the redirect supports mb so will likely the target.
