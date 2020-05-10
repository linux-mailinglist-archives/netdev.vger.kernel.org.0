Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5796D1CCD1A
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 20:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgEJSvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 14:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbgEJSvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 14:51:55 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0288E2082E;
        Sun, 10 May 2020 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589136715;
        bh=BCRbDK9r4jhbytE8sgO9FGzWEuSLseCNWey93X0Ha7w=;
        h=From:To:Cc:Subject:Date:From;
        b=Q2GHvBByU/TyGjuLFgGzUEebtvm8twfAoObCZbARhdipppjBu4AIwDcNKaxPuW87H
         o3SWTsCpLHeXii/a+yaubt+ceJ/LJ1iOvaKbE5xIxiWF/qhm79Ygem0NJTHYpR7RGn
         hakg8rJ5kfmLZR+6b3uSI6rV4sAsKUpeyoNR7bu8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] checkpatch: warn about uses of ENOTSUPP
Date:   Sun, 10 May 2020 11:51:48 -0700
Message-Id: <20200510185148.2230767-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENOTSUPP often feels like the right error code to use, but it's
in fact not a standard Unix error. E.g.:

$ python
>>> import errno
>>> errno.errorcode[errno.ENOTSUPP]
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: module 'errno' has no attribute 'ENOTSUPP'

There were numerous commits converting the uses back to EOPNOTSUPP
but in some cases we are stuck with the high error code for backward
compatibility reasons.

Let's try prevent more ENOTSUPPs from getting into the kernel.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Hi Joe, I feel like I already talked to you about this, but I lost
my email archive, so appologies if you already said no.

 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index eac40f0abd56..254877620bd8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4199,6 +4199,14 @@ sub process {
 			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
 		}
 
+# ENOTSUPP is not a standard error code and should be avoided.
+# Folks usually mean EOPNOTSUPP (also called ENOTSUP), when they type ENOTSUPP.
+# Similarly to ENOSYS warning a small number of false positives is expected.
+		if ($line =~ /\bENOTSUPP\b/) {
+			WARN("ENOTSUPP",
+			     "ENOTSUPP is not a standard error code, prefer EOPNOTSUPP.\n" . $herecurr);
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if ($perl_version_ok &&
-- 
2.25.4

