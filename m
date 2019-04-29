Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356BCDA18
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 02:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfD2ASK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Apr 2019 20:18:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55127 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfD2ASI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Apr 2019 20:18:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id c1so11497702wml.4;
        Sun, 28 Apr 2019 17:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xi/bqu+5Yj87FAza0D0zWehDcDcznhOhDhCyw5UfAcM=;
        b=JRm771NI98FkW4KICvl5H+ru9SRLqSjtBvFZgwIn4oSD8t0XWEXwaARs+8Ig2xLgEI
         K9YORU+p2rAbor0U6vI5uLKlAugD/0kSXAbU8nWmp8ygkYfGqiDB/NfngxaKwZSDbJSj
         qxlkNhdACnkyjAwlcGVbsohkqfwln8PqFrmB+sYrHD9CPeHoUyCAVseNzBWUK/lafCv0
         FldVnkXEkO81YZeh7uRfc++DchrqAnZlJmW9wbcJbiIakz/nIXPWAFRpWYN7bvhMceub
         md65w3Ho4GJTOTo3efhUkgAujf50+WbWogdIixCVWoP3nu1WfX1yR/92i9uRQ1gXOeX8
         b6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xi/bqu+5Yj87FAza0D0zWehDcDcznhOhDhCyw5UfAcM=;
        b=gxxsfTT5M7MmYVoIsCNv0ZKSkHrENzmhrJJGnFJbV1EoxnZe9puqGHQUvfRY4v+58K
         PtEUbSR73pZHHE3qyMX8oVqW74HU7NeEgoj7TA9VSL7pZYrZfgWvS01H8CFzY4nvMGVy
         pk+3gZBWkmv7LytdK/v3+A0iK+Wcyf02FoKHbVt5g9JaQpC0/8mmlE2FQTdhIt+JYFVW
         vLMvQX7shuxY0Nvl+IUakMphWS+Ji6s8yhOHIl6DnHMTUQ2aJ9+TyDgQmcCCrbw2Gbq9
         plBAdxCDbdIq5C6w9RDM+OIgivSQ0lJM4E+p4C7pFU6IOGSGQpbOx6+36caI9S3X2K75
         XMoQ==
X-Gm-Message-State: APjAAAWMb2TVqvedVtXVrqCfsmDLUvJQ2WYMECCWWRccP8vay7BjI/+M
        FpYy25IsctUiYmZwPin3p/c=
X-Google-Smtp-Source: APXvYqwehGA+MF4l1p9Lf1Fa8NxbRxxm9qQhqsraNfVZ85lrkoMTpOgFCDY3qQTg4P3aSIKJ+z1EPA==
X-Received: by 2002:a7b:c3da:: with SMTP id t26mr5724574wmj.40.1556497087036;
        Sun, 28 Apr 2019 17:18:07 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id h16sm5098030wrb.31.2019.04.28.17.18.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 17:18:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 05/12] ether: Add dedicated Ethertype for pseudo-802.1Q DSA tagging
Date:   Mon, 29 Apr 2019 03:16:59 +0300
Message-Id: <20190429001706.7449-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190429001706.7449-1-olteanv@gmail.com>
References: <20190429001706.7449-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two possible utilizations so far:

- Switch devices that don't support a native insertion/extraction header
  on the CPU port may still enjoy the benefits of port isolation with a
  custom VLAN tag.

  For this, they need to have a customizable TPID in hardware and a new
  Ethertype to distinguish between real 802.1Q traffic and the private
  tags used for port separation.

- Switches that don't support the deactivation of VLAN awareness, but
  still want to have a mode in which they accept all traffic, including
  frames that are tagged with a VLAN not configured on their ports, may
  use this as a fake to trick the hardware into thinking that the TPID
  for VLAN is something other than 0x8100.

What follows after the ETH_P_DSA_8021Q EtherType is a regular VLAN
header (TCI), however there is no other EtherType that can be used for
this purpose and doesn't already have a well-defined meaning.
ETH_P_8021AD, ETH_P_QINQ1, ETH_P_QINQ2 and ETH_P_QINQ3 expect that
another follow-up VLAN tag is present, which is not the case here.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v4:
Patch was reintroduced at Andrew's request.

Changes in v3:
Patch was removed.

Changes in v2:
Patch is new.

 include/uapi/linux/if_ether.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 3a45b4ad71a3..3158ba672b72 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -109,6 +109,7 @@
 #define ETH_P_QINQ2	0x9200		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_QINQ3	0x9300		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_EDSA	0xDADA		/* Ethertype DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_DSA_8021Q	0xDADB		/* Fake VLAN Header for DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_IFE	0xED3E		/* ForCES inter-FE LFB type */
 #define ETH_P_AF_IUCV   0xFBFB		/* IBM af_iucv [ NOT AN OFFICIALLY REGISTERED ID ] */
 
-- 
2.17.1

