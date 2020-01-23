Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBB8146D83
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAWP4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:56:00 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32890 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgAWPzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:55:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id b6so3696539wrq.0
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 07:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y/5BZmJT8mKE56SUZiH7P/ZiqsELI/+2GypFXWy++to=;
        b=RZMIaeB2M1SJX/6LvC2tRbAVNav9fqo2SyfdxvFduZ5iVH7DzbuQ/orwRW0nAvVZ/8
         hMuwGubx0P8JcayS7yZWOuPb8yH+zkhJ1UtnlKDC6kdzL9A2xsyM+sSiIhNofy+N5Uyl
         68hf9kBGjdqpAt7aug2rVpY5SR4X7WMM6LgsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y/5BZmJT8mKE56SUZiH7P/ZiqsELI/+2GypFXWy++to=;
        b=IY1F/LJQwYa5HIdbFdbVNedkq/WdzvmjX20oJwlo0UBHV3pdx2yWFlIQkPFtzMB/Zp
         HOa0kK8dw37XYRCrB6uEkwlMDSUBNMFumS8fMXcXHSTB+Ej5VIBhhwTEUP/E79tHY+XJ
         16rqqZWFVgwv3AQRFI3Lrlstblbuw/ic7PFCBpMHojoUR0HfNsR8DVCCzF5vODNoHynf
         a92ddlc2bBVzqafWCSnS4wVFKZNh348F7L3tpqBV9hbAQvRDENeGdAsfdPJjdKajLGOT
         H61UprBnVMLmv8c1u4k6R7Rhohl6XL1Rn4z3J5zzuXejHnIPp5hPboI7hLfZFz+dAK5Q
         hXhQ==
X-Gm-Message-State: APjAAAUgRQ3UT1WpP7xJlBna5eZLf48xOKpbOd7rhvoP2yQolRtB7IBc
        hfU3VsRlyps1IPHBawW78kaPkQ==
X-Google-Smtp-Source: APXvYqxEVdD+jHvsVaj1J1YYOuGhbqiR8+bMcDvZzYBxdYVDD68tdJPUb7LF/oIK4kv96gfnD1LVNQ==
X-Received: by 2002:a5d:42c5:: with SMTP id t5mr19145427wrr.73.1579794947668;
        Thu, 23 Jan 2020 07:55:47 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id h2sm3579560wrv.66.2020.01.23.07.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 07:55:47 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 09/12] bpf: Allow selecting reuseport socket from a SOCKMAP
Date:   Thu, 23 Jan 2020 16:55:31 +0100
Message-Id: <20200123155534.114313-10-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123155534.114313-1-jakub@cloudflare.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCKMAP now supports storing references to listening sockets. Nothing keeps
us from using it as an array of sockets to select from in BPF reuseport
programs. Whitelist the map type with the bpf_sk_select_reuseport helper.

The restriction that the socket has to be a member of a reuseport group
still applies. Socket from a SOCKMAP that does not have sk_reuseport_cb set
is not a valid target and we signal it with -EINVAL.

This lifts the restriction that SOCKARRAY imposes, if SOCKMAP is used with
reuseport BPF, the listening sockets can exist in more than one BPF map at
the same time.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 kernel/bpf/verifier.c |  6 ++++--
 net/core/filter.c     | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 734abaa02123..45b48f8e8b40 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3693,7 +3693,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (func_id != BPF_FUNC_sk_redirect_map &&
 		    func_id != BPF_FUNC_sock_map_update &&
 		    func_id != BPF_FUNC_map_delete_elem &&
-		    func_id != BPF_FUNC_msg_redirect_map)
+		    func_id != BPF_FUNC_msg_redirect_map &&
+		    func_id != BPF_FUNC_sk_select_reuseport)
 			goto error;
 		break;
 	case BPF_MAP_TYPE_SOCKHASH:
@@ -3774,7 +3775,8 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 			goto error;
 		break;
 	case BPF_FUNC_sk_select_reuseport:
-		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY)
+		if (map->map_type != BPF_MAP_TYPE_REUSEPORT_SOCKARRAY &&
+		    map->map_type != BPF_MAP_TYPE_SOCKMAP)
 			goto error;
 		break;
 	case BPF_FUNC_map_peek_elem:
diff --git a/net/core/filter.c b/net/core/filter.c
index 4bf3e4aa8a7a..261d33560b14 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8627,6 +8627,7 @@ struct sock *bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	   struct bpf_map *, map, void *, key, u32, flags)
 {
+	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
 	struct sock_reuseport *reuse;
 	struct sock *selected_sk;
 
@@ -8635,12 +8636,16 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 		return -ENOENT;
 
 	reuse = rcu_dereference(selected_sk->sk_reuseport_cb);
-	if (!reuse)
-		/* selected_sk is unhashed (e.g. by close()) after the
-		 * above map_lookup_elem().  Treat selected_sk has already
-		 * been removed from the map.
+	if (!reuse) {
+		/* reuseport_array has only sk with non NULL sk_reuseport_cb.
+		 * The only (!reuse) case here is - the sk has already been
+		 * unhashed (e.g. by close()), so treat it as -ENOENT.
+		 *
+		 * Other maps (e.g. sock_map) do not provide this guarantee and
+		 * the sk may never be in the reuseport group to begin with.
 		 */
-		return -ENOENT;
+		return is_sockarray ? -ENOENT : -EINVAL;
+	}
 
 	if (unlikely(reuse->reuseport_id != reuse_kern->reuseport_id)) {
 		struct sock *sk;
-- 
2.24.1

