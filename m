Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A269244FD3
	for <lists+netdev@lfdr.de>; Sat, 15 Aug 2020 00:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgHNWXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 18:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgHNWXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 18:23:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2E9C061389
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 15:23:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u10so4799520plr.7
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 15:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5jRl27RMtgZLeq7b/WHxRkukWBIOKeVCPevK+sNiPhQ=;
        b=k73o73VNd0qn9M+iiKly87GFMMXb6KyBorDW4eREbb7tWN2jSXYRFziRAoYgSezuUF
         FLz13Od/1weIFdHYZAkH4EE6DZ2zj7DIZfLAK/em3ojP/RtKqLTLGoQKKszjB6dJ4pV9
         mte4YoB6Bc6FECyWkOAdnIkWLrrXIYtyO/yYs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5jRl27RMtgZLeq7b/WHxRkukWBIOKeVCPevK+sNiPhQ=;
        b=NxIWj0EweTsu8OQlfNQVZ9QOMzKhXFPnSwJTttxVMcABmMGcQQzEyUtT4FTIP5174m
         za5NWB7C2RBMZqo9UI1UPzOltJVyajr6pKN7Ei6kpfBuU2dtIvmkHxKzvcqwSlQiZro1
         SBIjlVr38TvS6x8mLiY02PlzeYlchK9bDP/zQkwyWDSMMEQYrgGYjc6Qv5dUdSlzVxFW
         LEQb2n2mSeDKgbYfVHaxLPS4+fB9RxUIziRXQDo0Sck+tAKZpgA5vNccbuM6/RbiZg/m
         agtC/cU45QyBWBcnGRolyUgyYe9K+/OWKU4aLOapHZLU4qUQP1Yp7rk/PEIAMqO/S+qv
         JvdA==
X-Gm-Message-State: AOAM5301J/5HevZhpxU6VYgue8bsfNUpSq9WFYfOvMkw+386KPeWyWNa
        Ina5EDmHvSX1sPw9K0/RSy9Q2g==
X-Google-Smtp-Source: ABdhPJw4VToGF1Qswjip3GwGa5R4xOuQDDzZR0q80w8U/1h/s8l757szCrDYF3vT/E21VzKADGZyYA==
X-Received: by 2002:a17:902:82c2:: with SMTP id u2mr3422745plz.239.1597443823248;
        Fri, 14 Aug 2020 15:23:43 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:7220:84ff:fe09:2b94])
        by smtp.gmail.com with ESMTPSA id a17sm9302460pgi.26.2020.08.14.15.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 15:23:42 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] bluetooth: Set ext scan response only when it exists
Date:   Fri, 14 Aug 2020 15:23:36 -0700
Message-Id: <20200814152323.1.Ib022565452fde0c02fbcf619950ef868715dd243@changeid>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only set extended scan response only when it exists. Otherwise, clear
the scan response data.

Per the core spec v5.2, Vol 4, Part E, 7.8.55

If the advertising set is non-scannable and the Host uses this command
other than to discard existing data, the Controller shall return the
error code Invalid HCI Command Parameters (0x12).

On WCN3991, the controller correctly responds with Invalid Parameters
when this is sent.  That error causes __hci_req_hci_power_on to fail
with -EINVAL and LE devices can't connect because background scanning
isn't configured.

Here is an hci trace of where this issue occurs during power on:

< HCI Command: LE Set Extended Advertising Parameters (0x08|0x0036) plen 25
        Handle: 0x00
        Properties: 0x0010
          Use legacy advertising PDUs: ADV_NONCONN_IND
        Min advertising interval: 181.250 msec (0x0122)
        Max advertising interval: 181.250 msec (0x0122)
        Channel map: 37, 38, 39 (0x07)
        Own address type: Random (0x01)
        Peer address type: Public (0x00)
        Peer address: 00:00:00:00:00:00 (OUI 00-00-00)
        Filter policy: Allow Scan Request from Any, Allow Connect...
        TX power: 127 dbm (0x7f)
        Primary PHY: LE 1M (0x01)
        Secondary max skip: 0x00
        Secondary PHY: LE 1M (0x01)
        SID: 0x00
        Scan request notifications: Disabled (0x00)
> HCI Event: Command Complete (0x0e) plen 5
      LE Set Extended Advertising Parameters (0x08|0x0036) ncmd 1
        Status: Success (0x00)
        TX power (selected): 9 dbm (0x09)
< HCI Command: LE Set Advertising Set Random Address (0x08|0x0035) plen 7
        Advertising handle: 0x00
        Advertising random address: 08:FD:55:ED:22:28 (OUI 08-FD-55)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Advertising Set Random Address (0x08|0x0035) ncmd
        Status: Success (0x00)
< HCI Command: LE Set Extended Scan Response Data (0x08|0x0038) plen 35
        Handle: 0x00
        Operation: Complete scan response data (0x03)
        Fragment preference: Minimize fragmentation (0x01)
        Data length: 0x0d
        Name (short): Chromebook
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Extended Scan Response Data (0x08|0x0038) ncmd 1
        Status: Invalid HCI Command Parameters (0x12)

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Reviewed-by: Daniel Winkler <danielwinkler@google.com>
---

 net/bluetooth/hci_request.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index e0269192f2e536..e17bc8a1c66ddd 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1533,11 +1533,14 @@ void __hci_req_update_scan_rsp_data(struct hci_request *req, u8 instance)
 
 		memset(&cp, 0, sizeof(cp));
 
-		if (instance)
+		/* Extended scan response data doesn't allow a response to be
+		 * set if the instance isn't scannable.
+		 */
+		if (get_adv_instance_scan_rsp_len(hdev, instance))
 			len = create_instance_scan_rsp_data(hdev, instance,
 							    cp.data);
 		else
-			len = create_default_scan_rsp_data(hdev, cp.data);
+			len = 0;
 
 		if (hdev->scan_rsp_data_len == len &&
 		    !memcmp(cp.data, hdev->scan_rsp_data, len))
-- 
2.28.0.220.ged08abb693-goog

