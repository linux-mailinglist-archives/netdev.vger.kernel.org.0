Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9D439FC9
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 15:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfFHNDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 09:03:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56218 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfFHNDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 09:03:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so4520117wmj.5
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 06:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mZ0IhyUCytjfdZRm6QSoJ7pqK83VhwGyG5Nrvea+uJA=;
        b=V7uIUGzWDvXosu4Qjvp7Zv+ByNXNbar+TOqe83YsrZURlP5RAHDszVWFgPc362tZ5I
         YBNEHqVij7pXitXJcT9wwRDW+oqittIuxHyacFgBKlVbAtpdQhT7kVD6IhgdJyixLCfM
         nGM/mWdJbjpfemzlrs2nXe+wewwfa5hRPifejhVtH8EnzwzYLqpmRfZv8D5tq0aej8tZ
         PoReTOXABb6J/zTDMJ0eeLVNPx0Mn5W0MXDHMaaKxEXCTw/jsiYwHcxbLmIMoOmu+ws8
         q13Z4/mi2PTeU06j9b7W4co2LHWAhOxNvFCN1okGEuyKNMUcUD4GGjJbIqySk8cyLawJ
         M3lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mZ0IhyUCytjfdZRm6QSoJ7pqK83VhwGyG5Nrvea+uJA=;
        b=ZPOPaKQo3tK7l9NMTjPOt2eQ9+WNRk55eCXT7VbAupdhJ9piphcpSD9E5ImyDzXrI5
         1me/K/Jnyags4Kq9qCyKB0KedUSukCLgBg0XboBo9TnAvyJ0dt0bWBh3i+jlQbT6QEi2
         ecotvJYyotJoQls88KUOxHcUe2fm/9Wsqifw7Y/bvcnC7+EWOTAkalEWFw7YH77ebXR2
         BnBqWV3yMw1uWQDVIuY6L3wmZ1mGe7lO9hoxat4HliOlmkr12aav9uBOG5HS6JzQ91i0
         8NfWz1AZvg3R+x6P2cjZXGGGxuLv+P8cpP9rOEdbSroPoTn+oqQcTw5a5Xom2JSxxx4r
         0ocQ==
X-Gm-Message-State: APjAAAXLiRlu5FAmPnxuByBZyjuH0DGfVhXbc3OB/64KuGnyRP7qBpqB
        TOXlaSWe8BXpmoy7neU6MoE=
X-Google-Smtp-Source: APXvYqyBIsB04mQCja/0GcN1u/FJkGDkHtYcV0nPINQqaNdgjT1BCg7Qrk1hDmtQIwC0qtarQhba/w==
X-Received: by 2002:a05:600c:2149:: with SMTP id v9mr6951688wml.141.1559999030539;
        Sat, 08 Jun 2019 06:03:50 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id 128sm4632766wme.12.2019.06.08.06.03.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 06:03:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/4] Rethink PHYLINK callbacks for SJA1105 DSA
Date:   Sat,  8 Jun 2019 16:03:40 +0300
Message-Id: <20190608130344.661-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements phylink_mac_link_up and phylink_mac_link_down,
while also removing the code that was modifying the EGRESS and INGRESS
MAC settings for STP and replacing them with the "inhibit TX"
functionality.

Vladimir Oltean (4):
  net: dsa: sja1105: Use SPEED_{10,100,1000,UNKNOWN} macros
  net: dsa: sja1105: Update some comments about PHYLIB
  net: dsa: sja1105: Export the sja1105_inhibit_tx function
  net: dsa: sja1105: Rethink the PHYLINK callbacks

 drivers/net/dsa/sja1105/Kconfig        |   2 +-
 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c | 138 +++++++++----------------
 drivers/net/dsa/sja1105/sja1105_spi.c  |  14 +--
 4 files changed, 62 insertions(+), 94 deletions(-)

-- 
2.17.1

