Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E70CEA056E
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfH1O6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:58:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41559 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfH1O6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 10:58:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so105206wrr.8
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 07:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lE5u4nJ66WBe1wnsF1M0KIbzlttZzu9045WhjeymvmY=;
        b=BmGzNtbsF+2YrNghxeQyGwpjrk26X0LZzKBwDRLNa3AoxroOv/X71OyIL9lY9hK6lX
         S+4RNlH11xslfu0CEFibxxvyWm/c9U6y+RKDPuY3SPcusrO7pUujk/cZdXVLo75dnZel
         QQp7N58TEZqQhAsZTDDEIBi2k8GxGGjgxURe9U7TCvP58opg4xNzbOmnqDv245QhTwGX
         U5kW5kw+ChvGuveWHS4CpiLjlgnjbhzuSA4bqmjwCb8UpqRX9t5nYIgquPrjzhPyzcOy
         ZBMeGiPJxbheWZ1dOz0aSbVvBaSdNiF2K7+CHrN4D40iG/ndwNPmGws9Yen6hCWuZcTn
         H4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lE5u4nJ66WBe1wnsF1M0KIbzlttZzu9045WhjeymvmY=;
        b=Xhn0vzLQfk9qI8738No9r6vA/VlNi3adDJBDbE2Ub8BNIK/vWBcJEppmtbB3ClFRi9
         MD9p0RuSApp7o3JgTwH0JRgXQ2F6nYRCNTC//RRUoYYtq1cV83mGqfFlzlzowXrKiGg1
         mtlltwP2eQmoSy1/oJjRtWJnIaqPVlhXtZj8aXgiUWcl/CTN70YHVCUH8r1yJg1a+zpx
         k9vHkt6t1rOGT8N3hUWJfZqxoTQIvu7y2baIMW6S4YjLK6jRlW9w7AvAZrI4S0s97H/T
         J79Uvo+s5wYi0/bo93U15LEmvIqaE+bDZavVrrodPl3WwOy6J6HtezCGg9mnWRkZ4R7I
         beAg==
X-Gm-Message-State: APjAAAUDYlXaJFk/6pYIoYmPaEi+4xfPe1OFwEA5iqyRspXjgVj5Wbvx
        ZQA/vbL8hDDzJkkqJvWETkxYg3wfBEY=
X-Google-Smtp-Source: APXvYqxHbkr2HKl8QHcVTGgQMQWGZESlrgnV6V8PpX/NMY0rWE7ATZUlxOpk8l980Z2U6SZIPLFCLg==
X-Received: by 2002:adf:fa01:: with SMTP id m1mr5268787wrr.254.1567004293021;
        Wed, 28 Aug 2019 07:58:13 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id o2sm3284190wmh.9.2019.08.28.07.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 07:58:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        asolokha@kb.kras.ru
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH 0/1] Fix PHYLINK handling of ethtool ksettings with no PHY
Date:   Wed, 28 Aug 2019 17:58:01 +0300
Message-Id: <20190828145802.3609-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Logically speaking, this patch pertains to the "Fix issues in tc-taprio
and tc-cbs" series at:
https://patchwork.ozlabs.org/project/netdev/list/?series=127821&state=*

The reason why I did not submit this patch together with those is that I
don't know whether the error condition can happen in current mainline
Linux at the moment. I am running Arseny's RFC patch "gianfar: convert
to phylink" and have found that __ethtool_get_link_ksettings returns a
speed of 0 instead of SPEED_UNKNOWN when there is no PHY connected.

Gianfar has carried this oddity over from its PHYLIB days, where it
connects "late" to the PHY. I am not sure whether PHYLINK, gianfar, or
both, need to be changed. Comments welcome.

Vladimir Oltean (1):
  phylink: Set speed to SPEED_UNKNOWN when there is no PHY connected

 drivers/net/phy/phylink.c | 1 +
 1 file changed, 1 insertion(+)

-- 
2.17.1

