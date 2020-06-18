Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2864C1FE9A5
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgFRDxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:53:32 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61839C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:31 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id w14so3387659qtv.19
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 20:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FgdaRGKNID6s0Fi/dVkHB0Y6OYa/Mod09NPSlx3byds=;
        b=CeuqRbKaaalIHGmGCYfSr+6TNSjS1sYGPLMD/88JJgET/S/dN4B8EEtnosn0YUhgLG
         U6hJJWk3zp4HZKu9tV+mRzI+VcRl2Zi6Ba5Up6WYnCLaBoYSNcI212xc0uszQN/XiqUF
         DslAUK4gYMcl9urVNcvD+37hXlNWrD2jYfRg/q+noyO8TCMdCGPpi1u8mDc1vSQPtWgx
         yQT7xJOMcsQDdZ4G/y4oSx+WMES1iYVKDF5rrgi9ZLFCZ8nH/XocjOBNvq8TH1i21GY4
         yopqZ7wKIfACoM6C6ry8eGSbw6Jrh/UmrZiKb61/QFhfQaSvcDXjf7n/gWcuBI+EYAHX
         FVWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FgdaRGKNID6s0Fi/dVkHB0Y6OYa/Mod09NPSlx3byds=;
        b=j9g2ufolZ2nZ5Aw73r7aaXK9A8ibwOxDBmC+FWtpzH1L7PWmug85DTJ8YWbTVYXcqP
         psrCZ49s96ge98JgfrS66aAspmCkPLNSB8d/MuAwcuLPMsbFmc0iqRTPFCDmOL5PJcQF
         4j+iMJDLVXIePaxsoM6QhqxNgWkwkQWNUvMBXrTAXFDPGQYaW/TB8OGNb0Nb43Wm3RMC
         Y73s6t42K0jKBVEqaos9NrBMs3C5ynx27sLRJ+Lw96ULRlnAWRawqaSiL4O+EAdLk0ZM
         0y1inh4WcYnCrAp3U1/Kh/zR5G9cqD4ZgJ4jhh2EZs1fG8J9kpl+2X1LfC3GRor2cvZW
         k2XQ==
X-Gm-Message-State: AOAM5309S8M4PEv5ztuPiEw64gqw/Q2tmiURSwi1FGaM+iOAiyGudKGK
        LOSHV/YeAisHrXaQsKNUy++DEqCS8aXY1g==
X-Google-Smtp-Source: ABdhPJyJtKRf1N/BR38iaJzOyRJxkKGqHL7L+8KfRmulowYhgAoZyeBe35XZNvasZYKTksANswm6TyBcVvXFEA==
X-Received: by 2002:ad4:494c:: with SMTP id o12mr1930185qvy.102.1592452409863;
 Wed, 17 Jun 2020 20:53:29 -0700 (PDT)
Date:   Wed, 17 Jun 2020 20:53:20 -0700
Message-Id: <20200618035326.39686-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH v2 net-next 0/6] net: tso: expand to UDP support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With QUIC getting more attention these days, it is worth
implementing UDP direct segmentation, the same we did for TCP.

Drivers will need to advertize NETIF_F_GSO_UDP_L4 so that
GSO stack does not do the (more expensive) segmentation.

Note the two first patches are stable candidates, after
tests confirm they do not add regressions.

v2: addressed Jakub feedback :
   1) Added a prep patch for octeontx2-af
   2) calls tso_start() earlier in otx2_sq_append_tso()

Eric Dumazet (6):
  octeontx2-af: change (struct qmem)->entry_sz from u8 to u16
  net: tso: double TSO_HEADER_SIZE value
  net: tso: shrink struct tso_t
  net: tso: constify tso_count_descs() and friends
  net: tso: cache transport header length
  net: tso: add UDP segmentation support

 .../ethernet/cavium/thunder/nicvf_queues.c    |  5 ++-
 drivers/net/ethernet/freescale/fec_main.c     |  5 +--
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  5 +--
 drivers/net/ethernet/marvell/mvneta.c         |  5 +--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  6 +--
 .../ethernet/marvell/octeontx2/af/common.h    |  2 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |  6 +--
 include/net/tso.h                             | 23 +++++-----
 net/core/tso.c                                | 44 ++++++++++++-------
 9 files changed, 55 insertions(+), 46 deletions(-)

-- 
2.27.0.290.gba653c62da-goog

