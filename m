Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9573428569B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 04:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgJGCQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 22:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgJGCQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 22:16:24 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9830C061755;
        Tue,  6 Oct 2020 19:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=nXek4RJi9uTxF+VRaNkUsahj/OZ3iK3n3IUnrhElzu4=; b=TqlIn+3B+GF53KTsWyNoJGvuRL
        IQFzLbK1UX+/QX6DweTdDzp5DWs4OEty0JjroINPYUMhLdj/8qfv6eMd2iCWiYjOOXe8oqkUDJ7pL
        g/y+HzOGh5Mw9d6wa5n+zrJ4PGzLthMFMQl77PUyDonXAvF2LHx74Zq0RZYWl0Y09nO3Bi7jiAhzJ
        p7f3eDDnVYfrGEVJv81dYnQfPpVRlmhaN/1yq6859Fc+dvWrRV92VAA2YK7eU/+yGBLFnT71bVE15
        HF6P8xhYxHQli01y+tCerel5LVePAhq+LqLsjHO0i/TSfidTsv9wmz5Z02l9eCvdvtQFPhs3JtWWi
        L/pziVqA==;
Received: from [2601:1c0:6280:3f0::2c9a] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPz08-0004Rz-1w; Wed, 07 Oct 2020 02:16:20 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        linux-next@vger.kernel.org
Subject: [PATCH bpf-next] kernel/bpf/verifier: fix build when NET is not enabled
Date:   Tue,  6 Oct 2020 19:16:13 -0700
Message-Id: <20201007021613.13646-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build errors in kernel/bpf/verifier.c when CONFIG_NET is
not enabled.

../kernel/bpf/verifier.c:3995:13: error: ‘btf_sock_ids’ undeclared here (not in a function); did you mean ‘bpf_sock_ops’?
  .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],

../kernel/bpf/verifier.c:3995:26: error: ‘BTF_SOCK_TYPE_SOCK_COMMON’ undeclared here (not in a function); did you mean ‘PTR_TO_SOCK_COMMON’?
  .btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],

Fixes: 1df8f55a37bd ("bpf: Enable bpf_skc_to_* sock casting helper to networking prog type")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: linux-next@vger.kernel.org
---
First reported by me in linux-next-20200928.

 kernel/bpf/verifier.c |    4 ++++
 1 file changed, 4 insertions(+)

--- mmotm-2020-1006-1550.orig/kernel/bpf/verifier.c
+++ mmotm-2020-1006-1550/kernel/bpf/verifier.c
@@ -3984,6 +3984,7 @@ static const struct bpf_reg_types sock_t
 	},
 };
 
+#ifdef CONFIG_NET
 static const struct bpf_reg_types btf_id_sock_common_types = {
 	.types = {
 		PTR_TO_SOCK_COMMON,
@@ -3994,6 +3995,7 @@ static const struct bpf_reg_types btf_id
 	},
 	.btf_id = &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 };
+#endif
 
 static const struct bpf_reg_types mem_types = {
 	.types = {
@@ -4037,7 +4039,9 @@ static const struct bpf_reg_types *compa
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_CTX_OR_NULL]	= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
+#ifdef CONFIG_NET
 	[ARG_PTR_TO_BTF_ID_SOCK_COMMON]	= &btf_id_sock_common_types,
+#endif
 	[ARG_PTR_TO_SOCKET]		= &fullsock_types,
 	[ARG_PTR_TO_SOCKET_OR_NULL]	= &fullsock_types,
 	[ARG_PTR_TO_BTF_ID]		= &btf_ptr_types,
