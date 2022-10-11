Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A265FBCEF
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 23:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJKV2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 17:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiJKV16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 17:27:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C349C2D8
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:27:37 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so182263pjb.2
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 14:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oAiEbA6JueVJprKHbFK6SigvxHa9ncyFYDwcHVSWp54=;
        b=O3rU/0lalQGgT4H2ZhJhSw1Tsdgk+CIkPmRVIJID6iHAgl+ez5ZMIxlqMm8RlAubJD
         6fNhCR2UTbKUy4xoRJ3XFmzMLvKN45v+NqTqBA+lZ0aUu0E+mg9BI976KezzltvhCNE3
         7jakwVISuM6fQy+MFX5monTARMpgLv2KicRkX2vTirNsZj4dGaK5nGH4P+j1YcUqQ7F6
         Y0M9vao3nsK+R7Gc+tU296fIrE0CiUrlZR+WviWjirCT77GYpxULWhcK4KmfZvIyeEFw
         55nVq//tNRrm3/7Qo4vLrTB/3lbI1WgVJ3EbpgMYVM2ifb1zGn4MCg7/V/Np2ys3zqgY
         md6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oAiEbA6JueVJprKHbFK6SigvxHa9ncyFYDwcHVSWp54=;
        b=Q8AnsXgs3cqShLqJg/HES7cSUxqDCp6ZEmGd0mGXl4RnpQuHCIYaO/DCu6gF1Ngsrz
         FH6/8l9rzS+x14ojNUvpnJ7ZAbeM4SUZOZO2GR7z8FaYt/LhpRzBpyzvmyA0YuNIvI6T
         /wtNUnFkG4AJFSgbhZL0aHpZfzG+llX23+VJ8Qdyc/nkI6bd7Zkmt0lMkpzJliTGhT/R
         aC80zdAHt0eCwaDlijtUx3aTBDoa+5m1Ka9NuEwIG8ASrGrE/OaOGYAFxaekK7ng6jnu
         MkxSIyWrbnaUXH+TPPG68v8m+u70s/g704SA7dpqchVRWCZv/WnbEhhohSL1McXFC22K
         AVkQ==
X-Gm-Message-State: ACrzQf152GmBFuZW8p6SRty7mGJk7aLG0u0I2llaer/EWOQ4Nb2/oKIx
        aDZH8AT1AwyvK+6pXnFd58M=
X-Google-Smtp-Source: AMsMyM41AZfgyApJy36Wo2XRUx5mKW0LAw3zlRG/FaRhExs8qLuCWbivtTCsPXIBwNXttKYG7n+tqg==
X-Received: by 2002:a17:902:900a:b0:178:77c7:aa28 with SMTP id a10-20020a170902900a00b0017877c7aa28mr26385570plp.3.1665523655881;
        Tue, 11 Oct 2022 14:27:35 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:245b:b683:5ec3:7a71])
        by smtp.gmail.com with ESMTPSA id ix21-20020a170902f81500b001750792f20asm936592plb.238.2022.10.11.14.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 14:27:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 0/2] inet: ping: give ping some care
Date:   Tue, 11 Oct 2022 14:27:27 -0700
Message-Id: <20221011212729.3777710-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Dumazet <edumazet@google.com>

First patch fixes an ipv6 ping bug that has been there forever,
for large sizes.

Second patch fixes a recent and elusive bug, that can potentially
crash the host. This is what I mentioned privately to Paolo and
Jakub at LPC in Dublin.

Eric Dumazet (2):
  ipv6: ping: fix wrong checksum for large frames
  inet: ping: fix recent breakage

 net/ipv4/ping.c | 23 ++++++-----------------
 net/ipv6/ping.c |  2 +-
 2 files changed, 7 insertions(+), 18 deletions(-)

-- 
2.38.0.rc1.362.ged0d419d3c-goog

