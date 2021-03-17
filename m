Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493BD33EFEC
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhCQMA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbhCQMAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 08:00:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC0AC06175F;
        Wed, 17 Mar 2021 05:00:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so1218917pjb.2;
        Wed, 17 Mar 2021 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vJf2xWBFK1v4BuhbkRcyp/Yvw0Lr/H5oTB+llhaRm9I=;
        b=Amd7fp4SxY6XK/ENYQMRVlEL7AUA6uXdxoW7gbm1nfJKLdKLr9d3ml1Kzx3wNsvY/a
         mll6ZQQ6/rBOHrPmdNn1/mIO5GFfO4COxVGsEqHHMHeYgMA/jXxCW/DwQQ9v7tcMGpX1
         Zz21+SRTXMZSWqTA4OLHj9XsFNbMysAPPjPaIxBg9WJRH0YZKMVnqg70uL4y4P0MKQhh
         tApQ4tG4ETyBJBHIk5qPI9dGgzXYl4b7cTcg0bIa4IwghUrlOdAQfml4y0EGWysgBaNL
         jv+zdO+qRd54vi5tqWm6q9ARXsvyMqcY1Dm9KKk8fx4uY4kmCs/BAsmr0Zlr/g4H7Ou3
         1alA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vJf2xWBFK1v4BuhbkRcyp/Yvw0Lr/H5oTB+llhaRm9I=;
        b=LFjadu4JQJXDLuc7Yt8A2dInl+Iy1uogyUGz0unlMye7k6HMzOGukOgS2f9hFDKQ2B
         1d2O8XjGM2vKm92RY1zBx9Kng5KEbEA2KEoZLoXLoJejinY1x3MoSiHw6nKUwsgaZBqY
         43KYK7WH/NQQFdE9t9mxzKLA4z9RGHOI4+5Gd/1j9kC1IJaS7c7WtXoIGZ4vdBMkzSBk
         +jme7JUkyukKslJn2gk+eUI/0Gw4QGlK4IOnQfJnB0rt2ipiVf0l6yFCcvCb/6L7wOYC
         BIBvA9mtuCBRTICk2d0eiRI7sWp1G+z0NzE7ToeW8W3Gf5rcEnXf4++ltYQ9/GFge0u6
         s98A==
X-Gm-Message-State: AOAM532jDErcwEkfi65WVTwNleSZLfEu0GYchpNQAavVPolG/Wpg7uA/
        UvQn7CQVr/B90NHdGIukKZo=
X-Google-Smtp-Source: ABdhPJyQmeDd6BsE9YEAGN0BUtj4GvpwRxvaZRO+UINdE1Oqef51QcrBE7vphlF6VCqwV98J3BMfkw==
X-Received: by 2002:a17:90b:4017:: with SMTP id ie23mr4436991pjb.118.1615982405777;
        Wed, 17 Mar 2021 05:00:05 -0700 (PDT)
Received: from localhost ([47.8.26.8])
        by smtp.gmail.com with ESMTPSA id 132sm19471687pfu.158.2021.03.17.05.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 05:00:05 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     ast@kernel.org
Cc:     toke@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2] libbpf: use SOCK_CLOEXEC when opening the netlink socket
Date:   Wed, 17 Mar 2021 17:28:58 +0530
Message-Id: <20210317115857.6536-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, there exists a small window between the opening and closing
of the socket fd where it may leak into processes launched by some other
thread.

Fixes: 949abbe88436 ("libbpf: add function to setup XDP")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
Changelog:

v1 -> v2
Tag the bpf-next tree (Toke)
Add a Fixes: tag (Toke)
---
 tools/lib/bpf/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index 4dd73de00..d2cb28e9e 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -40,7 +40,7 @@ static int libbpf_netlink_open(__u32 *nl_pid)
 	memset(&sa, 0, sizeof(sa));
 	sa.nl_family = AF_NETLINK;
 
-	sock = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
+	sock = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, NETLINK_ROUTE);
 	if (sock < 0)
 		return -errno;
 
-- 
2.30.2

