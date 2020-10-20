Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1882D2940F3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395030AbgJTQ5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:57:12 -0400
Received: from devianza.investici.org ([198.167.222.108]:59621 "EHLO
        devianza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389442AbgJTQ5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 12:57:11 -0400
Received: from mx2.investici.org (unknown [127.0.0.1])
        by devianza.investici.org (Postfix) with ESMTP id 4CG00l1fLtz6vKg;
        Tue, 20 Oct 2020 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1603212455;
        bh=ADXGo30GAB9BIpk7uqaqEaVM/FjFskBOk0sHBVi75ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uopfpmiObaXru0l4Sn8uvOzarL9AAymsbXbb0tQa0lxRY2iao+WDlBedyDgYIHWyy
         +aw9/1gAvz2NAMFsFsjNGkgDrbCPk2I9Vsay+fu81o+XizDJxWau4VWjkVxAM/kV2n
         X00LMrceiR9KKwuDjaYsQErryh4BuOafv2cpGLOE=
Received: from [198.167.222.108] (mx2.investici.org [198.167.222.108]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CG00k6jFRz6vKf;
        Tue, 20 Oct 2020 16:47:34 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Francis Laniel <laniel_francis@privacyrequired.com>
Subject: [RFC][PATCH v3 1/3] Fix unefficient call to memset before memcpu in nla_strlcpy.
Date:   Tue, 20 Oct 2020 18:47:05 +0200
Message-Id: <20201020164707.30402-2-laniel_francis@privacyrequired.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201020164707.30402-1-laniel_francis@privacyrequired.com>
References: <20201020164707.30402-1-laniel_francis@privacyrequired.com>
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

