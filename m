Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02ADB3A9C4A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 15:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhFPNoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 09:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhFPNoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 09:44:14 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE47C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 06:42:07 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l184so1983695pgd.8
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 06:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+BS5Fri1iArnxuxDqeMDo4fcwlq9ZyEjfYFMw064G+w=;
        b=a9RqT4YgxTJuHU8YpGk7nKIW/C1novPHlf5OCrb2ELwPi7+mtoERNyS7yXG/4wia9e
         ulGy0GYGA+/SnsTHCyLh+v3p6JSM0s3whaJvi80x6wv9eeYYxFlTT7wXxuBy32WiNnmf
         KL3rzN2J5pXvD0fl9+gnWYubZ7LVA3ASmv3bBcMjm+ZLNShAhWil4CzaQEg0Dl/bsbNN
         +/vOlfxUoaZDJ+AlBC90jPWFJCk0zeuW52IMeo+geOeCtpRsUu06aJX+zwVGaIxjmUwl
         BDM1r5yyWnr1DpfC3jtu4yvHyRF0Z0ZxDEjDGiVtUgrjR+lYcs6GxI/0BsV5qO38ffXY
         PK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+BS5Fri1iArnxuxDqeMDo4fcwlq9ZyEjfYFMw064G+w=;
        b=mEt0DipmmVmzIbhWYPx58p+rj3050fk9ZwZvrqTAGzEhSDlb+ZABOy8H6yUIpuAuVo
         Prvwkrfx4MAnKMF57HMwVK1SR/Ac1e97Xrlxlot0BQXChLj0bGF8KqcHeFTMtXKHa+SN
         8nd8qt1O5ENMWVRRE3PsYHzvsUrCqVp0XLTNhjS5T4oxBiEx6WyhxbT95cRVZZ9fkbNx
         /NJq/Af+JZOHUxZzHrIT0XtV6Q/yJExcIU865crsC9JL9+/bD83rM8nemtyj+KOUTttx
         uunu8DHpJGqBYt+0FMhQpnjbgmoEvVmbxx5uhg4YHB2QuHjFDowWW4BHzx+uixZtR3Xb
         c/aw==
X-Gm-Message-State: AOAM530q17U/bXcbvp4whhOla7Q7OMLmY+1apFxE4HezPv7Ms7FfnQtE
        pAge1pkq8wvm4aKq0v/e0CA=
X-Google-Smtp-Source: ABdhPJwLrc+fuYDm1j0PQks82914p6o1lQb3aKL/Cd17P3ReX++rJwxUUr+Uw/HQamaXLMKVs8A92A==
X-Received: by 2002:a62:7a4c:0:b029:2f8:49fa:bebc with SMTP id v73-20020a627a4c0000b02902f849fabebcmr9737481pfc.44.1623850927360;
        Wed, 16 Jun 2021 06:42:07 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e857:405b:92df:8194])
        by smtp.gmail.com with ESMTPSA id e6sm5764467pjl.3.2021.06.16.06.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 06:42:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 0/2] net/packet: annotate data races
Date:   Wed, 16 Jun 2021 06:42:00 -0700
Message-Id: <20210616134202.3661456-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

KCSAN sent two reports about data races in af_packet.
Nothing serious, but worth fixing.

Eric Dumazet (2):
  net/packet: annotate accesses to po->bind
  net/packet: annotate accesses to po->ifindex

 net/packet/af_packet.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

-- 
2.32.0.272.g935e593368-goog

