Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3205F03F4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiI3Eze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiI3Ez2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:55:28 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1F31162CC
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:09 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id d1so2208898qvs.0
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=vyoWUCAskGobFqxOR5uj1j2NUhtSVKk5WBoJwN5wJOM=;
        b=asHZFb/VUKMgzK4CVEmiLt+7uvI3UgwPfhzeCvPcUXHotPBSp6ci0hPrhgVlkbOk7m
         IGTfg4b+Fil/tliyX9UwsjVRNC9TjgezYtvmC6RSNoDTM2hc0ypUoqoytCrRuzYZTZTJ
         f1ftj5TBtDFaWrVqXdQUkGm+IrAD6GeD7JG2z6v3wcAbP2jyPurdVmteFHky7re4dbB8
         8vICKWmue9x6oU/uo8tOXEK+hctsieuYsnlvrInsnOE6je0B8MaNFrnVi+oJi4uxzyax
         eSkjAdOJ5Rs63k6Y/830MzXKrzhNB/qRP5FRrr3pQ7mjvK1jS0yKSts7FJinUotF1xvn
         3BdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vyoWUCAskGobFqxOR5uj1j2NUhtSVKk5WBoJwN5wJOM=;
        b=Rhwwh8q7dseTMS0aMUcUhFstNmbVgGttgsLlkQKBv1ag5zYuErOWcAMFYDgXtbJqAE
         XB5ERtlpOfbKjJoM1bDscyN6+N2CXplDjt7yfQG4VcBsntUGkRnvo+yqcCWOt9CDorII
         dMdAqWgcofFBDvDklW0v0wSQ60HxUxE3sXFyC4uutUfVxbcLfAKTK87HfEKqcziY8eO3
         SlBiI/GPAfqq2N+PhcTzOk1HmVWzThPays54tY4cc/5239ZR6VVyDWF6ZIQtUi48duV3
         HqEZlN2JCbaMjdQuAtM5LOVbsmkWWjgYRe0TOlu3BlcUsB6zoa4TDeA4saMdlqCVrIyK
         i0Vw==
X-Gm-Message-State: ACrzQf1kOs4o4SYaUtlzwNwX993qM/WT4O64g1rtFYvhJkMkOGI7VfLh
        AeG64MlVTFKy4zh6k4lWmbjarb5PYrgUeg==
X-Google-Smtp-Source: AMsMyM6yjw5FYY7askqAW41YfrgMmNQtYYFIGH9AA0uBFZdq4PhWlcPB2pNxtRRxXBlwATO9dGgAAw==
X-Received: by 2002:ad4:5d43:0:b0:4af:9350:440d with SMTP id jk3-20020ad45d43000000b004af9350440dmr5452602qvb.115.1664513637642;
        Thu, 29 Sep 2022 21:53:57 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id de9-20020a05620a370900b006bb82221013sm1550059qkb.0.2022.09.29.21.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 21:53:57 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 5/5] tcp: add rcv_wnd and plb_rehash to TCP_INFO
Date:   Fri, 30 Sep 2022 04:53:20 +0000
Message-Id: <20220930045320.5252-6-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220930045320.5252-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
 <20220930045320.5252-1-mubashirmaq@gmail.com>
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

From: Mubashir Adnan Qureshi <mubashirq@google.com>

rcv_wnd can be useful to diagnose TCP performance where receiver window
becomes the bottleneck. rehash reports the PLB and timeout triggered
rehash attempts by the TCP connection.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/tcp.h | 5 +++++
 net/ipv4/tcp.c           | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index c9abe86eda5f..879eeb0a084b 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -284,6 +284,11 @@ struct tcp_info {
 	__u32	tcpi_snd_wnd;	     /* peer's advertised receive window after
 				      * scaling (bytes)
 				      */
+	__u32	tcpi_rcv_wnd;	     /* local advertised receive window after
+				      * scaling (bytes)
+				      */
+
+	__u32   tcpi_rehash;         /* PLB or timeout triggered rehash attempts */
 };
 
 /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 685c06c6d33f..a0b518f63c3a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3936,6 +3936,8 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_reord_seen = tp->reord_seen;
 	info->tcpi_rcv_ooopack = tp->rcv_ooopack;
 	info->tcpi_snd_wnd = tp->snd_wnd;
+	info->tcpi_rcv_wnd = tp->rcv_wnd;
+	info->tcpi_rehash = tp->plb_rehash + tp->timeout_rehash;
 	info->tcpi_fastopen_client_fail = tp->fastopen_client_fail;
 	unlock_sock_fast(sk, slow);
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

