Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160D4225054
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 09:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgGSHYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 03:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgGSHXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 03:23:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C10C0619D5;
        Sun, 19 Jul 2020 00:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=rtmni3Fi9OejKkO3sYKJE2xHOWC7aoDdjADGXcErtkg=; b=AwfP0s2fwY7tOKDxfrGN5p+BV+
        O1TceXh+okp2KPnJG1H4UCWxYYynbROWfZnZch8JEyyayX0kcG0Z6NPgT/3+Wi95G5tu3sY5GN4lL
        PdOas3Pmm6vU4bE5jpUz573P9gR+6kQGJtjw8jWinV6iHt4G5T3Na2mLn7OyRGjFbJ0M4x4v4sbdq
        WiWcDBntP/+LxLvt+MGx5JVUtdZ0OuJyCY7VYlO74ExCrBbUXJIx6q+EZNP/tpGA+hZj7NQ/YADqG
        C8t7RiSsVhp7STbkXRgsJPDOcwNvXB1l4jBOPA41u9U9qZ327hHxFAlCulm68ZNhyOV9olB2+oNpy
        4+rbUPsw==;
Received: from [2001:4bb8:105:4a81:4ef5:9f24:cda4:103f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jx3f5-0000UW-LX; Sun, 19 Jul 2020 07:23:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 26/51] sctp: switch sctp_setsockopt_auth_key to use memzero_explicit
Date:   Sun, 19 Jul 2020 09:22:03 +0200
Message-Id: <20200719072228.112645-27-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200719072228.112645-1-hch@lst.de>
References: <20200719072228.112645-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch from kzfree to sctp_setsockopt_auth_key + kfree to prepare for
moving the kfree to common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/sctp/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index a573af7dfe41f5..365145746b559d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3649,7 +3649,8 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	}
 
 out:
-	kzfree(authkey);
+	memzero_explicit(authkey, optlen);
+	kfree(authkey);
 	return ret;
 }
 
-- 
2.27.0

