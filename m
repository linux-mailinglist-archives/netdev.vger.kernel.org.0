Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D21513EC4
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfEEKTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:19:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41625 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfEEKTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id c12so13412149wrt.8
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VwcX6SuHVLW1nKVu/hsbbrZz2vlyWLKMjyxZ3yk9B44=;
        b=TqvYh286Zb3JhzeZpMgnVwkrKfCmPNdfgRRZfClZbFF4ML+9ZReu477DzjbNyuQs6f
         dEwHWJbZRFiwjm6OM28okKLgijRY5qusC3MAeSxDfmIV+10OqcUxMQutXVfZXu76B4lW
         +wEJJGVvhM8/t7+S+FKTjzaf3qnsCaszat/+AUWILLoRVcpzLNhIVVMpUK2uMB4Rth6o
         wxX3Pqs7Tczplgw4Z/WKaw2mWAMRObaIER098pg++mZa8xcM66Bu54A1ZnrBz87jQuOe
         /kSU/hSO3cB0+6t6brtVyQZNQlxBytNnKHlzgqV2rSdpddsOdHymUToJC7tQpu9ASIFB
         LEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VwcX6SuHVLW1nKVu/hsbbrZz2vlyWLKMjyxZ3yk9B44=;
        b=tMZnr2d7LYXnmqPwzQbeuuH3fLKekVYbcRY+ZEVpWXp+1/vKSHz9E0sFulSW8nN/Mu
         ihtS2BQqNM+H3vVqC9X2deuKO5rskAs/mbf4EF2VnL86fDYDcZvtG/0SwzF+NHA7ua9t
         E4C7xsMN5f4QnhCyGylW1kXQFcuK+KzKuOFQRlevFGCgJw2r1VXcLQDV4YSa7HkKyLIh
         LVNe/wsyv594KlD+toqoAqGHgV6+ul8qAuD4kptFWQ9eU9fPrEvkJddb5tPEGT0Ng0eB
         Guv1nIq6AuM4HDWlTsW8BIKYkujCuNS14+UMoHrBEfTltkiBTgAqE7bXDe6nXQAj/EMb
         I8yA==
X-Gm-Message-State: APjAAAWX8/1CgVsA7g48teMxtkhR7CByX2BP8Q2unxPfWf8WT/iiDvCi
        Ce8Nq9EsYuIZdlHuZN+y8gVhYMlk
X-Google-Smtp-Source: APXvYqyi7htnD85FDefMEW/z6Hb5SxmFmH7MJW9os3jB5/mb4V4YYWQye2lmQaUP0MrVxB4cZl5QaA==
X-Received: by 2002:a5d:6912:: with SMTP id t18mr9299889wru.17.1557051579530;
        Sun, 05 May 2019 03:19:39 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 00/10] Traffic support for SJA1105 DSA driver
Date:   Sun,  5 May 2019 13:19:19 +0300
Message-Id: <20190505101929.17056-1-olteanv@gmail.com>
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

v1 patchset can be found at:
https://lkml.org/lkml/2019/5/3/877

Changes in v2:

* Made the deferred xmit workqueue also be drained on the netdev suspend
  callback, not just on ndo_stop.

* Added clarification about how other netdevices may be bridged with the
  switch ports.

v2 patchset can be found at:
https://www.spinics.net/lists/netdev/msg568818.html

Changes in v3:

* Exported the dsa_port_vid_add and dsa_port_vid_del symbols to fix an
  error reported by the kbuild test robot

* Fixed the following checkpatch warnings in 05/10:
  Macro argument reuse 'skb' - possible side-effects?
  Macro argument reuse 'clone' - possible side-effects?

* Added a commit description to the documentation patch (10/10)

Vladimir Oltean (10):
  net: dsa: Call driver's setup callback after setting up its switchdev
    notifier
  net: dsa: Export symbols for dsa_port_vid_{add,del}
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

 Documentation/networking/dsa/sja1105.rst |  54 +++++
 drivers/net/dsa/sja1105/Kconfig          |   1 +
 drivers/net/dsa/sja1105/sja1105.h        |   6 +
 drivers/net/dsa/sja1105/sja1105_main.c   | 246 +++++++++++++++++++++--
 include/linux/dsa/8021q.h                |  76 +++++++
 include/linux/dsa/sja1105.h              |  35 +++-
 include/net/dsa.h                        |  68 +++++++
 net/dsa/Kconfig                          |  20 ++
 net/dsa/Makefile                         |   2 +
 net/dsa/dsa2.c                           |   9 +-
 net/dsa/dsa_priv.h                       |   2 +
 net/dsa/port.c                           |   2 +
 net/dsa/slave.c                          |  64 ++++--
 net/dsa/tag_8021q.c                      | 222 ++++++++++++++++++++
 net/dsa/tag_sja1105.c                    | 131 ++++++++++++
 net/ethernet/eth.c                       |   6 +-
 16 files changed, 903 insertions(+), 41 deletions(-)
 create mode 100644 include/linux/dsa/8021q.h
 create mode 100644 net/dsa/tag_8021q.c
 create mode 100644 net/dsa/tag_sja1105.c

-- 
2.17.1

