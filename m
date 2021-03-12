Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028C8339312
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhCLQWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:22:23 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:44310 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhCLQWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:22:18 -0500
Date:   Fri, 12 Mar 2021 16:22:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615566136; bh=YmdVo4a5muajAW7ky6oQdDWmCsEr3lutZLcm8CzAK8g=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Gxn0eCPzV4PGe17edQnPQpPylHh4XzMaGCPbxHxHjyfMIXAd3m7xStNFdThQ00ElP
         GjM50m5sXUXL4og8AOZ1rRcmmL1DRYJtgsSJndp4PwsXELfkguazt35Wh1mI1o98Ss
         BUpVrINRoxlZMa5aiSgZ3AX4vg25oQOxhMvcmnmK6DT2dGiXE9Y6yuiZWZ3lmKBXRj
         gKtpSjs9wCLhaOCwxKpT/MEpT+3m8iIhO/TBjMHxZ09YHItZJHDrqXNPuiZJ8/SCCr
         M/lTU/X0acg0yNutXVhGSMcXHse204uy6r3K+9wrASXIFtdb2GsvczGT2I59rfOnik
         1ScsMIEqnRjVA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 4/4] gro: improve flow distribution across GRO buckets in dev_gro_receive()
Message-ID: <20210312162127.239795-5-alobakin@pm.me>
In-Reply-To: <20210312162127.239795-1-alobakin@pm.me>
References: <20210312162127.239795-1-alobakin@pm.me>
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

Most of the functions that "convert" hash value into an index
(when RPS is configured / XPS is not configured / etc.) set
reciprocal_scale() on it. Its logics is simple, but fair enough and
accounts the entire input value.
On the opposite side, 'hash & (GRO_HASH_BUCKETS - 1)' expression uses
only 3 least significant bits of the value, which is far from
optimal (especially for XOR RSS hashers, where the hashes of two
different flows may differ only by 1 bit somewhere in the middle).

Use reciprocal_scale() here too to take the entire hash value into
account and improve flow dispersion between GRO hash buckets.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 65d9e7d9d1e8..bd7c9ba54623 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5952,7 +5952,7 @@ static void gro_flush_oldest(struct napi_struct *napi=
, struct list_head *head)

 static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk=
_buff *skb)
 {
-=09u32 bucket =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
+=09u32 bucket =3D reciprocal_scale(skb_get_hash_raw(skb), GRO_HASH_BUCKETS=
);
 =09struct gro_list *gro_list =3D &napi->gro_hash[bucket];
 =09struct list_head *gro_head =3D &gro_list->list;
 =09struct list_head *head =3D &offload_base;
--
2.30.2


