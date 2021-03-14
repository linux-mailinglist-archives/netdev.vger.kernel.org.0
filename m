Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B8833A463
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 12:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbhCNLLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 07:11:31 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:31891 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235212AbhCNLLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 07:11:04 -0400
Date:   Sun, 14 Mar 2021 11:11:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615720262; bh=akHA2XdZrjVj6nR+ZsUhHnDBklFIjIMbFmd6VtrDomE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ERlrfbNDFrhrQdjRZv27BFCTN1DQ/54Ypn+fYYu+RLLP4CdS28HGjug/o8KxWXzG/
         ceGDPy0l9gY9mfXfmLcIQg4thRSISYRkwx+GqiVuSta/4zfsQLrz15idyEeuCS5M77
         c8KpivT4MSstXs+r8bLYfos7mWPN4SREPpC8e4KEPbxzSd/I1Q32zJWHYeCxm1+uQB
         P1lZk8Tbh+LWGjlOCmcJj5M9cOUH9TKTTYBmvTURVafr+TY7CIArm4jgXq9vFuUozQ
         78aav+2sD/8O587NAWuYh6WBvRaSVm/OzLmn32C1tOFt7j//3nEmm65GkfRhtifqab
         4aJxe900FOXsg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Wang Qing <wangqing@vivo.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net-next 1/6] flow_dissector: constify bpf_flow_dissector's data pointers
Message-ID: <20210314111027.7657-2-alobakin@pm.me>
In-Reply-To: <20210314111027.7657-1-alobakin@pm.me>
References: <20210314111027.7657-1-alobakin@pm.me>
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

BPF Flow dissection programs are read-only and don't touch input
buffers.
Mark 'data' and 'data_end' in struct bpf_flow_dissector as const
in preparation for global input constifying.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/net/flow_dissector.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index cc10b10dc3a1..bf00e71816ed 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -368,8 +368,8 @@ static inline void *skb_flow_dissector_target(struct fl=
ow_dissector *flow_dissec
 struct bpf_flow_dissector {
 =09struct bpf_flow_keys=09*flow_keys;
 =09const struct sk_buff=09*skb;
-=09void=09=09=09*data;
-=09void=09=09=09*data_end;
+=09const void=09=09*data;
+=09const void=09=09*data_end;
 };

 static inline void
--
2.30.2


