Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C40146ECD
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbgAWQ7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 11:59:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37568 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbgAWQ7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:59:42 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so3927726wru.4
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 08:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tk5yxpI11cI9KBhNdKfyqvJ4tETGqhiDxT73Ojpv4Ao=;
        b=gM+SBtUrqHYCH5UsDYhylmm+WVyKg25od/ZJr/Tksv9L6gkmX94U9E8tUlYYBjjfMR
         AOzRDXQZ288R/2qbHzzJByeeoPGUU/F+HR//ucS0HPGOvWPb35bSYXySSWmxxr47ydgA
         wBmpMZ8LrzIp9ZNrTffHaQwRhvYWwB1C3RFFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tk5yxpI11cI9KBhNdKfyqvJ4tETGqhiDxT73Ojpv4Ao=;
        b=Qn+lb5xEVGb/g1dyBD7wJBw5ZrUfWbd+eAvUV1/FwCA/6X6x98GEPqnKiHOcxx9aAa
         C4D6UALSv3qicZp2uI4JSk+LAVa+VmNeTYS/UCI6VG0F7tGQBVgF1+IfutOaoIzSkxUy
         Xgnn1Dskw2dJKeb8GddB8OI7Q01VFddPjST64QrtVGerL+hmKPgZOIvF/+WacopJgO8J
         JNItemDnnOzrWhGGTYE7EsWzIIkvvadbfbuhpm0IzG6zbp1ReUkMgK8aHImPyFuM8YQy
         Z+jSxBcPUbDHs0TtPA/yJhy9MU3ARnhogi6m3NFIhOLc+8qANTz8vnKovodJIq6zVdqQ
         J8fA==
X-Gm-Message-State: APjAAAVbm6uRYLcOxacko7E7EoJfJCWmv/4bj5mUwFXQKTtEbJ+1taew
        wqxaIMFfj4p3wpoPpHXZKs4LSQ==
X-Google-Smtp-Source: APXvYqz2lADwPXyrinmzdCei9lekeb2aETAUdPvvyLc9MoAepDbesXeR9FKf5Pmtz5ITIzzfSnMLRw==
X-Received: by 2002:adf:dd51:: with SMTP id u17mr17957228wrm.290.1579798779869;
        Thu, 23 Jan 2020 08:59:39 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:d0a9:6cca:1210:a574])
        by smtp.gmail.com with ESMTPSA id u1sm3217698wmc.5.2020.01.23.08.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 08:59:38 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf 0/4] Various fixes for sockmap and reuseport tests
Date:   Thu, 23 Jan 2020 16:59:29 +0000
Message-Id: <20200123165934.9584-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I noticed some rough edges while running the sockmap and reuseport tests in
a virtme environment. It only has a single CPU, and the root filesystem is
mounted read-only.

The cause for patch #2 is either the VM being slow because it only has a
single CPU. Patches #3-4 helped me narrow down the problem, so they are
probably useful for others as well.

Lorenz Bauer (4):
  selftests: bpf: use a temporary file in test_sockmap
  selftests: bpf: ignore RST packets for reuseport tests
  selftests: bpf: make reuseport test output more legible
  selftests: bpf: reset global state between reuseport test runs

 .../bpf/prog_tests/select_reuseport.c         | 44 ++++++++++++++++---
 .../bpf/progs/test_select_reuseport_kern.c    |  6 +++
 tools/testing/selftests/bpf/test_sockmap.c    | 15 +++----
 3 files changed, 50 insertions(+), 15 deletions(-)

-- 
2.20.1

