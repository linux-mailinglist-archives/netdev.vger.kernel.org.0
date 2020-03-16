Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9264D187502
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732770AbgCPVpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:45:23 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:34940 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732652AbgCPVpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:45:23 -0400
Received: by mail-wr1-f45.google.com with SMTP id h4so2539986wru.2;
        Mon, 16 Mar 2020 14:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FfPpdz9J4skN4p3S/CS6XKQcAy2N9kTf5vI/j49UlgQ=;
        b=GAaQ7sIzdom1zPFBKBJ0qramzcEWfAyH6wS9FE+ctO79AA5zuhWW7MRnREov6Kktwu
         /mHnCpJeGC75drCn3e/Q8Dtb9Mzf14q3VDmZezYiY4I+93u6imbwa7wbTrUlLJTj5SQJ
         cQoHbDCNDSTgHyHM0EGIxzcYozCqYzIspCEl09cswre1F/5K9j/ytSnaI+KdtXc9EYqY
         TWvu0HpUd0XPrVZvBHvD1Xc1JAT7o5CmGuxChluOBhoDO68/5eW4mss5VHCyONINDDs0
         C/TENN3J48NEdjfWD1p6qDRqZg5EWvFAC13Jqjb+7awmdL/1uJKyZcENWgX31PY69q+m
         cTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FfPpdz9J4skN4p3S/CS6XKQcAy2N9kTf5vI/j49UlgQ=;
        b=LypnkhnfhRtSlTg9rAkNy5W1q9dq2gIFUWabEZvmk7ofT0Gk0Q3zXc4p9kMSXt+nOp
         KWK5d4Vqo/MXnz2aW0oatXcjA+zFxKkjlV5iwEry/2XZUpTxa4vaSCE7cs1jt8/jCZbm
         BhayW3XNq92w0McU9lk8uE8Qcx3qozr6X2m/YXMDsdf1bhpA0xZDBVdZvlF55gVlikE9
         2HjeVI+GXwg/qQcKT/2qtMDgaq1k/69idZThwtlrMSVkPzSTBdrVlcSuVLng0QZNuFx3
         fbCYNBYWN7qO8hV5Wanm1drqd7uZticM+hwbAX3Hv8g00NXGZDxUS0xNul8TyLCEdM+A
         sMNQ==
X-Gm-Message-State: ANhLgQ12diOX8drcmC1/SUUAviSUAH4luVdnLqt9QzM1/Cu75wtS7LYN
        KpaXGKSu3XdYHIKtdzgn6Rc=
X-Google-Smtp-Source: ADFU+vuMlY3kwzXXs69D6CZI4m87gdH5XYJab7g0mZaWj3MEXEhiTPue0pxPxGqNDw2y4S0PE1VxXw==
X-Received: by 2002:a5d:5741:: with SMTP id q1mr1394313wrw.169.1584395121578;
        Mon, 16 Mar 2020 14:45:21 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a13sm1625676wrh.80.2020.03.16.14.45.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Mar 2020 14:45:21 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 0/2] net: bcmgenet: revisit MAC reset
Date:   Mon, 16 Mar 2020 14:44:54 -0700
Message-Id: <1584395096-41674-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3a55402c9387 ("net: bcmgenet: use RGMII loopback for MAC 
reset") was intended to resolve issues with reseting the UniMAC
core within the GENET block by providing better control over the
clocks used by the UniMAC core. Unfortunately, it is not
compatible with all of the supported system configurations so an
alternative method must be applied.

This commit set provides such an alternative. The first commit
reverts the previous change and the second commit provides the
alternative reset sequence that addresses the concerns observed
with the previous implementation.

This replacement implementation should be applied to the stable
branches wherever commit 3a55402c9387 ("net: bcmgenet: use RGMII 
loopback for MAC reset") has been applied.

Unfortunately, reverting that commit may conflict with some
restructuring changes introduced by commit 4f8d81b77e66 ("net: 
bcmgenet: Refactor register access in bcmgenet_mii_config").
The first commit in this set has been manually edited to
resolve the conflict on net/master. I would be happy to help
stable maintainers with resolving any such conflicts if they
occur. However, I do not expect that commit to have been
backported to stable branch so hopefully the revert can be
applied cleanly.

Doug Berger (2):
  Revert "net: bcmgenet: use RGMII loopback for MAC reset"
  net: bcmgenet: keep MAC in reset until PHY is up

 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 10 +++---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  6 +++-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       | 40 ++++------------------
 3 files changed, 16 insertions(+), 40 deletions(-)

-- 
2.7.4

