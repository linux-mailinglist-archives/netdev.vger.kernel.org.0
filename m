Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B5137BC9
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 07:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgAKGNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 01:13:02 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:42207 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgAKGNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 01:13:02 -0500
Received: by mail-il1-f196.google.com with SMTP id t2so3590750ilq.9;
        Fri, 10 Jan 2020 22:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8SRJAuD6qlOD0HSHgo+IvNbTx/fcAJ7xhAU9mfc1Ves=;
        b=o6uawgi+8OmM89CDqXqZoGJfdNydWXpnWS0ecI9oEOo8pXTIPUq748kWVRBRPnj3Ov
         kb+MuhelrLsa3rkE7QP85w6KqA9zFU5HMAhC8WuxqXa98iz1FWF1eE7E0czepMw/3ux1
         kqRmSP9jEO2Qiih3b+S+qvLa+OCnI8X1W9nOT69LgxAUqNSHac5pcfaayTvm4EolLcGp
         cH2R3Oj5WLrfl1bYz8CX5Ra1FObFq5IjfU8g2JMrTNcsSJme1LDo0qEk5V+v/We/cAXW
         raErJb5fImh/f1oHTCsdV2O6gESvAcTOq0yIEn3+zPxIRoSsr1LYC1XmFKzrUUnPfeDA
         dg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8SRJAuD6qlOD0HSHgo+IvNbTx/fcAJ7xhAU9mfc1Ves=;
        b=LGp34mRGPMC1yFKOuiGALQstHypiSgFh8CUPCt3kqT/cA3EtcZukNbt1wd4y36Q0Vw
         jK53lCvlbn4fk028P05ciEoJjEyrU1/vdYTpO88uRFmcBGNnKm97oUdgGWOcSOrQBJq2
         ujuxARl5a5zX50ty6S+a5CsQZWlK6yC+0IUqrH8wNoEUJzcCHMXSazc43xI2ZCnYOjyv
         bGWeuyZDH/bDc5UeG/eiecFyAAr5tmriIDEzuJ2sTi5zLr+w4BgA9Q5Nqjywp/jas6wm
         nfc6+xMN1v+Zvs5/n2NFUTk2Xw7FwGtTftSqkhTPjiHl16ndkmptPmARE1tMaicJ+24H
         Me1Q==
X-Gm-Message-State: APjAAAVUpwjnGUvGAlRNDaGJC3PAuwSWnjyzoxiDej7Pm6M5YWvKoqUy
        17AGD0rtXfot4WEKEMUzlcsqIcLS
X-Google-Smtp-Source: APXvYqweHuLLy6ioN+DmkMuH2W62etIvLBu1N4lBObEkyEBEU+eiUj3Ez4rBfL6qqDaChFVymVTAkg==
X-Received: by 2002:a92:d809:: with SMTP id y9mr6241457ilm.261.1578723181012;
        Fri, 10 Jan 2020 22:13:01 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 141sm1417784ile.44.2020.01.10.22.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 22:13:00 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        john.fastabend@gmail.com, song@kernel.org, jonathan.lemon@gmail.com
Subject: [bpf PATCH v2 4/8] bpf: sockmap, skmsg helper overestimates push, pull, and pop bounds
Date:   Sat, 11 Jan 2020 06:12:02 +0000
Message-Id: <20200111061206.8028-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200111061206.8028-1-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the push, pull, and pop helpers operating on skmsg objects to make
data writable or insert/remove data we use this bounds check to ensure
specified data is valid,

 /* Bounds checks: start and pop must be inside message */
 if (start >= offset + l || last >= msg->sg.size)
     return -EINVAL;

The problem here is offset has already included the length of the
current element the 'l' above. So start could be past the end of
the scatterlist element in the case where start also points into an
offset on the last skmsg element.

To fix do the accounting slightly different by adding the length of
the previous entry to offset at the start of the iteration. And
ensure its initialized to zero so that the first iteration does
nothing.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Fixes: 6fff607e2f14b ("bpf: sk_msg program helper bpf_msg_push_data")
Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
CC: stable@vger.kernel.org
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d22d108fc6e3..ffa2278020d7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2231,10 +2231,10 @@ BPF_CALL_4(bpf_msg_pull_data, struct sk_msg *, msg, u32, start,
 	/* First find the starting scatterlist element */
 	i = msg->sg.start;
 	do {
+		offset += len;
 		len = sk_msg_elem(msg, i)->length;
 		if (start < offset + len)
 			break;
-		offset += len;
 		sk_msg_iter_var_next(i);
 	} while (i != msg->sg.end);
 
@@ -2346,7 +2346,7 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 	   u32, len, u64, flags)
 {
 	struct scatterlist sge, nsge, nnsge, rsge = {0}, *psge;
-	u32 new, i = 0, l, space, copy = 0, offset = 0;
+	u32 new, i = 0, l = 0, space, copy = 0, offset = 0;
 	u8 *raw, *to, *from;
 	struct page *page;
 
@@ -2356,11 +2356,11 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 	/* First find the starting scatterlist element */
 	i = msg->sg.start;
 	do {
+		offset += l;
 		l = sk_msg_elem(msg, i)->length;
 
 		if (start < offset + l)
 			break;
-		offset += l;
 		sk_msg_iter_var_next(i);
 	} while (i != msg->sg.end);
 
@@ -2506,7 +2506,7 @@ static void sk_msg_shift_right(struct sk_msg *msg, int i)
 BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 	   u32, len, u64, flags)
 {
-	u32 i = 0, l, space, offset = 0;
+	u32 i = 0, l = 0, space, offset = 0;
 	u64 last = start + len;
 	int pop;
 
@@ -2516,11 +2516,11 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 	/* First find the starting scatterlist element */
 	i = msg->sg.start;
 	do {
+		offset += l;
 		l = sk_msg_elem(msg, i)->length;
 
 		if (start < offset + l)
 			break;
-		offset += l;
 		sk_msg_iter_var_next(i);
 	} while (i != msg->sg.end);
 
-- 
2.17.1

