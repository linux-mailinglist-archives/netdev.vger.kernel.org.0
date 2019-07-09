Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 339F66312C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfGIGnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfGIGnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 02:43:50 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E926D216C4;
        Tue,  9 Jul 2019 06:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562654629;
        bh=bpaoLc7Aubq+GHHtWfTPdoDmyYcmyMeIRmhPLjxgnvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XLCPPnoxmA+d5SIZX4KLYprsvOfn+M5RbeeQ0JhL5lVKTZdO7Gq3gpBSJVyPjarT2
         3AF50kLJ1mmYraXLzptZPTNxpXit1FKMbEd22q4eU54v80g+cttOhBSusdLQRSevWj
         wZ8NBEGqV0IYVgpcNgbdJ4YelQg898+AFMKb++JQ=
Date:   Tue, 9 Jul 2019 09:43:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190709064346.GF7034@mtr-leonro.mtl.com>
References: <20190709135636.4d36e19f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190709135636.4d36e19f@canb.auug.org.au>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 01:56:36PM +1000, Stephen Rothwell wrote:
> Hi all,
>
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/infiniband/sw/siw/siw_cm.c: In function 'siw_create_listen':
> drivers/infiniband/sw/siw/siw_cm.c:1978:3: error: implicit declaration of=
 function 'for_ifa'; did you mean 'fork_idle'? [-Werror=3Dimplicit-function=
-declaration]
>    for_ifa(in_dev)
>    ^~~~~~~
>    fork_idle
> drivers/infiniband/sw/siw/siw_cm.c:1978:18: error: expected ';' before '{=
' token
>    for_ifa(in_dev)
>                   ^
>                   ;
>    {
>    ~
>
> Caused by commit
>
>   6c52fdc244b5 ("rdma/siw: connection management")
>
> from the rdma tree.  I don't know why this didn't fail after I mereged
> that tree.

I had the same question, because I have this fix for a couple of days alrea=
dy.

=46rom 56c9e15ec670af580daa8c3ffde9503af3042d67 Mon Sep 17 00:00:00 2001
=46rom: Leon Romanovsky <leonro@mellanox.com>
Date: Sun, 7 Jul 2019 10:43:42 +0300
Subject: [PATCH] Fixup to build SIW issue

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/sw/siw/siw_cm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw=
/siw_cm.c
index 8e618cb7261f..c883bf514341 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1954,6 +1954,7 @@ static void siw_drop_listeners(struct iw_cm_id *id)
 int siw_create_listen(struct iw_cm_id *id, int backlog)
 {
 	struct net_device *dev =3D to_siw_dev(id->device)->netdev;
+	const struct in_ifaddr *ifa;
 	int rv =3D 0, listeners =3D 0;

 	siw_dbg(id->device, "id 0x%p: backlog %d\n", id, backlog);
@@ -1975,8 +1976,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
 			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));

-		for_ifa(in_dev)
-		{
+		in_dev_for_each_ifa_rcu(ifa, in_dev) {
 			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
 			    s_laddr.sin_addr.s_addr =3D=3D ifa->ifa_address) {
 				s_laddr.sin_addr.s_addr =3D ifa->ifa_address;
@@ -1988,7 +1988,6 @@ int siw_create_listen(struct iw_cm_id *id, int backlo=
g)
 					listeners++;
 			}
 		}
-		endfor_ifa(in_dev);
 		in_dev_put(in_dev);
 	} else if (id->local_addr.ss_family =3D=3D AF_INET6) {
 		struct inet6_dev *in6_dev =3D in6_dev_get(dev);
--
2.21.0


>
> I have marked that driver as depending on BROKEN for today.
>
> --
> Cheers,
> Stephen Rothwell


