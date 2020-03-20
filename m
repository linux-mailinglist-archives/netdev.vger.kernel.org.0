Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF9C18C416
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 01:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgCTAHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 20:07:31 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:44890 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbgCTAHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 20:07:30 -0400
Received: by mail-pf1-f174.google.com with SMTP id b72so2287793pfb.11
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kLb0ZW3Gt56un5tXJnGrDhWNvjh5tVVZUmrjKBTkr+I=;
        b=LY7Fc+nlEVtHs0x3b9ctNL+6CrOSlcR+dUMnjqvjQwijmEnKO6WMGSwm7kxpjqqoOP
         rQrvu1SMuG56ettv/vRNoQUuSnEvkfcvf9DdCO+i+sU1NuOcoAkGsBA2HbbgokioRHFt
         OUg11p+DIaNLmdcadaLQASLwXes5a1rc+XT9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kLb0ZW3Gt56un5tXJnGrDhWNvjh5tVVZUmrjKBTkr+I=;
        b=JOjVXlvvXj/BPAk/cVFuSPy17wxY30wolV5jPhlaKbs/3unyVx7ForNI7LJ+BSPAVE
         Q9TgT5NdO1G1y0rbQr0UQxKjOZpJ5WACQuqmam2QnyMQan1+lgn9NPYg1z2tXwo8Rtz/
         e39B4wvNtrm5jxBtqTOGS8f3oUmSVJA5jVaHllm3u6XF2SB+w0ZtetlL3mQ7ICJrUaDK
         W7AKbuWHvi9Jj5seiiXe9UYEWMGQf1yH5tOiAZZXt4C0eKjWgcLA6D/UfWptlJfRm04p
         XS7XVdPSl7cAmJRyuLI9Kfj9mWevbCbEKGzm8yIKDKcGmLRtWT9MyEp8dFqTUhx2+MZ+
         D4xw==
X-Gm-Message-State: ANhLgQ1rbyX3Z5fVh4MkVq8HEFPeF49TcvGYgx0P1vi4y6s9AJuGPqq8
        qIqBYEbnae7BwKB66lKLO/BZsg==
X-Google-Smtp-Source: ADFU+vu+R8yEHZtvdwQOflPfI/ieY4C1RoRUB74THQ9itVUwbo0VQhUooKemv0uAcyg5F8tYTYvIFQ==
X-Received: by 2002:a63:c507:: with SMTP id f7mr5766872pgd.278.1584662849286;
        Thu, 19 Mar 2020 17:07:29 -0700 (PDT)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id m12sm2928292pjf.25.2020.03.19.17.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 17:07:28 -0700 (PDT)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/2] Bluetooth: Suspend related bugfixes
Date:   Thu, 19 Mar 2020 17:07:11 -0700
Message-Id: <20200320000713.32899-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Marcel,

After further automated testing of the upstreamed suspend patches,
I found two issues:
- A failure in PM_SUSPEND_PREPARE wasn't calling PM_POST_SUSPEND.
  I misread the docs and thought it would call it for all notifiers
  already run but it only does so for the ones that returned
  successfully from PM_SUSPEND_PREPARE.
- hci_conn_complete_evt wasn't completing on auto-connects (an else
  block was removed during a refactor incorrectly)

With the following patches, I've run a suspend stress test on a couple
of Chromebooks for several dozen iterations (each) successfully.

Thanks
Abhishek



Abhishek Pandit-Subedi (2):
  Bluetooth: Restore running state if suspend fails
  Bluetooth: Fix incorrect branch in connection complete

 net/bluetooth/hci_core.c  | 39 ++++++++++++++++++++-------------------
 net/bluetooth/hci_event.c | 17 +++++++++--------
 2 files changed, 29 insertions(+), 27 deletions(-)

-- 
2.25.1.696.g5e7596f4ac-goog

