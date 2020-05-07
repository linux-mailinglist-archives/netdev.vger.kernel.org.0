Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB2D1C9691
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgEGQc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726393AbgEGQc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:32:27 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34798C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 09:32:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r18so7585798ybg.10
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 09:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=m2MaQiv89zOuh3FDuCvScmLssibqa+62mXVPf4mWtG0=;
        b=VyZ0NWTnmfCinX4B9TU31jpDuqv0PYZYVOZ2wxqyZ1KiE/gl+qiE0NkJAVZPI+LXzn
         0lc98Fmd0WU6czoh5eRAilI4D+YLMk28Abllux8cVZnheQsR6av5TJfsbZuNOftSnJGg
         ScrXI4NZUePgGmCv26eX3XClBrBz3dPc9QuaGb7CBZizA/pQT0tvSsmGu8ts0Z/qplKb
         e8e44YrLUMfe18Zzasj//hGC9W1WKAsFe91kFdmG3LnBcWsJKL/2f//mZX7z2WBtbr09
         i1aPj1oaasKqHfDQAIxnQ5FvLPRfMrOW+UzlWbpMMberMAWA5QXRD03aYL9DXzunadb9
         XCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=m2MaQiv89zOuh3FDuCvScmLssibqa+62mXVPf4mWtG0=;
        b=b9bEuPgNpmwltsM7xkYVZXuEuMFSNyyYL6OnnspnGOuOy5ptEf+ZGfCzdqp5FVkYgY
         YJUDgoqHuuoDX0C2SY9jUvOT7mzAOspZ76QaV0CtPV23fEPlqMn5FwLSlDNqzpC4foQ5
         UAciQVBJbMgbZxAHhubIii5BZmIdx3qJ6wy7QTdtEGQoiQwosr1not1mQ2It8QwP53DS
         NvKVPDR74sSCW1hMcM47TRJEuySJ6yT8SDDcC/9eQcwtM5NERPW4MDC2RhjZj+wZmsHd
         ShtOtn0Tww6EGuF/WVT4aDenR1Vgws+h7jmNrWKBRsjsXM9zln6CVYtJHMtYJrjmtyhc
         4McA==
X-Gm-Message-State: AGi0Pubzumh4/GqNZrchpy0ANddMtH1mdPzKaoYEPFyOD5VG0XL/jT5K
        ua8O+VYrTLTc+Ot7QtnuAsLFWNZuFPDu/Q==
X-Google-Smtp-Source: APiQypJy8SitOuTjRFNn3fRgO/KSPmK/CiezbCGR02JbosRuHB9BnlbPgqdAhkvUD/er6rMDdAydKHrN3ZViZw==
X-Received: by 2002:a25:4289:: with SMTP id p131mr23721635yba.311.1588869145367;
 Thu, 07 May 2020 09:32:25 -0700 (PDT)
Date:   Thu,  7 May 2020 09:32:17 -0700
Message-Id: <20200507163222.122469-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 0/5] bonding: report transmit status to callers
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

First patches cleanup netpoll, and make sure it provides tx status to its users.

Last patch changes bonding to not pretend packets were sent without error.

By providing more accurate status, TCP stack can avoid adding more
packets if the slave qdisc is already full.

This came while testing latest horizon feature in sch_fq, with
very low pacing rate flows, but should benefit hosts under stress.

Eric Dumazet (5):
  netpoll: remove dev argument from netpoll_send_skb_on_dev()
  netpoll: move netpoll_send_skb() out of line
  netpoll: netpoll_send_skb() returns transmit status
  netpoll: accept NULL np argument in netpoll_send_skb()
  bonding: propagate transmit status

 drivers/net/bonding/bond_alb.c  |  7 ++--
 drivers/net/bonding/bond_main.c | 60 ++++++++++++---------------------
 drivers/net/macvlan.c           |  5 ++-
 include/linux/if_team.h         |  5 +--
 include/linux/netpoll.h         | 10 +-----
 include/net/bonding.h           | 16 ++++-----
 net/8021q/vlan_dev.c            |  5 ++-
 net/bridge/br_private.h         |  5 +--
 net/core/netpoll.c              | 29 +++++++++++++---
 net/dsa/slave.c                 |  5 ++-
 10 files changed, 65 insertions(+), 82 deletions(-)

-- 
2.26.2.526.g744177e7f7-goog

