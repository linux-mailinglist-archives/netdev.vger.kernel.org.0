Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C007A86EDA
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404985AbfHIAaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:30:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45018 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHIAaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:30:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so44929529pgl.11
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 17:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9EsoBFcZX3rcBpwVrej/Ld7CiMRGTrTVP3yIlKkfAhA=;
        b=cbxvIdPKeqPGz3qQakuyoDNV3FuyF4ZWcBcR6PUZZVvHMMWPjESxv5YcBCsFDo1vDn
         tYNABcEKBfGCAzEKkSTL6XSZe7/qMPmw2QaZhrcNLyVm/4KeHOiMR5CFCoKCNsBBKY98
         UoYYjolzSXWgZfwwmsvY3u5zMzySyV4GaXrLZOyz3OCOCyrXSEWAfioXOUKguTxiXMy+
         eU6oinvvpIT4DS1AHrHTwTlXgWb0JyQLJYYFCA/x+0zoOImeDpo+SYvl4EwukmbPsVMh
         yz++ybHQh7xueaT77eCCUQe66qB7Yy9DRrMDxQFxl7newC0FOM/Bh7SAX10B0UnYein2
         MH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9EsoBFcZX3rcBpwVrej/Ld7CiMRGTrTVP3yIlKkfAhA=;
        b=mta/SWep8NSRnZDQphwNh/oeLOhsD4Pvn2bhyFfwD+IxyCTGREp5PQrEjSPHK+tJ10
         v4Ru00zOqrPN69Q/nxwjuvIqwDGqIGtBBJb5eXuSafBMd1t4mOfzKaSid4ILXt14vCOP
         ZCPaIHWYKK7usaYRtv8VlEuWM6fDDl7tLHOKyDmnbDbqMzHelT6dCqlJi7Uqsd5znPBW
         yxGCidWVFJyVKulHrUZRJrNERwQ0J1tM+9a8yqGeI4wY76Kp0ztskRGjHeE9hN+ox/5Z
         5hfib2AmGUR92ydwEZ9Z/g9V3Yzkh2Sfxs6n7D/tpn875mo9pQL9q/SUJoBB/6BObLxO
         0F4Q==
X-Gm-Message-State: APjAAAVXQyFd/gthqRKdKsqi3gc1ZPSoxqhdMm6F2QWenmR7PfXWKukI
        BYN9zUyYWZN4xsCDBSqlbuSVb9+sUT+s/g==
X-Google-Smtp-Source: APXvYqy7pcKjAF0jXWXtbCIzb3uAPdD6DpqYZquXk/D6AaCAZ7OZijzwsl9jQrf3yeIMozzDZhNIyQ==
X-Received: by 2002:a65:6904:: with SMTP id s4mr15028494pgq.33.1565310602099;
        Thu, 08 Aug 2019 17:30:02 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 196sm103991808pfy.167.2019.08.08.17.29.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 17:30:01 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Joe Perches <joe@perches.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 2/2] ibmveth: use netdev_err_ratelimited when set_multicast_list
Date:   Fri,  9 Aug 2019 08:29:41 +0800
Message-Id: <20190809002941.15341-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190809002941.15341-1-liuhangbin@gmail.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
 <20190809002941.15341-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When add lots of (e.g. add 3000) memberships in one multicast group on
ibmveth, the following error message flushes our console log file

8507    [  901.478251] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
...
1718386 [ 5636.808658] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table

We got 1.5 million lines of messages in 1.3h. Let's replace netdev_err() by
netdev_err_ratelimited() to avoid this issue.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index d654c234aaf7..138523ee5e84 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1446,9 +1446,8 @@ static void ibmveth_set_multicast_list(struct net_device *netdev)
 						   IbmVethMcastAddFilter,
 						   mcast_addr);
 			if (lpar_rc != H_SUCCESS) {
-				netdev_err(netdev, "h_multicast_ctrl rc=%ld "
-					   "when adding an entry to the filter "
-					   "table\n", lpar_rc);
+				netdev_err_ratelimited(netdev, "h_multicast_ctrl rc=%ld when adding an entry to the filter table\n",
+						       lpar_rc);
 			}
 		}
 
-- 
2.19.2

