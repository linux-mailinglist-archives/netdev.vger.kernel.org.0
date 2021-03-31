Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F84350055
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhCaM3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:29:18 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:59068 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbhCaM2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 08:28:42 -0400
Date:   Wed, 31 Mar 2021 12:28:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1617193719; bh=zI3QaYD0UyhErTHzJ9xtVjlAtErv7jv4T3mrzGJ1yG8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=c84tXW1g3EszL3GXgeXUMymQ0g5Zg9NaGGhLaxp3OI1aGtitirwU50pNTmtC57J7F
         8uyuZz4xQtRNHkpA5LDrPLYxlLcv6acHSbabi7lczADJ9VQffjOgPXX6TvuboORA6x
         ZFYAEh2IyrGDfs0Zk3oCLPkJimyPwpbv1YleOMgfhCmWQCTYXsSioWuJrFNcAlmwQR
         sjGSswH3MvgbPsH/nvBnc6w3DJxSMwAWxBDrs3pKTQuYBCoia2Re0sd9zYQ4gl41Mu
         IiVqf9FqLY5Wccqd9NpuGzHkhjzEuyZYn5Q3Hyni2Wprffnt5Stg20RNv0jNk2Zm2v
         YygrVsSlVR4ZA==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf-next 1/2] xsk: speed-up generic full-copy xmit
Message-ID: <20210331122820.6356-1-alobakin@pm.me>
In-Reply-To: <20210331122602.6000-1-alobakin@pm.me>
References: <20210331122602.6000-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few moments that are known for sure at the moment of
copying:
 - allocated skb is fully linear;
 - its linear space is long enough to hold the full buffer data.

So, the out-of-line skb_put(), skb_store_bits() and the check for
a retcode can be replaced with plain memcpy(__skb_put()) with
no loss.
Also align memcpy()'s len to sizeof(long) to improve its performance.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/xdp/xsk.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a71ed664da0a..41f8f21b3348 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -517,14 +517,9 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *=
xs,
 =09=09=09return ERR_PTR(err);

 =09=09skb_reserve(skb, hr);
-=09=09skb_put(skb, len);

 =09=09buffer =3D xsk_buff_raw_get_data(xs->pool, desc->addr);
-=09=09err =3D skb_store_bits(skb, 0, buffer, len);
-=09=09if (unlikely(err)) {
-=09=09=09kfree_skb(skb);
-=09=09=09return ERR_PTR(err);
-=09=09}
+=09=09memcpy(__skb_put(skb, len), buffer, ALIGN(len, sizeof(long)));
 =09}

 =09skb->dev =3D dev;
--
2.31.1


