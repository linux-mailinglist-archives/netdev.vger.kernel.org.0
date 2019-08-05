Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC2826E4
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbfHEV3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 17:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729834AbfHEV3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:29:12 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F6E4216B7;
        Mon,  5 Aug 2019 21:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565040551;
        bh=45+cRqS8MNOxm6R+6LgHhyjb3IGQXlsBUzjj4gB6koA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B2BtE7x+J+uyPpX6iLy9TJ7q1IO7/7TGuEUF1zxg35LXOFCU9dR2zAY+KnsxNUY/Q
         lpVqvo97DgG+6mdKCeNL4ZbMEgBDvaTtV0TL2aNPObt3NbsA/1ZH7CyA5IgBPi6mil
         irLa1qdsuLYYsXMFiON96atqoy0nu+THLCRczHg0=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [WIP 2/4] bpf: Don't require mknod() permission to pin an object
Date:   Mon,  5 Aug 2019 14:29:03 -0700
Message-Id: <3bb110117c983f781f545e69ce35d4fcdd0c543b.1565040372.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1565040372.git.luto@kernel.org>
References: <cover.1565040372.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

security_path_mknod() seems excessive for pinning an object --
pinning an object is effectively just creating a file.  It's also
redundant, as vfs_mkobj() calls security_inode_create() by itself.

This isn't strictly required -- mknod(path, S_IFREG, unused) works
to create regular files, but bpf is currently the only user in the
kernel outside of mknod() itself that uses it to create regular
(i.e. S_IFREG) files.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/bpf/inode.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index cb07736b33ae..14304609003a 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -394,10 +394,6 @@ static int bpf_obj_do_pin(const struct filename *pathname, void *raw,
 
 	mode = S_IFREG | ((S_IRUSR | S_IWUSR) & ~current_umask());
 
-	ret = security_path_mknod(&path, dentry, mode, 0);
-	if (ret)
-		goto out;
-
 	dir = d_inode(path.dentry);
 	if (dir->i_op != &bpf_dir_iops) {
 		ret = -EPERM;
-- 
2.21.0

