Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6049344A72
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhCVQEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:04:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231759AbhCVQD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4428761998;
        Mon, 22 Mar 2021 16:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429036;
        bh=yFqEt0Vza9xx1ZEH6vpmadF/s9WD+9cr+PvfYFx1jTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnY2VvcIHWNR00CmYsS8o9sdpXW8IfqlUTn3pfDogyHxX/SIITlr8SG6GxkT3eSRZ
         a7K8jLXsPna4Mm190+MpWcuBICb/n+i193Sgx5UJVnr/NQaks4zNGBOOkdJN7kk+Zx
         IrtL2gHR1/fBjD9NvgLiYwkQqQ/EKWhfodExGrNMHcxDZouSH1dybJZC/EbBnOcXm9
         XQLG8dt1bjMaDOofLpAx013Fhy9k111G7DuVnc/32l3avRksgUDzsBf0x12znYeUYk
         RAdBhG+/y/EhxEsBwjpyhm77vbHfFV6Wbj7ETM5qbIRB/4/X2e34tKnfe8hgDnqlGY
         gToo1OwJ8lpqg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jmorris@namei.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        Ning Sun <ning.sun@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Tycho Andersen <tycho@tycho.pizza>
Subject: [PATCH 03/11] security: commoncap: fix -Wstringop-overread warning
Date:   Mon, 22 Mar 2021 17:02:41 +0100
Message-Id: <20210322160253.4032422-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 introdces a harmless warning for cap_inode_getsecurity:

security/commoncap.c: In function ‘cap_inode_getsecurity’:
security/commoncap.c:440:33: error: ‘memcpy’ reading 16 bytes from a region of size 0 [-Werror=stringop-overread]
  440 |                                 memcpy(&nscap->data, &cap->data, sizeof(__le32) * 2 * VFS_CAP_U32);
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The problem here is that tmpbuf is initialized to NULL, so gcc assumes
it is not accessible unless it gets set by vfs_getxattr_alloc().  This is
a legitimate warning as far as I can tell, but the code is correct since
it correctly handles the error when that function fails.

Add a separate NULL check to tell gcc about it as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 security/commoncap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 28f4d25480df..9a36ed6dd737 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -400,7 +400,7 @@ int cap_inode_getsecurity(struct user_namespace *mnt_userns,
 				      &tmpbuf, size, GFP_NOFS);
 	dput(dentry);
 
-	if (ret < 0)
+	if (ret < 0 || !tmpbuf)
 		return ret;
 
 	fs_ns = inode->i_sb->s_user_ns;
-- 
2.29.2

