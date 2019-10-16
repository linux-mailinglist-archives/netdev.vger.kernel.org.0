Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9407CDA1F8
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405831AbfJPXHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:07:23 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46165 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389129AbfJPXHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:07:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id o18so106760wrv.13;
        Wed, 16 Oct 2019 16:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GgIaguR3zbW5gymqzaWVQpClblW7SO//3IVmlVP9BgY=;
        b=IiuoBFuZdV4Pqx5uMcjA+lPbeMx76MAfmUxTfsfdre59jzBQFy65+F4vOE2nKGK6dq
         1voKvpJ9VXhFw8T1/s+FZ6WxTYABILErZjPM2YKiJ1XYXanIOI/LUmdOBYsdiP9tuRac
         lzKRP5VNGJbOGpovoGriN/18zbJAWtygUrwUU04CewDKTkReAQ1NfEsvdPoXkRro8437
         AnhlqjIruPEVoTKfCqJHAmW+Bq6Bb8WZS9JpVGTkV8T1wao+R034UFnmVK1lw06V8TzC
         /NNRwUSBMPgH5Gin9M2sr3DIGaZbOcprxfJA+0h9iOS+y81ODLEnfTfwr6CiSIEYnO6S
         6qxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GgIaguR3zbW5gymqzaWVQpClblW7SO//3IVmlVP9BgY=;
        b=MeRgzzSCao9kCPCTIOKHHSDLUZpECKVvmsjVa19K99icWst/SEJwdodLwTf7Wbtc9e
         rh1YDZsEiJMIjez6HlIZh3lLxSvmI9/MnmTQuUJKsRUIgElpiHxDyxQ6ytE2Zs5HwFEB
         YEPHsleQXinziLRAkdliJqX8qHaNjVi6hj/kN5QBNyjDClESnHRDcHOPnzclTPSii4IC
         BEhEtEP/ZYRu7YYqnBfnDAB6v+2w91EpQbJMW72Gkrn+Sp+rySsHnGZthm+zKVaUFtgJ
         RtZ6flj8Zo0kg5NTg3ykuc0v6RLKm2duki/s11uPnpci6qKKMIYHpJwuzv8JUGlvzBlC
         KgIw==
X-Gm-Message-State: APjAAAUNehlNBJwtkHllzJl0Co2/UxZaUDaEfmZKsp71OJrmwBFYvYHo
        c4vW4n0tEdKNYQHqMyEftohLCDNd
X-Google-Smtp-Source: APXvYqwoJT4pqCR3zmv0RSm0ZDWFSVA8QyFQbkize4ArET7GpVnTYC2dFOU6tqdkjaRSdNWX+u8d/w==
X-Received: by 2002:adf:dd88:: with SMTP id x8mr251880wrl.140.1571267241080;
        Wed, 16 Oct 2019 16:07:21 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l9sm297071wme.45.2019.10.16.16.07.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Oct 2019 16:07:20 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 0/4] net: bcmgenet: restore internal EPHY support
Date:   Wed, 16 Oct 2019 16:06:28 -0700
Message-Id: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I managed to get my hands on an old BCM97435SVMB board to do some
testing with the latest kernel and uncovered a number of things
that managed to get broken over the years (some by me ;).

This commit set attempts to correct the errors I observed in my
testing.

The first commit applies to all internal PHYs to restore proper
reporting of link status when a link comes up.

The second commit restores the soft reset to the initialization of
the older internal EPHYs used by 40nm Set-Top Box devices.

The third corrects a bug I introduced when removing excessive soft
resets by altering the initialization sequence in a way that keeps
the GENETv3 MAC interface happy.

Finally, I observed a number of issues when manually configuring
the network interface of the older EPHYs that appear to be resolved
by the fourth commit.

Doug Berger (4):
  net: bcmgenet: don't set phydev->link from MAC
  net: phy: bcm7xxx: define soft_reset for 40nm EPHY
  net: bcmgenet: soft reset 40nm EPHYs before MAC init
  net: bcmgenet: reset 40nm EPHY on energy detect

 drivers/net/ethernet/broadcom/genet/bcmgenet.c |  41 +++++----
 drivers/net/ethernet/broadcom/genet/bcmgenet.h |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c   | 112 +++++++++++--------------
 drivers/net/phy/bcm7xxx.c                      |   1 +
 4 files changed, 79 insertions(+), 77 deletions(-)

-- 
2.7.4

