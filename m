Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302B918384E
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgCLSLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:11:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43602 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgCLSLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:11:03 -0400
Received: by mail-pf1-f195.google.com with SMTP id c144so3640529pfb.10
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1r2hqBwaO/kXT5sadF+nxqNCtN3Dus3oicu3doTosoE=;
        b=j9EWbDuxdtPVrVMGo4g9ExD52Du4/T/igLgDcH42KRTjU6y75HsFQkhrQ/bwHZ3/O6
         7mkGbWdalaG0JS7k3bYNBIm66Z8Iml9+4mPN8AmEuunwcmVpaSYTdHXLemTTceKsBsU+
         plUohAf86OM+LkovQFpdDLktjvutMG0n3IurE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1r2hqBwaO/kXT5sadF+nxqNCtN3Dus3oicu3doTosoE=;
        b=Lm2zs2Wz3U0h8cLBwkzHlhaoCXncLG35sSxyBTLsmZpwsm1Q5EG7fimhRemaBdLup6
         EmlxCay1Gz8xQWyEtwVof4CqQspHmbhIvXgR634oHjveUcvc1GRHrZs6pn1jaO1UY1pY
         O6XpjJv6vtL1+rZFp39TMzvaU0u0BLaBOqyQoVgk9vw6/I69Iu2D+O4MMP6z5T+bZmFI
         dhOICUkGenmtC8NRMLodPD9J/vjj3z5mjsMUXqF94P9PAYQKroZd8Oo2keFLegMmwyUP
         hngxVPrD5Mkdc+AY6ENQxuKh4csqXrpwq5LEJzL038bKh4mvPSNsLBkcG3AGmG2DYr1H
         GoSg==
X-Gm-Message-State: ANhLgQ1ajsO3BEUkk9S4ctyXvHOYAAZaBbFqHWqOgTBhvwlSc9C/kQkI
        3Vfx0OdK8SwaQ4VEIkC+Q2GkOw==
X-Google-Smtp-Source: ADFU+vu7HWZMs5iJFzE+oa997HRVSVS4ZUzn+3cxJq0K5Cw2fuo9QjichDhlzf8YgyHRaX8xraS3PQ==
X-Received: by 2002:a62:144c:: with SMTP id 73mr7218549pfu.265.1584036661706;
        Thu, 12 Mar 2020 11:11:01 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id b18sm56787876pfd.63.2020.03.12.11.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 11:11:01 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/1] Bluetooth: Prioritize sco traffic on slow interfaces
Date:   Thu, 12 Mar 2020 11:10:54 -0700
Message-Id: <20200312181055.94038-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi linux-bluetooth,

While investigating supporting Voice over HCI/UART, we discovered that
it is possible for SCO packet deadlines to be missed in some conditions
where large ACL packets are being transferred. For UART, at a baudrate
of 3000000, a single 1024 byte packet will take ~3.4ms to transfer.
Sending two ACL packets of max size would cause us to miss the timing
for SCO (which is 3.75ms) in the worst case.

To mitigate this, we change hci_tx_work to prefer scheduling SCO/eSCO
over ACL/LE and modify the hci_sched_{acl,le} routines so that they will
only send one packet before checking whether a SCO packet is queued. ACL
packets should still get sent at a similar rate (depending on number of
ACL packets supported by controller) since the loop will continue until
there is no more quota left for ACL and LE packets.

To test this patch, I played some music over SCO (open youtube and
a video conference page at the same time) while using an LE keyboard.
There were no discernible slowdowns caused by this change.

Thanks
Abhishek


Abhishek Pandit-Subedi (1):
  Bluetooth: Prioritize SCO traffic on slow interfaces

 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_core.c         | 91 +++++++++++++++++++++++++-------
 2 files changed, 73 insertions(+), 19 deletions(-)

-- 
2.25.1.481.gfbce0eb801-goog

