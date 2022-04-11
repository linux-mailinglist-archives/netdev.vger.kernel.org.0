Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E44A4FB638
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 10:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343920AbiDKInc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 04:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343910AbiDKIna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 04:43:30 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB00C3D4A1
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:41:16 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id b21so25311660lfb.5
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 01:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=u7es23m68YE0yDAKWEjJ20E23kk4TJaXNmA2qr7JJH4=;
        b=L8oivNjMQSl9MPzjFbzVGxjlnBoiWGiLHMIq/oDJwCXUtR5AWy+eO/MMO/EOMD8F62
         dAn8Zv109J9ObyJa4YNpyo+ayqdoyqppliEDrOUUhUBsl7BScxW6Ilyidt0B+GZO/sLp
         1PJhZv6EsQlETlxh1kQq7Pa7T8E2lUxpNLk+WOmfvcpsmnvYb7vdlpeWsp6ab/ZWcvVQ
         SPlfbz2s9+GjpIPCRTk+1863QwHynHZrtyEKMoWav/zOQoIc93rrLCj+8C2xa5KPcEM2
         J6W8Ct1jNR/SdB+daDHjRGlZM3QbiT6PtmlXyFpxXz3eQMQFbrb6fB1KQX/fKaY7aIuW
         K5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=u7es23m68YE0yDAKWEjJ20E23kk4TJaXNmA2qr7JJH4=;
        b=KbUXPc/g29tWea77NtQcWQ7aaC/qt0uhI6LLhvQTLUGKormV81OlvQf2o1VHPnjbcX
         bSMZHg/qMyUSclCpeMOZZ1AWbVWcn6lJTXFIN6TiSjs5CDOVKERnzDB96RtyIh1TEsd1
         ELE9OSbzzHGoOqg9z5zWXlLkr2JQcBXLt5fl3HqVWYM23yJiMKTdkeN+8ILvZ/eQ0zfw
         kii97OPHphV/yVenU60t2UPmbdoyChkjOUAmfgyPd55fKiOezc7hioQKT0hVx7ygLt2f
         aJ1RdTFuflaYUgFX2aQ7NfdlGeKQOl/uXLimiwi+VGZBDjQb2/naE+ehHa6cla+DVRpf
         IfQQ==
X-Gm-Message-State: AOAM532F5weEUEp80fVxi2WBbfIdzteAsVFaBPvIEVsBKkHiDBnkUn32
        Te1mAqD+NsRdHvBvGG+PDM0=
X-Google-Smtp-Source: ABdhPJwp4oR0rTrcDt9TRoyZvlNtd1Xhzy4g/pTdfURpRKhdpxieKhUAmpQhgmt1j0oZ4AbeS/2DqA==
X-Received: by 2002:a05:6512:1684:b0:448:a0e6:9fa6 with SMTP id bu4-20020a056512168400b00448a0e69fa6mr20765212lfb.592.1649666474642;
        Mon, 11 Apr 2022 01:41:14 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id x24-20020a056512047800b0046b9dafd55bsm549080lfd.164.2022.04.11.01.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 01:41:13 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH v2 net-next 0/2] net: bridge: add support for host l2 mdb entries
Date:   Mon, 11 Apr 2022 10:40:52 +0200
Message-Id: <20220411084054.298807-1-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223172407.175865-1-troglobit@gmail.com>
References: <20220223172407.175865-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Fix to an obvious omissions for layer-2 host mdb entries, this v2 adds
the missing selftest and some minor style fixes.

Note: this patch revealed some worrying problems in how the bridge
      forwards unknown BUM traffic and also how unknown multicast is
      forwarded when a IP multicast router is known, which a another
      (RFC) patch series intend to address.  That series will build
      on this selftest, hence the name of the test.

 /Joachim

v2:
  - Add braces to other if/else clauses (Jakub)
  - Add selftest to verify add/del of mac/ipv4/ipv6 mdb entries (Jakub)

Joachim Wiberg (2):
  net: bridge: add support for host l2 mdb entries
  selftests: forwarding: new test, verify host mdb entries

 net/bridge/br_mdb.c                           |  12 +-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/bridge_mdb.sh    | 103 ++++++++++++++++++
 3 files changed, 111 insertions(+), 5 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb.sh

-- 
2.25.1

