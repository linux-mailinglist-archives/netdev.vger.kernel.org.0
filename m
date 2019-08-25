Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDD89C5EB
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 21:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfHYTqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 15:46:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34526 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbfHYTqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 15:46:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id e8so12914086wme.1
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 12:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SaYFPcN+MlLHGvtJ+DRlGf4xSX/j6aWkiTWqYMvGVUc=;
        b=scSeng9r8fyOjaZx0vGvs6Ys/tSIKpgmahekT7SpFxxeBqcKnrRWnouH7QAhac2DHu
         3nxSMy89ZKeUCiDxdPLyqLYWNUijzqp5/1JVbxMMK1crqHrspAQx2an695ehCw7atEaU
         oHpWt4bVQ+EGERoROhdDG5fl1KBdatEsqXd31BbXJZquDb8Wnw93TTVZjVy0Lg7rL7xz
         i9F26916W/KMMdPsgulD2Gpqm6tUivHCVb5k0tvrHAuSSVTaDHB9p19zfkMVzx60mPF9
         8HdT0e+Ibo7b6b/3nUHYNdYVpBNg0tbhY6GrWIAe2nNlt6wBgiDGYDqi5ZoZMO/SsMYq
         geUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SaYFPcN+MlLHGvtJ+DRlGf4xSX/j6aWkiTWqYMvGVUc=;
        b=tSWm2C5WyyojSW+R3TE71/iMYjOjQ4v9OoZD0t4moj+9K1Wcec8mCVl7HhQHgsvXtr
         S5/tBm/+xABSr1v2MZKPQFFMdnfKBwj0sIzPAN2gc3aq0hiL+30UVhc88MCRCf11DpYU
         ZDTTwiyANmVgfj+qtWuIiEl2PiM32BjDT5ju2hI+qRjBEFe4obpU/d0zjTsq5QqTvuZE
         a9HWWyA8y0czgyfpiDG4wZwgsOUvf0Laov8f/Iq1b7PgBn9hKl3Mj+KfF/FJEDXhSlG+
         MEFynb++EqsSORs+kXHvacLhTLYC5YfSvqVhfVIDsP1MKQi/cuTGyMc7A/Ct6gq3HILW
         v+Rw==
X-Gm-Message-State: APjAAAVZvK+YLh5bkaMzPv0mjW/+bRDCDlixUm+cWa8tVO6JYt3p7nwP
        mxFD+E9k/94ImR7BebpP4bo=
X-Google-Smtp-Source: APXvYqyIOFVqNoZ/0kWeQYs9ApRJ4djosU/vcfkTyWced1RR7/31Fl1wd0ISHrzjGI3i+8rU9KepOQ==
X-Received: by 2002:a1c:2314:: with SMTP id j20mr17641079wmj.152.1566762401847;
        Sun, 25 Aug 2019 12:46:41 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id v124sm19770974wmf.23.2019.08.25.12.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 12:46:41 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/2] Simplify DSA handling of VLAN subinterface offload
Date:   Sun, 25 Aug 2019 22:46:28 +0300
Message-Id: <20190825194630.12404-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depends on Vivien Didelot's patchset:
https://patchwork.ozlabs.org/project/netdev/list/?series=127197&state=*

This patchset removes a few strange-looking guards for -EOPNOTSUPP in
dsa_slave_vlan_rx_add_vid and dsa_slave_vlan_rx_kill_vid, making that
code path no longer possible.

It also disables the code path for the sja1105 driver, which does
support editing the VLAN table, but not hardware-accelerated VLAN
sub-interfaces, therefore the check in the DSA core would be wrong.
There was no better DSA callback to do this than .port_enable, i.e.
at ndo_open time.

Vladimir Oltean (2):
  net: dsa: Advertise the VLAN offload netdev ability only if switch
    supports it
  net: dsa: sja1105: Clear VLAN filtering offload netdev feature

 drivers/net/dsa/sja1105/sja1105_main.c | 16 ++++++++++++++++
 net/dsa/slave.c                        | 15 ++++++---------
 2 files changed, 22 insertions(+), 9 deletions(-)

-- 
2.17.1

