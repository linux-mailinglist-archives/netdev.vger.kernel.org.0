Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2001CED64
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 22:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbfJGU1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 16:27:03 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:41903 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbfJGU1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 16:27:02 -0400
Received: by mail-pg1-f169.google.com with SMTP id t3so3062467pga.8
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 13:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iYngEvnZDmzD/znQk3fm2VIAdjMXrMKfM+x4TqLNis=;
        b=sSzbJ7ULIOYy0Xu1wExNyYL3IhN+L/eN7UyWBu61brX3FdAoQxwhv9+GFNaus919Nh
         8trWYAw3aGuqeyjXg1GjotVMObWEx0+qtHehaaU323PZB4VcseuKfCMHZp/9IUq1m4h4
         +1GLE8sHDnh/YW2VIg4QjzrudNms7/MSP3PleVGHjdz5vbWDCWnYFIOe86IxsOj8FbZP
         B6HYy1j4c1x2y/2QiEjynRjgVf6lqd9kYcm3lqwNrxCh90x4QT4vPH+Bvm2U57KBGgI8
         /oKplWzNsVdlWPizM5IhtIe6LbGleqvhDsQ/RT2mrYQC2YZUKGA8UUJA457kU148l5nQ
         dFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2iYngEvnZDmzD/znQk3fm2VIAdjMXrMKfM+x4TqLNis=;
        b=mjVuQcBUr+qGuffIw6McXjblAXQKL07BK1S/JxA4e2k3CgfNSBAVPUtAl+VahDjaSq
         OeFCpHGwadGU87sqKWAR25r0mDumIzyF7LXjzNI6Qc53vMOOxh3Y7FqQj5tDT8/O7pnc
         AqWMd8wXQudXiMqIRjCD/mH9vNukkWqiicAMaDO1RHueVoULpFK7ZtE2YxjbR4ilBiCS
         Bm/dY78FvBdHSZHdorSMqfDP8/ywGQEr2gsHpsB0WAliSfqQNPbCHP5coa7l/j3220HT
         gdVf9QjoI6a5R6iuHDy/cmYK3fIxRfTKKKGLbBRTyax3LQjq6fNfqGPk9ycYI6/jD5w0
         EeXg==
X-Gm-Message-State: APjAAAW2IlZbQP2oxH4+i273IuiG1I1XQcMnl105IzOqI8c/K9aQ9Z4h
        yAXEI/KwqqxfRhoRvGk/7RGdleOh
X-Google-Smtp-Source: APXvYqxquy5mUWSY9TTAGrPIhK1IoNnW6l3FLRpz/+lSggeCkCIecH7uUQ0uZ5t+OKabzS/BnEnRYw==
X-Received: by 2002:a63:1002:: with SMTP id f2mr18692403pgl.84.1570480021756;
        Mon, 07 Oct 2019 13:27:01 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id k8sm12679602pgm.14.2019.10.07.13.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 13:27:01 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: fix backward compatibility for TCA_ACT_KIND
Date:   Mon,  7 Oct 2019 13:26:29 -0700
Message-Id: <20191007202629.32462-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For TCA_ACT_KIND, we have to keep the backward compatibility too,
and rely on nla_strlcpy() to check and terminate the string with
a NUL.

Note for TC actions, nla_strcmp() is already used to compare kind
strings, so we don't need to fix other places.

Fixes: 199ce850ce11 ("net_sched: add policy validation for action attributes")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/act_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index da99667589f8..4684f2f24b17 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -832,8 +832,7 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 }
 
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
-	[TCA_ACT_KIND]		= { .type = NLA_NUL_STRING,
-				    .len = IFNAMSIZ - 1 },
+	[TCA_ACT_KIND]		= { .type = NLA_STRING },
 	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
@@ -865,8 +864,10 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			goto err_out;
 		}
-		nla_strlcpy(act_name, kind, IFNAMSIZ);
-
+		if (nla_strlcpy(act_name, kind, IFNAMSIZ) >= IFNAMSIZ) {
+			NL_SET_ERR_MSG(extack, "TC action name too long");
+			goto err_out;
+		}
 		if (tb[TCA_ACT_COOKIE]) {
 			cookie = nla_memdup_cookie(tb);
 			if (!cookie) {
-- 
2.21.0

