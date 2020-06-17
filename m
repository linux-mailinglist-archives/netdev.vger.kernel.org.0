Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB461FD4D0
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgFQSsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQSsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:48:31 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EC2C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e192so3555456ybf.17
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=F01vx6WQfdDvBApvD1kgkEb9J8VkASHiWh21QIhkIvA=;
        b=qUDt53ZER2Vay6YYvIagT9JemF5QJNX3plSbn53QevWYfkpRTqO3572dVxpvdfWGzm
         1yCyqJdm0zBPhOVPawQAukhNqRKDWOg+NQRubyGLgDrm7F9IUX5ygr0Utp9kvncLTZ2T
         Vo2MFoZvMrxZZ87G0L0EIb8KObD/VvaQXOlkghnuzjXE7AI8Dmy59bnMWhS/FvWuTGr2
         vRW3L2BXKW/0KoKpZu6A8erK4qb9kLi/NQ8Sb+P5GH4FwHxSTOe0E/SvqjLz/gR+raOM
         cSMGJsmt2pNWxPxMoULyGKgqjcaudVmFQwc4TPVqyIKXZrlX+SQ7HsU1EQkV3vd1BMJV
         eLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=F01vx6WQfdDvBApvD1kgkEb9J8VkASHiWh21QIhkIvA=;
        b=FYKTnaiBbYIhYLin9N/5iHjl1QDv0qmbx5EwJAt/d4/0G3qCj+hMveLHuWWCr7PYn0
         HiDxssbg6AtAE6ePkKRg4r1h3JLx/Y4v5V7EAMEJCj5cFxT24m2A7yB0QEAY3q7i2XvW
         B17TNITlkfvpoa43rjX8V4xAcfT9wdsk56tCb0CuIW7POA3IaNLSj/UzMwEYQe8ufsjd
         EbxrEHOWUoG0/c8JhcNFLH959XDC8+YK50YJeTjcL7Yjfc6BenbnnIhQdMHiAo3U07NM
         BFCclvARvJAUhsrpdPcUdhWjUaJtN5GblxxrR68epuiq4l/COjGuX6LWX7OFR06FixFQ
         y61Q==
X-Gm-Message-State: AOAM530Yt0qXm8upnfkfdrBmST2U2yFXdk6dmak2XaCEyM2KgWVGf9l2
        7b/dcJPccC1Ey4HihUYADqJ/IdjmCx+meQ==
X-Google-Smtp-Source: ABdhPJyRTy/L7gZ+FKoWqQN9vzR6r+KyvgekJZ1jThSUajZsq972JoHVzp/qbxzbGo+uIfSHC+orQF8xzTkiQw==
X-Received: by 2002:a05:6902:729:: with SMTP id l9mr440152ybt.381.1592419709260;
 Wed, 17 Jun 2020 11:48:29 -0700 (PDT)
Date:   Wed, 17 Jun 2020 11:48:14 -0700
Message-Id: <20200617184819.49986-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net-next 0/5] net: tso: expand to UDP support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
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

Eric Dumazet (5):
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
 .../marvell/octeontx2/nic/otx2_txrx.c         |  6 +--
 include/net/tso.h                             | 23 +++++-----
 net/core/tso.c                                | 44 ++++++++++++-------
 8 files changed, 54 insertions(+), 45 deletions(-)

-- 
2.27.0.290.gba653c62da-goog

