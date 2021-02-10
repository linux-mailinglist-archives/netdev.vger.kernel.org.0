Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD60316B3D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhBJQam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:30:42 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:62022 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbhBJQ3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:29:40 -0500
Date:   Wed, 10 Feb 2021 16:28:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612974531; bh=1jmyGVktapkh6qfM8bIJnHx7xqAc92nYkNV3TutbC78=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=gbmpv4lGEvPVfspMw+xqDGpCczdOgaYqmSD3+Cqjy/zKAmMt7PGcCfYiumfmtYf0E
         zODpQyZE/7Bc33HH9nKf71vbaoqRuPAhwaXhRjzA0qZGbfRnv3EUkrb5i4ArCCQNBr
         lmyyyPIj6xJyGeaOnuJoQ/HHQVGLOJXt8coqZTKpZ0gOxZMdH7P9bB9tZTJJ57iyEb
         SqkFESCINRCNu8gYQTGxmUTjH/HqnoCPwoRayDOF2C4uMyOaXC4Tx4lfz1+BWpMCeb
         16I691QmfIr2asbNYAdnmgwAwTgVmDuNaHpSkZH0XKO0/82A/sewgpkezHZalv7K9h
         VMUTGAxamokYA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 net-next 02/11] skbuff: simplify kmalloc_reserve()
Message-ID: <20210210162732.80467-3-alobakin@pm.me>
In-Reply-To: <20210210162732.80467-1-alobakin@pm.me>
References: <20210210162732.80467-1-alobakin@pm.me>
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

Eversince the introduction of __kmalloc_reserve(), "ip" argument
hasn't been used. _RET_IP_ is embedded inside
kmalloc_node_track_caller().
Remove the redundant macro and rename the function after it.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a0f846872d19..70289f22a6f4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -273,11 +273,8 @@ EXPORT_SYMBOL(__netdev_alloc_frag_align);
  * may be used. Otherwise, the packet data may be discarded until enough
  * memory is free
  */
-#define kmalloc_reserve(size, gfp, node, pfmemalloc) \
-=09 __kmalloc_reserve(size, gfp, node, _RET_IP_, pfmemalloc)
-
-static void *__kmalloc_reserve(size_t size, gfp_t flags, int node,
-=09=09=09       unsigned long ip, bool *pfmemalloc)
+static void *kmalloc_reserve(size_t size, gfp_t flags, int node,
+=09=09=09     bool *pfmemalloc)
 {
 =09void *obj;
 =09bool ret_pfmemalloc =3D false;
--=20
2.30.1


