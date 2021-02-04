Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CE030FB30
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbhBDSUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238948AbhBDSTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:19:35 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7707DC061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 10:18:55 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id k20so2857317qvm.16
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 10:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=jVxxi2FsPuJw4XM1jbb8exuFnk/zAFQh52OuUnL6x5c=;
        b=eoiLv4Fjju3JEfXDuHbAba/lObCo1w6vbwyoS7MtecyRwqYnXpMFoZNAYuf+W6oplH
         gED96JwbPRY7jeChrEt5R+59xV+yLfGj24fcQAeQ3kg+O5aLSKHWIqNnkUhhZ+dn8Rq4
         BSdC2ZaIBJTBtyH56RgpmICjqdLlGqg7bhCp5MvnfQftXNufcaTDf86YmN34tkYl8nUh
         E1TEXeKWOfc62QBEEL4iaICZJUqV2BK4Tg1pQtpDeOKiotE8p202ib96xqd5eEqoxJGm
         +lkG9dpS6gQ0YmtwBPKtO1zwA8TCpj/+Qfh0XPeMeyCRpOBP6XgHl3PnRK0X4FR79HSi
         HU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=jVxxi2FsPuJw4XM1jbb8exuFnk/zAFQh52OuUnL6x5c=;
        b=QOB6uq5PPPJw/Iqpfthzny8wzXvbHFrcnyhAQU+7U8y+4mFHrLOQYz8keYcCSd4uPA
         TWQVFHUunxwSferVtMIy5NMIQtQgQv9nn3WX2inL9IIMjjmsJpUkb+sukpThR3HC8lUA
         JxCDthbJV44uU0yBfvtar+M1hg+Fm2jhd02VpDDV03LgZcv6fwnJgUn4Eav4PeCevW2z
         VA/Vv644hxZ3RGFyvgtbrFi9MpzaG44SMLdAPTQjlDwPvnEG6SEAwQjGOxinSgkkyfAJ
         7PlpWkjz8DwIm3oKqreIN/FEScB0tZjTWYYlr7dPCoG0KlBWUmj6CG7hZVtACcEMnazU
         Vd6Q==
X-Gm-Message-State: AOAM530O9qvJlc9QthaWCG26TY7NRtlrZaTKlhdzpL+hF342rKqBgRnc
        fsy5Xyvqmb7/vb7ytz31ogEUbtwFb0XB
X-Google-Smtp-Source: ABdhPJyMx58OK+cTr24By73GqN8pUy8WYFcuOgVnb6Mlp/ZIQ5bdJXL9uXFa9JTBMZrMJ90CejS/EeyKo95s
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a0c:e652:: with SMTP id
 c18mr436707qvn.59.1612462734464; Thu, 04 Feb 2021 10:18:54 -0800 (PST)
Date:   Thu,  4 Feb 2021 18:18:38 +0000
Message-Id: <20210204181839.558951-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next 1/2] net: add EXPORT_INDIRECT_CALLABLE wrapper
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a static function is annotated with INDIRECT_CALLABLE_SCOPE and
CONFIG_RETPOLINE is set, the static keyword is removed. Sometimes the
function needs to be exported but EXPORT_SYMBOL can't be used because if
CONFIG_RETPOLINE is not set, we will attempt to export a static symbol.

This patch introduces a new indirect call wrapper:
EXPORT_INDIRECT_CALLABLE. This basically does EXPORT_SYMBOL when
CONFIG_RETPOLINE is set, but does nothing when it's not.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 include/linux/indirect_call_wrapper.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
index 54c02c84906a..a8345c8a613d 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -36,6 +36,7 @@
 
 #define INDIRECT_CALLABLE_DECLARE(f)	f
 #define INDIRECT_CALLABLE_SCOPE
+#define EXPORT_INDIRECT_CALLABLE(f)	EXPORT_SYMBOL(f)
 
 #else
 #define INDIRECT_CALL_1(f, f1, ...) f(__VA_ARGS__)
@@ -44,6 +45,7 @@
 #define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALLABLE_DECLARE(f)
 #define INDIRECT_CALLABLE_SCOPE		static
+#define EXPORT_INDIRECT_CALLABLE(f)
 #endif
 
 /*
-- 
2.30.0.365.g02bc693789-goog

