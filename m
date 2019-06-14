Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA3346627
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfFNRta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:49:30 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33916 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfFNRta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:49:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id t8so2237193qkt.1;
        Fri, 14 Jun 2019 10:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NzPhRKABWxj3qAdaqQ8+kdoT461BCHthHBtxzDllSyw=;
        b=T5POkD/h2pXir3L0ErwMWCzpm2VPm4i24qiVjCrW10mSltOJqQOSirOZuvUDC14kDU
         IRBi/OhXILMUKgHsY1r/g9hySOK93rPYyL3V6tSWM1/VIqfMpYftkJOFccGEHpJdqi6A
         mrLPx2ath0XM66T3Xx6/kxJLrE9lbyj9v9dCKSVvDUWPk1OR4oDpMosBdAH60kv0zXB4
         NtCG8lzFgblT60d78g5hVOO8Xb1exv+CciZtMSNdmK3eQzOR11DqOg/e3lFSz7DuOOQN
         B9j/ZOFxzaHKxA8tZXhVZHtOSHJFACbAidaKjsW8pmM9+P6j6wViJLRx7U2OlN6wRKc+
         0wrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NzPhRKABWxj3qAdaqQ8+kdoT461BCHthHBtxzDllSyw=;
        b=sO4du8jZHScqAac38TO+esWY4PGWTTTCVcureyRZiIXxSF2hEBr5OICnPSYfPxObY5
         fmophZh4fdLeDsAti6n5OxB/t8AG9xifZN4BQ+3GFL2oQNJu/d5+CRlWTn6jfgr8q8Kj
         Mw10SohJ2LdMJ/1aPt1NeaYbW5bLts+yoxpmqG00x7jwdt0/JB+cx5CBrZkb5ZVpgUkM
         3cYCGu8ofbL7H3phNCxXKGAj+dSxkfmjdsR1fQHlDkOPwFZw38/YnyiwQKrvnbkLrTCq
         PuyCMRIeuw88yGyTv676dcJ5mos4FrkLJVP2jQ3wgai5kpLVpxJhIhpGJFIV+zWLhOa4
         S/WQ==
X-Gm-Message-State: APjAAAXkfVb4OIb5+/x/1H0fySWuSwul8XeU+FNHEiXcN/6F95wOEWnz
        HWb7a8KiImXkGVuIy9NJutecSalAe8U=
X-Google-Smtp-Source: APXvYqx+qElbXC/YtEqdsVjItU3xYJ7YGze+h1/1lwnsx3wcwqoAvkXmZk5UEAfCDGFg91rSb6Dxjg==
X-Received: by 2002:a37:de06:: with SMTP id h6mr58835672qkj.322.1560534569186;
        Fri, 14 Jun 2019 10:49:29 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z8sm1551620qki.23.2019.06.14.10.49.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 10:49:28 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: [PATCH net-next v2 0/4] net: dsa: use switchdev attr and obj handlers
Date:   Fri, 14 Jun 2019 13:49:18 -0400
Message-Id: <20190614174922.2590-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series reduces boilerplate in the handling of switchdev attribute and
object operations by using the switchdev_handle_* helpers, which check the
targeted devices and recurse into their lower devices.

This also brings back the ability to inspect operations targeting the bridge
device itself (where .orig_dev and .dev were originally the bridge device),
even though that is of no use yet and skipped by this series.

Changes in v2: Only VLAN and (non-host) MDB objects not directly targeting
the slave device are unsupported at the moment, so only skip these cases.

Vivien Didelot (4):
  net: dsa: do not check orig_dev in vlan del
  net: dsa: make cpu_dp non const
  net: dsa: make dsa_slave_dev_check use const
  net: dsa: use switchdev handle helpers

 include/net/dsa.h |  2 +-
 net/dsa/port.c    |  9 ------
 net/dsa/slave.c   | 80 ++++++++++++++++++++---------------------------
 3 files changed, 35 insertions(+), 56 deletions(-)

-- 
2.21.0

