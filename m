Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BFA47E984
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 23:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350578AbhLWW1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 17:27:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350812AbhLWW0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 17:26:11 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F1EC0698E1
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 14:24:46 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id v1-20020a17090a6b0100b001b12c84a1b7so5013170pjj.0
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 14:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7JAsMzI/xyXeS8mjzvdmC639EA7v2UpQEtBKKluUX/g=;
        b=OP2W3j77iNB3uUHuQlng1JV1keYNfkTz0Sy0Kvqkp9sCAeDTAOamUMUCO9QdhCzm48
         5met2fjSGHbwyqXJGVFnBmTzkNVsILz7a1aVxGDxDk30vf8USoOkjYeM6GOYmUAOuiqS
         7uZxBTY6SL+azsP24z49/oTidKkojpSHUBuukdSeJK9h/ivI/INBTH//pPGxlKcH/+rf
         nII9jFkvlL5XxGTIPgos2M9hgWw7t74+9y/WLmJCWihp8FeEZJPQjT+SZz9qMiqgz7LY
         t0xSeIMSqD/brmjcp7m1Iyr5D7Rt37xrRlVQQYa+35Bg6vpfi5bKOagx8s6ndCJ6HXP5
         6Dww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7JAsMzI/xyXeS8mjzvdmC639EA7v2UpQEtBKKluUX/g=;
        b=nqF6HL5XT3UuT7CaYL5Bcfd6BiwNdb/XfriodQv5wmtrb/QXV9L30vDyhKMzjMUVYa
         3PRIWzzwikFcpWINIM9+ySr1uA55MI9fsdQQO8bjt7Bot4ZzJpnyUzophv7BbSaorepQ
         iICqqrEhjssqzfOo8JoKjn6lyIZp/RbRqTqy+fAswOkp+thTaF/KE4kUweS8F9dJAAMp
         ahAGcew2MGQZRLMrdVAHc0BfmVlow87bmIUE6TwhrgYZj87gNyit5Eo6h4FuLKmRAcoJ
         Qak0N7rX5GfBMFYTMDzcc2PnEzhkFAzIpGmK8gbC7zESFjErFquCX7wiVzS4wuVFAnLv
         Ra8g==
X-Gm-Message-State: AOAM533H6Rq3M4hMFXn8AV8CFxGza9wS7TdtXZz4My0X0lqOo991tNBi
        C+olNfPhc2ykE9nOHdnfrSwzc3F62fxd3fqhKe4JabizMxjuOzeF9XFzzRuYXIK2tzASt8XUs6f
        0Le0oKqrW4U0RRPTWG7uAWigOGX+GTg9FDR8xvbFhFDFM8YeEoPt5I9O3mPQLr99Vc+jkgA==
X-Google-Smtp-Source: ABdhPJxLAWE3bDq8JURNCdZCW7sz74Ba0Sqcdow8Xqh9NCOHCw8xNhCg6jgJfTLQqb5Hv9aycftTnIuhpCZ8+m4=
X-Received: from coco0920.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5738])
 (user=lixiaoyan job=sendgmr) by 2002:a17:902:b695:b0:148:a2f7:9d76 with SMTP
 id c21-20020a170902b69500b00148a2f79d76mr4142939pls.149.1640298286100; Thu,
 23 Dec 2021 14:24:46 -0800 (PST)
Date:   Thu, 23 Dec 2021 22:24:40 +0000
Message-Id: <20211223222441.2975883-1-lixiaoyan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH net 1/2] udp: using datalen to cap ipv6 udp max gso segments
From:   Coco Li <lixiaoyan@google.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The max number of UDP gso segments is intended to cap to
UDP_MAX_SEGMENTS, this is checked in udp_send_skb().

skb->len contains network and transport header len here, we should use
only data len instead.

This is the ipv6 counterpart to the below referenced commit,
which missed the ipv6 change

Fixes: 158390e45612 ("udp: using datalen to cap max gso segments")
Signed-off-by: Coco Li <lixiaoyan@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index a2caca6ccf11..8cde9efd7919 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1204,7 +1204,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, struct flowi6 *fl6,
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-		if (skb->len > cork->gso_size * UDP_MAX_SEGMENTS) {
+		if (datalen > cork->gso_size * UDP_MAX_SEGMENTS) {
 			kfree_skb(skb);
 			return -EINVAL;
 		}
-- 
2.34.1.448.ga2b2bfdf31-goog

