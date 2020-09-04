Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86525CEAF
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 02:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgIDAFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 20:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgIDAFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 20:05:43 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDB7C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 17:05:43 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bh1so280500plb.12
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 17:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qmoUrb8VaWe79NNTfqTvjEmsBhkSyAamCT+WeRcO06M=;
        b=uHaBu8BnmjEu/nfZxrr/BtClkkuf52yPGlkAV7Aqg0Gu3AqtbRBxtGSfquGsMWPHJY
         vkp60+WQ6F/ncUlGd+aCtngCsXnvwGpE7mXf5Hfr9SDKoAW+1K7pVpd7SxUpUKZ2rN0h
         5F/AKwUgH5sK7i8nZBFg2QnOoABMqsnHnBeMNHUrbo6XlvJ4V56nRnqzYG8HsAXDsZbr
         uvzxTG8Hi+rOiGDmubq3kRE666cCt4yH4lYkUzryJh/weEfVfI8V1OipS8q8rS91loZP
         Hc0z7o6WfGUhz5btVOzr4ZnrHTsAjPY4sQ40N4aSw4cC6kQpCAHQ3/NYytV9IgN2/2M2
         IBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qmoUrb8VaWe79NNTfqTvjEmsBhkSyAamCT+WeRcO06M=;
        b=MUTLRJBd3Xg+twE790621xLrtSitaIa1z9V12Tn0tlULNvbOnYcvGqv3SGfY2/rcr0
         i/9Bi2w/ypPsbUI1V8AOuTds35Q9/Ix4rmmsz8hSHpEY/fwEYqIKm33HbKk/SWTRbKYx
         lgzsuVYii8YjyQsf4AT6ko0gS+RuUMWC4C/wdIsF6DH8pMf/LiH2+AjZyxlELKRVZ2fd
         Z59kISKB5fLHEaEFy/Bu+UOevSi2G1AWkoVPWe6qOYjfXCoPq0G6aT6joUyz+7lSkf3V
         EMl50X8JfOAiPBtQzO4y7IJgckv7n+mB5mO9ME9O7l0/HP9uAb1QRr16tvz0QJXudL1r
         GonQ==
X-Gm-Message-State: AOAM533EnUtmqzbk1fmxcXKEbNvGjuxehoOVOdc65vECg96KfxjDV0H1
        IZHi7JQzZ8sDJQDx6CQDqkF0AASH9hQb7w==
X-Google-Smtp-Source: ABdhPJwy0eritq2KZe6I0eMuRlxFAD+69t7r+AJySylso8dHLFd4OUC8+F3mcLPJR5haNRaMva9n5A==
X-Received: by 2002:a17:90b:3004:: with SMTP id hg4mr5396893pjb.7.1599177942413;
        Thu, 03 Sep 2020 17:05:42 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w5sm3924602pgk.20.2020.09.03.17.05.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Sep 2020 17:05:41 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 0/2] ionic: add devlink dev flash support
Date:   Thu,  3 Sep 2020 17:05:32 -0700
Message-Id: <20200904000534.58052-1-snelson@pensando.io>
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
we want to be able to list the FW that is installed and selectable but
don't yet have the API to fully support that.

v2: change "Activate" to "Select" in status messages

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

