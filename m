Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F602344A5B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhCVQFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231818AbhCVQE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:04:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D63E5619A4;
        Mon, 22 Mar 2021 16:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429066;
        bh=nkpO3F9iV2LP9C5b1X1yN1ZVysmYmotRTLuBUWIaptM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MU4IL9JNNK+J8U+vvpLpwovR+/suU+W9R4RhhhMaub4p/qt1HSm7/5H/LxJjfRA1v
         f+dccndcC0t+6DndIOBCJbVJvgtAFbUO/Xj+Ad4PAK3HRVGVN0VmdJVzwNG2nWP60W
         yoMi7GzhcMMul2Me0RQEOrAkh9+ikItIp0T7LrmMn4UxhxHfYhCqAAaad++VD478Ly
         WRurbxWp7EoqaQbB5aDSFB4iZyCpOkFivtOdus8BKdINgwMELaIsTcoM1dTXGsBCvO
         NUlZI47cRIaTlBnQpp36y5LIoHJRasVTH3KqfKgtuhF/A3Vph299qnut15q3EDnfE2
         ATElHLu2Uchbw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Anders Larsen <al@alarsen.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        Ning Sun <ning.sun@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 05/11] qnx: avoid -Wstringop-overread warning
Date:   Mon, 22 Mar 2021 17:02:43 +0100
Message-Id: <20210322160253.4032422-6-arnd@kernel.org>
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

gcc-11 warns that the size of the link name is longer than the di_fname
field:

fs/qnx4/dir.c: In function ‘qnx4_readdir’:
fs/qnx4/dir.c:51:32: error: ‘strnlen’ specified bound 48 exceeds source size 16 [-Werror=stringop-overread]
   51 |                         size = strnlen(de->di_fname, size);
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from fs/qnx4/qnx4.h:3,
                 from fs/qnx4/dir.c:16:
include/uapi/linux/qnx4_fs.h:45:25: note: source object declared here
   45 |         char            di_fname[QNX4_SHORT_NAME_MAX];

The problem here is that we access the same pointer using two different
structure layouts, but gcc determines the object size based on
whatever it encounters first.

Change the strnlen to use the correct field size in each case, and
change the first access to be on the longer field.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/qnx4/dir.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index a6ee23aadd28..68046450e543 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -39,21 +39,20 @@ static int qnx4_readdir(struct file *file, struct dir_context *ctx)
 		ix = (ctx->pos >> QNX4_DIR_ENTRY_SIZE_BITS) % QNX4_INODES_PER_BLOCK;
 		for (; ix < QNX4_INODES_PER_BLOCK; ix++, ctx->pos += QNX4_DIR_ENTRY_SIZE) {
 			offset = ix * QNX4_DIR_ENTRY_SIZE;
-			de = (struct qnx4_inode_entry *) (bh->b_data + offset);
-			if (!de->di_fname[0])
+			le = (struct qnx4_link_info *)(bh->b_data + offset);
+			de = (struct qnx4_inode_entry *)(bh->b_data + offset);
+			if (!le->dl_fname[0])
 				continue;
 			if (!(de->di_status & (QNX4_FILE_USED|QNX4_FILE_LINK)))
 				continue;
 			if (!(de->di_status & QNX4_FILE_LINK))
-				size = QNX4_SHORT_NAME_MAX;
+				size = strnlen(de->di_fname, sizeof(de->di_fname));
 			else
-				size = QNX4_NAME_MAX;
-			size = strnlen(de->di_fname, size);
+				size = strnlen(le->dl_fname, sizeof(le->dl_fname));
 			QNX4DEBUG((KERN_INFO "qnx4_readdir:%.*s\n", size, de->di_fname));
 			if (!(de->di_status & QNX4_FILE_LINK))
 				ino = blknum * QNX4_INODES_PER_BLOCK + ix - 1;
 			else {
-				le  = (struct qnx4_link_info*)de;
 				ino = ( le32_to_cpu(le->dl_inode_blk) - 1 ) *
 					QNX4_INODES_PER_BLOCK +
 					le->dl_inode_ndx;
-- 
2.29.2

