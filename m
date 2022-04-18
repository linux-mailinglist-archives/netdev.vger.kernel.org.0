Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AD6505CB6
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346437AbiDRQwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346425AbiDRQwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:52:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A27432ED9;
        Mon, 18 Apr 2022 09:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B690E612E4;
        Mon, 18 Apr 2022 16:49:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9833DC385AA;
        Mon, 18 Apr 2022 16:49:37 +0000 (UTC)
Subject: [PATCH RFC 2/5] tls: build proto after context has been initialized
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:49:36 -0400
Message-ID: <165030057652.5073.10364318727607743572.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

We have to build the proto ops only after the context has been
initialized, as otherwise we might crash when I/O is ongoing
during initialisation.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/tls/tls_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7b2b0e7ffee4..7eca4d9a83c4 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -836,8 +836,6 @@ static int tls_init(struct sock *sk)
 	struct tls_context *ctx;
 	int rc = 0;
 
-	tls_build_proto(sk);
-
 #ifdef CONFIG_TLS_TOE
 	if (tls_toe_bypass(sk))
 		return 0;
@@ -862,6 +860,7 @@ static int tls_init(struct sock *sk)
 
 	ctx->tx_conf = TLS_BASE;
 	ctx->rx_conf = TLS_BASE;
+	tls_build_proto(sk);
 	update_sk_prot(sk, ctx);
 out:
 	write_unlock_bh(&sk->sk_callback_lock);


