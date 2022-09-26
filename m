Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA115EA634
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 14:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239457AbiIZMcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 08:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239523AbiIZMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 08:32:13 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4218BD74D9
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:10:54 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id nb11so13279535ejc.5
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=f1KMgPO9SFkLi1gTlZBals2n7Bm2I4UFo3jj4D/h4yo=;
        b=uMCtKtHwNTQjnDJdyiyHiWr4LKWgNsnDvzS+X6x+VXJamMUFXj2xkeR9jEVK2OaqXA
         Rm6A5YMw8M0KzKKYv8iY6c8usewdj/ipVeTbINVW7IwJB2zVcjD+0UnVAVFX/G59MNqI
         Uk5e9k0MJ+V/PqxYI+43xNOosREVENe3hXehyH3PYvJK5R4Uqx2exftpYfcRPOY381jv
         u5F9GiX+ZeVEL3OLTHBFUuSkugLcutz6dlqH+XATQtANl9Gii7QVXNs94C7ySpncags1
         OuIdxv5p9lrRwc2ynikIZPaJQ952gF6116l7LB+cZNgnpDvvyuN7BxuWPA3QPm1Qmhkx
         iwUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=f1KMgPO9SFkLi1gTlZBals2n7Bm2I4UFo3jj4D/h4yo=;
        b=F5RNktlWobwMVX2y5fgl4xuzNam+ehFoWG2H1O1UuqBslsbqktj9qX0K3xWOQKRKkh
         sWTjISk6ntEf1YTrwzkBqbpagWZ3Y7whxhM/2SEyZzrZhnNqFqcjc2mILxGqPnhvLh6h
         XqYAY99+2HtUuW+959eocnn5DEBZLty2mt92864lLEWb+DoEz2MUjVVcBNptPw3AF3GW
         KPnvGQK9lLkPnGdQumMWvpqORpsVHVnGO6FFk4I6pmOx0jerFHGu3OfWuQaBFCfCDC0T
         hvWVoMMnSdmPvKGcjuX5/Lu/LDw+fk50aluCc+Y8vvUu4YcSgP48njoxuiC2/IOhts0S
         5mnw==
X-Gm-Message-State: ACrzQf1REv7xUN/SErXkAgoH7nxO+XajFFiVzMB7P/Fl1WCYkXB/fyr3
        nD38pQQXo4W4psnTaznO7hymbXg1eGA4DBrqYzI=
X-Google-Smtp-Source: AMsMyM5FnWSM92Ts7/yFT4GlVVxjpKO065obiTjTZ6qLPzcd7nZlRhboSAvsAeIlqc9TyxYjxK5ucA==
X-Received: by 2002:a17:907:6e14:b0:782:4659:14c1 with SMTP id sd20-20020a1709076e1400b00782465914c1mr17258523ejc.196.1664190580040;
        Mon, 26 Sep 2022 04:09:40 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 25-20020a170906311900b007838e332d78sm1425683ejx.128.2022.09.26.04.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 04:09:39 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        snelson@pensando.io, drivers@pensando.io, f.fainelli@gmail.com,
        yangyingliang@huawei.com
Subject: [patch net-next 0/3] devlink: fix order of port and netdev register in drivers
Date:   Mon, 26 Sep 2022 13:09:35 +0200
Message-Id: <20220926110938.2800005-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Some of the drivers use wrong order in registering devlink port and
netdev, registering netdev first. That was not intended as the devlink
port is some sort of parent for the netdev. Fix the ordering.

Note that the follow-up patchset is going to make this ordering
mandatory.

Jiri Pirko (3):
  funeth: unregister devlink port after netdevice unregister
  ice: reorder PF/representor devlink port register/unregister flows
  ionic: change order of devlink port register and netdev register

 .../net/ethernet/fungible/funeth/funeth_main.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c         |  6 +++---
 drivers/net/ethernet/intel/ice/ice_main.c        | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_repr.c        |  2 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c  | 16 ++++++++--------
 5 files changed, 19 insertions(+), 19 deletions(-)

-- 
2.37.1

