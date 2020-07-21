Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753F42287B8
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgGURq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgGURq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:46:26 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABB2C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q17so10563917pls.9
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ABU+ms6bROYaNvduQpsHHlgiNnrFdR678+J3x02CBOk=;
        b=geDewetpQyS2t9bKzF1DMO4iyNw6BvZ3pGLBnZk3RbouOvQpaRwO9T1Ak+bEzXr4Td
         e+O8Z5kcjEbPG+OaRzV4T7OEw8ZlOs6VVC3s4y7mNlHfJwiFe0TsLv0bnXoyMEF7EpjV
         L/pVp30Q2SgDk2HEjXgKakiGKE2NvrQUmkpUN0V0zWcV351UmLnJLud8yKvLqD5jb2e4
         1sEeIRlTv0N7doUtlAPL1SkB6yVyF7/YhN04D5kzdUAhgrn4y5czcY5rsnOZsROD/nv8
         P+SJX+0hAvkHgppYkrfZgYXUTeSRuQK4VuWWtHKKCEN5bz9naOXUFuOPNJFrfiiE1YTo
         YI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ABU+ms6bROYaNvduQpsHHlgiNnrFdR678+J3x02CBOk=;
        b=C0DpIYXiNl0N49R+BFWvyh5AL4Jxxk+4JnPsn3fKzevnbKBoJH3sqFKF/TpBkaeiSJ
         fVBZedffCeOVe+UXVA+xmbcVoNbXZi8DmFi1MWUPlEnTzhLqe+LITe5xcMD3VQUD8sWe
         vzmPgcn/dZ1wf6KgpJGa25OuuCCtP3xbChlxplq4E/09yH73HZ8Al96ahExKcSd+sLwF
         Bw3xzn5te8fFvzHcKigath1PXQNdpjv0zOYqx80J+BdsI9Nv5c2Pezspf3DhY3qqbfuR
         I2feanT50KsZJjrrKe2jz8+g9+pB0RlQnjY0wGp5+csaLCH5n1CWqkLXP0NWOgpme6vq
         JTaQ==
X-Gm-Message-State: AOAM530Fw0zQHVyIH/R4MwInsqTa7YBus/J8021UvHGZ8gJQruU0eq+d
        g+23Dbf/0+naSTzvAbG7udafvMhI4JA=
X-Google-Smtp-Source: ABdhPJwq29onnKD0SwnFWN34mH3Jwo6CR1Df68z+M14Q0BtmfjgyQ5MSOiBZSJ58A6i9vzdofS3OKA==
X-Received: by 2002:a17:90a:ff03:: with SMTP id ce3mr6361529pjb.174.1595353585854;
        Tue, 21 Jul 2020 10:46:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c14sm4598712pgb.1.2020.07.21.10.46.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 10:46:25 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net 0/6] ionic: locking and filter fixes
Date:   Tue, 21 Jul 2020 10:46:13 -0700
Message-Id: <20200721174619.39860-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches address an ethtool show regs problem, some locking sightings,
and issues with RSS hash and filter_id tracking after a managed FW update.

v2: filter spinlock additions and debug msg changes were
    split into separate patches

Shannon Nelson (6):
  ionic: use offset for ethtool regs data
  ionic: add missing filter locking
  ionic: fix up filter debug msgs
  ionic: update filter id after replay
  ionic: keep rss hash after fw update
  ionic: use mutex to protect queue operations

 .../ethernet/pensando/ionic/ionic_ethtool.c   |  7 ++-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 50 +++++++++----------
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  8 +--
 .../ethernet/pensando/ionic/ionic_rx_filter.c | 29 +++++++++++
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  6 ---
 5 files changed, 60 insertions(+), 40 deletions(-)

-- 
2.17.1

