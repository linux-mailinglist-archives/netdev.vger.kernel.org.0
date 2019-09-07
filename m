Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5EFAC91F
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406149AbfIGUBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:01:18 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43885 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391561AbfIGUBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:01:17 -0400
Received: by mail-qk1-f194.google.com with SMTP id h126so1350396qke.10
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gAAZeSKgh6D2+AcbLcDLTJjuBji93p4KUhOrOKnr944=;
        b=jtYv6bi0L5gaVprDrrJS4NRr3h6/oFGhJvnR9V1nAq8JtSNpzyeWhedUhTcyvzjwFy
         H6OUlKWclMGzeNBB28EtlbJADL5iR/qfzU4gyrMVekM0CMN4tdNhCurswy0hSukhueoy
         K7fIdknGb0GMukKd5BGp0WEwN2IqOqHKlbISmByp1ahYyclxNF1xwNVQht5GoVn76ZZP
         PNVuGGmXBlfEli1usnDsdyKNlPxKqlxOqozBkTA9RQ8p80K+hcE4cCEXUc0ZmIGxXyLc
         Xr3ndDFHPS81qPEpCJyZVjKqQ9FQ9jimJzKEmUkcN+X8BjwbV7WlPKFm+dRluKecircj
         nSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gAAZeSKgh6D2+AcbLcDLTJjuBji93p4KUhOrOKnr944=;
        b=hV99KuQ4fiikes0UyumNzbNaj5CmZN5eEPOOABp283t/VODZJCb5I2jrDVjxH5NvsB
         Ct9c6A6HpYH82/QQlVUDk0K3T/AXhGGRLjv1tOJ7v5wQpWaAA0W3BeeW4uX7w56Be+sH
         82KotExNKQG5Ig6ziftcrQ187ojVhbEquwL3PgZiLQ/TSDkYz1FSrg18XgNUBKi41dgN
         bPcB6e+SMxYIh+o91TmVOoeayLFVXOmZBp2YOKHOHZ/n9op1U2GOStQy2YQFcHYpqzF8
         6XZMOaYfnzN9fUuHlsiJgvNHO33YOfhXZKVWxfyiXAN3OGYFR/3sBdn2EYC4g2chMD+M
         HfGQ==
X-Gm-Message-State: APjAAAXH7dt58AeN4YnCwPawj769ZVsC2jARgcQpZYmj9UbUsj4qGM0r
        c13DaeYeAPr20CJXvJjABg+OlkEA
X-Google-Smtp-Source: APXvYqzYOEoQeNWBluq2CiKt94o8o/DAnMxdFsNhgPd9nNwVqxMvvoUpUSKSwrPRgJPIDw4nmIpJzw==
X-Received: by 2002:ae9:ef53:: with SMTP id d80mr15916668qkg.288.1567886476447;
        Sat, 07 Sep 2019 13:01:16 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id i23sm3897898qkl.107.2019.09.07.13.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:01:15 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/3] net: dsa: mv88e6xxx: add PCL support
Date:   Sat,  7 Sep 2019 16:00:46 -0400
Message-Id: <20190907200049.25273-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series implements the ethtool RXNFC operations in the
mv88e6xxx DSA driver to configure a port's Layer 2 Policy Control List
(PCL) supported by models such as 88E6352 and 88E6390 and equivalent.

This allows to configure a port to discard frames based on a configured
destination or source MAC address and an optional VLAN, with e.g.:

    # ethtool --config-nfc lan1 flow-type ether src 00:11:22:33:44:55 action -1

Vivien Didelot (3):
  net: dsa: mv88e6xxx: complete ATU state definitions
  net: dsa: mv88e6xxx: introduce .port_set_policy
  net: dsa: mv88e6xxx: add RXNFC support

 drivers/net/dsa/mv88e6xxx/chip.c        | 241 ++++++++++++++++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h        |  35 ++++
 drivers/net/dsa/mv88e6xxx/global1.h     |  43 +++--
 drivers/net/dsa/mv88e6xxx/global1_atu.c |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c        |  74 ++++++++
 drivers/net/dsa/mv88e6xxx/port.h        |  17 +-
 6 files changed, 388 insertions(+), 28 deletions(-)

-- 
2.23.0

