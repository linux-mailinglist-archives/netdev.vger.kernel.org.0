Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF14217D64D
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 22:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCHVXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 17:23:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34294 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHVXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 17:23:51 -0400
Received: by mail-pl1-f195.google.com with SMTP id a23so450430plm.1
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 14:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tzW7HssZBtY3SvxCb22E4ke3jvHNoIbFs14WY4NcNA=;
        b=bsR7I29sZ7HfQSRCAWI51eV06TbZfLHVY993eC6fVQqxIVQt1NptdMVXm/LrxLBCbl
         Tlz0S0zWxgO+UynwKVdIWh9nCHZxu74LqYXv2XWjUiTkt1XmFmUl9JG4kgka3YKjBTqL
         bzm6pFJdujJETyNaI9EGQk1oSgV0oqBlguB9s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tzW7HssZBtY3SvxCb22E4ke3jvHNoIbFs14WY4NcNA=;
        b=WeZwhuHFZNvOINon1tNtRoEIo4Mv9DYzcqPz/fQFe9AN5IChLQ8bzZUyNV0WGf6o+w
         IIXCdhbfsxIdZG067RVOS0yV0ZY9H0IcQ9/KcS8Y1tIj7I8JyL68UH659yEY6zxAnUOL
         OEWYDAxw2lgcNpjAqTnnPDt+Tms429c4OgjbWLSivK2EceBZTq2JYTbRHx+sotdTZ2Lk
         xMkaUcOIP1WoP1XZU9D6DGfherVNIEzg8yCNrioVtrcUReWwfYfzq0zJwWYpGErtiSxx
         Zb/Zrw3RcTbuylg9WCF9F9M1Ez7ydbKaSZeu41nRNq4TcmoygTCix3COL/v7q2sjWu9w
         wWhQ==
X-Gm-Message-State: ANhLgQ3+LtS2OV/rPzmZVZzIvLfbYEFdP6ZdsUa7+QbgPugGewd2HQG4
        qR0fDVukOvBUR/AyIXmwOLTOkQ==
X-Google-Smtp-Source: ADFU+vvelZvzMJOKHIDQCA76OpDS1N/lyb9dlkT4CLYv3R+PMp59C7h2DOAkY1Yx0ZU74tx7JibdGQ==
X-Received: by 2002:a17:902:6b48:: with SMTP id g8mr12825346plt.149.1583702630315;
        Sun, 08 Mar 2020 14:23:50 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id k1sm39509228pgt.70.2020.03.08.14.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2020 14:23:49 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, luiz.dentz@gmail.com, alainm@chromium.org
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH v5 0/5] Bluetooth: Handle system suspend gracefully
Date:   Sun,  8 Mar 2020 14:23:29 -0700
Message-Id: <20200308212334.213841-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
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

Series 2 has refactored the change into multiple smaller commits as
requested. I tried to simplify some of the whitelist filtering edge
cases but unfortunately it remains quite complex.

Series 3 has refactored it further and should have resolved the
whitelisting complexity in series 2.

Series 4 adds a fix to check for powered down and powering down adapters.

Series 5 moves set_wake_capable to the last patch in the series and
changes BT_DBG to bt_dev_dbg.

Please review and provide any feedback.

Thanks
Abhishek


Changes in v5:
* Convert BT_DBG to bt_dev_dbg
* Added wakeable list and changed BT_DBG to bt_dev_dbg
* Add wakeable to hci_conn_params and change BT_DBG to bt_dev_dbg
* Changed BT_DBG to bt_dev_dbg
* Wakeable entries moved to other commits
* Patch moved to end of series

Changes in v4:
* Added check for mgmt_powering_down and hdev_is_powered in notifier

Changes in v3:
* Refactored to only handle BR/EDR devices
* Split LE changes into its own commit
* Added wakeable property to le_conn_param
* Use wakeable list for BR/EDR and wakeable property for LE

Changes in v2:
* Moved pm notifier registration into its own patch and moved params out
  of separate suspend_state
* Refactored filters and whitelist settings to its own patch
* Refactored update_white_list to have clearer edge cases
* Add connected devices to whitelist (previously missing corner case)
* Refactored pause discovery + advertising into its own patch

Abhishek Pandit-Subedi (5):
  Bluetooth: Handle PM_SUSPEND_PREPARE and PM_POST_SUSPEND
  Bluetooth: Handle BR/EDR devices during suspend
  Bluetooth: Handle LE devices during suspend
  Bluetooth: Pause discovery and advertising during suspend
  Bluetooth: Add mgmt op set_wake_capable

 include/net/bluetooth/hci.h      |  17 +-
 include/net/bluetooth/hci_core.h |  43 ++++
 include/net/bluetooth/mgmt.h     |   7 +
 net/bluetooth/hci_core.c         | 102 ++++++++++
 net/bluetooth/hci_event.c        |  24 +++
 net/bluetooth/hci_request.c      | 331 ++++++++++++++++++++++++++-----
 net/bluetooth/hci_request.h      |   2 +
 net/bluetooth/mgmt.c             |  92 +++++++++
 8 files changed, 558 insertions(+), 60 deletions(-)

-- 
2.25.1.481.gfbce0eb801-goog

