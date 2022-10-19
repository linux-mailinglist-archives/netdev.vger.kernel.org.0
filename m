Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C97604F7D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiJSSUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiJSSUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:20:08 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AFF10250C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:20:06 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id b18so23243335ljr.13
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bell-sw-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPh0u1BA0HQYxCfyWKJVzP0srDWIxJF+kLpCjGoUg78=;
        b=hEmS6GbI/1koN1G+CUVRnXrQLIwK/YMFTK3pq8IiQWlcOPyHOhGlqLkJSIsJ4pkJ5W
         kAFJ0Jtbai2QkstEWnIVaIUQAX6bvpLh/eDBWrqeZLB93CuSAXfWNxrHdEPx36f3oW6d
         UCSuzaNSu/yxSkIpkpGuyurdvv2y1XinbpD8yqb9kCxk5dmKE3cNBQeMhBHX+cxUqpMP
         88LCSe9jkw6y6AMcqP0m6uROGOEr+xPZPa0RO2UchKhFc0FD2ON2uMTUnRK6klnxm12X
         4X8W8PbEKD+SFHp1NjUTOYOMxI5TWMeQL0QuIKyYWD/dvvtBnGS+kCnXsHOKGO7TfRvz
         ocxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPh0u1BA0HQYxCfyWKJVzP0srDWIxJF+kLpCjGoUg78=;
        b=WRh44zqEdEIzdRM0CI9lYEvWwoAgVPvVdGeWGfAON5ZAvPFF146l8VPyQvsCAHA9Cs
         nWHoFZpe3Jo9vV3Pv/EzhJTwSNRJyub7AUjsU0ldbkNiVMhvdWdQ4fnDTULIqXF44YP3
         OJoqj0PBXDKO8jhn1HV5WyIhQNd8vgSSWlSsgwoNRozRZXTDoo6k2C8GoMezgHQwZO5w
         5M5RFq/yv/mzEO9jPE5T7IjrOkyL2VsxG9TdZFB5HUchY3xR3iBWvoIQmnh549MOGinD
         AaQr966zaFdrZMEGBSh6vmhMvQ9Is4Ntav8QDfYiICon5TiRKeBSPyPW/w7i1ZPiJQ+l
         uL1A==
X-Gm-Message-State: ACrzQf1pOJCO9XgV7BsxC7tPCUaLEIoH/84V+3QqVVwdQ7iPqjDLgwJh
        f82Xpx9kkfJzr5hkpQ7Gmqnq
X-Google-Smtp-Source: AMsMyM6NrfkHk+sR1M8XdMNeQ79MLvygM8kM/P9L44tE14vUcD3bKlRvYQKPjcfc3RdvCsrEkI31Uw==
X-Received: by 2002:a2e:88c2:0:b0:26e:2a8:d6a1 with SMTP id a2-20020a2e88c2000000b0026e02a8d6a1mr3393053ljk.131.1666203604807;
        Wed, 19 Oct 2022 11:20:04 -0700 (PDT)
Received: from localhost.localdomain ([95.161.223.113])
        by smtp.gmail.com with ESMTPSA id j23-20020ac24557000000b004a287c50c13sm2389916lfm.185.2022.10.19.11.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 11:20:04 -0700 (PDT)
From:   Alexey Kodanev <aleksei.kodanev@bell-sw.com>
To:     linux-sctp@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Subject: [PATCH net-next 2/3] sctp: remove unnecessary NULL check in sctp_ulpq_tail_event()
Date:   Wed, 19 Oct 2022 21:07:34 +0300
Message-Id: <20221019180735.161388-2-aleksei.kodanev@bell-sw.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221019180735.161388-1-aleksei.kodanev@bell-sw.com>
References: <20221019180735.161388-1-aleksei.kodanev@bell-sw.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 013b96ec6461 ("sctp: Pass sk_buff_head explicitly to
sctp_ulpq_tail_event().") there is one more unneeded check of
skb_list for NULL.

Detected using the static analysis tool - Svace.
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
---
 net/sctp/ulpqueue.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 24960dcb6a21..b05daafd369a 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -256,10 +256,7 @@ int sctp_ulpq_tail_event(struct sctp_ulpq *ulpq, struct sk_buff_head *skb_list)
 	return 1;
 
 out_free:
-	if (skb_list)
-		sctp_queue_purge_ulpevents(skb_list);
-	else
-		sctp_ulpevent_free(event);
+	sctp_queue_purge_ulpevents(skb_list);
 
 	return 0;
 }
-- 
2.25.1

