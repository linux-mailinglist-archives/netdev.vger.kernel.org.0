Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C780CF0
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfHDWjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:39:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39148 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfHDWjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:39:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so60862820wmc.4
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 15:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7C25X5qXBakta2ke4cvQy8wE4WSIdgtoSXxFmQqtRhs=;
        b=CS2P8ArwC8YAxFLyNQ2XaX60fROXDs73+QHf+q80yCoqAKc4ZooBpPzUAB9yZ7rzZj
         jI3MO/AMIeAkR/KdnNt3ETmVKn8fAWVNzgEWEP80jdFBzHO6rA/UWHLGQ+R2/1XAd5vZ
         sd+6r5te5DxuaLJV8cfBCtMU1fnGQki9YbL/G947hOV0aSqkHOffZ+744KWDSqK3wdd5
         naq7Gp2cU9OxWr5nCKEoADbBsqKqHJFJ/rl5BcvMiaLJfWwwLKlk9BdJohw5edRs7vZj
         VwLhs13HBOqXH0NmzN1lnKkURsv7asXBlrvqdgidS+1FJvD+hl2jaoCO1yc6EXDI/igi
         zUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7C25X5qXBakta2ke4cvQy8wE4WSIdgtoSXxFmQqtRhs=;
        b=oQ2sN9NwpOoZvn3GIl9I5evrxTvAv0juj5PG5qHIGTADBnnm2joKorUUSqlZaCf6aj
         6jFmIJhPIZRjl3+iPrgHIRtD47IKxoCEZb/22gzDPI0tJ7R2bMR62h9XP3VdIgpBndXP
         QnrZrGgxRQSVfYMxx4ThE3pEtBfg/8BSk7Bs3eismNr38GxO1/ROd0SqeaHrZToaXZMs
         VFw7PGJxoydTtLFzOsHkTFxvV/RTkqfQJxeR+NLxabC6CHL00HeOEnOWF5JvguodTuPx
         grQ3vSmm42iVocC6IscJswlBxSGy+Xc1B6oUJbGZ6mWS2FLdVQDyqly2rxLJ3PTCUX/J
         qjmQ==
X-Gm-Message-State: APjAAAWY2tCdGejkuUs8t4159oTkjb/4r9uWAqYpacV5ephA4hFCsnbr
        bBy2gBwhtqRXF4YYE+YmwgE=
X-Google-Smtp-Source: APXvYqyJ1kaVK674WX/+8PW1V4DQy6wknhZIkcAjQntPNJpU9F6bCxsYK+EDfs9mGKauUw6NdtOvsQ==
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr13636636wmj.61.1564958362067;
        Sun, 04 Aug 2019 15:39:22 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id j33sm187795615wre.42.2019.08.04.15.39.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:39:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/5] Fixes for SJA1105 DSA: FDBs, Learning and PTP
Date:   Mon,  5 Aug 2019 01:38:43 +0300
Message-Id: <20190804223848.31676-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an assortment of functional fixes for the sja1105 switch driver
targeted for the "net" tree (although they apply on net-next just as
well).

Patch 1/5 ("net: dsa: sja1105: Fix broken learning with vlan_filtering
disabled") repairs a breakage introduced in the early development stages
of the driver: support for traffic from the CPU has broken "normal"
frame forwarding (based on DMAC) - there is connectivity through the
switch only because all frames are flooded.
I debated whether this patch qualifies as a fix, since it puts the
switch into a mode it has never operated in before (aka SVL). But
"normal" forwarding did use to work before the "Traffic support for
SJA1105 DSA driver" patchset, and arguably this patch should have been
part of that.
Also, it would be strange for this feature to be broken in the 5.2 LTS.

Patch 2/5 ("net: dsa: sja1105: Use the LOCKEDS bit for SJA1105 E/T as
well") is a simplification of a previous FDB-related patch that is
currently in the 5.3 rc's.

Patches 3/5 - 5/5 fix various crashes found while running linuxptp over the
switch ports for extended periods of time, or in conjunction with other
error conditions. The fixed-up commits were all introduced in 5.2.

Vladimir Oltean (5):
  net: dsa: sja1105: Fix broken learning with vlan_filtering disabled
  net: dsa: sja1105: Use the LOCKEDS bit for SJA1105 E/T as well
  net: dsa: sja1105: Really fix panic on unregistering PTP clock
  net: dsa: sja1105: Fix memory leak on meta state machine normal path
  net: dsa: sja1105: Fix memory leak on meta state machine error path

 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  14 +-
 drivers/net/dsa/sja1105/sja1105_main.c        | 140 +++++++-----------
 drivers/net/dsa/sja1105/sja1105_ptp.c         |   7 +-
 net/dsa/tag_sja1105.c                         |  12 +-
 4 files changed, 75 insertions(+), 98 deletions(-)

-- 
2.17.1

