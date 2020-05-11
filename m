Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082D01CE0FF
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 18:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730729AbgEKQx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 12:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727874AbgEKQx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 12:53:28 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 880A8206D7;
        Mon, 11 May 2020 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589216007;
        bh=dam+wrisZkSDTYvLRv5tNOfLqS88LxqpLl5TR80UCVk=;
        h=From:To:Cc:Subject:Date:From;
        b=d8jO5YdLOxZDIhJGblPnmWACNyek/+jRk4BMNiwiEL6q3TsQ2CqFaNc/Nm7ntTT4L
         qM4+xSdjOHm3lx5p7N5wKSKj4jb/fBEeArcY2v2Yt1MrEhFDV5rGFktcqSPdr2CGfc
         9R0KiAH4YbnDO25W/RPpKdqokJC3lX9ro6oge+nI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joe Perches <joe@perches.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2] checkpatch: warn about uses of ENOTSUPP
Date:   Mon, 11 May 2020 09:53:19 -0700
Message-Id: <20200511165319.2251678-1-kuba@kernel.org>
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

Recent example:
https://lore.kernel.org/netdev/20200510182252.GA411829@lunn.ch/

v2 (Joe):
 - add a link to recent discussion,
 - don't match when scanning files, not patches to avoid sudden
   influx of conversion patches.

v1:
https://lore.kernel.org/netdev/20200510185148.2230767-1-kuba@kernel.org/

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 scripts/checkpatch.pl | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index eac40f0abd56..bfbdc869cd99 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4199,6 +4199,17 @@ sub process {
 			     "ENOSYS means 'invalid syscall nr' and nothing else\n" . $herecurr);
 		}
 
+# ENOTSUPP is not a standard error code and should be avoided in new patches.
+# Folks usually mean EOPNOTSUPP (also called ENOTSUP), when they type ENOTSUPP.
+# Similarly to ENOSYS warning a small number of false positives is expected.
+		if (~$file && $line =~ /\bENOTSUPP\b/) {
+			if (WARN("ENOTSUPP",
+				 "ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/\bENOTSUPP\b/EOPNOTSUPP/;
+			}
+		}
+
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if ($perl_version_ok &&
-- 
2.25.4

