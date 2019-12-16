Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4771511FF6C
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 09:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfLPIKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 03:10:04 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38888 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfLPIKD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 03:10:03 -0500
Received: by mail-qk1-f193.google.com with SMTP id k6so2181550qki.5
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 00:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MqbnFQHmZrpa0AOsiWXxCoFAk+GRpaNAI5iaz8ghDhM=;
        b=AfhJ9nsmFBX1MBqiprJE/IFswoBgJC23Yc1dCcmT9IbApkHHKTa1/PQO6jniHo07iD
         vqXapbUHNILm0dydcinlSq5ZZtAapZUhM3qm3M9P0t1aC2ONN9ik05hAbWDYxoylZkH8
         bgXzmqQSISsNPQdtUyAD2SSzyG9VEdMvXY7CebzwbHHqBTe4CndZtl0DQ/txUs1nnBiO
         mVz62wQRfVfYn6pB+D1clGCH8/YKZWUgukcbBq/Fr12LOWyq8LhBgIExdnbD5x5XzZ/i
         pFaOyYRG570PEfvvScn9rz8PrPToWjNlZxvUKS2+RfRIM1tq6KB0eqdYKd00yblPIOV6
         1A6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MqbnFQHmZrpa0AOsiWXxCoFAk+GRpaNAI5iaz8ghDhM=;
        b=KkGG16s8I44rMyuSsM/KtAikweqqxm7GJKCv1XeSlg7dMFImdw3OFB3iwKOtqdEB5t
         TSLp68M586KFFDAXkk3fflE9M+IjgjbVSga2bqF1rpZau0arZGFd4C3wGQObum2BeTtU
         /HwOIKaM2K4fBTU2jQqiLTl4rJ/GG6oU3IzSlEmkQC15PGlwUu01ZU6wi49ihp8n73tV
         kWbH3PXNwIkDtSNfkbxnCI9DAL775vGuuNb7VA9RIbXL3v6bIzoYiOV2HdXwcUawCDDP
         uyvvMO0SGpaUX4AP9fd6Jg6Q5o7DzsY3e4JnU0Ku1rrxOyg+c0JRljTvSM0Zp/ni7CgJ
         +ldA==
X-Gm-Message-State: APjAAAVD6nEptbGqFeFpmLyjT1eJ8UKvIFM+TciLy9DwClia44WwP+6y
        sYGn7fCK4DitXmRg3o98Kwtp1vZlaXkWJOzilJc8zg==
X-Google-Smtp-Source: APXvYqxy1jsjrgXIc9KkiY8dqe0Yevuy0Pq7KGGCsDx+L5LcYj27ueeWtQy3pwAK+PyyrQwyqiqzuK0wBqN53GRo1FA=
X-Received: by 2002:ae9:e50c:: with SMTP id w12mr23755470qkf.407.1576483802315;
 Mon, 16 Dec 2019 00:10:02 -0800 (PST)
MIME-Version: 1.0
References: <000000000000c71dcf0579b0553f@google.com> <000000000000dcc9b10599b3fd5e@google.com>
 <20191215063020.GA11512@mit.edu>
In-Reply-To: <20191215063020.GA11512@mit.edu>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 16 Dec 2019 09:09:51 +0100
Message-ID: <CACT4Y+Zk42DSpSYWjH5AdHEk5s_iJtpU9zm44kiW33zAu7CtBA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in ext4_xattr_set_entry (2)
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     syzbot <syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com>,
        a@unstable.cc, Andreas Dilger <adilger.kernel@dilger.ca>,
        afd@ti.com, b.a.t.m.a.n@lists.open-mesh.org, chris@lapa.com.au,
        David Miller <davem@davemloft.net>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        sre@kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 7:30 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Sat, Dec 14, 2019 at 05:27:00PM -0800, syzbot wrote:
> > syzbot has bisected this bug to:
> >
> > commit 8835cae5f2abd7f7a3143afe357f416aff5517a4
> > Author: Chris Lapa <chris@lapa.com.au>
> > Date:   Wed Jan 11 01:44:47 2017 +0000
> >
> >     power: supply: bq27xxx: adds specific support for bq27520-g4 revision.
>
> This is pretty clearly nonsense.

Agree.

FTR, it seems that bisection was first diverged by this kernel bug:

testing commit 8835cae5f2abd7f7a3143afe357f416aff5517a4 with gcc (GCC) 5.5.0
run #0: crashed: WARNING in batadv_mcast_mla_update

on top of this non-deterministic kernel build bug kicked in to prevent
detection of "culprit does not affect build":

culprit signature: 2aca06cd9a4175f124f866fe66467cfa96c0bf2a
parent  signature: 8a8dd9ca5726f129b6d36eb6e1f3b78cc7c18b31





>  However let's try this fix:
>
> #syz test: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git master
>
> From 9c962de70a52e0b24fba00ee7b8707964d3d1e37 Mon Sep 17 00:00:00 2001
> From: Theodore Ts'o <tytso@mit.edu>
> Date: Sun, 15 Dec 2019 01:09:03 -0500
> Subject: [PATCH] ext4: validate the debug_want_extra_isize mount option at parse time
>
> Instead of setting s_want_extra_size and then making sure that it is a
> valid value afterwards, validate the field before we set it.  This
> avoids races and other problems when remounting the file system.
>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Reported-by: syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com
> ---
>  fs/ext4/super.c | 143 +++++++++++++++++++++++-------------------------
>  1 file changed, 69 insertions(+), 74 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index b205112ca051..46b6d5b150ac 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1886,6 +1886,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>                 }
>                 sbi->s_commit_interval = HZ * arg;
>         } else if (token == Opt_debug_want_extra_isize) {
> +               if ((arg & 1) ||
> +                   (arg < 4) ||
> +                   (arg > (sbi->s_inode_size - EXT4_GOOD_OLD_INODE_SIZE))) {
> +                       ext4_msg(sb, KERN_ERR,
> +                                "Invalid want_extra_isize %d", arg);
> +                       return -1;
> +               }
>                 sbi->s_want_extra_isize = arg;
>         } else if (token == Opt_max_batch_time) {
>                 sbi->s_max_batch_time = arg;
> @@ -3540,40 +3547,6 @@ int ext4_calculate_overhead(struct super_block *sb)
>         return 0;
>  }
>
> -static void ext4_clamp_want_extra_isize(struct super_block *sb)
> -{
> -       struct ext4_sb_info *sbi = EXT4_SB(sb);
> -       struct ext4_super_block *es = sbi->s_es;
> -       unsigned def_extra_isize = sizeof(struct ext4_inode) -
> -                                               EXT4_GOOD_OLD_INODE_SIZE;
> -
> -       if (sbi->s_inode_size == EXT4_GOOD_OLD_INODE_SIZE) {
> -               sbi->s_want_extra_isize = 0;
> -               return;
> -       }
> -       if (sbi->s_want_extra_isize < 4) {
> -               sbi->s_want_extra_isize = def_extra_isize;
> -               if (ext4_has_feature_extra_isize(sb)) {
> -                       if (sbi->s_want_extra_isize <
> -                           le16_to_cpu(es->s_want_extra_isize))
> -                               sbi->s_want_extra_isize =
> -                                       le16_to_cpu(es->s_want_extra_isize);
> -                       if (sbi->s_want_extra_isize <
> -                           le16_to_cpu(es->s_min_extra_isize))
> -                               sbi->s_want_extra_isize =
> -                                       le16_to_cpu(es->s_min_extra_isize);
> -               }
> -       }
> -       /* Check if enough inode space is available */
> -       if ((sbi->s_want_extra_isize > sbi->s_inode_size) ||
> -           (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
> -                                                       sbi->s_inode_size)) {
> -               sbi->s_want_extra_isize = def_extra_isize;
> -               ext4_msg(sb, KERN_INFO,
> -                        "required extra inode space not available");
> -       }
> -}
> -
>  static void ext4_set_resv_clusters(struct super_block *sb)
>  {
>         ext4_fsblk_t resv_clusters;
> @@ -3781,6 +3754,68 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>          */
>         sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
>
> +       if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
> +               sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
> +               sbi->s_first_ino = EXT4_GOOD_OLD_FIRST_INO;
> +       } else {
> +               sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
> +               sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
> +               if (sbi->s_first_ino < EXT4_GOOD_OLD_FIRST_INO) {
> +                       ext4_msg(sb, KERN_ERR, "invalid first ino: %u",
> +                                sbi->s_first_ino);
> +                       goto failed_mount;
> +               }
> +               if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
> +                   (!is_power_of_2(sbi->s_inode_size)) ||
> +                   (sbi->s_inode_size > blocksize)) {
> +                       ext4_msg(sb, KERN_ERR,
> +                              "unsupported inode size: %d",
> +                              sbi->s_inode_size);
> +                       goto failed_mount;
> +               }
> +               /*
> +                * i_atime_extra is the last extra field available for
> +                * [acm]times in struct ext4_inode. Checking for that
> +                * field should suffice to ensure we have extra space
> +                * for all three.
> +                */
> +               if (sbi->s_inode_size >= offsetof(struct ext4_inode, i_atime_extra) +
> +                       sizeof(((struct ext4_inode *)0)->i_atime_extra)) {
> +                       sb->s_time_gran = 1;
> +                       sb->s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
> +               } else {
> +                       sb->s_time_gran = NSEC_PER_SEC;
> +                       sb->s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
> +               }
> +               sb->s_time_min = EXT4_TIMESTAMP_MIN;
> +       }
> +       if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
> +               sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
> +                       EXT4_GOOD_OLD_INODE_SIZE;
> +               if (ext4_has_feature_extra_isize(sb)) {
> +                       unsigned v, max = (sbi->s_inode_size -
> +                                          EXT4_GOOD_OLD_INODE_SIZE);
> +
> +                       v = le16_to_cpu(es->s_want_extra_isize);
> +                       if (v > max) {
> +                               ext4_msg(sb, KERN_ERR,
> +                                        "bad s_want_extra_isize: %d", v);
> +                               goto failed_mount;
> +                       }
> +                       if (sbi->s_want_extra_isize < v)
> +                               sbi->s_want_extra_isize = v;
> +
> +                       v = le16_to_cpu(es->s_min_extra_isize);
> +                       if (v > max) {
> +                               ext4_msg(sb, KERN_ERR,
> +                                        "bad s_min_extra_isize: %d", v);
> +                               goto failed_mount;
> +                       }
> +                       if (sbi->s_want_extra_isize < v)
> +                               sbi->s_want_extra_isize = v;
> +               }
> +       }
> +
>         if (sbi->s_es->s_mount_opts[0]) {
>                 char *s_mount_opts = kstrndup(sbi->s_es->s_mount_opts,
>                                               sizeof(sbi->s_es->s_mount_opts),
> @@ -4019,42 +4054,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>                                                       has_huge_files);
>         sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits, has_huge_files);
>
> -       if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
> -               sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
> -               sbi->s_first_ino = EXT4_GOOD_OLD_FIRST_INO;
> -       } else {
> -               sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
> -               sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
> -               if (sbi->s_first_ino < EXT4_GOOD_OLD_FIRST_INO) {
> -                       ext4_msg(sb, KERN_ERR, "invalid first ino: %u",
> -                                sbi->s_first_ino);
> -                       goto failed_mount;
> -               }
> -               if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
> -                   (!is_power_of_2(sbi->s_inode_size)) ||
> -                   (sbi->s_inode_size > blocksize)) {
> -                       ext4_msg(sb, KERN_ERR,
> -                              "unsupported inode size: %d",
> -                              sbi->s_inode_size);
> -                       goto failed_mount;
> -               }
> -               /*
> -                * i_atime_extra is the last extra field available for [acm]times in
> -                * struct ext4_inode. Checking for that field should suffice to ensure
> -                * we have extra space for all three.
> -                */
> -               if (sbi->s_inode_size >= offsetof(struct ext4_inode, i_atime_extra) +
> -                       sizeof(((struct ext4_inode *)0)->i_atime_extra)) {
> -                       sb->s_time_gran = 1;
> -                       sb->s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
> -               } else {
> -                       sb->s_time_gran = NSEC_PER_SEC;
> -                       sb->s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
> -               }
> -
> -               sb->s_time_min = EXT4_TIMESTAMP_MIN;
> -       }
> -
>         sbi->s_desc_size = le16_to_cpu(es->s_desc_size);
>         if (ext4_has_feature_64bit(sb)) {
>                 if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
> @@ -4503,8 +4502,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>         } else if (ret)
>                 goto failed_mount4a;
>
> -       ext4_clamp_want_extra_isize(sb);
> -
>         ext4_set_resv_clusters(sb);
>
>         err = ext4_setup_system_zone(sb);
> @@ -5292,8 +5289,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>                 goto restore_opts;
>         }
>
> -       ext4_clamp_want_extra_isize(sb);
> -
>         if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
>             test_opt(sb, JOURNAL_CHECKSUM)) {
>                 ext4_msg(sb, KERN_ERR, "changing journal_checksum "
> --
> 2.24.1
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/20191215063020.GA11512%40mit.edu.
