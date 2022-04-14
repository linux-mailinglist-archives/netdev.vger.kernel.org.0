Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA49E501EAF
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347361AbiDNWuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347356AbiDNWuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:50:01 -0400
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C84C74A4;
        Thu, 14 Apr 2022 15:47:33 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:47:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976451;
        bh=wBk9JjddsWdkPL3+TnZwqvhbFqPlgDryFkVFtACVs5s=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=nOwFrCMQqgdnT5ACg0miHsryQvMGaVe1VVs6T+wkBBVk40W6TE0Oxjlsqbiiqtd4i
         IL3o3iY4Fmhszf3elBnEFfupsT+BLDg2f0H4qXtRtsemsQkLk8jIQ9ZubVi6/8Mj0C
         WSO0kpOQNupTzmMubOERMBBZKtgMtH9nko71yWrOKqgqTgLI6YoUgUiUMxyn77ZNzn
         B4gmE8cw6m7FaO8iBFxmb5lmu/zAbxSCDY+JMXFJ2mue0BKKsVwYAGHThryC4JPvB7
         hqVfIWqC1Bv4OFOZY6FypF77uCtCS32X6gX/aV7jChafN1KUc8WV9PUzrVlWlFTDd0
         50OCb5uCi1WOQ==
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
Subject: [PATCH bpf-next 11/11] samples: bpf: xdpsock: fix -Wmaybe-uninitialized
Message-ID: <20220414223704.341028-12-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-1-alobakin@pm.me>
References: <20220414223704.341028-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix two sort-of-false-positives in the xdpsock userspace part:

samples/bpf/xdpsock_user.c: In function 'main':
samples/bpf/xdpsock_user.c:1531:47: warning: 'tv_usec' may be used uninitia=
lized in this function [-Wmaybe-uninitialized]
 1531 |                         pktgen_hdr->tv_usec =3D htonl(tv_usec);
      |                                               ^~~~~~~~~~~~~~
samples/bpf/xdpsock_user.c:1500:26: note: 'tv_usec' was declared here
 1500 |         u32 idx, tv_sec, tv_usec;
      |                          ^~~~~~~
samples/bpf/xdpsock_user.c:1530:46: warning: 'tv_sec' may be used uninitial=
ized in this function [-Wmaybe-uninitialized]
 1530 |                         pktgen_hdr->tv_sec =3D htonl(tv_sec);
      |                                              ^~~~~~~~~~~~~
samples/bpf/xdpsock_user.c:1500:18: note: 'tv_sec' was declared here
 1500 |         u32 idx, tv_sec, tv_usec;
      |                  ^~~~~~

Both variables are always initialized when @opt_tstamp =3D=3D true and
they're being used also only when @opt_tstamp =3D=3D true. However, that
variable comes from the BSS and is being toggled from another
function. They can't be executed simultaneously to actually trigger
undefined behaviour, but purely technically it is a correct warning.
Just initialize them with zeroes.

Fixes: eb68db45b747 ("samples/bpf: xdpsock: Add timestamp for Tx-only opera=
tion")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/xdpsock_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 399b999fcec2..1dc7ad5dbef4 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1496,7 +1496,7 @@ static void rx_drop_all(void)
 static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb,
 =09=09   int batch_size, unsigned long tx_ns)
 {
-=09u32 idx, tv_sec, tv_usec;
+=09u32 idx, tv_sec =3D 0, tv_usec =3D 0;
 =09unsigned int i;

 =09while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
--
2.35.2


