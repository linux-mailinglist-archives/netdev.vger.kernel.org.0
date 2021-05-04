Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668EC373177
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 22:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbhEDUhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 16:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhEDUg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 16:36:58 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63E6C061761
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 13:36:02 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id b21so12805824ljf.11
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 13:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flodin-me.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0axzc7no5h3INRXc+5xP0BDp3d4xOPiiJKbi/m2zvG0=;
        b=nA0Vd3HsV37YAgXFnWawSi/QUAI712ahgzw7ZE2JNmqbv+UnWLJRodeqdyIeeZ++3k
         gY05zrgmnKAD4gTH55N25Nxqs4X7Fgi6yHs5E1TWCHQQ8A9605fzRpeHhBa22c/7JFC8
         zSY+5WtwB9XPqxTwg2ZYYIGqvYca1Ewh6b4dzjPC/vXByy3iuCzg8ORm9gmK9w/FGoU8
         GjkLfboxu3CBKVgTbV4dMWy/FdxOgS6DxwmnesgNXQP62L7H99LcYbjk04xpjkqWVHHL
         9wXS9Rch6nFZbtncdiIa9XJWa4Xs6AYEHaw9bz+D0IFiUUE1LrQoLPgsuj4bQr0o67jn
         /Khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0axzc7no5h3INRXc+5xP0BDp3d4xOPiiJKbi/m2zvG0=;
        b=bbmHV1CaZZCA1OOp4JrH6FThViKmhcuZJX5H9/XP0B961YEKD4nG5pGAcFpYd1YB7R
         wqsGXWQkJxpm7ZK22OJo8LmI0eyafp/h0eZPV+stqNsNrolAqhpEPUPmrjak16beR8Nu
         z4XsXPsxdc3gAmGFndgF9J2Wzi4vcFEfnlxxntFf7LAplF+kMqRlrytiuvsWjI2ZAVjS
         9C5w3Wpg4hTwC0uQXIRzZZQ5+TrafbXDnw6uUHjcNK+WHe1qN2+Q2G45gIJB5crmjKUu
         2JX0TpG039xDWBWuaqPA22YpHSyRIm/IK55LuNh+Na2b2jg0UXFR2pz9CtMt/pK+3eBB
         zoeQ==
X-Gm-Message-State: AOAM531dv1M3J5AZpG5g570r8aqH3eDd9SNV/7sjFILw678H3HuANrUg
        zC0rstVJPKosQnvyh9KM1j7U6r0zXcRe5CfH
X-Google-Smtp-Source: ABdhPJyUeoCJBYXqXV0qacfH28GoiRJuTtvPEt6/vftDe5OL79M2MJx9P5fHe1QdpXiP6+KjgToevw==
X-Received: by 2002:a2e:2c01:: with SMTP id s1mr3082191ljs.17.1620160561169;
        Tue, 04 May 2021 13:36:01 -0700 (PDT)
Received: from trillian.bjorktomta.lan (h-158-174-77-132.NA.cust.bahnhof.se. [158.174.77.132])
        by smtp.gmail.com with ESMTPSA id v1sm1792222ljj.77.2021.05.04.13.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 13:36:00 -0700 (PDT)
From:   Erik Flodin <erik@flodin.me>
To:     socketcan@hartkopp.net, mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Erik Flodin <erik@flodin.me>
Subject: [PATCH v2 0/2] can: Add CAN_RAW_RECV_OWN_MSGS_ALL socket option
Date:   Tue,  4 May 2021 22:35:44 +0200
Message-Id: <20210504203546.115734-1-erik@flodin.me>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a socket option that works as CAN_RAW_RECV_OWN_MSGS but where reception
of a socket's own frame isn't subject to filtering. This way transmission
confirmation can more easily (or at all if CAN_RAW_JOIN_FILTERS is enabled)
be used in combination with filters.

Changes since v1:
- Rebase on top of can-next/master.

Erik Flodin (2):
  can: add support for filtering own messages only
  can: raw: add CAN_RAW_RECV_OWN_MSGS_ALL socket option

 Documentation/networking/can.rst |   7 +++
 include/linux/can/core.h         |   4 +-
 include/uapi/linux/can/raw.h     |  18 +++---
 net/can/af_can.c                 |  50 ++++++++-------
 net/can/af_can.h                 |   1 +
 net/can/bcm.c                    |   9 ++-
 net/can/gw.c                     |   7 ++-
 net/can/isotp.c                  |   8 +--
 net/can/j1939/main.c             |   4 +-
 net/can/proc.c                   |  11 ++--
 net/can/raw.c                    | 101 +++++++++++++++++++++++++------
 11 files changed, 153 insertions(+), 67 deletions(-)


base-commit: 9d31d2338950293ec19d9b095fbaa9030899dcb4
-- 
2.31.1

