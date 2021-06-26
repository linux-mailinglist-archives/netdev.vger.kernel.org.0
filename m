Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699303B4C02
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 04:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhFZCnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 22:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFZCnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 22:43:20 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E190AC061574;
        Fri, 25 Jun 2021 19:40:58 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j1so12702366wrn.9;
        Fri, 25 Jun 2021 19:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZU04GSGCtsrqt2KPTPge5U5HIHQjnrtdaZAx0zq0az4=;
        b=O82ivbMYO4ZZM2COWw+KrJk9iFQZW9WXG/51J2p3Jo+7H/LqJ/rPSJrxZ7t8xQBh7j
         10HMaf+9uX+ywdXWe+WgHexcZF28hAPAGGHS+f6dF2Sz5JlLWloefYRndgaMBq13W3JV
         CXnx+yKW+9M56YMdlvTssAAYvwblEcNom2HaL/8zEo+eRkMsSnCJMGaY+skoJ3vDG0S7
         mdhj10+kHj9jeGTsr+hgAsQbyppFaEMBvpJj9LIB0UJd0NuMpQI2LhuQ4AAoWS3Ph2eX
         u62iWrX/H2ckACJ68QnzHe3L5yKEqsqKsUgWgmzD/2fIzoCWnsP+25NoWPrufbiz/uvT
         eDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZU04GSGCtsrqt2KPTPge5U5HIHQjnrtdaZAx0zq0az4=;
        b=Xz9h3sRCdoeS+ZPUu4r9v3N0/mUv7euPBB0075wzPeymLRxVVRkrt1eBXy6//YkzTd
         GrZ/FqAbEnjAARvmg/Yb2muYOVB3APpZHDcySI7LiwpN6SMFpgg+qYugsxPn0tprNJ8P
         +SzzhILwhcxUjzj2SNoqGitGJtT8jHCOP3S6+hDgRa33EtMdShx12jzN0HX5Ny3koCd7
         CI9SjwTmevR15uzqjZQrQhXrhJOMYYeJ/dn9J5Yi9DPzSC0GU+KIVIJJbKYGhqLR9L6o
         N0LxHVDkg7AIl5wWrDDCqqyJXGWhErV5IWGIWfA/g22MfjMJk7UbIpdNzxlgshNj5rGN
         F4Ng==
X-Gm-Message-State: AOAM532SjSTAQw03OI2Vi8jNNV/wb+NAEnoyHvV/fyXJelxk7Ff/Xsdb
        Q2gZMORt8k5z9UYZNqPb0XxlCslUhB2Geg==
X-Google-Smtp-Source: ABdhPJxEeFt86hYNG7DGKrgR6nZgupnuGspsU+bJi2aink54b8Clg2Iv2bZaOyr/FUwf/H8Cavyi2Q==
X-Received: by 2002:adf:f942:: with SMTP id q2mr14244170wrr.427.1624675257450;
        Fri, 25 Jun 2021 19:40:57 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b5sm6686118wmj.7.2021.06.25.19.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 19:40:57 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Cc:     David Laight <david.laight@aculab.com>
Subject: [PATCHv2 net-next 0/2] sctp: make the PLPMTUD probe more effective and efficient
Date:   Fri, 25 Jun 2021 22:40:53 -0400
Message-Id: <cover.1624675179.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As David Laight noticed, it currently takes quite some time to find
the optimal pmtu in the Search state, and also lacks the black hole
detection in the Search Complete state. This patchset is to address
them to mke the PLPMTUD probe more effective and efficient.

v1->v2:
  - see Patch 1/2.

Xin Long (2):
  sctp: do black hole detection in search complete state
  sctp: send the next probe immediately once the last one is acked

 Documentation/networking/ip-sysctl.rst | 12 ++++++++----
 include/net/sctp/structs.h             |  3 ++-
 net/sctp/sm_statefuns.c                |  5 ++++-
 net/sctp/transport.c                   | 16 ++++++++--------
 4 files changed, 22 insertions(+), 14 deletions(-)

-- 
2.27.0

