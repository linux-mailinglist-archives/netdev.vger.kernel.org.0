Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D131C625E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbgEEUv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728660AbgEEUv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:51:28 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F44C061A0F;
        Tue,  5 May 2020 13:51:27 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f3so3908404ioj.1;
        Tue, 05 May 2020 13:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=xJng1Ix8TW8nkrcPtgXZNfXYIs9G0OJY9EPsHGjvKZM=;
        b=MXmyIis9L8q/oZxluBnpKbGR0CP54puLFPh0MXbq5H9JieTp0Sg8deRUUmORgCs1mi
         vZUYDE0H5KGL55a3oaJCL+lksmgBlpMjH4plKcJMPLmoUr+HZFW6JN2uxAvaomopnNLc
         /nMU1H9cX8Yx6Hh2WqoxestDWXd2xUcsjm4XiG+ejlMS3SqIiUcsdNIYLUR6fYozaEiY
         sGAJuor5bX5ZmefpSNaZj8TRbfgG+P2aRgbjaGro36g0+giw1rDDo3mDlNO52p3TpwAj
         AIYJRVPwOToBOpaC3XKxwoAIRoCacmev+36hgDs0s2s9y8bATVELRcfQ2Yokw8xVUuqa
         USCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xJng1Ix8TW8nkrcPtgXZNfXYIs9G0OJY9EPsHGjvKZM=;
        b=bIrz+vfCN2D4KmhqWrm7ucsdOzqlS/tsQ/wGkKBHMe/qLI8ufZiCa4VJCqdS3AtPEe
         zBuUteSIOmkEo37nONeV7NpUQ/4GJe7JJpuUyBQkM4uB1J6cjWdUvuXZwQKw5wAljvmE
         Rt45V1CP3AuVAsqB+Bfs8bIblv0+zSEym72PBTaU7XdTRXm9klswFU75gMGXYNwaCIfC
         Nxz2cjEWfCE9MOMcvZlvLANovm9MN2YhyzSHz33rmq3z6qzxHeoxkOwaHveBip4mxAaX
         0qzMDHxDCBbCx3ivlQsqaIPXxba8W1Cdqm3z0glrL5tnQYmCsq118fuqpmbU1Sgt4Of6
         pOww==
X-Gm-Message-State: AGi0Puaw7njGgb4BUy+vpwVX7BiB/F68zGuT52L7yKtqzA07FLd9mTIG
        uQBVsgGPbLuu3j2U/oKwHtRFOi2UZgc=
X-Google-Smtp-Source: APiQypKqKqoAZjo64z0EAHPP8UVJ3M1+WXGFWsvjiMtkRb/C8JGfOnOsbP5TPS+dtNmJ9CAJYje1RQ==
X-Received: by 2002:a05:6602:1303:: with SMTP id h3mr5332937iov.14.1588711887146;
        Tue, 05 May 2020 13:51:27 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k18sm2346992ili.77.2020.05.05.13.51.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 13:51:26 -0700 (PDT)
Subject: [bpf-next PATCH 05/10] bpf: selftests,
 improve test_sockmap total bytes counter
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Tue, 05 May 2020 13:51:14 -0700
Message-ID: <158871187408.7537.17124775242608386871.stgit@john-Precision-5820-Tower>
In-Reply-To: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recv thread in test_sockmap waits to receive all bytes from sender but
in the case we use pop data it may wait for more bytes then actually being
sent. This stalls the test harness for multiple seconds. Because this
happens in multiple tests it slows time to run the selftest.

Fix by doing a better job of accounting for total bytes when pop helpers
are used.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index a81ed5d..36aca86 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -502,9 +502,10 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		 * paths.
 		 */
 		total_bytes = (float)iov_count * (float)iov_length * (float)cnt;
-		txmsg_pop_total = txmsg_pop;
 		if (txmsg_apply)
-			txmsg_pop_total *= (total_bytes / txmsg_apply);
+			txmsg_pop_total = txmsg_pop * (total_bytes / txmsg_apply);
+		else
+			txmsg_pop_total = txmsg_pop * cnt;
 		total_bytes -= txmsg_pop_total;
 		err = clock_gettime(CLOCK_MONOTONIC, &s->start);
 		if (err < 0)
@@ -638,9 +639,13 @@ static int sendmsg_test(struct sockmap_options *opt)
 
 	rxpid = fork();
 	if (rxpid == 0) {
+		iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
 		if (opt->drop_expected)
 			exit(0);
 
+		if (!iov_buf) /* zero bytes sent case */
+			exit(0);
+
 		if (opt->sendpage)
 			iov_count = 1;
 		err = msg_loop(rx_fd, iov_count, iov_buf,

