Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0E11D04A6
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgEMCJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgEMCJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 22:09:42 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D18C061A0E
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 19:09:41 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a5so10424004pjh.2
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 19:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=30k3g7kfn7bIzbjqMwYYoV+lbQ2qdyHsMEbPQh3FmRs=;
        b=VEnpDexEnncojA2+uni+RuhZttreiRApv7RLWNpsKCikVkF04Yah550tFknZwIINV1
         6GvJgAjKm6vBp29dmG9cgiQ04WVeBL8YAROTIDsBvkWFoYubQ17yHCXSjqLJIiRgrget
         MkNmUz/X/UoBbR2e85L/34rpRNnmcIukW9New=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=30k3g7kfn7bIzbjqMwYYoV+lbQ2qdyHsMEbPQh3FmRs=;
        b=lyUBAetxMqr0mqCVhVGH+4IFvTExY2wwcCc+Qk2nBa6tJVF3blw/RgOEWPWIY6qJr9
         5MQKqXpszHySo/1y1BCAVr1Iydxs+fRe3iUg7ssDBHsLHk4UjCZkg6MkrRq3RvDGNjvt
         Dd8Cnpy1I7NLhQiOV1PAfyAYKHOZiM9vGAAliDblwoe0jca4mjdAuPJThWLnOUjRqXha
         NTPeDXyFJJMRDWhuzp1ofV9czssPHAxZbdO1slR9f58W72n1/IU2FZQshf/bSa8o/RjE
         Bq0iC600v7scHCBu5xzn0bMiI639g2gIRl8hbX2biFux8EwSxM40R9plPiKPSvK5/lyI
         46zA==
X-Gm-Message-State: AOAM532XNlwqp8tdRsGhElN7EX7/N7kVfwuI4EX+wq9RczkM48fzAiIf
        ETCbdBdFrQDqpPzsGZDvDBDufA==
X-Google-Smtp-Source: ABdhPJwzjFKyOAvQxlaI87Fj2o2dIZsts/LJ9t7/iT1YUdO5bz9fWYeXCjxBWM39gJxQgizwI/xFAQ==
X-Received: by 2002:a17:902:b08d:: with SMTP id p13mr4543034plr.241.1589335780671;
        Tue, 12 May 2020 19:09:40 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id x7sm13456749pfj.122.2020.05.12.19.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 19:09:39 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/2] Bluetooth: Update LE scanning parameters for suspend
Date:   Tue, 12 May 2020 19:09:31 -0700
Message-Id: <20200513020933.102443-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi linux-bluetooth,

This series updates the values used for window and interval when the
system suspends. It also fixes a u8 vs u16 bug when setting up passive
scanning.

The values chosen for window and interval are 11.25ms and 640ms. I have
tested these on several Chromebooks with different LE peers (mouse,
keyboard, Raspberry Pi running bluez) and all of them are able to wake
the system with those parameters.

Thanks
Abhishek



Abhishek Pandit-Subedi (2):
  Bluetooth: Fix incorrect type for window and interval
  Bluetooth: Modify LE window and interval for suspend

 net/bluetooth/hci_request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.26.2.645.ge9eca65c58-goog

