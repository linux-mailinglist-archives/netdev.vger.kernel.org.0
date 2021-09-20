Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4190B412AC5
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 03:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238647AbhIUB6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 21:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhIUBuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:50:01 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE818C06AB01;
        Mon, 20 Sep 2021 14:54:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w11so2448267plz.13;
        Mon, 20 Sep 2021 14:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N13BqckQH7bbiU9DGK/tP2bm1aq47bRFIOq1IepoQy4=;
        b=aO8g3FxQPDqwl6P7L0jNCV8SSST7wg2U6wBn7/qS62DIAWN2cJeJPHSpPlDGRBl1Ug
         F0uZ9DoayEKKem+IlekAiwUBioCbI0NND4BuIEyjEDZ4vGdSoSiifyk+R27IaqvnHdET
         PSoNxLKBU5P+MqKFNYQyhc89J6ST25RH3R2oBZ87dvD71foaWvSF3znJqjBLHUpR5G2l
         c2KadRJ4fnFBNv+k5q9bphgka84RPMMxrbuO9gnwXIN/vTL8l9Qcr6x/WT3Oe0+qE+Ht
         zwCLWkkvssvgtAJYIn5u7O9S8sS8J1nOz0TUTNoxPDHzzxDefuvM7WZ1BjtMUGDI98H/
         4/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N13BqckQH7bbiU9DGK/tP2bm1aq47bRFIOq1IepoQy4=;
        b=llNc/zAERUioOJFNoiKbp/AxvVRFKqUZpqjNomdu3fGesEgfRcDWCzbLvs5jT8eet1
         eKJi0Rkbl86Swns/eKO/q52VmjFgkXwaRzRk7oj3ZvQy55jSLQv61GiQzpU9cnxJQ5St
         DMe4WjKe96fSwcCJ0YIcTUBCzIOZL8O8ja05TWFjuhJh05jhWh4TwTHqyBPwkxQB3LAm
         gVLjghJM9jCbSQqZzrm6xNVT9YXTcAQWrF42xf7LDyYmP29xCQE8mk3h7amvSKz/t3w3
         tJgxNB/vszQeAsoxyezWALLXW4QHJ/QPOO6Rqw94azVYTZYCIEnLH4obToEb/0ZonXv0
         HQkw==
X-Gm-Message-State: AOAM530hMhCEq2GU+ABUk5z2zotag9Dr2ZVK/SdL6Ze2lbiGLRUrnvPt
        tInA5E7vuNdue7lWWhbBwaP7wjAqq5Q=
X-Google-Smtp-Source: ABdhPJyD6Ja7PNLHpb9Jg4KhCUR45UCy/9CROIq5VQ5fjIfyRCKw+caoTAGYPYpINrPVGbgUwv9YXA==
X-Received: by 2002:a17:903:124d:b0:13a:36d5:44f3 with SMTP id u13-20020a170903124d00b0013a36d544f3mr24655170plh.28.1632174864917;
        Mon, 20 Sep 2021 14:54:24 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m28sm16224297pgl.9.2021.09.20.14.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 14:54:24 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/5] net: phy: broadcom: IDDQ-SR mode
Date:   Mon, 20 Sep 2021 14:54:13 -0700
Message-Id: <20210920215418.3247054-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for the IDDQ with soft recovery mode
which allows power savings of roughly 150mW compared to a simple
BMCR.PDOWN power off (called standby power down in Broadcom datasheets).

In order to leverage these modes we add a new PHY driver flags for
drivers to opt-in for that behavior, the PHY driver is modified to do
the appropriate programming and the PHYs on which this was tested get
updated to have an appropriate suspend/resume set of functions.

Florian Fainelli (5):
  net: phy: broadcom: Add IDDQ-SR mode
  net: phy: broadcom: Wire suspend/resume for BCM50610 and BCM50610M
  net: phy: broadcom: Utilize appropriate suspend for BCM54810/11
  net: bcmgenet: Request APD, DLL disable and IDDQ-SR
  net: dsa: bcm_sf2: Request APD, DLL disable and IDDQ-SR

 drivers/net/dsa/bcm_sf2.c                    |  4 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c |  4 +-
 drivers/net/phy/broadcom.c                   | 59 +++++++++++++++++++-
 include/linux/brcmphy.h                      |  8 +++
 4 files changed, 71 insertions(+), 4 deletions(-)

-- 
2.25.1

