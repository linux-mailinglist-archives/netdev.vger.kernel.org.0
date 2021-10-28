Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CED443DDDF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhJ1JjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhJ1JjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:39:13 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BBDC061570;
        Thu, 28 Oct 2021 02:36:46 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w15so22276146edc.9;
        Thu, 28 Oct 2021 02:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5UtnX/BS5wJUI30R0Rg1To+05cxnloCRImbzHZCiB2k=;
        b=TZt3Q/KcU5hGmbKYla11JTZok67tXjXu+bFXrbXCi4OmNJ9QxutRu1vVDVJ6wTk61h
         ck9FZDza/bgu2gEm6mqCODziQ9Ieh5zDFkMqIGO+qExUpPhJ9p0MwFWHmiLI1yM5hoi9
         H96euIaBxn07vxRO7VjOqSg4yc0t+pXkNxaBhuX0HIIn8P4kpu71QzmjFofXK9130Igs
         ENqLDHPxizAry8fxV2ckxA+Vm0lgQhAiDhzaPk0VXXMVmhk7R85rowQ6DmrFAhtpLsVM
         uMoUxydOPzDdftg4Wi9fSBVWiqITZcBnAwmLZtTpgKzS5VAQsGmbJTO0pYAYZEvMdwDU
         +LGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5UtnX/BS5wJUI30R0Rg1To+05cxnloCRImbzHZCiB2k=;
        b=zaJz2/hZRmMTNjCf+OfBoDD24UCBegz5x2yRh1abDXPKzXH1vaA7UWIROIXtHtl4dT
         M0BjRL/7AIISUZ6Be+y68Sz3CTVBRCy+JZ5o7c5tyBTuvB+wMmg64rfCv/LtUIVonoTf
         j0hfDgqzv/10iBfkWBcnntxHz5oyPqvElB3hiUmMLRQvzUjEGEHxd0VcjzcF6McpAj3q
         76aiga8ojR61kmGRwXjFv542OsRP0yYS2nvjB8taYTW0Q/Nf0PUNQoTGpmBy7GDcs1YN
         xm2/eD3oh3DgT6/JUlwcG4+87xCv2weNhySJHMIMf2ySYJUQ8bXAsGBajMAzKICo03K2
         9Z9Q==
X-Gm-Message-State: AOAM533nR1p4aJjm8LGpr/2JDQczf1/hjQfQuf9oOnRq9/faZ4hw1RLW
        qo0G6/d3OCJV0RkPmk0h7xSMv2UTLcM4Yg==
X-Google-Smtp-Source: ABdhPJxt3ok0lGq6TajYoNgRaghilWVSsBqi+ZH4/iJVFy5+ZjFLi+hD0sCxFmqSW0lKc4pSHdGGbA==
X-Received: by 2002:a50:998c:: with SMTP id m12mr4572087edb.19.1635413805354;
        Thu, 28 Oct 2021 02:36:45 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id s12sm1379865edc.48.2021.10.28.02.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:36:45 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net 2/4] sctp: reset probe_timer in sctp_transport_pl_update
Date:   Thu, 28 Oct 2021 05:36:02 -0400
Message-Id: <bcdcbcf8a902443ce471254e3842769350ebfeb1.1635413715.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1635413715.git.lucien.xin@gmail.com>
References: <cover.1635413715.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_transport_pl_update() is called when transport update its dst and
pathmtu, instead of stopping the PLPMTUD probe timer, PLPMTUD should
start over and reset the probe timer. Otherwise, the PLPMTUD service
would stop.

Fixes: 92548ec2f1f9 ("sctp: add the probe timer in transport for PLPMTUD")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 69bab88ad66b..bc00410223b0 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -653,12 +653,10 @@ static inline void sctp_transport_pl_update(struct sctp_transport *t)
 	if (t->pl.state == SCTP_PL_DISABLED)
 		return;
 
-	if (del_timer(&t->probe_timer))
-		sctp_transport_put(t);
-
 	t->pl.state = SCTP_PL_BASE;
 	t->pl.pmtu = SCTP_BASE_PLPMTU;
 	t->pl.probe_size = SCTP_BASE_PLPMTU;
+	sctp_transport_reset_probe_timer(t);
 }
 
 static inline bool sctp_transport_pl_enabled(struct sctp_transport *t)
-- 
2.27.0

