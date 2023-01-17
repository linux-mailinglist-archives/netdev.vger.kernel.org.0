Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FAB66DAD2
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbjAQKWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbjAQKWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:22:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0136225E0F
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673950905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QEdYja+spAQRgI3ocatVF5aB4j8EGJYrwOlz+aS8qnc=;
        b=SmVr9iMAUwDVXxgrgv5anTXm0OTJGWq7gT3t+95gEZD7NzTfbCni5EeruPQkc6UtNlUT7U
        oUeZUMx+lgwnEqPZNwn+lrZB7mAuo4Ud90ylNX5+LU7IfNOOTGS4qFfyaIIuNI1bO4YfRT
        AReHh+JpKzfq7NYchXoP+JGQzbnLY3k=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-308-Ln2LJ1D3Ok-UOhBD_6A5xA-1; Tue, 17 Jan 2023 05:21:43 -0500
X-MC-Unique: Ln2LJ1D3Ok-UOhBD_6A5xA-1
Received: by mail-qv1-f69.google.com with SMTP id o95-20020a0c9068000000b005320eb4e959so15808388qvo.16
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:21:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QEdYja+spAQRgI3ocatVF5aB4j8EGJYrwOlz+aS8qnc=;
        b=2vnhP94541dZRprA+65yD7tH01fao90bu1taP+BrE/XY9F7NLYOB5Q/3zhrfqYQCKk
         NxNppUaMUo9M1G5txLjwLqkr264M+8igceqY85suHdAZWDckl/QXZcWuvDD+sp65xjEW
         chk/Xt6Ry9+dCOl5fPkHzpM+taLWpFGwEKSOTeflTqJEjkzhD/m8LH1bwQKZL6SMjzPL
         DOzf0W3BjrC40RniCIsCVJLve6V5fTLS2adFa9c+0nSJSzF93meGE7gtge/UH3Gp3tyd
         umweRJB3ghvTnWMvjlWl4AWbHHMd9aMoB1uhQ9kB9FXSxsko5+lbHDSeMlxr/hE+uWtl
         5KSA==
X-Gm-Message-State: AFqh2ko5jDThyQjixmpxKVrOlWAV8reUTpRYHNdgFtD/s/FWhkftqL8m
        SAAfR6YLSGHhBg0asFbt3DUsW5UY4E9aWDyOgMmL/tF3GtrfTD4GR1uRs/pKp0e3Sh5a38BBVwe
        ChbGc2iugOL3jgvu6
X-Received: by 2002:a05:6214:5cc6:b0:535:2539:f6f5 with SMTP id lk6-20020a0562145cc600b005352539f6f5mr3569725qvb.19.1673950903265;
        Tue, 17 Jan 2023 02:21:43 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvPYUizcpEacQSRFhRTtErkHrTAYpfYmoU93jJcJUpktp3acV/jkNc/5kpL9F9xjfj7nlvLjg==
X-Received: by 2002:a05:6214:5cc6:b0:535:2539:f6f5 with SMTP id lk6-20020a0562145cc600b005352539f6f5mr3569707qvb.19.1673950903011;
        Tue, 17 Jan 2023 02:21:43 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id t11-20020a05620a034b00b006fa31bf2f3dsm19675388qkm.47.2023.01.17.02.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:21:42 -0800 (PST)
Message-ID: <cf3c7895be29d46e814d356bb5afad1203815253.camel@redhat.com>
Subject: Re: [PATCH net-next v3] inet: fix fast path in __inet_hash_connect()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pietro Borrello <borrello@diag.uniroma1.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 17 Jan 2023 11:21:39 +0100
In-Reply-To: <20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it>
References: <20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-01-14 at 13:11 +0000, Pietro Borrello wrote:
> __inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
> equal to the sk parameter.
> sk_head() returns the hlist_entry() with respect to the sk_node field.
> However entries in the tb->owners list are inserted with respect to the
> sk_bind_node field with sk_add_bind_node().
> Thus the check would never pass and the fast path never execute.
>=20
> This fast path has never been executed or tested as this bug seems
> to be present since commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), thus
> remove it to reduce code complexity.
>=20
> Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
> ---
> Changes in v3:
> - remove the fast path to reduce code complexity
> - Link to v2: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_h=
ead-v2-1-5ec926ddd985@diag.uniroma1.it
>=20
> Changes in v2:
> - nit: s/list_entry/hlist_entry/
> - Link to v1: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_h=
ead-v1-1-7e3c770157c8@diag.uniroma1.it
> ---
>  net/ipv4/inet_hashtables.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
>=20
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index d039b4e732a3..b832e7a545d4 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -994,17 +994,7 @@ int __inet_hash_connect(struct inet_timewait_death_r=
ow *death_row,
>  	u32 index;
> =20
>  	if (port) {
> -		head =3D &hinfo->bhash[inet_bhashfn(net, port,
> -						  hinfo->bhash_size)];
> -		tb =3D inet_csk(sk)->icsk_bind_hash;
> -		spin_lock_bh(&head->lock);
> -		if (sk_head(&tb->owners) =3D=3D sk && !sk->sk_bind_node.next) {
> -			inet_ehash_nolisten(sk, NULL, NULL);
> -			spin_unlock_bh(&head->lock);
> -			return 0;
> -		}
> -		spin_unlock(&head->lock);
> -		/* No definite answer... Walk to established hash table */
> +		local_bh_disable();
>  		ret =3D check_established(death_row, sk, port, NULL);
>  		local_bh_enable();
>  		return ret;

LGTM, thanks!

Eric, do you have any additional comment?

Cheers,

Paolo



