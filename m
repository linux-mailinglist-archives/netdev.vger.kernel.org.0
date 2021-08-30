Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD2E3FBA4E
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 18:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbhH3QqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 12:46:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233446AbhH3QqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 12:46:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E234060E90;
        Mon, 30 Aug 2021 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630341926;
        bh=1qZTcEvIsAXBUStNE8UgF9NAfGDDOJr5XumUMJdnFBY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hs71tLE/RxlvQj0tMheczqyzM4fDjXgScgYeTuHGXOdVOGdPDbfiIP9KF1dHstL9h
         OBa6vxnPLnJrvd/x+BNRN4vCL+eokWpBIO7eAn0xej6wdvFXg2+p3DPSZdPUUplypi
         IweUDAd2Hvb3pBlQW29I3cgXHLEBAGUmNwzHWbau7SLJhCtxEmzdIkQNxvkQk+6GDZ
         2VWxLW2fYSD7B8gpNb6xhr9eSQJ519bsuTUhT9Cg0NW/eQHTVID9IQYRu21/hK/nXe
         ng6+jNQsBxVg1Dm7RRW1BWtDWjervsuWQkwSDRXff99BMyXHVLlXT5JSpV/VMwKEkU
         3WEB4rO7Nr5ZA==
Date:   Mon, 30 Aug 2021 09:45:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: fix NULL pointer reference in cipso_v4_doi_free
Message-ID: <20210830094525.3c97e460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHC9VhTEs9E+ZeGGp96NnOhmr-6MZLXf6ckHeG8w5jh3AfgKiQ@mail.gmail.com>
References: <c6864908-d093-1705-76ce-94d6af85e092@linux.alibaba.com>
        <18f0171e-0cc8-6ae6-d04a-a69a2a3c1a39@linux.alibaba.com>
        <CAHC9VhTEs9E+ZeGGp96NnOhmr-6MZLXf6ckHeG8w5jh3AfgKiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 10:17:05 -0400 Paul Moore wrote:
> On Mon, Aug 30, 2021 at 6:28 AM =E7=8E=8B=E8=B4=87 <yun.wang@linux.alibab=
a.com> wrote:
> >
> > In netlbl_cipsov4_add_std() when 'doi_def->map.std' alloc
> > failed, we sometime observe panic:
> >
> >   BUG: kernel NULL pointer dereference, address:
> >   ...
> >   RIP: 0010:cipso_v4_doi_free+0x3a/0x80
> >   ...
> >   Call Trace:
> >    netlbl_cipsov4_add_std+0xf4/0x8c0
> >    netlbl_cipsov4_add+0x13f/0x1b0
> >    genl_family_rcv_msg_doit.isra.15+0x132/0x170
> >    genl_rcv_msg+0x125/0x240
> >
> > This is because in cipso_v4_doi_free() there is no check
> > on 'doi_def->map.std' when doi_def->type got value 1, which
> > is possibe, since netlbl_cipsov4_add_std() haven't initialize
> > it before alloc 'doi_def->map.std'.
> >
> > This patch just add the check to prevent panic happen in similar
> > cases.
> >
> > Reported-by: Abaci <abaci@linux.alibaba.com>
> > Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
> > ---
> >  net/netlabel/netlabel_cipso_v4.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-) =20
>=20
> I see this was already merged, but it looks good to me, thanks for
> making those changes.

FWIW it looks like v1 was also merged:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D733c99ee8b
