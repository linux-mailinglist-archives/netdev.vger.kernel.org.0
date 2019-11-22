Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD901073C6
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 15:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfKVOAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 09:00:11 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:32999 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfKVOAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 09:00:11 -0500
Received: by mail-io1-f65.google.com with SMTP id j13so8144274ioe.0;
        Fri, 22 Nov 2019 06:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A3eKvaFo1JGhu6lnAN1aDIgq1Pf6mOkZOyokY6qopcs=;
        b=A6fh5q+F4GC/hZejOwyrpnYhDN+x0FLlt7gyPcxFTCEIGdyK0qgh0s4KHaIE/kpvwL
         GZe6kl/qQy1CA3jABX7M2XrVjU1Zhzlm2ku1Wc+JlO/h6PK3VeKoeiVmrbpPEJ3XVSgY
         XxlsRPUSOrqz7G3hEWAINFGlOxlfyHaaz4pq9rKXsEZveAco7HAulJixh39Q+ehsQlwU
         PA/+5WJ90zhFL/Hzyd8M3W28ZizEqlJxkdelyVrbTjtiZbV5U2CF6K1Pk5z/ZhFFQ7uI
         cl9zcUjEI/iHMgBVeWDClGJoRidtWH9veioqpcuYZG045mi8fazgsc2AZ3DSYRA/exEc
         MAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A3eKvaFo1JGhu6lnAN1aDIgq1Pf6mOkZOyokY6qopcs=;
        b=TaYqy+Finv9xdIkX72mYpA34hGiDQsia0KW0CgQDBnxL8LNLgLzKRJ6aA+5wGpYEeN
         Icj4c15z3+2kS+evnCbBLY8aOvhGfgHyJb+WJwkU6L97n4eR7q3OZpmPfkzGLfC4nW7b
         FmHSbMzbGfN5moUr/7Ve/Ai2m0B2lLDoJ81baJ4P+XLeSJ82oBDolc77K8mZepn5zavF
         JctzLIqb5f7l+DiBZwtmmFqqb5uoLRUUOZyKN8HsnYdJJaUeZkyIpIDGbFaOfZZQ595u
         8B8pkidr9o7VzJBszSnyh60sixIpq4BStWNCmeCgoYo9JcRAwYAmieiQBOcUjbcuIbTQ
         x19A==
X-Gm-Message-State: APjAAAWbIAdoWSOXuS2x+clbb5xvRaKkL7bD7GT9IOh/xW9qt5JnqtFO
        49xVm6GKuvKz89t3bVeN//eunt257rmlu/4UDJ0ZQp3DUKs=
X-Google-Smtp-Source: APXvYqwaUR+5DSTETTRFfyfpI1V27XTxBW6BS9bvv8ctDtLaBovtbrmFzfqebLHu+KU4PgEKnwitUz7Ur31g4V49TEM=
X-Received: by 2002:a02:9f95:: with SMTP id a21mr14065328jam.16.1574431209771;
 Fri, 22 Nov 2019 06:00:09 -0800 (PST)
MIME-Version: 1.0
References: <20191122054911.1750-1-sashal@kernel.org> <20191122054911.1750-133-sashal@kernel.org>
In-Reply-To: <20191122054911.1750-133-sashal@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 22 Nov 2019 15:00:43 +0100
Message-ID: <CAOi1vP9MCrPf44V2GMyODH185A0HJcuPsYfVkOAVGkcMRb+=iw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 140/219] libceph: drop last_piece logic from write_partial_message_data()
To:     Sasha Levin <sashal@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 6:51 AM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Ilya Dryomov <idryomov@gmail.com>
>
> [ Upstream commit 1f6b821aef78e3d79e8d598ae59fc7e23fb6c563 ]
>
> last_piece is for the last piece in the current data item, not in the
> entire data payload of the message.  This is harmful for messages with
> multiple data items.  On top of that, we don't need to signal the end
> of a data payload either because it is always followed by a footer.
>
> We used to signal "more" unconditionally, until commit fe38a2b67bc6
> ("libceph: start defining message data cursor").  Part of a large
> series, it introduced cursor->last_piece and also mistakenly inverted
> the hint by passing last_piece for "more".  This was corrected with
> commit c2cfa1940097 ("libceph: Fix ceph_tcp_sendpage()'s more boolean
> usage").
>
> As it is, last_piece is not helping at all: because Nagle algorithm is
> disabled, for a simple message with two 512-byte data items we end up
> emitting three packets: front + first data item, second data item and
> footer.  Go back to the original pre-fe38a2b67bc6 behavior -- a single
> packet in most cases.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ceph/messenger.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index f7d7f32ac673c..6514816947fbe 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -1612,7 +1612,6 @@ static int write_partial_message_data(struct ceph_connection *con)
>                 struct page *page;
>                 size_t page_offset;
>                 size_t length;
> -               bool last_piece;
>                 int ret;
>
>                 if (!cursor->resid) {
> @@ -1620,10 +1619,9 @@ static int write_partial_message_data(struct ceph_connection *con)
>                         continue;
>                 }
>
> -               page = ceph_msg_data_next(cursor, &page_offset, &length,
> -                                         &last_piece);
> -               ret = ceph_tcp_sendpage(con->sock, page, page_offset,
> -                                       length, !last_piece);
> +               page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
> +               ret = ceph_tcp_sendpage(con->sock, page, page_offset, length,
> +                                       true);
>                 if (ret <= 0) {
>                         if (do_datacrc)
>                                 msg->footer.data_crc = cpu_to_le32(crc);

Hi Sasha,

This commit was part of a larger series and shouldn't be backported on
its own.  Please drop it.

Thanks,

                Ilya
