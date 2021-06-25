Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5782E3B418D
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 12:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhFYK0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 06:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhFYK0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 06:26:21 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D81BC061574;
        Fri, 25 Jun 2021 03:24:00 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id d16so15437219lfn.3;
        Fri, 25 Jun 2021 03:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mA4MK7Qr8XHELuEKqiootlu+LOQg/7ijOx7HOstIiJ4=;
        b=FLY+8QuEnlw0aXi+0Z/K7u5MBSA0emdjGCxiSFOOVOx2UVbkAHwOaSlJXeSRa+QfEQ
         HSCg/CclfLPIw2ldxVHDTHF+mmp7fm9xP9f1jULV6hPMYnVMa8uWjSfnv+dNilsMlJ/l
         f6yBKMPBH0PSiDgAP6Y3fdUVJDeh175EJZJ/HGkpLbZaN2oW1ZoDbBqnMKUny2npK9Xj
         6oIJx/lWCgXvpP1/359x7/HCQ6OzrNYMm77NUbglvFLSNW7Y3FF5cWLUc9F3q6tz100H
         H1XLmoFbFcETuGCKB9yrkak+vK9oESwEcU9OhJoTjzFL7tH8uxbs9M32wdRgJnuYkbSn
         M7wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mA4MK7Qr8XHELuEKqiootlu+LOQg/7ijOx7HOstIiJ4=;
        b=WjC3blmLvC6VzZoJef2n5P86tm9CSxeYr5+E4rwGJBK93SwofjcQ9NCkxglLqqY+VF
         reMXL5ci69qNXXyhjaAjZdNmxVr1HLS61DcLoowVQ5lHiDyuSwsrO9rfuUZ1DgYO5UH5
         8gGd/4aF9QB2FAp6hzOU8RBBIpXhyN6T0IZ4/vIKKQjfehbOUrcrsAph/0CpTjJa3kop
         uu2TyO7wVeh8EyX7NBGUz39xFTfz0GwPVsfVgVfde9RqodrPmczRvnyQAQwgQZ5LluEk
         iEhRf0hjKRkjMcsEC28rBtRqlu4xK8y/cAgMLkYODKiU+Cdo31eKrCudYmtRHqK0KH/r
         UbTg==
X-Gm-Message-State: AOAM5311d5+n+LueeNOU5VjylpXidGGPPHqMynJXW/SuqF1m6gFX3Jg0
        dQ3UyYMdrA0YwA4J5qwRat2TVUWpA3RfIw==
X-Google-Smtp-Source: ABdhPJzP8BIojsyjcuITH5Yh5F7FsZh5MrEOdEg7PEgv+7lhTdVafj4BjC5luipLHqpCvczgohsedw==
X-Received: by 2002:a19:650f:: with SMTP id z15mr7471186lfb.511.1624616638682;
        Fri, 25 Jun 2021 03:23:58 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id f13sm474904lfc.157.2021.06.25.03.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 03:23:58 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, 0x7f454c46@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com
Subject: [PATCH] net: xfrm: fix memory leak in xfrm_user_rcv_msg
Date:   Fri, 25 Jun 2021 13:23:54 +0300
Message-Id: <20210625102354.18266-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported memory leak in xfrm_user_rcv_msg(). The
problem was is non-freed skb's frag_list.

In skb_release_all() skb_release_data() will be called only
in case of skb->head != NULL, but netlink_skb_destructor()
sets head to NULL. So, allocated frag_list skb should be
freed manualy, since consume_skb() won't take care of it

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Reported-and-tested-by: syzbot+fb347cf82c73a90efcca@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

One thing I'm not sure about is did I choose the rigth
place to free this skb, maybe we can move this clean up
a little bit deeper, like in xfrm_alloc_userspi()?

---
 net/xfrm/xfrm_user.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index f0aecee4d539..ff60ff804074 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2811,6 +2811,16 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	err = link->doit(skb, nlh, attrs);
 
+	/* We need to free skb allocated in xfrm_alloc_compat() before
+	 * returning from this function, because consume_skb() won't take
+	 * care of frag_list since netlink destructor sets
+	 * sbk->head to NULL. (see netlink_skb_destructor())
+	 */
+	if (skb_has_frag_list(skb)) {
+		kfree_skb(skb_shinfo(skb)->frag_list);
+		skb_shinfo(skb)->frag_list = NULL;
+	}
+
 err:
 	kvfree(nlh64);
 	return err;
-- 
2.32.0

