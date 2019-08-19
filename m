Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDA794EA0
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfHSUBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:01:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43323 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbfHSUBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:01:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id b11so3306815qtp.10
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WhVcUku1a0jqZfU4wQ51rz9H+TtOwbLau62VpG4wjRA=;
        b=fKZvNbOLVmcuTV7pefic2A5nTcqC1C9zKDvqOSm5lG6gNJKimDiCiV+54/7uI4RSMx
         NcmIAJTIGmDkjQ4a8jDKOtzAb6Z9o2cz3o4NflaeRXJRTqgcGJ3p5Kk2MawUWWiWY1yT
         GfE84vEF5c093Mq1DJeOHz8ZQ5Qv3mVHjfm8K48Ybc14fkiYsKnzgmyW0yy1VF5Eekef
         ERw8HnbeRSxhTdycFp6kVqNjuEdBnv03ojYmYuBt8ca4VZbuhsRnlJBJ+06eaYAsZIrV
         q7AgMXOXo9jUM3UmyN/c9F7hjxh/XDJMCAmo+IPABcayAIXQbeQsq2T4l/Wz1ihNW0G7
         BeTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WhVcUku1a0jqZfU4wQ51rz9H+TtOwbLau62VpG4wjRA=;
        b=Ev1NMecP5vP8qTLcleTASXyY3MARV9NrF9VVcstCtBDkfO5ilsrQLNcHROEKmn92Tz
         Q+jWgfs/jwZ0GtdkdQF+tdbjMUZLVLlbZb//Z3i2/buSiOc0LuDEYK956CIeeDISNGDD
         WuwCeGg1/Dk1bWZr85mSTCF0aIhEsK/0AoLO2NTuS3TrJ/5f0nPkcIikGTGBpqjkIvxh
         wEU0xzqGYbmyNXoCZoyLQXd5AFvtA0pM4eHdT+ZbuqDc+dLuoxNwklJ6z+VaMki8ZGi/
         gYO5yKm7nWti+l5F3JJcqTm2Or3QkAJpu5/3NVu2sI/8AwLfpm1v7Af2j/KqqNzocWSL
         qucw==
X-Gm-Message-State: APjAAAUxh8PBQTFylhFneUonTuG4mbRx/BGx7NggGcdC32p3WG2X/VbL
        SaFpkEJq2s4irZdPqGRou8QEAyK3x5o=
X-Google-Smtp-Source: APXvYqwdaud7LMrzm3e+/ul1ITUjjtM/BOzwaPy1c+3fur58GJsG9HBT7gqJ5Q6S+O4qpAMHzIApIw==
X-Received: by 2002:a0c:edcb:: with SMTP id i11mr11974347qvr.206.1566244866697;
        Mon, 19 Aug 2019 13:01:06 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o18sm8336191qtb.53.2019.08.19.13.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:01:05 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next v2 0/6] net: dsa: enable and disable all ports
Date:   Mon, 19 Aug 2019 16:00:47 -0400
Message-Id: <20190819200053.21637-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA stack currently calls the .port_enable and .port_disable switch
callbacks for slave ports only. However, it is useful to call them for all
port types. For example this allows some drivers to delay the optimization
of power consumption after the switch is setup. This can also help reducing
the setup code of drivers a bit.

The first DSA core patches enable and disable all ports of a switch, regardless
their type. The last mv88e6xxx patches remove redundant code from the driver
setup and the said callbacks, now that they handle SERDES power for all ports.

Changes in v2: do not guard .port_disable for broadcom switches.

Vivien Didelot (6):
  net: dsa: use a single switch statement for port setup
  net: dsa: do not enable or disable non user ports
  net: dsa: enable and disable all ports
  net: dsa: mv88e6xxx: do not change STP state on port disabling
  net: dsa: mv88e6xxx: enable SERDES after setup
  net: dsa: mv88e6xxx: wrap SERDES IRQ in power function

 drivers/net/dsa/b53/b53_common.c       |  7 +-
 drivers/net/dsa/bcm_sf2.c              |  3 +
 drivers/net/dsa/lan9303-core.c         |  6 ++
 drivers/net/dsa/lantiq_gswip.c         |  6 ++
 drivers/net/dsa/microchip/ksz_common.c |  6 ++
 drivers/net/dsa/mt7530.c               |  6 ++
 drivers/net/dsa/mv88e6xxx/chip.c       | 64 ++++++-----------
 net/dsa/dsa2.c                         | 98 +++++++++++++-------------
 8 files changed, 106 insertions(+), 90 deletions(-)

-- 
2.22.0

