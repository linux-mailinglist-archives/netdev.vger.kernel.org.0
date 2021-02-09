Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927DA3159D3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 00:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhBIXC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 18:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbhBIWUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:20:13 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8AAC061221
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 14:18:29 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 19so432465pjk.7
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 14:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=IJr6rjdV0ge7ooDfMKWJj/dk9pIwsXcgC7YvK8nTUak=;
        b=InEoJpk9LyZYeLF0/9RsVHGrznhp1YhCNKUyHtVinTKmiyQuo6DeyVS3piPLA5O4cb
         ldYBhl9VdgBZqfgdwzXbvfgfxOAFGURyimUn3j7nOb+SVsnq1Nlm7ClMwDS2TY9uDVfB
         muAR2aNpy4HxkpmQ+zsSzb2lu+7ssVK6SGIQbapeB6B5nXjWa7tOxXxvo4mg39SqsFoB
         xDDrqRUkMtevHstpmlxov1a7qi7T4YSqnyGt6S4IIGzbxyXp3wtpCK5i+6oI2kaL8vFI
         Y422T3144vu/G5ycG+B6DRPvwkbnGpEbHUaRrBWVktQFNiS95sZ3QeG/l2YXZpujoDTd
         ylTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=IJr6rjdV0ge7ooDfMKWJj/dk9pIwsXcgC7YvK8nTUak=;
        b=Aw07upygata8D/vqyVzi0f7EfzS5s+jYU6hPWBmOYKLorx8OxuGd1V95+FYgJHZF20
         G9nkJ8QoOJcNfmqaCtdzzGvuIHik4ITfWYCTuAFiJ7vnR+VHcLjqaX0LYZfbnzEmtPCN
         5LomfsNM5plFvO50NqteFIbRaIZtu9HlhkQCz5X8FlDyk7LaKwbT6G3mwr+kSV6pdhQ/
         xHVZYBWzuPmFgw7sbNuBdXmU/A3vuYbtCmfcu+aj1F/wi99p187GiUiNczCuj3f8RnbV
         YJBTK3vKzTiNPki4g8uluu8g1cD1iCvjZsZhrsTNFC9OsCfq4/ghEqAl6gLCi8/N77rY
         WX1Q==
X-Gm-Message-State: AOAM531HR0+XA/UsxqEhykzSGBVrN+efbnZbZ4Z5eL7Ji/F5dnI4+MKn
        D5rMmp3tKqwP/NCX5x5g6y7kiHbB+W8OCuj3am2vxXClvxxn0yhPWh+VDDFM6OtaWKRgG+tyPfZ
        8YYKkOlnCAujqmdDrd3aA9NGLriGurf6xS2I5Fs0dkaOUdxYcwNKYnA==
X-Google-Smtp-Source: ABdhPJy5tl47uJDJ2/4A3uDNCUkisIgBFwLvqPvYV6iSDsZCyNTo6WaNHXJU8WOl6QtJi5whnzgiP44=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:b8:bd34:879f:b865])
 (user=sdf job=sendgmr) by 2002:a17:90a:4209:: with SMTP id
 o9mr22850pjg.75.1612909108659; Tue, 09 Feb 2021 14:18:28 -0800 (PST)
Date:   Tue,  9 Feb 2021 14:18:26 -0800
Message-Id: <20210209221826.922940-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH bpf-next] libbpf: use AF_LOCAL instead of AF_INET in xsk.c
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have the environments where usage of AF_INET is prohibited
(cgroup/sock_create returns EPERM for AF_INET). Let's use
AF_LOCAL instead of AF_INET, it should perfectly work with SIOCETHTOOL.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/lib/bpf/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 20500fb1f17e..ffbb588724d8 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -517,7 +517,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 	struct ifreq ifr = {};
 	int fd, err, ret;
 
-	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	fd = socket(AF_LOCAL, SOCK_DGRAM, 0);
 	if (fd < 0)
 		return -errno;
 
-- 
2.30.0.478.g8a0d178c01-goog

