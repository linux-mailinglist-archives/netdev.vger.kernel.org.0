Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E712EA922
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 03:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfJaCJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 22:09:33 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37313 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfJaCJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 22:09:33 -0400
Received: by mail-qt1-f196.google.com with SMTP id g50so6400656qtb.4;
        Wed, 30 Oct 2019 19:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JEU7U39/Op5pg2LNZgsOwhOAxrwT9y+7EfdsgnrCvPI=;
        b=fi803U72PttAWd2PzdFrAKhx7mGhy09H/K4lPwDfl05rZpKK3Og3MfkTUbOgpJSJbd
         9FTYvRABpwcAGrgRfaZIGK7kHn5SVFo7YQf+zEQmHZmdv2PnKbEDI96z7+suMP8P14Em
         KAdK56dvNLr9EZFbgm1VS6qgr1ZpFf++FFF3xR0RgCYtwQZZxYL5p3RfGF/yvKCS1XMn
         zeCavCkhYFf4FuNRoClSu+9HiOArYBTO2IoPBWTYuSEM3n51lchqvS03XqSLKIeODRG9
         1focFuibN0+u0mIwojFOahcapwUqNzQmJZGdDU1GZqgfg0SgSxl30fcNS0Jv3yBii6Go
         Yuaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JEU7U39/Op5pg2LNZgsOwhOAxrwT9y+7EfdsgnrCvPI=;
        b=AWLnUiOrx7eYV51hGtoD9M9ij7ZUMSD6igGnbNM9IbBUaA8R+ql+IxMLGCGvmEUBZB
         sN2LVsdmOmMbR0dgCMna0PlxFqj4VjBPdIjia4Yv2YHOBs1VkL8Q14iE933IDVFG0lEx
         mrK/zScON8IWx1xkj+t6ZGOyLg0zBozfU9yY+aH5k/YPGQwCgA7zaHyafe5mQy5rONQP
         fOoyCsJeSarwl1+RIjUW3yf1uekbeqX6uvvHmdBuYfc6wq8lOfzFvbeL4wLaAY4pbEtz
         UKxCVrR/Eyg7xZVMaNnB5WJh59YFv+IaYsbXAf26ojcRPqsAY2Ayoo9qoCKhMq5enhRH
         7V8A==
X-Gm-Message-State: APjAAAXEKYbCyNlv6CExfW/Zdi2SG3c0+JDEu14D4JOiejVX9CCOkWj0
        E5GYPgTvwQNPbXK3CsXOz40=
X-Google-Smtp-Source: APXvYqwWylfXZw723vis1t6dYgEYwvWVExz5bajzoGMfn9S84nnqu6pNLCgXoYgDxDPuZ1eLARYRSw==
X-Received: by 2002:ac8:2d2d:: with SMTP id n42mr3258093qta.119.1572487772183;
        Wed, 30 Oct 2019 19:09:32 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z17sm1541316qtj.95.2019.10.30.19.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 19:09:31 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 0/7] net: dsa: replace routing tables with a list
Date:   Wed, 30 Oct 2019 22:09:12 -0400
Message-Id: <20191031020919.139872-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This branch gets rid of the ds->rtable static arrays in favor of
a single dst->rtable list. This allows us to move away from the
DSA_MAX_SWITCHES limitation and simplify the switch fabric setup.

Changes in v2:
  - fix the reverse christmas for David

Vivien Didelot (7):
  net: dsa: list DSA links in the fabric
  net: dsa: remove ds->rtable
  net: dsa: remove switch routing table setup code
  net: dsa: remove the dst->ds array
  net: dsa: remove tree functions related to switches
  net: dsa: remove limitation of switch index value
  net: dsa: tag_8021q: clarify index limitation

 drivers/net/dsa/mv88e6xxx/chip.c |   8 +-
 include/net/dsa.h                |  39 +++++++---
 net/dsa/dsa2.c                   | 121 +++++++++++++------------------
 net/dsa/tag_8021q.c              |   5 +-
 4 files changed, 85 insertions(+), 88 deletions(-)

-- 
2.23.0

