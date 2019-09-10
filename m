Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C894BAE1F0
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 03:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392375AbfIJBfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 21:35:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46907 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732574AbfIJBfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 21:35:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id d17so3972051wrq.13
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 18:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L5Cwv17g4KSeqrNFKDHEoFiNmmx9M0rq17M79gVDXzo=;
        b=LSnkIwaE7ucKgLzum5rzaXFdexG2aANUYVryjHrAoxH9sZp9LQEWD+Jjg9s1kGqHMm
         xvK65UcsgylFyroIprd6mm13Nhk7wDksd6i/aCRJfGr5eh5FAJoygH4aXhI+ew6QjZ3c
         uaSw+B0dCNbabQ3bw6Ii2xKpPCCvI3i4tCvjUlnJ6miw/JoDkIntRYKvcGcs3FGVQRNP
         iUMrV6LMsZxF4/QKe91mYvvmJ127/rTmFk6MF91kch+VteP05ZoyWAbYiixCPALWWAK7
         qJOwNwjFScvOelipC2Zi7ql0GniyotCj0eIDUfeHOxUNQa8C0RkRj6Cx5uBK6vV6ykBj
         soZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L5Cwv17g4KSeqrNFKDHEoFiNmmx9M0rq17M79gVDXzo=;
        b=hKstNHnKayUxFGXZSuJLKUOE+jP53zINqg7tspsmY4Crl1WXSMBDQLzWXcnhOTmvsd
         BiXqns42I+0/1VIAj/ieGYnDKGtn5FjMi9D5pr7QkhoiS99jMl/QigktFae6xbeZBgIz
         so2n+V3cSL9jiAi3KIviPs2LP/eziw8HpJgALTNwYZZPfLxZReYbJINjyCfrAt6kp+ic
         SIkbKuEnoNcj419k5LIzF1KgC4LdQkwiRCN8QG5t8+EG8z03gz0avkhJzoUeMPi6B8cl
         VB1DDgnoiL4ADei7bqIB5nK4yzvc3opD0boCX5B+Cvk0O6PhdCpSGrZ4hmAfzj+bZZHn
         alog==
X-Gm-Message-State: APjAAAVJAht8+rJUY/7M+f88RV7Ee0tiNX99QV6DB0hR4SDqQRvYsG5R
        L+6rxfOvEFu0cH+cjYz87Nk=
X-Google-Smtp-Source: APXvYqw66INrt19iYGDq7FQbAjEP3JTF/aWZC6k4O6bOW/yP29qVpIdn9zz31j2b5hJfMVOap99j3g==
X-Received: by 2002:adf:e9c5:: with SMTP id l5mr416649wrn.40.1568079338236;
        Mon, 09 Sep 2019 18:35:38 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id b1sm1254597wmj.4.2019.09.09.18.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 18:35:37 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 0/7] Hardware operations for the SJA1105 DSA PTP clock
Date:   Tue, 10 Sep 2019 04:34:54 +0300
Message-Id: <20190910013501.3262-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series performs the following changes to the PTP portion of the
driver:
- Deletes the timecounter/cyclecounter implementation of a free-running
  PHC and replaces it with actual hardware corrections of the PTP
  timestamping clock.
- Deletes the approximation of timecounter_init() with the argument of
  ktime_to_ns(ktime_get_real()) (aka system clock) that is currently
  done in sja1105_ptp_reset. Now that the PTP clock can keep the wall
  time in hardware, it makes sense to do so (and thus arises the need
  to restore the PTP time after resetting the switch).
- Profits from the fact that timecounter/cyclecounter code has been
  removed from sja1105_main.c, and goes a step further by doing some
  more cleanup and making the PTP Kconfig more self-contained. The
  cleanup also covers preparing the driver for the gettimex API
  (PTP_SYS_OFFSET_EXTENDED ioctl) - an API which at the moment does
  not have the best implementation available in the kernel for this
  switch, but for which the addition of a better API is trivial after
  the cleanup.

 drivers/net/dsa/sja1105/sja1105.h      |  18 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  66 ++++--
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 283 +++++++++++++------------
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  78 +++++++
 drivers/net/dsa/sja1105/sja1105_spi.c  |  42 ++--
 5 files changed, 310 insertions(+), 177 deletions(-)

-- 

These are the PTP patches that have been split apart from:
https://www.spinics.net/lists/netdev/msg597214.html
("tc-taprio offload for SJA1105 DSA").
As such I have marked them as v2. There are no changes since the
tc-taprio patchset, it is only for better review-ability.

Vladimir Oltean (7):
  net: dsa: sja1105: Get rid of global declaration of struct
    ptp_clock_info
  net: dsa: sja1105: Change the PTP command access pattern
  net: dsa: sja1105: Switch to hardware operations for PTP
  net: dsa: sja1105: Implement the .gettimex64 system call for PTP
  net: dsa: sja1105: Restore PTP time after switch reset
  net: dsa: sja1105: Disallow management xmit during switch reset
  net: dsa: sja1105: Move PTP data to its own private structure

2.17.1

