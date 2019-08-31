Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB52A461A
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfHaUS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:18:56 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]:42275 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfHaUS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:18:56 -0400
Received: by mail-qk1-f176.google.com with SMTP id f13so9169377qkm.9
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sj0D+eFn0rU86Ldnw9O27QT2ilcPXxYK+5EkTvk6Ao0=;
        b=E1hPRZYn/INBiEKvKDs+DV7//GTuJAffdaK8hxyrwK21EK0/cPHmXpQZ976PeUNyNF
         EaaNTbjFjc1YwktLYR+0NboUNbtLJnCJVK6rew+GyIwlwQz2eB0Mr//2dL2asbZ1IShx
         DhRy8i0Z+beEavXMS1A3Up49m1fEYSrQ3WiLlzvL/wlb+kdjPXIKGr2JtzQTeRdDcegI
         hliFMqiYskezh6iEtJuepQiom3zPJY61+5JYryMTNo+YrPGRYajgRTMm/3+U1xUNjiC5
         fRlkouCWL63c1s7F5VOfVTslu0V5n69KMlDLUpnsB0jw8kBTERnvWQkxUKi9WmLcuUi0
         BMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sj0D+eFn0rU86Ldnw9O27QT2ilcPXxYK+5EkTvk6Ao0=;
        b=LqB/lc4WOdgkuoYSZh3YUKU1fgzb7w4cYzaSXCjrONzx6gEBeWN8zqNyPFDm6Ytjli
         wERdG58y6rre6Ufl/z7eONovg/Nv8BiuzAwQ93kUUXIn+Ol7BwMFn6t7lXpV3+1gEDJq
         /fQIfDMMjOhYVgMZcpH6g7pdbfGwSPAp5/26wlY0T588gz7eBgwT986oz6eRL1H4Ke3W
         03VNkq7Gf/LV/lLVPM5w91wTjzN0b48QgOu7hvbBM0IQytVfJC4HxgyOR0BKj0jvfLHm
         mYejYmiRliFGveocDKIm4O+CKgGWlMvfVIPiPH2zHg+moOvdEY5U90DHkAAEvrawVAJq
         7HNw==
X-Gm-Message-State: APjAAAW/27Rsip889F3OcaOp48d4jChycRCTOUY00Hau/YLRhFC9hX6d
        ncwjCdO93Vf83hPbEzHkN4NFjHs1
X-Google-Smtp-Source: APXvYqw1YW16KPBD4fSX4YADragnHG6JFPkgaYZKKG1ItU8yXUyhKpkzoiQTB4Nv+oxyN4uj5EICgg==
X-Received: by 2002:a37:4d90:: with SMTP id a138mr21642093qkb.128.1567282735040;
        Sat, 31 Aug 2019 13:18:55 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id c64sm2370385qkb.21.2019.08.31.13.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:18:54 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 00/10] net: dsa: mv88e6xxx: centralize SERDES IRQ handling
Date:   Sat, 31 Aug 2019 16:18:26 -0400
Message-Id: <20190831201836.19957-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following Marek's work on the abstraction of the SERDES lanes mapping, this
series trades the .serdes_irq_setup and .serdes_irq_free callbacks for new
.serdes_irq_mapping, .serdes_irq_enable and .serdes_irq_status operations.

This has the benefit to limit the various SERDES implementations to simple
register accesses only; centralize the IRQ handling and mutex locking logic;
as well as reducing boilerplate in the driver.

Vivien Didelot (10):
  net: dsa: mv88e6xxx: check errors in mv88e6352_serdes_irq_link
  net: dsa: mv88e6xxx: fix SERDES IRQ mapping
  net: dsa: mv88e6xxx: introduce .serdes_irq_mapping
  net: dsa: mv88e6xxx: simplify .serdes_get_lane
  net: dsa: mv88e6xxx: implement mv88e6352_serdes_get_lane
  net: dsa: mv88e6xxx: merge mv88e6352_serdes_power_set
  net: dsa: mv88e6xxx: pass lane to .serdes_power
  net: dsa: mv88e6xxx: introduce .serdes_irq_enable
  net: dsa: mv88e6xxx: introduce .serdes_irq_status
  net: dsa: mv88e6xxx: centralize SERDES IRQ handling

 drivers/net/dsa/mv88e6xxx/chip.c   | 141 ++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h   |  15 +-
 drivers/net/dsa/mv88e6xxx/port.c   |  21 +-
 drivers/net/dsa/mv88e6xxx/serdes.c | 382 ++++++++---------------------
 drivers/net/dsa/mv88e6xxx/serdes.h | 107 ++++++--
 5 files changed, 315 insertions(+), 351 deletions(-)

-- 
2.23.0

