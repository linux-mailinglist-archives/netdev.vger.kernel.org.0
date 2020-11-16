Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CFE2B544B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgKPW2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:28:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbgKPW2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:28:01 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CA9C0613CF;
        Mon, 16 Nov 2020 14:28:01 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id d9so20517770oib.3;
        Mon, 16 Nov 2020 14:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=IosZaA2J4WB04PBn1llEGI1Q5uikyxZcnchHfDV0ON0=;
        b=QpCfn048Rb2F2BjKhWu0wJhZm8nH8/AAlMT1F4Nt7xMppyJyhsrkI9aiKlqDAaO+OE
         PpGNsJ5wdUeitX2n2LbBAjXmFJvsSMsg0ohW/dI/jCuL9FiiJCJCYmLXrtc5+KWwHIx2
         D+FpBPVgk5Wl8i8eD7VX7udSQGPX7fp1T9sR+SrwahreJJwEaaB/IZAKFPvNn8o+5btu
         9vr3rIMzOz1/DTMy0kSIBNmfqNdikeX7/auzu2hZgNmjZR0nsze603Soz03v7mfGdHiA
         5KwG+1rUDDF73nL9D/6oPvB0EL34WM0+QcEWLVdbZfQnJIV+uF+G0guh28r1z5V9R62M
         J0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IosZaA2J4WB04PBn1llEGI1Q5uikyxZcnchHfDV0ON0=;
        b=JLKwwsUgehMKeeLam+YUo6Y64Uwo3TYTT2H75nPirWYtLcvjDUGRq0VpaeOUYYGvGE
         E5fAuBIU6cx0gY2k9C0kuzEVZKnggtXkEOuQu0ETywirfVCXrh7KzqWuQS3hcuEnIa/F
         oPp2Ay//Flhzu8SlutDaq4IX1eKVs4c58pcoYyHc/fre/5XD2n37/qPnQm4M2oUMG+gW
         1zHfkIIzM6T7WYyQ2TbvPMnbjlam/DpAxc9Xt+8+DK308fCytKa1Dbiobd15mFsLsfh3
         WnIFylV0AdFMIVX+3nvzGE6o8y/LjgVViV5NvbzMMwy4cSlf6DH9WyC8ejlXpAdCux+G
         ylAQ==
X-Gm-Message-State: AOAM530SChHaSqPnM00UDz5nBeQycsxcjU0EtZ1fspwz8nOqUCTlsYra
        H5YebTy+vaH8g4YtlhpFD80+HsE1EWG1Gg==
X-Google-Smtp-Source: ABdhPJzrs4QSdqjppUHQQp2IsbW+JMz+NMoR2Oe+/nFhYFhQAEpMqmvTKau6XqIIGs1Tesus7ZZOsQ==
X-Received: by 2002:aca:a988:: with SMTP id s130mr583643oie.172.1605565680656;
        Mon, 16 Nov 2020 14:28:00 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v82sm4971383oif.27.2020.11.16.14.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:28:00 -0800 (PST)
Subject: [bpf PATCH v3 1/6] bpf,
 sockmap: fix partial copy_page_to_iter so progress can still be made
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, ast@kernel.org, daniel@iogearbox.net
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 16 Nov 2020 14:27:46 -0800
Message-ID: <160556566659.73229.15694973114605301063.stgit@john-XPS-13-9370>
In-Reply-To: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
References: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
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
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
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
 


