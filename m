Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0734A146D86
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgAWP4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:56:02 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40058 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgAWPzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:55:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so3637613wrn.7
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 07:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JLv/e4bALSFRO4Odq3IND/raBr+TbMVPO/ljGM7kDSM=;
        b=FJIxxBQeFlxLjndHJdqOQGpOzNE8O94+CfJwZoE+Zb3qHSZ0P0tmVqndNfHEcs//7V
         OugimUNmDOBFCmKiqY8sDlizFQm7W+4+cdgzszbeXFqJJpUNVvqkt5Je8WVQ7cqwvvk9
         HMjxkJWKxDOhNlZCzNUukWqWxAP7NtfUw83lI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JLv/e4bALSFRO4Odq3IND/raBr+TbMVPO/ljGM7kDSM=;
        b=h2yjrMs97PbZp4huDnMxfJy5U/FOmfnyafYC5u4BeayYtD0d7QIok7g3+K4ot3Y59S
         kbPfHS9Z2yMLv+2vWzIBPmg4r7H2AQJ3Y9HsivaAtXr6YN2NQzXNC89hwnkVuEeDEtZm
         AjoxXkC6IGch+lKyZ+Tis81mrhleSDOWlGCDEQMPZrMkap9W3vyw2TIDsrxZT+Zzbhpb
         G7Ry5ZyPO5jPEvLA43ghDuSgJuevBRk747Xos2H1rtNDy1+8WT4jtxx683ss3FnWy6CU
         xdjEAwlTxFVy3JrIssXOc0jkeW+A3Anp4JVpNAoj06Okx7HnvDKSpKRpIx6JMjl6x+gs
         vKww==
X-Gm-Message-State: APjAAAW1zMAJSw23mvp2Fvg1p0KrktH4OIzgrRrNw8wBEYbNDlTR8yax
        1pJ0kretLr9Hg9QQF77S2BxTCA==
X-Google-Smtp-Source: APXvYqyIkUkRINJ6QcWysHrqkt5sG/ipDBIZcaUA3Fhlwhc5U9dIACFLO9+6bRd1blfbJ5iEvcRxBQ==
X-Received: by 2002:a5d:5273:: with SMTP id l19mr19321107wrc.175.1579794946327;
        Thu, 23 Jan 2020 07:55:46 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id z8sm3478146wrq.22.2020.01.23.07.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 07:55:45 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 08/12] bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
Date:   Thu, 23 Jan 2020 16:55:30 +0100
Message-Id: <20200123155534.114313-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123155534.114313-1-jakub@cloudflare.com>
References: <20200123155534.114313-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't require the kernel code, like BPF helpers, that needs access to
SOCKMAP map contents to live in net/core/sock_map.c. Expose the SOCKMAP
lookup operation to all kernel-land.

Lookup from BPF context is not whitelisted yet. While syscalls have a
dedicated lookup handler.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 441f213bd4c5..7b17b258a3d7 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -297,7 +297,7 @@ static struct sock *__sock_map_lookup_elem(struct bpf_map *map, u32 key)
 
 static void *sock_map_lookup(struct bpf_map *map, void *key)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return __sock_map_lookup_elem(map, *(u32 *)key);
 }
 
 static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
@@ -964,6 +964,11 @@ static void sock_hash_free(struct bpf_map *map)
 	kfree(htab);
 }
 
+static void *sock_hash_lookup(struct bpf_map *map, void *key)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static void sock_hash_release_progs(struct bpf_map *map)
 {
 	psock_progs_drop(&container_of(map, struct bpf_htab, map)->progs);
@@ -1043,7 +1048,7 @@ const struct bpf_map_ops sock_hash_ops = {
 	.map_get_next_key	= sock_hash_get_next_key,
 	.map_update_elem	= sock_hash_update_elem,
 	.map_delete_elem	= sock_hash_delete_elem,
-	.map_lookup_elem	= sock_map_lookup,
+	.map_lookup_elem	= sock_hash_lookup,
 	.map_release_uref	= sock_hash_release_progs,
 	.map_check_btf		= map_check_no_btf,
 };
-- 
2.24.1

