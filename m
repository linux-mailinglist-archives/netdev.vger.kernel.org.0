Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827E93B32CC
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 17:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhFXPuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 11:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhFXPub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 11:50:31 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF8BC061574;
        Thu, 24 Jun 2021 08:48:12 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id g3so844106qth.11;
        Thu, 24 Jun 2021 08:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R9+VKDibn9NfhjcFoZUD6oHbzR2Zf0N89Z4DFIz0UUg=;
        b=fIJ0mc+eTzRNPGGu229pL+J+opk4FDs2FGKSw4Qalj9EgtxIqUp19j1Cyg/jUOF7DJ
         Zxg9+whnldRC3c0EN1J61TT8uHSwZr07LqAggg2lj66fDsynb+sVxF46CScs2dxjMDHM
         t/Hg2xreyJAnkpTZjQbT1A6REclcIlp/HmNznDkbbVkF6aENyJCXMRMJy8NlmGgNQ1rQ
         eC/6Zoobe4afU++BArLenJkcKrE0ipan4dcrZA1OC4O26rNCDb1Loyv+7zlfWuOojZHJ
         PV2UW4vVTJERA3uHc2VIVSvPzHzOnXeHQt10X3PIhodHEUl4x8G5AHfu4ly0KD1CJyuC
         w6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R9+VKDibn9NfhjcFoZUD6oHbzR2Zf0N89Z4DFIz0UUg=;
        b=bexn/aqaVn3IM13vWD+sUKWeevuiTFdpzXVyKRUeMV5vJqWxmHE+/Dcb1VRZa1kLJ5
         0BXSznOU7EK9EPt6sIf/InTZo7oGFrApb5ZCnFOyxNV3dE0qC9MVDys97zarK/j2NTOh
         raZ2vecC9K8hT3rapn6AGCdjCpUYbRin198LLOFmD+4Kj5e7fcGqaINll9U+mqfYoKg2
         dSrl0gIL8180FCM02ARZN51EY9Yl3WtG9hSrbSB7l3UAIqxRHnQq7XAsN4UGH+71hsjQ
         6bEYMucW4n8FCtmHOn1ihjsDYwexMkEa8eO/kc1GYONp7gkoKYqcfBOdP3GKk1KH9H1+
         J1bQ==
X-Gm-Message-State: AOAM5315VPjsbeGJJQ23SWKATnckggJJBK18csRavF6QaLrDXF2rZP6V
        O0MkSdLEMKxrPL9kctpDmLZA59jeM4PK3Q==
X-Google-Smtp-Source: ABdhPJynEPsSyGIDYR6VePtr7oOuMh8S8I2BbGFtI/FE9cnDMEZ4qaLB0Ynv8aBuwn/ND41LEJFB7w==
X-Received: by 2002:ac8:5784:: with SMTP id v4mr999712qta.29.1624549691430;
        Thu, 24 Jun 2021 08:48:11 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id g19sm2181011qtg.36.2021.06.24.08.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 08:48:11 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Cc:     David Laight <david.laight@aculab.com>
Subject: [PATCH net-next 0/2] sctp: make the PLPMTUD probe more effective and efficient
Date:   Thu, 24 Jun 2021 11:48:07 -0400
Message-Id: <cover.1624549642.git.lucien.xin@gmail.com>
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

Xin Long (2):
  sctp: do black hole detection in search complete state
  sctp: send the next probe immediately once the last one is acked

 Documentation/networking/ip-sysctl.rst | 12 ++++++++----
 include/net/sctp/structs.h             |  3 ++-
 net/sctp/sm_statefuns.c                |  5 ++++-
 net/sctp/transport.c                   | 11 ++++-------
 4 files changed, 18 insertions(+), 13 deletions(-)

-- 
2.27.0

