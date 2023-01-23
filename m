Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB56783DE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbjAWSAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbjAWSAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:00:05 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CE923D88;
        Mon, 23 Jan 2023 10:00:02 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id i9so7291947oif.4;
        Mon, 23 Jan 2023 10:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rte6+hTvGTi0zso5MYwzOe5jA6sy2ryoE/zhELkv8Wo=;
        b=cEmBoltaSyNL6vk2i77CSSe87Ql42R7QnLesXNAwHt7F5UM6qNIQMAguc4K8mHU6aS
         P1BRlOMn9MXcgXzaif3Qp6eOMjYcUZ7VhYBVASwDCMIVFQ5H9bPl508zGy/HiX4P0aUj
         JcblbwcFSD6WlFRt8KfOJE7LFE7x+CFO9DXNaaZzFpC0mb5edL+bUBGahrkwr9pANh8y
         +ykjtVBdAiV1tjjGeT9SlLvEzos4Gpj0pU01nuoQi+rlE//ipYytikUf3h1gZlNY5POI
         9poPLJympPk2lKzoeM5/YbN4jkt3RRZN1vtxbjuqnjd95cIWpJbv4qhL2fZxvWw8Z3PO
         nuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rte6+hTvGTi0zso5MYwzOe5jA6sy2ryoE/zhELkv8Wo=;
        b=I1nMCOCMkTEQpvdisuzZgTYQrkMSsTwpFYXKw3+Bw89Mr/cgO0vYK8Sqp66MuTSv58
         E2w33klfNNvPNup+zxdbHoaO1ve4WoXb7BJBzUijdS/pTgvs3tSzf0m5lHAkRl7A7C0t
         94iIWXjKcQrlE9HUbLx/kXZdY+iYQIEq2Zn5Zv7clGUkd9ZNKFwziQ1IIoX9wZRg5taF
         lB5tdtPwM7xVhXRvw7hsn6be7W4FrxC/SubPKMEx2rCSS0BmFgmIe10yu2GWE3HmOdCI
         a6pwc9n7vzkiBZooqwj/0OfeClfLSgGW6s639yt9Smn3m/sPrlYAQny2bLCYX1KSRBOK
         IyrQ==
X-Gm-Message-State: AFqh2ko7p2FTMusicZ+1oCu1QMXYNG/Oz/v8dKJPVGH9MI8svptyysSo
        RiZE/p5VqNLF3u1j9ToZZCkHSXOP6SY=
X-Google-Smtp-Source: AMrXdXvhtiCadsxGbL53BgoOFq/6UxMLc3Rw7jrT8Pjli5CA2474ii7A5Vo4GXmTpf+r2jCS32xyfQ==
X-Received: by 2002:a05:6808:4247:b0:36e:b7bf:e3d7 with SMTP id dp7-20020a056808424700b0036eb7bfe3d7mr6336241oib.52.1674496802121;
        Mon, 23 Jan 2023 10:00:02 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:d30f:6272:a08b:2b30:ac0e])
        by smtp.gmail.com with ESMTPSA id s128-20020acaa986000000b003648b84a2b5sm16562432oie.33.2023.01.23.10.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 10:00:01 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id EB3B14AECAF; Mon, 23 Jan 2023 14:59:59 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-sctp@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>
Subject: [PATCH net] sctp: fail if no bound addresses can be used for a given scope
Date:   Mon, 23 Jan 2023 14:59:33 -0300
Message-Id: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.39.0
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

Currently, if you bind the socket to something like:
        servaddr.sin6_family = AF_INET6;
        servaddr.sin6_port = htons(0);
        servaddr.sin6_scope_id = 0;
        inet_pton(AF_INET6, "::1", &servaddr.sin6_addr);

And then request a connect to:
        connaddr.sin6_family = AF_INET6;
        connaddr.sin6_port = htons(20000);
        connaddr.sin6_scope_id = if_nametoindex("lo");
        inet_pton(AF_INET6, "fe88::1", &connaddr.sin6_addr);

What the stack does is:
 - bind the socket
 - create a new asoc
 - to handle the connect
   - copy the addresses that can be used for the given scope
   - try to connect

But the copy returns 0 addresses, and the effect is that it ends up
trying to connect as if the socket wasn't bound, which is not the
desired behavior. This unexpected behavior also allows KASLR leaks
through SCTP diag interface.

The fix here then is, if when trying to copy the addresses that can
be used for the scope used in connect() it returns 0 addresses, bail
out. This is what TCP does with a similar reproducer.

Reported-by: Pietro Borrello <borrello@diag.uniroma1.it>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/bind_addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 59e653b528b1faec6c6fcf73f0dd42633880e08d..6b95d3ba8fe1cecf4d75956bf87546b1f1a81c4f 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -73,6 +73,12 @@ int sctp_bind_addr_copy(struct net *net, struct sctp_bind_addr *dest,
 		}
 	}
 
+	/* If somehow no addresses were found that can be used with this
+	 * scope, it's an error.
+	 */
+	if (list_empty(&dest->address_list))
+		error = -ENETUNREACH;
+
 out:
 	if (error)
 		sctp_bind_addr_clean(dest);
-- 
2.39.0

