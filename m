Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB4695091AA
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382038AbiDTUzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238578AbiDTUzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:55:32 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A7C1ADAA;
        Wed, 20 Apr 2022 13:52:45 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q75so2173080qke.6;
        Wed, 20 Apr 2022 13:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cScurUMpYFRygaW6/SiHr7VE5fv8vZDygvnl1ZVKk1Q=;
        b=pmRo+iuKIEfPCaM59DnAIZqj1JQD1PdLf8Uw8qFUwq/w/vRYbgy0JYB2fD0vXT4pgT
         k7cG5olVjALJLnibzW0uMMPp2wP0Yj+SBWj/8pNtMxGhXbIsM5NXhXx99C53eD54IruZ
         k3ENDY6oucsuvxSRoZ4HsuagIXEyr7P+fgsHcLdTPHNVNIe7mZyS8wxvlEpLNIBbZOEm
         S7xwiqGmQ/lNGF5LAfMzmIQErt4MNXhIGGcsIqJoTv/LG4VS2A8aAmNx5N5cHM/zW7z+
         8kw6NuIys8wu3SZLbUYOYwHX7buQ1rT4ZV5r1Z79Hy7cXBfqbdWVx1mY14r+X8ZUZj1Q
         ldZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cScurUMpYFRygaW6/SiHr7VE5fv8vZDygvnl1ZVKk1Q=;
        b=RlKKC7moGjJQVXwgK4gnY7ElkyUGOK+6YId1wGvJ8e8ffEx7L9r/Zgrvj87YU/WTiG
         uS7qeysEzmU57oUaxa3YEneVH5vPWuARRRxcPzUhVUQlbmwuzq0AlJ2ulD0USbuAdFsV
         PjI1UAUQXEZUOFBtnzK66XaibSxxT9aVQ0FutwM7XGFFxW5Bozfy3ilm2Fq5JtI2ARIw
         b7djDFz47mvAvZlb2qhnQUt4pOGzZe232a+17kameUz+IzvWn/LvsNCcjczfIliWdZUQ
         FGsDvAi889uiObomPteEuxZK9xeFJ9UDTmLrtS5bgRFkN3Palb5EVydmhkHe7ZbZe4FZ
         jk1g==
X-Gm-Message-State: AOAM5305lAjT/jARxMhjTMDvY45TyVcpaA4wG6E0NgdfTnPKW/VXV1Vk
        uoRbXZYnmSa9s2PFxd9CmgQitjtRGyOI1g==
X-Google-Smtp-Source: ABdhPJzqQOOtJRmj/yGdYQ817Q66sX9m+I8wr+mgbfUsXpu0ku2jOuc+yguogDN3xZ5D41UN6EZ14A==
X-Received: by 2002:a05:620a:bc8:b0:67a:fe6a:22ac with SMTP id s8-20020a05620a0bc800b0067afe6a22acmr13630180qki.28.1650487963663;
        Wed, 20 Apr 2022 13:52:43 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 187-20020a370bc4000000b0069c8f01368csm2060445qkl.92.2022.04.20.13.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 13:52:42 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: check asoc strreset_chunk in sctp_generate_reconf_event
Date:   Wed, 20 Apr 2022 16:52:41 -0400
Message-Id: <3000f8b12920ae81b84dceead6dcc90bb00c0403.1650487961.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A null pointer reference issue can be triggered when the response of a
stream reconf request arrives after the timer is triggered, such as:

  send Incoming SSN Reset Request --->
  CPU0:
   reconf timer is triggered,
   go to the handler code before hold sk lock
                            <--- reply with Outgoing SSN Reset Request
  CPU1:
   process Outgoing SSN Reset Request,
   and set asoc->strreset_chunk to NULL
  CPU0:
   continue the handler code, hold sk lock,
   and try to hold asoc->strreset_chunk, crash!

In Ying Xu's testing, the call trace is:

  [ ] BUG: kernel NULL pointer dereference, address: 0000000000000010
  [ ] RIP: 0010:sctp_chunk_hold+0xe/0x40 [sctp]
  [ ] Call Trace:
  [ ]  <IRQ>
  [ ]  sctp_sf_send_reconf+0x2c/0x100 [sctp]
  [ ]  sctp_do_sm+0xa4/0x220 [sctp]
  [ ]  sctp_generate_reconf_event+0xbd/0xe0 [sctp]
  [ ]  call_timer_fn+0x26/0x130

This patch is to fix it by returning from the timer handler if asoc
strreset_chunk is already set to NULL.

Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_sideeffect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index b3815b568e8e..463c4a58d2c3 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -458,6 +458,10 @@ void sctp_generate_reconf_event(struct timer_list *t)
 		goto out_unlock;
 	}
 
+	/* This happens when the response arrives after the timer is triggered. */
+	if (!asoc->strreset_chunk)
+		goto out_unlock;
+
 	error = sctp_do_sm(net, SCTP_EVENT_T_TIMEOUT,
 			   SCTP_ST_TIMEOUT(SCTP_EVENT_TIMEOUT_RECONF),
 			   asoc->state, asoc->ep, asoc,
-- 
2.31.1

