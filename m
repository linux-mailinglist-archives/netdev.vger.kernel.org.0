Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223E0F3CD4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKHA12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:27:28 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:50336 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfKHA12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:27:28 -0500
Received: by mail-pl1-f202.google.com with SMTP id x8so2907636plo.17
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WFqFHkCaqrzTakq6QlXJq9kHUsA/qAi5VJIcm52FwDk=;
        b=ca5GrBFrhTkcEfnMfUOSZpm+B13zD9UuiK+i3f9GOtZzoblQzdKgdwCz1fRzn2sTqY
         RTpXb8VyFxLMaUi6DnyKpSZSi8okdYClEfrY7sFQYG+R1JPm4m+NVyqRRKwajvRZT48Y
         dmKLubAJCBCaivsFsKaZ2k5e2Ji30FoLFprLfrXnUBasogAvedOzbDugE0hNHItSf0yx
         P6R6fGqqOb2FgQQ0cG+0EVxtInSbazrqQ+VlgjUio+IRmatCYe/hWJIZBhHyO0q/0J+a
         Ul1wXCIz3lt69r08UGdyMsDZeyZut1CYKeT1cVqRApHcYhnPKFIHkmviyzCg06dHKRaL
         0T3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WFqFHkCaqrzTakq6QlXJq9kHUsA/qAi5VJIcm52FwDk=;
        b=KB3TpV9Fx6AJxDGyxG6HPQKSC3VUQJAx3Wf+mTsdaCwJQe0jLN2nDGaH35sOvpSvTl
         JfUTLFL3SjClmUCRsmQ2ogdJR110Dt7XFXIpjA3kuhtfQ2xbZrmDBAp8BbmxFvV0GI2O
         R56Oaf8iJtU62DWN5INY+MuOShJsycCGbVNTTrCV1L9/PxXHgsIe/jFL9zehUNkXRMc5
         7MQpoWwpFjVMDHWnt0BL8aHCA2p8gehSxkoLjldB61oZKvTN7Z+InBBdqXeZo4MyutZ7
         mYDoiD6buwaEUt6ve+cKtzS4colR6C9ZPzZEdfVyC8clPP1/z/nXhUZtP9nJc0WSMrke
         IbcA==
X-Gm-Message-State: APjAAAXqfM0I0PyS+UgBAywt4gD38eDas2WJl9cTOi9qM/Zk14rMB/+a
        4D4Hwj+SB/jzT2TksNaDepg5227TXN6vMA==
X-Google-Smtp-Source: APXvYqyXrI4hcRvminlVhT/jk4m4adWYC3WLNMsuTTrDcOIsmcYKMoFzD8k/sjsNN+OdwRAB6O0fTqmzeV3qBQ==
X-Received: by 2002:a63:364d:: with SMTP id d74mr8176793pga.408.1573172846170;
 Thu, 07 Nov 2019 16:27:26 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:13 -0800
Message-Id: <20191108002722.129055-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 0/9] net: introduce u64_stats_t
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KCSAN found a data-race in per-cpu u64 stats accounting.

(The stack traces are included in the 8th patch :
 tun: switch to u64_stats_t)

This patch series first consolidate code in five patches.
Then the last three patches address the data-race resolution.

Eric Dumazet (9):
  net: provide dev_lstats_read() helper
  net: provide dev_lstats_add() helper
  net: nlmon: use standard dev_lstats_add() and dev_lstats_read()
  veth: use standard dev_lstats_add() and dev_lstats_read()
  vsockmon: use standard dev_lstats_add() and dev_lstats_read()
  net: dummy: use standard dev_lstats_add() and dev_lstats_read()
  u64_stats: provide u64_stats_t type
  tun: switch to u64_stats_t
  net: use u64_stats_t in struct pcpu_lstats

 drivers/net/dummy.c            | 36 ++++--------------------
 drivers/net/loopback.c         | 38 +++++++++++++------------
 drivers/net/nlmon.c            | 28 ++-----------------
 drivers/net/tun.c              | 32 ++++++++++-----------
 drivers/net/veth.c             | 43 ++++++++--------------------
 drivers/net/vsockmon.c         | 31 ++-------------------
 include/linux/netdevice.h      | 16 +++++++++--
 include/linux/u64_stats_sync.h | 51 +++++++++++++++++++++++++++++++---
 8 files changed, 118 insertions(+), 157 deletions(-)

-- 
2.24.0.432.g9d3f5f5b63-goog

