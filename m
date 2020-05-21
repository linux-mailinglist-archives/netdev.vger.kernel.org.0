Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A671DCC58
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 13:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbgEULrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 07:47:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45639 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729074AbgEULrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 07:47:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F42125C00CF;
        Thu, 21 May 2020 07:46:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 21 May 2020 07:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=sJENaNmJ/LYH6bFpNmJ7wWNagcOKU3srH25QIn016wI=; b=zygPE+36
        HUbuGbTIc5epA4IX/rN6c6vvqBEkkJxyBxa/I4tl97Nxwfhal6+YL1gBMAyG55lA
        lZ+EECQhkjDhyfmZLspGSTTwMFsivL75tby6UR/4uHZetci3VxAUoDspeE8xoVEt
        +rSh8m/tT5pDnimz5syN1of1bwsoTBqff31ZUzojdb1rDDFxk1gclKAOPtl+GiHr
        72EtNSw/vWNCpIbcQnIF1eiF0iZuk4WdFHbPgmIX/r+L6mel/0QwTcYfJvjQqEDk
        RKUpdKkePNi0WKVAU8/TRjFhANW6qWHxci9J42U4yf84NM77CjFDz/rS/aef0bcq
        lGds6jO5UWVGrA==
X-ME-Sender: <xms:M2rGXn44zzel41I7-DmfAfnCTJfMYqA47XklEcStfWkUmD3vZGNh9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduuddggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:M2rGXs5dGpBzS1xgWEPK0cOHsrQEm-PEuN-6RF_MnU9tLoTThQi1Ig>
    <xmx:M2rGXudcySCWBLXWXXwg8ULU9DocQL7Mfms6vLlYnvPYL-MUdklqjw>
    <xmx:M2rGXoKECxti828KzyZTb-SWmdlCJOTSGzsvi1t0q9C3P0sh1TcCwA>
    <xmx:M2rGXhje6aMU5aPC8YLf5HYj83pAPWkBk-J-myodgUfoNDfe9g2C-g>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AAF95306647D;
        Thu, 21 May 2020 07:46:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] netdevsim: Ensure policer drop counter always increases
Date:   Thu, 21 May 2020 14:46:16 +0300
Message-Id: <20200521114617.1074379-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521114617.1074379-1-idosch@idosch.org>
References: <20200521114617.1074379-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In case the policer drop counter is retrieved when the jiffies value is
a multiple of 64, the counter will not be incremented.

This randomly breaks a selftest [1] the reads the counter twice and
checks that it was incremented:

```
TEST: Trap policer                                                  [FAIL]
	Policer drop counter was not incremented
```

Fix by always incrementing the counter by 1.

[1] tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh

Fixes: ad188458d012 ("netdevsim: Add devlink-trap policer support")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 68668a22b9dd..dc3ff0e20944 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -858,8 +858,7 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
 		return -EINVAL;
 
 	cnt = &nsim_dev->trap_data->trap_policers_cnt_arr[policer->id - 1];
-	*p_drops = *cnt;
-	*cnt += jiffies % 64;
+	*p_drops = (*cnt)++;
 
 	return 0;
 }
-- 
2.26.2

