Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425B01D1EC2
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390483AbgEMTOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387469AbgEMTOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:14:38 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963AFC061A0C;
        Wed, 13 May 2020 12:14:38 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id x5so299391ioh.6;
        Wed, 13 May 2020 12:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=xGBwlQtGoaNYgfOnJCC61s1o80ih0DoV5BMaC6NrFsw=;
        b=omEh8HzyZGPMm93orBnqzJgZKlcRfMt+nVPnx3ozjAmlHQywPQegrCtcDIbQ0KUqwl
         SxMYEsk0uwGRXLXF9v/Prf1vYt07UFamBu0NQPVgq9CjwCbn9JEBc5MCaQxbuueHMk6b
         xoQY6gv/Y2YtehRjUzah8ZMBs/RrmIzeYbDDl6nakHyb2ObCWL1WuSkZWnUJuf6BD8zW
         FKw9vfThN8PrUPCfegNSuYY4PrIJsW9RB5MDa/vDaKMdlQLYjJrcdKSssRykRU8wLeoa
         4oTabuwDwXP0YXfJKAVil/B4uIctGeMkkwfn+ArEzYIBch2LkGJn3Xtt6iCnyMZcVtSB
         F14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xGBwlQtGoaNYgfOnJCC61s1o80ih0DoV5BMaC6NrFsw=;
        b=oLmcFeZMpekIxwbVaa9DCgJ+zS1U+wEn1U+uuq2cr/XpWxO56Ev09g/ZOH0+UZ09RH
         hoqakgKwayT2XU8n+lgWaL656ZgZoT0VvkwdpbInVFWv2uSSNO0/lQpYHB7K7X/cKabF
         nOJfBhcvQKNTFOCth6pefDS9Hw3pEnYhEKWCsFaQELsOP02osQbz2Pqvq4PQy9Vbfpwl
         +XuZKFflO1Jgw4rFM9QdZQUlTs/ttxJszKNrjjXYWePrb0bfkr416Uup9dCPMKk06j+Z
         vtL8Yz4xui2shlhkE90yl8EGfPUq8klkmFP1R5aBW1GDPqWPHBFQwRwQLX1qat1jMsSV
         GWtA==
X-Gm-Message-State: AGi0PubEvPf2P/Od34ebzIwS+lyBvUtNiM4d+LmbUskcoYGcAfdQ+5Qd
        XsVBvpuzG9bguQbHoPzuGhI=
X-Google-Smtp-Source: APiQypIj6mHnsxch8JAEYks98+EEkVokUx7Qs5+kKbFHSgArQg05je6uFYIvKshNFKJevDgaMMUjuQ==
X-Received: by 2002:a02:344d:: with SMTP id z13mr980993jaz.65.1589397277940;
        Wed, 13 May 2020 12:14:37 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w1sm152392ila.63.2020.05.13.12.14.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:14:37 -0700 (PDT)
Subject: [bpf-next PATCH v2 07/12] bpf: selftests,
 improve test_sockmap total bytes counter
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:14:25 -0700
Message-ID: <158939726542.15176.5964532245173539540.stgit@john-Precision-5820-Tower>
In-Reply-To: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
References: <158939706939.15176.10993188758954570904.stgit@john-Precision-5820-Tower>
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

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/test_sockmap.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 7f45a8f..9a7e104 100644
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
@@ -638,8 +639,12 @@ static int sendmsg_test(struct sockmap_options *opt)
 
 	rxpid = fork();
 	if (rxpid == 0) {
+		iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
 		if (opt->drop_expected)
-			exit(0);
+			_exit(0);
+
+		if (!iov_buf) /* zero bytes sent case */
+			_exit(0);
 
 		if (opt->sendpage)
 			iov_count = 1;

