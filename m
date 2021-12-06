Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF046933E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 11:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhLFKRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 05:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235772AbhLFKRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 05:17:37 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5A1C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 02:14:08 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1638785646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SMwNRtOAEg1dqtcrilcdAoVkoWkH0cJamOE90u29d+E=;
        b=HcUrKRKr+/bcJ0GmQ/gWp5dwLKo/1dedGTCmMbGY72j83wuzh56DK9b3MwoQRJJKln934u
        9V150/siwAAN8ccC3snmmpKyBdqxYMyRWmqWkRvK9/YqLKPZGG18FjtzDOAFyHKJyiuNYl
        aNsLM47ycMs4hJzNPso7Mr7fxjwOq5E=
From:   Jackie Liu <liu.yun@linux.dev>
To:     kabel@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, liu.yun@linux.dev
Subject: [PATCH] net: dsa: mv88e6xxx: fix uninit-value err in mv88e6393x_serdes_power
Date:   Mon,  6 Dec 2021 18:13:52 +0800
Message-Id: <20211206101352.2713117-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

'err' is not initialized. If the value of cmode is not in the switch case,
it will cause a logic error and return early.

Fixes: 7527d66260ac ("net: dsa: mv88e6xxx: Save power by disabling SerDes trasmitter and receiver")
Reported-by: kernel-bot <kernel-robot@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 55273013bfb5..33727439724a 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1507,7 +1507,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool on)
 {
 	u8 cmode = chip->ports[port].cmode;
-	int err;
+	int err = 0;
 
 	if (port != 0 && port != 9 && port != 10)
 		return -EOPNOTSUPP;
-- 
2.25.1

