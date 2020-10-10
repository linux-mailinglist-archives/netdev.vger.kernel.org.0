Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3F289EBA
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 08:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgJJGpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 02:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJJGpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 02:45:14 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4920AC0613CF;
        Fri,  9 Oct 2020 23:45:14 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id e10so8763002pfj.1;
        Fri, 09 Oct 2020 23:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xfSdIY+23CT3/wQXlBcdzzU4V4XTk+/nKDZH0PbiNHM=;
        b=q2fd0Idi2WuzJrVO09Ukmf7rseVtkmEVEgXkG/5RZYMvMUdy9XwUbZVI7rjVYaxQQ5
         u8Oy4QNnInXLUfNGlez7eCt2NuZUqDnnIXj26uYUNfEKmdaOLOQJHNPyIkjwSpwM/+yg
         vVXkTWeABrrr6AGcYZJ6KE4/oZhkHp5akR1EkM6QpMW6dWvQzx84xAlTvs7oi+cectqI
         fXU691erxXgiZ6dIeM8fTqagH5hlZDLyX3V+WWGgl2f0pNB4S08fXbLVbxUoWjWAZyJx
         tI6PN7UYd1Cr3ttmuxlMPg3eaFrpBPyzUEKKn2LWILPBAN/YqEGUQ1yG2DECQ4yJfUJp
         +F/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xfSdIY+23CT3/wQXlBcdzzU4V4XTk+/nKDZH0PbiNHM=;
        b=Xdr3Py6EuSezVcnbQ6D2ALMX9XfVlW3MYZwhCF4LNdlhnqGzdjP1WwUmrd455MljV6
         ylrrFh0QvMLqmLXq3nknvsimBzSi574ywluLHdWUqUujQroAo6FKLNE9tx7q2taJgBdQ
         1dEfEzb14vkAaJIyafpj4ZsN+CbRa646s+RdWEhDGstQq4GIJQAANNWCKAOZzkS7XEJW
         isu3TYRSsPg8jRDZeBUg2FxoyAso+18C8p0kO4ZImcSaO0sQCFU0EDaALsuXE+S8JJBM
         jCgBJvD8uD0xWohzP8qsRazCC2fdCfcjFfa9yLuFrY1D7Pe8jVqswuPPiEsBZ0rvlztY
         5WBA==
X-Gm-Message-State: AOAM531CwDzLAw0zQbJALRPFrKLlNL4ZK/OddYgbnfGVIvJCYzFAmIcG
        +wFhd60sXb7hwb647JQyQYw=
X-Google-Smtp-Source: ABdhPJxQ9ckge6Dkw/bNv402x14aKWItjXVRRQ/zAhILTY8a8R+FJKqwAPERSOX/98H89BtWIK6UpA==
X-Received: by 2002:a62:105:0:b029:155:c7c0:3a81 with SMTP id 5-20020a6201050000b0290155c7c03a81mr634597pfb.34.1602312313405;
        Fri, 09 Oct 2020 23:45:13 -0700 (PDT)
Received: from localhost.localdomain ([49.207.200.2])
        by smtp.gmail.com with ESMTPSA id e2sm14219800pjw.13.2020.10.09.23.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 23:45:12 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: rtl8150: don't incorrectly assign random MAC addresses
Date:   Sat, 10 Oct 2020 12:14:59 +0530
Message-Id: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_registers() directly returns the return value of
usb_control_msg_recv() - 0 if successful, and negative error number 
otherwise.
However, in set_ethernet_addr(), this return value is incorrectly 
checked.

Since this return value will never be equal to sizeof(node_id), a 
random MAC address will always be generated and assigned to the 
device; even in cases when get_registers() is successful.

Correctly modifying the condition that checks if get_registers() was 
successful or not fixes this problem, and copies the ethernet address
appropriately.

Fixes: f45a4248ea4c ("set random MAC address when set_ethernet_addr() fails")
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
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

