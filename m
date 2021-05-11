Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4FC37AE1E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhEKSNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 14:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhEKSNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 14:13:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FB6C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 11:12:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b21so11259113plz.0
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 11:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jAxgtyhNk9VuN8km6ue65YwsCdyxZJZYkMtfUJZ0EJo=;
        b=yPcsV74oq9FuQAJvKjRXm4MmmNzGExeRKgqUEBK3tip4ZsUzfIP3zyKHzcC5OQvMTw
         HXBbUThM52K5XxZEAgG4/TPIdup8y3kysf0yKEkHuyHvlEZdFzsX1yAA1PdXo3Xz/VGZ
         jZZmyTAHZh7ThtQn+61ibinxZ3JIWZxOb/TwaeGY0NwQ/g7vKyqwHAzyBeOtvulGahdv
         94MouwKEqi1vbSeRBXtMy1IqxBu2QqqPP8bx9HjhWX2miIP/1+/9XrOXBCl71mROaMHm
         /pRnsfOnh5CanDIh8wmmWZTM4OF+dgsetmE2y1igmABi36Olw1BtzJwsOranyuoymCxx
         joPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jAxgtyhNk9VuN8km6ue65YwsCdyxZJZYkMtfUJZ0EJo=;
        b=ubjntQVAE8gFtm+wmGnw1NaRltlMe3M8nkbIGVtdgB72Zu4sNLa9KpBU6DWZ83KRNb
         lS4peb3UuR/f+4WkUx+4faisE9d2KzU7pX5WJc+WEZ6MWzVLOFHrnvhAYiswJOcVYCnh
         bl5iNU1EDAURCEi2TYvDiR2Mdae2kXcbCYDj+czKSF2bj/N+KIbuDjycqdEnY3JMJK/2
         aHt00rTGPVrdHu9+qKmWxGajnMGkLuH6dvupxoYCkhPjn4e4O3aYcC+2GX+XiwZZgTmh
         sVRaGDJMjlIPZ1NxkStSQ6PTjKoguI08u6K1bnn6qgfFrrJn7wVoqltup7DjYI8wu8gw
         G+7w==
X-Gm-Message-State: AOAM531He3otRArYzrgKEMQHRmY49lmKQYX3j1vbX9NAlNYnzA6MOApW
        yBilIGxojplhKu/RermkMRfpGEia+zKILw==
X-Google-Smtp-Source: ABdhPJxWreOR3DWz4joUsIVbE84zK/O7d14E/P8JefkueA1nb4hIBiFn+61spbmTVqjEgb6OOoSW3g==
X-Received: by 2002:a17:90a:5d14:: with SMTP id s20mr34218262pji.185.1620756729690;
        Tue, 11 May 2021 11:12:09 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id z13sm14413798pgc.60.2021.05.11.11.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 11:12:08 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Randy Dunlap <rdunlap@infradead.org>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH v4 net] ionic: fix ptp support config breakage
Date:   Tue, 11 May 2021 11:11:32 -0700
Message-Id: <20210511181132.25851-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IONIC=y and PTP_1588_CLOCK=m were set in the .config file
the driver link failed with undefined references.

We add the dependancy
	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
to clear this up.

If PTP_1588_CLOCK=m, the depends limits IONIC to =m (or disabled).
If PTP_1588_CLOCK is disabled, IONIC can be any of y/m/n.

Fixes: 61db421da31b ("ionic: link in the new hw timestamp code")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---

v4 - Jakub's rewrite
v3 - put version notes below ---, added Allen's Cc
v2 - added Fixes tag
---
 drivers/net/ethernet/pensando/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/Kconfig b/drivers/net/ethernet/pensando/Kconfig
index 5f8b0bb3af6e..202973a82712 100644
--- a/drivers/net/ethernet/pensando/Kconfig
+++ b/drivers/net/ethernet/pensando/Kconfig
@@ -20,6 +20,7 @@ if NET_VENDOR_PENSANDO
 config IONIC
 	tristate "Pensando Ethernet IONIC Support"
 	depends on 64BIT && PCI
+	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
 	select NET_DEVLINK
 	select DIMLIB
 	help
-- 
2.17.1

