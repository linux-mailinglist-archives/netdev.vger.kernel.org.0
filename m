Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027252517C6
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgHYLho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbgHYLga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 07:36:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F22C061574;
        Tue, 25 Aug 2020 04:36:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ep8so1098326pjb.3;
        Tue, 25 Aug 2020 04:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G5TWazzzMgjC9Slh4n6C2utp132vqwOdTyqnBKUdMpI=;
        b=aA1xYLITkGAScs4a36jGJoqczNTRUpXBf8l/paUBl3mDrZiVkmbdVZ9JXPsoqzzApa
         KBcDqNMM34uEWH524uRt5CnUJOWsM+yCohXl4GJfy9WO8o5x9+oA3pafSxYSewzMrpTB
         gX0Nfm9cIAH9HOFhKuyvKzmIzubCu8hgkQoheStAJ6NlzKCdULx8tA6bjfECWRBWore5
         tYe4cDPurSEU2tAnfo+VTFpLCObr4gXxBKgyfKWCARN/HeEXyg3PPZaFSLWkMI5xmVyY
         0Vu5E4T65scLOem0nF/1auSnfy9rc7/6aoDi3krbd3RBTQRLhUTJMSBUgU/o8ChUHVl7
         zJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G5TWazzzMgjC9Slh4n6C2utp132vqwOdTyqnBKUdMpI=;
        b=T/37YGjj7VLhYw+hVP98lbJLaqs16iNR4XTuY2FwJxqytDj/FTyTHq9mgunH6wenx1
         SmT6CcQswY3oKRywQ5J9GWwgPCCN5I1gLlmnudcVNZdYYmOkwlHh27m6Y9h8nLFz3nJS
         vKMJxmnJ5Nu9gADerJX0G1sI73SE0S87VK4U6+kXuptjTIyO3CRCOFh5XhyU6E2yHHNI
         XNukRqmt4xtQxDBefsnE5kFrOrd73Ag3EcbxlCOh6k01x8ACAqd4Pnf/sx4X1mOO3Qdj
         axeudsKlZJLG/9Q72KFbqIIXeOBsp2iX0IiCuq7zjMQn64CwAjs9gLGoMJ2jAcdGZ6Xy
         PZKQ==
X-Gm-Message-State: AOAM532IzMbD2WeETKAH7PGdmBB4ijY1wFdGHnFSGCDpr/X2ML67vwBE
        Hb8pwjTOjvHJIdJHYBkAVdA=
X-Google-Smtp-Source: ABdhPJzQDPQApDpR0aE4b/lgD3iBQmB+PwT/twzUE45OQ8F7EVRGMnmWWmDM73jv1oTqKpi452tzSg==
X-Received: by 2002:a17:90b:b18:: with SMTP id bf24mr1134056pjb.223.1598355372921;
        Tue, 25 Aug 2020 04:36:12 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id e7sm12699937pgn.64.2020.08.25.04.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 04:36:12 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 0/3] i40e driver performance tweaks for AF_XDP
Date:   Tue, 25 Aug 2020 13:35:53 +0200
Message-Id: <20200825113556.18342-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains three patches worth of driver tweaks for the i40e
AF_XDP Rx path, that in total improves the Rx performance (rx_drop 64B
packets-per-second) with 9%.

Please refer to the individual commits for more details.

v1->v2: Removed the napi budget increase patch [1]. Instead, that will
        be sent out as a more generic series that addresses all AF_XDP
        zero-copy capable drivers, as suggested by Jakub. [2]

Cheers,
Björn

[1] https://lore.kernel.org/netdev/20200702153730.575738-4-bjorn.topel@gmail.com/
[2] https://lore.kernel.org/netdev/20200728131653.3b90336b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/


Björn Töpel (3):
  i40e, xsk: remove HW descriptor prefetch in AF_XDP path
  i40e: use 16B HW descriptors instead of 32B
  i40e, xsk: move buffer allocation out of the Rx processing loop

 drivers/net/ethernet/intel/i40e/i40e.h        |  2 +-
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 10 ++++----
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |  6 ++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 19 ++++++++++++---
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  2 +-
 .../ethernet/intel/i40e/i40e_txrx_common.h    | 13 ----------
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  5 +++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 24 ++++++++++++-------
 9 files changed, 47 insertions(+), 38 deletions(-)


base-commit: 079f921e9f4d3992968a2fc5dc3af0a3540853cc
-- 
2.25.1

