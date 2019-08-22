Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2C49A0E4
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbfHVUNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:13:49 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43937 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731739AbfHVUNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:13:48 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so6280726qkd.10
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iB2Yd7lQIrKuQTp4f8AUyWpSoQRqMaKYORXTFFDehNQ=;
        b=GWVLjVwKUXJgo7+FfU9nZzhLFQORg49Px/RKCj0lDgE7J6+LGEWr7sbDcCOrTTHLBv
         t91iaEX3x/X2UHUcNtxle6i75xcn8IQ2+5O7VkaktTWbrKVPEJ6jRtodhh3uzdP7HCZM
         Sk0AQBkuTM6siSQKBmLAFewX46pDGoQ/OifHSrlEQNWM3KxHWwj/RXkopPvBkFob+jOe
         uDala8wSpquM5vfi7lST93KzA3OkUo0vWdm3919S0rKxdhDlkMRSIEc0tSfCbDlURb3q
         NBiY9oC92PMLiBuJqSJwng/zJmoiGHnvQOE0QTqtw6s/oJGpFrhSeSE86HLBRtEWlIIP
         /vLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iB2Yd7lQIrKuQTp4f8AUyWpSoQRqMaKYORXTFFDehNQ=;
        b=DLZQivhqssNvkwE39LvPjjf1TLrFZrGDCiR9owgJI9/MRFA8qofrzHhRUKkR8DiyZG
         1GsgcLFtGPFoxGyhXAAK8ZhMXbeREqGa7sYBRoJ5wW8aeRbmreqGZZDk8Zx17FCdk017
         nmwDfcNsJBmdneeMn7d/q2RitHDREyFQLhbUY9peoYJAZserr6wzBUAb8mAeK+a/NNmp
         LMd/Z+suXDlEm1iHI6ltxlL6Ln9AywpnuxkHzf0Wf2jVuTTdIJK/i7ckyQPWAormSm+U
         XiQU9ZZxqSF4mnIOu4Vh/UN8dNxns4caMfkvUrT8EF10xtV9+1W4ZKC8bcDisPUIP+7X
         KsqQ==
X-Gm-Message-State: APjAAAXgfLYuzpBkkPycex4OZlUZVX8MNNn5zKekAPWIBxsE6KG7qjYG
        IYiiTAITmqyJz6z7rJWlv2An6+YW
X-Google-Smtp-Source: APXvYqzuMk6KTf1tYN/3UmRH8MC3OfZ9e35NRyhJx2TvP4D0QxTHMs2ZBeoEXajx6TnQxBQFb8sbsA==
X-Received: by 2002:a37:8c04:: with SMTP id o4mr797242qkd.163.1566504827477;
        Thu, 22 Aug 2019 13:13:47 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 65sm352924qkk.132.2019.08.22.13.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:13:46 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/6] net: dsa: explicit programmation of VLAN on CPU ports
Date:   Thu, 22 Aug 2019 16:13:17 -0400
Message-Id: <20190822201323.1292-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a VLAN is programmed on a user port, every switch of the fabric also
program the CPU ports and the DSA links as part of the VLAN. To do that,
DSA makes use of bitmaps to prepare all members of a VLAN.

While this is expected for DSA links which are used as conduit between
interconnected switches, only the dedicated CPU port of the slave must be
programmed, not all CPU ports of the fabric. This may also cause problems in
other corners of DSA such as the tag_8021q.c driver, which needs to program
its ports manually, CPU port included.

We need the dsa_port_vlan_{add,del} functions and its dsa_port_vid_{add,del}
variants to simply trigger the VLAN programmation without any logic in them,
but they may currently skip the operation based on the bridge device state.

This patchset gets rid of the bitmap operations, and moves the bridge device
check as well as the explicit programmation of CPU ports where they belong,
in the slave code.

While at it, clear the VLAN flags before programming a CPU port, as it
doesn't make sense to forward the PVID flag for example for such ports.

Vivien Didelot (6):
  net: dsa: remove bitmap operations
  net: dsa: do not skip -EOPNOTSUPP in dsa_port_vid_add
  net: dsa: add slave VLAN helpers
  net: dsa: check bridge VLAN in slave operations
  net: dsa: program VLAN on CPU port from slave
  net: dsa: clear VLAN flags for CPU port

 include/net/dsa.h |   3 --
 net/dsa/dsa2.c    |  14 -----
 net/dsa/port.c    |  14 ++---
 net/dsa/slave.c   |  79 +++++++++++++++++++++++----
 net/dsa/switch.c  | 135 +++++++++++++++++++++-------------------------
 5 files changed, 136 insertions(+), 109 deletions(-)

-- 
2.23.0

