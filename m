Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D2E2753F4
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 11:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIWJGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 05:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIWJGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 05:06:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC25C0613CE;
        Wed, 23 Sep 2020 02:06:09 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bb1so781178plb.2;
        Wed, 23 Sep 2020 02:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wmyY5XpgcNpj2CzR3rp96YCOt1z4gBJ/8Zy+qlXjkUo=;
        b=rPYT1OansxEM1lD9H7pOWAhXSVBopghvDdtGsmfmfU36gTCwwAwK8KmFGWqUIy2mC+
         CEL6zjZ4FfebYe+WFovSsYiUhxdj9GtpH8pf/bQ7kpysLFcX1n0O87gL37sLkBU6qvjk
         HT1dQJX1LSwg/MZOGu4J4XU8l4tNP6/cTGsdOjgRCieTYWO+f6/BKf4VLffe6RWDPaFU
         vb/yAB6/lBSfN7+1KELo1XuLw+c03GjWHu0ueW1bb2UlZlnRBbN5Kcq2SQrl43v0hiNI
         JinvjkrPmnh8bBIYVjWiYTmPXjVVu6KrIxaJhzBU+VMgbuNK6UjjFCcLyEkkAwV5qvq2
         bpsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wmyY5XpgcNpj2CzR3rp96YCOt1z4gBJ/8Zy+qlXjkUo=;
        b=VPkExiYKlD7IxlAEpPeqBXVabfVx09JkfiyfjKHg+x5ZT8QRxMyBrjwGw0fSYbXRco
         j8zAnnjLo2PRFeM2rewSRz/bptHvs4T8Ekn+/BekQ5J02bcsGLqBMfqQHLB04bHEuvOM
         VYTn5O9uuM4tYfevFTMF76uGQ+1MysyVMbCpWAgq+uRTJ9Cf0JAgwAOfHuF1TzJXeZSK
         cFdSE0jMOutIXBTOeUVCAbm6ebiZmdmNUSTqiWvZrWsguz5/HbpoAzftzOQs5irQOOAt
         tbq+ZR9rmkPuwdFo7rbIE6iR6K1bWeyUPAXAg2hpsPdXOdYBcDMLvv5LzgIsv7tybO5h
         CBfQ==
X-Gm-Message-State: AOAM531XuLIr7NMQWWWh8In5OsG9lEzMOSfsftlMhHoXWkNiBhco7r4O
        QpWnQZOMRqwPaygXks4vEKQ=
X-Google-Smtp-Source: ABdhPJzd4xTYSZZ2phKNaD2FrJKt2AqeoD5MuNiHRdhxUAkHsNGQkCtu4z32V9SndvXr6zfsM3rGJA==
X-Received: by 2002:a17:90a:ad48:: with SMTP id w8mr7309913pjv.179.1600851969127;
        Wed, 23 Sep 2020 02:06:09 -0700 (PDT)
Received: from localhost.localdomain ([2405:205:c8e3:4b96:985a:95b9:e0cd:1d5e])
        by smtp.gmail.com with ESMTPSA id a13sm16496226pgq.41.2020.09.23.02.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 02:06:08 -0700 (PDT)
From:   Himadri Pandya <himadrispandya@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        yuehaibing@huawei.com, petkan@nucleusys.com, ogiannou@gmail.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org,
        Himadri Pandya <himadrispandya@gmail.com>
Subject: [PATCH 0/4] net: usb: avoid using usb_control_msg() directly
Date:   Wed, 23 Sep 2020 14:35:15 +0530
Message-Id: <20200923090519.361-1-himadrispandya@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent bug-fix shaded light on possible incorrect use of
usb_control_msg() without proper error check. This resulted in
introducing new usb core api wrapper functions usb_control_msg_send()
and usb_control_msg_recv() by Greg KH. This patch series continue the
clean-up using the new functions.

Himadri Pandya (4):
  net: usbnet: use usb_control_msg_recv() and usb_control_msg_send()
  net: sierra_net: use usb_control_msg_recv()
  net: usb: rtl8150: use usb_control_msg_recv() and
    usb_control_msg_send()
  net: rndis_host: use usb_control_msg_recv() and usb_control_msg_send()

 drivers/net/usb/rndis_host.c | 44 +++++++++++++---------------------
 drivers/net/usb/rtl8150.c    | 32 +++++--------------------
 drivers/net/usb/sierra_net.c | 17 ++++++-------
 drivers/net/usb/usbnet.c     | 46 ++++--------------------------------
 4 files changed, 34 insertions(+), 105 deletions(-)

-- 
2.17.1

