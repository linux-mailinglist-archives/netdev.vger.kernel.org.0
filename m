Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE203D0222
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhGTSll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 14:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbhGTSlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 14:41:37 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B78C061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 12:22:13 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id s193so21115188qke.4
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 12:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lJ75WYeeE402syI2eR3iksgV3fgVsDh6b/H1A0UUJFA=;
        b=FXEK1TEQHS8xCRU6HT2Lq6rrIHNFiQDBw534d2OBGUmS8+gGUZ6ViH4u8zzufdmjFG
         QBI9c5V856mBL4G5TIiWJKO/cLXSs9A+x42eyVuLJxiXEcABjkYywRrUCPfsAygNabJ/
         yVxlbfn3fmpWdQnv3k3lhAeRvzeh1X+3ciQB8+Qm8omQ5hB9JtSfq5xIbB/ePpyhYtGZ
         t5VDri2rZih4iMa+hI+AFked/9++UQtCH7R0gCSAPXrnWFjvuQnz4WwbtJ/nqoWq9/c2
         2w0fnqi0seXoeDNggTPsD4yDUxBKWTC/RnM2eu+GO2b6dmn8EaKVRp5IhsUeTeEqruob
         TrXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lJ75WYeeE402syI2eR3iksgV3fgVsDh6b/H1A0UUJFA=;
        b=pe5rmqz6/0zj/lJn87s6BELsja6LS4ZtnGIKEgiD3iUfQL0JJwpGDhi+8Vssfnf5uV
         Q8u/vEsV0pmL4Hu4WLS3eIZjBoLBZxSkz+Mry93zWkZyYzp1ShSsKHolzMbh0bQp1yvV
         ntlfbxlXmpbuf3dLFmctBRYOxdFc4JeVuUsFyl69cthSOdECjqF/gF6yRdOQnhjrg/97
         7MvDwBemQSxFi4cN4AAFARziIHPCazkDyFBcfP4f8bCq3nuaylMiAnowCLDuh2cVofpr
         WTKvcEK4j7zze3k9kH7GZxCHEtWkxxGvaBXd06m1Lk/mAkbN3P7isGYQeLQ9DbSyvD1I
         KP8w==
X-Gm-Message-State: AOAM531M1yXlljmCDl06TiOVeD9ol4w+8oWK1lKLsxD1aaE9qJaPdFX+
        MRSPAqdEeFU8ZXvR0ogLe4VDfAq+jQ==
X-Google-Smtp-Source: ABdhPJws7/1lwJd444bcGZFSy7g8L/2hlWkhTKEw6ZkttmyKw7CDyNJGjj0ygXucgK1mUpydZiYIAw==
X-Received: by 2002:a05:620a:2224:: with SMTP id n4mr9275988qkh.424.1626808932226;
        Tue, 20 Jul 2021 12:22:12 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id q206sm10174147qka.19.2021.07.20.12.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 12:22:11 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2 v2] tc/skbmod: Remove misinformation about the swap action
Date:   Tue, 20 Jul 2021 12:21:45 -0700
Message-Id: <20210720192145.20166-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720180416.19897-1-yepeilin.cs@gmail.com>
References: <20210720180416.19897-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently man 8 tc-skbmod says that "...the swap action will occur after
any smac/dmac substitutions are executed, if they are present."

This is false.  In fact, trying to "set" and "swap" in a single skbmod
command causes the "set" part to be completely ignored.  As an example:

	$ tc filter add dev eth0 parent 1: protocol ip prio 10 \
		matchall action skbmod \
        	set dmac AA:AA:AA:AA:AA:AA smac BB:BB:BB:BB:BB:BB \
        	swap mac

The above command simply does a "swap", without setting DMAC or SMAC to
AA's or BB's.  The root cause of this is in the kernel, see
net/sched/act_skbmod.c:tcf_skbmod_init():

	parm = nla_data(tb[TCA_SKBMOD_PARMS]);
	index = parm->index;
	if (parm->flags & SKBMOD_F_SWAPMAC)
		lflags = SKBMOD_F_SWAPMAC;
		^^^^^^^^^^^^^^^^^^^^^^^^^^

Doing a "=" instead of "|=" clears all other "set" flags when doing a
"swap".  Discourage using "set" and "swap" in the same command by
documenting it as undefined behavior, and update the "SYNOPSIS" section
as well as tc -help text accordingly.

If one really needs to e.g. "set" DMAC to all AA's then "swap" DMAC and
SMAC, one should do two separate commands and "pipe" them together.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Changes in v2:
	- Update tc -help text as well
	- Update commit message accordingly
	- Fix typo in commit message
	- Change title from "man: tc-skbmod.8:" to "tc/skbmod:"

 man/man8/tc-skbmod.8 | 24 +++++++++++++-----------
 tc/m_skbmod.c        |  5 ++---
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/man/man8/tc-skbmod.8 b/man/man8/tc-skbmod.8
index eb3c38fa6bf3..76512311b17d 100644
--- a/man/man8/tc-skbmod.8
+++ b/man/man8/tc-skbmod.8
@@ -5,12 +5,12 @@ skbmod - user-friendly packet editor action
 .SH SYNOPSIS
 .in +8
 .ti -8
-.BR tc " ... " "action skbmod " "{ [ " "set "
-.IR SETTABLE " ] [ "
+.BR tc " ... " "action skbmod " "{ " "set "
+.IR SETTABLE " | "
 .BI swap " SWAPPABLE"
-.RI " ] [ " CONTROL " ] [ "
+.RI " } [ " CONTROL " ] [ "
 .BI index " INDEX "
-] }
+]
 
 .ti -8
 .IR SETTABLE " := "
@@ -25,6 +25,7 @@ skbmod - user-friendly packet editor action
 .IR SWAPPABLE " := "
 .B mac
 .ti -8
+
 .IR CONTROL " := {"
 .BR reclassify " | " pipe " | " drop " | " shot " | " continue " | " pass " }"
 .SH DESCRIPTION
@@ -48,10 +49,7 @@ Change the source mac to the specified address.
 Change the ethertype to the specified value.
 .TP
 .BI mac
-Used to swap mac addresses. The
-.B swap mac
-directive is performed
-after any outstanding D/SMAC changes.
+Used to swap mac addresses.
 .TP
 .I CONTROL
 The following keywords allow to control how the tree of qdisc, classes,
@@ -128,9 +126,13 @@ tc filter add dev eth3 parent 1: protocol ip prio 10 \\
 .EE
 .RE
 
-As mentioned above, the swap action will occur after any
-.B " smac/dmac "
-substitutions are executed, if they are present.
+However, trying to
+.B set
+and
+.B swap
+in a single
+.B skbmod
+command will cause undefined behavior.
 
 .SH SEE ALSO
 .BR tc (8),
diff --git a/tc/m_skbmod.c b/tc/m_skbmod.c
index e13d3f16bfcb..3fe30651a7d8 100644
--- a/tc/m_skbmod.c
+++ b/tc/m_skbmod.c
@@ -28,10 +28,9 @@
 static void skbmod_explain(void)
 {
 	fprintf(stderr,
-		"Usage:... skbmod {[set <SETTABLE>] [swap <SWAPABLE>]} [CONTROL] [index INDEX]\n"
+		"Usage:... skbmod { set <SETTABLE> | swap <SWAPPABLE> } [CONTROL] [index INDEX]\n"
 		"where SETTABLE is: [dmac DMAC] [smac SMAC] [etype ETYPE]\n"
-		"where SWAPABLE is: \"mac\" to swap mac addresses\n"
-		"note: \"swap mac\" is done after any outstanding D/SMAC change\n"
+		"where SWAPPABLE is: \"mac\" to swap mac addresses\n"
 		"\tDMAC := 6 byte Destination MAC address\n"
 		"\tSMAC := optional 6 byte Source MAC address\n"
 		"\tETYPE := optional 16 bit ethertype\n"
-- 
2.20.1

