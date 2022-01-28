Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD8E49F78E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 11:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243887AbiA1Kty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 05:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiA1Ktx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 05:49:53 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20904C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 02:49:53 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id b14so8501854ljb.0
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 02:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=8CT7EpSslyddpBtHXKqY5+EfQKG+CUNYfwr1IFTv+KI=;
        b=WBPu8Ymv+kKhnFaHJ3SdRJoBLa/Nqa+K2v/0N6Rc+vd59fQ21HWqhGfLyIc35cCbm7
         7hYAZk43pYNTNyjEye+5HOBQbfZj/fgMggVYYOhiynq1Ijl7+IyljF0FB1AWMBLIronh
         7WW5t2StQ3Bq+0/SqRhO8I/B9k+hnUZTCec2UpFDm4Ny6aN2QZYDGG96mSCKzpP2EFTj
         MBOU2HLs+Jzpdvw7m5UAXnpOb1h+BImkgbIFEAOnxiS/RGrU8jDxPHt+hzF7hruKoU5D
         hv56QNQApedlS4rMmTjnt73paUQfM3H5MhxBVxQss8DcvjFt5Jgr8QzHqQAXf9aIDjUi
         1UgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=8CT7EpSslyddpBtHXKqY5+EfQKG+CUNYfwr1IFTv+KI=;
        b=j1KiGpprWNW79iCzT6kGBGHAaMoucLGtTeOtIhIQrS1VEwbYkFdUeYQv5atlNC5Ttt
         DMLN6QFl3Gz1Fjlw03WjO9jGs1xOQ6ukJN4jw2iKhk+OCebMHr14qqhUFfoXTMlI5QDB
         0XbgYWmNeovcwlXWK31MQ83kFoWVqixCxcRw4xvFuZ5VcscaAj/mYSaltPtk67jc6/3I
         kh4fvLWrWSgV5RVIjh3XibLVG14AsVLprRABtEhsoN9gtDPi3E84YyQJVsFiDNZQT8if
         AtnAlbjm1CiEkUYvD9f02QEgXoETEFD0i3fhVUc3PUOzZnhTqUUyDe/ltUIugu3k/GIx
         qyNA==
X-Gm-Message-State: AOAM531z8URPP91SY4PlPyzYQF2CXPOMPO1DWZp8wDxmYOzd4GsDJYnc
        HkvADKVM68JBGGuZfGdw2yFtoaMbBiXjUA==
X-Google-Smtp-Source: ABdhPJxmtsm9UdXseUsMJ4G0DuHgmNPMntf/UNv3eAKKmLusLuqin6oIjZZub7HcrsrUTPg6Gld/dg==
X-Received: by 2002:a2e:2a85:: with SMTP id q127mr5425607ljq.508.1643366991395;
        Fri, 28 Jan 2022 02:49:51 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v29sm1931347ljv.72.2022.01.28.02.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 02:49:50 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect addressing performance
Date:   Fri, 28 Jan 2022 11:49:36 +0100
Message-Id: <20220128104938.2211441-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The individual patches have all the details. This work was triggered
by recent work on a platform that took 16s (sic) to load the mv88e6xxx
module.

The first patch gets rid of most of that time by replacing a very long
delay with a tighter poll loop to wait for the busy bit to clear.

The second patch shaves off some more time by avoiding redundant
busy-bit-checks, saving 1 out of 4 MDIO operations for every register
read/write in the optimal case.

v1 -> v2:
- Make sure that we always poll the busy bit at least twice, in the
  unlikely event that the first one is quick to query the hardware,
  but is then scheduled out for a long time before the timeout is
  checked.

Tobias Waldekranz (2):
  net: dsa: mv88e6xxx: Improve performance of busy bit polling
  net: dsa: mv88e6xxx: Improve indirect addressing performance

 drivers/net/dsa/mv88e6xxx/chip.c | 10 +++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/smi.c  | 32 ++++++++++++++++++++------------
 3 files changed, 28 insertions(+), 15 deletions(-)

-- 
2.25.1

