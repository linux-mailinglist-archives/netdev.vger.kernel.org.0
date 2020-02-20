Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0AF1660A7
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgBTPNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:13:55 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35134 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbgBTPNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 10:13:54 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so1674960plt.2
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 07:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=bMJUAglWaWbIZEErlVZ0yTCdWDkC7jYkZQda3XXE62Q=;
        b=tKINAgJ0p6sZD6U0O2h4bwxpfrupZWDIqr9wXBctvFse5GFxMsHnN02iA8U7YzBzri
         /KllxP2aOugr4N+X5pjCoQjP2YocZX6OwA16WqOdats8MmO9a9IWDCMdZdP+AhYQ7NwM
         GaG9S8eTwzFbK1QwJbi3HTEM1APmHUmOKdhycCPXRyIx8scR1bt1U6R4/ZxvfYmudeAn
         W/KzS4QLixLg08s30YcWaB+Lt1iTbaPgF9yTx2bcWq6Za35zBYLlXPETPRHzf5Lo1Gc4
         +j2wvjDhusuW52lJAQ4TIl72d+TV2koEEwWDXfOaWwXU29r0czUn/Yq6RtmK6U5BcGd2
         dyIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bMJUAglWaWbIZEErlVZ0yTCdWDkC7jYkZQda3XXE62Q=;
        b=fpxSyMUY2qhClHRDxKm21/KyxtT2dc7/pbe26LyaLh8UQIjvTPnzv7NaRRxpGFwhf+
         OGywcM3plzKg+wZvIhWMjVgaDWf+/u+TBnXfUtpBWWjLzHcu5QAB21LYAKwMAZ2HIKnX
         C0pBhs3jvQfEmqRq1KVSoguAiyWs1nORqOQHnYiYrcFg0+/XFZ8dNybdbsIF0u+VJ/om
         XYj5BPcdr2k/BiXcetC8QyujzZCWfAItfpUTzqQwBRqvTh3j7Yv0zcr+caeCKg+o7/tE
         uMrXluwQNTOqOjr1ayqKwbBvRjEm1spBp1yAV2ytjD6DuZm/Aug/WTlR+Z1RihQhexeZ
         ldtA==
X-Gm-Message-State: APjAAAUR0D0XFDf62R2HZlfFREWREFd3yypRbM/J6N2UG4+UI02eaItr
        vGgWUMEUXmw7b482yAewNidh
X-Google-Smtp-Source: APXvYqzFGueZdfe/6uJyF21F4s62BQbhb3H52MtdFXDE0w3cedIOjDgSxh+cqOfTkyvv2VjV2nXIRw==
X-Received: by 2002:a17:902:59cd:: with SMTP id d13mr32010465plj.146.1582211634020;
        Thu, 20 Feb 2020 07:13:54 -0800 (PST)
Received: from localhost.localdomain ([2409:4072:315:9501:8d83:d1eb:ead7:a798])
        by smtp.gmail.com with ESMTPSA id z16sm3865548pff.125.2020.02.20.07.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 07:13:53 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 0/2] Migrate QRTR Nameservice to Kernel
Date:   Thu, 20 Feb 2020 20:43:25 +0530
Message-Id: <20200220151327.4823-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This patchset migrates the Qualcomm IPC Router (QRTR) Nameservice from userspace
to kernel under net/qrtr.

The userspace implementation of it can be found here:
https://github.com/andersson/qrtr/blob/master/src/ns.c

This change is required for enabling the WiFi functionality of some Qualcomm
WLAN devices using ATH11K without any dependency on a userspace daemon. Since
the QRTR NS is not usually packed in most of the distros, users need to clone,
build and install it to get the WiFi working. It will become a hassle when the
user doesn't have any other source of network connectivity.

The original userspace code is published under BSD3 license. For migrating it
to Linux kernel, I have adapted Dual BSD/GPL license.

This patchset has been verified on Dragonboard410c and Intel NUC with QCA6390
WLAN device.

Thanks,
Mani

Changes in v2:

* Sorted the local variables in reverse XMAS tree order

Manivannan Sadhasivam (2):
  net: qrtr: Migrate nameservice to kernel from userspace
  net: qrtr: Fix the local node ID as 1

 net/qrtr/Makefile |   2 +-
 net/qrtr/ns.c     | 751 ++++++++++++++++++++++++++++++++++++++++++++++
 net/qrtr/qrtr.c   |  51 +---
 net/qrtr/qrtr.h   |   4 +
 4 files changed, 767 insertions(+), 41 deletions(-)
 create mode 100644 net/qrtr/ns.c

-- 
2.17.1

