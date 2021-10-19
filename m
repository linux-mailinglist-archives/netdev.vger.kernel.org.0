Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83619432B37
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 02:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhJSAgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 20:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJSAgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 20:36:20 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128DDC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 17:34:09 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e10so7563612plh.8
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 17:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dfltF+KdoBWysgdk4AaWUKJJEeefM25wtANwmdckgLY=;
        b=WY8OzPy79QUMaP7d5boNtqR0avMKYrn6noq5wILRqi8jK3o9tuaJSaPHlYsZT4xFg2
         5hbrVrNQ1/KGzwudLa+M3PMvXrJ2wuJbIT8e9ia0Eavbk5to53Vept2V2XpywtmTHQBu
         IbHVTTNc+9BnaHsaL/Xde8YII9+YSvMH3xfPAU5vcntga/IXptjN1RuISI5kkQzTWAiM
         oIzMrWNVpenGDZVQBZPlO9GRg+BZeYiIebPLtqqYdxQ5zgnq2kdGDFAbA/lHJqfw9f2j
         GGMCIhjjy+XV4SmT6dlqk195tR6usvh+OC9ZlKGg7kfQAgdPD325dC/J7g/rc714SowN
         +2Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfltF+KdoBWysgdk4AaWUKJJEeefM25wtANwmdckgLY=;
        b=yMUxElaJRPk5g7Gl8umpnBbSdgCqppZa8wPfGQVXagL9gStEyh1C3sCo40wFaHHs0o
         +OfyH/ZJvIP67PhO5Q/GZaDglmueL4kXD537pmTXBOHpQrPKzjbnNwpjZOlfnywcfFCz
         Cb87Ur0H7M9kbkU4twfBN+QOOEgMu0++SwRV6DHA70o5OL7764lIiHO4/c07s+rMuTva
         NeMW7A4lIVcXEHoGrXzJWLn4nkX9VYJSmRivmaSoNv4sY43gQpQ3aSRzFVvPXuS/4KlN
         Zci/Ix8MbHU/B4amkg/u27v2SzcCFSojsyrDame6x1hb13IC1ByjBCgzanrvDS7K5UGb
         Aj4Q==
X-Gm-Message-State: AOAM530g6oGUZUPmJ93kbxhVGLmAwxRXXusOZSAbUx+FP574xz0tL9JN
        7UQBPK80h47Dkrrds/S+cvk=
X-Google-Smtp-Source: ABdhPJzYbBrlGiTNdKGFan2xlLORf0sdo5/WM5SzDLthX+0/QhXNs0Gf4Lqmk80KvbHLEsQTdQ51Ig==
X-Received: by 2002:a17:90a:6b01:: with SMTP id v1mr2647551pjj.6.1634603648604;
        Mon, 18 Oct 2021 17:34:08 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:85d3:2c8e:fcea:2b1e])
        by smtp.gmail.com with ESMTPSA id n22sm579675pjv.22.2021.10.18.17.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 17:34:08 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 1/2] net: sched: fix logic error in qdisc_run_begin()
Date:   Mon, 18 Oct 2021 17:34:01 -0700
Message-Id: <20211019003402.2110017-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211019003402.2110017-1-eric.dumazet@gmail.com>
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For non TCQ_F_NOLOCK qdisc, qdisc_run_begin() tries to set
__QDISC_STATE_RUNNING and should return true if the bit was not set.

test_and_set_bit() returns old bit value, therefore we need to invert.

Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/net/sch_generic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index baad2ab4d971cd3fdc8d59acdd72d39fa6230370..e0988c56dd8fd7aa3dff6bd971da3c81f1a20626 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -217,7 +217,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		 */
 		return spin_trylock(&qdisc->seqlock);
 	}
-	return test_and_set_bit(__QDISC_STATE_RUNNING, &qdisc->state);
+	return !test_and_set_bit(__QDISC_STATE_RUNNING, &qdisc->state);
 }
 
 static inline void qdisc_run_end(struct Qdisc *qdisc)
-- 
2.33.0.1079.g6e70778dc9-goog

