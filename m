Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140D416B2A5
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgBXVfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:35:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43384 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBXVfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:35:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id r11so12186146wrq.10
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3VSaKJB6+NoBZrbeiaz5pRFHkQdImhv4sNwWrfC9chs=;
        b=ljN+ctc9ypy8M0BzZPSlZniU15LUrG5WWtPJGTn1reHCaKbbwFyEV2TM5V7/WrgDLa
         GtcQVU2vB5adnkOU1JZjozLoCES2cKQdImmoWeXJDTzxMmLIXZ7enbf0JnwCary7NfPb
         +VtgDti1s41mfTK39GQXohMnkmLZzPLstHs2XWUgPtpzKjuK9vxvRZIL3EVV0yDv5IMR
         c/cdy4UiLQ95EOKXE5OpfMuyBJ/yX5Kmz15CPDJuoRLDrvmBt2r1sZ4pymVQBDP/ShSU
         1YzFjQrBGMrn8rATUT9wvJ/FNel7pzmXOrMNwC9f88QXqKqUzda7xxIYL/0EyBdRTkFc
         mIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3VSaKJB6+NoBZrbeiaz5pRFHkQdImhv4sNwWrfC9chs=;
        b=IgfqRXoPCRK+FyYA+gFiSHw/beaRSqqS3Sx/O7+9H3LTKsqPfrUf7RjbBiugErJVSp
         tpbQUpcnbIW4KeQOh06P7hoQoYjG9GJno7aGyBzpfEa6B4aAK4MW1PdXKM+gPA8gu6UC
         71DlUrxo6LFjvpZG7tzZfxurRo752/fbgv9jfOWpFkceuRcTtXesAC9kB5pOCt+P/+Sy
         8fgi5lVu8lHjrnZHaQdIiqpNwXrPk3n1Xr56yBKGWvFdjbvMKNbbU1PGPnFYP1M+OQK6
         Easor4BMqpxe20v7uowN4wh6FUUhz48iRYcu3Bj7kxSgeA9sD2Kzh3uh8JtZdtsXUFQJ
         Lhgg==
X-Gm-Message-State: APjAAAX+B0AS5T+e3XyMFEqPnh1xgHe+NDAogTo+RoWxDzRY2Rzolrct
        aubbHibKVu9T0K1CFfGjK0k=
X-Google-Smtp-Source: APXvYqzf+lCA54fcrAxr7FqbTFk2+00DRU/vGHp7tmnMk8IMZwfj4h2N8CvQheXvN6Pb6HnzGyNcLg==
X-Received: by 2002:adf:df90:: with SMTP id z16mr67227042wrl.273.1582580105903;
        Mon, 24 Feb 2020 13:35:05 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n3sm1001069wmc.27.2020.02.24.13.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:35:05 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 0/2] Allow unknown unicast traffic to CPU for Felix DSA
Date:   Mon, 24 Feb 2020 23:34:56 +0200
Message-Id: <20200224213458.32451-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is the continuation of the previous "[PATCH net-next] net: mscc:
ocelot: Workaround to allow traffic to CPU in standalone mode":

https://www.spinics.net/lists/netdev/msg631067.html

Following the feedback received from Allan Nielsen, the Ocelot and Felix
drivers were made to use the CPU port module in the same way (patch 1),
and Felix was made to additionally allow unknown unicast frames towards
the CPU port module (patch 2).

Vladimir Oltean (2):
  net: mscc: ocelot: eliminate confusion between CPU and NPI port
  net: dsa: felix: Allow unknown unicast traffic towards the CPU port
    module

 drivers/net/dsa/ocelot/felix.c           | 16 ++++--
 drivers/net/ethernet/mscc/ocelot.c       | 62 +++++++++++++---------
 drivers/net/ethernet/mscc/ocelot.h       | 10 ----
 drivers/net/ethernet/mscc/ocelot_board.c |  5 +-
 include/soc/mscc/ocelot.h                | 67 ++++++++++++++++++++++--
 net/dsa/tag_ocelot.c                     |  3 +-
 6 files changed, 117 insertions(+), 46 deletions(-)

-- 
2.17.1

