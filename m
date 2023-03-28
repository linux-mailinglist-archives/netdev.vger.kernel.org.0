Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09906CB2D9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 02:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjC1Amp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 20:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjC1Amn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 20:42:43 -0400
Received: from out-38.mta1.migadu.com (out-38.mta1.migadu.com [IPv6:2001:41d0:203:375::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66E22114
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 17:42:42 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679964159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rf1EkSEFlgAO5tBERqxTHe8l/2my1WJLxeCtmisFink=;
        b=v08g/ECkIFew3lbUwGX388WJy0TEbrwDSxipvz7FiSCbx8RYS+q+mU/j89IdwiTa6AH6sl
        aRWN338PfhGez0N7fF3MB+AcOjujAQt8FhPeOJbe0MmNVrEDK89e/2lqYPQzRMURyf9BLZ
        +cwnFBtTnNkvyOZGV2eaAQBp+z9USX8=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH bpf] bpf: tcp: Use sock_gen_put instead of sock_put in bpf_iter_tcp
Date:   Mon, 27 Mar 2023 17:42:32 -0700
Message-Id: <20230328004232.2134233-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

While reviewing the udp-iter batching patches, notice the bpf_iter_tcp
calling sock_put() is incorrect. It should call sock_gen_put instead
because bpf_iter_tcp is iterating the ehash table which has the
req sk and tw sk. This patch replaces all sock_put with sock_gen_put
in the bpf_iter_tcp codepath.

Fixes: 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock")
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ea370afa70ed..b9d55277cb85 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2780,7 +2780,7 @@ static int tcp_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
 static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
 {
 	while (iter->cur_sk < iter->end_sk)
-		sock_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++]);
 }
 
 static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
@@ -2941,7 +2941,7 @@ static void *bpf_iter_tcp_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		 * st->bucket.  See tcp_seek_last_pos().
 		 */
 		st->offset++;
-		sock_put(iter->batch[iter->cur_sk++]);
+		sock_gen_put(iter->batch[iter->cur_sk++]);
 	}
 
 	if (iter->cur_sk < iter->end_sk)
-- 
2.34.1

