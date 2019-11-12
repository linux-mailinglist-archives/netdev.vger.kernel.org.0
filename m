Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505DBF84EF
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfKLAMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:12:03 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43009 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKLAMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:12:03 -0500
Received: by mail-wr1-f65.google.com with SMTP id n1so16524061wra.10
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 16:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JZWMxEHW/yzdHe4DSALvUVy0vMkS/Yc3n2zssBxhCNY=;
        b=s1waOwdJpK3jw2UWbdj2OwnhBDBifdEriQMg2crrLAXxb3VRQ/0g9ndUPx1+uPaEKj
         9JJS0fgCGp94IiYc62pN07TMcPwy9uciaenkkp4xyQVobL+Vlsx7NCC9ecUrl19pTvc6
         QRHCiaXzK/8mWeAxW1NJgmGi+gmcc5rBMUznuhvbmEUyn5P9LL/+wCbKqpCDQXkpLb3z
         gliQSfKEHUcd7I1aXQGbSpntddHBfpEt1KC9d9XXIuMm7Kzr5I2ivyiiYZs0IJls/q2f
         y3wiKav8/hAMCNAVFDLrjpMjHlybwIcmIe8YJhXK6pZryjTDDQpJJ43y7RCdB4frZPFP
         fL+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JZWMxEHW/yzdHe4DSALvUVy0vMkS/Yc3n2zssBxhCNY=;
        b=VAqETME8uGXIHGOzvrwJz5S/wHqCRgilSq/B5cSwoMFKUsTz2HxUTBGjtAy9HqsLh8
         3xJxhyCODYeo29HI7LZ8ScPaQbWHwnrWdgH+1xct8szXh7YUojs+7rvFg8tTiPhI5pH8
         AtftZzjd5DEbofbnpzOaXi+lzr6j8/bUPwB8lYUBVdGqzxr65phvTiG3Z7jxRCevWt1f
         0A9TxJ12d9GsSy0KSyrfiqKtPZYQ1abpjOSrjhbPjBjzIIzIjFeLYhko4Y3auSuiR1MZ
         lpj2cTLvuNVBoj0NWBYZKSbfFEh2xZ1a2xMBs981manHZeb4aDwLfGXKT0ah2kQmhVoq
         wBmQ==
X-Gm-Message-State: APjAAAV+k2IoSt6wcWgBgiOuXJeeRNfb8XNBqNS5GoBUVrxvaXTteTQ8
        g/uJOekm0Oe9RsOG3kN7xmz8F6pep6s=
X-Google-Smtp-Source: APXvYqyXVW5LN8GDqUr4rOew3do2r5BJXi1355zx2pWrTBVkQfwTRqjvudIFGVxK2PiLHWmwuc2JhQ==
X-Received: by 2002:adf:f192:: with SMTP id h18mr13458894wro.148.1573517520091;
        Mon, 11 Nov 2019 16:12:00 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id m25sm808687wmi.46.2019.11.11.16.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 16:11:59 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     vinicius.gomes@intel.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] PTP clock source for SJA1105 tc-taprio offload
Date:   Tue, 12 Nov 2019 02:11:52 +0200
Message-Id: <20191112001154.26650-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes the IEEE 802.1Qbv egress scheduler of the sja1105
switch use a time reference that is synchronized to the network. This
enables quite a few real Time Sensitive Networking use cases, since in
this mode the switch can offer its clients a TDMA sort of access to the
network, and guaranteed latency for frames that are properly scheduled
based on the common PTP time.

The driver needs to do a 2-part activity:
- Program the gate control list into the static config and upload it
  over SPI to the switch (already supported)
- Write the activation time of the scheduler (base-time) into the
  PTPSCHTM register, and set the PTPSTRTSCH bit.
- Monitor the activation of the scheduler at the planned time and its
  health.

Ok, 3 parts.

The time-aware scheduler cannot be programmed to activate at a time in
the past, and there is some logic to avoid that.

PTPCLKCORP is one of those "black magic" registers that just need to be
written to the length of the cycle. There is a 40-line long comment in
the second patch which explains why.

Vladimir Oltean (2):
  net: dsa: sja1105: Make the PTP command read-write
  net: dsa: sja1105: Implement state machine for TAS with PTP clock
    source

 drivers/net/dsa/sja1105/Kconfig       |   1 +
 drivers/net/dsa/sja1105/sja1105.h     |  16 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c |  77 +++--
 drivers/net/dsa/sja1105/sja1105_ptp.h |  24 +-
 drivers/net/dsa/sja1105/sja1105_spi.c |  16 +-
 drivers/net/dsa/sja1105/sja1105_tas.c | 428 +++++++++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_tas.h |  27 ++
 7 files changed, 534 insertions(+), 55 deletions(-)

-- 
2.17.1

