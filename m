Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F10123859
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLQVDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:03:19 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39697 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfLQVDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:03:19 -0500
Received: by mail-wm1-f67.google.com with SMTP id b72so4721478wme.4;
        Tue, 17 Dec 2019 13:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GxzriEHPiJzchhSDhjDW2yVbRDC1frNuwENV6e3uE9E=;
        b=o84tlNEctnC5hBDROraAJX0vNa6tLdOc8Eqw02XhyFAse1GfHxNCjmylJVahWLIvkF
         QeOCSKQDHkBhj++1hwMIU/Bj8HkhIw4nUbnknfyj9DQV0TqHs+Sa4bWeluhLjJ/vybvt
         iNQwayn+H9cpwMlOeMrARz2kf5Swqxl94N/8uKlD9M3XDPga4yD8WqxAtLPhGmnYnhzM
         CHi1K4sjebn8Uy7VAXQz3BoWvTkV4g/Hc5ZlPMfOq9dEFb7zcGERBc0HCmvDgBn/SB4b
         rcZl6Sdjry3pefneskMAisdVTGK/tPzOZLzsZgalHFcCHEydUaKG0+6H8nUS1zV8RTRX
         qFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GxzriEHPiJzchhSDhjDW2yVbRDC1frNuwENV6e3uE9E=;
        b=h7uKyOrpOmcpxecoa/X8ksl+IxW5MgKyGQ22pexuZDWpcXaAIRU8/G9IQ+hZI2xT+z
         k9ry71dABOHsgAhEf58QH/NUaLA35poHa36zSnqZUJBOPQ+N0EMSWM3GC/+I2uBS3Chf
         O8vDg0K+9lOLlhZ05oYrikFbWSfYBu35WT7XAFJ5NzoqBakAmIA9UukrQ7BnO4ieXndW
         tBYAcjqZeMI/9M0wt0e/fxyUukzUn/fHiHxYmuB7dqdaiUk6Vs9M3uB8gED+BxKiUJBu
         l1Wl88UkHzCYvpzroWxBsmH0TOaMhb7aTpjpvuSP89BxVf3qagf/6abMnjOOSQJGLZeW
         B1aQ==
X-Gm-Message-State: APjAAAV7T5uJd5ZfKDwpaM8xqOmVKAsaXgFGVPshiVoNsWSKxsbssjLR
        VVPvWQq/Ww7DarDU1qy7Uls=
X-Google-Smtp-Source: APXvYqwXMHVmY6Ot+nXyFpagGsPXLBPuGCkBkA8nm8XKRZbgyt85eg2jRI3YeeTl2Bc0G+K2eZvi9g==
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr5347963wmc.173.1576616596729;
        Tue, 17 Dec 2019 13:03:16 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i5sm37856wml.31.2019.12.17.13.03.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 13:03:16 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 0/8] net: bcmgenet: Turn on offloads by default
Date:   Tue, 17 Dec 2019 13:02:21 -0800
Message-Id: <1576616549-39097-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit stack is based on Florian's commit 4e8aedfe78c7 ("net: 
systemport: Turn on offloads by default") and enables the offloads for
the bcmgenet driver by default.

The first commit adds support for the HIGHDMA feature to the driver.

The second converts the Tx checksum implementation to use the generic
hardware logic rather than the deprecated IP centric methods.

The third modifies the Rx checksum implementation to use the hardware
offload to compute the complete checksum rather than filtering out bad
packets detected by the hardware's IP centric implementation. This may
increase processing load by passing bad packets to the network stack,
but it provides for more flexible handling of packets by the network
stack without requiring software computation of the checksum.

The remaining commits mirror the extensions Florian made to the sysport
driver to retain symmetry with that driver and to make the benefits of
the hardware offloads more ubiquitous.

Doug Berger (8):
  net: bcmgenet: enable NETIF_F_HIGHDMA flag
  net: bcmgenet: enable NETIF_F_HW_CSUM feature
  net: bcmgenet: use CHECKSUM_COMPLETE for NETIF_F_RXCSUM
  net: bcmgenet: Refactor bcmgenet_set_features()
  net: bcmgenet: Utilize bcmgenet_set_features() during resume/open
  net: bcmgenet: Turn on offloads by default
  net: bcmgenet: Be drop monitor friendly while re-allocating headroom
  net: bcmgenet: Add software counters to track reallocations

 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 107 ++++++++++++++-----------
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   3 +
 2 files changed, 65 insertions(+), 45 deletions(-)

-- 
2.7.4

