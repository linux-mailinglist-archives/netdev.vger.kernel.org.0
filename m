Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB2A50943A
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383548AbiDUAm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383552AbiDUAmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:42:52 -0400
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B291BEBF
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:40:04 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:39:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501602;
        bh=W0VffryUE5RZwuv08QCVM2IU2VidejFL9tGRVW8qxIU=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=ZmwSroo+f/5b/WG1HKGylRZynSpIQ7KwWJXsPB35AcEjjQWgWLGzrrLTKHiJQ7mYT
         wzphf4JosMH0oJ6OOq5QI+pEO6tAU/smfTxKKI2n7mFUlmEEg+CD8SOOGxwCfdZKzP
         p1rBaXkzYRrAwc0OFrTOIK8SLRaPd34JorLslZzs+kVaRX1fiL5w6jDgHPQ/Jk364F
         dTC0WyV45BxGoQjD985X18M+2afDUl4jpRq9H9oYPr0jX/TzoCzNeL369xQanMyqb6
         ck3tLF/yLpqjIn+RXHbFNveiB8nbS3dmPKyfMidq4O/TjC/jA+t97ZiJMjx5q8IKuj
         WEOC87ZPC22yA==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf 11/11] samples/bpf: xdpsock: fix -Wmaybe-uninitialized
Message-ID: <20220421003152.339542-12-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/xdpsock_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 9747d47a0a8f..a6d8291c8b38 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1497,7 +1497,7 @@ static void rx_drop_all(void)
 static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb,
 =09=09   int batch_size, unsigned long tx_ns)
 {
-=09u32 idx, tv_sec, tv_usec;
+=09u32 idx, tv_sec =3D 0, tv_usec =3D 0;
 =09unsigned int i;

 =09while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
--
2.36.0


