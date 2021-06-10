Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A993A37DB
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFJX34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:29:56 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:45753 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhFJX3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:29:55 -0400
Received: by mail-ed1-f51.google.com with SMTP id r7so20641274edv.12
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lLZajE0kF2yv7O85pmFs2crS5Zf9rKc0mk2l/qV3sWM=;
        b=M5QdytZTp4Q8xN6q7JNQ3UA2zjLjrdOKG43dMYbDTdWprCODXQzyR5LxEVtAPQfGi2
         R0/cXE9tfrRGoxKo2iIbkBJm1dq4bJAMVrWKlCO9BcRxagdpxpUHkmDi5Ku68MATz9vA
         9pQ211yT96BOF8TXK5/FXijCvniAgxrvs0Qzb81B8EdSmLTeTyoXIBtFGEhLJdo4jRNE
         2DaS5BPUXlRyD0Ge7BD5nFHBaCht/FEvBf9Hh3WlSpBOV312yFk97rPyh5L1+ruqZwN7
         +dlddISqDW85Vj0X9DRi0uioX58VjScnY62lTZryWBrHuknfYH163J9YyINzO8+Rc0YO
         5CTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lLZajE0kF2yv7O85pmFs2crS5Zf9rKc0mk2l/qV3sWM=;
        b=oSoTqqcn7+W7yg40WfmIa08AnJ0Au84s6iZpPhKcxGdRS1PdSIMM5G7xqdo2tvInN9
         gpwUnqAB4xx+MoVUP1u6pXOuPBwDMAUwFr9ALaIoKeoUFQeMhQuaJWmg7Uf2fW5SVmj3
         9+BuzSLl/fNzvIcN9EuwV5oUg+UxlSuIbWMdvED0SsuI6PVhcJUywcYDMdVcu06Yo58t
         EBHoQH+5+XhJyK0bWz/XqgDXThiqyYV6VUlZRhHw9UOIkzCLh2yavnCPfN9D/GDN4cB1
         yBGu4xOr9JdsScRt2iOS30MKfb9VDHU7Q5MkPa8EbcJuvjpN6T2L7uDCs07bn7YyZ8hK
         kIJA==
X-Gm-Message-State: AOAM531p9qa3X8dPechXCEwRyRjVOwmC03/sIG/Gb0gqiZmS3rPlZrQT
        q325RFxLtl+lMTVFUO+yfyg=
X-Google-Smtp-Source: ABdhPJyB4onJEgvQK2H/APnrbPiFy4TnCYnLa9qtc9wQRpRRYnPLHoPdrAS2Od4ntsgkhnAF56k+nA==
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr877677eds.78.1623367602981;
        Thu, 10 Jun 2021 16:26:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1534187ejt.11.2021.06.10.16.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:26:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 00/10] DSA tagging driver for NXP SJA1110
Date:   Fri, 11 Jun 2021 02:26:19 +0300
Message-Id: <20210610232629.1948053-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support for tagging data and control packets on the new
NXP SJA1110 switch (supported by the sja1105 driver). Up to this point
it used the sja1105 driver, which allowed it to send data packets, but
not PDUs as those required by STP and PTP.

To accommodate this new tagger which has both a header and a trailer, we
need to refactor the entire DSA tagging scheme, to replace the "overhead"
concept with separate "needed_headroom" and "needed_tailroom" concepts,
so that SJA1110 can declare its need for both.

There is also some consolidation work for the receive path of tag_8021q
and its callers (sja1105 and ocelot-8021q).

Changes in v2:
Export the dsa_8021q_rcv and sja1110_process_meta_tstamp symbols to
avoid build errors as modules.

Vladimir Oltean (10):
  net: dsa: sja1105: enable the TTEthernet engine on SJA1110
  net: dsa: sja1105: allow RX timestamps to be taken on all ports for
    SJA1110
  net: dsa: generalize overhead for taggers that use both headers and
    trailers
  net: dsa: tag_sja1105: stop resetting network and transport headers
  net: dsa: tag_8021q: remove shim declarations
  net: dsa: tag_8021q: refactor RX VLAN parsing into a dedicated
    function
  net: dsa: sja1105: make SJA1105_SKB_CB fit a full timestamp
  net: dsa: add support for the SJA1110 native tagging protocol
  net: dsa: sja1105: add the RX timestamping procedure for SJA1110
  net: dsa: sja1105: implement TX timestamping for SJA1110

 Documentation/networking/dsa/dsa.rst          |  21 +-
 drivers/net/dsa/sja1105/sja1105.h             |   4 +
 drivers/net/dsa/sja1105/sja1105_main.c        |  35 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c         |  97 +++++-
 drivers/net/dsa/sja1105/sja1105_ptp.h         |  13 +
 drivers/net/dsa/sja1105/sja1105_spi.c         |  28 ++
 .../net/dsa/sja1105/sja1105_static_config.c   |   1 +
 .../net/dsa/sja1105/sja1105_static_config.h   |   1 +
 include/linux/dsa/8021q.h                     |  79 +----
 include/linux/dsa/sja1105.h                   |  26 +-
 include/net/dsa.h                             |   8 +-
 net/core/flow_dissector.c                     |   2 +-
 net/dsa/dsa_priv.h                            |   5 +
 net/dsa/master.c                              |   6 +-
 net/dsa/slave.c                               |  10 +-
 net/dsa/tag_8021q.c                           |  23 ++
 net/dsa/tag_ar9331.c                          |   2 +-
 net/dsa/tag_brcm.c                            |   6 +-
 net/dsa/tag_dsa.c                             |   4 +-
 net/dsa/tag_gswip.c                           |   2 +-
 net/dsa/tag_hellcreek.c                       |   3 +-
 net/dsa/tag_ksz.c                             |   9 +-
 net/dsa/tag_lan9303.c                         |   2 +-
 net/dsa/tag_mtk.c                             |   2 +-
 net/dsa/tag_ocelot.c                          |   4 +-
 net/dsa/tag_ocelot_8021q.c                    |  20 +-
 net/dsa/tag_qca.c                             |   2 +-
 net/dsa/tag_rtl4_a.c                          |   2 +-
 net/dsa/tag_sja1105.c                         | 312 ++++++++++++++++--
 net/dsa/tag_trailer.c                         |   3 +-
 net/dsa/tag_xrs700x.c                         |   3 +-
 31 files changed, 551 insertions(+), 184 deletions(-)

-- 
2.25.1

