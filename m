Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34F8444CD2
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 02:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhKDBIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 21:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhKDBI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 21:08:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF58C061203
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 18:05:52 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id k4so4481227plx.8
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 18:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F7IntgBRqXmThHfeu8v3VfsyQz57chbxKAkcYHeyT70=;
        b=DC4kh7qqTVyouDvVXwTXkHPdVKF6JxiMXTwigL5IFB8peVA0DGwVqBDgNUQL8dqqxP
         xYKE+nl2876LdESELxAM+m7J8FDKEXXvTSgJUQq/4+FHNpitGEXzoXQNSxSxMeegzUOC
         Fh9RLzSFEQ9giDzOKXCyZqedrFGWPaWebKX0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F7IntgBRqXmThHfeu8v3VfsyQz57chbxKAkcYHeyT70=;
        b=tbsrYgwjzkXkAO/BhUaJJ1X0/EI5xAC3aXEoc4ZgsWT+MSH/LCeJMZn60jdHXxGVVP
         qdMG5Pv4xQDnPtp/gNN40nk+IeuvQBqYQhAl+GFX/9H7pV/gaGnd5E6EWO+luIrIp9WZ
         rRZTue8uvfAkMMiZ+wYn2cepyj69Xg8/d4UaK4MQnKPHylEUc1jUZwgv7/frY9SgRNL1
         r9i8ilnw0ECSOn/0ITriHuzqnYcpzsJqrX0LU/q5ZugDzGj1oqS0XfAQclfTGMCEsJui
         YY61clWIouIxYKIokjwjo8a5wEb4sqKpU1HaRoi7LMi/S+Vyj4GWqspz0LyZBVLxlh+d
         ELcg==
X-Gm-Message-State: AOAM530mdaGmrsYvS0G6XjsqkWM3nAybULvm2JfKvH8lUQrzr51bQskl
        LpK71dr4Fylln/mBtZyvGW5CHw==
X-Google-Smtp-Source: ABdhPJwIDnMlPDwfl4MjKZ60puhKpQJbMdve+2zJWlJPT8+RQio8OoxhvgtxuJXzTcieT0ljmUubfw==
X-Received: by 2002:a17:902:f209:b0:141:99d1:7cef with SMTP id m9-20020a170902f20900b0014199d17cefmr40318754plc.70.1635987951935;
        Wed, 03 Nov 2021 18:05:51 -0700 (PDT)
Received: from localhost ([2600:6c50:4d00:d401:aa7a:1484:c7d0:ae82])
        by smtp.gmail.com with ESMTPSA id f11sm3749026pfe.3.2021.11.03.18.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 18:05:51 -0700 (PDT)
From:   Benjamin Li <benl@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] wcn36xx: populate band before determining rate on RX
Date:   Wed,  3 Nov 2021 18:05:46 -0700
Message-Id: <20211104010548.1107405-1-benl@squareup.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
Tweak commit message of patch 1 (probe response -> beacon/probe response).

Check for rate_idx >= 4 in patch 2, per Bryan's observation and Loic's
confirmation that FW sometimes sends rate_idx = 0 for 5GHz legacy rate
frames.

No warn per feedback from Kalle, since this a confirmed FW bug & logging
could be spammy.

v2:
Fix unused variable warning.

Benjamin Li (2):
  wcn36xx: populate band before determining rate on RX
  wcn36xx: fix RX BD rate mapping for 5GHz legacy rates

 drivers/net/wireless/ath/wcn36xx/txrx.c | 41 ++++++++++++-------------
 1 file changed, 20 insertions(+), 21 deletions(-)

-- 
2.25.1

