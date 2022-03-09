Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861124D3CBA
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 23:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbiCIWOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 17:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbiCIWOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 17:14:52 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B854A3CB;
        Wed,  9 Mar 2022 14:13:49 -0800 (PST)
Date:   Wed, 9 Mar 2022 23:13:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646864027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6L0rg3bdg9PSfTr778oNR9IkfA6VNn058COlVBv40UE=;
        b=VIsD/1IRo06lRVr6Gh5UZWT2Ko9YVNYI025lqTRUjC/X3/b3KNjYT4BkjiAS7aMpaIOFeA
        zX4K0q2jAn+nZZ+e2DWZ9/fcMv4e99SMfu9FhBLkk/oxN70RF+v6vMg5z7iq02cWTVKip4
        FpcfVr6TpdV6G2J3YmdGYCbUq5dPFE4p+iztM8EhF4H1wl+WsY4RNqc8Z/CUv+fKQAogIa
        SF0tfBC127rIaqQRsSs//zHBCvN4AUc0SrXuzXrcydhsmDVrjOHiIePRdpvmMq7Qfu1+Gd
        MbIF+NmlfzBJBsfUq6VtqG724DdXx92CafdGj3wvvqtEv11zI8ztjmfSMjRGpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646864027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6L0rg3bdg9PSfTr778oNR9IkfA6VNn058COlVBv40UE=;
        b=TVh3BqYrL8c8UZawotF0e8QFGl2v7NiqAzF2xTno3fIjHYkcIFtewAVbQqMPvXZm17Z877
        ovQv3BgpIu5ztWBA==
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
Subject: [PATCH net v3] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Message-ID: <YikmmXsffE+QajTB@linutronix.de>
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
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
v2=E2=80=A6v3:
   - Use trace_mem_connect_enabled() as suggested by Steven Rostedt.

v1=E2=80=A6v2:
   - Instead letting the trace point deal with a NULL pointer, skip the
     trace point.

 net/core/xdp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/xdp.c b/net/core/xdp.c
index 7aba355049862..73fae16264e10 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -357,7 +357,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp=
_rxq,
 	if (IS_ERR(xdp_alloc))
 		return PTR_ERR(xdp_alloc);
=20
-	trace_mem_connect(xdp_alloc, xdp_rxq);
+	if (trace_mem_connect_enabled() && xdp_alloc)
+		trace_mem_connect(xdp_alloc, xdp_rxq);
 	return 0;
 }
=20
--=20
2.35.1

