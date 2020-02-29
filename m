Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E4174782
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgB2Ou5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:50:57 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39141 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgB2Ou4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:50:56 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so6868026wrn.6
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lEaID/YP+IcYac1UYierEmZvcSj8shTaGfYwyqFzgeM=;
        b=TQ0I7xTdLHe8xFgl3qV0dNczpClpwBdxL9FY34VoJWFmxXBnCgtta2VNyORu6U0EEO
         D6uWzaUBXb4dxVIpm53yiKcwV9QOJTTNUTBxPVxCdPukssVjq7UzZ68dmyyTJVtDRbnW
         gzukLdsq3rtoH4Rv0vVi4SdmBRE86yJ7lhubjE7GBuGOqLWszPypBjEQYhOP5m99rjKn
         uarPAxZK6wTKiTeP+A4siLPaqbyoOc0dEgI3cGMd57QB/gq4N7XsAL/sHT5CkAQeLky6
         +KSN6yPAx5ip52MPVmHyvZB9AhGRRjbleLhEf/36BCXAGPWxWDVmbZmRHjMW4fBq7SyW
         HjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lEaID/YP+IcYac1UYierEmZvcSj8shTaGfYwyqFzgeM=;
        b=jDXnS5/TuF/nP4RsIOLy3TvYwR3pueEjMZgWlxZ1kKQLPHcXaZP0Q/B0lVh0EKa3oQ
         1KFNoByGp2DTv4Z107txYuUHY4FPPzZN6MEOHd2LY3Fs1lVmFgvaRmBBfmmnKVTqq62S
         yTBAFTh/AqngSM5HhkD8FST2nrHwvvuub1A2LbK134pOS9G7N9H0UJx56O1ywI/bbYXO
         JjO7RPZs0F5AyCeRu1AvTe6+9UqjHWABqFLMtcCpuWQa9v65Awxc18QEKqyUFjDhdS08
         TMtiFJOdIuQo++fKR8X3Mxmd4UtF9HK8Q/vvxpTP9EsKGmBe70lhojqGRkBlWiKC/rnv
         kYsw==
X-Gm-Message-State: APjAAAXC2OzVmEGTHGMyqL5Xc/ODkL0XuXm9fS9N23X6fc8rOTaoa+/g
        7XZBvfHiByZ1yBMi9s/VXFE=
X-Google-Smtp-Source: APXvYqzkioFbSsxyUuo/KI+gWOE4JOeZ5Qlu9i50kGfuXGawA726OBgAeEzFl0qGeHpaMxO42ilRQg==
X-Received: by 2002:adf:f6c1:: with SMTP id y1mr10763465wrp.17.1582987853910;
        Sat, 29 Feb 2020 06:50:53 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id j14sm18164015wrn.32.2020.02.29.06.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:50:53 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 0/2] Allow unknown unicast traffic to CPU for Felix DSA
Date:   Sat, 29 Feb 2020 16:50:01 +0200
Message-Id: <20200229145003.23751-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

 drivers/net/dsa/ocelot/felix.c           | 16 +++++-
 drivers/net/ethernet/mscc/ocelot.c       | 62 +++++++++++---------
 drivers/net/ethernet/mscc/ocelot.h       | 10 ----
 drivers/net/ethernet/mscc/ocelot_board.c |  7 +--
 include/soc/mscc/ocelot.h                | 72 ++++++++++++++++++++++--
 net/dsa/tag_ocelot.c                     |  3 +-
 6 files changed, 121 insertions(+), 49 deletions(-)

-- 
2.17.1

