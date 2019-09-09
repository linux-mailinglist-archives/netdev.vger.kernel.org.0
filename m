Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0A1AD4DF
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 10:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389112AbfIIIaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 04:30:19 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41935 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727023AbfIIIaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 04:30:19 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so8673398pfo.8
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 01:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=V/dDlvtPa/zUelwbyU9EaW9OfGFB6sH/7tZfOCqCgsE=;
        b=Ijkbl+Mh7grNiX+5dgwU2rVOhB1D1Hows8vURc1vLDBWlu2BM6FwLaj+ulsBcO350T
         VPsBU0r4Hotefp/kM0DZPESq7ZxYBsYlHvcre09Yn4bQb3UYkCjuMqUxF5ekjlBBsj2M
         x7DUIqsl+xEkPR/+A+frtDtVcknmkzK0oEKXtaa/lJFZQbbVkykHpsRjEBJaRpejwYEE
         kkqgfsywU+EnG/iDdGahv6XFwPXwwdCqQQo2NYmf59dxaZ+Ei6bd4uTkwLWYxaa3APTL
         PDb3aBzSA6wHitVhNwmOgAMeN7V3P1SO0VTFfGM3kL1NxqTFTXl7H80X8LenUp3RwEoC
         9UhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V/dDlvtPa/zUelwbyU9EaW9OfGFB6sH/7tZfOCqCgsE=;
        b=NLouBaQUJ6XqwLDDy4vTZX/BjTV++CUFTQbYNtS8NuvnGSFjte1ENo7oPqJACPByyr
         nEAjcifPRazSQKKl4giVnpuJ5dd4v5EZ9ANwivUuMAaGQ20AgsMVrvUETVhtMX7Cf/I4
         4QVA0683FjYyC0e/VnRGG6ClyF0N9d8qMNbYGWCbNdF3qzmhraAuPunhsfYa2EW0/Q7v
         tek9I1hqqaiByJ9MaKAoJDPG5dCH16NLqpjGO09RNajV6B6l0UBrDLNZjyLEMlwo+i2O
         jAC6vf9yrROxdsOpVbXgVKl/4XBn076e+T+HtoaBAWydDACmjKgNaYajyiX13bdvO+ij
         XT4Q==
X-Gm-Message-State: APjAAAUh/nDVU8T84tzsuBSjlj3U4IWt9vsomkXUhxvWgpqf4wRbkZ+7
        MHhoOc6Be8qGeOtzY8zGCPucyokyGwo=
X-Google-Smtp-Source: APXvYqycIypA4v5UcW83BQ7AWJkEwjOoZVSDQ8Hsf82Y9KXkz92Io3EzhX0J9U9gyhGiHIplahwgUA==
X-Received: by 2002:a17:90a:f0c6:: with SMTP id fa6mr16265832pjb.136.1568017818207;
        Mon, 09 Sep 2019 01:30:18 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c125sm19927793pfa.107.2019.09.09.01.30.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 01:30:17 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, steffen.klassert@secunet.com
Subject: [PATCHv2 ipsec-next] xfrm: remove the unnecessary .net_exit for xfrmi
Date:   Mon,  9 Sep 2019 16:30:10 +0800
Message-Id: <0e9b72a6caf695dd99c02bd223168897977daaef.1568017810.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xfrm_if(s) on each netns can be deleted when its xfrmi dev is
deleted. xfrmi dev's removal can happen when:

  a. netns is being removed and all xfrmi devs will be deleted.

  b. rtnl_link_unregister(&xfrmi_link_ops) in xfrmi_fini() when
     xfrm_interface.ko is being unloaded.

So there's no need to use xfrmi_exit_net() to clean any xfrm_if up.

v1->v2:
  - Fix some changelog.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_interface.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 74868f9..faa0518 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -738,30 +738,7 @@ static struct rtnl_link_ops xfrmi_link_ops __read_mostly = {
 	.get_link_net	= xfrmi_get_link_net,
 };
 
-static void __net_exit xfrmi_destroy_interfaces(struct xfrmi_net *xfrmn)
-{
-	struct xfrm_if *xi;
-	LIST_HEAD(list);
-
-	xi = rtnl_dereference(xfrmn->xfrmi[0]);
-	if (!xi)
-		return;
-
-	unregister_netdevice_queue(xi->dev, &list);
-	unregister_netdevice_many(&list);
-}
-
-static void __net_exit xfrmi_exit_net(struct net *net)
-{
-	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
-
-	rtnl_lock();
-	xfrmi_destroy_interfaces(xfrmn);
-	rtnl_unlock();
-}
-
 static struct pernet_operations xfrmi_net_ops = {
-	.exit = xfrmi_exit_net,
 	.id   = &xfrmi_net_id,
 	.size = sizeof(struct xfrmi_net),
 };
-- 
2.1.0

