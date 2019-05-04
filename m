Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D480136E9
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 03:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfEDBSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 21:18:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40656 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfEDBSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 21:18:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so9907543wre.7;
        Fri, 03 May 2019 18:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1zQYpHCU7UlsHYJBg7jwPlzoSjQyIJpUN9QDyya+MQ4=;
        b=iNyGD2djAV4yvcaEiFk74Q3jMsefHRPo2VLdHt6+MDRkoGpn2/BdwSM85jK0O+lh4w
         FtoB0Pwc9HSyTKTj/PJo+u6qGIosa+3AGS1dIIfPGvUwXqqBsCLYXM244i5/mzazaTbZ
         romkbGP14FJPlQNLK+MMJ4i5iwO+KE0K7T59l1k5NlcVYPp9aNn6kBbgFnwLAuw0ixKV
         1ZJIdiA/YhxssYzwoiv6ezEuvkiOpWUZwkHerdNl9AyaKVx0E4+Al6hzKtCo5l1RwZFX
         hxRaWR5bcZRcXwk7xIGKibIBDjcbVkwQP+EFsTyVyMiCN3K+b9MKJlNkdjWPtAQvHxXH
         EJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1zQYpHCU7UlsHYJBg7jwPlzoSjQyIJpUN9QDyya+MQ4=;
        b=ftNhThYlCHcVFPoRxlqLjXcTWCo+G7x8K63nmEL726MpXohQI1G7H9stIB8uxttiOk
         97TLZupVMeKYCRLMVgyuzon+RuEIak/cEebBu0ZoT/v8CV+MofwoRLAt57ea8qdWVnIK
         shUIV3NT418Yl+2kkeejvHNkXuWuZHfArK/NNKixFEdk+xYzZmEQ2/y7A8tSs3Vn+/at
         4+Q4vT8+Q+2sksGqPUpvnmFyIbTTlvRvhoRMLo8zbAP2xulErjiltC1f/O2HJE9rwwq7
         rZFEROsCG5IUmV7H2cAS0Mcd7o7NatQAhBuJNl5Z8p5CZkJllGsgTOeu04WCqmUtAo4V
         NViw==
X-Gm-Message-State: APjAAAU7KvaRv0xythf+3DmLeUfDwvpDjhXKmdSb+znEK+TMpQ0fsTCt
        UIyY9wbUjvAdrzxRZ8QRtCs=
X-Google-Smtp-Source: APXvYqw6wc3ZIfNewUS90lwCR4NOKjdRSzhVflAo5NyRDdVdP/14J8wfKH0BjyoXDNrlziVicETL/g==
X-Received: by 2002:adf:dbce:: with SMTP id e14mr9061327wrj.249.1556932718724;
        Fri, 03 May 2019 18:18:38 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id t1sm3937639wro.34.2019.05.03.18.18.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 18:18:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/9] Traffic support for SJA1105 DSA driver
Date:   Sat,  4 May 2019 04:18:17 +0300
Message-Id: <20190504011826.30477-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is a continuation of the "NXP SJA1105 DSA driver" v3
series, which was split in multiple pieces for easier review.

Supporting a fully-featured (traffic-capable) driver for this switch
requires some rework in DSA and also leaves behind a more generic
infrastructure for other dumb switches that rely on 802.1Q pseudo-switch
tagging for port separation. Among the DSA changes required are:

* Generic xmit and rcv functions for pushing/popping 802.1Q tags on
  skb's. These are modeled as a tagging protocol of its own but which
  must be customized by drivers to fit their own hardware possibilities.

* Permitting the .setup callback to invoke switchdev operations that
  will loop back into the driver through the switchdev notifier chain.

The SJA1105 driver then proceeds to extend this 8021q switch tagging
protocol while adding its own (tag_sja1105). This is done because
the driver actually implements a "dual tagger":

* For normal traffic it uses 802.1Q tags

* For management (multicast DMAC) frames the switch has native support
  for recognizing and annotating these with source port and switch id
  information.

Because this is a "dual tagger", decoding of management frames should
still function when regular traffic can't (under a bridge with VLAN
filtering).
There was intervention in the DSA receive hotpath, where a new
filtering function called from eth_type_trans() is needed. This is
useful in the general sense for switches that might actually have some
limited means of source port decoding, such as only for management
traffic, but not for everything.
In order for the 802.1Q tagging protocol (which cannot be enabled under
all conditions, unlike the management traffic decoding) to not be an
all-or-nothing choice, the filtering function matches everything that
can be decoded, and everything else is left to pass to the master
netdevice.

Lastly, DSA core support was added for drivers to request skb deferral.
SJA1105 needs this for SPI intervention during transmission of link-local
traffic. This is not done from within the tagger.

Some patches were carried over unchanged from the previous patchset
(01/09). Others were slightly reworked while adapting to the recent
changes in "Make DSA tag drivers kernel modules" (02/09).

The introduction of some structures (DSA_SKB_CB, dp->priv) may seem a
little premature at this point and the new structures under-utilized.
The reason is that traffic support has been rewritten with PTP
timestamping in mind, and then I removed the timestamping code from the
current submission (1. it is a different topic, 2. it does not work very
well yet). On demand I can provide the timestamping patchset as a RFC
though.

"NXP SJA1105 DSA driver" v3 patchset can be found at:
https://lkml.org/lkml/2019/4/12/978

Vladimir Oltean (9):
  net: dsa: Call driver's setup callback after setting up its switchdev
    notifier
  net: dsa: Optional VLAN-based port separation for switches without
    tagging
  net: dsa: Allow drivers to filter packets they can decode source port
    from
  net: dsa: Keep private info in the skb->cb
  net: dsa: Add support for deferred xmit
  net: dsa: Add a private structure pointer to dsa_port
  net: dsa: sja1105: Add support for traffic through standalone ports
  net: dsa: sja1105: Add support for Spanning Tree Protocol
  Documentation: net: dsa: sja1105: Add info about supported traffic
    modes

 Documentation/networking/dsa/sja1105.rst |  49 +++++
 drivers/net/dsa/sja1105/Kconfig          |   1 +
 drivers/net/dsa/sja1105/sja1105.h        |   6 +
 drivers/net/dsa/sja1105/sja1105_main.c   | 246 +++++++++++++++++++++--
 include/linux/dsa/8021q.h                |  76 +++++++
 include/linux/dsa/sja1105.h              |  35 +++-
 include/net/dsa.h                        |  65 ++++++
 net/dsa/Kconfig                          |  20 ++
 net/dsa/Makefile                         |   2 +
 net/dsa/dsa2.c                           |   9 +-
 net/dsa/dsa_priv.h                       |   2 +
 net/dsa/slave.c                          |  61 ++++--
 net/dsa/tag_8021q.c                      | 222 ++++++++++++++++++++
 net/dsa/tag_sja1105.c                    | 131 ++++++++++++
 net/ethernet/eth.c                       |   6 +-
 15 files changed, 890 insertions(+), 41 deletions(-)
 create mode 100644 include/linux/dsa/8021q.h
 create mode 100644 net/dsa/tag_8021q.c
 create mode 100644 net/dsa/tag_sja1105.c

-- 
2.17.1

