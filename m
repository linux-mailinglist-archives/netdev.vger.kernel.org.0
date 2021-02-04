Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F10F30F98B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237916AbhBDRVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238350AbhBDRUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 12:20:25 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA409C061788
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 09:19:45 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z3so2905900pfj.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 09:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=jVxxi2FsPuJw4XM1jbb8exuFnk/zAFQh52OuUnL6x5c=;
        b=cBBH6E38w3ioyeFqsdVI637YfnFdofxvqmnPq3Agbtor84vP4DOwxc29ct1qwg1dTr
         k3Enyv1FSv3SKdG6Pyefp5vIiAPf0wtby8liexvP0SZTzpOAOdqRBCUjs7ByW54gJV+7
         bHlUjZ2phzNhw7TpKljfGEcnDmNFE205AsM4pPwqBna8CnFmSsvK9Nm252VXdEP2KEam
         4WqKIF3bUtfx1CHRgj6G4R2f8XVM2/fzMyeHR/4WRRY4MeabYJPNKaqjwf4bCqc6bnCT
         OEASH+3HzCato3ZPypgQvZv4Nf7U4DiHGHzsbE5/bCSUj3uY46G4fduPbEJ/LUoEaGz+
         1DLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=jVxxi2FsPuJw4XM1jbb8exuFnk/zAFQh52OuUnL6x5c=;
        b=Q79qx8MWLjZKTcEyCfDD8KitmkJDYExWGMQ2gYcPlKFDv/0kOg+gkrdGZfOjcORcy/
         KJuPrQnJfgZtW4Zuw3DgKKXn9gdaqwKtTOQwHQEXyZcIZ/GyEFzUZ+S3SEMkQtWDGYfO
         8dyZPXtqjPEpneECSAWkDiKXp940cT/wPb7J9r15P5tUJ8btWCgBC0S6X+wvl7Z5M5oD
         RMlfI3bzCvhNKufGUfPjyT6lnkW6CGLktTB94SSSQsCiW4tlBt6xX18hRP8SZwZIKfNY
         74ofwPz++dX2aeX1O55p+3cynVufMPzSGWZEN9+OMjIO+E3QnXjQaMGGRY5zel9XUBaJ
         WYDQ==
X-Gm-Message-State: AOAM532fXkIxU0l8ctENgD3/LtmJ6yHuuoc0m+2krAP/i3TJJqwjQKo9
        EUXzDLYVln0K/oPXSgul2otdmB0hyowI
X-Google-Smtp-Source: ABdhPJwt8i+WRWwmmTnVx/RZ4nFR8fm8Ym2VS8rcLwVe+ugJh6hHeS0ugCVuXanWYSPq2Q7tq4GodF5wZvGe
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a17:90a:7503:: with SMTP id
 q3mr480577pjk.79.1612459185194; Thu, 04 Feb 2021 09:19:45 -0800 (PST)
Date:   Thu,  4 Feb 2021 17:19:41 +0000
Message-Id: <20210204171942.469883-1-brianvv@google.com>
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

