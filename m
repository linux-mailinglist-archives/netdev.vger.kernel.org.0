Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54766D4AD4
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfJKXS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:18:27 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38029 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfJKXS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:18:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so11596960wmi.3
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 16:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7YgpW27cZuoYFdV3RY1bHXljdad9EzV+YkSqX2ofDFY=;
        b=QB+3ZAt+8WQ6HJmIrRs5x8smw8IagOz2YQVvLGDakbth7G4u/eXoZ/p10qj1Cjl1ef
         IkCCvqQ6CJ0raQoBiJNwOmnejZnRCbvob1PhMzuC7zWIVf9p/j72dyMYLgEN6ux6c0uR
         M96cgJm30ARnKz1lgYL8K3b2J7ES09p6XvuAiSD6HmcsjhPWqEsdy8KC/5wxwykT0tLL
         UcZO4q+WNegg6ryZSMsQJkpszkIupRuDXWB7rGd//05togK7REF8ho5ie5jTCRQUrnhB
         PLaLRQRI0zQ8Q6LCFtjw917L/D7RSafpq99vjK4FASbhiXfdq1rL461UBrgbXlOkaHfT
         RNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7YgpW27cZuoYFdV3RY1bHXljdad9EzV+YkSqX2ofDFY=;
        b=qVX3/63j+BbFTBxrcc0BcXGmMze9LzbXzf+oVYDb2ERmH2ss9iDPHzgU42dnExxhRe
         KE1H9dEEOV26E23AliuGnEjFkFhEv/0VeK3VL5unnsy7rKKaSFTQqyX22IebO9FPEmh5
         YzwdXF2O0IKGTgRYQJtgHo1ow9UW2aFEne32hEOT/C2Vk0mquuq0gJ6YHYpTcpxgrVzQ
         L8sRgErBppz3POzMJf3BqZ8HQZnz2OPkEKIB2TDnZzBeO9hI55YrrZfVA85x7Q9q9tB1
         cFBCH7lyZZ26RpDNOr91reJEjV2LNzBUTioTPFyOxIUYiJTsLl3P+Rlw2dyQDKXjm1mC
         y68w==
X-Gm-Message-State: APjAAAVZxZHvlzf6sMG91degEFFlJSyhvkaFh+y/u2Yvl9pLAbKwPw5w
        5yFQI16CAdt6fOGXAL/QFAE=
X-Google-Smtp-Source: APXvYqwHzBwEXFBgOE22D7z5JyEhdLyngs4VxvuO5U0K22vh5eHInFjRk/vJIo6aAoaEUrBSGt4ClQ==
X-Received: by 2002:a1c:55c4:: with SMTP id j187mr5065004wmb.155.1570835904507;
        Fri, 11 Oct 2019 16:18:24 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id 207sm17425853wme.17.2019.10.11.16.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 16:18:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/4] PTP driver refactoring for SJA1105 DSA
Date:   Sat, 12 Oct 2019 02:18:12 +0300
Message-Id: <20191011231816.7888-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series creates a better separation between the driver core and the
PTP portion. Therefore, users who are not interested in PTP can get a
simpler and smaller driver by compiling it out.

This is in preparation for further patches: SPI transfer timestamping,
synchronizing the hardware clock (as opposed to keeping it
free-running), PPS input/output, etc.

Vladimir Oltean (4):
  net: dsa: sja1105: Get rid of global declaration of struct
    ptp_clock_info
  net: dsa: sja1105: Make all public PTP functions take dsa_switch as
    argument
  net: dsa: sja1105: Move PTP data to its own private structure
  net: dsa: sja1105: Change the PTP command access pattern

 drivers/net/dsa/sja1105/sja1105.h      |  16 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 234 +--------------
 drivers/net/dsa/sja1105/sja1105_ptp.c  | 391 ++++++++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  84 ++++--
 drivers/net/dsa/sja1105/sja1105_spi.c  |   2 +-
 5 files changed, 386 insertions(+), 341 deletions(-)

-- 
2.17.1

