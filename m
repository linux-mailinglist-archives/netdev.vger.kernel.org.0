Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EF02B19B6
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 12:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKMLNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 06:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgKMLMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 06:12:24 -0500
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C26C061A04;
        Fri, 13 Nov 2020 03:11:58 -0800 (PST)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CXbQM3xGNz12WW;
        Fri, 13 Nov 2020 11:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605265915;
        bh=a8NC42R6u3qlmdveQqeX3g+/yoA0KQ9pNupZi4YG580=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDPcpPDIHfNoRB6KA4dFuZJp9v/qA1ZekZ6ewbO1TYKGkB6eyR012NFTZnczJZ9lc
         NxxiXtyTD8/tHbmGWqUFvKgsUesXuD/qTm53srO09QBm5bl9pGNso2bPQUyIVRc8WT
         auu/jtMK0RecgA9OqaUe2wsH5a4o0rXnEYrlHGCk=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CXbQM22j6z12W4;
        Fri, 13 Nov 2020 11:11:55 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, keescook@chromium.org,
        Francis Laniel <laniel_francis@privacyrequired.com>
Subject: [PATCH v5 1/3] Fix unefficient call to memset before memcpu in nla_strlcpy.
Date:   Fri, 13 Nov 2020 12:11:31 +0100
Message-Id: <20201113111133.15011-2-laniel_francis@privacyrequired.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
References: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Francis Laniel <laniel_francis@privacyrequired.com>

Before this commit, nla_strlcpy first memseted dst to 0 then wrote src into it.
This is inefficient because bytes whom number is less than src length are written
twice.

This patch solves this issue by first writing src into dst then fill dst with
0's.
Note that, in the case where src length is higher than dst, only 0 is written.
Otherwise there are as many 0's written to fill dst.

For example, if src is "foo\0" and dst is 5 bytes long, the result will be:
1. "fooGG" after memcpy (G means garbage).
2. "foo\0\0" after memset.

Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 lib/nlattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 74019c8ebf6b..07156e581997 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -731,8 +731,9 @@ size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize)
 	if (dstsize > 0) {
 		size_t len = (srclen >= dstsize) ? dstsize - 1 : srclen;
 
-		memset(dst, 0, dstsize);
 		memcpy(dst, src, len);
+		/* Zero pad end of dst. */
+		memset(dst + len, 0, dstsize - len);
 	}
 
 	return srclen;
-- 
2.20.1

