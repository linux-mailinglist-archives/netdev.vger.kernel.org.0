Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3473628A883
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 19:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388298AbgJKRbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 13:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbgJKRbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 13:31:19 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A6FC0613CE;
        Sun, 11 Oct 2020 10:31:19 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so11739636pgb.10;
        Sun, 11 Oct 2020 10:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hNTm1OzW+wIMxya0eR8AK1iqMeCHqexcmEvSu7nlCOI=;
        b=SS4zNG6yU7IlMUMGVW6ioKDCIvsh6QQh5FGnzmIuX9Wdj2VqDtAWSmv9y/CPFbzynp
         nhPED5aHrpRnxbWAmdWR2X532HxCN8qGvuwEFVPNRfXmMwbtmaTzV/xrPqpGAhqNYvcH
         /e+eFA7zuCmcHV1JLZBgYjSfDijfdtLKfoNIRXykS/Qa+Q5vdkEwmn7qwkvOACum3KJi
         EvOmtxt7ce4meYIiLSx95OJoEOhFo4dtPjwj5Fb8ZE7QB70RKy2zYxIIUe+6sXWcddXP
         za2NKRDedkBdAUi6YD/bU+zRll8xbcsKW8IG9QTUh5XMAc1/KgiNSZWwyulp57zsPrXi
         vdWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hNTm1OzW+wIMxya0eR8AK1iqMeCHqexcmEvSu7nlCOI=;
        b=UUo73TKMBGLmtNE5/ZSD/EAbimO1B3BIpDS5m3QOfyE0BKaT+JLW6saGJiLJuxD4YP
         agoJkiOqWhz8ZGW6+0p+nZwXr8ox2KJ59P6vaNFAvFq7SqV7pnox5n3cQEgOZQOACDcy
         Fx0Z3w+OBLkIl5upsjSqyB1/MoJQsAVElSJG/lh8s9x6m/Ezwz7fRD22x0BhUk7GWu2H
         ULKQp6xBl0n/uAYkQAljRcvZrwi3irAw/bhDT1t12MNCFAEVYXg0DC1p5tfD414hBQt1
         GxBsUpj8OT1DTiEYXW1QZdL8tCdKPmeYc6bQPhmWnF7i2g8j24c7yBjZOvSkoGW1RVG+
         eggA==
X-Gm-Message-State: AOAM532ADx/d+2byWJ62eb05g0kM/zvMstg0poGwB/bisGFRmLqPtBVU
        Cj8FPbnMcwODCD65+vk3JNzQ6JJyo/rrVEMKYb4=
X-Google-Smtp-Source: ABdhPJyScJzovZz5qBJKCIIr5LHMY6WEG9NGnXsgVyz5deAPZsN/Cc6yNciErzsZqHZ9auTeUwl/ig==
X-Received: by 2002:a63:6c6:: with SMTP id 189mr10631535pgg.133.1602437478954;
        Sun, 11 Oct 2020 10:31:18 -0700 (PDT)
Received: from localhost.localdomain ([49.207.200.2])
        by smtp.gmail.com with ESMTPSA id j23sm9103666pgm.76.2020.10.11.10.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 10:31:18 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     petkan@nucleusys.com, davem@davemloft.net, kuba@kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: [PATCH v2] net: usb: rtl8150: don't incorrectly assign random MAC addresses
Date:   Sun, 11 Oct 2020 23:00:30 +0530
Message-Id: <20201011173030.141582-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In set_ethernet_addr(), if get_registers() succeeds, the ethernet address
that was read must be copied over. Otherwise, a random ethernet address
must be assigned.

get_registers() returns 0 if successful, and negative error number
otherwise. However, in set_ethernet_addr(), this return value is
incorrectly checked.

Since this return value will never be equal to sizeof(node_id), a
random MAC address will always be generated and assigned to the
device; even in cases when get_registers() is successful.

Correctly modifying the condition that checks if get_registers() was
successful or not fixes this problem, and copies the ethernet address
appropriately.

Fixes: f45a4248ea4c ("net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails")
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
Changes in v2:
        * Fixed the format of the Fixes tag
        * Modified the commit message to better describe the issue being 
          fixed

+CCing Stephen and linux-next, since the commit fixed isn't in the networking
tree, but is present in linux-next.

 drivers/net/usb/rtl8150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index f020401adf04..bf8a60533f3e 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -261,7 +261,7 @@ static void set_ethernet_addr(rtl8150_t *dev)
 
 	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
 
-	if (ret == sizeof(node_id)) {
+	if (!ret) {
 		ether_addr_copy(dev->netdev->dev_addr, node_id);
 	} else {
 		eth_hw_addr_random(dev->netdev);
-- 
2.25.1

