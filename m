Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC097134EAC
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgAHVPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:15:11 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:39191 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgAHVPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:15:10 -0500
Received: by mail-il1-f196.google.com with SMTP id x5so3886586ila.6;
        Wed, 08 Jan 2020 13:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=R01+CMo0RVfAWZgIcUOi47biaid6EcOVDaXjw4Yf1DM=;
        b=Yy48ZqE+361CSnDnXBR2wVWy0DeyOm6JU6USAVm8V+a8o9xUuQtPQbTkh1nsCkVx8L
         j+m3QnHfEQ9P6MLFi3PRTrGyCLi0CcoIrkHDVNRCfuEfSDFSGYzOa06FzrWxMJr2C60A
         ps8gnAzcWD3sKR0ZEbFztrxjZBeYoRpbc/COqSVOKMxMu1WhFCjQ8BupFjEwf993oM8Q
         5gX9W6SpMDefxKANSBsBOHAUtnuMR6Od5a0oS/w086FtgEYYg6hjIZGQLKsBMu/Ik3u0
         Jw9oUF2XgsLyeWP0YsYh/4IA5dyflT6zq0BV3D1X/ThVqaV5URRmQkJb9i5wqLfhV8gI
         tb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R01+CMo0RVfAWZgIcUOi47biaid6EcOVDaXjw4Yf1DM=;
        b=UeVm/hrbKSnKPrmvMf6o3IQOtYya17LMs4jG1RVUsyPMaNTNPxeZU9BGRyPuhzN+X4
         nZE0jEKK5RGvw29480bM4olR5I/B2M9wiuYokbpfNXOUTlosQ1T6r2zINs0VrSiwUGE4
         Og5epuDMKezYUToGilkRVaBg8AQQMU6BB/O2imHnlfsais/6Ca3/H+cWti7mlwsC9ojT
         53LLS/GTg2sjLMBnQiz9PgOoSNAk3tGCHRrQeuyHYTVTUV++3NvXZ4Fp3uGowcnbVKcl
         Th3jfv92q99FCzLf3qkE9wrYk1fXsjtrNiMCw8Qgy3WdSzY9NWLriEix79j+B3r7m1BH
         IRog==
X-Gm-Message-State: APjAAAVSi41m00xVoEP+4tsektQRxlUw0DDuSKnZ2cbnGujeDlcWvxcw
        Vh1PSCt5Ut3zcIO3/aVJd+3c9jG2
X-Google-Smtp-Source: APXvYqy7NoWL+AdwBrnVel3a7s6z8DEgl9xhq2+mYh7yh6TSczvEN1TbuQT/0xeXoH9rCu0oPm8N1g==
X-Received: by 2002:a05:6e02:d05:: with SMTP id g5mr5536389ilj.272.1578518110164;
        Wed, 08 Jan 2020 13:15:10 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a7sm908014iod.61.2020.01.08.13.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 13:15:09 -0800 (PST)
Subject: [bpf PATCH 4/9] bpf: sockmap, skmsg helper overestimates push, pull,
 and pop bounds
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 21:14:58 +0000
Message-ID: <157851809847.1732.8255673984543824278.stgit@ubuntu3-kvm2>
In-Reply-To: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/filter.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 28b3c258188c..34d8eb0823f4 100644
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
 

