Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 601A15A6CA2
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 20:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiH3S5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 14:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiH3S5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 14:57:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A585760F7
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:57:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso18885186pjk.0
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 11:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=NpbrkV6HEgRKtMGGqa3VbXgfm7ZlRU6AQ1OEPEbrtkI=;
        b=IXGVjQMfcK840hzgvBb2nCF92lLbRmWEkuXIIxq9RbUay972XErWfAf4OpwWbI5sU1
         JiyqTYSFdBMdfitNrxaGGKYLNDluX8DbZryK/CKOTnYzdTxs0sPVzofeeDwFHlDNJctL
         NaLSGtSKoIpFZfiTUxUTHxoP1grMB/N6fDQh2TsMPX6srmoijmP2dTr1JHBElzOWZ4wt
         awwWXnpIXitnSTKAqrcajCteQlJGDll6MfM/zGcDM7nlV1RduJFxwl5k1c7kftVZP55c
         QHC2Q0pMreFthF5lz9ngto9a/DuaIEdlamERjo+2jo0GmL9CQ1bB5lw+5OBzuS80sBbo
         XwHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=NpbrkV6HEgRKtMGGqa3VbXgfm7ZlRU6AQ1OEPEbrtkI=;
        b=fEePq2yWMjAu3ovofatDB6yDlJZIipDjiPiusbmIKx/QB323B9SWofL/DsspakazuD
         Y5IrYl31J5Sq3G5Bi6pWJv7aW2auJt0RheUR6c12o825TCuUt5cbpJg9cSSGuQEEfhe5
         Ts5/v5DyHzrrZY2FrdgXXx497F0ewHYlcn2zHNviJJ4PgIUdeiBwevL47iIpKGs3Tvuj
         dGpJCHFzDMKIdEoFJ2Yi1WDV1b1rPInncxQkky95nTsaa6PleWxDfa19/XnSpJaAiJkZ
         0T6f+eAfWssj5HXMmif8/NHAhx8kxXx3MmMYOTMHZsaKecUB27S4MwmdMkIF2DIKP0ua
         LpeQ==
X-Gm-Message-State: ACgBeo0nivbd2CAAmBuUqPf+s+oxFPL133XFKXNvmLerQBap5V5hSxRI
        +1ULq0mH4BGYG296mh+k/lg=
X-Google-Smtp-Source: AA6agR7aFsqFcY/SxaRFB8rBoQuSpYrekxnZ/gCt8QAzfhAw/R+CSAh3cFxvKl+84uzZKMP8+L19HA==
X-Received: by 2002:a17:902:e5c7:b0:174:e71e:30ef with SMTP id u7-20020a170902e5c700b00174e71e30efmr8368212plf.30.1661885821082;
        Tue, 30 Aug 2022 11:57:01 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6f37:1040:8972:152e])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902784b00b00173164792aasm10085449pln.127.2022.08.30.11.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 11:57:00 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Jason Baron <jbaron@akamai.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 0/2] tcp: tcp challenge ack fixes
Date:   Tue, 30 Aug 2022 11:56:54 -0700
Message-Id: <20220830185656.268523-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
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

syzbot found a typical data-race addressed in the first patch.

While we are at it, second patch makes the global rate limit
per net-ns and disabled by default.

Eric Dumazet (2):
  tcp: annotate data-race around challenge_timestamp
  tcp: make global challenge ack rate limitation per net-ns and default
    disabled

 Documentation/networking/ip-sysctl.rst |  5 ++++-
 include/net/netns/ipv4.h               |  2 ++
 net/ipv4/tcp_input.c                   | 21 +++++++++++----------
 net/ipv4/tcp_ipv4.c                    |  6 ++++--
 4 files changed, 21 insertions(+), 13 deletions(-)

-- 
2.37.2.672.g94769d06f0-goog

