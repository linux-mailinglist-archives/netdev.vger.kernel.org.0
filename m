Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2100FB1B11
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfIMJp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 05:45:56 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32836 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbfIMJp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 05:45:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id t11so13016523plo.0
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 02:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uXJ9/ls5TBnDekmtSFYRB29+X7xMmTdyo3ReTuj2abw=;
        b=LHz8cENy3PQ4tEbqOnVcYHeXBap0/hLYZHlwiZ11S/Ww5ug7gwsAO9koeTzc+wvISn
         XnuqW71Yo5pMI/Z79FHDkIZUwOU42oqXUjtTKUPM41S77yuIB8pFKajVbLIYezVgDIba
         noeR1oOJ8Gbr5AevIxbmHhW0tvet9Slq+SMw9TLsseicHgey880XgKx2zMsATs+wYBOP
         06yJ0xwsx826a5aRb9W1QDerHV+HCssOi8tmN26dJ86BwKYrCrIsdC402BGiEsgosvVa
         V/yth29rfDotn65dsxDCoTBsr9lsjV4JWdJfa6mRXtxfeoVoy/Wc+9L+sDOYbaajFRnd
         4rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uXJ9/ls5TBnDekmtSFYRB29+X7xMmTdyo3ReTuj2abw=;
        b=MyajMW2K4qcv1h0q881C5tiT5I6RYhb9luS09A7udQD0HxX2aywPUv2mg3LMAJnWcd
         yPAjV9tAprsW+jYgSWaQAvN35mRGLZlDJ5p7Ua7LtDrLM3OOQZrXKA5rDKCjyahIxX0m
         gfUzZYhK0vIJC0loOYSJ37P46EdAAgJMLJftJCTBYMMR9EsBhafsSGKTNKc24ck+PI0P
         BitbriPtkuHl6j7gXU3/+HRxhQ0EasQG2A38phyXf0dSsrNf9kbLD/wGvsIfiLapcLb0
         NogkUBrnaryDvfhop8OoRfchq/4easz5NepgR0Ta1NqN6rGD2lIUQsbDvoWrPrtlaLPF
         GCXA==
X-Gm-Message-State: APjAAAWBIhy5DlkwvV5WqnLfVE7V3vgL0cm9XVC6WmSmgSKgqeJ1eesU
        x3OvB3RKGuI6f7WoiuVQgvC/WiOdbF8=
X-Google-Smtp-Source: APXvYqxZzkNuyvfP+F7zvqtpIRTdcgGUSzJPQT34Ypydo8J7/n47stFLlrRWFqXhkBXegJp6zwtV8w==
X-Received: by 2002:a17:902:a586:: with SMTP id az6mr45457228plb.298.1568367955363;
        Fri, 13 Sep 2019 02:45:55 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p66sm41087578pfg.127.2019.09.13.02.45.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 02:45:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, William Tu <u9012063@gmail.com>
Subject: [PATCH net] ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit
Date:   Fri, 13 Sep 2019 17:45:47 +0800
Message-Id: <1bfbf329c5b3649a6c6362350a0d609ff184deba.1568367947.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ip6erspan_tunnel_xmit(), if the skb will not be sent out, it has to
be freed on the tx_err path. Otherwise when deleting a netns, it would
cause dst/dev to leak, and dmesg shows:

  unregister_netdevice: waiting for lo to become free. Usage count = 1

Fixes: ef7baf5e083c ("ip6_gre: add ip6 erspan collect_md mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ip6_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index dd2d0b96..d5779d6 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -968,7 +968,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		if (unlikely(!tun_info ||
 			     !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
 			     ip_tunnel_info_af(tun_info) != AF_INET6))
-			return -EINVAL;
+			goto tx_err;
 
 		key = &tun_info->key;
 		memset(&fl6, 0, sizeof(fl6));
-- 
2.1.0

