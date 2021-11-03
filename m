Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D8A444504
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 16:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhKCP6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbhKCP6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 11:58:36 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4313CC061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 08:56:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so1706158pji.5
        for <netdev@vger.kernel.org>; Wed, 03 Nov 2021 08:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wB6L2zhgIZw3VuMIvl+9jSRccRbfwY9247FkYpdL0aY=;
        b=dW56jnmgDtqynIU5Q+4TgJNOK5/NMDKboPX1MmaRr6TIPGKKMuTORRHVd+eKO+gb1J
         F9CjXz01U3+wl3H2VbwpaCRDn4ueAv46ELOXnvjHif0wov09YHb+xvJrjcQLfbP0aY4G
         KvSDnOftdKvwJ8dakI0KNrEwnWLpHoBXzlNvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wB6L2zhgIZw3VuMIvl+9jSRccRbfwY9247FkYpdL0aY=;
        b=ysP/hWqEqekgkavMh54WBrZO3FilH2kiTX2m0m57YuatNfJ2T6rvsUsGNJAaJQIkr7
         dp+9qP5sAVA2Ja1fJqfwSUXW68Jp2yDjCgrd3z8zn1i0YTCr223fanmdFs629V0fYyMA
         2ewnpbgCotQSHZkLaQGZo0/LHGO0Qk8wktWYQ1uJSh/wJZo5k2JW+y3rVNctGaMXkh8P
         lpsEZjO/zPrc8Uyc2CWmx0QMrJ5/ulwwtZCyQnpxCbAAAgbJnKEz/gtl33DttBycdWFM
         8Ic0ZCwN6u5r7nPpnNpv/bp7tjYX3G4T9mBC658hengBESTjnzR1u2/NaqDmNt41VP4K
         50Ng==
X-Gm-Message-State: AOAM531KB/kcLG9Rj8E0vfdi+tq4aaXo/QMvIl/LBEN+O/i7ql3nQxi4
        YetDFgIPb5iCXMuc1gf6cf6nRA==
X-Google-Smtp-Source: ABdhPJwJHBwZvky/2hhePb9Q/bclZzLHICNSu13XZlb7MrPyS8HuhRjfaZtItq8TjUEpDSH9B5Errg==
X-Received: by 2002:a17:902:654d:b0:141:7df3:b94 with SMTP id d13-20020a170902654d00b001417df30b94mr38998695pln.60.1635954959352;
        Wed, 03 Nov 2021 08:55:59 -0700 (PDT)
Received: from localhost ([2600:6c50:4d00:d401:aa7a:1484:c7d0:ae82])
        by smtp.gmail.com with ESMTPSA id x17sm2742679pfa.209.2021.11.03.08.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 08:55:58 -0700 (PDT)
From:   Benjamin Li <benl@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] wcn36xx: populate band before determining rate on RX
Date:   Wed,  3 Nov 2021 08:55:40 -0700
Message-Id: <20211103155543.1037604-1-benl@squareup.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
Fix unused variable warning.

Benjamin Li (2):
  wcn36xx: populate band before determining rate on RX
  wcn36xx: fix RX BD rate mapping for 5GHz legacy rates

 drivers/net/wireless/ath/wcn36xx/txrx.c | 42 ++++++++++++-------------
 1 file changed, 20 insertions(+), 22 deletions(-)

-- 
2.25.1

