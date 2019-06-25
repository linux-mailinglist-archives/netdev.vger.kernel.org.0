Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B9A55C69
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfFYXkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34354 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfFYXkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so538956wrl.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eSNgacyu+5pJFnObskryRG2mxNolRQg6dAjpCVAw3Eo=;
        b=BC2ajN+oj49it7CxbdUv8bZtYvtjbuCO7kqeGkKpAZagRpE+bgR0qHvSfxMAP13zfe
         5AWSAfK7uwA7Dn5I8EtW/KwxAisB62cJWKOLolUNh0R/QhSGXV9B7WrykKrOijRTj6fb
         mjnRmyiQ+sNO22xysK1NMXxtTphiK44M2l1C83rO56RsoGCvJije7QKdFak5wD5ArdBC
         EXenJXeeVcjKIR+OBsCc/dl3qiPft3pRiv7j8FPMGClaK17aGCJy9ohOI1tfMOPw78tL
         Ub68R4P/IwmO1RcnDGtsjbKousflLoYsl7Wyx6ot/pQpwTMBkjrJfrINEF7Mb1Np+dhz
         HAaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eSNgacyu+5pJFnObskryRG2mxNolRQg6dAjpCVAw3Eo=;
        b=JbCj5tCBwHs2ldstCGZyHIvXYkchnfpijRRfR/gWa8OB90EhmUqHI/liOCpdT3zjHn
         EIN2VCfj1NwlNwrEVS5erCDhuOI8sWDQCamgPRGXw/suhfoBFnv6B6t5c2Aoq2ECAWo1
         +xEx53f3o5qOZBGZlCriB6BMa9bgquX2GQ1YJGNAB9mojawBbfjS/IUEy6rdLmvwh0yS
         RESyuo2usMY9E0wNRAy18vEFB9lxlhRWvtajS5iwfYTgEznjZt5BjJTF/JoRRh9ML76F
         Px+ZgStSPAb8y2n2bNYCES9ta3BhTuD/D1eDgzRDTdVcju5sE2cscz2a5fTeiqCnQC2T
         7cPw==
X-Gm-Message-State: APjAAAVAsBxY5mBObgMEWIVoMsz4tIs3FlciAwMC0iqkCz7VNsjtn8uV
        +yHF/Smxs2fdwoPw9sSA+dk=
X-Google-Smtp-Source: APXvYqyHyMheNuCsd0vvJduUMJtUaT4cZPa2tFA1uZ7+qJ+5QF3MNKzed5vSUgR+RKyfWbiOX/+3/A==
X-Received: by 2002:adf:d081:: with SMTP id y1mr550279wrh.34.1561506003784;
        Tue, 25 Jun 2019 16:40:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 00/10] FDB, VLAN and PTP fixes for SJA1105 DSA
Date:   Wed, 26 Jun 2019 02:39:32 +0300
Message-Id: <20190625233942.1946-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is an assortment of fixes for the net-next version of the
sja1105 DSA driver:
- Avoid a kernel panic when the driver fails to probe or unregisters
- Finish Arnd Bermann's idea of compiling PTP support as part of the
  main DSA driver and not separately
- Better handling of initial port-based VLAN as well as VLANs for
  dsa_8021q FDB entries
- Fix address learning for the SJA1105 P/Q/R/S family
- Make static FDB entries persistent across switch resets
- Fix reporting of statically-added FDB entries in 'bridge fdb show'

Vladimir Oltean (10):
  net: dsa: sja1105: Build PTP support in main DSA driver
  net: dsa: sja1105: Cancel PTP delayed work on unregister
  net: dsa: sja1105: Make vid 1 the default pvid
  net: dsa: sja1105: Actually implement the P/Q/R/S FDB bits
  net: dsa: sja1105: Make P/Q/R/S learn MAC addresses
  net: dsa: sja1105: Back up static FDB entries in kernel memory
  net: dsa: sja1105: Add a high-level overview of the dynamic config
    interface
  net: dsa: sja1105: Populate is_static for FDB entries on P/Q/R/S
  net: dsa: sja1105: Use correct dsa_8021q VIDs for FDB commands
  net: dsa: sja1105: Implement is_static for FDB entries on E/T

 drivers/net/dsa/sja1105/Makefile              |   2 +-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 154 +++++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c        | 227 ++++++++++++++----
 drivers/net/dsa/sja1105/sja1105_ptp.c         |  13 +-
 drivers/net/dsa/sja1105/sja1105_spi.c         |   2 -
 .../net/dsa/sja1105/sja1105_static_config.c   |  12 +-
 .../net/dsa/sja1105/sja1105_static_config.h   |   3 +-
 7 files changed, 343 insertions(+), 70 deletions(-)

-- 
2.17.1

