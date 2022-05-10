Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99CD520B31
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiEJCce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiEJCcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:32:32 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A6C1A90C7
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:28:36 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id o11so12622209qtp.13
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W6jOMUgILshn2WYmKe1q5xPwSH19p0pv5Sgwj8YN3Ic=;
        b=LxrccxHB5ShY+Li9AxEbs/r6b5v29JSx2sRyAbLaekDsvOtrFZRXwATgEExVDmTIea
         saj94hqUdN3dH5a0itNV9kN4EHzc5qD97nffu8dxU/daH+GYOJwKydppWQMz3gwEeUYM
         2vHrIsjtFj3gYr+TiURYYTO6PnUbrNiIUIUAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W6jOMUgILshn2WYmKe1q5xPwSH19p0pv5Sgwj8YN3Ic=;
        b=hVNpC35VVgOQ9x1i9Mqg2dYQkNVEaNY5wCWMf4fQHtApoTUL7w2DYe1/Le2g8OtPuL
         gA+tgvS7vdZ0Nt+Q0u3Z9SwAKRiidR4iGXPsKyVZ98IychZWub+4XlIqOPcsKUe2I3YJ
         +9ezTi1UfRAz/ZD87VlIDoIfiOp1iL8m7YWp85Cgbp9D3M0Ddqb9hyClT+ZEsDD3NHAp
         0D97mhgaCOkbNojNvfcoof2I5TF+brm72YsrBuv/wvXxfFIYq2bd/d2103XzreegrU18
         UllKTitqSDFhIFZ7U4vN0zVGuT2EtBal9x7o6EXQl7e8veP8QEWnyAowF1lbAp73cwFA
         popQ==
X-Gm-Message-State: AOAM531gi0vkWs57WmJJodRQyfO85ntqMgG9hoAaq9bxDyBQ8GNorEFa
        FeNI7HZasSZ5+PFQGL5tmziq3Q==
X-Google-Smtp-Source: ABdhPJz3H3ybqqVT6iThgbLBPKnjqzXyFMDiP+lk/h6qcoE+DUsiQz0S7GXQaociIc3ewIBjht9/Sg==
X-Received: by 2002:ac8:5f0c:0:b0:2f3:cbad:5024 with SMTP id x12-20020ac85f0c000000b002f3cbad5024mr16029420qta.578.1652149715111;
        Mon, 09 May 2022 19:28:35 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id 18-20020a05620a06d200b0069fc13ce213sm7742375qky.68.2022.05.09.19.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 19:28:33 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 0/4 V2] net: atlantic: more fuzzing fixes
Date:   Mon,  9 May 2022 19:28:22 -0700
Message-Id: <20220510022826.2388423-1-grundler@chromium.org>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Chrome OS fuzzing team posted a "Fuzzing" report for atlantic driver
in Q4 2021 using Chrome OS v5.4 kernel and "Cable Matters
Thunderbolt 3 to 10 Gb Ethernet" (b0 version):
    https://docs.google.com/document/d/e/2PACX-1vT4oCGNhhy_AuUqpu6NGnW0N9HF_jxf2kS7raOpOlNRqJNiTHAtjiHRthXYSeXIRTgfeVvsEt0qK9qK/pub

It essentially describes four problems:
1) validate rxd_wb->next_desc_ptr before populating buff->next
2) "frag[0] not initialized" case in aq_ring_rx_clean()
3) limit iterations handling fragments in aq_ring_rx_clean()
4) validate hw_head_ in hw_atl_b0_hw_ring_tx_head_update()

(1) was fixed by Zekun Shen <bruceshenzk@gmail.com> around the same time with
"atlantic: Fix buff_ring OOB in aq_ring_rx_clean" (SHA1 5f50153288452e10).

I've added one "clean up" contribution:
    "net: atlantic: reduce scope of is_rsc_complete"

I tested the "original" patches using chromeos-v5.4 kernel branch:
    https://chromium-review.googlesource.com/q/hashtag:pcinet-atlantic-2022q1+(status:open%20OR%20status:merged)

I've forward ported those patches to 5.18-rc2 and compiled them but am
unable to test them on 5.18-rc2 kernel (logistics problems).

Credit largely goes to ChromeOS Fuzzing team members:
    Aashay Shringarpure, Yi Chou, Shervin Oloumi

V2 changes:
o drop first patch - was already fixed upstream differently
o reduce (4) "validate hw_head_" to simple bounds checking.

 drivers/net/ethernet/aquantia/atlantic/aq_ring.c        | 17 ++++++++++-------
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c   |  6 ++++++
 2 files changed, 16 insertions(+), 7 deletions(-)

cheers,
grant
