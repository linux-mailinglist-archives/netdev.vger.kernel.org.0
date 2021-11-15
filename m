Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D36450CE2
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 18:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbhKORpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 12:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238376AbhKORnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 12:43:03 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A0DC028BBB
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:23:08 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x7so13375593pjn.0
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 09:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WKI+4rudpleRoYto5X2It+Z1ZwkXP22Ch9lRgd+5X9Y=;
        b=nqCqAn+Hy+sryKy2Rrtw6y9ifW5IX4ANPjlKbtjK4ABcfaiq0g3Bq9hhwP2xxc3bFJ
         BpqqmDwGs2jq6Cqw1eINtn941fc0MkVPehEScp+xrKNjxXNhNEh4kvEJao75iQBzOyBf
         iNeKnrmmEboloIx2P3q3ZgcoezTTJ/ZRo+CokyWavUeoQcKKJt5CyEuD8lXcGLHKJ2m+
         hfsOUUZVCQS71L6RZdnsMjdwd/RvXSMe6nJv9eB1kbF4tG54AgYdqBXHhRO2N0AeuiSU
         mrRpP+9k0/Yx8HhdcsvSdLFEBGaowmGkxqje1T2Yww5OcZ6BALKeRfBRWb/DC8dXx8Wf
         rxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WKI+4rudpleRoYto5X2It+Z1ZwkXP22Ch9lRgd+5X9Y=;
        b=Bi0IC40v+pE763TPXDzGbkMtJS8fMrFmaiEDhKJRZRdkqubh5++oTO6q6ZbyvUURb2
         57e9Dq22uhhfrtntHKoRpvlLbGnWssXCFXyRsMYtRotVG5IJUWCVEvdajTc1RhDB3AnX
         oCFIweKlZqBHXqDUWgu9XtLhfpZaVrvmiYss9qwlYuJvcLjUjvTZPLiwf4/re0E1StL2
         jBUr7aU8m/RDzvFxVndN2aJhxzm+7RCGenEmpgblKM4JxLU6d2mmk+oBxuIf+mjwTHzE
         LqR4wwe5C+tMDqZZ6SQT169bA8BQSk6Fr0cUnLbeD0GZEfKHEUHr2EhaxCXzjvdIxbmd
         owWQ==
X-Gm-Message-State: AOAM530cykGtAOinbGfvWNKjLLZKMq74iucfrcS3U3VuKpsdxA69FuK0
        zxDO8tEuYv3yYjVywQqY/Bs=
X-Google-Smtp-Source: ABdhPJwDtsNgcmLWr3zS29GKdrwVyZWVVLbRnJZBN7TyOCsFxMl0wpn+n/OPU71s5WC5zTuwp35KjQ==
X-Received: by 2002:a17:902:b68f:b0:143:7bf7:c9cb with SMTP id c15-20020a170902b68f00b001437bf7c9cbmr36504594pls.7.1636996987849;
        Mon, 15 Nov 2021 09:23:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id a12sm18740840pjq.16.2021.11.15.09.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 09:23:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/3] once: use __section(".data.once")
Date:   Mon, 15 Nov 2021 09:23:01 -0800
Message-Id: <20211115172303.3732746-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115172303.3732746-1-eric.dumazet@gmail.com>
References: <20211115172303.3732746-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

.data.once contains nicely packed bool variables.
It is used already by DO_ONCE_LITE().

Using it also in DO_ONCE() removes holes in .data section.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/once.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/once.h b/include/linux/once.h
index d361fb14ac3a2c5b77c289107f093862194ebd1c..f54523052bbcb5d0c13017d4684b68ceb8da5855 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -38,7 +38,7 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 #define DO_ONCE(func, ...)						     \
 	({								     \
 		bool ___ret = false;					     \
-		static bool ___done = false;				     \
+		static bool __section(".data.once") ___done = false;	     \
 		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
 		if (static_branch_unlikely(&___once_key)) {		     \
 			unsigned long ___flags;				     \
-- 
2.34.0.rc1.387.gb447b232ab-goog

