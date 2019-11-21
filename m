Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626B41054AE
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 15:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfKUOjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 09:39:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59991 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbfKUOjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 09:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574347192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lJDYWSgP00g7qIjqTZLTHnhWuHMmstvkVgAhwaYoRHs=;
        b=OsfjO340y8YCVflKGYo2v2hZeH0TjPZpY0xKcDkKVKMnjHwvT0y2V/VjlKTGkQUwK5h9qQ
        HnpdKjtjre9FP+TFJGJzaDzQHFpFmZS+sAaWQ3aIOD/XcAd0afvOL0bHtRpm/wdI67Rt/X
        zdE+Q1bVhAokLR8q+OUBYHJGJkhh4d8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-OUxjw_4_OD6Gq5Bg9m8Kzw-1; Thu, 21 Nov 2019 09:39:48 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A32FB18B9FC1;
        Thu, 21 Nov 2019 14:39:47 +0000 (UTC)
Received: from ovpn-117-89.ams2.redhat.com (ovpn-117-89.ams2.redhat.com [10.36.117.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E0C46E70C;
        Thu, 21 Nov 2019 14:39:46 +0000 (UTC)
Message-ID: <65c66f8c860b7fc0c01f65feecae08aebb5cb0c9.camel@redhat.com>
Subject: Re: [PATCH net] udp: drop skb extensions before marking skb
 stateless
From:   Paolo Abeni <pabeni@redhat.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Byron Stanoszek <gandalf@winds.org>
Date:   Thu, 21 Nov 2019 15:39:45 +0100
In-Reply-To: <20191121055623.20952-1-fw@strlen.de>
References: <20191121053031.GI20235@breakpoint.cc>
         <20191121055623.20952-1-fw@strlen.de>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: OUxjw_4_OD6Gq5Bg9m8Kzw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-11-21 at 06:56 +0100, Florian Westphal wrote:
> Once udp stack has set the UDP_SKB_IS_STATELESS flag, later skb free
> assumes all skb head state has been dropped already.
>=20
> This will leak the extension memory in case the skb has extensions other
> than the ipsec secpath, e.g. bridge nf data.
>=20
> To fix this, set the UDP_SKB_IS_STATELESS flag only if we don't have
> extensions or if the extension space can be free'd.
>=20
> Fixes: 895b5c9f206eb7d25dc1360a ("netfilter: drop bridge nf reset from nf=
_reset")
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reported-by: Byron Stanoszek <gandalf@winds.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/skbuff.h |  6 ++++++
>  net/ipv4/udp.c         | 27 ++++++++++++++++++++++-----
>  2 files changed, 28 insertions(+), 5 deletions(-)
>=20
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 64a395c7f689..8688f7adfda7 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4169,12 +4169,18 @@ static inline void skb_ext_reset(struct sk_buff *=
skb)
>  =09=09skb->active_extensions =3D 0;
>  =09}
>  }
> +
> +static inline bool skb_has_extensions(struct sk_buff *skb)
> +{
> +=09return unlikely(skb->active_extensions);
> +}
>  #else
>  static inline void skb_ext_put(struct sk_buff *skb) {}
>  static inline void skb_ext_reset(struct sk_buff *skb) {}
>  static inline void skb_ext_del(struct sk_buff *skb, int unused) {}
>  static inline void __skb_ext_copy(struct sk_buff *d, const struct sk_buf=
f *s) {}
>  static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buf=
f *s) {}
> +static inline bool skb_has_extensions(struct sk_buff *skb) { return fals=
e; }
>  #endif /* CONFIG_SKB_EXTENSIONS */
> =20
>  static inline void nf_reset_ct(struct sk_buff *skb)
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 1d58ce829dca..447defbfccdd 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1297,6 +1297,27 @@ int udp_sendpage(struct sock *sk, struct page *pag=
e, int offset,
> =20
>  #define UDP_SKB_IS_STATELESS 0x80000000
> =20
> +/* all head states (dst, sk, nf conntrack) except skb extensions are
> + * cleared by udp_rcv().
> + *
> + * We need to preserve secpath, if present, to eventually process
> + * IP_CMSG_PASSSEC at recvmsg() time.
> + *
> + * Other extensions can be cleared.
> + */
> +static bool udp_try_make_stateless(struct sk_buff *skb)
> +{
> +=09if (!skb_has_extensions(skb))
> +=09=09return true;
> +
> +=09if (!secpath_exists(skb)) {
> +=09=09skb_ext_reset(skb);
> +=09=09return true;
> +=09}
> +
> +=09return false;
> +}
> +
>  static void udp_set_dev_scratch(struct sk_buff *skb)
>  {
>  =09struct udp_dev_scratch *scratch =3D udp_skb_scratch(skb);
> @@ -1308,11 +1329,7 @@ static void udp_set_dev_scratch(struct sk_buff *sk=
b)
>  =09scratch->csum_unnecessary =3D !!skb_csum_unnecessary(skb);
>  =09scratch->is_linear =3D !skb_is_nonlinear(skb);
>  #endif
> -=09/* all head states execept sp (dst, sk, nf) are always cleared by
> -=09 * udp_rcv() and we need to preserve secpath, if present, to eventual=
ly
> -=09 * process IP_CMSG_PASSSEC at recvmsg() time
> -=09 */
> -=09if (likely(!skb_sec_path(skb)))
> +=09if (udp_try_make_stateless(skb))
>  =09=09scratch->_tsize_state |=3D UDP_SKB_IS_STATELESS;
>  }

Acked-by: Paolo Abeni <pabeni@redhat.com>

