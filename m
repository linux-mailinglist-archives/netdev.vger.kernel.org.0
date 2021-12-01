Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC79A4643BA
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345514AbhLAAGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345469AbhLAAGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:06:05 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B398C061574;
        Tue, 30 Nov 2021 16:02:45 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z6so22323923pfe.7;
        Tue, 30 Nov 2021 16:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AA/C5oSpqza07XwpfAgMyaKKyGZVr7v8RCqRrokVzOI=;
        b=dG64TriVe8rq33ChR3vGDWrM8hakTjbbYKo6xdhQOzy4Ylwu5MxfSgUFhxxDaMffxV
         1zFMmURb7TuaOuhc4VXA/F0GagxNbU0LFUODmXDHgzjstR455Drsnzu2NMAly2SSFMd4
         S+rq2wWLCH1PGUqeXlZgwoyj2fyIINTAr1sraN27EmTHj0LGL5gzOiRTdSnnCBtQI/w2
         XbxQj/9QYX0wkwPrwn2aGqld8pZ4RuYdWsN/HkTRoMIQMg7QfbbeoeMA2sRbPU3hHRYv
         BbIepB7OWyy8wHcRjoE5fbbPQsGlR80n+NgGQHQ8XhpdejbgOi8giqesxj4I1OO+Bb1Q
         wsMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AA/C5oSpqza07XwpfAgMyaKKyGZVr7v8RCqRrokVzOI=;
        b=nb+FgzZNZrEBt1h87TKz5phv6BRFgMR6ksy21g2wYQh8nRuapW8o+SgZahjz9bu0QR
         8/o5Vv1EAuguf1+gEWhjER0aFqTe/Fm+RNQ6og8UMc1Os40V8XXfHMpkVodorfGw+ZXD
         NdkFNslHYqOVSLpVq1xU+YDI7LNiq3s1l2fmxJDGwlOVrf6tR6rArFx7/I/OaSgGeLyT
         pmaB83TEZYG+X3/5Z/cFzXO0JAyXzwIdyXdfBD3qtdnFJ4R2O5d5KUXGUk6cZR251ggd
         O3XCnL+JLRUhSSj7XOnyuY4BKlQp9HwE99msUKm5Uj9B63fgu4rsW7u6bVAiEKjd1mRn
         kBXA==
X-Gm-Message-State: AOAM530TVogaLAnb0lK2MC9ErhgZcukCeJLwXyHVHweeC9HPD4gBZN88
        MqTDMLn0eiJJioWKLkRwkwA=
X-Google-Smtp-Source: ABdhPJwPISuje6Op0QKPRGMm8yaFNG5FX8Htn37ptlxFWjKiq6W6baiyKLsOlQ21VLLvy7iZhlJ1Kw==
X-Received: by 2002:a05:6a00:1741:b0:49f:f918:3eb7 with SMTP id j1-20020a056a00174100b0049ff9183eb7mr2704265pfc.6.1638316964477;
        Tue, 30 Nov 2021 16:02:44 -0800 (PST)
Received: from lvondent-mobl4.intel.com (c-71-56-157-77.hsd1.or.comcast.net. [71.56.157.77])
        by smtp.gmail.com with ESMTPSA id j13sm21001739pfc.151.2021.11.30.16.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:02:43 -0800 (PST)
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        dan.carpenter@oracle.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 00/15] Rework parsing of HCI events
Date:   Tue, 30 Nov 2021 16:02:00 -0800
Message-Id: <20211201000215.1134831-1-luiz.dentz@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

This reworks the parsing of HCI events using skb_pull_data to check
event length, in addition to that it does introduce function tables to
handle events, LE subevents, Command Complete and Command Status which
simplify the callback by adding a common code that uses skb_pull_data
when parsing such events.

Luiz Augusto von Dentz (15):
  skbuff: introduce skb_pull_data
  Bluetooth: HCI: Use skb_pull_data to parse BR/EDR events
  Bluetooth: HCI: Use skb_pull_data to parse Command Complete event
  Bluetooth: HCI: Use skb_pull_data to parse Number of Complete Packets
    event
  Bluetooth: HCI: Use skb_pull_data to parse Inquiry Result event
  Bluetooth: HCI: Use skb_pull_data to parse Inquiry Result with RSSI
    event
  Bluetooth: HCI: Use skb_pull_data to parse Extended Inquiry Result
    event
  Bluetooth: HCI: Use skb_pull_data to parse LE Metaevents
  Bluetooth: HCI: Use skb_pull_data to parse LE Advertising Report event
  Bluetooth: HCI: Use skb_pull_data to parse LE Ext Advertising Report
    event
  Bluetooth: HCI: Use skb_pull_data to parse LE Direct Advertising
    Report event
  Bluetooth: hci_event: Use of a function table to handle HCI events
  Bluetooth: hci_event: Use of a function table to handle LE subevents
  Bluetooth: hci_event: Use of a function table to handle Command
    Complete
  Bluetooth: hci_event: Use of a function table to handle Command Status

 include/linux/skbuff.h      |    2 +
 include/net/bluetooth/hci.h |   59 +-
 net/bluetooth/hci_event.c   | 3031 +++++++++++++++++++----------------
 net/bluetooth/msft.c        |    2 +-
 net/bluetooth/msft.h        |    2 +-
 net/core/skbuff.c           |   23 +
 6 files changed, 1689 insertions(+), 1430 deletions(-)

-- 
2.33.1

