Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F1152411A
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349386AbiEKXiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349372AbiEKXiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:06 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98EE980B8
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:05 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 204so3284573pfx.3
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yOgD8n5meg7ofEW5JqI3SftRDBRm5coeT04EbI5g5IQ=;
        b=Rq0T+l3sO2dSmDhqKahCuq5GYyNU92IlSrKnI2GtCSjd+KvR4WgRz7Eej1ZaGw7OL2
         wSDYnZVm7ydKP54H96aRDMYyNAzzEoCXqyLw4vlNMqQveCPNpapEvm0xr95Z9btGXGqg
         dMUSs+G2qCok2IOfATdtnclxGem/Wj5ptedMwP7Ryqwpzzn8eBcDppHU3nf1qxBGffvz
         dXE70e+HFv8X3JLmU+lULAi47vnuhaVVStCDwWI4truR8eYdZZRnTXo8rq0c6AVcJLZr
         Qye680UUW80llTjf5taitbs2UFSCqCvjAOEMFgyAb9askkmfuCRIQAhsQzL3Hvreoknq
         cUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yOgD8n5meg7ofEW5JqI3SftRDBRm5coeT04EbI5g5IQ=;
        b=2zQx8sN9S6yXuTi4BF0wb0jpdX5wFgD23SMHQm9P8JK7fko2ZruNSG9cnHV2hHSbT3
         N4yBqX+wfXNbSoeDm3iaFv0dn2SCPh4WuZZiS9cWQGPwYmSdp21TFBREbuUpR9zZPrLc
         cJKF2BcRksmS0cKIrm1GRO+/mtlzMneRUN/AasJajLkkXqhLaWx7L8PuhiCNeiom2B6W
         51NSAN5nXzelI4J9H+N8S4WPPZ1LFbHzebg3LfhhDpr5R4jfBrb1Z52LDD4V0eUEKpsC
         fS3Qf//H8KeP5HEgBUY8EjAKww7KybT6Z0kPDojcvPflYZ7B4wzILKb5TSOK4nPLJcdG
         tKsg==
X-Gm-Message-State: AOAM530u9rGKqpZ6gOR1BFI9X0sS4OlIyAdTFIOjFJuVGqSTJwKmcpeA
        uzsZJM3oMdCMW+106t45SO4=
X-Google-Smtp-Source: ABdhPJzz41DjgBULgr5CrIiHY379idlSTdKnbzcuZOoec8mFH5iFtzhINPjBn3slm0FgVMeW0qTRRg==
X-Received: by 2002:a05:6a00:450e:b0:510:88c8:7d33 with SMTP id cw14-20020a056a00450e00b0051088c87d33mr24901377pfb.27.1652312285210;
        Wed, 11 May 2022 16:38:05 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 02/10] sctp: read sk->sk_bound_dev_if once in sctp_rcv()
Date:   Wed, 11 May 2022 16:37:49 -0700
Message-Id: <20220511233757.2001218-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220511233757.2001218-1-eric.dumazet@gmail.com>
References: <20220511233757.2001218-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sctp_rcv() reads sk->sk_bound_dev_if twice while the socket
is not locked. Another cpu could change this field under us.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sctp/input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/input.c b/net/sctp/input.c
index 90e12bafdd4894624b3a63d625ed21c85b60a4f0..4f43afa8678f9febf2f02c2ce1a840ce3ab6a07d 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -92,6 +92,7 @@ int sctp_rcv(struct sk_buff *skb)
 	struct sctp_chunk *chunk;
 	union sctp_addr src;
 	union sctp_addr dest;
+	int bound_dev_if;
 	int family;
 	struct sctp_af *af;
 	struct net *net = dev_net(skb->dev);
@@ -169,7 +170,8 @@ int sctp_rcv(struct sk_buff *skb)
 	 * If a frame arrives on an interface and the receiving socket is
 	 * bound to another interface, via SO_BINDTODEVICE, treat it as OOTB
 	 */
-	if (sk->sk_bound_dev_if && (sk->sk_bound_dev_if != af->skb_iif(skb))) {
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	if (bound_dev_if && (bound_dev_if != af->skb_iif(skb))) {
 		if (transport) {
 			sctp_transport_put(transport);
 			asoc = NULL;
-- 
2.36.0.512.ge40c2bad7a-goog

