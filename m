Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBC954FE29
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiFQUKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiFQUKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:10:50 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1BB91BEA1
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 13:10:49 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id y13-20020a17090a154d00b001eaaa3b9b8dso5051033pja.2
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 13:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tccD4MmsP0xHKohZBq3Ps9T12PcELQPvXzPShxybJLE=;
        b=QT6a/WkAV6/jo7MSsI8E3S/j8NvpuBCBy+f/suzqUlY4m5HI23+TWp17rDtMqyguT+
         kLznGvlEqxsp4MuH3S1RlqywOirKCdTINIIY4Yyc4OuZUjsvmdJjoK0/kl/6Zlujku5X
         XqvDVjsM8qwsEwWgqiYk6Xyh2sDfANUd28R3q3zqVjp5dClUv2jNmDUTUPA7wlIWYnXZ
         pnP3zlOwhoqo7rkIjrOKD85COHI/+ENIa8ODlDlWorAzRNGyZSlLHHQYZmjIawjNUnbU
         E2zqz/U1ifoCNgvtdLwMbxC6xic1kZDtEAwuCOMDw8XeK9YjqdUaeR3LYVspvDsrXhwO
         BJLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tccD4MmsP0xHKohZBq3Ps9T12PcELQPvXzPShxybJLE=;
        b=xs/1aLR7ZR6bk6Nh5AoZEO+aOt2KFXj2eJC8xofefpwVDwRnpNvHTvbr/rfkhrnjNn
         IpHLkiCKssJ07rSwVirqr+txD3oGN2IodDfx4v9mTAO5WHpHtUswn2z2WpGsLJqa+/Z0
         fRvtgTz8n4Nt0X6N9TDa1S39YpRzbnbhrhywrtQdqYBezFQLTa9sJ3lcYOhEnDf0LAa2
         UWx8GhmOfbZepnOG129mWBmeFDvprRZUNQ7kOj2sg9I2nNlhpBncbyfua4QoVCKVCZEz
         424umwYSPIBMwRaK6/AnGkgjHZKYRjCVerhFEGvGUbGpgvaDyJILR3V4gwOeNbOUzWE0
         mmYQ==
X-Gm-Message-State: AJIora9+ZirmCEDfKLB5yeF42eEjPDtNZkGk/TZfAYf1edLqYpjqDcHR
        TyZxad3RiSkMMp6e/GYen84=
X-Google-Smtp-Source: AGRyM1s16YEEr2UyP9WPZzFxtk099lCuJqU6h4fLlyQY9l7Fjtt7CvXfSBTfPuiRwvVRM8MwT98kyQ==
X-Received: by 2002:a17:90b:1a8f:b0:1e8:7dfe:c4f with SMTP id ng15-20020a17090b1a8f00b001e87dfe0c4fmr12339485pjb.17.1655496649195;
        Fri, 17 Jun 2022 13:10:49 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d5d2:fc18:6baf:e16b])
        by smtp.gmail.com with ESMTPSA id ja14-20020a170902efce00b00168adae4ea2sm3931758plb.39.2022.06.17.13.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 13:10:48 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] raw: RCU conversion
Date:   Fri, 17 Jun 2022 13:10:43 -0700
Message-Id: <20220617201045.2659460-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
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

Using rwlock in networking code is extremely risky.
writers can starve if enough readers are constantly
grabing the rwlock.

I thought rwlock were at fault and sent this patch:

https://lkml.org/lkml/2022/6/17/272

But Peter and Linus essentially told me rwlock had to be unfair.

We need to get rid of rwlock in networking stacks.

Without this conversion, following script triggers soft lockups:

for i in {1..48}
do
 ping -f -n -q 127.0.0.1 &
 sleep 0.1
done

Next step will be to convert ping sockets to RCU as well.

Eric Dumazet (2):
  raw: use more conventional iterators
  raw: convert raw sockets to RCU

 include/net/raw.h   |  16 +++--
 include/net/rawv6.h |   7 ++-
 net/ipv4/af_inet.c  |   2 +
 net/ipv4/raw.c      | 150 ++++++++++++++++++--------------------------
 net/ipv4/raw_diag.c |  41 ++++++------
 net/ipv6/af_inet6.c |   3 +
 net/ipv6/raw.c      | 119 +++++++++++++----------------------
 7 files changed, 148 insertions(+), 190 deletions(-)

-- 
2.36.1.476.g0c4daa206d-goog

