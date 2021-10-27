Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE71643CF57
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhJ0RFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbhJ0RFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:05:42 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE42CC061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:03:16 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id m184so4589005iof.1
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 10:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f2sYqrV79rh3369wClGLos5kmskab5d3N7ni1N0ATjU=;
        b=XjEC9O8fLz9VGTKb0yxMeV4s7XM80XOaOqsB9U2Iatz91WyxBtARrrgkthK3clxIDf
         RR0hz/dgGKHb/ekP/lWgjDyEOzt11bGrYwxjhKAM4Yr2+yaM/I55SFC79/b2MrujUwC6
         QO0lSGI9aS3INQ77fxSb7Ih12pUEce9tk7cVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f2sYqrV79rh3369wClGLos5kmskab5d3N7ni1N0ATjU=;
        b=3I9Hfb2Rgc3lqnAKZgoivLX4pm+HUi47GPnGJ5sKWII/catF7LvU1zXvlE42lkmunQ
         OaL8y3oNagPeJ30dxZZpm+kHNiq+bC+8rncXVoNInpWsPDRvCBLPygOGRwMYXOKODfq8
         yrmyf+sbigi+baDozGojGZ1rkr17OAMbSjYs3WAd7r7wLAHofpXNvjPiPWJ4NaXOLDqq
         QYIY+H7z5Z3ebfuGdOUHNOc5Dkn9NhsJtuYZBBy5CzF6ZrjvkeFtFRWO6hrA+Gqc9lwZ
         +pdrMlzCdaWp1hfmETGvGMaBLKhC8hxylXDDE//3VovofX1+UNw8yBq7BJXapX02JgHe
         lPnw==
X-Gm-Message-State: AOAM530yXIFNAlfjEFvxLYkD4+tZOc5BEEsQTm+uwJZj87xF2E27RQx+
        STNGpAbQnJZlY061loAMw8Ks6w==
X-Google-Smtp-Source: ABdhPJywloO7Ma/yoOAJEIwPDRo+lNYk7Cdl7sFOroT3fZ8Qi9wcAHBUj2og2Sx2gGzDxYH58oHO7g==
X-Received: by 2002:a02:cbb1:: with SMTP id v17mr17337139jap.51.1635354195460;
        Wed, 27 Oct 2021 10:03:15 -0700 (PDT)
Received: from localhost ([2600:6c50:4d00:cd01::382])
        by smtp.gmail.com with ESMTPSA id n25sm230377ioz.51.2021.10.27.10.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 10:03:14 -0700 (PDT)
From:   Benjamin Li <benl@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Joseph Gates <jgates@squareup.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] wcn36xx: software scanning improvements
Date:   Wed, 27 Oct 2021 10:03:02 -0700
Message-Id: <20211027170306.555535-1-benl@squareup.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
Fix compiler warning (int flags -> unsigned long flags in patch 2).

v1:
Less important now, given Loic's breakthrough with FW scan offload on
5GHz channels, but downstream does do software scanning so these fixes
for that path may still be valuable to someone.

Benjamin Li (3):
  wcn36xx: add debug prints for sw_scan start/complete
  wcn36xx: implement flush op to speed up connected scan
  wcn36xx: ensure pairing of init_scan/finish_scan and
    start_scan/end_scan

 drivers/net/wireless/ath/wcn36xx/dxe.c     | 47 +++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/dxe.h     |  1 +
 drivers/net/wireless/ath/wcn36xx/main.c    | 49 ++++++++++++++++++----
 drivers/net/wireless/ath/wcn36xx/smd.c     |  4 ++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  1 +
 5 files changed, 95 insertions(+), 7 deletions(-)

-- 
2.25.1

