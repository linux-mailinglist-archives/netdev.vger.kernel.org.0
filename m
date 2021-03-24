Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3A03480E7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 19:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbhCXSrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 14:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbhCXSrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 14:47:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6077C0613DE
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:47:08 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 131so3350436ybp.16
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 11:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rKcNbR+LxTP4j4KG6QhvAtJ90pK5ENJOnzBCgg91Onk=;
        b=tHmA+b14JUxfjas7gHzGU6el3u3kffAUHUkD+sPuAhvVTGZmCTtIEJYIH1lxofX4qA
         Fng0ME678PGbmGlVLsIfQgNeZz6r6QSH542Ex82lanWrbWfn5G9aUYLoppQDYIjlO9aD
         x5HrVs0t+AgFqfePObi9np1MxOJObRbzom4bWTjbV/TcSu4i0ACNCJCG9fwDq2k2cKv2
         EjW1sPVQcMF/hPRN+lVWQoocH/B5UJK0T9jaeM1+ofq8yESoDPtECfhdsVW22pfdn6tc
         auPPqHm6ZeoP0dveluUbzuc9a5aHJrlyHpbkZiXIfGaMZ0inBit7rrZCSUJ+NawQWlry
         GVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rKcNbR+LxTP4j4KG6QhvAtJ90pK5ENJOnzBCgg91Onk=;
        b=HwLM4UJySkhsirf1OzAHyERO56OPY6fvv2fk/Kd5KPzvUZuQN/rsPtiXk0SRsJ+0uO
         JMhRQer3gK/ASnX0tsSLUWgvpZhiOgUjWyKGxE+PHbAnZsL2d+1v7LEb9zeYu60p+ncw
         fLfies4xlOtPYQyjWjrCW+pAswDwnFBfstaDhb6McyGQFYtl54S8EMevLDpKGG/Ts6ar
         aVsDUToUClziVzT5jy7V4TjPmaLdlt0/D9x89ym+qseubNMZrAZLk8omjS9jLxKz9JNQ
         reoIVLRT+eqwVZ8UDYjQluEwXaRJo+0MMd8fNJyZT4XKKm998BA9YcM4v1ULHnJ6VecP
         GFuw==
X-Gm-Message-State: AOAM530VumkhZpSXpCO17mSra9arb7+6Smc2WqsR8ZxSuZU4XoCl4A8n
        RuOZhdd4rYWVCnq/OGenGdqLBbaNzb3s1ZwfXQ4z
X-Google-Smtp-Source: ABdhPJw5jhML1zb+OVbUM2/vBIFd6z6LjwoP90Rg2G6aIKnjRPTyyQjQDggU3LK8VY9QFoCVintXXoK5ZaOWnp3RTHlh
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f18d:a314:46c6:7a97])
 (user=danielwinkler job=sendgmr) by 2002:a25:ba10:: with SMTP id
 t16mr6021053ybg.222.1616611627661; Wed, 24 Mar 2021 11:47:07 -0700 (PDT)
Date:   Wed, 24 Mar 2021 11:47:03 -0700
Message-Id: <20210324114645.v2.1.I53e6be1f7df0be198b7e55ae9fc45c7f5760132d@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v2] Bluetooth: Always call advertising disable before setting params
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In __hci_req_enable_advertising, the HCI_LE_ADV hdev flag is temporarily
cleared to allow the random address to be set, which exposes a race
condition when an advertisement is configured immediately (<10ms) after
software rotation starts to refresh an advertisement.

In normal operation, the HCI_LE_ADV flag is updated as follows:

1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
   __hci_req_enable_advertising, but hci_req configures an enable
   request
2. hci_req is run, enable callback re-sets HCI_LE_ADV flag

However, in this race condition, the following occurs:

1. adv_timeout_expire is called, HCI_LE_ADV gets cleared in
   __hci_req_enable_advertising, but hci_req configures an enable
   request
2. add_advertising is called, which also calls
   __hci_req_enable_advertising. Because HCI_LE_ADV was cleared in Step
   1, no "disable" command is queued.
3. hci_req for adv_timeout_expire is run, which enables advertising and
   re-sets HCI_LE_ADV
4. hci_req for add_advertising is run, but because no "disable" command
   was queued, we try to set advertising parameters while advertising is
   active, causing a Command Disallowed error, failing the registration.

To resolve the issue, this patch removes the check for the HCI_LE_ADV
flag, and always queues the "disable" request, since HCI_LE_ADV could be
very temporarily out-of-sync. According to the spec, there is no harm in
calling "disable" when advertising is not active.

An example trace showing the HCI error in setting advertising parameters
is included below, with some notes annotating the states I mentioned
above:

@ MGMT Command: Add Ext Adv.. (0x0055) plen 35  {0x0001} [hci0]04:05.884
        Instance: 3
        Advertising data length: 24
        16-bit Service UUIDs (complete): 2 entries
          Location and Navigation (0x1819)
          Phone Alert Status Service (0x180e)
        Company: not assigned (65283)
          Data: 3a3b3c3d3e
        Service Data (UUID 0x9993): 3132333435
        Scan response length: 0
@ MGMT Event: Advertising Ad.. (0x0023) plen 1  {0x0005} [hci0]04:05.885
        Instance: 3

=== adv_timeout_expire request starts running. This request was created
before our add advertising request
> HCI Event: Command Complete (0x0e) plen 4         #220 [hci0]04:05.993
      LE Set Advertising Data (0x08|0x0008) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Set Scan.. (0x08|0x0009) plen 32  #221 [hci0]04:05.993
        Length: 24
        Service Data (UUID 0xabcd): 161718191a1b1c1d1e1f2021222324252627
> HCI Event: Command Complete (0x0e) plen 4         #222 [hci0]04:05.995
      LE Set Scan Response Data (0x08|0x0009) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Set Adver.. (0x08|0x000a) plen 1  #223 [hci0]04:05.995
        Advertising: Disabled (0x00)
> HCI Event: Command Complete (0x0e) plen 4         #224 [hci0]04:05.997
      LE Set Advertise Enable (0x08|0x000a) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Set Adve.. (0x08|0x0006) plen 15  #225 [hci0]04:05.997
        Min advertising interval: 200.000 msec (0x0140)
        Max advertising interval: 200.000 msec (0x0140)
        Type: Connectable undirected - ADV_IND (0x00)
        Own address type: Public (0x00)
        Direct address type: Public (0x00)
        Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
        Channel map: 37, 38, 39 (0x07)
        Filter policy: Allow Scan Request, Connect from Any (0x00)
> HCI Event: Command Complete (0x0e) plen 4         #226 [hci0]04:05.998
      LE Set Advertising Parameters (0x08|0x0006) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Set Adver.. (0x08|0x000a) plen 1  #227 [hci0]04:05.999
        Advertising: Enabled (0x01)
> HCI Event: Command Complete (0x0e) plen 4         #228 [hci0]04:06.000
      LE Set Advertise Enable (0x08|0x000a) ncmd 1
        Status: Success (0x00)

=== Our new add_advertising request starts running
< HCI Command: Read Local N.. (0x03|0x0014) plen 0  #229 [hci0]04:06.001
> HCI Event: Command Complete (0x0e) plen 252       #230 [hci0]04:06.005
      Read Local Name (0x03|0x0014) ncmd 1
        Status: Success (0x00)
        Name: Chromebook_FB3D

=== Although the controller is advertising, no disable command is sent
< HCI Command: LE Set Adve.. (0x08|0x0006) plen 15  #231 [hci0]04:06.005
        Min advertising interval: 200.000 msec (0x0140)
        Max advertising interval: 200.000 msec (0x0140)
        Type: Connectable undirected - ADV_IND (0x00)
        Own address type: Public (0x00)
        Direct address type: Public (0x00)
        Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
        Channel map: 37, 38, 39 (0x07)
        Filter policy: Allow Scan Request, Connect from Any (0x00)
> HCI Event: Command Complete (0x0e) plen 4         #232 [hci0]04:06.005
      LE Set Advertising Parameters (0x08|0x0006) ncmd 1
        Status: Command Disallowed (0x0c)

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

Changes in v2:
- Added btmon snippet showing HCI command failure

 net/bluetooth/hci_request.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 8ace5d34b01efe..2b4b99f4cedf21 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1547,8 +1547,10 @@ void __hci_req_enable_advertising(struct hci_request *req)
 	if (!is_advertising_allowed(hdev, connectable))
 		return;
 
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
-		__hci_req_disable_advertising(req);
+	/* Request that the controller stop advertising. This can be called
+	 * whether or not there is an active advertisement.
+	 */
+	__hci_req_disable_advertising(req);
 
 	/* Clear the HCI_LE_ADV bit temporarily so that the
 	 * hci_update_random_address knows that it's safe to go ahead
-- 
2.31.0.291.g576ba9dcdaf-goog

