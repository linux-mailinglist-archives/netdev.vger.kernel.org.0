Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFF2171717
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgB0MZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:25:36 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52491 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbgB0MZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:25:35 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep11so1073730pjb.2
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 04:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XTyZnf00Y4OLat+MUaa4NzF+hyDpLr8/FsmeeQd9ntU=;
        b=ijrG8zsYYesF3dN1ghLYxiblvIs+ftDnTJmkrvcWHIVT/xeGTUpqsvLXt8qlawSxRr
         zq6rG89Hw+uPyJP+QMnD7Z4Y/qQdvR852a3le7ctMXQk8AUzl3gGgp7syuaDqZmnWJVp
         pekRD/uoxPg5FrnyGjYmXkCxaQtUEsn8wkd6yM25SJvMLOCnGWsWBCjQDFYxmZ8ID/kr
         JlNkeoiWNS+8erPsKGr74tKkj3rl29y5USfqLuEZ1LbcLRZU0P6Ylxz9y/45iMZapIjG
         dAM6dO3KeC/qG6bzd1Gr8JilVkseE/5XpcW5wAoh8Pagljqqgd9KFPVJUiKxIT4BP9HD
         /pfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XTyZnf00Y4OLat+MUaa4NzF+hyDpLr8/FsmeeQd9ntU=;
        b=IYzY/goU7KB4k6fw/EvDoc05JckYsT17/XQ5uFB8bk+/+7NwtRD/5eQl8BnrxTrr+s
         y3lutN46Cn153zkE35o1oFgHiqPs4XfEyiF9hrR3iqkArj8/tyyOQsc+Obe/aeF6yu7G
         lrAkmwOZ6qcyLWwBlDKZd3Os2cu4ty9A/Vobt5hxagQ1aUwUjWWM7Xr167YHJwHQEAJk
         vYEM2goY7quHTg35u6hgm9zvjN890k4xUFrNENxIYIpNel/EgBGOrg7g9HJdXvqFuiVs
         iYYXjGRj9jVDK/bsj7PuG4ku0pm1QzaIocoijFv3bEq8ZOXjv26Xeh1n3B10X2RwiPJh
         4jDA==
X-Gm-Message-State: APjAAAWfZK7HMBR8zra8eKj1kpw92MdASMo0qvzSes6OTOzvOe6CwaFI
        pNbn5sUAbzpuHeSm51VnYKk=
X-Google-Smtp-Source: APXvYqyDcR0iPYXgnCcuekl4RE/vp0N2SO/se+Z0MstdNo9vgTPGXvTrRkGAgN9e6Thirfc6U1EOfQ==
X-Received: by 2002:a17:90a:e981:: with SMTP id v1mr4734942pjy.131.1582806333953;
        Thu, 27 Feb 2020 04:25:33 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id c19sm7639650pfc.144.2020.02.27.04.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 04:25:32 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 5/8] net: rmnet: do not allow to change mux id if mux id is duplicated
Date:   Thu, 27 Feb 2020 12:25:19 +0000
Message-Id: <20200227122519.19341-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Basically, duplicate mux id isn't be allowed.
So, the creation of rmnet will be failed if there is duplicate mux id
is existing.
But, changelink routine doesn't check duplicate mux id.

Test commands:
    modprobe rmnet
    ip link add dummy0 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link add rmnet1 link dummy0 type rmnet mux_id 2
    ip link set rmnet1 type rmnet mux_id 1

Fixes: 23790ef12082 ("net: qualcomm: rmnet: Allow to configure flags for existing devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2:
  - update commit log.

 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 0ad64aa66592..3c0e6d24d083 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -306,6 +306,10 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 
 	if (data[IFLA_RMNET_MUX_ID]) {
 		mux_id = nla_get_u16(data[IFLA_RMNET_MUX_ID]);
+		if (rmnet_get_endpoint(port, mux_id)) {
+			NL_SET_ERR_MSG_MOD(extack, "MUX ID already exists");
+			return -EINVAL;
+		}
 		ep = rmnet_get_endpoint(port, priv->mux_id);
 		if (!ep)
 			return -ENODEV;
-- 
2.17.1

