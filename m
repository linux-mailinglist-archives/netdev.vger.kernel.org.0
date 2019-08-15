Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A18D8E4E7
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 08:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbfHOG2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 02:28:51 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34101 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbfHOG2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 02:28:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id b24so898271pfp.1
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 23:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rW27JgmRAd7uJ6fOqaefRHRk/SuuuN3zVWcMlhtpIEY=;
        b=J+LcPcJ6WrIBVt+bVSF7CQ/P/X9pqwvaIe/FMufZrm8bco0+2HzRRPIzEBa0v1M0D2
         hzP0ytkNJWstALpUdZtcFFsXNeV29z/uLqN04NzahU3zf5j77lkCKL2w8pPrXRGrjcOw
         fUURFvk1sfEcVyw6Y+VaEbPm8p75iBb4IImEFk48ciD1f6WUYqbOqcNzMuPz45R3s++c
         PtRtYcxYxJgFbV5/izSDF0AqRXMsRascXlAmYl+xxkeXwm0lHjqAMzj//a2OwH04HGRe
         AXFfiVeJk+YSyAxcLE5mZqDzpjrd9Pl6RLfHKfxJQzBpTNaYk6NrC9iaaJbhCZULBA3/
         k1dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rW27JgmRAd7uJ6fOqaefRHRk/SuuuN3zVWcMlhtpIEY=;
        b=kj9Hxc0tzGFprICdT9gI6WlWR9agW1Hexz8caUVsVXBAlXerKjSCRgoEFd9UbaBnBG
         1z1dI1q10iSrpPkGejJ5Z+IZdSNZK93Gtl8/23OJHUVYLnZvtbV3nE1UloSryOtHlvGh
         UzDpMoDoPQvysdAuhg5TuGrrzsARG6KYRLOvfvsIyBmpcAc/ZmD/FhJqwwg8CYjIwoit
         WK8fQnDksbTf8ShTGIepBYeBkSWch3Uh7Ak2M8rhxcfWCrR63xxtI1dy6QDjiFr1tUM9
         A0LAS+M+SRDOhHlb7Hypscg5S2sWH0dtxnS3u7Isrk7zNFATTyB/2OmC8B0UQTKKQIR1
         268Q==
X-Gm-Message-State: APjAAAWT9H/XIeyJXZTffBr+GCPWdp4KMLW683xalNhRWxaK5m+V+FAg
        gaLygAmtaHrJBXx1It5Fo3XHBj+E
X-Google-Smtp-Source: APXvYqw9hl782bd5l1XuXlL8K/+ZkC5zZFQmdc8YOXCZrJWAOpN9wqKYvzZV61W701bUOjqblFfAlw==
X-Received: by 2002:a63:e807:: with SMTP id s7mr2289922pgh.194.1565850530797;
        Wed, 14 Aug 2019 23:28:50 -0700 (PDT)
Received: from localhost.localdomain ([110.225.3.176])
        by smtp.gmail.com with ESMTPSA id dw7sm535629pjb.21.2019.08.14.23.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 23:28:50 -0700 (PDT)
From:   Nishka Dasgupta <nishkadg.linux@gmail.com>
To:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     Nishka Dasgupta <nishkadg.linux@gmail.com>
Subject: [PATCH] net: hns: hns_enet: Add of_node_put in hns_nic_dev_probe()
Date:   Thu, 15 Aug 2019 11:58:37 +0530
Message-Id: <20190815062837.6015-1-nishkadg.linux@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The local variable ae_node in function hns_nic_dev_probe takes the
return value of of_parse_phandle, which gets a node but does not put it.
This may cause a memory leak. Hence put ae_node after the last time it
is invoked.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 2235dd55fab2..b26e84929e1e 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -2309,6 +2309,7 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 			goto out_read_prop_fail;
 		}
 		priv->fwnode = &ae_node->fwnode;
+		of_node_put(ae_node);
 	} else if (is_acpi_node(dev->fwnode)) {
 		struct fwnode_reference_args args;
 
-- 
2.19.1

