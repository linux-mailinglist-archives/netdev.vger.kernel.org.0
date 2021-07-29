Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA2C3DA8CF
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhG2QUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhG2QUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:20:43 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDDEC0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j2so7613888wrx.9
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hFXn2xFkYP75TNOyXFEIXsA4f61R2isd0RjJQoMsXiQ=;
        b=Z8zymT69buBCqb364LcZlwP5MAbJ/jnbTwbo56NWVNE2uzzhjhNj8AfL2UnLWk9gQp
         RYMDmza4Quq77p4yN4g9sHMwQFsAC+dIrThx9RMGnJ9XYlJTQXrGXC6jLMcdfXVR8UQ3
         MYhU6LenUP0BbnYrjOHZJPq2oGNPf4n7d8wevCNLyCGIwpfwgpIVSBdoK40CHaondCaF
         8Cc2sPFE0kbtQMhLiAwj2GPy6qPscpZOszFbFmRgpG5t7BQTYJAq0n3pzCiL55Ev42CP
         GG9zs4SS8mV6mOCVK8rY0NJIi/t8X96rvnqFrk2yZqT/J5vLsLg0guDmKbxOCqt6hihU
         nI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hFXn2xFkYP75TNOyXFEIXsA4f61R2isd0RjJQoMsXiQ=;
        b=YI8RHf62LU71ym/7iKlfnD2xr6z5QbaykMM+OoxknhyzBCXYBO6hJ3/NJ2bKKHd8AY
         WWHkBiJLzK3/ZxVLo+Zvqfd0DU3yiQSDpyZ4K9fUDVRU+qsHt1sHSVnhGJED0jLRVNHr
         riH+kyxb0c8l4VMUAlHgLWdA4OfuSlgpxNrEt0/Yn/3Bg5/fnNGOvCb+B4ulEc21vkjU
         ur2KBXfNr/j6LfTrTtmX1MKGBFSywPAwSeepryAMO+YeS6pjGyewKzaekKfKPOkR+W1G
         Ux1p5bDcQWmdQt+feQgzPkAYYsIEONTY+sjgTP7ZFlfnP8YlvYQU7AkkwndI62ijC1Wr
         Yr+Q==
X-Gm-Message-State: AOAM531ukJRKcSkb3Wi8TcZj4H/MwVdJKtbEoIpw+LW7IIWsNXyfrtxd
        FMfBRByDjvSMsUYRJjT92ioDTQ==
X-Google-Smtp-Source: ABdhPJxPkmh27hp2PJRclfyYOar0gCS+x3Aqe7PlO1hJIWsHzkx2/AI/aOn5jS097cvpDKICKH6hAA==
X-Received: by 2002:adf:9e01:: with SMTP id u1mr5810636wre.12.1627575638046;
        Thu, 29 Jul 2021 09:20:38 -0700 (PDT)
Received: from localhost.localdomain ([149.86.66.250])
        by smtp.gmail.com with ESMTPSA id c10sm3854853wmb.40.2021.07.29.09.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:20:37 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 1/8] libbpf: return non-null error on failures in libbpf_find_prog_btf_id()
Date:   Thu, 29 Jul 2021 17:20:21 +0100
Message-Id: <20210729162028.29512-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162028.29512-1-quentin@isovalent.com>
References: <20210729162028.29512-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable "err" is initialised to -EINVAL so that this error code is
returned when something goes wrong in libbpf_find_prog_btf_id().
However, a recent change in the function made use of the variable in
such a way that it is set to 0 if retrieving linear information on the
program is successful, and this 0 value remains if we error out on
failures at later stages.

Let's fix this by setting err to -EINVAL later in the function.

Fixes: e9fc3ce99b34 ("libbpf: Streamline error reporting for high-level APIs")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/lib/bpf/libbpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a1ca6fb0c6d8..7b2b5d261a08 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8317,7 +8317,7 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 	struct bpf_prog_info_linear *info_linear;
 	struct bpf_prog_info *info;
 	struct btf *btf = NULL;
-	int err = -EINVAL;
+	int err;
 
 	info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
 	err = libbpf_get_error(info_linear);
@@ -8326,6 +8326,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 			attach_prog_fd);
 		return err;
 	}
+
+	err = -EINVAL;
 	info = &info_linear->info;
 	if (!info->btf_id) {
 		pr_warn("The target program doesn't have BTF\n");
-- 
2.30.2

