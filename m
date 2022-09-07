Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEDA5AFD38
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiIGHO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGHO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:14:27 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E651E8E4DB;
        Wed,  7 Sep 2022 00:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=tB1RP
        O26vXe1FKV6Z0BCxutSM6Hh9I8XS6K8h1ddblw=; b=lULX5HIQA49HMpjnmMClZ
        bUDrbrnBT081jnGcf/yLo0vTjve0E95ZcYr4gtOirJnKHVSukPOHtpqM5MUA5IJD
        7RCV7bfKOf3NrieJeHbi1O+RjPWYEicTeYXqseOQEWh9nP/sPdwV22SEMfSJBFJH
        5B9xKjMFY2R0BhSYy55Tgo=
Received: from localhost.localdomain (unknown [36.112.3.164])
        by smtp5 (Coremail) with SMTP id HdxpCgCHGUqjRBhjg6Qvag--.54847S4;
        Wed, 07 Sep 2022 15:13:51 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] SUNRPC: Fix potential memory leak in xs_udp_send_request()
Date:   Wed,  7 Sep 2022 15:13:38 +0800
Message-Id: <20220907071338.56969-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgCHGUqjRBhjg6Qvag--.54847S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr1rZFy8CrWkXrWkuw4fuFg_yoWfAFcEgF
        ykWa1xXr1qganxJayUZa13Gr1ayay7WFZ5u3Z3GFy7J3W8ur13tr10grn3GayxCr43Jr98
        C3WkKry2yw1SvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRK7KsUUUUUU==
X-Originating-IP: [36.112.3.164]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/xtbBOQZ1jF-PPLOtqgAAse
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xs_udp_send_request() allocates a memory chunk for xdr->bvec with
xdr_alloc_bvec(). When xprt_sock_sendmsg() finishs, xdr->bvec is not
released, which will lead to a memory leak.

we should release the xdr->bvec with xdr_free_bvec() after
xprt_sock_sendmsg() like bc_sendto() does.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 net/sunrpc/xprtsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e976007f4fd0..298182a3c168 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -958,6 +958,7 @@ static int xs_udp_send_request(struct rpc_rqst *req)
 		return status;
 	req->rq_xtime = ktime_get();
 	status = xprt_sock_sendmsg(transport->sock, &msg, xdr, 0, 0, &sent);
+	xdr_free_bvec(xdr);
 
 	dprintk("RPC:       xs_udp_send_request(%u) = %d\n",
 			xdr->len, status);
-- 
2.25.1

