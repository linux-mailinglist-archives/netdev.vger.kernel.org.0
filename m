Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CA91D04BB
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgEMCTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgEMCTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:19:33 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F637C061A0F
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 19:19:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k19so6213014pll.9
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 19:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lkqIDoib68FB2JDTnUdkS+sJ6c0KSJCfPM4XCGL9+wo=;
        b=i4oyZDhasB3BK4N58xBJKFV7wb9fn+1SGRZKwR34UdXB63m/A0ctudRtq27LnDuPzX
         TLoqbyusguNq5jwMxryJrk5tkyJWysGVxhcZ+27xGGZmOdC3T+RzhjNVrpG1o6ewhF9f
         MtCITc7U9pKFK3h0/jGDni3RSnjduO3gFObFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lkqIDoib68FB2JDTnUdkS+sJ6c0KSJCfPM4XCGL9+wo=;
        b=cq/BQwEw3ckAAvhvBSBg88+uoRgKO9RF5fIJHxS3U9gQywDu1JsaRt1cG92cjRDbT/
         pwhjjr7hljL+gj3Li9aIsMLx1Ld1h8DpdnvxTzN8TWVmM7Xs4uQlzl4MAnAx9LEUiKMT
         GGraAzO7qDTr94CwX/jgkxHkXiJPVC9KRuS5BMEnpIcudt70rXt5kqlwL8BUAWokjAT2
         ADzuwbkeq37dqKCGU7+9s2vGfvRYk7+pvXFAIYp/YV+6HvReM5xK6rJvt3TGIp+xDNuQ
         H26rwWoOM1iCTsZJqoks/0CsFFkGiLctGR/QDef3Sl5L70gSMi+pgbB6RCBBkr/nP/ez
         NPRA==
X-Gm-Message-State: AOAM531/4edwF1924OK/lh2bqWexnABz6b5O0xiMpDj8wlGwZBmgM+8l
        qR6Qlx5b4VGZKLD9fgbnS7mbDw==
X-Google-Smtp-Source: ABdhPJy1z/U/SgoeHL7kpt3JfXpLpI+JwdlQqILbEJfVHiYHPh4Qblisl0P/YTYl50n/NcdWbdpM8Q==
X-Received: by 2002:a17:902:fe8d:: with SMTP id x13mr1122508plm.198.1589336372539;
        Tue, 12 May 2020 19:19:32 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id w2sm14170600pja.53.2020.05.12.19.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 19:19:32 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/3] Bluetooth: Prevent scanning when device is not configured for wakeup
Date:   Tue, 12 May 2020 19:19:24 -0700
Message-Id: <20200513021927.115700-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi linux-bluetooth,

This patch series adds a hook to prevent Bluetooth from scanning during
suspend if it is not configured to wake up. It's not always clear who
the wakeup owner is from looking at hdev->dev so we need the driver to
inform us whether to set up scanning.

By default, when no `prevent_wake` hook is implemented, we always
configure scanning for wake-up.

Thanks
Abhishek



Abhishek Pandit-Subedi (3):
  Bluetooth: Rename BT_SUSPEND_COMPLETE
  Bluetooth: Add hook for driver to prevent wake from suspend
  Bluetooth: btusb: Implement hdev->prevent_wake

 drivers/bluetooth/btusb.c        | 8 ++++++++
 include/net/bluetooth/hci_core.h | 3 ++-
 net/bluetooth/hci_core.c         | 8 +++++---
 net/bluetooth/hci_request.c      | 2 +-
 4 files changed, 16 insertions(+), 5 deletions(-)

-- 
2.26.2.645.ge9eca65c58-goog

