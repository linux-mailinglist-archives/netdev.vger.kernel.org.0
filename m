Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055011412FD
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 22:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgAQV1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 16:27:36 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54873 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729235AbgAQV1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 16:27:35 -0500
Received: by mail-pj1-f66.google.com with SMTP id kx11so3697297pjb.4
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 13:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1l3obKwRCGQ8frlt+kT/Fwgd/74cacl1ClW7zB9H/o=;
        b=CYHEf/2Cn6TJeeZKMkiqa5bNKoh9HBjN2YlyR5SrXNyPtSogq9fsIX8WlZlhoP9xBI
         kUuFDVSg1b3/6VFpjCZKPOzOFZaFrWYvpEztWhQRjrDeDeig3MJprxaKPanOi9CzgY41
         GjMkeexGflv2Z9YfniznQcGAokcOlZb99+4xw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g1l3obKwRCGQ8frlt+kT/Fwgd/74cacl1ClW7zB9H/o=;
        b=IattADiSwe+6TfrnHxDxUnehmi1ahdZmlsT+m2jVTyLXUpJq8tZYEhs4YqWjDjgPk1
         0dXHVt77ZNiOWWB9OxcoCQo/kTiyOhobS0dyM3pAEvpPod7OW7+Cn935crJSqQcw6onm
         Qf+7VRyLT983umoJLUy6yXTgBQlZ6akJe/3et4EXSHugd8HUbYc58Bszm3aRRlEtBC3C
         SkFNnqrOE3QnlF4FCmTS4CPzxgQVgaWnFdQTUtGgeFXOfAX0bGixkqv0iAn/kroCktB0
         YprnpXSy8Vx2UNVOWCcZA+4wERRKkuHX8mRYANnq6fKri3k6qyXwrlBalCm+asr5/IwC
         1cMA==
X-Gm-Message-State: APjAAAXKY6V7Iai0wenIISTrWmUMoh54s6S/zk/ksr6H2aloy4z8YBkV
        0fTattcUUtMcgTtA2Aq6gX/uGA==
X-Google-Smtp-Source: APXvYqxVIeRLkgGU2AYw+K1fB38PoJYs1C0RKehuSzanbrmAgoDINfQJ8oQXlOnlVXne+BFVhg9fyA==
X-Received: by 2002:a17:902:9a42:: with SMTP id x2mr1384059plv.194.1579296454733;
        Fri, 17 Jan 2020 13:27:34 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id k5sm6999655pju.29.2020.01.17.13.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 13:27:34 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] Bluetooth: Handle system suspend gracefully
Date:   Fri, 17 Jan 2020 13:27:03 -0800
Message-Id: <20200117212705.57436-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi linux-bluetooth,

This patch series prepares the Bluetooth controller for system suspend
by disconnecting all devices and preparing the event filter and LE
whitelist with devices that can wake the system from suspend.

The main motivation for doing this is so we can enable Bluetooth as
a wake up source during suspend without it being noisy. Bluetooth should
wake the system when a HID device receives user input but otherwise not
send any events to the host.

This patch series was tested on several Chromebooks with both btusb and
hci_serdev on kernel 4.19. The set of tests was basically the following:
* Reconnects after suspend succeed
* HID devices can wake the system from suspend (needs some related bluez
  changes to call the Set Wake Capable management command)
* System properly pauses and unpauses discovery + advertising around
  suspend
* System does not wake from any events from non wakeable devices

Please review and provide any feedback.

Thanks
Abhishek



Abhishek Pandit-Subedi (2):
  Bluetooth: Add mgmt op set_wake_capable
  Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND

 include/net/bluetooth/hci.h      |  30 +++-
 include/net/bluetooth/hci_core.h |  46 +++++
 include/net/bluetooth/mgmt.h     |   7 +
 net/bluetooth/hci_core.c         |  71 ++++++++
 net/bluetooth/hci_event.c        |  24 ++-
 net/bluetooth/hci_request.c      | 297 ++++++++++++++++++++++++++++---
 net/bluetooth/hci_request.h      |   4 +-
 net/bluetooth/mgmt.c             |  94 +++++++++-
 8 files changed, 537 insertions(+), 36 deletions(-)

-- 
2.25.0.341.g760bfbb309-goog

