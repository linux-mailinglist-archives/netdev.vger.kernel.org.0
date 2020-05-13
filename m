Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D572D1D1EB6
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390604AbgEMTNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390588AbgEMTNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:13:04 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D0CC061A0C;
        Wed, 13 May 2020 12:13:03 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id e8so811445ilm.7;
        Wed, 13 May 2020 12:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=pOZk8UxNTX95dEutC1DQDK2tUfBzdL1DimJZ4o4eV10=;
        b=rr9HlkxscpG7wFAPPCCwWeB3OOpl9Geji8BWMQgByl1MMiTMWDn0w0aHOzfIVtcI+N
         DouJinbE5+y9VSnmd1GN0JfdW3u2xnOD8UA9FnrlmI/pQX8PkcYRtadv2O6wANmWSK2w
         jxXoPe2yi4heeAs0Yy5wcZYa1VypUEJawGOc8mjW8R1goLUoVgv6tirZJHJ2QnhDUOWq
         csWX83K0H8CqgULTySQRd02JOXuYWSP1lxOsYIHjVSI5ydMt6PlOT1DTU4g7KDdWwcbm
         ZihIpxkJR/bNatKzKlePKEj69zHS6cSze071kmwXW096zRVjos+nJTjO3E180UUuI4w/
         +OwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pOZk8UxNTX95dEutC1DQDK2tUfBzdL1DimJZ4o4eV10=;
        b=i01V0l4PhGSkd4SsOBrMXemGxA/9qVVmH/HMpQxLAbtqfKX8PYj4siq7vZL4T+UTOO
         r4jjccOq8x3neqTRIM6fiEF3PO+LJGs+U3uvXWgleWLjzqkpeuJWBliitffWggN0m5Nr
         9s+LTbZ/gHp0XCqy/66ZBuzofSljp9h8IQG6XlRPTN9jepLMeaZPSLFWPuB0kjaIMa07
         EAC07C2auvgecIZ6ImgKgdTy8DGTYI1z3eZDH+oRGRSWyMve+sMmylAVQFXkjoykA2hF
         tpJI0D3zopU9BReXGAztJdxNpAf3s0mPLE/qQ+dJqGHnKa1cpCe6k1+wxsjFXBhmOia4
         kLnw==
X-Gm-Message-State: AOAM533OVudvpK1mgqAExYagcEkvyGT8DFsObu782M9kb3qKYHFdV545
        ntoQFzRLHmn+RZyyh3gbsSg=
X-Google-Smtp-Source: ABdhPJwN41Mr/9LV9o7I7xyraiI46185brVeuyZVlS4qu7sL4hslqmX98xeh5uFQvXB+0ikwqWSSLw==
X-Received: by 2002:a92:c952:: with SMTP id i18mr1030970ilq.100.1589397183222;
        Wed, 13 May 2020 12:13:03 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b11sm162929ile.3.2020.05.13.12.12.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:13:02 -0700 (PDT)
Subject: [bpf-next PATCH v2 02/12] bpf: sockmap,
 bpf_tcp_ingress needs to subtract bytes from sg.size
From:   John Fastabend <john.fastabend@gmail.com>
To:     lmb@cloudflare.com, jakub@cloudflare.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org
Date:   Wed, 13 May 2020 12:12:50 -0700
Message-ID: <158939717033.15176.12533943232686062367.stgit@john-Precision-5820-Tower>
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

In bpf_tcp_ingress we used apply_bytes to subtract bytes from sg.size
which is used to track total bytes in a message. But this is not
correct because apply_bytes is itself modified in the main loop doing
the mem_charge.

Then at the end of this we have sg.size incorrectly set and out of
sync with actual sk values. Then we can get a splat if we try to
cork the data later and again try to redirect the msg to ingress. To
fix instead of trying to track msg.size do the easy thing and include
it as part of the sk_msg_xfer logic so that when the msg is moved the
sg.size is always correct.

To reproduce the below users will need ingress + cork and hit an
error path that will then try to 'free' the skmsg.

[  173.699981] BUG: KASAN: null-ptr-deref in sk_msg_free_elem+0xdd/0x120
[  173.699987] Read of size 8 at addr 0000000000000008 by task test_sockmap/5317

[  173.700000] CPU: 2 PID: 5317 Comm: test_sockmap Tainted: G          I       5.7.0-rc1+ #43
[  173.700005] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
[  173.700009] Call Trace:
[  173.700021]  dump_stack+0x8e/0xcb
[  173.700029]  ? sk_msg_free_elem+0xdd/0x120
[  173.700034]  ? sk_msg_free_elem+0xdd/0x120
[  173.700042]  __kasan_report+0x102/0x15f
[  173.700052]  ? sk_msg_free_elem+0xdd/0x120
[  173.700060]  kasan_report+0x32/0x50
[  173.700070]  sk_msg_free_elem+0xdd/0x120
[  173.700080]  __sk_msg_free+0x87/0x150
[  173.700094]  tcp_bpf_send_verdict+0x179/0x4f0
[  173.700109]  tcp_bpf_sendpage+0x3ce/0x5d0

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 0 files changed

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 8a709f6..ad31c9f 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -187,6 +187,7 @@ static inline void sk_msg_xfer(struct sk_msg *dst, struct sk_msg *src,
 	dst->sg.data[which] = src->sg.data[which];
 	dst->sg.data[which].length  = size;
 	dst->sg.size		   += size;
+	src->sg.size		   -= size;
 	src->sg.data[which].length -= size;
 	src->sg.data[which].offset += size;
 }
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 5a05327..26bac78 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -125,7 +125,6 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
 
 	if (!ret) {
 		msg->sg.start = i;
-		msg->sg.size -= apply_bytes;
 		sk_psock_queue_msg(psock, tmp);
 		sk_psock_data_ready(sk, psock);
 	} else {

