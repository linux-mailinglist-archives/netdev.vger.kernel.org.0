Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651DA8CC01
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 08:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfHNGiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 02:38:54 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:38657 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfHNGiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 02:38:54 -0400
Received: by mail-yb1-f193.google.com with SMTP id j199so40810412ybg.5;
        Tue, 13 Aug 2019 23:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zC5nOG0/99YM0l9ci08akJ+NBkTP4tUrD3MLrU08kpw=;
        b=Os5sbqRrygIZmRsW8clcL0KiyGYMXeLrt5DmFahcg7oC7C67XzzaOdN0NvLrN1OYeh
         7Ug+G23dlLQA+EWoL6XYXm+6uvDdlHDgX6UgmpNCWYpQHfhypMYb6AyxekYoYwLgD6Wg
         FMY3wB9306SNxUcGZ6wUktSGf+oRSXLvB/A5TaDjRWiP2CyaW9vdetaHgI+hUixawL1D
         w2Ufu2HF8tifhpkn3UlhwtlOelwbOJBJ+ReC3E4wypXH6vptBQhJIO60uBqx19rqQqH7
         Lt7NTpYgwalADBK4JoD9Smo24ILWqUP6h7GLeNE36PSNF98lySzm/P3n64x+bPD1H0PD
         6dIw==
X-Gm-Message-State: APjAAAU9JYhB4Er54fOeM3vAiKAtc/X8sNGET83MOpz60gh8g/5xS6MP
        il7O9yIf36297epoIQcQbqg=
X-Google-Smtp-Source: APXvYqyByWpfdk/Iul0/yYFAFA2h8msozyN9NUx2GkwaDjdrm62GsVw5TeJDQ3Jf+9VpWTd8/7JEIA==
X-Received: by 2002:a25:7652:: with SMTP id r79mr4636899ybc.258.1565764733078;
        Tue, 13 Aug 2019 23:38:53 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id d69sm24643978ywa.29.2019.08.13.23.38.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Aug 2019 23:38:51 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Chris Lee <christopher.lee@cspi.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:MYRICOM MYRI-10G 10GbE DRIVER
        (MYRI10GE)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: myri10ge: fix memory leaks
Date:   Wed, 14 Aug 2019 01:38:39 -0500
Message-Id: <1565764719-6488-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In myri10ge_probe(), myri10ge_alloc_slices() is invoked to allocate slices
related structures. Later on, myri10ge_request_irq() is used to get an irq.
However, if this process fails, the allocated slices related structures are
not deallocated, leading to memory leaks. To fix this issue, revise the
target label of the goto statement to 'abort_with_slices'.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index d8b7fba..337b0cb 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3919,7 +3919,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * setup (if available). */
 	status = myri10ge_request_irq(mgp);
 	if (status != 0)
-		goto abort_with_firmware;
+		goto abort_with_slices;
 	myri10ge_free_irq(mgp);
 
 	/* Save configuration space to be restored if the
-- 
2.7.4

