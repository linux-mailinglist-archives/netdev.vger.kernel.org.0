Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650C9358F95
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 00:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhDHWBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 18:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbhDHWBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 18:01:49 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F33C061761;
        Thu,  8 Apr 2021 15:01:37 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id a76so1928593wme.0;
        Thu, 08 Apr 2021 15:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=1k2oFebJMetFk2MF03n3BhfJ/Z6puGCIo7fh0K3MdcY=;
        b=PRkaV10clS+sLFEZRt0+mqBC/zm4SqmmBE9Gqa81Fz0xckmRM+MJuOI2M525VQlPg1
         D5ThmRBHKWpYoIIiGkgzco8KJcvyMvcQhWi8lgTawXnBb9X4vbWGi+Y9vf8atwhaj5Ce
         oFAcr1MFJG5lO0AX4iRggn7HIDdTiy8mGxoDh05Fc4HUGzghplJf7iXLMSwakD6v8iUk
         B9EVN7msrL3jru4b556NUvx41K9Xfo0LdNBQiwJ9avVKkMZyfu4+jAQHMS+EOWDLKzKu
         I4Oiud+uTZ6fvFUCUzU5NhlcOcMRebMxa6lIohFsp8fzpu80DzrK6aSyMO1SHYKujZY1
         6DUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1k2oFebJMetFk2MF03n3BhfJ/Z6puGCIo7fh0K3MdcY=;
        b=ox0DLYGIulOlNlVs3qBUO4xkNyO+l+LckU3+jFFFV2nRF8w0zCYekGLkZA0f9KfTIy
         yizGVZQWzd8ZRJqYNmoU2XF90D97b6lRi0SDX51uwJ+Wfb4Gud3PY1vkfi1QojbJzIji
         X1+lU/s/POy8zsBKXYbLp3L+8x0en5rMrYMQY6Bu5+GtWtbx9wPxYvWhiIrcPxVKhpiZ
         NMvQ4JX6RgQIelw3WlFRVk7I7n5xseb1lldg63wVkAdgdgg+auTLM/04IllZvJb8va4s
         nO31ZmQNmr/Y/sS/hDEOZtkGjfVFSFPHp1k9mZUql9QAdBW5WDh/5gjLbthP9u/mWS0J
         k5lw==
X-Gm-Message-State: AOAM530IGM9gC3WYkeaykLvERzyoSUrvxwVQ+EcojL74Qnk47y7CZPmw
        EClZvTUsC+DJAn5VcNaDt0E=
X-Google-Smtp-Source: ABdhPJxf8t72/YsLezTsQMLohaoXiiyiWCTcZkEGUe9xPH/SLdEmI4+zc7XajgVWPcBaL1ImutIVrQ==
X-Received: by 2002:a1c:4c0c:: with SMTP id z12mr10800685wmf.38.1617919295698;
        Thu, 08 Apr 2021 15:01:35 -0700 (PDT)
Received: from LEGION ([39.46.7.73])
        by smtp.gmail.com with ESMTPSA id o7sm1041687wrs.16.2021.04.08.15.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 15:01:35 -0700 (PDT)
Date:   Fri, 9 Apr 2021 03:01:29 +0500
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [IPv4/IPv6]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     musamaanjum@gmail.com, kernel-janitors@vger.kernel.org,
        colin.king@canonical.com, dan.carpenter@oracle.com,
        stable@vger.kernel.org
Subject: [PATCH] net: ipv6: check for validity before dereferencing
 cfg->fc_nlinfo.nlh
Message-ID: <20210408220129.GA3111136@LEGION>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nlh is being checked for validtity two times when it is dereferenced in
this function. Check for validity again when updating the flags through
nlh pointer to make the dereferencing safe.

CC: <stable@vger.kernel.org>
Addresses-Coverity: ("NULL pointer dereference")
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
---
 net/ipv6/route.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 28801ae80548..a22822bdbf39 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5206,9 +5206,11 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 		 * nexthops have been replaced by first new, the rest should
 		 * be added to it.
 		 */
-		cfg->fc_nlinfo.nlh->nlmsg_flags &= ~(NLM_F_EXCL |
-						     NLM_F_REPLACE);
-		cfg->fc_nlinfo.nlh->nlmsg_flags |= NLM_F_CREATE;
+		if (cfg->fc_nlinfo.nlh) {
+			cfg->fc_nlinfo.nlh->nlmsg_flags &= ~(NLM_F_EXCL |
+							     NLM_F_REPLACE);
+			cfg->fc_nlinfo.nlh->nlmsg_flags |= NLM_F_CREATE;
+		}
 		nhn++;
 	}
 
-- 
2.25.1

