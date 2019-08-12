Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF48589EB9
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfHLMtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:49:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41653 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfHLMtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:49:21 -0400
Received: by mail-pf1-f196.google.com with SMTP id 196so2473073pfz.8;
        Mon, 12 Aug 2019 05:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wEbvzNsLC6y0503rph1qVfbXmE7y6KOKF1l8FURvlDQ=;
        b=fFdkO6sL5obFm0xjRUyDod3iaIgtlVK7itJHHUPFlC940iXJlaxuLQzVSVeDpkRTdV
         mQP6dvr20KUfxj2OldQRw3XKmrnHiSZUD8jwMHMwy9I3jIfciwnVtZ6BJlQI0uYqoJnl
         eL5dONkxHSkLlM6XrPsveXNIqGn//Yt4BmdgSW2LmovJFijeq1d8aSDhB6JEpGzh7LRG
         ZLr0xPFpI12rBYXY4EACQtCgSANgVuqF1kXK3izQc0HqykMgJOhE17e2d9Nrs9buItfw
         fvilDXBkkJrgmP//10xDg/TF0X1IqZvv1stRx80RCo3LMcGfUFiM3MkvzjOk8Wxl5S+U
         isag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wEbvzNsLC6y0503rph1qVfbXmE7y6KOKF1l8FURvlDQ=;
        b=s9yjJ464Ax4HcyVhxu/W6Nl5n2NF1QPklkr47vPrOvcHNoq2mpS1XW5kBE+VqO7jET
         0RcLSar43Ryz4iXrkLVP+X/cMVMl3fFpS0i5M5NbOOESYMyhubdOuwzSbcBZAExR9xWd
         RvW5X6+9D/5v/gtI0n9vxeJP2oFkbWKjpw6Pwdr4i5DEmQPNftYlUH+a7k8tU3Ftbwe+
         r9A4iDTjMrgrLBLaanNDOVdl37+i+zCpUjjyGAt5jlIkTIS/ZZKeIPPp43OU1RJDFoMU
         TccqNxIiTgPZejQOLXgywZ8ZCTi7nomhQyh8u9tmn2b4eFGMxgLOiqSvfKt+uEOz/50Y
         kqLA==
X-Gm-Message-State: APjAAAXHkOb+Y4mWOOONWETGpx/c2RaTe7aShdIj2VYfdrLxfuyPPzA0
        e0fD/66q2N2h/bPE3GmI2X0rtKaM3rw=
X-Google-Smtp-Source: APXvYqwODWRf37e6S0APoidGG1svBSDB1bGBTFUwtOaglcL1lEB9iRxh/CC/DZY2LGR1dT513lhvUQ==
X-Received: by 2002:a63:553:: with SMTP id 80mr30829037pgf.280.1565614160209;
        Mon, 12 Aug 2019 05:49:20 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j187sm12054180pfg.178.2019.08.12.05.49.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 05:49:19 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: fix the transport error_count check
Date:   Mon, 12 Aug 2019 20:49:12 +0800
Message-Id: <55b2fe3e5123958ccd7983e0892bc604aa717132.1565614152.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the annotation says in sctp_do_8_2_transport_strike():

  "If the transport error count is greater than the pf_retrans
   threshold, and less than pathmaxrtx ..."

It should be transport->error_count checked with pathmaxrxt,
instead of asoc->pf_retrans.

Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_sideeffect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index a554d6d..1cf5bb5 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -546,7 +546,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_cmd_seq *commands,
 	 */
 	if (net->sctp.pf_enable &&
 	   (transport->state == SCTP_ACTIVE) &&
-	   (asoc->pf_retrans < transport->pathmaxrxt) &&
+	   (transport->error_count < transport->pathmaxrxt) &&
 	   (transport->error_count > asoc->pf_retrans)) {
 
 		sctp_assoc_control_transport(asoc, transport,
-- 
2.1.0

