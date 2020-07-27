Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B3922F7A6
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgG0SWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729357AbgG0SWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:22:24 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49762C061794;
        Mon, 27 Jul 2020 11:22:24 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k07lU-003oWt-7u; Mon, 27 Jul 2020 18:22:20 +0000
Date:   Mon, 27 Jul 2020 19:22:20 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Nick Bowler <nbowler@draconx.ca>
Subject: [PATCH net] fix a braino in cmsghdr_from_user_compat_to_kern()
Message-ID: <20200727182220.GI794331@ZenIV.linux.org.uk>
References: <20200723155101.pnezpo574ot4qkzx@atlas.draconx.ca>
 <20200727160554.GG794331@ZenIV.linux.org.uk>
 <20200727161319.GH794331@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727161319.GH794331@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	commit 547ce4cfb34c ("switch cmsghdr_from_user_compat_to_kern() to
copy_from_user()") missed one of the places where ucmlen should've been
replaced with cmsg.cmsg_len, now that we are fetching the entire struct
rather than doing it field-by-field.

	As the result, compat sendmsg() with several different-sized cmsg
attached started to fail with EINVAL.  Trivial to fix, fortunately.

Reported-by: Nick Bowler <nbowler@draconx.ca>
Tested-by: Nick Bowler <nbowler@draconx.ca>
Fixes: 547ce4cfb34c ("switch cmsghdr_from_user_compat_to_kern() to copy_from_user()")

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/net/compat.c b/net/compat.c
index 5e3041a2c37d..434838bef5f8 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -202,7 +202,7 @@ int cmsghdr_from_user_compat_to_kern(struct msghdr *kmsg, struct sock *sk,
 
 		/* Advance. */
 		kcmsg = (struct cmsghdr *)((char *)kcmsg + tmp);
-		ucmsg = cmsg_compat_nxthdr(kmsg, ucmsg, ucmlen);
+		ucmsg = cmsg_compat_nxthdr(kmsg, ucmsg, cmsg.cmsg_len);
 	}
 
 	/*
