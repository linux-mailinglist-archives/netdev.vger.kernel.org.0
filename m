Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D612E24E6E6
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 12:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgHVKeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 06:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgHVKeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 06:34:17 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6146BC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 03:34:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so3995390wme.4
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 03:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K2yrBUH4mgUfgV9x8u+qsCs9ZQVgkgT8J0hzEzgXEYM=;
        b=OE50YbaF1KKFeehFa3D86J0GRZwPPlDsc/47tX8VYuM5hCmticsWpoOpiM72W8K/+L
         28I4FlbsuOeRkB5e+2ZsPoXTV+wAHB5ttpw7v+Y+8IlYAitgzb52Tt1v7f+uBdxD5YOh
         FtWshnayaQErDBW+5zNh3/Lhwj6yC9VKeqMXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K2yrBUH4mgUfgV9x8u+qsCs9ZQVgkgT8J0hzEzgXEYM=;
        b=q/o46Cb4hg8Zr2VwakIvzthLfhLEswCCVniVNOu0EjXVQ1otgVyTZYpEaqW19pph4a
         s+7tGKUOlpy8JSPM+c2EZAKhj5uDgvD61r1xCMP3jROkta+pzCM8tU8EXimp5DzKbfwK
         kt14LLBPthP5tB9n03HBaqwAIkfdAX8VARaKrjXGhhVXPfrgAdyoHF3M1Ks4feEEZlBi
         rQX4lQkyCpVsoOldip8gAPmCWNecw/CHIiLOqeHGrrk9tw5PSNR5cJVLkU7Em0SPY/cZ
         ++2RoxUR9vNsu1rGHbSUgjgNuUsETc7oTHUO0cvvJn6SaYJ0xN2LHnrmOysnBpgYrQZW
         0EDQ==
X-Gm-Message-State: AOAM530naO1pnTH7hhwPlHKF24OJxegn+cHkJCl+Ui1UZhWjKKHJmh5U
        KltWniaeh2uVOwM1YWfKBwB/jiLB75+5Hw==
X-Google-Smtp-Source: ABdhPJzZ/DRpFz90v+qKbFl6J4A67XHV0qc4eDssW5XIuGGuFlpLaCCzUoecYsJxdLTWG7Eegf+vnA==
X-Received: by 2002:a7b:c1d0:: with SMTP id a16mr8067369wmj.111.1598092454913;
        Sat, 22 Aug 2020 03:34:14 -0700 (PDT)
Received: from wrk.www.tendawifi.com ([79.134.173.43])
        by smtp.gmail.com with ESMTPSA id g25sm10539211wmh.35.2020.08.22.03.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 03:34:14 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@gmail.com>,
        syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
Subject: [PATCH net] net: nexthop: don't allow empty NHA_GROUP
Date:   Sat, 22 Aug 2020 13:33:40 +0300
Message-Id: <20200822103340.184978-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <6184a09e-04ee-f7f0-81b0-de405b6188ae@gmail.com>
References: <6184a09e-04ee-f7f0-81b0-de405b6188ae@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the nexthop code will use an empty NHA_GROUP attribute, but it
requires at least 1 entry in order to function properly. Otherwise we
end up derefencing NULL pointers all over the place due to not having
any nh_grp_entry members allocated, nexthop code relies on having at least
the first member present. Empty NHA_GROUP doesn't make any sense so just
disallow it.
Also add a WARN_ON for any future users of nexthop_create_group().

CC: David Ahern <dsahern@gmail.com>
Reported-by: syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com
Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
Tested on 5.3 and latest -net by adding a nexthop with an empty NHA_GROUP
(purposefully broken iproute2) and then adding a route which uses it.

 net/ipv4/nexthop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index cc8049b100b2..134e92382275 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -446,7 +446,7 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 	unsigned int i, j;
 	u8 nhg_fdb = 0;
 
-	if (len & (sizeof(struct nexthop_grp) - 1)) {
+	if (!len || len & (sizeof(struct nexthop_grp) - 1)) {
 		NL_SET_ERR_MSG(extack,
 			       "Invalid length for nexthop group attribute");
 		return -EINVAL;
@@ -1187,6 +1187,9 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	struct nexthop *nh;
 	int i;
 
+	if (WARN_ON(!num_nh))
+		return ERR_PTR(-EINVAL);
+
 	nh = nexthop_alloc();
 	if (!nh)
 		return ERR_PTR(-ENOMEM);
-- 
2.26.2

