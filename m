Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C5C20B64E
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgFZQwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbgFZQwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 12:52:36 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16557C03E97A
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:52:36 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a205so7009358qkc.16
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 09:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=eUwmZKxCGJq9Xs8nLFS4B15rV5sLgo86/VMV9gkjb/4=;
        b=GpbBei1cwX7kTf8cUy0QTU7xkWGkbB+/alxZvCAx+Y1ytygViG7wgzj8Ui3ECpUGu4
         UuD7qs0PtYpzSn7pLq31oLP1psu7OkOw5qh1lbVgerCxptFzE4ju+DfWkJDp/IH7fJOA
         MnxWxztIRd4bHEIpzJ+6PFXU6tcETTA8niKcIYmfeu9eu2lN7bRqEWA5QgWZaCci5xGA
         WmIeBkzNVMsHKcxjZaz0trQnTfOm8+YWuwHnAc5UcZW0cZVP2S27Wan6AzQNpnPotbV5
         6uf1s/Swi4Bt6SQRPJ21RPHlHyO7O4rPKUUlBnwEuGv3ioOdiINu4Y3oZQ9CSMonT1Vm
         VqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eUwmZKxCGJq9Xs8nLFS4B15rV5sLgo86/VMV9gkjb/4=;
        b=Lb6W3O/FrydZFvrUZHmZ5a8BezK/ksbz2FOwy5nM26nbM2xB8RXLxgBbjg96dflmIj
         LYLgGeHvIIR8xU1cHDeZ1xzZFJV+5Tup9Ln/rzaGkpK4IGr4JHXk+nHeZIBdwQq1pP4u
         ixQz4DvrS52Ujb+ljD8U/afzgA6LpjKZ7dIJQ59EKA1YhlvvfUwySBtZ1aS0p0FFhykX
         blYoq88zP7QGlWjiL0lc/6T1wSZQ6S2yDutxSFkikyd3/AIhpnSK19n8npmWjSA3dSV2
         P7zckvrHE+rVORZy/INzXL+FKwpyuNspDPxTuSHoZOK5Fm5caaY1ZETzmmOx29vXX6cE
         cXmQ==
X-Gm-Message-State: AOAM532mg1L8B9ZeMvQAoxvXh+XAAftNWTRpG8UdVo97hGdHxgIl9rPN
        1jyCSF7L31YOQ5p9r+8POFss1E8FrjBqpHEWSr1q6RTz3gs9EYJFlsfuqxiGyDFf0B1PoXCq4Xk
        kUsOZkISg8dcqZiX5KMKU/tK18xKKq04Qjy7oLhbUC0PJG/hDD65erg==
X-Google-Smtp-Source: ABdhPJwE6V/rqLyi3zRXFMUkuntbGD8cd9sZnn5khxLup5Lt7jLTREOlbOMwRihlbXlcf6IMTqupD/U=
X-Received: by 2002:a0c:f78b:: with SMTP id s11mr4132483qvn.33.1593190355221;
 Fri, 26 Jun 2020 09:52:35 -0700 (PDT)
Date:   Fri, 26 Jun 2020 09:52:29 -0700
In-Reply-To: <20200626165231.672001-1-sdf@google.com>
Message-Id: <20200626165231.672001-2-sdf@google.com>
Mime-Version: 1.0
References: <20200626165231.672001-1-sdf@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH bpf-next v2 2/4] libbpf: add support for BPF_CGROUP_INET_SOCK_RELEASE
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add auto-detection for the cgroup/sock_release programs.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 1 +
 tools/lib/bpf/libbpf.c         | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index c65b374a5090..d7aea1d0167a 100644
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
index 7f01be2b88b8..acbab6d0672d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6670,6 +6670,8 @@ static const struct bpf_sec_def section_defs[] = {
 	BPF_APROG_SEC("cgroup_skb/egress",	BPF_PROG_TYPE_CGROUP_SKB,
 						BPF_CGROUP_INET_EGRESS),
 	BPF_APROG_COMPAT("cgroup/skb",		BPF_PROG_TYPE_CGROUP_SKB),
+	BPF_EAPROG_SEC("cgroup/sock_release",	BPF_PROG_TYPE_CGROUP_SOCK,
+						BPF_CGROUP_INET_SOCK_RELEASE),
 	BPF_APROG_SEC("cgroup/sock",		BPF_PROG_TYPE_CGROUP_SOCK,
 						BPF_CGROUP_INET_SOCK_CREATE),
 	BPF_EAPROG_SEC("cgroup/post_bind4",	BPF_PROG_TYPE_CGROUP_SOCK,
-- 
2.27.0.212.ge8ba1cc988-goog

