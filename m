Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1C92F5EBC
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 12:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfKILc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 06:32:59 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39065 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbfKILc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 06:32:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so8754934wmi.4
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 03:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8De6Rj8Z3/FvZ/IH+300vRGzCtyFKenlxsoUFlOTBKg=;
        b=tfdQYT5RnrGUEhjHpTZP7MEuf2ySxT+Vi/dTLCRnTEe4D48Umx7LMlw2Z7CXDGbrpD
         kkv1Git4wE8uyzy5lMv0tIBdh53aZ5t+WqfACRJCOn/KvWwct6zNh7xJSNLDvtskVtie
         s54DC3dna1HFE/j2+ypz5UsUsG4rPC+6R3jn+D3/dygI+xSifHsDr0ROajWvsEo/L9p0
         ms/5UUZKQcvFcd/+DFkQLDodA4p6YaJXHY5JjzCrHRbJbKPE5LMDvDxf1zq33/pduMa6
         aEeZENOK5WDqrIVlv6gZ2rjQxeFpUA473i4ELL0V4ssy+LO+ND3RzSQYtAxAwMphTERt
         gGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8De6Rj8Z3/FvZ/IH+300vRGzCtyFKenlxsoUFlOTBKg=;
        b=Uv+/8xBOJhiydJJG3NKzSSofnWiQkoIX129RpYio49D6hSNfq8ZQ4brg8LS7EJPU1Q
         GXocw/RZLRQT5AfSR3K96RQyIhpG25K0vzRKL1WMZC2pqA2m0Q1pPPmhbN9qS1px3bvP
         NngOjBiiEcgLB/kx+ytQusz46ygq04puQg0OD81HmLXlXFKgD0Rdo6R96jlq+HLCwjWh
         D0+Zsn6pc32XnezezgMmetOz9XPdbu5W2sZHfQSwdRglJNR2RcP+Nf+O373biPPtkdu7
         7sE+1An3sjAshG0MmqRFvKkgMG/6UDWLYGIBkJ9OcATrRrhxv5qi214Nd5jQr9SQSPzQ
         qIXA==
X-Gm-Message-State: APjAAAWRWHrn2SkoeSUE4iiTPNWywa0FiDEQxJBozIR+vC8kULElswVZ
        jRqnXMVxk8PSe7alvH4XIcI=
X-Google-Smtp-Source: APXvYqxy8ZxKWDeAVT2mamMy3GoisnqcsR4R8+WKqVNRSL+3hvQeVh21zh6yHzDF1l8bSW6C8H/QmA==
X-Received: by 2002:a1c:2342:: with SMTP id j63mr11856997wmj.56.1573299176971;
        Sat, 09 Nov 2019 03:32:56 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w13sm8353512wrm.8.2019.11.09.03.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 03:32:56 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/3] Unlock new potential in SJA1105 with PTP system timestamping
Date:   Sat,  9 Nov 2019 13:32:21 +0200
Message-Id: <20191109113224.6495-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SJA1105 being an automotive switch means it is designed to live in a
set-and-forget environment, far from the configure-at-runtime nature of
Linux. Frequently resetting the switch to change its static config means
it loses track of its PTP time, which is not good.

This patch series implements PTP system timestamping for this switch
(using the API introduced for SPI here:
https://www.mail-archive.com/netdev@vger.kernel.org/msg316725.html),
adding the following benefits to the driver:
- When under control of a user space PTP servo loop (ptp4l, phc2sys),
  the loss of sync during a switch reset is much more manageable, and
  the switch still remains in the s2 (locked servo) state.
- When synchronizing the switch using the software technique (based on
  reading clock A and writing the value to clock B, as opposed to
  relying on hardware timestamping), e.g. by using phc2sys, the sync
  accuracy is vastly improved due to the fact that the actual switch PTP
  time can now be more precisely correlated with something of better
  precision (CLOCK_REALTIME). The issue is that SPI transfers are
  inherently bad for measuring time with low jitter, but the newly
  introduced API aims to alleviate that issue somewhat.

This series is also a requirement for a future patch set that adds full
time-aware scheduling offload support for the switch.

Vladimir Oltean (3):
  net: dsa: sja1105: Implement the .gettimex64 system call for PTP
  net: dsa: sja1105: Restore PTP time after switch reset
  net: dsa: sja1105: Disallow management xmit during switch reset

 drivers/net/dsa/sja1105/sja1105.h      |   6 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  42 +++++++++-
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 103 ++++++++++++++++++-------
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  24 +++++-
 drivers/net/dsa/sja1105/sja1105_spi.c  |  54 +++++++++----
 5 files changed, 177 insertions(+), 52 deletions(-)

-- 
2.17.1

