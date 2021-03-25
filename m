Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34FB3494DD
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhCYPC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhCYPCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:02:01 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF50C06174A;
        Thu, 25 Mar 2021 08:02:01 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id x14so2019609qki.10;
        Thu, 25 Mar 2021 08:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D6lqBkmqDi36o04hy81nixhjopIa3qv0i9AAEd/fUWA=;
        b=QjNiajmB8gVa1mycAekPlCc88I7cNIkFrq1JW4JZPgh1nb9NQ+NvVOA5X9tVtkqwaQ
         0tEj4Zr1igynSalGkTsxc5QMi6/DuPBUBzuu7tchXbMgLj00Mv6e/2IgblTY3GzuGvGk
         MkmONWAcnjYZ9G2tjitB2Zk7oeaRewtFB+p+xR0+jUUxGPfmX7jDuSkVS3dajFc6gFRR
         hRwmJdSgxakAVPgkj+UwXAglqqbjZVcUSt2J3LI9IwmymGOMzXm+9nidW8v86aXpSRrA
         GTTnLK+XX0ofgrMfQ0UtZQ/Kre9X7gF1gDtYBABIVy/mOo4cV5jpJzO+cgG7lp/J1Qx3
         E3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D6lqBkmqDi36o04hy81nixhjopIa3qv0i9AAEd/fUWA=;
        b=AgCMc7NGvaM/aDlY608nauW4xLhp3lgACs5lUfR+4/N7thgAOi7qQCpyqhe8TJHEKW
         z60DTwwkhaYLYF7ZqCBkRLsHYyHliEn8vfM3gYAvSYkH/3UHBdBbhVNX3x0eUUJkuhQI
         8fSeJfD5APDWc+MX/wjNhGD/DflNaF9XVhD5MGNk8RKBqdqFfAdDxoL3moV4r1/y4tXJ
         hiulYexFlkT+a4gHkZSGnhrO99T8q6WHXxHrDmARHgm+KYLpD1RUySnaptXTXHSVOFPy
         cQtvmx2VKNzSgM8Xq/UcG2dxz694pRkjNJbn3njd8piFhhjj7hBP6NwVwkTo8vHPbzpn
         7vfA==
X-Gm-Message-State: AOAM530qcfFPE2vsFCldCS/h3nN+yd2Y44DJ2Zgj0C7l+Y5s7wITXW8+
        PS33PQrmDex6a5hHIk9p92A=
X-Google-Smtp-Source: ABdhPJyfq2qXFDWvIbGbYdWsuxBVQZT7cmtz7Mh3rfp4HUM45O97U1d5wQivOPeOLXkRRQOsN4ko1Q==
X-Received: by 2002:a05:620a:11ad:: with SMTP id c13mr8570692qkk.282.1616684520625;
        Thu, 25 Mar 2021 08:02:00 -0700 (PDT)
Received: from localhost.localdomain ([179.218.4.27])
        by smtp.gmail.com with ESMTPSA id c19sm4006766qkl.78.2021.03.25.08.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 08:02:00 -0700 (PDT)
From:   Pedro Tammela <pctammela@gmail.com>
X-Google-Original-From: Pedro Tammela <pctammela@mojatatu.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: fix bail out from 'ringbuf_process_ring()' on error
Date:   Thu, 25 Mar 2021 12:01:15 -0300
Message-Id: <20210325150115.138750-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code bails out with negative and positive returns.
If the callback returns a positive return code, 'ring_buffer__consume()'
and 'ring_buffer__poll()' will return a spurious number of records
consumed, but mostly important will continue the processing loop.

This patch makes positive returns from the callback a no-op.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 tools/lib/bpf/ringbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 8caaafe7e312..e7a8d847161f 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -227,7 +227,7 @@ static int ringbuf_process_ring(struct ring* r)
 			if ((len & BPF_RINGBUF_DISCARD_BIT) == 0) {
 				sample = (void *)len_ptr + BPF_RINGBUF_HDR_SZ;
 				err = r->sample_cb(r->ctx, sample, len);
-				if (err) {
+				if (err < 0) {
 					/* update consumer pos and bail out */
 					smp_store_release(r->consumer_pos,
 							  cons_pos);
-- 
2.25.1

