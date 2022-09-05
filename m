Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844095AD9AF
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbiIETeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiIETeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:34:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AB7474D2
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662406447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cb44sAlGkwW1h3uSRekzsxscfF1ULe6c2mO9L1Yigmc=;
        b=Kf4N0x371fAP6zLhSIeY0pMzzD6xA5NwT3E69P2vZvXn2a6MJNPwXSWgNCS/VASuB8OT/1
        E/Ix/S6V/5tpp46uCjSF06zvOcCZLvt4F1QCuV8F9yw41oSGU8UPn/F5BeyXgAN/+mC2UU
        6lUbP+QYzes56mrlrMHc64F7emRMTAc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-77-aULOwxi2MF64q9SUHTTk9A-1; Mon, 05 Sep 2022 15:34:06 -0400
X-MC-Unique: aULOwxi2MF64q9SUHTTk9A-1
Received: by mail-ed1-f69.google.com with SMTP id f14-20020a0564021e8e00b00448da245f25so6177046edf.18
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 12:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Cb44sAlGkwW1h3uSRekzsxscfF1ULe6c2mO9L1Yigmc=;
        b=q9rLSBMv3cLQX02VqZXZU/Tjx+Ezn4st9z+9g+LWGXXotwKsQE6hT9IM4cMYouCpoE
         lYRP1XGTzRkYQ68BmEh48IPrWVCW9ablVvJlNDKhCC1vSEgeko+ag791DhfEU63VeID1
         4E7TumdVW+tKHIElT9ksf3qoWKdd4L+pkMMx6DSy2oRGQeYCOPZA70MbpkEOlQC8pNAt
         SInp8BoJYmUiCanygjSfbYtKlQNeggeTBKv3fzXH3o7WjctxXzqPI4EpoZmmN1E6qiLS
         C/StvKd1F598+xPx2K8SDt2fCCvy6geCSCMAMAjjR/0GVhl1zu/jn9jF2GLLtpV8yy2p
         ftZA==
X-Gm-Message-State: ACgBeo3nNSGa4WLwZMAHtcvVrK6tZsN7NaGZafHfI651b1u/JiNUtVVV
        bMPoSEq1FBtolh86ZGJCXbdPaFXWlDL5FnGL1odge+KXeNAzC9PzoyXaVPTTeNBAXEQXmfxHbra
        k0Kwg7pVRR4yuxhy+
X-Received: by 2002:a17:906:fd8d:b0:73a:7424:6c0d with SMTP id xa13-20020a170906fd8d00b0073a74246c0dmr37065234ejb.425.1662406445411;
        Mon, 05 Sep 2022 12:34:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5MUI6WKKWY+6BMpWnbORp4bmqChLD76O1TGLapelQjbgsUdwUD0fBqLE5D/mc63OTPg81neA==
X-Received: by 2002:a17:906:fd8d:b0:73a:7424:6c0d with SMTP id xa13-20020a170906fd8d00b0073a74246c0dmr37065207ejb.425.1662406445037;
        Mon, 05 Sep 2022 12:34:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ku20-20020a170907789400b007306a4ecc9dsm5573715ejc.18.2022.09.05.12.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 12:34:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2E9C1589584; Mon,  5 Sep 2022 21:34:01 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 2/3] bpf: Expand map key argument of bpf_redirect_map to u64
Date:   Mon,  5 Sep 2022 21:33:58 +0200
Message-Id: <20220905193359.969347-3-toke@redhat.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220905193359.969347-1-toke@redhat.com>
References: <20220905193359.969347-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For queueing packets in XDP we want to add a new redirect map type with
support for 64-bit indexes. To prepare fore this, expand the width of the
'key' argument to the bpf_redirect_map() helper. Since BPF registers are
always 64-bit, this should be safe to do after the fact.

Reviewed-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h      |  2 +-
 include/linux/filter.h   | 12 ++++++------
 include/uapi/linux/bpf.h |  2 +-
 kernel/bpf/cpumap.c      |  4 ++--
 kernel/bpf/devmap.c      |  4 ++--
 kernel/bpf/verifier.c    |  2 +-
 net/core/filter.c        |  4 ++--
 net/xdp/xskmap.c         |  4 ++--
 8 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9c1674973e03..222cba23e6d9 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -134,7 +134,7 @@ struct bpf_map_ops {
 	struct bpf_local_storage __rcu ** (*map_owner_storage_ptr)(void *owner);
 
 	/* Misc helpers.*/
-	int (*map_redirect)(struct bpf_map *map, u32 ifindex, u64 flags);
+	int (*map_redirect)(struct bpf_map *map, u64 key, u64 flags);
 
 	/* map_meta_equal must be implemented for maps that can be
 	 * used as an inner map.  It is a runtime check to ensure
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 527ae1d64e27..eff295509f03 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -637,13 +637,13 @@ struct bpf_nh_params {
 };
 
 struct bpf_redirect_info {
-	u32 flags;
-	u32 tgt_index;
+	u64 tgt_index;
 	void *tgt_value;
 	struct bpf_map *map;
+	u32 flags;
+	u32 kern_flags;
 	u32 map_id;
 	enum bpf_map_type map_type;
-	u32 kern_flags;
 	struct bpf_nh_params nh;
 };
 
@@ -1493,7 +1493,7 @@ static inline bool bpf_sk_lookup_run_v6(struct net *net, int protocol,
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
-static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex,
+static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u64 index,
 						  u64 flags, const u64 flag_mask,
 						  void *lookup_elem(struct bpf_map *map, u32 key))
 {
@@ -1504,7 +1504,7 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 	if (unlikely(flags & ~(action_mask | flag_mask)))
 		return XDP_ABORTED;
 
-	ri->tgt_value = lookup_elem(map, ifindex);
+	ri->tgt_value = lookup_elem(map, index);
 	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
 		/* If the lookup fails we want to clear out the state in the
 		 * redirect_info struct completely, so that if an eBPF program
@@ -1516,7 +1516,7 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
 		return flags & action_mask;
 	}
 
-	ri->tgt_index = ifindex;
+	ri->tgt_index = index;
 	ri->map_id = map->id;
 	ri->map_type = map->map_type;
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 837c0f9b7fdd..c6d37ac2b87c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2629,7 +2629,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * long bpf_redirect_map(struct bpf_map *map, u32 key, u64 flags)
+ * long bpf_redirect_map(struct bpf_map *map, u64 key, u64 flags)
  * 	Description
  * 		Redirect the packet to the endpoint referenced by *map* at
  * 		index *key*. Depending on its type, this *map* can contain
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index b5ba34ddd4b6..39ed08a2bb52 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -668,9 +668,9 @@ static int cpu_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
 	return 0;
 }
 
-static int cpu_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+static int cpu_map_redirect(struct bpf_map *map, u64 index, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
+	return __bpf_xdp_redirect_map(map, index, flags, 0,
 				      __cpu_map_lookup_elem);
 }
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f9a87dcc5535..d01e4c55b376 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -992,14 +992,14 @@ static int dev_map_hash_update_elem(struct bpf_map *map, void *key, void *value,
 					 map, key, value, map_flags);
 }
 
-static int dev_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+static int dev_map_redirect(struct bpf_map *map, u64 ifindex, u64 flags)
 {
 	return __bpf_xdp_redirect_map(map, ifindex, flags,
 				      BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS,
 				      __dev_map_lookup_elem);
 }
 
-static int dev_hash_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+static int dev_hash_map_redirect(struct bpf_map *map, u64 ifindex, u64 flags)
 {
 	return __bpf_xdp_redirect_map(map, ifindex, flags,
 				      BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 068b20ed34d2..844a44694b6f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14169,7 +14169,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			BUILD_BUG_ON(!__same_type(ops->map_peek_elem,
 				     (int (*)(struct bpf_map *map, void *value))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_redirect,
-				     (int (*)(struct bpf_map *map, u32 ifindex, u64 flags))NULL));
+				     (int (*)(struct bpf_map *map, u64 index, u64 flags))NULL));
 			BUILD_BUG_ON(!__same_type(ops->map_for_each_callback,
 				     (int (*)(struct bpf_map *map,
 					      bpf_callback_t callback_fn,
diff --git a/net/core/filter.c b/net/core/filter.c
index ee768bb5b5ab..285eaee2b373 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4408,10 +4408,10 @@ static const struct bpf_func_proto bpf_xdp_redirect_proto = {
 	.arg2_type      = ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
+BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u64, key,
 	   u64, flags)
 {
-	return map->ops->map_redirect(map, ifindex, flags);
+	return map->ops->map_redirect(map, key, flags);
 }
 
 static const struct bpf_func_proto bpf_xdp_redirect_map_proto = {
diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index acc8e52a4f5f..771d0fa90ef5 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -231,9 +231,9 @@ static int xsk_map_delete_elem(struct bpf_map *map, void *key)
 	return 0;
 }
 
-static int xsk_map_redirect(struct bpf_map *map, u32 ifindex, u64 flags)
+static int xsk_map_redirect(struct bpf_map *map, u64 index, u64 flags)
 {
-	return __bpf_xdp_redirect_map(map, ifindex, flags, 0,
+	return __bpf_xdp_redirect_map(map, index, flags, 0,
 				      __xsk_map_lookup_elem);
 }
 
-- 
2.37.2

