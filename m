Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B112FAC4C1
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 07:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394384AbfIGFaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 01:30:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33151 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394256AbfIGFaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 01:30:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id r17so8770634wme.0
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 22:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dx41YCGDvfkhBz/wB+xC7MBpYx63Q4EPkw5ptApY9cc=;
        b=uYuK+TRMeohmWJ6yi4KVOL/QwLE8748fjRvczmBPUrxFQ+kCJRTn1+W0yP4hLqR8Gp
         lbj/5UZDRYKSp+cj/p9GR/4XyZBOmP3uTrKc7784+FDbFJAGebIyqOm7XA+Bf7sZuFJf
         Sx2nKDYdTaPj8gmjRDZLht9BJarsOonlJa4i11K2QwiGQJ440zTbMksWqrEIS2CtYarL
         pdVADAoOyPgWvHRpL6pCOPCnO+IZPEE3+EKdeZThlxHGoSEVEbv7LPbuTB5BrY3i9hqB
         ma2Sa8FGKLiR2+oKOPVOMavdAC/wC74ITZKxXN79EIskn9Tey4sG8vaFanNo9SpS5yTa
         db2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dx41YCGDvfkhBz/wB+xC7MBpYx63Q4EPkw5ptApY9cc=;
        b=p2K9644r411dxzNOsyi3wfKjPutygImARsBnPGf1Y52BQ1/FCmfpLuX+4fXFq5DaKK
         GBDd1muNLJ1H52Wuv1c9cc0uor8R0rE1gCYzRZrpO3eziwOFqDdRm08EOhGL7X+3AJnE
         DIkxA7ABYQBcpWW17NstKRIH/P2/OISXGBsXA+F0uvpMMTE3m3aat1tAlbkPMAZh2QW0
         3cyKNMAcyfqJ1vdkzdretHYu3G7fhqSXnH5O4HWpOn7SuP3Xpl2oZV8jQEknIjjHyPbQ
         67XQNThGIreE5eIcBBzn3QW5b4f6iYa3cerhhDiNfDkyJQxUPwhk/+rLrdOMNc0ZxfXQ
         CZcQ==
X-Gm-Message-State: APjAAAV9HUCO3ZVn3dQlBaj/gl0TMJ5VPQmkxAQ6Px+Bzpanpm3kshcQ
        9MOov9Ygl+MSQbUSYpzA6D3tag==
X-Google-Smtp-Source: APXvYqy1hzIyXYTb6y9aXxKfAixS/cv+qrRtORR98ArH4utCt15EJqSYpNd7CRVDXPr/KbptOq5hkg==
X-Received: by 2002:a7b:c549:: with SMTP id j9mr9255872wmk.143.1567834215732;
        Fri, 06 Sep 2019 22:30:15 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n4sm2446939wmd.45.2019.09.06.22.30.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 22:30:15 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/4] net/tls: small TX offload optimizations
Date:   Fri,  6 Sep 2019 22:29:56 -0700
Message-Id: <20190907053000.23869-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This set brings small TLS TX device optimizations. The biggest
gain comes from fixing a misuse of non temporal copy instructions.
On a synthetic workload modelled after customer's RFC application
I see 3-5% percent gain.

Jakub Kicinski (4):
  net/tls: unref frags in order
  net/tls: use RCU for the adder to the offload record list
  net/tls: remove the record tail optimization
  net/tls: align non temporal copy to cache lines

 net/tls/tls_device.c | 121 ++++++++++++++++++++++++++++++-------------
 1 file changed, 84 insertions(+), 37 deletions(-)

-- 
2.21.0

