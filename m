Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F34C16232F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgBRJQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:16:23 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37599 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgBRJQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:16:23 -0500
Received: by mail-pj1-f66.google.com with SMTP id m13so727674pjb.2;
        Tue, 18 Feb 2020 01:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yp/ab5kZWg45A94tMz1UqFxP2h1Y+iYso3CF9v+W1UM=;
        b=sB6oVFJ+yCJjoWFon2cCJHM9tZxESL3ds6fDaMbeBThoBlrTTQEi6bf5+avbtGVSUc
         PvKv89wwwxbcckaO5V5OyZ5ezUG4DJF4qtDLjrIAoWzXMD1xAU1/uKF8rohCel2NJwzy
         cHjtJL3coTN4Nbcds6uQgHSO9p1KWZknSjrvFdn0ZeVonX0AQtVEX6btwmVVsXVmXvQM
         f65PEDFf+WQQKokaoXmZJfXszWZK9Oa+UtuDHr42ZNDdzTq2stpJV7BvZbx359GUAWZt
         BjeXq1WF3vfmkqw91fJQqh77JllzNin1S6Q6IZMaVraiWijOGmQQj2eKzv5We9t4pcZ6
         CKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yp/ab5kZWg45A94tMz1UqFxP2h1Y+iYso3CF9v+W1UM=;
        b=mGCSyB8He4RwOEUl77JNBqoMpXd3QOaIK26ko/CTdmv9DpCND2VY9j6///5h9Gg0tb
         Gs3OMoUhOkIYiXn0VGxWN/YocyxzA/huFjS0q05kdF73p7mJKIQAARbEASvcZeMioTM2
         WW54J0x3ECrDp21tbUCHazsIWVPKZjFNNMn0grVGMe+HMbo8MAR2G2E6l3WQlyGFgNSN
         Vk7AKExY4stTNtOjDq8lXkitiZVz+sesQA3zz3tTac9phVZdWPfQOoDI1Qe6XU2uyP3t
         B1bOz62R/e3c5wLIgdIyEgFogLLpk2E8YlOut0DzRvmdejXyfue+he8QK6dPaO1Yk5wO
         k7Lg==
X-Gm-Message-State: APjAAAWGzKamy4Qfrn5sMt6j/kxx8yiPb06N/PG3Zbu/i9XaIAlVamvA
        nsdkQWUAExBthlfCl2ZM0TKNcQXbXlTfFg==
X-Google-Smtp-Source: APXvYqwawTCGVxgpAJWwWn22jFMnPo16SN4BT/lZaqEXlliiiDDQRx1bajM2Nwoqu/JFliBagoYzUA==
X-Received: by 2002:a17:902:b116:: with SMTP id q22mr20480121plr.324.1582017382466;
        Tue, 18 Feb 2020 01:16:22 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id h191sm1992110pge.85.2020.02.18.01.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 01:16:21 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v2 bpf-next 1/3] bpf: Add sock ops get netns helpers
Date:   Tue, 18 Feb 2020 09:15:39 +0000
Message-Id: <20200218091541.107371-2-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218091541.107371-1-forrest0579@gmail.com>
References: <20200206083515.10334-1-forrest0579@gmail.com>
 <20200218091541.107371-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
uniq connection because there may be multi net namespace.
For example, there may be a chance that netns a and netns b all
listen on 127.0.0.1:8080 and the client with same port 40782
connect to them. Without netns number, sock ops program
can't distinguish them.
Using bpf_sock_ops_get_netns helpers to get current connection
netns number to distinguish connections.

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
---
 include/uapi/linux/bpf.h |  8 +++++++-
 net/core/filter.c        | 19 +++++++++++++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index f1d74a2bd234..3573907d15e0 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2892,6 +2892,11 @@ union bpf_attr {
  *		Obtain the 64bit jiffies
  *	Return
  *		The 64 bit jiffies
+ * u64 bpf_sock_ops_get_netns(struct bpf_sock_ops *bpf_socket)
+ *  Description
+ *      Obtain netns id of sock
+ * Return
+ *      The current netns inum
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3012,7 +3017,8 @@ union bpf_attr {
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
-	FN(jiffies64),
+	FN(jiffies64),			\
+	FN(sock_ops_get_netns),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index c180871e606d..f8e946aa46fc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4421,6 +4421,23 @@ static const struct bpf_func_proto bpf_sock_ops_cb_flags_set_proto = {
 	.arg2_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_1(bpf_sock_ops_get_netns, struct bpf_sock_ops_kern *, bpf_sock)
+{
+#ifdef CONFIG_NET_NS
+	struct sock *sk = bpf_sock->sk;
+
+	return (u64)sk->sk_net.net->ns.inum;
+#endif
+	return 0;
+}
+
+static const struct bpf_func_proto bpf_sock_ops_get_netns_proto = {
+	.func		= bpf_sock_ops_get_netns,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+};
+
 const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
 EXPORT_SYMBOL_GPL(ipv6_bpf_stub);
 
@@ -6218,6 +6235,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;
 #endif /* CONFIG_INET */
+	case BPF_FUNC_sock_ops_get_netns:
+		return &bpf_sock_ops_get_netns_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
-- 
2.20.1

