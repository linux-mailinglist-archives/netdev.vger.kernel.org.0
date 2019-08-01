Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EABCD7D82D
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 11:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbfHAJED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 05:04:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34847 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730567AbfHAJED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 05:04:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id s1so27500189pgr.2
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 02:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HlVpE3JrUPgt5bwXt1zctS/JyyAdQ6iVTMPgL+U1A68=;
        b=rj9gdite46Ds2xIDExQzcVm5w3jgDsTXHAowLfVHxE+rUN+Wy0n+14OrFwivxUKvj+
         HN+0FuUv99H+zDCdZ/NzaHKFBLwaN3iwxzjse2b1yLO0J62CNL8aEtWXBcxeaUc9qwsh
         NQn2KvIvDzYp8yIRCSygmEmBHuFwpK1Zm54lg384Elu7CKAHSZ1cbtNW2v97EGPLZqNQ
         GSpBBuFGFtKmb5AWPgaqPd0Ce8PplPnP5M2HLM6QPfaA0Y9Vcsf0ljzQpigdRezUx/nx
         RxfNliKM2bblNNBee6qkJ9GVuEFLfWb++l8ngfTZ4AExALR2ubFUNrVqVjv/FtqXerc/
         875A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HlVpE3JrUPgt5bwXt1zctS/JyyAdQ6iVTMPgL+U1A68=;
        b=QALEuHPyMZhZPE7aIRHPnj+xt+u6ro7asu19641rSegMjM1TspN2bS5xkZhIVYKhzH
         j/TzSoyGVGuWMYRBktwiKsES2gJ2k9snwq7MdaT7jVj6fFsSRzeH6+nuOkr/4wQpr9AA
         LORQtpt7YP5wmw9pA4yOJEoSmmYpVLLJnks/lXqMofHAjWCdKAKwsh4cCfmI7hLHiKft
         HMUcZtlCqZW+iXmalm7DgbN9Gjl1TjmDbaHdF2Kzthi+ISjdHEo0OTIHb2mBS+r2U7A3
         bMvJdm1lSPjM98/QOaJ1cHGMDHIAI5PPikkfcqE+kq9zycVNSEpmzKOUJQfRMWO+xFLz
         dIBQ==
X-Gm-Message-State: APjAAAVvAZH5DTZoN1VshId/SkAtgZQC6eUSnZ+m53FCqemOb9x+ZEuk
        t4A+91A79LTeCMZ7Sx3JXzJfW5nTTV/8kw==
X-Google-Smtp-Source: APXvYqwkMNjzjbpYJh5IknyStm2IN3nFzBqSrV5pcZI2Cn4Je75TseUPlWSv8WukDPtpehO5317Kcg==
X-Received: by 2002:a17:90a:3ac2:: with SMTP id b60mr7533869pjc.74.1564650242313;
        Thu, 01 Aug 2019 02:04:02 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j128sm74951333pfg.28.2019.08.01.02.04.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 02:04:01 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] ibmveth: use net_err_ratelimited when set_multicast_list
Date:   Thu,  1 Aug 2019 17:03:47 +0800
Message-Id: <20190801090347.8258-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting lots of multicast list on ibmveth, e.g. add 3000 membership on a
multicast group, the following error message flushes our log file

8507    [  901.478251] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table
...
1718386 [ 5636.808658] ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table

We got 1.5 million lines of messages in 1.3h. Let's replace netdev_err() by
net_err_ratelimited() to avoid this issue. I don't use netdev_err_once() in
case h_multicast_ctrl() return different lpar_rc types.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/ethernet/ibm/ibmveth.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index d654c234aaf7..3b9406a4ca92 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1446,9 +1446,11 @@ static void ibmveth_set_multicast_list(struct net_device *netdev)
 						   IbmVethMcastAddFilter,
 						   mcast_addr);
 			if (lpar_rc != H_SUCCESS) {
-				netdev_err(netdev, "h_multicast_ctrl rc=%ld "
-					   "when adding an entry to the filter "
-					   "table\n", lpar_rc);
+				net_err_ratelimited("%s %s%s: h_multicast_ctrl rc=%ld when adding an entry to the filter table\n",
+						    ibmveth_driver_name,
+						    netdev_name(netdev),
+						    netdev_reg_state(netdev),
+						    lpar_rc);
 			}
 		}
 
-- 
2.19.2

