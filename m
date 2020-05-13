Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF041D109F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 13:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgEMLID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 07:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgEMLID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 07:08:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809EEC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 04:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Ux2iDnKNR2OwEnQUxJY2CJVUd9EbIh+47cEfOd0JSpM=; b=gy94sZbsnzvjp1Uvht+JyhdyBv
        t3cYbGogxGqlHyV2njFXXEDps6LM2khBEE+IAo4aBjzWORqt+1FV8NUz9Jla7UwlERIyLbRAsyeuG
        8tlnkSLrAenyRxm7U0APFQoytAiTEQr2rRnEgIHJ1hzJ5P78GGiW9iLngVbKn5HCITbTYwrsBAc4Q
        aBkE1/lnT+YdxhbQEc2CXapLz+z12p6cKSRXhHZHPTjRtMkYd2tW23vf0s447uWAOeCBZv5KGo4eg
        aqJWu3Jfiuuuxe9Awpv0AxU9HlCoXgY/ypUAVMAPN+pGZc04sFWUAukkxbSyAgAHBLeyE8JK9OsP+
        Dp01g11g==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYpF3-0001ZJ-O5; Wed, 13 May 2020 11:08:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: [PATCH] net: ignore sock_from_file errors in __scm_install_fd
Date:   Wed, 13 May 2020 13:07:59 +0200
Message-Id: <20200513110759.2362955-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code had historically been ignoring these errors, and my recent
refactoring changed that, which broke ssh in some setups.

Fixes: 2618d530dd8b ("net/scm: cleanup scm_detach_fds")
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/core/scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index a75cd637a71ff..875df1c2989db 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -307,7 +307,7 @@ static int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
 		sock_update_classid(&sock->sk->sk_cgrp_data);
 	}
 	fd_install(new_fd, get_file(file));
-	return error;
+	return 0;
 }
 
 static int scm_max_fds(struct msghdr *msg)
-- 
2.26.2

