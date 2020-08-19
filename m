Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0E924A9A5
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgHSWmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgHSWkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:40:39 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057FFC061387
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id b18so19396pge.8
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=4lUOSfg5crC/CXFRp8F/K1Jb1PQLzPLA9O5+4H789wU=;
        b=vqBrpVaLG5hgyuLORPxN8M2fiZFQB9dD18R/Ooo0adUnZ41ijb7pOrysJRfD0R3QWh
         Ad1zPUlUDRdgRHl6q1yvEdA+t0YasDSvU5kcljOIAHzujqBZo1fV5ygeNVw0jYT0poGC
         bWQahRedPnzPBQkh0DEDaII0mgLKbi4mi+sMdw8Za+uAtyt4OPAhkWNN1Mtu4TZgFAU4
         6C74G1IiRmIW8+IF4ZDmaSUcoh4dyqUx7pc2wnJeY0+MV50EipBwVjS36jTc6VQflbvT
         5LnFtOofo9HL8sPEOxaDyAC5Ia/2Hzl6Bvm7qCu4zPqc0pfm+ZZI2hu0FhiRVl6ZuIzW
         Cb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4lUOSfg5crC/CXFRp8F/K1Jb1PQLzPLA9O5+4H789wU=;
        b=soKp0iIFHlBbSAWqH+9/5xrQPgqVbh75U3k1lOIg74jiriK2tPpbRUVz/YV3gvDWtV
         CRPZnbghXKGEQpUtvPdeV0c/A2cr3yGnRLqgsHBVuIei/DgFRYRpvK3C/e3LXMBoDUW8
         Lith4J6NoQIAFLTzsxesh4yzf3fLy/6xPSH12OltDrK/b6qGTgKBFF4bUz8uRrIsTbUE
         rVMMz8AzNDhisPkCtvP0Pp7QBDOPXUSKtOC29/ks89JpMeURZ/gcY1RiXh1qjZRQbUwJ
         9NukY2s4DwkjPDKLT1UNJ7NApjfS40AQYakvBBKe6gDF/rKRKuXKgYXRGgx8TQfqHvQq
         UTig==
X-Gm-Message-State: AOAM530bB/N8WqX8pi9RTCbdCxPrps88UWq4C7in/AkiiDYtIw2ji8Cv
        yic+NjVVSX1gCoBfuF7s06j20DvbMOUxg5ZN+5HLelamTQsTD8XDHp4V3Mi6762+pa8VR4kqELC
        qatKE2uqAB1vWCzEe+ysVo7tiqM1VQJr06dUID/wljHGUpxs/qlgczVUigD1vHQ==
X-Google-Smtp-Source: ABdhPJw60HhYSD5xD+NKMghulZyrwy7CSfEqKWANtTW3eDGeqH3EPOr0UctlJdOGdV4ZXKaGvMSwbdfQlz4=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:aa7:8ec4:: with SMTP id b4mr34434pfr.227.1597876838302;
 Wed, 19 Aug 2020 15:40:38 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:40:24 -0700
In-Reply-To: <20200819224030.1615203-1-haoluo@google.com>
Message-Id: <20200819224030.1615203-3-haoluo@google.com>
Mime-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH bpf-next v1 2/8] bpf: Propagate BPF_PSEUDO_BTF_ID to uapi
 headers in /tools
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Propagate BPF_PSEUDO_BTF_ID from include/linux/uapi/bpf.h to
tools/include/linux/uapi/bpf.h.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 tools/include/uapi/linux/bpf.h | 38 ++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 0480f893facd..468376f2910b 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -346,18 +346,38 @@ enum bpf_link_type {
 #define BPF_F_TEST_STATE_FREQ	(1U << 3)
 
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
- * two extensions:
- *
- * insn[0].src_reg:  BPF_PSEUDO_MAP_FD   BPF_PSEUDO_MAP_VALUE
- * insn[0].imm:      map fd              map fd
- * insn[1].imm:      0                   offset into value
- * insn[0].off:      0                   0
- * insn[1].off:      0                   0
- * ldimm64 rewrite:  address of map      address of map[0]+offset
- * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
+ * the following extensions:
+ *
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
+ * insn[0].imm:      map fd
+ * insn[1].imm:      0
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map
+ * verifier type:    CONST_PTR_TO_MAP
  */
 #define BPF_PSEUDO_MAP_FD	1
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
+ * insn[0].imm:      map fd
+ * insn[1].imm:      offset into value
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map[0]+offset
+ * verifier type:    PTR_TO_MAP_VALUE
+ */
 #define BPF_PSEUDO_MAP_VALUE	2
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_BTF_ID
+ * insn[0].imm:      kernel btd id of VAR
+ * insn[1].imm:      0
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of the kernel variable
+ * verifier type:    PTR_TO_BTF_ID or PTR_TO_MEM, depending on whether the var
+ *                   is struct/union.
+ */
+#define BPF_PSEUDO_BTF_ID	3
 
 /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
  * offset to another bpf function
-- 
2.28.0.220.ged08abb693-goog

