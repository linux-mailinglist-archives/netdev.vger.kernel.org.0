Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985A41FE9BA
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 06:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgFREBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 00:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgFREBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 00:01:04 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F30C06174E;
        Wed, 17 Jun 2020 21:01:04 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b27so4351346qka.4;
        Wed, 17 Jun 2020 21:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=nLCU3BeAJp62oE0ohSEc7wdaroH7R0ZRm4fHrbC9orM=;
        b=LqlHSuLQ65Np1zhkoayftr2UXNQ8eEE/M4V6/MFxrelBs7C8VOxPv3o2ZFzdheHTbr
         l/2+1okJK1OxCUNvq4/aVlnJOpOZzOuFj0JJX1t7R5Uy0pvGhXAFxF2Yy+Es9W/cSruH
         iWZspYZ8O+MYwOqgxjEWFUIRn6w7JjXqe5Bkb0fqcn6f9H+0w5nzfhmp+4fxoN13tzeK
         c6iQRDmwMGv0DA8Aw0711xADXWdoN5QgZfaBk9oeAKayvRVb4Ja/yPwSLoVGKQxgAxc/
         LJJlmHa4bWyTgQga6AICtXkXk00rJ63uHpZaiqpxsrsBJsqsqLJD58/3HIBvrNfdChjF
         UdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=nLCU3BeAJp62oE0ohSEc7wdaroH7R0ZRm4fHrbC9orM=;
        b=Y8zc0Osk41Y9BfY2g+6wDOc6VJh+7mKtonn1pBrQl0TKpHEldTtIR5sNQ3ZWqPzUvu
         y+BgxnAI7SJt/ImHWhW2tMaubI77R8siZJC5pcQm8n0twG6tq4x4xmAYkKfnaPCXY71h
         f39XyKUfy7imDS1rXUUJ0cavrAsB1jTYLLCds7Zr3AtsvkLqd/LfdnWyLg36qynsUvFp
         jODJNHUIO7ErQY3SKmXL10hzhYfMxEvQ+wTJPwCQifdAhldv8+qgqOCaAPcub/2nF0ka
         KmtI7pB9lF1LQMY4+5qvpTnOl50ngrMeQQkzHUqFXWZXfrg2CQZah6JNEP1V2/Li3KbG
         4yrA==
X-Gm-Message-State: AOAM533sf3YCP/cLwhxX7QmAvtG07JrJvsomEmPKigPxMxrQPQUJX8EG
        Xsl8OHlyFPXh3sVwySUH/6s=
X-Google-Smtp-Source: ABdhPJwX0x0Vg27Ije6SK4gt0QVQGyehvhGJ5GqW0IowRD2zcddjX/tJVgUvFaeR4OGk+M0uONehUQ==
X-Received: by 2002:a37:850:: with SMTP id 77mr1894189qki.498.1592452863605;
        Wed, 17 Jun 2020 21:01:03 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:9c3:b47c:c995:4853])
        by smtp.googlemail.com with ESMTPSA id m53sm1948825qtb.64.2020.06.17.21.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 21:01:03 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TC subsystem),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/sched]: Remove redundant condition in qdisc_graft
Date:   Thu, 18 Jun 2020 00:00:56 -0400
Message-Id: <20200618040056.30792-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618012308.28153-1-gaurav1086@gmail.com>
References: <20200618012308.28153-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parent cannot be NULL here since its in the else part
of the if (parent == NULL) condition. Remove the extra
check on parent pointer.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 9a3449b56bd6..be93ebcdb18d 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1094,7 +1094,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 		/* Only support running class lockless if parent is lockless */
 		if (new && (new->flags & TCQ_F_NOLOCK) &&
-		    parent && !(parent->flags & TCQ_F_NOLOCK))
+			!(parent->flags & TCQ_F_NOLOCK))
 			qdisc_clear_nolock(new);
 
 		if (!cops || !cops->graft)
-- 
2.17.1

