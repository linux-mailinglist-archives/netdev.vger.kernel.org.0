Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27533211418
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 22:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgGAUNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 16:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727047AbgGAUNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 16:13:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC496C08C5DB
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 13:13:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o140so27226683yba.16
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 13:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KeQTrd37BEFhJhhFg8eLib2y6OHrwfUDJnin6VhVDDE=;
        b=XPFcwwz+IN0GhlhFtLkS54T/AZox3vukZ/EUvPT/i0rbNqsZm+7ptZp6276Y0MIU7+
         zC7FNTBq8N7L4wY4fDKZ60+fAhTJGJQyvfPCVmzo1IKbh2DmWhuzvzsvft0La448sT6H
         yZWPG3KepMC7HMIor0MvX7mDyp8mIwsUSuwe1FvaSQP15JJ9SZMYAER72sVUUF+4X7AJ
         N0vEvGbIyoI3ZsstYS6khx6KqC+dInvaT4ppZws44O2ZjIYseM8SVQThZv4BV/mmqxdH
         qNuZ8VYr1we2UkHAO2V6xvapYhgcm49pQMDJnRMNjRBDYnk4Cl2rZWMxup4LwwUEyAG6
         M4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KeQTrd37BEFhJhhFg8eLib2y6OHrwfUDJnin6VhVDDE=;
        b=FhUJtGk885V9o6sBr8Cwz4SihWlEdbqj+bNMVzd9V+ZFnYIG1m0NUI4whw9yLiDitW
         neIbU7VmlrZAjGWSuK4BbKmwqCsE5SnJwl2fsvobYDHpmMfGdp7FPnJwUgMkXju+nDUg
         2uKzm2dX1JjLnGBRKL4JszOunT2qqDMFg5YHXsSGechp4IZcD6w/mxJaeLeEAto8G7Bk
         SwvfwgZN5vhvkVlPpvoaNwGBdGZ2fgH8ztZnY48U2FUt6vaIoKZCENs3mDav5onflYn4
         O2DsPAEnq6aNvMrBAOgh2sYl5lIXrFBWcBmaev6RQHx624rnOi0iNMVkD4AKr6aQqICT
         gUOw==
X-Gm-Message-State: AOAM533Wu8nzpoHdCQENT/JJlFj1vL9DcQ2PT8z6JFXsU3nv2YbpJSl0
        DvfwlxWNW1LUHIk3fao+kQAylYoxjDc2SD+1pbwzYnzbxJSNVu8c368ULlzu2k0jMd14kSZdcJV
        1D/42OW6SzfPLVPYLubuxE4dBNhJzy7fgG/cYu6XMY6uvQBwznTNZfQ==
X-Google-Smtp-Source: ABdhPJxz3YBEHyQoZOW9dyvNhF7Y+L81FC/JAfShrbT3eSsWT6KVByCnW9l5xQYbw0o6jDJ6VV/EmKk=
X-Received: by 2002:a25:3f87:: with SMTP id m129mr47200320yba.371.1593634392985;
 Wed, 01 Jul 2020 13:13:12 -0700 (PDT)
Date:   Wed,  1 Jul 2020 13:13:05 -0700
In-Reply-To: <20200701201307.855717-1-sdf@google.com>
Message-Id: <20200701201307.855717-3-sdf@google.com>
Mime-Version: 1.0
References: <20200701201307.855717-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v3 2/4] libbpf: add support for BPF_CGROUP_INET_SOCK_RELEASE
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

Add auto-detection for the cgroup/sock_release programs.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/include/uapi/linux/bpf.h | 1 +
 tools/lib/bpf/libbpf.c         | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index da9bf35a26f8..548a749aebb3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -226,6 +226,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_INET4_GETSOCKNAME,
 	BPF_CGROUP_INET6_GETSOCKNAME,
 	BPF_XDP_DEVMAP,
+	BPF_CGROUP_INET_SOCK_RELEASE,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4ea7f4f1a691..88a483627a2b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6917,6 +6917,10 @@ static const struct bpf_sec_def section_defs[] = {
 	BPF_APROG_SEC("cgroup_skb/egress",	BPF_PROG_TYPE_CGROUP_SKB,
 						BPF_CGROUP_INET_EGRESS),
 	BPF_APROG_COMPAT("cgroup/skb",		BPF_PROG_TYPE_CGROUP_SKB),
+	BPF_EAPROG_SEC("cgroup/sock_create",	BPF_PROG_TYPE_CGROUP_SOCK,
+						BPF_CGROUP_INET_SOCK_CREATE),
+	BPF_EAPROG_SEC("cgroup/sock_release",	BPF_PROG_TYPE_CGROUP_SOCK,
+						BPF_CGROUP_INET_SOCK_RELEASE),
 	BPF_APROG_SEC("cgroup/sock",		BPF_PROG_TYPE_CGROUP_SOCK,
 						BPF_CGROUP_INET_SOCK_CREATE),
 	BPF_EAPROG_SEC("cgroup/post_bind4",	BPF_PROG_TYPE_CGROUP_SOCK,
-- 
2.27.0.212.ge8ba1cc988-goog

