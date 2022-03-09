Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8792D4D2747
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiCIDld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 22:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiCIDlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 22:41:32 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B64915F0BA
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 19:40:35 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id z16so1146542pfh.3
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 19:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bF8+OBq4WcXq4Z2Z8PBT2wi4fSdgvyKTgfwfwzAAzrI=;
        b=SFzwTVfIuSydlVaDlZe2vKfiGZiEDSBZeWLSLrLUOL3xmkOmf88RvvHn0UnpRcsxdl
         VWSx0bP0JrMKWykHNCJh5vkQ++TXaSRv6yg/va2fceKBzefgNJEYcsdIaYt5f2PPC5Gx
         2CNJJk5IomVQ/WmUj+BiiSIKtbbHohieztnyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bF8+OBq4WcXq4Z2Z8PBT2wi4fSdgvyKTgfwfwzAAzrI=;
        b=zXeTosdt7sCMQ5hD4XgL4zcQs1I1ytpFYoqbklUpso1I0N7/GUCLDO1VJSVrG9QOSE
         cn8A9ux5MjvSW7e9m+Qk2VV/ckHPQb9VRAKBTzDoWsrSBaL9Og2Giesogi3lVR3i7Qd1
         GrM3RPltoEzLBJ12BKTJzq2kzjUTB+RCjGzEQtxl+pcPT0ZVit/Zo/2DcJJumP+ThQRJ
         Iue7dDm8+wSn7z6HvbzMWTX3V3WKhxyFR5xWkMDBgwyNdMeB2xV7ZUSoNDmDymJudDHN
         4+SCY/LTguLGJG/Xyzyib1ABNzQbDRqPaPXwTqI4IoBXciKaxlNc1GkBB+u6jv0Dn4zI
         g3cQ==
X-Gm-Message-State: AOAM531YOrCycU4kyL9AIqJitvhAHDPUJq0r1CkyTBHyrS+sQCFdjtO7
        c2CdDZHFDthiaaKBddZPR6r/gg==
X-Google-Smtp-Source: ABdhPJyag71SEgP3TFzsAkm31royx3Ftq7Hrsex0khfO1abPdTnSECss0/x5aJ5ZitjTV8Y5IeqaYw==
X-Received: by 2002:a63:7c5c:0:b0:380:7412:341b with SMTP id l28-20020a637c5c000000b003807412341bmr8267442pgn.38.1646797234525;
        Tue, 08 Mar 2022 19:40:34 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm578631pfu.120.2022.03.08.19.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 19:40:33 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com, rdunlap@infradead.org
Subject: [PATCH net-next 0/2] net/fungible: fix errors when CONFIG_TLS_DEVICE=n
Date:   Tue,  8 Mar 2022 19:40:30 -0800
Message-Id: <20220309034032.405212-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This pair of patches fix compile errors in funeth when
CONFIG_TLS_DEVICE=n. The errors are due to symbols that are not defined
in this config but are used in code guarded by
"if (IS_ENABLED(CONFIG_TLS_DEVICE) ..."

One option is to place this code under preprocessor guards that will
keep the compiler from looking at the code. The option adopted here is
to define the offending symbols also when CONFIG_TLS_DEVICE=n.

The first patch does this for two functions in tls.h.
The second does the same for driver symbols and makes tls.h inclusion
unconditional.

Dimitris Michailidis (2):
  net/tls: Provide {__,}tls_driver_ctx() unconditionally
  net/fungible: fix errors when CONFIG_TLS_DEVICE=n

 drivers/net/ethernet/fungible/funeth/funeth_ktls.h | 7 +++----
 drivers/net/ethernet/fungible/funeth/funeth_tx.c   | 9 +++++----
 include/net/tls.h                                  | 2 --
 3 files changed, 8 insertions(+), 10 deletions(-)

-- 
2.25.1

