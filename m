Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809A628A3A7
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390207AbgJJW4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgJJVJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 17:09:42 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDB0C0613D0;
        Sat, 10 Oct 2020 14:09:42 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a200so9948555pfa.10;
        Sat, 10 Oct 2020 14:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ec9PVwrrG4wt31+D6ewlM+AL+7A9A3Y/2wI9lVyXaLI=;
        b=jzBLA5pYP9ANRRty0Q2tPknfb4dcy7phjo7KoXG1ZJJFd45CUUNcxRmYFUz1pLnCfV
         6sKUhukAL5MToZ7+aE4myHQkmSGoZ6SJAtpyeMu9Gjqjsa1Cmnk50/yVca6AqKZR3NVx
         e9jY7mL8fjZATbr+aG0jeYpsQFsVFELgN/h8TeSkpSy6yD3J1NisKVwagSNO5i6KTwSF
         7wohsTYBjgoYzb/nr3RJxZKmu7Rgv//KLEa/Z6hJtyQYP0JSQTyNpdYAbkSmQ3Y92X05
         RXju+uBSSWrSsVqxepYTniHCyuQQh9an4He6FPTXn+2/YZ7SZTc7SSEitqJMlSheUwtE
         eQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ec9PVwrrG4wt31+D6ewlM+AL+7A9A3Y/2wI9lVyXaLI=;
        b=He1JTsm6nqeNImxuiIKtXFtcY3twZsHEE1YIaZh+Js4wYbaYaU0mfudJl44BsLBjjt
         vw031Wa4Kulh3OfkLnsm4nh4HFS6/dRdz9QPVibhsrUD4kefMteCs/5hbsR2DphHQR7x
         GFwWFEjhKO3Lx21SPSY6D6MhnwHfXL2HzAuZtcQMi3l/nsHUQ7NdhPz4dtQdHIOZ/yFU
         agYMsyRljF0LrHaW4rBI5jKc6bZsomZN954tTQ/WSFcC20VTcimbAu3bPTLMbTglUs5P
         z3ERSAHVr9i+cuf7Q9Z4PRPq15Zt7IKtm18URfsuc+IY8jXmWlS8djstkilOtUCQoTdV
         Wg4w==
X-Gm-Message-State: AOAM5332YiwIsWnB7dafx8CellpVMRUU5ktE+GAA1XnrXqsv0VaQdKjT
        lvup0sKTUL+kA5foxsIppOU=
X-Google-Smtp-Source: ABdhPJz9oa00UL45KYiP8Ed4JXeDj4BGCSkwo3hNV7y7qhN6uBnwfYk7/qq6ElDlcYQi8McRJQDdZw==
X-Received: by 2002:a17:90a:3486:: with SMTP id p6mr12198245pjb.23.1602364181401;
        Sat, 10 Oct 2020 14:09:41 -0700 (PDT)
Received: from localhost.localdomain ([45.118.167.204])
        by smtp.googlemail.com with ESMTPSA id c10sm520701pgl.92.2020.10.10.14.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 14:09:40 -0700 (PDT)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, anmol.karan123@gmail.com,
        syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH net] ethtool: strset: Fix out of bound read in strset_parse_request()
Date:   Sun, 11 Oct 2020 02:39:29 +0530
Message-Id: <20201010210929.620244-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flag ``ETHTOOL_A_STRSET_COUNTS_ONLY`` tells the kernel to only return the string 
counts of the sets, but, when req_info->counts_only tries to read the 
tb[ETHTOOL_A_STRSET_COUNTS_ONLY] it gets out of bound. 

- net/ethtool/strset.c
The bug seems to trigger in this line:

req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];

Fix it by NULL checking for req_info->counts_only while 
reading from tb[ETHTOOL_A_STRSET_COUNTS_ONLY].

Reported-by: syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com 
Link: https://syzkaller.appspot.com/bug?id=730deff8fe9954a5e317924d9acff98d9c64a770 
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
When I tried to reduce the index of tb[] by 1, the crash reproducer was not working anymore,
hence it's probably reading from tb[ETHTOOL_A_STRSET_STRINGSETS], but this won't give the 
strset 'count' and hence is not a plausible fix. But checking for the req_info->counts_only 
seems legit.

If I have missed something please let me know, and I will work towards fixing it in next version.

 net/ethtool/strset.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 82707b662fe4..20a7b36698f3 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -174,7 +174,8 @@ static int strset_parse_request(struct ethnl_req_info *req_base,
 	if (ret < 0)
 		return ret;
 
-	req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
+	if (req_info->counts_only)
+		req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
 	nla_for_each_nested(attr, nest, rem) {
 		u32 id;
 
-- 
2.28.0
