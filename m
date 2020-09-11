Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540222665E9
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgIKRSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgIKRNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:13:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9648EC061757
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:13:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x123so7852803pfc.7
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9xx/aNqVyo8F+vwS35kGQGZUtQETH2qUMc7jEIvGGiw=;
        b=GZDyuoKHjUGYRo0q4YPBblihRY7pVBrudliixlJ7RLgVwDc+Kb5t+Undpb8QD8ma1k
         LxcEc4G4bBSIQ2egiR316Cnaz8Lb6jVplZhJXxXv4s5AQPe7Bhs1z9tnzvyqBP56gnxi
         fxVvfLI3EnCu4SpB/ycK4W7PuhQE1S57liyYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9xx/aNqVyo8F+vwS35kGQGZUtQETH2qUMc7jEIvGGiw=;
        b=I5+KZJdac5oRL9jF5fu2SmuSmRa+VLedk4ox7ryonmnPHLxMkmub591mkp3RxOUNeY
         DX1JxhpsvW23bbkxtrKQqA9TmfaDK+2KadbPqKvL/WzBcVb9YMFxkGpNumyXj5H3RM8O
         7Vh5La+ij8YwFe4IcDq8HlFkkl5Dhm5q7LR/GE4Ts3Dp08uYlUr9xJoDpP6UYhRxpR+3
         JUbhCu1v9p7vaR7Sa17+FScHER/8EiM5CgshrSoDhQ2yJSJZImXrFH3kNORC9TvOMEOp
         rpeAbxwkB27DjisWQugQTTDa6vev99RJjrxeuYa5ywfB0I+EmGfh5ke5WjIdhIIztNFS
         nStg==
X-Gm-Message-State: AOAM530g0abPnXzMTZ03evZVwLAFn33ZDJQpo54GvG+A3SQmyktvN520
        m1UZ/mhHhplW5BVTd5WOmrgiVg==
X-Google-Smtp-Source: ABdhPJydKYhFb52mw7so7AX3H27Z2tg1yZLck6RxPp1D+3/fVJBJsaDGZl3UZMOdjs43ONG+bWVCPA==
X-Received: by 2002:a63:4d5:: with SMTP id 204mr2422300pge.0.1599844391141;
        Fri, 11 Sep 2020 10:13:11 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id h9sm2787452pfc.28.2020.09.11.10.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 10:13:10 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RESEND PATCH 0/3] Bluetooth: Emit events for suspend/resume
Date:   Fri, 11 Sep 2020 10:13:03 -0700
Message-Id: <20200911171306.3758642-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marcel,

This series adds the suspend/resume events suggested in
https://patchwork.kernel.org/patch/11771001/.

I have tested it with some userspace changes that monitors the
controller resumed event to trigger audio device reconnection and
verified that the events are correctly emitted.

Patch for btmon changes: https://patchwork.kernel.org/patch/11743863/

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
2.28.0.618.gf4bc123cb7-goog

