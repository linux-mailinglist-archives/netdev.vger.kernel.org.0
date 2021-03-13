Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8324C339DDB
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhCMLhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:37:34 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:31339 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbhCMLhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:37:24 -0500
Date:   Sat, 13 Mar 2021 11:37:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615635442; bh=ftpGwrO8lUj/+nf3ZEMhVVW9gOAMLofs/x8sHMcxcZI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=eJQO1rJq8ThcFtAOnrXSWUS0jy8TjW1bNWMzpwsTX40b3DWBYINzUpzVs5DhIz2EI
         uoDh0E4vEmkCaMCHbydHF3U0TJ+J8weKrIsZ5Myu68oTX/ocoU2Nz7LnqYXCZlS2ST
         Z3fs5IQNLW+c8o1fvCREYJLcJ0bw5tT7rzTm0AdKhI1hgBXARx7fVF0p14NOXEzNVR
         bOCZ/DMAQ7ryfzbsNhAwVf9ijx/XJ3ZXmYunQFyfXwrg7FUQDgqNC8Si7rWOVIqQ9l
         GI/CFHxZVLM+2GPrlMPywwPfqS/U4thSFM8iJLjPmoAUTQJmNNCWsxhNpHOltdJuvJ
         JAs3a+EYDv7jA==
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
Subject: [PATCH v2 net-next 1/6] flow_dissector: constify bpf_flow_dissector's data pointers
Message-ID: <20210313113645.5949-2-alobakin@pm.me>
In-Reply-To: <20210313113645.5949-1-alobakin@pm.me>
References: <20210313113645.5949-1-alobakin@pm.me>
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
Mark @data and @data_end in struct bpf_flow_dissector as const in
preparation for global input constifying.

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


