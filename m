Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA315549D72
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349274AbiFMTVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242043AbiFMTVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:21:33 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E973204A
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:04 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d129so6099793pgc.9
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=juaci2PeoXcL+nqMkUy89lNr7q7tNb6TUDgIbRhaIWw=;
        b=dk7XnnMMUNUZeH5USqPH5eZIK+N/ookTgsHOsMjDEB6TfQFu+xplzvknAaEAA5K+U3
         9B7t0ZBMgJWojLC47fY0XfkYlL/VJR9bHUdpolFbttYo2cJv6A0NQ9Lmdl92WCPvbg5b
         Hm+WOdccIVztYuewNGEy2w0KaMbSSDh/s0weK5Re7WDlkkZ0B8r6qYHhPUAuuAfLT8jK
         GrTTMM9Uk0JHQjr162JVES4M8b+4QHCCXq2cVckkoMk1DGxLgSY4TvLmeM/kMGauQRvK
         oNKt4avN8PfrMNbTKKm6MP6rtIBrTaJKF2KLoSEn5XU4pEdGVAUksxL/ykuyyUwnpitp
         OYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=juaci2PeoXcL+nqMkUy89lNr7q7tNb6TUDgIbRhaIWw=;
        b=OWv28NsUk9ZfVI4GVrEquRhAh2uWQKxxAvHb05NraXuO4R54Tyrc4ffZEvzxh4vwu8
         BeG2OGZZB37csBbPrzRIQQa8ZOgdNnv145+h9PUaWkuVqjazvwvDiXVrzjOQ1Ug2ogwP
         +qelzyKaY5piwJllhFztBkuFQ7mY0xyIeB+SSuRyMlFmeeJH30rcguuIOyWwbavqgLTw
         hIqm+WTtOtyvGo1HkPgOWSVIsofg70w2xxvgyZt5UtNEm34eq5/XhZ54WZv+aWQ1J4Ey
         79aV3hE2n8GgzGYz+eOvwubHH2whdK8xqSvdDU3v4lT/iADBBq3L92L3j4ue7VKDv13U
         z3Gw==
X-Gm-Message-State: AOAM531XOdOzzsAZ0ouG81ozUse4b0V+xaXP3uQWHgaTJuUVqiMOVryG
        ntm7bhZQiMJeiK+92y5OAqD46g==
X-Google-Smtp-Source: ABdhPJwcTcXOF9xRG3dPFI9a4nx8eDN+e296+S49xU51P+CvYepm9W234zBxio3nRmKFJRYBFiXIbw==
X-Received: by 2002:a63:28c:0:b0:3c1:6f72:7288 with SMTP id 134-20020a63028c000000b003c16f727288mr551294pgc.564.1655140683760;
        Mon, 13 Jun 2022 10:18:03 -0700 (PDT)
Received: from localhost.localdomain ([192.77.111.2])
        by smtp.gmail.com with ESMTPSA id u17-20020a62d451000000b0050dc762812csm5646641pfl.6.2022.06.13.10.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:18:03 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: simplify completion statistics
Date:   Mon, 13 Jun 2022 12:17:53 -0500
Message-Id: <20220613171759.578856-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch in this series makes the name used for variables
representing a TRE ring be consistent everywhere.  The second
renames two structure fields to better represent their purpose.

The last four rework a little code that manages some tranaction and
byte transfer statistics maintained mainly for TX endpoints.  For
the most part this series is refactoring.  The last one also
includes the first step toward no longer assuming an event ring is
dedicated to a single channel.

					-Alex

Alex Elder (6):
  net: ipa: use "tre_ring" for all TRE ring local variables
  net: ipa: rename two transaction fields
  net: ipa: introduce gsi_trans_tx_committed()
  net: ipa: simplify TX completion statistics
  net: ipa: stop counting total RX bytes and transactions
  net: ipa: rework gsi_channel_tx_update()

 drivers/net/ipa/gsi.c         | 77 +++++++++++++++++------------------
 drivers/net/ipa/gsi.h         |  2 +-
 drivers/net/ipa/gsi_private.h |  9 ++++
 drivers/net/ipa/gsi_trans.c   | 68 +++++++++++++++----------------
 drivers/net/ipa/gsi_trans.h   | 15 +++----
 5 files changed, 87 insertions(+), 84 deletions(-)

-- 
2.34.1

