Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95CAC12349
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfEBUYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:24:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37807 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbfEBUYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 16:24:44 -0400
Received: by mail-wm1-f66.google.com with SMTP id y5so4281660wma.2;
        Thu, 02 May 2019 13:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4ODP+XEFRjK001DSttsUwl/FSkMZTPwnjow6ojmj0+A=;
        b=naFWMFOCBajIQjr85sD6rQnspad0plTOIaijKaoxr/kP1mOyuUQa0/+dPBc3Crscdb
         1hx4Wf2ETcq97rRduFovqgcQMzUYINIbBmcNvdqN62xjD0kgH6ghf5rO5ynEzyKYpzE+
         oFaV9gUbkhascfI+QR4FYGjFqEJkUlIamJXP9M/8AmNj6qA8ihAn1F0LrRlq8Gs560ly
         LbSpaBUCxNwwncvXZgjAyXL/AzTVeROrk86juFZBeuODIubJUvTuyAAN1lFBQztU3k4V
         v9APwUyGuV5txNDTT9S8YELIvvqyGQJahTOtrvCS+9iuxNuNgZuhWilufrHmrotXzmLI
         GO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4ODP+XEFRjK001DSttsUwl/FSkMZTPwnjow6ojmj0+A=;
        b=ADOIw20wGf+51Emb9/potp8lxdLcoAgYYkWXON0JY0/h9oEBDfuVgWDLV4JaZmrH+R
         1O7DrUkRkVa2QAfYhwAgeeUKzQsykvsHQyNbPZlJl1iuMxK5jGoTzTNpZGNM/vdGeh7d
         H0rXaXRGDfQMNgrfI6D8hh9BPHA5cFka+quTTt/1c1/CZRXGq1PaKMMwtmf+T+GK5c+C
         NnsOGqQqKra6vnWoivxIOwy4v9f9yaDqYljm/Ouomu3sEWTpcsrJ7tGx5Miz7k5maB3T
         G/XpXGhewv0zDJsY4twTJa6Qk5E65YgGesFkeOW71XJyCdbBWBgTaTddQgNvsbFi3xbQ
         /GRQ==
X-Gm-Message-State: APjAAAVhTxEOaOTFssinZnqzBQ8xnYHnBcbOCR0D3ojOepZZt7sXcRxW
        xCSPUItoxxNapkTRNdYJO+QBl/ZAuOI=
X-Google-Smtp-Source: APXvYqyvAWckmgV9jU0i+Jx/gV2zwzfPiPdrj59p72OdV62sxDxS5zZtXZIrB77S/d59iEHDiLKIfg==
X-Received: by 2002:a1c:a914:: with SMTP id s20mr3744796wme.55.1556828683004;
        Thu, 02 May 2019 13:24:43 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s124sm217655wmf.42.2019.05.02.13.24.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 13:24:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v5 net-next 05/12] ether: Add dedicated Ethertype for pseudo-802.1Q DSA tagging
Date:   Thu,  2 May 2019 23:23:33 +0300
Message-Id: <20190502202340.21054-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190502202340.21054-1-olteanv@gmail.com>
References: <20190502202340.21054-1-olteanv@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v5:
None.

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

