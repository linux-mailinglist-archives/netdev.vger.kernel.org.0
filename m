Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1118372409
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 03:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfGXBvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 21:51:33 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35002 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfGXBvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 21:51:33 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so86178385ioo.2;
        Tue, 23 Jul 2019 18:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1VazidXBzwwvgKrkltEbhe85rbEwNvTQ8zjEVjoM56Q=;
        b=IlQ7oTFWgQqpWLR9bzEHX58gA0YOUxxvxu7TrawjU4uRhn8WkcDmJDF6MbMfQzQ7PK
         1cZ946o4DoQGjwwWy0Q0S7GvMklc4sapjcukQdoMY8kNoifE36+r2SgTfudKono3EMnh
         0DQuKbWPRJas0BO/wqkYeT5d6u/RtTC3cWannVEEsaFN/3SaqsG1WbdWDPFoJmEUloi0
         u9i8kwANQBhRMml/mLHclKoDp4LzH6dZCaeviKxex6U690Pc8gAscBE+pToCqCFprXZ4
         RZvjiWZ3PyzxauQBT0EDKt/UEvrcNieJo6HqD3962tYz8WTGxm0hNrQo3aXzHj149iYF
         EpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1VazidXBzwwvgKrkltEbhe85rbEwNvTQ8zjEVjoM56Q=;
        b=O5gSS62Wzydlm+6qR/rz8EoLtDaGd2cKMZst59LP/LvdUv0rK0YAJ2bPtNqN9QobGp
         C2mxYwZo6m8ycR6mHX6iRaDdt5juPdFurE+2vSVLJqehsqCLnTBKp8ncjYvhbK0UJ/8d
         me17AD0xsPcarNSEbXGuI6za6fDJNY18KAaOlqX8nhGtHYbHpZsNs01hn3PL7d8/xfxv
         I1OpZaxVM99cJvPF6mdvR3kbMKaaMtV1zTeLyTzcpauQB5OJ8fxbOKuGWdUVY2iGWmEo
         dl9A+9GgCMjUzktjjXX2dgQ8XH+5Xn89Qgj1csrPYRw723PQhFCkTfVrRnveCDGn+nkU
         YfEg==
X-Gm-Message-State: APjAAAVbyEHrZ6WjOlzuBfvO4N7GcdNhdDsx5EstHUt26EPVVDzG2KkV
        RPBWUwjyQ/MjLTEOzo2WWeY=
X-Google-Smtp-Source: APXvYqzyixL9gx5oZfe67P+25eJ53Dndx+lIIuJWgA3Lp2n7+ufHNQD1bMOd+5hLfViXG56ltZu4kQ==
X-Received: by 2002:a6b:7109:: with SMTP id q9mr68279157iog.30.1563933092175;
        Tue, 23 Jul 2019 18:51:32 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id e26sm38223271iod.10.2019.07.23.18.51.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 18:51:31 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Navid Emamdoost <navid.emamdoost@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rpcrdma_decode_msg: check xdr_inline_decode result
Date:   Tue, 23 Jul 2019 20:51:14 -0500
Message-Id: <20190724015115.3493-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdr_inline_decode may return NULL, so the check is necessary. The base
pointer will be dereferenced later in rpcrdma_inline_fixup.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 4345e6912392..d0479efe0e72 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1160,6 +1160,9 @@ rpcrdma_decode_msg(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep,
 
 	/* Build the RPC reply's Payload stream in rqst->rq_rcv_buf */
 	base = (char *)xdr_inline_decode(xdr, 0);
+	if (!base)
+		return -EIO;
+
 	rpclen = xdr_stream_remaining(xdr);
 	r_xprt->rx_stats.fixup_copy_count +=
 		rpcrdma_inline_fixup(rqst, base, rpclen, writelist & 3);
-- 
2.17.1

