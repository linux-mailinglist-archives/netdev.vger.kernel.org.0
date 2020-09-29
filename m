Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4791027DB8F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgI2WUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbgI2WUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 18:20:06 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252B8C061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:20:05 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so5078880pgl.9
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=I4VQdR5SXfKBHDimfwLz1ayBcunxC11U7fYBCunNRDc=;
        b=zATEeYNBU/b57K7GoXlxl4uqf8zR5aOrB3cpCAlbC0abe57ZIlP8YkWdeGpW2Ep2Cm
         ZZOx03BX+dJUwU0YeVxKB4065PGDty0VevRn/+ISIbU4ZZBK7FfSyZPgrbR2xKEJlGij
         42NGqEySS+xjsnfr+NOXcwrnJUba1KUUHcWGUVoYiH+uSdiRP3+6Yp2I63qATsjwpCAO
         vRx5M02BkmxhfEY+5CttV4REDqg0MQkfZLSuCrbuTssZml960d7EKCREU3U/ZAXR0nGg
         JXJsTwFq10j1k8qu7Wj9O4RJT/ALfKBu49LE+LOia/hspA62YISwt3QbLcZ+PDaVgDsO
         BBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I4VQdR5SXfKBHDimfwLz1ayBcunxC11U7fYBCunNRDc=;
        b=KqiOoYWTY0GLZ9nwPUTenHY3Q2a9NV5LT2WsvEGlaLj1pSOBme88+rRdk4yvfeQBcu
         hJ7v4jROax/P0EjMX0eGXxX5zgdj/wJGSsKTSzyq9RhjQhQY17QqV5ZfPO83WHOcii2w
         n8sJFcrIVH6VhSCObZmI1ahjZAKnwc5ajVBQyjAbi3VbJpbwQvrTM18Qn+WlAtJBxY0P
         7PIjmLoa3fvx07ppsTBgTiX4x1cHPyyeyLp6Q89fb0AynRqIXxdHgCOxwnH/I/ANXk8A
         OBQII335AIusLbwtRcul3lHMR8T2hDdeQH0Rzcww4sATlrmf80g5HO0IGZlfOoZBXYdY
         vEtQ==
X-Gm-Message-State: AOAM5332szLMTtRF+4WStCwdFw9x11P2NFVWQ5GyY3HGjzZw2X8FD5zX
        uFtRu/Cox4pnM82aWU8fgNRqMJUMEwXWqw==
X-Google-Smtp-Source: ABdhPJwJbNvreJECFWE9pU5YDxmhoblC06n+kBEYCzjmiWx7nyuWthBvVu156QE/A1qu0tqaaeXzRg==
X-Received: by 2002:a63:1a50:: with SMTP id a16mr4775999pgm.331.1601418004359;
        Tue, 29 Sep 2020 15:20:04 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id e27sm6756428pfj.62.2020.09.29.15.20.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 15:20:03 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 0/2] ionic watchdog training
Date:   Tue, 29 Sep 2020 15:19:54 -0700
Message-Id: <20200929221956.3521-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our link watchdog displayed a couple of unfriendly behaviors in some recent
stress testing.  These patches change the startup and stop timing in order
to be sure that expected structures are ready to be used by the watchdog.

Shannon Nelson (2):
  ionic: stop watchdog timer earlier on remove
  ionic: prevent early watchdog check

 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c |  5 +++--
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 10 ++++------
 drivers/net/ethernet/pensando/ionic/ionic_dev.h     |  1 -
 3 files changed, 7 insertions(+), 9 deletions(-)

-- 
2.17.1

