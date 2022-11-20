Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22126312A1
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 06:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiKTFxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 00:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiKTFxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 00:53:44 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DFAA3412
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 21:53:44 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f9so4266834pgf.7
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 21:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1nfX671vJfg2zuri8O5EjdOm28I55ysFPzOVZ8pdPfc=;
        b=iXSzihHSBh2V+1RmARwyPzRf2xKEkOri0t/IgmAzShFbe2VgBP37pnMNnkKllwjed0
         ZyH8ImqtqrnZ9izayaWkhmCs9BtPseVCehiyiu2OHNoZuBsehjzerEPa7Ce8B1bgxOsu
         x1QAiwi1c9DCGL83cCKFljP7WM4qXKhA2v+ltRBd2ydGmXiMRxKKEahRFPKA5Y/6c/Os
         xZlxCgQawrHCbSWvxxZvzMPALL5BwdEKu/SWJ7Emjwo2H15e64PzWH8f2rmZMZ1Ok3OD
         kt0kTrWkPRj3uAQnchn+xXaeWLeCrfoRGqxU0ehmJH4Cos4E3JDgzp9Z0e0KQvjeAYCA
         z1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1nfX671vJfg2zuri8O5EjdOm28I55ysFPzOVZ8pdPfc=;
        b=oL+CwEb+xXk9ph2ikJCDycbHYjBxJbHWUPiu7GJrG3E8W0PzkebHlD6SdLtu/azGF1
         B9BxwxidWLWBlbbiSAUeAk1ZbfhUeK3fu7miYz1e0kEUqc/PEGJ2pHVwdoT5GY86fxkc
         rxzOeAplAIOgFD5F9Dk4dez5TWGdllYYsAKCV8fNEHVION9CtD2zLPu111wvW/ACPKW8
         Ir4SxPNx9Fkkd+p4SgH1YrLLrDEDgBqbhYEo3xM1N7JETnvZBRHWuZdoxAZudLYTWDxX
         qdlJo9furM1SVOAMVAuO+Uk/v8xz/6uqDqxCZjTRnL/43EfcrrV5pyLRX4RyIiIcmj/0
         jy8g==
X-Gm-Message-State: ANoB5pnonKypA6U09WKbuzDmRzvEYhsxFykjBn8WO9tyVnWZlP97NsgD
        g8wZK712Z2ioYGRokxFpI6I=
X-Google-Smtp-Source: AA0mqf7i6oDD8saq7BmXwPLzQHAru/3IfsNWUEuh+u/KuqjN6okUXuT6H/V3Ju8suR3LI1R+f2KmwA==
X-Received: by 2002:a63:4813:0:b0:476:fdde:b1f6 with SMTP id v19-20020a634813000000b00476fddeb1f6mr247764pga.212.1668923623353;
        Sat, 19 Nov 2022 21:53:43 -0800 (PST)
Received: from localhost.localdomain ([176.119.148.120])
        by smtp.gmail.com with ESMTPSA id n1-20020a170902f60100b00186ac4b21cfsm6733397plg.230.2022.11.19.21.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 21:53:42 -0800 (PST)
From:   Yan Cangang <nalanzeyu@gmail.com>
To:     leon@kernel.org, kuba@kernel.org, Mark-MC.Lee@mediatek.com,
        john@phrozen.org, nbd@nbd.name, sean.wang@mediatek.com
Cc:     netdev@vger.kernel.org, Yan Cangang <nalanzeyu@gmail.com>
Subject: [PATCH net v3 0/2] net: ethernet: mtk_eth_soc: fix memory leak in error path
Date:   Sun, 20 Nov 2022 13:52:57 +0800
Message-Id: <20221120055259.224555-1-nalanzeyu@gmail.com>
X-Mailer: git-send-email 2.30.2
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

v1: https://lore.kernel.org/netdev/20221112233239.824389-1-nalanzeyu@gmail.com/T/
v2:
  - clean up commit message
  - new mtk_ppe_deinit() function, call it before calling mtk_mdio_cleanup()
v3:
  - split into two patches

Yan Cangang (2):
  net: ethernet: mtk_eth_soc: fix resource leak in error path
  net: ethernet: mtk_eth_soc: fix memory leak in error path

 drivers/net/ethernet/mediatek/mtk_eth_soc.c |  9 +++++----
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 19 +++++++++++++++++--
 drivers/net/ethernet/mediatek/mtk_ppe.h     |  1 +
 3 files changed, 23 insertions(+), 6 deletions(-)

-- 
2.30.2

