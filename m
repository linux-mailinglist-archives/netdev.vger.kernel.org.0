Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CE11FFC93
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgFRUgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbgFRUgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:36:42 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF23C06174E;
        Thu, 18 Jun 2020 13:36:41 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id n11so6945893qkn.8;
        Thu, 18 Jun 2020 13:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=NEoxghrRUhl5ceeHjhF2kNYMbCKr0vgXum9mS/e/H34=;
        b=In6Efq2RbfxHnF/MHdFcWVN6yrO4N3Cee0BWRcVxosKunH0hv3PAvDs2QM65kREgFH
         d9KNsTXMhUEXDqJCIKVDaqTHRCsEUnWcT+qJ9ZMj39+WUi/oeDamzAGr/EHg6sLvodxg
         IL1xZ7u5xUXa/Y28OvoKLZ418A2fA7IG1dNDF4RD8YQGAH+s2Ehnrc1lgqQ5z6asINUH
         ZlKRIpNTCEVel7zK8ddo6QwSlpB147Sc5fGVmhwCKCzurBLukEtUiyrsZVOIZsMvwlGN
         PHK+skevoIhzGjGf3HWrYO1Aek8vBYeJe3DByhN+KWOhGXz/KoEhPzIevjRvXkkC2GMd
         Ljaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=NEoxghrRUhl5ceeHjhF2kNYMbCKr0vgXum9mS/e/H34=;
        b=ik/Bim4suVA5hnBW8W8dW6H/uAwxnSCJHFy2JTDOXFd5sizIKwFfZjR+Tsuru1KtuY
         2q8WBpGwxGJBiF/rFRujRiNUD3t9baO5dz/165QF+XeRDA5IMseR+2/BNpw66XX0Muy0
         gl3gwdSsd2cUFScObNiUZJBQ0lO6G7XHUCjemeOsFsOeIJbuz9/5+gon/00+4s3fPmuy
         ZRU2GZTVaiI8mmIJgLGbCDZzGkwqHHo9y6t+ulzg7SKpNkGAYtSMBPQFaaNmwxW+bn5B
         fXMSV669FxVuH+OIFbw0AdAwXEKWoVQkgkmSZ4DHT9yTJnmnes89+ts++DWOSW6EkOUz
         3m+A==
X-Gm-Message-State: AOAM531CzFKj6pL9JmdgJ7am6YUOBjTYdLFn4yvXFB6NseMD+iL/fgnf
        KkPuBVN0gyba6xLuzknxoas=
X-Google-Smtp-Source: ABdhPJydw1D+WWgIU4/O5i1SIRQbQk5K5SCKueg5rQfMKoJW7gi6QO30Ux1t9XU17rDmJphExMkkmQ==
X-Received: by 2002:a37:7902:: with SMTP id u2mr239777qkc.53.1592512600599;
        Thu, 18 Jun 2020 13:36:40 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:25ba:8256:21eb:97ae])
        by smtp.googlemail.com with ESMTPSA id n2sm4092745qtp.45.2020.06.18.13.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 13:36:39 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:TC subsystem),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/sched]: Remove redundant condition in qdisc_graft
Date:   Thu, 18 Jun 2020 16:36:31 -0400
Message-Id: <20200618203632.15438-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200618040056.30792-1-gaurav1086@gmail.com>
References: <20200618040056.30792-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parent cannot be NULL here since its in the else part
of the if (parent == NULL) condition. Remove the extra
check on parent pointer.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/sched/sch_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 9a3449b56bd6..11ebba60da3b 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1093,8 +1093,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 		int err;
 
 		/* Only support running class lockless if parent is lockless */
-		if (new && (new->flags & TCQ_F_NOLOCK) &&
-		    parent && !(parent->flags & TCQ_F_NOLOCK))
+		if (new && (new->flags & TCQ_F_NOLOCK) && !(parent->flags & TCQ_F_NOLOCK))
 			qdisc_clear_nolock(new);
 
 		if (!cops || !cops->graft)
-- 
2.17.1

