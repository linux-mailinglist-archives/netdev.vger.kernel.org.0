Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100DA283689
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 15:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgJENaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 09:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJENaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 09:30:23 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544B6C0613CE;
        Mon,  5 Oct 2020 06:30:23 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n14so6904827pff.6;
        Mon, 05 Oct 2020 06:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KiVd1CB6lv+K5WRh3wsB+klp28Y/L0HyIFaj1iXVxLg=;
        b=LiUPfJAYlPG24Mmd5k3kdAcFh4fpsIM6iQfhPWi/GlYdSZy5/Y4NYgjBGt2cWC63y0
         PDxPAR8L1oTJoFcesFGZLGZqlLto66HKZI4ehZsOp+VRkpzuYs0skwwrEunRomaR5CCi
         ATI5+0Jucupp3yVEMFZcUHP3sY6agPxRApErUiuLyaa6D9cu6GCcuhawlrK26U+y9iYi
         CJmxovGG7JrVxpRJ6pdQapAALr9QIHtQmVQFWmQhPK9A+uGPTX2Vc47snJPzEe3LYpfd
         CuMRzPTNW1qOKEYLQCzQgZv7tjNKKNRtdjntyBrip+MiAEbnxi37FYLVHU7onUjCJRYp
         dQrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KiVd1CB6lv+K5WRh3wsB+klp28Y/L0HyIFaj1iXVxLg=;
        b=rhBmjkhQ7JdBUv7W5DMRnFkFcvlZrwBRGbBsRTlIjjQgJFoMDmUrsgFe6JfebkG2hJ
         OBZrxoTRnbkDeKXtyTh+3zcblQJA44zzEw6LeMVi+TcEjwEub1CH4q6g1UDqLUWqejLp
         4Ayw0wycmohogG7hpCA3OlyhQKt9n3IpKozPz1ZR2BCHeyqyujA7FfAu95rET5nIaRDP
         nUiW/9HRKHIgsTpvyjRPp1Yj/xZLZWkQDq5P4/AiCZYcVm5RJeYTK6RJhki5vDbl4fW9
         51Mv+bu0Q68jZl7g0wDiWx8O9Ehq0MwTYWQBF+Spc0IyuOSOcMk1aD5HkcFbelDnKtZM
         qBHQ==
X-Gm-Message-State: AOAM531Mdcqux07LwTuVi19ACFZfv8ngIlRHZPzH7TSTs2pazjJxfKlE
        1qisVDa9sRe9K01EmnA0jzhkbIPEumwfqP5b/8I=
X-Google-Smtp-Source: ABdhPJx42KObFaC35cretEvYRkAKYv1Q6kZMzxHGXyv3iTLzMgdH/w8QfHF+vIObQGxlrDZlOylVfQ==
X-Received: by 2002:a63:5858:: with SMTP id i24mr14417015pgm.449.1601904622430;
        Mon, 05 Oct 2020 06:30:22 -0700 (PDT)
Received: from localhost.localdomain ([49.207.199.235])
        by smtp.gmail.com with ESMTPSA id k7sm10597169pjs.9.2020.10.05.06.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 06:30:21 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org, joe@perches.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails
Date:   Mon,  5 Oct 2020 18:59:58 +0530
Message-Id: <20201005132958.5712-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When get_registers() fails in set_ethernet_addr(),the uninitialized
value of node_id gets copied over as the address.
So, check the return value of get_registers().

If get_registers() executed successfully (i.e., it returns
sizeof(node_id)), copy over the MAC address using ether_addr_copy()
(instead of using memcpy()).

Else, if get_registers() failed instead, a randomly generated MAC
address is set as the MAC address instead.

Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Acked-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
Changes in v4:
	* Use netdev_notice() instead of dev_warn() and update the 
	  logged message to show the new random MAC as well 
	  (Suggested by Joe Perches <joe@perches.com>)
	* Convert set_ethernet_addr()'s return type back to void.
	  Since we're not treating get_registers() (and thus 
	  set_ethernet_addr()) failing as an erroneous condition,
	  we can perform the error handling (setting a random
	  ethernet address) that was being done in v3 within 
	  set_ethernet_addr() itself.
	  (Suggested by Petko Manolov <petkan@nucleusys.com>)

Changes in v3:
	* Set a random MAC address to the device rather than making
	  the device not work at all in the even set_ethernet_addr()
	  fails. (Suggested by David Miller <davem@davemloft.net>)
	* Update set_ethernet_addr() to use ether_addr_copy() to copy 
	  the MAC Address (instead of using memcpy() for that same).
	  (Suggested by Joe Perches <joe@perches.com>)


Changes in v2:
	* Modified condition checking get_registers()'s return value to 
		ret == sizeof(node_id)
	  for stricter checking in compliance with the new 
	  usb_control_msg_recv() API 
	  (Suggested by Petko Manolov <petkan@nucleusys.com>)
	* Added Acked-by: Petko Manolov

 drivers/net/usb/rtl8150.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 733f120c852b..9d079dc2a535 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -274,12 +274,20 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
 		return 1;
 }
 
-static inline void set_ethernet_addr(rtl8150_t * dev)
+static void set_ethernet_addr(rtl8150_t *dev)
 {
-	u8 node_id[6];
+	u8 node_id[ETH_ALEN];
+	int ret;
+
+	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
 
-	get_registers(dev, IDR, sizeof(node_id), node_id);
-	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
+	if (ret == sizeof(node_id)) {
+		ether_addr_copy(dev->netdev->dev_addr, node_id);
+	} else {
+		eth_hw_addr_random(dev->netdev);
+		netdev_notice(dev->netdev, "Assigned a random MAC address: %pM\n",
+			      dev->netdev->dev_addr);
+	}
 }
 
 static int rtl8150_set_mac_address(struct net_device *netdev, void *p)
-- 
2.25.1

