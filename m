Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DE212FFAC
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 01:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgADAhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 19:37:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46461 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgADAhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 19:37:17 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so43835314wrl.13
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 16:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=65JxR1ai52of+XyH8Sd3GDSwpXFzyJnPvQ9FkKcGwBQ=;
        b=lHn3KFTkhVnXgjjh1ud/o9g3cyGfajdfqAzCFtoijAdyrLfo93wQKlGXIdpOgy8D/s
         8pmyLp7MKffvuWgpcT6BRLUsFmlnSYFcywjSw1x9nBSSL7wK/tmn/3DzfIBbrXRFVo85
         ULD1AA03kxEiMdJaiznTV4lG9QmXx0pu640loIkNVK9RMrJK1qC7Q85pE3TE9gLOjtOo
         qCTfaHRzKjoOEuTTiqikjY4HbqlTfj4EB8l3VGKeQ+wfOy81CY+TYnPeHKBT3SLv7H6k
         73dwqvatFLO3H0PT/okulPA69DAPw3MUFadtMjw5nZhl/9GDG9XUaJRDklK70UsWkKqw
         x4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=65JxR1ai52of+XyH8Sd3GDSwpXFzyJnPvQ9FkKcGwBQ=;
        b=WK9R/zfYNYqwUqmI9JxvLUVGG7OxoWDkaNAc60YLzwxG4sOZGsjs/UBWeoLLrysnYF
         rp9iEqwlLUpbcdFRXmeguQLq8aS194uBK1XbjO2u9qKlElYnlBY/5JogZLmArZ2LlKAm
         MZrzUTi/64htUXhoBBRBZ17nDAoGOSOmBYhrnENnYVSUZOkeG4NZBM4koGK3i8mtU5OL
         DLfhCT2bkh7vku+eRiN29ZbOcojoQ2zeTyIGsJUHsz8g/6UMwgcofpGM184oXIv3g5vf
         Ee98Z2qWbgM1bPsMwsYBgEqSB3yK5uALo0wkUWpTXDDJdXNq4Di3r9gKDoxMBx9vCCac
         551g==
X-Gm-Message-State: APjAAAU5S1qm5oWmirRofo/0m8Yxgy/iSjY0HeKCvBHFZMH1YS+IFSWQ
        i3mUC60qG53nQgJFzKtkzns=
X-Google-Smtp-Source: APXvYqxlbIlSITZ6SFPKEy8XyQSlNtXngWvmA5N3lFb80VyIZa/qE5Q9egZVAo0hDNamDsGUcS+mNg==
X-Received: by 2002:a05:6000:118e:: with SMTP id g14mr89447471wrx.39.1578098235139;
        Fri, 03 Jan 2020 16:37:15 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id x10sm59644167wrv.60.2020.01.03.16.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 16:37:14 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 0/3] Improvements to the DSA deferred xmit
Date:   Sat,  4 Jan 2020 02:37:08 +0200
Message-Id: <20200104003711.18366-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the feedback received on v1:
https://www.spinics.net/lists/netdev/msg622617.html

I've decided to move the deferred xmit implementation completely within
the sja1105 driver.

The executive summary for this series is the same as it was for v1
(better for everybody):

- For those who don't use it, thanks to one less assignment in the
  hotpath (and now also thanks to less code in the DSA core)
- For those who do, by making its scheduling more amenable and moving it
  outside the generic workqueue (since it still deals with packet
  hotpath, after all)

There are some simplification (1/3) and cosmetic (3/3) patches in the
areas next to the code touched by the main patch (2/3).

Vladimir Oltean (3):
  net: dsa: sja1105: Always send through management routes in slot 0
  net: dsa: Make deferred_xmit private to sja1105
  net: dsa: tag_sja1105: Slightly improve the Xmas tree in sja1105_xmit

 drivers/net/dsa/sja1105/sja1105_main.c | 120 +++++++++++++++----------
 include/linux/dsa/sja1105.h            |   4 +-
 include/net/dsa.h                      |   9 --
 net/dsa/dsa_priv.h                     |   2 -
 net/dsa/slave.c                        |  37 +-------
 net/dsa/tag_sja1105.c                  |  18 +++-
 6 files changed, 94 insertions(+), 96 deletions(-)

-- 
2.17.1

