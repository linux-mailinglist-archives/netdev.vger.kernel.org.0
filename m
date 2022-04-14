Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F45501EAE
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347296AbiDNWtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347277AbiDNWs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:48:59 -0400
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86956C6F00;
        Thu, 14 Apr 2022 15:46:32 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:46:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976390;
        bh=LiFwMTDd2fdSlZNNJT9AWOWlwaivKQ5qk8KaEcQEfrs=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=fiN8lGwSeXi6yQVq95169CY5q0fzkvN7gW6UYs2Gv4qL+WDStjwwjCQh0hCFYvksU
         KnswdJkdUtU5G9GqL5Gxkii4Kk5V4ypSMXwAFRhB8ERjsorTeeAsUqVoT+zdEMMnjf
         oJiycRhG9r7gmPG8gH0louf++DYLLAv75knuCVPX+ca7M2uTv/1VQdT18IzG6xzs/a
         6g4MF5ZXxirNHeYPobCikPiutt8fL50asp7vfCzUqKz1WsQRnWgrgFEHA5NMdKI4K0
         ZaO3DghoEjFcnwImnLGE3V49hSOiewYZfIPHt/9yi4wVZ+k81z8SzXwdnbzSqnD24V
         tQqte9gKKFnUQ==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH bpf-next 07/11] samples: bpf: fix uin64_t format literals
Message-ID: <20220414223704.341028-8-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-1-alobakin@pm.me>
References: <20220414223704.341028-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's a couple places where uin64_t is being passed as an %ld
format argument, which is incorrect (should be %lld). Fix them.

Fixes: 51570a5ab2b7 ("A Sample of using socket cookie and uid for traffic m=
onitoring")
Fixes: 00f660eaf378 ("Sample program using SO_COOKIE")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/cookie_uid_helper_example.c | 12 ++++++------
 samples/bpf/lwt_len_hist_user.c         |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/samples/bpf/cookie_uid_helper_example.c b/samples/bpf/cookie_u=
id_helper_example.c
index f0df3dda4b1f..1b98debb6019 100644
--- a/samples/bpf/cookie_uid_helper_example.c
+++ b/samples/bpf/cookie_uid_helper_example.c
@@ -207,9 +207,9 @@ static void print_table(void)
 =09=09=09error(1, errno, "fail to get entry value of Key: %u\n",
 =09=09=09=09curN);
 =09=09} else {
-=09=09=09printf("cookie: %u, uid: 0x%x, Packet Count: %lu,"
-=09=09=09=09" Bytes Count: %lu\n", curN, curEntry.uid,
-=09=09=09=09curEntry.packets, curEntry.bytes);
+=09=09=09printf("cookie: %u, uid: 0x%x, Packet Count: %llu, Bytes Count: %=
llu\n",
+=09=09=09       curN, curEntry.uid, curEntry.packets,
+=09=09=09       curEntry.bytes);
 =09=09}
 =09}
 }
@@ -265,9 +265,9 @@ static void udp_client(void)
 =09=09if (res < 0)
 =09=09=09error(1, errno, "lookup sk stat failed, cookie: %lu\n",
 =09=09=09      cookie);
-=09=09printf("cookie: %lu, uid: 0x%x, Packet Count: %lu,"
-=09=09=09" Bytes Count: %lu\n\n", cookie, dataEntry.uid,
-=09=09=09dataEntry.packets, dataEntry.bytes);
+=09=09printf("cookie: %llu, uid: 0x%x, Packet Count: %llu, Bytes Count: %l=
lu\n\n",
+=09=09       cookie, dataEntry.uid, dataEntry.packets,
+=09=09       dataEntry.bytes);
 =09}
 =09close(s_send);
 =09close(s_rcv);
diff --git a/samples/bpf/lwt_len_hist_user.c b/samples/bpf/lwt_len_hist_use=
r.c
index 430a4b7e353e..4ef22571aa67 100644
--- a/samples/bpf/lwt_len_hist_user.c
+++ b/samples/bpf/lwt_len_hist_user.c
@@ -44,7 +44,7 @@ int main(int argc, char **argv)

 =09while (bpf_map_get_next_key(map_fd, &key, &next_key) =3D=3D 0) {
 =09=09if (next_key >=3D MAX_INDEX) {
-=09=09=09fprintf(stderr, "Key %lu out of bounds\n", next_key);
+=09=09=09fprintf(stderr, "Key %llu out of bounds\n", next_key);
 =09=09=09continue;
 =09=09}

@@ -66,7 +66,7 @@ int main(int argc, char **argv)

 =09for (i =3D 1; i <=3D max_key + 1; i++) {
 =09=09stars(starstr, data[i - 1], max_value, MAX_STARS);
-=09=09printf("%8ld -> %-8ld : %-8ld |%-*s|\n",
+=09=09printf("%8ld -> %-8ld : %-8lld |%-*s|\n",
 =09=09       (1l << i) >> 1, (1l << i) - 1, data[i - 1],
 =09=09       MAX_STARS, starstr);
 =09}
--
2.35.2


