Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2F7133AAD
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 06:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgAHFGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 00:06:14 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34571 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgAHFGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 00:06:13 -0500
Received: by mail-wm1-f68.google.com with SMTP id w5so363530wmi.1
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 21:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jLVqObeYLC7d7UNxZ9ns6Cteqy8w8gwWc7xioogb6kI=;
        b=bgCnaSxXQ07Z1Q7ua5EP8Ah15XuIaVbUyA+slni3YI8jRHmcttnQXX5oPd9ohAv3fs
         KzJoG9GhGA0GIiUg5eA150sjamhDe5PCs+iy3+qBehJWOve9IKMzQVkoDI2wtNxy83Gv
         QIGJ1ABg6sySvwsQ5zmjRXQLyMvfICN+5CQR/fqxV4N4UUhdCIBATxqHdVN8+piRcxEK
         uP6rfQo7qdBJYCcBpv0gTHNtSNZuAbJwYthNGBDT1nNmsgnPEcCXu06eThoGvLa5WYoY
         /F5jO0c6zT7zOQRLyDLw1JvlBPJRsE5GY2LHlwlASzh+kDAUPJdUuipTGZclDNB5MqZg
         ofaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jLVqObeYLC7d7UNxZ9ns6Cteqy8w8gwWc7xioogb6kI=;
        b=n1vSa4cSL+M+o2V/nj8bbDWuvD5jpxFqSIMpTnUCQ7TDBGq7lhNA25h2j0g6jhtvL9
         LrjktqMabwjjb5T7ULcwkV4fy7pGU46AEuUjuA+lmafkV77jEGv7U5qkot02+VtJs6sr
         6TIylDfdP4GMLngkObaBEQQCtaLrTpsM5e1Qa/LJHQFXTIQbv+6NYSM4eNfQarsiomLp
         zRYLAX5shWTCX3Q/Q0Fc1RoO3uVh+BCS/rBhQ1KEhljP8g0Jr++bTrg86WSgdPz0rRNL
         VCEZD2Ry/BG7lWg9aVEJT0RJvqomrauM4LU3ONYP4wo7uic0SkGu3XctbmPIeQdLojEy
         iFuw==
X-Gm-Message-State: APjAAAWQGI9qcHSJZ9mllTtoCnOy2AsBuqouIBrXyg9FVP/KDEawZSzy
        E4/vo47qH2FrJ7AmvmgI9HrfykeX
X-Google-Smtp-Source: APXvYqyKYGcKQVhQBFnnzfOXlzMwG71UDR2ra8qx39HykjBBuVlctPdqWES4pU2fCE16EfD9fB9ywA==
X-Received: by 2002:a1c:6404:: with SMTP id y4mr1516583wmb.143.1578459971406;
        Tue, 07 Jan 2020 21:06:11 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p5sm2730048wrt.79.2020.01.07.21.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 21:06:10 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/2] Broadcom tags support for 531x5/539x families
Date:   Tue,  7 Jan 2020 21:06:04 -0800
Message-Id: <20200108050606.22090-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

This patch series finally allows us to enable Broadcom tags on the
BCM531x5/BCM539x switch series which are very often cascaded onto
another on-chip Broadcom switch. Because of that we need to be able to
detect that Broadcom tags are already enabled on our DSA master which
happens to be a DSA slave in that case since they are not part of the
same DSA switch tree, the protocol does not support that.

Due to the way DSA works, get_tag_protocol() is called prior to
ds->ops->setup and we do not have all data structures set-up (in
particular dsa_port::cpu_dp is not filed yet) so doing this at the time
get_tag_protocol() is called and without exporting a helper function is
desirable to limit our footprint into the framework.

Having the core (net/dsa/dsa2.c) return and enforce DSA_TAG_PROTO_NONE
was considered and done initially but this leaves the driver outside of
the decision to force/fallback to a particular protocol, instead of
letting it in control. Also there is no reason to suspect that all
tagging protocols are problematic, e.g.: "inner" Marvell EDSA with
"outer" Broadcom tag may work just fine, and vice versa.

This was tested on:

- Lamobo R1 which now has working Broadcom tags for its external BCM53125 switch
- BCM7445 which has a BCM53125 hanging off one of its internal switch
  port, the BCM53125 still works with DSA_TAG_PROTO_NONE
- BCM7278 which has a peculiar dual CPU port set-up (so dual IMP mode
  needs to be enabled)
- Northstar Plus with DSA_TAG_PROTO_BRCM_PREPEND and no external
  switches hanging off the internal switch

Thanks!

Florian Fainelli (2):
  net: dsa: Get information about stacked DSA protocol
  net: dsa: b53: Enable Broadcom tags for 531x5/539x families

 drivers/net/dsa/b53/b53_common.c       | 66 +++++++++++++++++++-------
 drivers/net/dsa/b53/b53_priv.h         |  4 +-
 drivers/net/dsa/dsa_loop.c             |  3 +-
 drivers/net/dsa/lan9303-core.c         |  3 +-
 drivers/net/dsa/lantiq_gswip.c         |  3 +-
 drivers/net/dsa/microchip/ksz8795.c    |  3 +-
 drivers/net/dsa/microchip/ksz9477.c    |  3 +-
 drivers/net/dsa/mt7530.c               |  3 +-
 drivers/net/dsa/mv88e6060.c            |  3 +-
 drivers/net/dsa/mv88e6xxx/chip.c       |  3 +-
 drivers/net/dsa/ocelot/felix.c         |  3 +-
 drivers/net/dsa/qca/ar9331.c           |  3 +-
 drivers/net/dsa/qca8k.c                |  3 +-
 drivers/net/dsa/rtl8366rb.c            |  3 +-
 drivers/net/dsa/sja1105/sja1105_main.c |  3 +-
 drivers/net/dsa/vitesse-vsc73xx-core.c |  3 +-
 include/net/dsa.h                      |  3 +-
 net/dsa/dsa2.c                         | 31 +++++++++++-
 net/dsa/dsa_priv.h                     |  1 +
 net/dsa/slave.c                        |  4 +-
 20 files changed, 114 insertions(+), 37 deletions(-)

-- 
2.17.1

