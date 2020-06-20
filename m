Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0F32026D8
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 23:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgFTV12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 17:27:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42854 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbgFTV11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 17:27:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id e9so6202133pgo.9;
        Sat, 20 Jun 2020 14:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0X0DDjflRu40U/YjqFAViv4c+Dopp8yvdpsJ3G4W+d4=;
        b=ZzWwEs6iC/AJfANlnwkhyBE2ml+iCExSzoUh4PxqnM+UB0rp2p7inTJW3YJjVzRj7M
         iVVE98iK6SEnCdNOexAEbjlhBGBaKcPecwkyUnNYj+A5RHcRHpDrYtw4B5Mx7xR/IeDD
         cIMvXa4Oi4SeEqM2E8l3wqKcVuedfr7hrmgOcQ+TmmbYDNkVA1YWONTbgngpYhX3khXU
         Bur2dxc8ZUcPTOOxIcxt+edxyH/YC0bEgs5LuA5eIfgE61e5wM2XSlJW3dx6bmAXgiQu
         FsePeuwmBFmOLkN6o0D6h1kC0KRkQ/bCax+cV+AWfAKSo7Fe7433Ik09vXOh++L90Xmo
         TafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0X0DDjflRu40U/YjqFAViv4c+Dopp8yvdpsJ3G4W+d4=;
        b=audSLqMYoQPl+TuaZHUooXfUtEpAv9aDhqFUCdChX0h5xVEewrwCv6eI6s2ZLQwMiI
         5ZKP0xvKaMZI5MFPP0ZK0JD5Q/GkijdXH26uqwTlEwQKckG9kwzPJlMeZs1g2zzJpksM
         AbghqtCLIoHQxSS48f608arY8VB0Z+v4UQO2XUCaRqkWJebj+m1nUZ7jNFVyvBDOZY73
         hCnAupB0D3/Q/JRxxsoVXoZtivVK7mUElXGPU9exDtT6kD3IufqQ3AC7E26xGAIL7DF0
         6MIbUnkEfG/qm7UH8J6v+eEFShvsCtnLhA1zqpItvWU/mojD4IowP2fz5al6xtqi7Bd2
         p0yw==
X-Gm-Message-State: AOAM533ft7rtOHc1euzmj0ZNU6SDcqApkpBoMSyb9yplMPag3PpbZ5Iu
        U5QxURhmO69muTce48+6bQg=
X-Google-Smtp-Source: ABdhPJzcvjmtq3PMeDSVQKIdeWm9GAgtrPAZsQj5iFKq3SU7vplD5hrN58E21f0/s+oCsj/qFUmAjg==
X-Received: by 2002:a63:b956:: with SMTP id v22mr4574957pgo.242.1592688386037;
        Sat, 20 Jun 2020 14:26:26 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id f14sm7808825pgj.62.2020.06.20.14.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 14:26:25 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH bpf v2] restore behaviour of CAP_SYS_ADMIN allowing the loading of networking bpf programs
Date:   Sat, 20 Jun 2020 14:26:16 -0700
Message-Id: <20200620212616.93894-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
In-Reply-To: <CAADnVQ+BqPeVqbgojN+nhYTE0nDcGF2-TfaeqyfPLOF-+DLn5Q@mail.gmail.com>
References: <CAADnVQ+BqPeVqbgojN+nhYTE0nDcGF2-TfaeqyfPLOF-+DLn5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is a fix for a regression introduced in 5.8-rc1 by:
  commit 2c78ee898d8f10ae6fb2fa23a3fbaec96b1b7366
  'bpf: Implement CAP_BPF'

Before the above commit it was possible to load network bpf programs
with just the CAP_SYS_ADMIN privilege.

The Android bpfloader happens to run in such a configuration (it has
SYS_ADMIN but not NET_ADMIN) and creates maps and loads bpf programs
for later use by Android's netd (which has NET_ADMIN but not SYS_ADMIN).

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Reported-by: John Stultz <john.stultz@linaro.org>
Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8da159936bab..7d946435587d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2121,7 +2121,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	    !bpf_capable())
 		return -EPERM;
 
-	if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN))
+	if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
-- 
2.27.0.111.gc72c7da667-goog

