Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63946D2872
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 21:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjCaTGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 15:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbjCaTGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 15:06:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5F422E8C;
        Fri, 31 Mar 2023 12:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9E8E62B55;
        Fri, 31 Mar 2023 19:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC5DC433D2;
        Fri, 31 Mar 2023 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680289558;
        bh=iO9lT4G+VhW54/C/njgyZWfDAkyGJR8Jg6RkIdRfetY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ph/7mpr4I+PN8mUUNwZLB+N2Azsxl/vFp3YIJ+bdZhdrmM4ACyFf68tVeZCpFqJG4
         gYjtsRlbUi3rt2F9V/ekTIedom19mcF67u0Ch4XpJIjyvWzzBtAx+3bj/VRKKxEW/+
         SWyMTy2b9bFUbg9eU6qlA3Rys87qUQ/eOnI7py4DPEK3IcLOV8NnQkRv2fcS64pA1w
         98pL9Ki9Of2ltspo2xcVvu5zw2hfke7ybOVlOg9XHOEFACFeFvDfdShI1GIrA7Hig9
         b9RS5F1AabdNZIwjBa+O/XRFXlF+UlMwZYbtoQUUBprHWaK0lCbQGZqEY65cOKa93M
         +j9o2x3pShS/g==
Message-ID: <a6adab95d955065dd05c78ac462c32dfd146e820.camel@kernel.org>
Subject: Re: [PATCH v3 01/55] netfs: Fix netfs_extract_iter_to_sg() for
 ITER_UBUF/IOVEC
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org
Date:   Fri, 31 Mar 2023 15:05:55 -0400
In-Reply-To: <20230331160914.1608208-2-dhowells@redhat.com>
References: <20230331160914.1608208-1-dhowells@redhat.com>
         <20230331160914.1608208-2-dhowells@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-03-31 at 17:08 +0100, David Howells wrote:
> Fix netfs_extract_iter_to_sg() for ITER_UBUF and ITER_IOVEC to set the si=
ze
> of the page to the part of the page extracted, not the remaining amount o=
f
> data in the extracted page array at that point.
>=20
> This doesn't yet affect anything as cifs, the only current user, only
> passes in non-user-backed iterators.
>=20
> Fixes: 018584697533 ("netfs: Add a function to extract an iterator into a=
 scatterlist")
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: Steve French <sfrench@samba.org>
> cc: Shyam Prasad N <nspmangalore@gmail.com>
> cc: Rohith Surabattula <rohiths.msft@gmail.com>
> cc: linux-cachefs@redhat.com
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/netfs/iterator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/netfs/iterator.c b/fs/netfs/iterator.c
> index e9a45dea748a..8a4c86687429 100644
> --- a/fs/netfs/iterator.c
> +++ b/fs/netfs/iterator.c
> @@ -139,7 +139,7 @@ static ssize_t netfs_extract_user_to_sg(struct iov_it=
er *iter,
>  			size_t seg =3D min_t(size_t, PAGE_SIZE - off, len);
> =20
>  			*pages++ =3D NULL;
> -			sg_set_page(sg, page, len, off);
> +			sg_set_page(sg, page, seg, off);
>  			sgtable->nents++;
>  			sg++;
>  			len -=3D seg;
>=20

Reviewed-by: Jeff Layton <jlayton@kernel.org>
