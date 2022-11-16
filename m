Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D8562C962
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbiKPUBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234780AbiKPUBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:01:30 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8D2627D9;
        Wed, 16 Nov 2022 12:01:29 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id z6so11447141qtv.5;
        Wed, 16 Nov 2022 12:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3grqxCjJ0FJboCJuXL1kuIKZVHmc0HhkHBhsbXQ5EeA=;
        b=eODxpzD+5ty19uRevKL1QNu1oRHIn17NM2SlSb2wel5r49Cr16DCS31rvzg02m1Xhv
         vv6fwvBLr6yd9oxDGGFOPmelCVtp6pd3LLpI9Sst58ZqyUwoJmzWIGnGz+TR8Nre6UpZ
         Hs5SWbfS893Gu06mYsVO5IwcQYdPdUi0olHEqaLS+BxkKHfDC1QuIumKmpcqvFZ0okHm
         NBEOf1C1o3ZtWpozfSJIRMdTqk7nZw3ULc6mJl0gxIji4ALJh6Jb3dtHSKnxr9jHdIPA
         4uDKW8qo6XnDEotrp60Gyh/3VQHj0s6O7/bFlEEpvTvFTj/gHF7B07Hx8LqhauOm7PnP
         i7vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3grqxCjJ0FJboCJuXL1kuIKZVHmc0HhkHBhsbXQ5EeA=;
        b=pVh+tNRTzCXpQorVEHr5ic8s8FcIuwt8B3faDBqTid52EMcHYP4X8MackIu8txrJ3P
         9DNVXV/pp3G7vu3UanFfWfUOhxphI8emvl6dFDFDaHjg8m+etHgSDpArDdbsm8+NgVI8
         sitqpSvtNevMvrs7UaQTIEIzziKQ3J6I0LN1uAQHnqcoPkwKm4iqaYKkD4q1m0FwakuI
         0zAaX9E4mLUhxfJ1LGAinJ42SnX/sj+sip4nXRKS6zhv2oADiyvTnV5G1Pj11kK0SXYq
         nQkHpP6vLr99pBX1X7ztIXTgn29wcW1gYsSLtbUJ84bh7tLUGvbmN0OvPtTrDGhTXSs+
         CZtw==
X-Gm-Message-State: ANoB5plHmVXcwABdyDEmd9RDZtb76pRck0S9/C6VXJ/4WjBJTB37oORa
        r2fRtMTcId7tkQtrIwIUpXAx/E3tK8oEKQ==
X-Google-Smtp-Source: AA0mqf6GqD9/n9o50Dci2/c28o11iex74413M1zdm//knjzEpJ2ll1sdY9BFQP8d3Ze0eutBapLWjg==
X-Received: by 2002:ac8:4f53:0:b0:3a5:5e38:c294 with SMTP id i19-20020ac84f53000000b003a55e38c294mr22129469qtw.122.1668628887934;
        Wed, 16 Nov 2022 12:01:27 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d7-20020a05620a240700b006fba44843a5sm2900411qkn.52.2022.11.16.12.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:01:27 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCHv2 net-next 1/7] sctp: verify the bind address with the tb_id from l3mdev
Date:   Wed, 16 Nov 2022 15:01:16 -0500
Message-Id: <8c4e5cce13bce15c1b58ff647539a774fe04b707.1668628394.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668628394.git.lucien.xin@gmail.com>
References: <cover.1668628394.git.lucien.xin@gmail.com>
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

After binding to a l3mdev, it should use the route table from the
corresponding VRF to verify the addr when binding to an address.

Note ipv6 doesn't need it, as binding to ipv6 address does not
verify the addr with route lookup.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/protocol.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index bcd3384ab07a..dbfe7d1000c2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -351,10 +351,13 @@ static int sctp_v4_addr_valid(union sctp_addr *addr,
 /* Should this be available for binding?   */
 static int sctp_v4_available(union sctp_addr *addr, struct sctp_sock *sp)
 {
-	struct net *net = sock_net(&sp->inet.sk);
-	int ret = inet_addr_type(net, addr->v4.sin_addr.s_addr);
-
+	struct sock *sk = &sp->inet.sk;
+	struct net *net = sock_net(sk);
+	int tb_id = RT_TABLE_LOCAL;
+	int ret;
 
+	tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ?: tb_id;
+	ret = inet_addr_type_table(net, addr->v4.sin_addr.s_addr, tb_id);
 	if (addr->v4.sin_addr.s_addr != htonl(INADDR_ANY) &&
 	   ret != RTN_LOCAL &&
 	   !sp->inet.freebind &&
-- 
2.31.1

