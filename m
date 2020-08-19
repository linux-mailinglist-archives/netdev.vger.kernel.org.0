Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8DF249973
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgHSJiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbgHSJhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:37:55 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0777C06134B
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:51 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g8so1403158wmk.3
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5kro16pmJ95iM/u9rOMoUVfxNBy72CdD/uqKbTNgUOo=;
        b=EqDQKOzOCBOt39rsYZLeQz04NqKOPVw3IJCRpDYkOHzJIFsi0Mvn/Z/Tf5HDiRArdc
         rpm9TbA1aGG+iChFutrOuLrkfuaGlguDEsGu58cMjk42Y7zu0c5Y3ykOwOu8S4/8sllW
         GErA935YNJs+JFIu542hS5oSXbhcUNs1E/8zQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5kro16pmJ95iM/u9rOMoUVfxNBy72CdD/uqKbTNgUOo=;
        b=B91aIt+0D7fzUNnDJECgCpXb/TsagGLFEMLrkEMSZG8FXHy98dMmp35azpReXmc9UW
         SyL4FdH8jCsXhUz9pQ7kgWcAf1gAhxbVaomVjWJsMKXM94HrcUERYofiyrPkcaL7XuWX
         fAHKMudo2cmQW4QGJl6Nnsvil8YRTD8C2m5aL/1veTxeOyRAEmsLhccmWDMOUZq6g6G5
         I+Xgyn/qWfl/QbSW7m74xbCUoYWp1puAzzIL6xgMpZScAXclw0U76f3sJUOFGHmdPnGm
         GFOMlPYrmi6pc4mOJwwVSFS9BU4CiFJFW2o4LQVR1fvCeaUcdvG9nGx/yKCTnZLzB1yB
         QYzA==
X-Gm-Message-State: AOAM5335JO0NjGt/fUUXWwh7FrMO2hHeROU5F48neWjLIkXpuaaVNNmg
        /Rs5XQx3iPvAJ2b902FjV6fuMg==
X-Google-Smtp-Source: ABdhPJyFZQOMNl3FbJ8gIJxc6cc1wD74uK1824MgJXDkM5LPxqm7GuxvxcjADiCDF5pk8Th2+EU2IA==
X-Received: by 2002:a1c:6689:: with SMTP id a131mr3892270wmc.157.1597829870465;
        Wed, 19 Aug 2020 02:37:50 -0700 (PDT)
Received: from antares.lan (c.d.0.4.4.2.3.3.e.9.1.6.6.d.0.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:60d6:619e:3324:40dc])
        by smtp.gmail.com with ESMTPSA id 3sm4204565wms.36.2020.08.19.02.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 02:37:49 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 4/6] bpf: override the meaning of ARG_PTR_TO_MAP_VALUE for sockmap and sockhash
Date:   Wed, 19 Aug 2020 10:24:34 +0100
Message-Id: <20200819092436.58232-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819092436.58232-1-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The verifier assumes that map values are simple blobs of memory, and
therefore treats ARG_PTR_TO_MAP_VALUE, etc. as such. However, there are
map types where this isn't true. For example, sockmap and sockhash store
sockets. In general this isn't a big problem: we can just
write helpers that explicitly requests PTR_TO_SOCKET instead of
ARG_PTR_TO_MAP_VALUE.

The one exception are the standard map helpers like map_update_elem,
map_lookup_elem, etc. Here it would be nice we could overload the
function prototype for different kinds of maps. Unfortunately, this
isn't entirely straight forward:
We only know the type of the map once we have resolved meta->map_ptr
in check_func_arg. This means we can't swap out the prototype
in check_helper_call until we're half way through the function.

Instead, modify check_func_arg to treat ARG_PTR_TO_MAP_VALUE* to
mean "the native type for the map" instead of "pointer to memory"
for sockmap and sockhash. This means we don't have to modify the
function prototype at all

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 kernel/bpf/verifier.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b6ccfce3bf4c..47f9b94bb9d4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3872,6 +3872,38 @@ static int int_ptr_type_to_size(enum bpf_arg_type type)
 	return -EINVAL;
 }
 
+static int override_map_arg_type(struct bpf_verifier_env *env,
+				 const struct bpf_call_arg_meta *meta,
+				 enum bpf_arg_type *arg_type)
+{
+	if (!meta->map_ptr) {
+		/* kernel subsystem misconfigured verifier */
+		verbose(env, "invalid map_ptr to access map->type\n");
+		return -EACCES;
+	}
+
+	switch (meta->map_ptr->map_type) {
+	case BPF_MAP_TYPE_SOCKMAP:
+	case BPF_MAP_TYPE_SOCKHASH:
+		switch (*arg_type) {
+		case ARG_PTR_TO_MAP_VALUE:
+			*arg_type = ARG_PTR_TO_SOCKET;
+			break;
+		case ARG_PTR_TO_MAP_VALUE_OR_NULL:
+			*arg_type = ARG_PTR_TO_SOCKET_OR_NULL;
+			break;
+		default:
+			verbose(env, "invalid arg_type for sockmap/sockhash\n");
+			return -EINVAL;
+		}
+		break;
+
+	default:
+		break;
+	}
+	return 0;
+}
+
 static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 			  struct bpf_call_arg_meta *meta,
 			  const struct bpf_func_proto *fn)
@@ -3904,6 +3936,14 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 		return -EACCES;
 	}
 
+	if (arg_type == ARG_PTR_TO_MAP_VALUE ||
+	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
+	    arg_type == ARG_PTR_TO_MAP_VALUE_OR_NULL) {
+		err = override_map_arg_type(env, meta, &arg_type);
+		if (err)
+			return err;
+	}
+
 	if (arg_type == ARG_PTR_TO_MAP_KEY ||
 	    arg_type == ARG_PTR_TO_MAP_VALUE ||
 	    arg_type == ARG_PTR_TO_UNINIT_MAP_VALUE ||
-- 
2.25.1

