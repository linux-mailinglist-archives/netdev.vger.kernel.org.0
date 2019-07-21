Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5436F606
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 23:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfGUVct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 17:32:49 -0400
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:55905 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfGUVct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 17:32:49 -0400
Received: from smtp7.infomaniak.ch (smtp7.infomaniak.ch [83.166.132.30])
        by smtp-sh2.infomaniak.ch (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id x6LLVU5D253757
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Jul 2019 23:31:30 +0200
Received: from localhost (ns3096276.ip-94-23-54.eu [94.23.54.103])
        (authenticated bits=0)
        by smtp7.infomaniak.ch (8.14.5/8.14.5) with ESMTP id x6LLVRN8069488;
        Sun, 21 Jul 2019 23:31:28 +0200
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v10 01/10] fs,security: Add a new file access type: MAY_CHROOT
Date:   Sun, 21 Jul 2019 23:31:07 +0200
Message-Id: <20190721213116.23476-2-mic@digikod.net>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190721213116.23476-1-mic@digikod.net>
References: <20190721213116.23476-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For compatibility reason, MAY_CHROOT is always set with MAY_CHDIR.
However, this new flag enable to differentiate a chdir form a chroot.

This is needed for the Landlock LSM to be able to evaluate a new root
directory.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/open.c          | 3 ++-
 include/linux/fs.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index b5b80469b93d..e8767318fd03 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -494,7 +494,8 @@ int ksys_chroot(const char __user *filename)
 	if (error)
 		goto out;
 
-	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR);
+	error = inode_permission(path.dentry->d_inode, MAY_EXEC | MAY_CHDIR |
+			MAY_CHROOT);
 	if (error)
 		goto dput_and_out;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 75f2ed289a3f..7a0d92b1da85 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -99,6 +99,7 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define MAY_CHDIR		0x00000040
 /* called from RCU mode, don't block */
 #define MAY_NOT_BLOCK		0x00000080
+#define MAY_CHROOT		0x00000100
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.22.0

