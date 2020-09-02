Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE9A25B4DD
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIBT5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgIBT50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:57:26 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CEBC061245
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 12:57:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l191so210924pgd.5
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 12:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=KpD8/6dickOGrR5lIddxOcxpXgvb8vlzMqLb8oD12Jo=;
        b=Qd9GfM8XM6ZQOIwklAglz/VuhcoF5s9wm5JCXDnQA9FNXap9B0ipKmMkobvEJyHVxe
         xNvrkiqlERN1yy8dRqHeJ1bzwTRLHuuHVzzao87birycUS6heCumeDmaX0ONsl01d4Xp
         JQltyR633NsPW/QYsvOVRBn5tPwFtPoKIviXTwPDhQ7rBGYtGaw+itbxeqjI06Aqszot
         BB3GCbjPKkBVi6tE+MH5dFP06PPE5OLIySK41teWoKi5gpNY+zx737uxlLkBGebC/xmK
         upMwp2kxzNRapE5UUrw3XaaDLR6qg8BBGZmPXN09/Mfm/afJ2Lx8a2j5yh9NlqZiWXbA
         XOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KpD8/6dickOGrR5lIddxOcxpXgvb8vlzMqLb8oD12Jo=;
        b=cxqGub8SQ0H8xMUoJEPMgTHzDwWespmhfM6VFPUeMzH9DfYez0umP9qj+CZECx3mXc
         VFWfpLIanOdtPonDM8ghfh3mMWEm/Y0bK8UNccutgm8SfcIFcfW0BjKdXVvkebPZlVgr
         gmogXEfnHh8juiMdXnrZVzPJ/5i1KscEr2ViBlB6/4FXgVePAci9JjZWG2bT4rq+KNDZ
         QGyJMdLquKDer0ZU0Sg9uE2imLBPLVFBf7Xb81B0Acd71TNoEKFNqVyd+e+GFOWXU8Fy
         WPK4rEpXVIUj42l2zRxuIvdU7Hicgoftkhh2nUoDXaMq4BJULzOvQonDUEjYVo82tN+r
         QYGQ==
X-Gm-Message-State: AOAM532yCe9Z35u3BMtPXsLLmn5xK2ZmRIuMGAMkqOB1bCf5n+A5NmlI
        gZ0IHvUymWLj04ng1SqeaNTC1yKBayNhYA==
X-Google-Smtp-Source: ABdhPJzNenV8pAEQQVum9/jpoSX6wzoWPOcaYydD8d2Yk64bo0uUPfwiTHaTa4bkzVrL/ejk5GDhLw==
X-Received: by 2002:a62:cdcb:: with SMTP id o194mr121104pfg.32.1599076645278;
        Wed, 02 Sep 2020 12:57:25 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a5sm355527pfb.26.2020.09.02.12.57.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Sep 2020 12:57:24 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/2] ionic: add devlink dev flash support
Date:   Wed,  2 Sep 2020 12:57:15 -0700
Message-Id: <20200902195717.56830-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for using devlink's dev flash facility to update the
firmware on an ionic device.  This is a simple model of pushing the
firmware file to the NIC, asking the NIC to unpack and install the file
into the device, and then activating it for the next boot.  If any of
these steps fail, the whole transaction is failed.

We don't currently support doing these steps individually.  In the future
we want to be able to list the FW that is installed and selectable but
don't yet have the API to fully support that.

Shannon Nelson (2):
  ionic: update the fw update api
  ionic: add devlink firmware update

 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../ethernet/pensando/ionic/ionic_devlink.c   |  14 ++
 .../ethernet/pensando/ionic/ionic_devlink.h   |   3 +
 .../net/ethernet/pensando/ionic/ionic_fw.c    | 195 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_if.h    |  33 ++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  17 +-
 6 files changed, 251 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_fw.c

-- 
2.17.1

