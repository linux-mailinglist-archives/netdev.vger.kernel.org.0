Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F31A53E6
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbfIBKW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:22:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730190AbfIBKW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:22:27 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E870AC002966
        for <netdev@vger.kernel.org>; Mon,  2 Sep 2019 10:22:26 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id z2so8600299wrt.6
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 03:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gEeiAvszbxAnk0W0OeGR1SCbvK2gSsI+MgoJstXil1Q=;
        b=skfWjU1YF/SBf3uYtq8wgi8jETr7Yz2juK1DEKHubuOW80l9TTAAhLfRVfJCCj7nK0
         2xeoynN5iwvXnQ14KV/EgvjQitbJEvBJNzHMlBKG7yWcQVVLjvsN9ejJp0BSpUcLP5ia
         9C3RzD/CRr7gKGKiVz4Xj2aJC+9r/nGR+eMqUprA7kPvaUyJGFhULQSSA2Px2WaOt2v9
         q75Hhsvm58KkQzakzZFaEk9f21mnaT6crBbdUD8FWz6W8uGOeHyOKLug4Lk5uuRaGIZC
         Q9QtYR3CwVle42dDgIhbtWCSl27Ow6HQHsCeKcMPJP6lIRIkt1zb6HkdJUnSI7//QkgY
         o9fA==
X-Gm-Message-State: APjAAAUKS72dwFb7HR1h9SBcdrhN+aduJq52aXnOMbtn8Ea3IM+weYUw
        gtMTqOBLwORnmw1zj+kubWY6PEofwGWdyOFR7/sBuZA/r9nLfLnFxWqFEoj0Zc4/K+W58Gz9We7
        +ITVZaMsScyk/R8rO
X-Received: by 2002:a05:6000:b:: with SMTP id h11mr19503088wrx.270.1567419745323;
        Mon, 02 Sep 2019 03:22:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwxsYAVAlXDrurLgSjDGUBmX9a2kkFqZL1X+GoLeUx1TkB89k+TrUHluPTa8s3E8CdQ7zTV9A==
X-Received: by 2002:a05:6000:b:: with SMTP id h11mr19503065wrx.270.1567419745133;
        Mon, 02 Sep 2019 03:22:25 -0700 (PDT)
Received: from mcroce-redhat.redhat.com (host221-208-dynamic.27-79-r.retail.telecomitalia.it. [79.27.208.221])
        by smtp.gmail.com with ESMTPSA id h23sm15824669wml.43.2019.09.02.03.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 03:22:24 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 0/2] mvpp2: per-cpu buffers
Date:   Mon,  2 Sep 2019 12:21:35 +0200
Message-Id: <20190902102137.841-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset workarounds an PP2 HW limitation which prevents to use
per-cpu rx buffers.
The first patch is just a refactor to prepare for the second one.
The second one allocates percpu buffers if the following conditions are met:
- CPU number is less or equal 4
- no port is using jumbo frames

If the following conditions are not met at load time, of jumbo frame is enabled
later on, the shared allocation is reverted.

Matteo Croce (2):
  mvpp2: refactor BM pool functions
  mvpp2: percpu buffers

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   4 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 272 +++++++++++++++---
 2 files changed, 235 insertions(+), 41 deletions(-)

-- 
2.21.0

