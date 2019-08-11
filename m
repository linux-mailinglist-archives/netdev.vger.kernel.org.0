Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D8489386
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 22:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbfHKUH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 16:07:56 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35369 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfHKUH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 16:07:56 -0400
Received: by mail-yw1-f66.google.com with SMTP id g19so37417940ywe.2;
        Sun, 11 Aug 2019 13:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I/wDFVoI+mYQ74OtLuR5i4v0k0nbe35K0FGp9EAyx0w=;
        b=QNTQr+VwFl2Ybq+yC/8PuJKkQQABJ4CWTVef1WvyNJBX87PVz2WeEZCQhGDod1M/qe
         JAG5soqsqjUTs3m93pQy5pbfL/TDz9CxSmk7wj6VfiXiYLOwZU1FIa7T0Ym0XIliTBb6
         cLPoHbsMLHj7NaGSQ6n3ERG0vuZqWvrbcmkH4h4IH5eHT+13f7HRg9+ZZpnP6Mx8yrsH
         yucSSQftFW+UnWDpgupONiQAFa6C0gOcZNmCiDkE2y7c5yoTuxf75G/QOBRy+wpMWbr6
         sXm2Cn3TkEWIP5hnIFOPQuNiL737c7ogOSPDgXzrcj8k46Z9FMG7Gl03duHO3VUudMHt
         5ACA==
X-Gm-Message-State: APjAAAWKmwGajcHCKhuMbTApIJZw6UMoxaHNMVB+g94OVpgCBoYMOpeZ
        Zod6rkVQztybK7X61McB6BI=
X-Google-Smtp-Source: APXvYqyoSDYPWu4RUOvnDARGMo8pOuQZ3RGQOV1HGXtNwNsBcsmUEeugZgXKGibzzlthU+3xSqElvw==
X-Received: by 2002:a0d:f0c7:: with SMTP id z190mr2409714ywe.317.1565554074798;
        Sun, 11 Aug 2019 13:07:54 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id x138sm23418950ywg.4.2019.08.11.13.07.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 11 Aug 2019 13:07:54 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: ixgbe: fix memory leaks
Date:   Sun, 11 Aug 2019 15:07:47 -0500
Message-Id: <1565554067-4994-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ixgbe_configure_clsu32(), 'jump', 'input', and 'mask' are allocated
through kzalloc() respectively in a for loop body. Then,
ixgbe_clsu32_build_input() is invoked to build the input. If this process
fails, next iteration of the for loop will be executed. However, the
allocated 'jump', 'input', and 'mask' are not deallocated on this execution
path, leading to memory leaks.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cbaf712..6b7ea87 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9490,6 +9490,10 @@ static int ixgbe_configure_clsu32(struct ixgbe_adapter *adapter,
 				jump->mat = nexthdr[i].jump;
 				adapter->jump_tables[link_uhtid] = jump;
 				break;
+			} else {
+				kfree(mask);
+				kfree(input);
+				kfree(jump);
 			}
 		}
 		return 0;
-- 
2.7.4

