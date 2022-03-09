Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCEF4D3B55
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbiCIUsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiCIUsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:48:41 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729876433;
        Wed,  9 Mar 2022 12:47:41 -0800 (PST)
Date:   Wed, 9 Mar 2022 21:47:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646858860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/VaQWHFrdCQjtr2d2yjCrhvjrQsK4eQi6tnlA98NSys=;
        b=XZHJ7Y9Io7mKHHbrh8ShVpAdpOErvqc6yTUNt7DWXityEliik2XKnPpEjAB+vguMnCWk4X
        a/ADh/3IANOzgsX/oPwcoE9RDPht2JB4I2vkiHx7qbVYGzx3CCJ9Ry5I3xf3FRg0W5AIgl
        QGGs583i1rAUMI2RQt8AWQlBRg9zeWE2PuJtvty7SEMyTtuz15Q7Uoci38XE3a2XzHLAqd
        G2cb8UujnYWbHdKxZE3HOUDxhU8tylWTEbkgZkYJzcianW5G89a08iVmy+QMpZikgB/aCb
        uRXmigqoW87kezS7YFQ9vq75biqadxw+a6E4r27YzimlpBdYR9X/XAuwaefW6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646858860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/VaQWHFrdCQjtr2d2yjCrhvjrQsK4eQi6tnlA98NSys=;
        b=vH43nxZp8aUBd5K69HKfo5f9nEmE3a6V+oQrQ8YrLxXMMnUOu1O0JJzaL2Ib/1ukgG4+Fp
        sIZwZgfbyYy7/0Ag==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH net v2] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Message-ID: <YikSav7Y1iEQv8sq@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the commit mentioned below __xdp_reg_mem_model() can return a NULL
pointer. This pointer is dereferenced in trace_mem_connect() which leads
to segfault.

The trace points (mem_connect + mem_disconnect) were put in place to
pair connect/disconnect using the IDs. The ID is only assigned if
__xdp_reg_mem_model() does not return NULL. That connect trace point is
of no use if there is no ID.

Skip that connect trace point if xdp_alloc is NULL.

[ Toke H=C3=B8iland-J=C3=B8rgensen delivered the reasoning for skipping the=
 trace
  point ]

Fixes: 4a48ef70b93b8 ("xdp: Allow registering memory model without rxq refe=
rence")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2:
   - Instead letting the trace point deal with a NULL pointer, skip the
     trace point.

 net/core/xdp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 7aba355049862..8ebb22eb6497c 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -357,7 +357,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp=
_rxq,
 	if (IS_ERR(xdp_alloc))
 		return PTR_ERR(xdp_alloc);
=20
-	trace_mem_connect(xdp_alloc, xdp_rxq);
+	if (xdp_alloc)
+		trace_mem_connect(xdp_alloc, xdp_rxq);
 	return 0;
 }
=20
--=20
2.35.1
