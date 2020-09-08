Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1A0262339
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 00:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729457AbgIHWsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 18:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgIHWsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 18:48:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE0AC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 15:48:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id l126so406897pfd.5
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 15:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=+9UdHv0ByCncP42muzNz32ZqaP9nxbSId6IdAWcfnQ8=;
        b=Z8LvyJblxEbxS3o33xOt/pU6Jwi8/vZZncKrQzjByPFf/8g0IoGa4bCJhzqH8O++d6
         56daxbJPJz1399En2gmhDZvbOsTwA2ybkBF0clyyXf11fyJocXFORPxuZABGEcf954PJ
         62449d5PZOHQAjPPbhqrL4ScKeTqYWnogZRwIUXOoA3z6JDxpncfc+ex2eMvvAgogmk6
         Gjpq/QBq/dZoJ4ngBmAldqC1DrlP/0jnFToM8kEzk+BTJDEtpiReBDQ4p/MPoJLttqZC
         2Egu4jvnJspF7gv1w2zEJKT6nawxY305vrLqzB5JEcO5mCIk8yyyZySdi+FrrHU+aQNM
         wl4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+9UdHv0ByCncP42muzNz32ZqaP9nxbSId6IdAWcfnQ8=;
        b=i5PQF9G8KKu47bD5n5f9RSh3LJwkU7FrdMAybbcNWMl2WbRWCezqPFd8Icv2LckDsY
         Yk9jut16whAaRTG1R1NDQS88NGuZGGLVH4eOvACTfIOh7GgTzgai88Pahi2aj71cP7rs
         alJqhvU+FRXOb4MPv4bsD1vPY1vksUaItvkqnbCiOb3ZQe0E8engqSk/Jx3YJYk1tOOy
         9hejW6ksALctAnxb2EzjksGcwYWRkZztHjUvmmn2oAHIQW2b+sHhfS7QDDx+MSibf1vh
         F02XOJEBMHalyoG8YX0lRalKcIqE9FYmyVpw+mLrSEJNdy0ZXWxi39sFdEMYAt0o6aXM
         zBHQ==
X-Gm-Message-State: AOAM532JW+Z8zVcjczSCUcI9bWyCg5m8ZMn1edihFqNHSEN95EjNcHDL
        1o2OIYtkFHMc7BzgiMSRJhNalui79pApmw==
X-Google-Smtp-Source: ABdhPJzYmg48fKB3rlBa7IKmHlH/pL2xNI6UVges7T/JyVT+N4KqyLM0+lpvoyvQ6tKFu8b9zOCYDw==
X-Received: by 2002:a63:1a46:: with SMTP id a6mr748272pgm.110.1599605299792;
        Tue, 08 Sep 2020 15:48:19 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id v6sm435515pfi.38.2020.09.08.15.48.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 15:48:18 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 0/2] ionic: add devlink dev flash support
Date:   Tue,  8 Sep 2020 15:48:10 -0700
Message-Id: <20200908224812.63434-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using devlink's dev flash facility to update the
firmware on an ionic device.  This is a simple model of pushing the
firmware file to the NIC, asking the NIC to unpack and install the file
into the device, and then selecting it for the next boot.  If any of
these steps fail, the whole transaction is failed.

We don't currently support doing these steps individually.  In the future
we want to be able to list the FW that is installed and selectable but we
don't yet have the API to fully support that.

v3: Changed long dev_cmd timeout on status check calls to a loop around
    calls with a normal timeout, which allows for more intermediate log
    messaging when in a long wait, and for letting other threads run
    dev_cmds if waiting.

v2: Changed "Activate" to "Select" in status messages.

Shannon Nelson (2):
  ionic: update the fw update api
  ionic: add devlink firmware update

 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |  14 ++
 .../ethernet/pensando/ionic/ionic_devlink.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_fw.c    | 209 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_if.h    |  33 ++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  27 ++-
 6 files changed, 271 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_fw.c

-- 
2.17.1

