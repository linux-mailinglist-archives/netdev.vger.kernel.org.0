Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2939E33EEC4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCQKuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhCQKuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:50:22 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA06EC06174A;
        Wed, 17 Mar 2021 03:50:14 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gb6so901982pjb.0;
        Wed, 17 Mar 2021 03:50:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ql0XfQdaA6JFx0GO4CBbHqqpEsH/UmgUozlPO3OUoJU=;
        b=jL4W4B2PkQqNt97Y5GRGgsJ8AcescD8GHejesmsdeohePt3nyfdRPwmxYFwErT3CJP
         zAcKdlSvw0LslANUOnY/z1lY+XTmORNxCUwDTc0f64l5Y8BBj7VgAdkk6SWpLocXCxRc
         OXiNHJ+XN+oyqExkdwhKdvA7tvpUylNmfqvmaeMWFT11zbaX+qo7rx/YmISmf86g7pKC
         AMWk+EpqEuXukspVQ3IebJUmiy2hVEzF8wf0sqpBjhDH1fye3qBch0xcBX9BiGaZc1UX
         xowCrEYtMaer7bqbB6zHq5keYTSVY9ZWg13j/u3XGyDP7kR0tS797MbNWNx/C1YixpHf
         4aUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ql0XfQdaA6JFx0GO4CBbHqqpEsH/UmgUozlPO3OUoJU=;
        b=mTqFQJbFA79MyD2V2J5HG0OL+o4oMMhfs19oxG9vuOVE02D0RhHttZjVjtYgwjT/PH
         o1ErM8kHP5b5N0ymc9/vrNrLPZMN/WBzHjwkyoPsqMs8XgqLsa8dhIy5uygs3mVASzQW
         1Lr/Gxa4+PUA+lpjL/Jhd6sPHFnFNT/Vsto2cfw52f3tsUQEGJ8vmXspYBob0wPursQA
         6OuETAa4zNrrVCJLgp5CsQmsfu8l7lDxWdJpHLVK2J4PiKDUFxDl+poJdaMXaDO2b2eI
         7xZ4bELCu2syVpmK0S6oeGzN9W9LBdiEp16fTwbf+o6w2aOBeqdqEF3VMlLle579vEEi
         r9nw==
X-Gm-Message-State: AOAM5339EdMrKzlT0LStxpGlCI/Cx0wNBVRiV0QM+tKbBjping2UgjMC
        sG28FiBSSYYeaxElfoPPKLY4E71B5rsI/Q==
X-Google-Smtp-Source: ABdhPJy5y031Uo4vhFvB5mvc9mqbZr7TIgDBStB2bi0HrigMG1t9R2Gy7oX71otR4Ts90RNGF+MCxQ==
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr3794372pjz.63.1615978214235;
        Wed, 17 Mar 2021 03:50:14 -0700 (PDT)
Received: from localhost ([112.79.241.63])
        by smtp.gmail.com with ESMTPSA id e8sm19237919pgb.35.2021.03.17.03.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 03:50:13 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     ast@vger.kernel.org
Cc:     toke@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libbpf: use SOCK_CLOEXEC when opening the netlink socket
Date:   Wed, 17 Mar 2021 16:15:14 +0530
Message-Id: <20210317104512.4705-1-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise, there exists a small window between the opening and closing
of the socket fd where it may leak into processes launched by some other
thread.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

