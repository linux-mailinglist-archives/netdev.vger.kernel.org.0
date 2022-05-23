Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76027531434
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbiEWQRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238775AbiEWQRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:17:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4068766CAA
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:17:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i1so13547277plg.7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=JJ9O94LWyONJPW7brV9wPeM6lmosffoWy6ACm3ZE3ik=;
        b=UJWImAy+FN/5FRntr2a/m9HmfijIWIJgVqAXsSJk1jlW0fDne55+vQhDFlgRrveC08
         IB73HIdkYkfiVTIEddbVfaJul5pb7F5KOlYb5Yy0N1/IH9h8AvU3JdNzgy6FuA3iTDU9
         kL8IBjkFtSfyThp0GviwcCxS2aPhqGDHzqNFJOMUgXFgJf3MkshDNg3geqcop5h76ab0
         Gw8Sqm1iokXU1baSPhrmn2tTZ1vky/ru7pPE2eRnte+xL4tJV3VzXgXxLtMgV4dTwP8o
         11tkochucanVlN+9LIhL1PW1napTVKbWlB1msPez+XY9OMabCuuggasYHZycAeCxg/aE
         AoBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JJ9O94LWyONJPW7brV9wPeM6lmosffoWy6ACm3ZE3ik=;
        b=5AzuzJ0MBEbulzbrR9PKZthbCtedPCvRI+rvsXcLloLD518cxqBtvTnjOjikJ9gp+c
         4w4D2vpT5Gj7NjvU4wu6MXHnhijL8WdiNhYuzyQLTsfMpiOz02tEgb0Z43VUJUKRoxqz
         N76I8xDEd5Nbna/yJdBGwIYTiaE5+FOvx8AkOKk5gAU7WtWTYGGulU+VAPOvAdY5KfT4
         5ZzsGOZXPqrbAmf3ytGiUV59EO0N9eDSq9O1tFQEldLdnsQY9yqTNJPBM9XX0KmtjQB3
         O4Qz/QxuR++lnFlzvBvQGjiLe3RK/vPoJSMZe6pG0sEnZ7XtqiAXcu8WHd9d5kwWw62V
         QSGQ==
X-Gm-Message-State: AOAM531tMKo/KAO4Q7LN92SOackiLclWoklpJUXeVcj9ye9T59Bj651e
        RPddK05ZU0F7JT0YomcUDS4cyxPsKx0=
X-Google-Smtp-Source: ABdhPJxIgqQKMtIHcT0o7Ba6cNIRZOrucleQwNcoJRYYVvYs2C2sIO2uGteuNycF6ZRmAzTg8l1MAQ==
X-Received: by 2002:a17:90a:e7ca:b0:1df:34ec:1fca with SMTP id kb10-20020a17090ae7ca00b001df34ec1fcamr27126861pjb.195.1653322638128;
        Mon, 23 May 2022 09:17:18 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id c8-20020a170902c2c800b0015e8d4eb2ccsm5252127pla.278.2022.05.23.09.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:17:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/3] amt: fix several bugs
Date:   Mon, 23 May 2022 16:17:05 +0000
Message-Id: <20220523161708.29518-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes several bugs in amt module

First patch fixes typo.

Second patch fixes wrong return value of amt_update_handler().
A relay finds a tunnel if it receives an update message from the gateway.
If it can't find a tunnel, amt_update_handler() should return an error,
not success. But it always returns success.

Third patch fixes a possible memory leak in amt_rcv().
A skb would not be freed if an amt interface doesn't have a socket.

Taehee Yoo (3):
  amt: fix typo in amt
  amt: fix return value of amt_update_handler()
  amt: fix possible memory leak in amt_rcv()

 drivers/net/amt.c | 6 +++---
 include/net/amt.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.17.1

