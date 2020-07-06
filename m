Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BEF2161CA
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgGFXBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgGFXBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:01:37 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF0EC08C5DF
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 16:01:36 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id z26so10939121qto.15
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 16:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4MFbPpxWqiWyQiCt/Y8/V+3EAFWxMVX6naLO9kXQaiI=;
        b=Eq9NO4LyHzXl17RJbq3NY1XVlrLBiLBZOAKnJw6WmZp9W2ylG+snyE0izLxMppHOAB
         qHMBf1AKbai+aIV4405PHilpczpmnm5mj473g+qnve1KwJSriQ1rkeIviaExSO1eVByi
         0upqdV1Q/FGBWnyVtQdY5nXRA+C7Eh0ZJEvrtghcQxoDoEk98QAx44GekZ7qAXmn8VMU
         ISTsZ6j6RxCJHvuukvecyhFC6cJg2roN62dtQX64x/NBynwHV4aHAdiGfd7MpWz2COjf
         pXLTca7ISKwpLCPQQSIJPnU0qBg+x3jWjTU75J9xGrflWIsVz3wVb2LVj2+7UhTVSTpd
         II2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4MFbPpxWqiWyQiCt/Y8/V+3EAFWxMVX6naLO9kXQaiI=;
        b=GDNvXaO5jiPdgBX5mhpsvnwyOLg3hlAyni82U5IEPsJG1Oednqat5vakxySwXdg/Aa
         WObHw3UsHadUv5luhNGnpzsYjb+ejqjfq8xxUCevhkEagq9oTrCo16+y2GFBTnhZauL4
         HYJNT/DhPtgbuvPjEaWNOVGmVOAjxNS1dhL7mEzuKZXfyQqL0eH1t6RnEOFaxXkwtaC0
         CusccO0oy03m3AqcCnF75wsoLk+T9laQXOt2em2r9nZDHIX6gv+DG+IjY5ZCAyvBSiGi
         cno3RaAl0NaJyFJQ+5bnAhS5Rn55PWuRWiQ4PcnQlLoOAjrYySBVQC0ceHHy/frHXKD0
         wViA==
X-Gm-Message-State: AOAM530tZI3uZPtb7y+1Tgtx7Eb4D4Oqb7J+jKKdkgPOp+9+o0QTN/+f
        acwjUs0FR8S9/exIfdK8gGvN/NJ+dYIcCFTZ0eXZ8suONDnpAkGebOJI8t5VFkC+L7+/tlDMDha
        IfR+COt+Nrmi8AicduInFY4ebyy/2VwrcPGi9hBDmE02aFPoVe9/7MQ==
X-Google-Smtp-Source: ABdhPJyPmSwRU4P3JJ//cB5ksinMQOKBAYC+Opzi5hOvf9AgYRcNxPR3KMIsGd0I+Fkm3ujJi309ap0=
X-Received: by 2002:ad4:4a64:: with SMTP id cn4mr48875063qvb.199.1594076495935;
 Mon, 06 Jul 2020 16:01:35 -0700 (PDT)
Date:   Mon,  6 Jul 2020 16:01:27 -0700
In-Reply-To: <20200706230128.4073544-1-sdf@google.com>
Message-Id: <20200706230128.4073544-4-sdf@google.com>
Mime-Version: 1.0
References: <20200706230128.4073544-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v4 3/4] bpftool: add support for BPF_CGROUP_INET_SOCK_RELEASE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support attaching to BPF_CGROUP_INET_SOCK_RELEASE and properly
display attach type upon prog dump.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 18e5604fe260..29f4e7611ae8 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -33,6 +33,7 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_CGROUP_INET_INGRESS]	= "ingress",
 	[BPF_CGROUP_INET_EGRESS]	= "egress",
 	[BPF_CGROUP_INET_SOCK_CREATE]	= "sock_create",
+	[BPF_CGROUP_INET_SOCK_RELEASE]	= "sock_release",
 	[BPF_CGROUP_SOCK_OPS]		= "sock_ops",
 	[BPF_CGROUP_DEVICE]		= "device",
 	[BPF_CGROUP_INET4_BIND]		= "bind4",
-- 
2.27.0.212.ge8ba1cc988-goog

