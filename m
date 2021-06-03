Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31A439A5DD
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFCQkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:40:24 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:39717 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhFCQkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 12:40:24 -0400
Received: by mail-lj1-f177.google.com with SMTP id c11so7931992ljd.6;
        Thu, 03 Jun 2021 09:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dg1cMbsNNvwB5OdWxFGfb7KgRwPXh4V5fRmUP5p6A38=;
        b=RrrueZy9r9DKDF26hY7QWRZMiPiuU/NUMwjn9bjRwczXNpUWyOMueFeUpbSJBVl4uC
         Yhp3lmS4NQQGk6NMbS7/PONLZEotmEa6VJ3/ukmRQpgz3MroFeA/pDchkQGAM3A+X7Qv
         Nxnjze6YJ/C5wveqwwjT8PhKCZwypevofZSgyKwpVzvIsJkUkfCPMPWcnqQ7WZmLLfEm
         Renqgr7go8J+cgZ2/WyTMNO3Arh+4F4+4aJOnyUum7DhcDXxhAgVMgS0LuBurVvd/HBW
         W2XY243joefQYORdGSF2qJ6zfOjU31ulu/W7fmJpSoSyRe5LK32n7Y/43T2csRv4/kGF
         b5og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dg1cMbsNNvwB5OdWxFGfb7KgRwPXh4V5fRmUP5p6A38=;
        b=s89mL0QbCZz70A9MsKrkm19wgbGQyCCpcC/7cNQiUG8M+BzWYWSNXXOQBGCZwNFQgI
         ldn868Q2gGn0ji1hiEfUt/YhnK3GE+Ibp/O1vm+zdwH9Vg+IoRJkRRm1UoTlDuB2hfXw
         TtSG8VKBY86T9a0Wt+DuE25eudj+8XCHXzsVRZO0JhSwooLWmWm98uEkcr2LCTdTxJHT
         QqkFm+zkWe00ecix2z4eT2CAtmL7KAmmwWx1LM4wxNk1231AcS3tX3NAD4mYJF4EttHM
         fybcKdo8RkdT2ot65NjzDidRpNMK4e+zVPznlXcMONLpAoffu2cW/kT+rcqCMGrE+CiQ
         piYQ==
X-Gm-Message-State: AOAM532U7mNb6ME2SuWvZPUr22elWbOYe2cdpOslAOCagU/3KmNQymmS
        C3qFzlfIv4YFihpa7elZNmw=
X-Google-Smtp-Source: ABdhPJwq2FHuCJ3LCjyNk09uOXvaSyHbq7RBi7/+zBxt8W/o7kB0TkaFaA8sVLJOUd3aHk9rrCWoJg==
X-Received: by 2002:a2e:6e19:: with SMTP id j25mr182995ljc.476.1622738258343;
        Thu, 03 Jun 2021 09:37:38 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id d26sm280461lja.74.2021.06.03.09.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:37:37 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        sjur.brandeland@stericsson.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH 0/4] net: caif: fix 2 memory leaks
Date:   Thu,  3 Jun 2021 19:37:27 +0300
Message-Id: <cover.1622737854.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fix 2 memory leaks in caif
interface.

Syzbot reported memory leak in cfserl_create().
The problem was in cfcnfg_add_phy_layer() function.
This function accepts struct cflayer *link_support and
assign it to corresponting structures, but it can fail
in some cases.

These cases must be handled to prevent leaking allocated
struct cflayer *link_support pointer, because if error accured
before assigning link_support pointer to somewhere, this pointer
must be freed.

Fail log:

[   49.051872][ T7010] caif:cfcnfg_add_phy_layer(): Too many CAIF Link Layers (max 6)
[   49.110236][ T7042] caif:cfcnfg_add_phy_layer(): Too many CAIF Link Layers (max 6)
[   49.134936][ T7045] caif:cfcnfg_add_phy_layer(): Too many CAIF Link Layers (max 6)
[   49.163083][ T7043] caif:cfcnfg_add_phy_layer(): Too many CAIF Link Layers (max 6)
[   55.248950][ T6994] kmemleak: 4 new suspected memory leaks (see /sys/kernel/debug/kmemleak)

int cfcnfg_add_phy_layer(..., struct cflayer *link_support, ...)
{
...
	/* CAIF protocol allow maximum 6 link-layers */
	for (i = 0; i < 7; i++) {
		phyid = (dev->ifindex + i) & 0x7;
		if (phyid == 0)
			continue;
		if (cfcnfg_get_phyinfo_rcu(cnfg, phyid) == NULL)
			goto got_phyid;
	}
	pr_warn("Too many CAIF Link Layers (max 6)\n");
	goto out;
...
	if (link_support != NULL) {
		link_support->id = phyid;
		layer_set_dn(frml, link_support);
		layer_set_up(link_support, frml);
		layer_set_dn(link_support, phy_layer);
		layer_set_up(phy_layer, link_support);
	}
...
}

As you can see, if cfcnfg_add_phy_layer fails before layer_set_*,
link_support becomes leaked.

So, in this series, I made cfcnfg_add_phy_layer() 
return an int and added error handling code to prevent
leaking link_support pointer in caif_device_notify()
and cfusbl_device_notify() functions.

NOTE: this series was tested by syzbot
https://syzkaller.appspot.com/bug?id=62bc71b5fa73349e2e6b6280eca9c9615ddeb585)

Pavel Skripkin (4):
  net: caif: added cfserl_release function
  net: caif: add proper error handling
  net: caif: fix memory leak in caif_device_notify
  net: caif: fix memory leak in cfusbl_device_notify

 include/net/caif/caif_dev.h |  2 +-
 include/net/caif/cfcnfg.h   |  2 +-
 include/net/caif/cfserl.h   |  1 +
 net/caif/caif_dev.c         | 13 +++++++++----
 net/caif/caif_usb.c         | 14 +++++++++++++-
 net/caif/cfcnfg.c           | 16 +++++++++++-----
 net/caif/cfserl.c           |  5 +++++
 7 files changed, 41 insertions(+), 12 deletions(-)

-- 
2.31.1

