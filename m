Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F84023175D
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 03:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgG2Bmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 21:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730430AbgG2Bmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 21:42:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857D9C0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 18:42:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 74so3824948pfx.13
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 18:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2JREyKdWiZay/mV18M1Axh+euiqXpqs5sXmHMc+iAKQ=;
        b=mv5ftazHEBjQoDdXHQUpaVOF1CD/lzXNM9zfmJde18RJxukAT2Wx8L0bZBp7YGKNbx
         e9uphKZyPXLxsThr5ua9lbNWsAvEOrbDPDh4SnRUsxEj3KepOa5d2jGbyXpTAdsRCcXu
         1xfJpH55O0nvsvyiDtieZSWOaXnVXd5BD95m0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2JREyKdWiZay/mV18M1Axh+euiqXpqs5sXmHMc+iAKQ=;
        b=dp06P4QjultyxQWo9tmtzT0gKMOFjS0/opTI6lbo/YwJafTId7lWsyXKjOkWLn0GHw
         lMsk+OAjPmTrw74KgcxyOCCDvW/2PxiAcFPxVRTof+Bzr53j3MkRG17UZHCNE9e8NJWd
         8e6/jHG/iZzilstw6keycUXobPAD0JT8afEEj/bzcn9kbdNnBabr4BeMkrQ12HFmX7wz
         FyFN7QK+KXxrxJN8mRLWK1YJOdSrLMZeq6H3LCvf394TS4sQzEPegrCtzJZBJSJS0mAT
         jwM0GQAswOkt0GWQaqK8KpJjmWGuSxPs1Ll+fUao2C8s4CFDqnU0yHILQqvAKtUC6gD1
         kmFg==
X-Gm-Message-State: AOAM532ZtbeOIh1HnausVJB5nwXz3qXmWXSxNtPc6wtjqFsqfljhCNSc
        jTDKD0MT+4b2oiAQCjEsL9eSwwSA4nM=
X-Google-Smtp-Source: ABdhPJyCZXaEbxMk/vJPZ4nalToz0Wmy+riDDLOIm88MjiSUydfptFoj2rCEtzKrzaZTiG7rhBHK9g==
X-Received: by 2002:a63:935c:: with SMTP id w28mr26269597pgm.174.1595986958935;
        Tue, 28 Jul 2020 18:42:38 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id e124sm280678pfe.176.2020.07.28.18.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 18:42:38 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/3] Bluetooth: Emit events for suspend/resume
Date:   Tue, 28 Jul 2020 18:42:22 -0700
Message-Id: <20200729014225.1842177-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marcel,

This series adds the suspend/resume events suggested in
https://patchwork.kernel.org/patch/11663455/.

I have tested it with some userspace changes that monitors the
controller resumed event to trigger audio device reconnection and
verified that the events are correctly emitted.

Please take a look.
Abhishek


Abhishek Pandit-Subedi (3):
  Bluetooth: Add mgmt suspend and resume events
  Bluetooth: Add suspend reason for device disconnect
  Bluetooth: Emit controller suspend and resume events

 include/net/bluetooth/hci_core.h |  6 +++
 include/net/bluetooth/mgmt.h     | 16 +++++++
 net/bluetooth/hci_core.c         | 26 +++++++++++-
 net/bluetooth/hci_event.c        | 73 ++++++++++++++++++++++++++++++++
 net/bluetooth/mgmt.c             | 28 ++++++++++++
 5 files changed, 148 insertions(+), 1 deletion(-)

-- 
2.28.0.rc0.142.g3c755180ce-goog

