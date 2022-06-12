Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9097B547974
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 11:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbiFLJBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 05:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbiFLJAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 05:00:51 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CDC51E4B
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 02:00:49 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r123-20020a1c2b81000000b0039c1439c33cso1599384wmr.5
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 02:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QEsnoS6fs7x7z63+N74TXGO62/r4Rll/JtLDyGKeftw=;
        b=RyVH1BNMS71kJucK5zElSTO/iNUJtJ1wzfB62MK2wkxOOJQg/HG4FYnSYIx5b28jtI
         c1Wk6gsCMqqP+0DlffzZlNALt2iyg5mxWghT7RpQ3Yotns8G4e/n7SJRzvMrjiCaxae/
         PUMD95tfWDtLUEIwDO+4QJirah2khGY715i+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QEsnoS6fs7x7z63+N74TXGO62/r4Rll/JtLDyGKeftw=;
        b=wJRg8DU1WEKTOrDrn7+rwmj2NVdfkELVznQK+ZFldPIFpc+65MJ+ICqWrQQlZv7wOa
         eaJeJ6xontHik+CvC8BgeAWxu8f2bvJMB3VLfuSZbLWVmkMLqzNNUAT1FVXtzF3z+Ket
         TRsv6sMez6JOVLHcgMLU/pq/WJVBmdvZPP4TkMszzq0d+nTChdggcA6wYo1K9gUPsSAN
         Rx6ce7tpjEyEG/ftLZYoCOdC1ldi14f0uE8Far/WrY2DSnUS3pGgF1JRjJTFn/PG1uz3
         sZRw4I8XzJMi1UapEzocHFsDpyF0XgA7zxgM1d1kr8ZoJ1+2yhvaIp29njTj+G7Hj+3m
         UTig==
X-Gm-Message-State: AOAM530xyIJ9v5KAGu82Ho0Xk3EubbrmeiVIR7arsFoIXn8sCxN8mjgS
        yxBmKmdNzCFzHjIQGuIGYmGCuw==
X-Google-Smtp-Source: ABdhPJwXZyVpsGAIc5rt4KdnvnyW5tPEH0k/SyiM2mkjkdzxtxUdKAXvWaJOWLmn6Fb+SsUMSvmc1g==
X-Received: by 2002:a05:600c:4e94:b0:39c:81fd:6594 with SMTP id f20-20020a05600c4e9400b0039c81fd6594mr8030223wmq.198.1655024448441;
        Sun, 12 Jun 2022 02:00:48 -0700 (PDT)
Received: from localhost.localdomain ([178.130.153.185])
        by smtp.gmail.com with ESMTPSA id d34-20020a05600c4c2200b0039c5b4ab1b0sm4798603wmp.48.2022.06.12.02.00.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Jun 2022 02:00:47 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Joe Damato <jdamato@fastly.com>
Subject: [RFC,net-next v2 6/8] net: ip: Support MSG_NTCOPY
Date:   Sun, 12 Jun 2022 01:57:55 -0700
Message-Id: <1655024280-23827-7-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1655024280-23827-1-git-send-email-jdamato@fastly.com>
References: <1655024280-23827-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support nontemporal copies of IP data when applications set the
MSG_NTCOPY flag and checksumming is offloaded.

ip_generic_getfrag is used by UDP and raw sockets, so this change
effectively enables MSG_NTCOPY support for both.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 net/ipv4/ip_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf2..75c8627 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -933,6 +933,7 @@ ip_generic_getfrag(void *from, char *to, int offset, int len, int odd, struct sk
 	struct msghdr *msg = from;
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		msg_set_iter_copy_type(msg);
 		if (!copy_from_iter_full(to, len, &msg->msg_iter))
 			return -EFAULT;
 	} else {
-- 
2.7.4

