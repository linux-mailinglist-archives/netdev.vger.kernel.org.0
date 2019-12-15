Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C0011F6AC
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 07:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfLOGaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 01:30:52 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47302 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbfLOGaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 01:30:52 -0500
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBF6UL5E023086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Dec 2019 01:30:21 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id EA22C4207DF; Sun, 15 Dec 2019 01:30:20 -0500 (EST)
Date:   Sun, 15 Dec 2019 01:30:20 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     syzbot <syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, adilger.kernel@dilger.ca, afd@ti.com,
        b.a.t.m.a.n@lists.open-mesh.org, chris@lapa.com.au,
        davem@davemloft.net, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, pali.rohar@gmail.com, sre@kernel.org,
        sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in ext4_xattr_set_entry (2)
Message-ID: <20191215063020.GA11512@mit.edu>
References: <000000000000c71dcf0579b0553f@google.com>
 <000000000000dcc9b10599b3fd5e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000dcc9b10599b3fd5e@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 05:27:00PM -0800, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 8835cae5f2abd7f7a3143afe357f416aff5517a4
> Author: Chris Lapa <chris@lapa.com.au>
> Date:   Wed Jan 11 01:44:47 2017 +0000
> 
>     power: supply: bq27xxx: adds specific support for bq27520-g4 revision.

This is pretty clearly nonsense.  However let's try this fix:

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git master

From 9c962de70a52e0b24fba00ee7b8707964d3d1e37 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 15 Dec 2019 01:09:03 -0500
Subject: [PATCH] ext4: validate the debug_want_extra_isize mount option at parse time

Instead of setting s_want_extra_size and then making sure that it is a
valid value afterwards, validate the field before we set it.  This
avoids races and other problems when remounting the file system.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-by: syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com
---
 fs/ext4/super.c | 143 +++++++++++++++++++++++-------------------------
 1 file changed, 69 insertions(+), 74 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b205112ca051..46b6d5b150ac 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1886,6 +1886,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		}
 		sbi->s_commit_interval = HZ * arg;
 	} else if (token == Opt_debug_want_extra_isize) {
+		if ((arg & 1) ||
+		    (arg < 4) ||
+		    (arg > (sbi->s_inode_size - EXT4_GOOD_OLD_INODE_SIZE))) {
+			ext4_msg(sb, KERN_ERR,
+				 "Invalid want_extra_isize %d", arg);
+			return -1;
+		}
 		sbi->s_want_extra_isize = arg;
 	} else if (token == Opt_max_batch_time) {
 		sbi->s_max_batch_time = arg;
@@ -3540,40 +3547,6 @@ int ext4_calculate_overhead(struct super_block *sb)
 	return 0;
 }
 
-static void ext4_clamp_want_extra_isize(struct super_block *sb)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_super_block *es = sbi->s_es;
-	unsigned def_extra_isize = sizeof(struct ext4_inode) -
-						EXT4_GOOD_OLD_INODE_SIZE;
-
-	if (sbi->s_inode_size == EXT4_GOOD_OLD_INODE_SIZE) {
-		sbi->s_want_extra_isize = 0;
-		return;
-	}
-	if (sbi->s_want_extra_isize < 4) {
-		sbi->s_want_extra_isize = def_extra_isize;
-		if (ext4_has_feature_extra_isize(sb)) {
-			if (sbi->s_want_extra_isize <
-			    le16_to_cpu(es->s_want_extra_isize))
-				sbi->s_want_extra_isize =
-					le16_to_cpu(es->s_want_extra_isize);
-			if (sbi->s_want_extra_isize <
-			    le16_to_cpu(es->s_min_extra_isize))
-				sbi->s_want_extra_isize =
-					le16_to_cpu(es->s_min_extra_isize);
-		}
-	}
-	/* Check if enough inode space is available */
-	if ((sbi->s_want_extra_isize > sbi->s_inode_size) ||
-	    (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
-							sbi->s_inode_size)) {
-		sbi->s_want_extra_isize = def_extra_isize;
-		ext4_msg(sb, KERN_INFO,
-			 "required extra inode space not available");
-	}
-}
-
 static void ext4_set_resv_clusters(struct super_block *sb)
 {
 	ext4_fsblk_t resv_clusters;
@@ -3781,6 +3754,68 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
 
+	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
+		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
+		sbi->s_first_ino = EXT4_GOOD_OLD_FIRST_INO;
+	} else {
+		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
+		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
+		if (sbi->s_first_ino < EXT4_GOOD_OLD_FIRST_INO) {
+			ext4_msg(sb, KERN_ERR, "invalid first ino: %u",
+				 sbi->s_first_ino);
+			goto failed_mount;
+		}
+		if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
+		    (!is_power_of_2(sbi->s_inode_size)) ||
+		    (sbi->s_inode_size > blocksize)) {
+			ext4_msg(sb, KERN_ERR,
+			       "unsupported inode size: %d",
+			       sbi->s_inode_size);
+			goto failed_mount;
+		}
+		/*
+		 * i_atime_extra is the last extra field available for
+		 * [acm]times in struct ext4_inode. Checking for that
+		 * field should suffice to ensure we have extra space
+		 * for all three.
+		 */
+		if (sbi->s_inode_size >= offsetof(struct ext4_inode, i_atime_extra) +
+			sizeof(((struct ext4_inode *)0)->i_atime_extra)) {
+			sb->s_time_gran = 1;
+			sb->s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
+		} else {
+			sb->s_time_gran = NSEC_PER_SEC;
+			sb->s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
+		}
+		sb->s_time_min = EXT4_TIMESTAMP_MIN;
+	}
+	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
+		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
+			EXT4_GOOD_OLD_INODE_SIZE;
+		if (ext4_has_feature_extra_isize(sb)) {
+			unsigned v, max = (sbi->s_inode_size -
+					   EXT4_GOOD_OLD_INODE_SIZE);
+
+			v = le16_to_cpu(es->s_want_extra_isize);
+			if (v > max) {
+				ext4_msg(sb, KERN_ERR,
+					 "bad s_want_extra_isize: %d", v);
+				goto failed_mount;
+			}
+			if (sbi->s_want_extra_isize < v)
+				sbi->s_want_extra_isize = v;
+
+			v = le16_to_cpu(es->s_min_extra_isize);
+			if (v > max) {
+				ext4_msg(sb, KERN_ERR,
+					 "bad s_min_extra_isize: %d", v);
+				goto failed_mount;
+			}
+			if (sbi->s_want_extra_isize < v)
+				sbi->s_want_extra_isize = v;
+		}
+	}
+
 	if (sbi->s_es->s_mount_opts[0]) {
 		char *s_mount_opts = kstrndup(sbi->s_es->s_mount_opts,
 					      sizeof(sbi->s_es->s_mount_opts),
@@ -4019,42 +4054,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 						      has_huge_files);
 	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits, has_huge_files);
 
-	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
-		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
-		sbi->s_first_ino = EXT4_GOOD_OLD_FIRST_INO;
-	} else {
-		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
-		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
-		if (sbi->s_first_ino < EXT4_GOOD_OLD_FIRST_INO) {
-			ext4_msg(sb, KERN_ERR, "invalid first ino: %u",
-				 sbi->s_first_ino);
-			goto failed_mount;
-		}
-		if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
-		    (!is_power_of_2(sbi->s_inode_size)) ||
-		    (sbi->s_inode_size > blocksize)) {
-			ext4_msg(sb, KERN_ERR,
-			       "unsupported inode size: %d",
-			       sbi->s_inode_size);
-			goto failed_mount;
-		}
-		/*
-		 * i_atime_extra is the last extra field available for [acm]times in
-		 * struct ext4_inode. Checking for that field should suffice to ensure
-		 * we have extra space for all three.
-		 */
-		if (sbi->s_inode_size >= offsetof(struct ext4_inode, i_atime_extra) +
-			sizeof(((struct ext4_inode *)0)->i_atime_extra)) {
-			sb->s_time_gran = 1;
-			sb->s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
-		} else {
-			sb->s_time_gran = NSEC_PER_SEC;
-			sb->s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
-		}
-
-		sb->s_time_min = EXT4_TIMESTAMP_MIN;
-	}
-
 	sbi->s_desc_size = le16_to_cpu(es->s_desc_size);
 	if (ext4_has_feature_64bit(sb)) {
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
@@ -4503,8 +4502,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	} else if (ret)
 		goto failed_mount4a;
 
-	ext4_clamp_want_extra_isize(sb);
-
 	ext4_set_resv_clusters(sb);
 
 	err = ext4_setup_system_zone(sb);
@@ -5292,8 +5289,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
-	ext4_clamp_want_extra_isize(sb);
-
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
-- 
2.24.1

