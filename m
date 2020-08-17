Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA39246148
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgHQIwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgHQIwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:52:18 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1F6C061388;
        Mon, 17 Aug 2020 01:52:18 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ha11so7377044pjb.1;
        Mon, 17 Aug 2020 01:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vizVhQpfl/P3IK7pdHhXwQuZJfxeoLTLAQwlgNJNWDQ=;
        b=ZvtBicJ4SHYCH+T9jknNOHbGL5ebXQExMrnEngS40FAumeB0nrQtJxh7WcMySXmaDQ
         ak4WnkwOWVjRV315tOGdLCe/Mi10sI68E212P2cU9T8Qid/O9SKl6e3rgVQ7Z4acf2Vy
         AQ8w50xgaBk9idsZ8zZ8KX0FwdxK4fJCtxz8BYhpe7JR/qgUxVyVhym4Sq5oyI0/rOxh
         Sl1irBBzjVytyAvys0zlbu6OnAfAXtD8Apvp1JBzm96pAHcbc3TYOmCfwUp0W/HbIgCa
         ynXCtwGrz+hWLI63HITzVI8MA7NdK67qI012GX4nO76plWswzvHbiCu/5SVyLIYBylY1
         OqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vizVhQpfl/P3IK7pdHhXwQuZJfxeoLTLAQwlgNJNWDQ=;
        b=q6I8yskDflkAqDdTrroS1yqVqCSwR7NMTkYy6JipIAnlK00/Gw21hmOHIwLA2fbHHQ
         fmfSwA1tkTIVyNBJOW1IIeRIqHGE7n7C4Lu6BqRakjbnh6gWjgxKIoLakayveoead+d2
         fUpPsHdSFSXbSxdZlOMM/8r3RQV8FeSyNbZHOb02qxIm8RH/zJq5FfvCnMr1WwzVRzWo
         fnyLRjoebQPuqnRvgCfl4IL2+9m05vyNJzKo0vr6xQyI4VRYpgQ4bmBizsRFhiHSXo8Z
         3vrVdPXOMCFSQBDfWW/kCCVNJfTOqPaM0laKjG9naqq+DcrI5mVlQlt1qUDfb4g9Rngk
         rFPA==
X-Gm-Message-State: AOAM533VcswTlYfpwGTr/vqWNcc3ZBD5VWgvY9bIpMNlJAc58aYy/ML4
        kGw63gU1LFcKsEchNJb05ss=
X-Google-Smtp-Source: ABdhPJz0JVPD+0NkPV6g7YT8ZnT0v2Chrhm2dyQYkE8uYkF0hl+N5WY8lwYvVona5wPQ+g0GAcnB7w==
X-Received: by 2002:a17:902:8b8b:: with SMTP id ay11mr10720345plb.241.1597654337917;
        Mon, 17 Aug 2020 01:52:17 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id b185sm18554863pfg.71.2020.08.17.01.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:52:17 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     gerrit@erg.abdn.ac.uk, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 6/8] net: sched: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:21:18 +0530
Message-Id: <20200817085120.24894-6-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085120.24894-1-allen.cryptic@gmail.com>
References: <20200817085120.24894-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 net/sched/sch_atm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 1c281cc81f57..0a4452178d5d 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -466,10 +466,11 @@ drop: __maybe_unused
  * non-ATM interfaces.
  */
 
-static void sch_atm_dequeue(unsigned long data)
+static void sch_atm_dequeue(struct tasklet_struct *t)
 {
-	struct Qdisc *sch = (struct Qdisc *)data;
-	struct atm_qdisc_data *p = qdisc_priv(sch);
+	struct atm_qdisc_data *p = from_tasklet(p, t, task);
+	struct Qdisc *sch = (struct Qdisc *)((char *) p -
+					     QDISC_ALIGN(sizeof(struct Qdisc)));
 	struct atm_flow_data *flow;
 	struct sk_buff *skb;
 
@@ -563,7 +564,7 @@ static int atm_tc_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		return err;
 
-	tasklet_init(&p->task, sch_atm_dequeue, (unsigned long)sch);
+	tasklet_setup(&p->task, sch_atm_dequeue);
 	return 0;
 }
 
-- 
2.17.1

