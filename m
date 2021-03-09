Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEBF331D04
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhCIC3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhCIC3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:29:03 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3233CC06174A;
        Mon,  8 Mar 2021 18:29:03 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso4304753pjb.4;
        Mon, 08 Mar 2021 18:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TFmmV9TVaaNUuaMbsO9KBOUJCI3DKPpFnOVgzqi7U6w=;
        b=apZSNVUIOKcBJTA2nDNXj8M/+Sm/J1CDcmtn4dh+G1TtfBQLVB1fCOy/VOwWVfJJrx
         tj1oL1/oE1PiHygPm2ldmo2IsMxeMsAG8V/NzrxRlUoyv3vPYKPr1tb9GcYsHYaaOMW5
         kvYBaAioNG8NEV+jhuDPtTLY7V134eJXP3WxpoD4bLvWgTf4XK0c4ozJakbj4ep0eOKX
         /saUXnACQ+gITn188nVyPqs0DkKYA5jQ9BN+Mn7hiOt3ilzyxNrFYGGP7w78PtFEDxRz
         n/bIng9BhhBr1aVYWUP2oWXotxybmvmNjN5JPPRI+4ouq3/h9wujb/+3xfKEeGEO4CPK
         nUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TFmmV9TVaaNUuaMbsO9KBOUJCI3DKPpFnOVgzqi7U6w=;
        b=VPJCUExpO3l2zIZDBMpy8YkGdJ2ThV0FanvBWJfkfMnqfCtKrHuuaQOYnb62W1eI0W
         sIwzeSYa4vAOF+Q8fiR4E+0TzbT3Bfk7/AzdUmM2V8+VD4kRKBrjJrA9J3a+2W/eVt+0
         4Di56CAdrP5CtxYuik2BDU1zm3DSaiojtGxZsHJenFNSk513lR1vK1dw+VBRL+nUkf9p
         CHWvkUu+qBiWCk9Nfeg4oOj/8WooFdGQHF+SoQmKfRVOkGqoUtHiexQLFF6DJ++cyflZ
         tFTR23j2G/4p+IanbBFM6ZtvSisa7S/QbSBOl8QhWmuJJKVnI6Kng76Q+kH3v9drwAvh
         nv+Q==
X-Gm-Message-State: AOAM532tAxky0rptgpLl0YZyYKRt31+JGOrQ9k6gW0p1GMZ0okhQfP2R
        VzfSLOmS9LK99Qa3WesFUjY=
X-Google-Smtp-Source: ABdhPJxHdg8O1Qf3n6xTDOTyz8jan40qc0uZIfiNe7WhMW9NneFjE2BcgAn+r1LEfAAjcWzN5WYdrw==
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr2113884pjz.145.1615256942855;
        Mon, 08 Mar 2021 18:29:02 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.97])
        by smtp.gmail.com with ESMTPSA id k9sm662852pji.8.2021.03.08.18.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 18:29:02 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: bridge: fix error return code of do_update_counters()
Date:   Mon,  8 Mar 2021 18:28:54 -0800
Message-Id: <20210309022854.17904-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When find_table_lock() returns NULL to t, no error return code of
do_update_counters() is assigned.
To fix this bug, ret is assigned with -ENOENT in this case.

Fixes: 49facff9f925 ("netfilter: ebtables: split update_counters into two functions")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ebe33b60efd6..66c9e4077985 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1256,8 +1256,10 @@ static int do_update_counters(struct net *net, const char *name,
 		return -ENOMEM;
 
 	t = find_table_lock(net, name, &ret, &ebt_mutex);
-	if (!t)
+	if (!t) {
+		ret = -ENOENT;
 		goto free_tmp;
+	}
 
 	if (num_counters != t->private->nentries) {
 		ret = -EINVAL;
-- 
2.17.1

