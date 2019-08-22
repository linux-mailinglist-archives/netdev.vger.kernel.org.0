Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF809A0E9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392916AbfHVUOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:14:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36366 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392892AbfHVUN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:13:58 -0400
Received: by mail-qk1-f194.google.com with SMTP id d23so6340721qko.3
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 13:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDi41gz+aqENpslRbtWqedS8nPsUGbBbGMSjytNOFYk=;
        b=jQElTt28bTADrJvUXR69QnZSkmE3xFf4/JnJmzZZRM7URz3anhB/zRfwIawCevNK8B
         2SMRWrO6wQmD0mRIEtxO9eoTc7uSdVMkTtQCVlG5KSqoUwqkNoPbCOZVKeQomOGvaM8V
         G7PhqFGooDZSWcTU5r3ZeryU0itZHK/z/z/FxYN13Ai/zwzyoHfhKnUcsR32Hg021LRn
         z+4e53fM2v2PyYyVEAlV5rGyTB5t02+3a8ebBuDcsIVW1kQeqfM0AmhYUSGIY3Xqt7NW
         Vs23XmDUt6JAW6/xz7266BTcr+l8njFZML3f7Q6vPQZCRzI+gWfIBVWDmqOq2zjx+8dK
         dJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDi41gz+aqENpslRbtWqedS8nPsUGbBbGMSjytNOFYk=;
        b=iJ++mBdzDeS/NYNOv80jjA4hyHj3wS3Lo6OZTn+ZSTq2U534umPRWUinu8b4Pz8bMY
         AiBoQTVO5N+1kMLyG+FvZT2vjJvwahxu9VJN4ymoCx6KpV4MKvYJHx1dIUAeDcfjzGrb
         4mLSjWSJmF9VoAahLs2xLonGCt9gEC2viY25MBeqbC+GnSHqOARwgMj1AGO/sUtct7uu
         B1hxyjgKLYPNzkgixYDE91p9vatsvgqtK5Ub4i9Dnxr3oulRxfLjSItjmML7MPQiOWje
         JVniMm/buQWLzEwkw/qjq/Y7VPnJxC8Se/tccovm0jO+15DNEL5tWkMHlGDMQSDQvHv0
         Aavg==
X-Gm-Message-State: APjAAAVkaNkL6XtU7gzxONhh258Usd1t63/InrHcq8PccEdvO8JViDoL
        tYxs6CQRO9UfwO07xWE2qN35M002
X-Google-Smtp-Source: APXvYqzrWMHNvuuPhNlIpMnoLiDv+XJq/7jjns1yJZ+oFZQqtPfE/9iC8ydiIfVw00T4KwlHQ8v3GQ==
X-Received: by 2002:a37:e306:: with SMTP id y6mr885753qki.174.1566504837366;
        Thu, 22 Aug 2019 13:13:57 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q42sm336131qtc.52.2019.08.22.13.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 13:13:56 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 6/6] net: dsa: clear VLAN flags for CPU port
Date:   Thu, 22 Aug 2019 16:13:23 -0400
Message-Id: <20190822201323.1292-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822201323.1292-1-vivien.didelot@gmail.com>
References: <20190822201323.1292-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the bridge offloads a VLAN on a slave port, we also need to
program its dedicated CPU port as a member of the VLAN.

Drivers may handle the CPU port's membership as they want. For example,
Marvell as a special "Unmodified" mode to pass frames as is through
such ports.

Even though DSA expects the drivers to handle the CPU port membership,
they are unlikely to program such VLANs untagged, and certainly not as
PVID. This patch clears the VLAN flags before programming the CPU port.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/slave.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8267c156a51a..48df48f76c67 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -332,6 +332,12 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	if (err)
 		return err;
 
+	/* We need the dedicated CPU port to be a member of the VLAN as well.
+	 * Even though drivers often handle CPU membership in special ways,
+	 * CPU ports are likely to be tagged, so clear the VLAN flags.
+	 */
+	vlan.flags = 0;
+
 	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
 	if (err)
 		return err;
-- 
2.23.0

