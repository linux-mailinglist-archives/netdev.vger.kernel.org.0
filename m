Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9142E29CD48
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgJ1BiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:23 -0400
Received: from mail-qv1-f74.google.com ([209.85.219.74]:50442 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833022AbgJ0XhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 19:37:00 -0400
Received: by mail-qv1-f74.google.com with SMTP id b16so135778qvw.17
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 16:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=F2RvHgXC3oKHdz1O4cGcgeyiXW9DkqTo75Q0ru83S58=;
        b=cPblheka8Zz576kOfWYGh7klThOUEF4vx0mwSf7z8wZsk0vKsTbArthcnN8pU+OarF
         +fmv0FbkiWBXYExERS3fX2JTfXeaaSSJzVK93W9SPlCJ1FgPfQ4mEyZce6QVM4QF0UiF
         16uzikCzugSzRrdTii0O7dkozRruYIPBSlc0l6Gal3cXt2shJPyrTOzLe2iuhwLu+VGe
         Y2ELYr/GIWz3d1P2MKCHhx+976agOMlGiI2CzZu0lgJuNiy6DIg9Ukx3gcNInlSWxvQj
         qvhO+h+0UflqdiKTgbkJs84ONO8AJVL3kjVRhQYs2kWbkx1JAopv05BfoO88vi5kbX2K
         KVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=F2RvHgXC3oKHdz1O4cGcgeyiXW9DkqTo75Q0ru83S58=;
        b=iCo7ooxpKts5WDNAs/nxJk5T6BE3YEBiH6roPCmV1hQxj6apJxPZUqjkLFuS/0tvaP
         2QmeIXDyKqU8B1PHXbC6a80FW3AqVd0fx4a4kZX2gI+xPZWClNmuo1d7KmpQtB2lmsru
         6bWbNXBKpE+IXW9dqdL7w3lSkG0S10i/VhzXSL9k3plcEZ0woP8NagVaa+4lBdNwSVok
         EPcYtBGwxElPcpOvNHiAD3IiV5s1sHChSmAq4/SSVS1P8oyoci32Hn9aW4whrY1qxo60
         MJQpD95TibMNITag790bG1FgdeOfDlSNRY2dRCURj502nH7b9AHkm5wSv99J/CQiwUuv
         IKUQ==
X-Gm-Message-State: AOAM531ZzJE0plQ5zM8oCegW1gZEV6Jxeey3nqEoNII1KtAm1y6LIor3
        50fPaqUJomHSRjysb7HqNl8gPF1VukNe
X-Google-Smtp-Source: ABdhPJxKUkk7BxVmNkh/rmJozAq6U0AfdieIdylk+jWsWElruPHkYKsXgddbtZwvxSrqgQM6GvFDzb3pyy2G
Sender: "irogers via sendgmr" <irogers@irogers.svl.corp.google.com>
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:2:f693:9fff:fef4:4583])
 (user=irogers job=sendgmr) by 2002:a05:6214:1351:: with SMTP id
 b17mr4973338qvw.11.1603841818509; Tue, 27 Oct 2020 16:36:58 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:36:45 -0700
Message-Id: <20201027233646.3434896-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 1/2] tools, bpftool: Avoid array index warnings.
From:   Ian Rogers <irogers@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Michal Rostecki <mrostecki@opensuse.org>,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_caps array is shorter without CAP_BPF, avoid out of bounds reads
if this isn't defined. Working around this avoids -Wno-array-bounds with
clang.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/bpf/bpftool/feature.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index a43a6f10b564..359960a8f1de 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -843,9 +843,14 @@ static int handle_perms(void)
 		else
 			p_err("missing %s%s%s%s%s%s%s%srequired for full feature probing; run as root or use 'unprivileged'",
 			      capability_msg(bpf_caps, 0),
+#ifdef CAP_BPF
 			      capability_msg(bpf_caps, 1),
 			      capability_msg(bpf_caps, 2),
-			      capability_msg(bpf_caps, 3));
+			      capability_msg(bpf_caps, 3)
+#else
+				"", "", "", "", "", ""
+#endif /* CAP_BPF */
+				);
 		goto exit_free;
 	}
 
-- 
2.29.0.rc2.309.g374f81d7ae-goog

