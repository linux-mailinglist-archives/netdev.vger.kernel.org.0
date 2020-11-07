Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A852AA7B3
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbgKGTiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGTiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:38:09 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDD5C0613CF;
        Sat,  7 Nov 2020 11:38:09 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id m143so5407232oig.7;
        Sat, 07 Nov 2020 11:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=NPVTKJWmUSvOJP9rbtvMF3MMcTo6hjjAwGFYmud3CuY=;
        b=qOfrOK/2tjZM8MaWG6SWiJfebBPU6LXs8nOF7SAKUFIlSkz9zEJ+HuX0HUxaZIsfnK
         KnBITDKgdmfrxlL3948tPiWNjwAs70n/rWx5pLOwLsbtBpYGPc/K1HTMQcP2tZmgDfWs
         AVmEz77datlf04tCJrQCBEv1gxmhUXsvcPPZpCH98pDoa6ZSnpEKIqMBx4Ss+lHHGERj
         zDsleUStKMrGTJoSht+m3YkGwTV12Vkb4AbntAnRajhtpPm+tm1dM8EsA2ijVquEeARl
         3MmtOYCqSPHWjgoZZhnZmbkCQGvzJKSlyVj9ht0A4zkjHXndJLXVlzsUnK9CxAJbH3/1
         NN4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NPVTKJWmUSvOJP9rbtvMF3MMcTo6hjjAwGFYmud3CuY=;
        b=lR4X3WLrjIVEyeH5XsRO0z9SGCvA1NC47SdhFgAwxpOeCDe0cM4UkwyyRHIUofZAlA
         91pIGoCTYKEKD2lJWhlGBaYu3FbUXrrpRxy7YihF3n+qOytzUwF6aIpX4kJCWkeulCqE
         enkxC8nN0qGLaW/Q2U25NEXmeBG95lK7RdQcFOdxqKwPSsZTlfJYNcXuoq8j5t2nJ+WV
         f9cf4x4FgBU4yTSUqLXBI+FCtgvLeQXmd9s/i5DK4bRKxxIPdE8ehOpFQuxM5munYcp7
         N25Gz6AgPqcoqQWLI1uutydac7+HO0c/4IqlCEv1X/4Py6Dx9vrjGxoarN8hLbMdzqCg
         RoVg==
X-Gm-Message-State: AOAM53082H5FW71HHAq2iqkXQ1XgDlS/wNTh7ws0irjYnD1kfo3/zHHY
        yivWvL1aAfvuorwzTAWCMPB/F59xtUYRvQ==
X-Google-Smtp-Source: ABdhPJzZUjVmCRkf6CSW4Q8oDRCjx2duacPPnJZinIlFsrUhF1foKa2T3fNV6ord91rwTbCxVHdt1Q==
X-Received: by 2002:aca:3e86:: with SMTP id l128mr4510950oia.133.1604777889029;
        Sat, 07 Nov 2020 11:38:09 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j7sm1259489oie.44.2020.11.07.11.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 11:38:08 -0800 (PST)
Subject: [bpf PATCH 1/5] bpf,
 sockmap: fix partial copy_page_to_iter so progress can still be made
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Sat, 07 Nov 2020 11:37:55 -0800
Message-ID: <160477787531.608263.10144789972668918015.stgit@john-XPS-13-9370>
In-Reply-To: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
References: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
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
 net/ipv4/tcp_bpf.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 37f4cb2bba5c..3709d679436e 100644
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
@@ -37,10 +37,9 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 			page = sg_page(sge);
 			if (copied + copy > len)
 				copy = len - copied;
-			ret = copy_page_to_iter(page, sge->offset, copy, iter);
-			if (ret != copy) {
-				msg_rx->sg.start = i;
-				return -EFAULT;
+			copy = copy_page_to_iter(page, sge->offset, copy, iter);
+			if (!copy) {
+				return copied ? copied : -EFAULT;
 			}
 
 			copied += copy;
@@ -56,6 +55,11 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 						put_page(page);
 				}
 			} else {
+				/* Lets not optimize peek case if copy_page_to_iter
+				 * didn't copy the entire length lets just break.
+				 */
+				if (copy != sge->length)
+					goto out;
 				sk_msg_iter_var_next(i);
 			}
 
@@ -82,6 +86,7 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 						  struct sk_msg, list);
 	}
 
+out:
 	return copied;
 }
 EXPORT_SYMBOL_GPL(__tcp_bpf_recvmsg);


