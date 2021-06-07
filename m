Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8C439E532
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhFGRWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhFGRWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:22:24 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C0FC061766;
        Mon,  7 Jun 2021 10:20:21 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id r198so24209754lff.11;
        Mon, 07 Jun 2021 10:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y2ro6T0qqojf4blqEYp6j8bNJdFK/yK6RngDggYxJQ8=;
        b=ioxSVn6ocOUUCeFsK89IAZxzVuvn35J3Fj7YPLaWRe6Rd9CXH8IwOSM5U5LYqjfFsV
         lcoHRBUuGzlUJbf/9cpn3YqryqB1sTrV0hWFsscK1wR6LRhClmJLy72J1I+zHy72E524
         XSZhcRCKWzZYP5ou9VbGEOlpvUlhg5oVzQKTu6dV2CLTkDc/+xVSoQ+aDAeGp9DkCl0H
         7QdrfAooIhLcPF6YmLUwg0ECUMKEY103PxSjpVN+/RxtmW2+Jxr/sEtwzNY2sJRujufb
         gLXgBKDzWaVBr85wcu0v8359UuVYSWIWhkhZilcNRIiUtmqT4d87u5DjnKlZ/ABi0Vo1
         01qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y2ro6T0qqojf4blqEYp6j8bNJdFK/yK6RngDggYxJQ8=;
        b=LYOLjFRjWQsJazhMIufS45Vz2zED18Izq9d3f5pSLpuM/jM5jYNTTCZG9bcMchtCr/
         97+XB9UoQ++DP7pPh1dDYuE0D9eEJ/6U8cvt0Ai8uz3Jb5gr1qwDfb3QCxlaCOLKji5k
         e4DI7ygNZYZhyPNKeDc1WYbn+JA/W53kq7lP5Yq9DzwfAnPo8/UGoE7PHEWEppuvxt4J
         eyOtQ7IlxphvIQ4Lj+2lnUbUItzx7wqJL7eCouOC/UY+LKI79jomGvYv7h70jFK9drBm
         G6/JGP3WB26ky/YxFKdcDveLqBwJ0XOVYHDY9BcG/hsEo9PElEgCFkM8GUW/3Stb1quL
         mQng==
X-Gm-Message-State: AOAM531vCdmi37hV+aSxmVJIXfPfHWqET1HdhI/y3MMfGNHaJhoimRoX
        yKcVh5SeHLdn288nXgxSY2gU91+fmaU=
X-Google-Smtp-Source: ABdhPJyPsUkq6BesCer/N77aEXiYiusKsN2vOkBOUTT1MS4jEYu6LljDHOeMGAVrfa8LFKfXNPDjqA==
X-Received: by 2002:ac2:5d4f:: with SMTP id w15mr12427499lfd.348.1623086419489;
        Mon, 07 Jun 2021 10:20:19 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id w24sm1560402lfa.143.2021.06.07.10.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 10:20:19 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com
Subject: [PATCH] revert "net: kcm: fix memory leak in kcm_sendmsg"
Date:   Mon,  7 Jun 2021 20:20:15 +0300
Message-Id: <20210607172015.19265-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit c47cc304990a ("net: kcm: fix memory leak in kcm_sendmsg")
I misunderstand the root case of memory leak and came up
completely broken fix.

So, simply revert this commit to avoid GPF.

Im so sorry about this one.

Reported-by: syzbot+65badd5e74ec62cb67dc@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/kcm/kcmsock.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 1c572c8daced..6201965bd822 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1066,11 +1066,6 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 		goto partial_message;
 	}
 
-	if (skb_has_frag_list(head)) {
-		kfree_skb_list(skb_shinfo(head)->frag_list);
-		skb_shinfo(head)->frag_list = NULL;
-	}
-
 	if (head != kcm->seq_skb)
 		kfree_skb(head);
 
-- 
2.31.1

