Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E30425BD5
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 04:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfEVCCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 22:02:13 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]:38334 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVCCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 22:02:13 -0400
Received: by mail-qt1-f176.google.com with SMTP id l3so551785qtj.5
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 19:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LgJiNqIQYe4dm+RTF/vNdCAbo3J6Na+8TIs8YuTA9pU=;
        b=CxpdHltDHaItZyQohe2SIxiTM8Nvbs/aPr2+5XSoMFVMGZxhDYUwtqfKru/J7ijaJp
         HzRxQ+Grr7tXZYF6LnKKHaaehF+2boBJbBZOGT5McAc04b26gGMQjcR61A7n04zeaP/b
         ezjkcBpATKfxfo/JhTNt23lqfzVxBgxtl2kzoU2Rkr8h/5F2ehuFTQTMXmJIL+YHLhwC
         1Nwms97boEXEhIvsRCNwx1fklFTBSkqvfn+wGs3XU5q8umjoplVa73vA9jpl8agi3rVw
         AIQ/77Wbd+efuYH+z8VgR1f2Xc+ScS0l3ZDtJq6q+EL1HSFAuDEvNMy0Ns6EqDlWb6pq
         t8Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LgJiNqIQYe4dm+RTF/vNdCAbo3J6Na+8TIs8YuTA9pU=;
        b=HgrMWpsTO+vSPS/c25fJ7QXMkcpGRBGls7aOYCPehDpJlMNHan8GvKJuY9VFF0N28G
         ZRDalI5BLU/aXqNAwnh7ioHz1DLVcYXP0g+aeuMKqMAue5rbqekdHaE0emjn+g7mXFBR
         8irXHbl2Avnbz213GTzldca+N3C+NyQrMQjUU8JRnUHCviyWkbb7cPsnArqNi5Xnttkm
         IaFk4B9UFgfI+lUfIslOAv8WQWcEQlJRSjEKT7RZXTWzGw8JpWJqnOTaB3gy+VnQtHpv
         kQz7Gap1Yg3Zh7io1ga80scXKe0kH+lTyJmYD+jI6Oon7V44Ke4iHIMajo4lEgSYI6lY
         spWA==
X-Gm-Message-State: APjAAAXKloHnJFdfqyEiWchPWKztTcxiZ/yn7ZnUhNSrKepuNwcLZVEg
        GASwQQj19zTT2wPnemG3gooe4w==
X-Google-Smtp-Source: APXvYqxTeZ2xT4ciZAe+C/j2X1HlrLCA8fq8DI5IErFAtCLxqRIC2d92mR/oQoNDZcTKeCVMnN7UOA==
X-Received: by 2002:aed:3bc5:: with SMTP id s5mr32948517qte.2.1558490532674;
        Tue, 21 May 2019 19:02:12 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w195sm11440663qkb.54.2019.05.21.19.02.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 19:02:11 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/3] net/tls: fix device surprise removal with offload
Date:   Tue, 21 May 2019 19:01:59 -0700
Message-Id: <20190522020202.4792-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series fixes two issues with device surprise removal.
First we need to take a read lock around resync, otherwise
netdev notifier handler may clear the structures from under
our feet.

Secondly we need to be careful about the interpretation
of device features.  Offload has to be properly cleaned
up even if the TLS device features got cleared after
connection state was installed.

Jakub Kicinski (3):
  net/tls: avoid NULL-deref on resync during device removal
  net/tls: fix state removal with feature flags off
  net/tls: don't ignore netdev notifications if no TLS features

 net/tls/tls_device.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

-- 
2.21.0

