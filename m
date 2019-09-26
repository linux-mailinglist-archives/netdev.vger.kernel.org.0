Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB84BEE85
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 11:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfIZJgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 05:36:55 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39053 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfIZJgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 05:36:54 -0400
Received: by mail-pl1-f195.google.com with SMTP id s17so1094506plp.6
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 02:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GGk9sguynL1KTQpVTMXRwXS1clhzSNAeBjYGrIwDEOg=;
        b=R0/G8vTJyh0P37bMVY92LLUbxMTUQWxkgYBwAie5F7VcJO0LQs9YncYASAs52coPBP
         splftTNeVP5F2erAJPBYvXWdSd0R5t3orWwjxaZE+kkPtZK8wENznzN4V8MhfQGnrs45
         DjWd+ZqnGQDcaMOf4c/mHLMwUDWrbDPLTkLTA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GGk9sguynL1KTQpVTMXRwXS1clhzSNAeBjYGrIwDEOg=;
        b=r+y3xA9P0refMKMsWNT0dhxjUuPRUv3vpMlDMi2vJyiw1xXM13a6mfaN93QmpD2HVM
         /dIoKN4zK2dYTFnoaW4haYz0L32VzYNyWnrhqAOKE3jaeuMKxlk6iBP+InnrhHS/lNxE
         4dTu44cHXsywn/f2SZ4abj7l/NGJi9sMt3hITEWt6+7xGBMUzLDw1NtnWKnEE9iwsUv+
         NAZ7wOXn2cNAd/4Z/PfPd7by4rszMVxRC1j1dEceJjY4OiXWDn0A4yEDto7UVjNrQU8O
         xPSgWkgp7t5M5sJC1iMGv8niT5lrEZnyvncJzKWvWZgI63ehVTBfBXtf3DkEOMXJRP8w
         Buzw==
X-Gm-Message-State: APjAAAU3y20EyEOwUC1o/ygFOSpY8HpNzwS6IVrxz14f2GkUghVts1Yr
        1xCSqzWXk9GG7OygRwk4a/N4Tw==
X-Google-Smtp-Source: APXvYqyWi4R7OLYSGjliAgeIlhQu+gdlA8bc2J8XpsAeL5t0lhOeORKytnYfTp3/kjpn508vMuuXUQ==
X-Received: by 2002:a17:902:b613:: with SMTP id b19mr2759547pls.225.1569490613963;
        Thu, 26 Sep 2019 02:36:53 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d10sm1972417pfh.8.2019.09.26.02.36.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 02:36:53 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH net] devlink: Fix error handling in param and info_get dumpit cb
Date:   Thu, 26 Sep 2019 15:05:54 +0530
Message-Id: <1569490554-21238-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If any of the param or info_get op returns error, dumpit cb is
skipping to dump remaining params or info_get ops for all the
drivers.

Instead skip only for the param/info_get op which returned error
and continue to dump remaining information, except if the return
code is EMSGSIZE.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
---
 net/core/devlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e48680e..a1dd1b8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3172,7 +3172,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI);
-			if (err) {
+			if (err == -EMSGSIZE) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -3432,7 +3432,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 						NETLINK_CB(cb->skb).portid,
 						cb->nlh->nlmsg_seq,
 						NLM_F_MULTI);
-				if (err) {
+				if (err == -EMSGSIZE) {
 					mutex_unlock(&devlink->lock);
 					goto out;
 				}
@@ -4088,7 +4088,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
 					   cb->extack);
 		mutex_unlock(&devlink->lock);
-		if (err)
+		if (err == -EMSGSIZE)
 			break;
 		idx++;
 	}
-- 
1.8.3.1

