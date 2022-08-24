Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCAA59FBA3
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbiHXNmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiHXNlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:41:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69A580F45
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfbbgckAA8b8IGBbIFhs4TFoQczUT6RAdpeMjlYjV4U=;
        b=hc3xaT43QbSr0oU2psZ7c8gAjwxILaITommXgHg+CowWPsRsrKyLC3Uf8XRoiXFJCOYQ+Q
        0jMxoqdeeMql2xToh50hmly9Qv/DE1GDoiTwnx0HI01wM9jdc+DyMFLBOt/s+XPokVcGr0
        R9UBYiS3SlRgVOqczexHLym1W/Sprg0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-1L-DFxkQNKmLF9f2NgWsDQ-1; Wed, 24 Aug 2022 09:41:28 -0400
X-MC-Unique: 1L-DFxkQNKmLF9f2NgWsDQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72CC785A58A;
        Wed, 24 Aug 2022 13:41:26 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 464B518ECC;
        Wed, 24 Aug 2022 13:41:23 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v9 07/23] libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
Date:   Wed, 24 Aug 2022 15:40:37 +0200
Message-Id: <20220824134055.1328882-8-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows to have a better control over maps from the kernel when
preloading eBPF programs.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v9

no changes in v8

no changes in v7

no changes in v6

new in v5
---
 tools/lib/bpf/skel_internal.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index 00c5f94b43be..1e82ab06c3eb 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -251,6 +251,29 @@ static inline int skel_map_update_elem(int fd, const void *key,
 	return skel_sys_bpf(BPF_MAP_UPDATE_ELEM, &attr, attr_sz);
 }
 
+static inline int skel_map_delete_elem(int fd, const void *key)
+{
+	const size_t attr_sz = offsetofend(union bpf_attr, flags);
+	union bpf_attr attr;
+
+	memset(&attr, 0, attr_sz);
+	attr.map_fd = fd;
+	attr.key = (long)key;
+
+	return skel_sys_bpf(BPF_MAP_DELETE_ELEM, &attr, attr_sz);
+}
+
+static inline int skel_map_get_fd_by_id(__u32 id)
+{
+	const size_t attr_sz = offsetofend(union bpf_attr, flags);
+	union bpf_attr attr;
+
+	memset(&attr, 0, attr_sz);
+	attr.map_id = id;
+
+	return skel_sys_bpf(BPF_MAP_GET_FD_BY_ID, &attr, attr_sz);
+}
+
 static inline int skel_raw_tracepoint_open(const char *name, int prog_fd)
 {
 	const size_t attr_sz = offsetofend(union bpf_attr, raw_tracepoint.prog_fd);
-- 
2.36.1

