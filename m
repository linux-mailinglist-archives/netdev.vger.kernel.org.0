Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9942B12BF
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgKLX1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgKLX1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:27:04 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA26C0613D1;
        Thu, 12 Nov 2020 15:26:55 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id l10so1743526oom.6;
        Thu, 12 Nov 2020 15:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Mv1nt7L5lJAD6UWt7vcLmtlaJBvfyTmw84ZoL88Oi2E=;
        b=NCoOjxcLYXvZ39sHyrxlkE6EEyy5jssR7pPVm1KoLJU/HfUW+Sa8TcpIs0cHEueB1c
         Pc6xySJ12v09I2NAkszZ3/fCkjbvz3Pu3R8OWpmhEBfGEUnAX5flK4LQVpNgzvPi8GsA
         +/jEyD5c3MsDekrG/QPG1f031oAkEIgLy6H3IrtaxyrKbsF8dyiSpSYGJ3dmm9ZwyL6/
         /cyUp0KP3cwXq0y+RxPGnDNfcAGel0q1YlCDdHkAG0NFBKE9yLffQQZQLBMLI+p042jz
         +YneNpL18iLB6452DD9YQ4L4dnKMoaLstPoMKjiuubFy8mTMAIN74KnGPxBVJ9GgsFNJ
         T/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Mv1nt7L5lJAD6UWt7vcLmtlaJBvfyTmw84ZoL88Oi2E=;
        b=b8BJDmR55qvTqYQm/UEvtDJL+aiuceEy0QV1bGyTJQwWprgGDxS9GTgGGaW8ygbcrK
         880RII7Kqn4ml0rF9JJlIwlO1dn7PNX4xaX8g6Z4nVu8fsvGYgOng0E+iOGaKNnitY4h
         LD0pRl/a5xNVF041Vi+e5PCcUCJx3N6DvVXjuRB8Njl6GwPI8XVhLLp6Rwa5LHSK4617
         PcbbyKocudbc1tSIMiudg+7ZMvqQCH8y+SXy8fTM0OTJgS0Ur5i3OIXDGRVw3AL/TGY4
         66UvKjIXOOkVwuTGT/GOURFZuuMcBcnUz7QI4LLM5t6fxozpNuSKArpZpsJvIetb6wGX
         BkEQ==
X-Gm-Message-State: AOAM533xfSXN1T3qTR19K59p+pPtuXwFHqxQ3RlRs/nOcPc7WHW6178C
        gX+7Ge9FyXopVn1r5xuNtos=
X-Google-Smtp-Source: ABdhPJyQ4K66OTjvIhRJvSvy8Yum3gYfbbJ3iOvjjD65DPEEUqVW5pAdYY69IyiJrqLJPTEQYWLZiQ==
X-Received: by 2002:a4a:e1c6:: with SMTP id n6mr1274055oot.68.1605223614564;
        Thu, 12 Nov 2020 15:26:54 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j186sm1472379oib.38.2020.11.12.15.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:26:53 -0800 (PST)
Subject: [bpf PATCH v2 1/6] bpf,
 sockmap: fix partial copy_page_to_iter so progress can still be made
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 15:26:39 -0800
Message-ID: <160522359920.135009.3651330637920905285.stgit@john-XPS-13-9370>
In-Reply-To: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
References: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If copy_page_to_iter() fails or even partially completes, but with fewer
bytes copied than expected we currently reset sg.start and return EFAULT.
This proves problematic if we already copied data into the user buffer
before we return an error. Because we leave the copied data in the user
buffer and fail to unwind the scatterlist so kernel side believes data
has been copied and user side believes data has _not_ been received.

Expected behavior should be to return number of bytes copied and then
on the next read we need to return the error assuming its still there. This
can happen if we have a copy length spanning multiple scatterlist elements
and one or more complete before the error is hit.

The error is rare enough though that my normal testing with server side
programs, such as nginx, httpd, envoy, etc., I have never seen this. The
only reliable way to reproduce that I've found is to stream movies over
my browser for a day or so and wait for it to hang. Not very scientific,
but with a few extra WARN_ON()s in the code the bug was obvious.

When we review the errors from copy_page_to_iter() it seems we are hitting
a page fault from copy_page_to_iter_iovec() where the code checks
fault_in_pages_writeable(buf, copy) where buf is the user buffer. It
also seems typical server applications don't hit this case.

The other way to try and reproduce this is run the sockmap selftest tool
test_sockmap with data verification enabled, but it doesn't reproduce the
fault. Perhaps we can trigger this case artificially somehow from the
test tools. I haven't sorted out a way to do that yet though.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/ipv4/tcp_bpf.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 37f4cb2bba5c..8e950b0bfabc 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -15,8 +15,8 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 {
 	struct iov_iter *iter = &msg->msg_iter;
 	int peek = flags & MSG_PEEK;
-	int i, ret, copied = 0;
 	struct sk_msg *msg_rx;
+	int i, copied = 0;
 
 	msg_rx = list_first_entry_or_null(&psock->ingress_msg,
 					  struct sk_msg, list);
@@ -37,11 +37,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 			page = sg_page(sge);
 			if (copied + copy > len)
 				copy = len - copied;
-			ret = copy_page_to_iter(page, sge->offset, copy, iter);
-			if (ret != copy) {
-				msg_rx->sg.start = i;
-				return -EFAULT;
-			}
+			copy = copy_page_to_iter(page, sge->offset, copy, iter);
+			if (!copy)
+				return copied ? copied : -EFAULT;
 
 			copied += copy;
 			if (likely(!peek)) {
@@ -56,6 +54,11 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 						put_page(page);
 				}
 			} else {
+				/* Lets not optimize peek case if copy_page_to_iter
+				 * didn't copy the entire length lets just break.
+				 */
+				if (copy != sge->length)
+					return copied;
 				sk_msg_iter_var_next(i);
 			}
 


