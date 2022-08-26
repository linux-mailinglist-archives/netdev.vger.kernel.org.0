Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C553D5A255E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244764AbiHZKEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiHZKES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:04:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655D1DB072;
        Fri, 26 Aug 2022 03:02:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCB566069D;
        Fri, 26 Aug 2022 10:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B41AC433D6;
        Fri, 26 Aug 2022 10:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661508167;
        bh=6tZc+HdtC2LGDXx4SBFzI9/NzW3IhS4lGkdA6sNprVM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QN0LKyU3LqJDm3iKn7rxUUlUMBomvmObaOGTPouw07z9oeqiG3Fkfrpz999G/n+s2
         Sb/NbkXdqDOdG6RJYK7tDv8i6OEvQ5JtWjNQazwIM040uK/li2ffdpPUl8z1RRZ3Ju
         wbrr5/yRQ5dTyDSvdfVxr9+k0fH8Y4DdONPJUakAJWYTZAxv5Xit05Fu8O7zDqQspM
         lVAj7YCAp7HW8+QFdu58CdQMVmOjfayRwpVMqpDn8wpFz8q0w4BZ5L4jcSWlaMU5i8
         /kTCx0FpgikxoA6OgCbIvh4vNFDuixEyTn5taB0eqnJLWUVgK8B+uPViLAf9zDnwiE
         LotTyIwuj15Ng==
Message-ID: <9312834e427a551479e1ad138b5085edaa395cdd.camel@kernel.org>
Subject: Re: [PATCH v1 net-next 01/13] fs/lock: Revive LOCK_MAND.
From:   Jeff Layton <jlayton@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date:   Fri, 26 Aug 2022 06:02:44 -0400
In-Reply-To: <20220826000445.46552-2-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
         <20220826000445.46552-2-kuniyu@amazon.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-08-25 at 17:04 -0700, Kuniyuki Iwashima wrote:
> The commit 90f7d7a0d0d6 ("locks: remove LOCK_MAND flock lock support")
> removed LOCK_MAND support from the kernel because nothing checked the
> flag, nor was there no use case.  This patch revives LOCK_MAND to
> introduce a mandatory lock for read/write on /proc/sys.  Currently, it's
> the only use case, so we added two changes while reverting the commit.
>=20
> First, we used to allow any f_mode for LOCK_MAND, but now we don't get
> it back.  Instead, we enforce being FMODE_READ|FMODE_WRITE as LOCK_SH
> and LOCK_EX.
>=20
> Second, when f_ops->flock() was called with LOCK_MAND, each function
> returned -EOPNOTSUPP.  The following patch does not use f_ops->flock(),
> so we put the validation before calling f_ops->flock().
>=20
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  fs/locks.c                       | 57 ++++++++++++++++++++------------
>  include/uapi/asm-generic/fcntl.h |  5 ---
>  2 files changed, 35 insertions(+), 27 deletions(-)
>=20
> diff --git a/fs/locks.c b/fs/locks.c
> index c266cfdc3291..03ff10a3165e 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -421,6 +421,10 @@ static inline int flock_translate_cmd(int cmd) {
>  	case LOCK_UN:
>  		return F_UNLCK;
>  	}
> +
> +	if (cmd & LOCK_MAND)
> +		return cmd & (LOCK_MAND | LOCK_RW);
> +
>  	return -EINVAL;
>  }
> =20
> @@ -879,6 +883,10 @@ static bool flock_locks_conflict(struct file_lock *c=
aller_fl,
>  	if (caller_fl->fl_file =3D=3D sys_fl->fl_file)
>  		return false;
> =20
> +	if (caller_fl->fl_type & LOCK_MAND ||
> +	    sys_fl->fl_type & LOCK_MAND)
> +		return true;
> +
>  	return locks_conflict(caller_fl, sys_fl);
>  }
> =20
> @@ -2077,9 +2085,7 @@ EXPORT_SYMBOL(locks_lock_inode_wait);
>   *	- %LOCK_SH -- a shared lock.
>   *	- %LOCK_EX -- an exclusive lock.
>   *	- %LOCK_UN -- remove an existing lock.
> - *	- %LOCK_MAND -- a 'mandatory' flock. (DEPRECATED)
> - *
> - *	%LOCK_MAND support has been removed from the kernel.
> + *	- %LOCK_MAND -- a 'mandatory' flock. (only supported on /proc/sys/)
>   */
>  SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
>  {
> @@ -2087,19 +2093,6 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned =
int, cmd)
>  	struct file_lock fl;
>  	struct fd f;
> =20
> -	/*
> -	 * LOCK_MAND locks were broken for a long time in that they never
> -	 * conflicted with one another and didn't prevent any sort of open,
> -	 * read or write activity.
> -	 *
> -	 * Just ignore these requests now, to preserve legacy behavior, but
> -	 * throw a warning to let people know that they don't actually work.
> -	 */
> -	if (cmd & LOCK_MAND) {
> -		pr_warn_once("Attempt to set a LOCK_MAND lock via flock(2). This suppo=
rt has been removed and the request ignored.\n");
> -		return 0;
> -	}
> -
>  	type =3D flock_translate_cmd(cmd & ~LOCK_NB);
>  	if (type < 0)
>  		return type;
> @@ -2109,6 +2102,7 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned i=
nt, cmd)
>  	if (!f.file)
>  		return error;
> =20
> +	/* LOCK_MAND supports only read/write on proc_sysctl for now */
>  	if (type !=3D F_UNLCK && !(f.file->f_mode & (FMODE_READ | FMODE_WRITE))=
)
>  		goto out_putf;
> =20
> @@ -2122,12 +2116,18 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned=
 int, cmd)
>  	if (can_sleep)
>  		fl.fl_flags |=3D FL_SLEEP;
> =20
> -	if (f.file->f_op->flock)
> +	if (f.file->f_op->flock) {
> +		if (cmd & LOCK_MAND) {
> +			error =3D -EOPNOTSUPP;
> +			goto out_putf;
> +		}
> +
>  		error =3D f.file->f_op->flock(f.file,
>  					    (can_sleep) ? F_SETLKW : F_SETLK,
>  					    &fl);
> -	else
> +	} else {
>  		error =3D locks_lock_file_wait(f.file, &fl);
> +	}
> =20
>   out_putf:
>  	fdput(f);
> @@ -2711,7 +2711,11 @@ static void lock_get_status(struct seq_file *f, st=
ruct file_lock *fl,
>  		seq_printf(f, " %s ",
>  			     (inode =3D=3D NULL) ? "*NOINODE*" : "ADVISORY ");
>  	} else if (IS_FLOCK(fl)) {
> -		seq_puts(f, "FLOCK  ADVISORY  ");
> +		if (fl->fl_type & LOCK_MAND) {
> +			seq_puts(f, "FLOCK  MANDATORY ");
> +		} else {
> +			seq_puts(f, "FLOCK  ADVISORY  ");
> +		}
>  	} else if (IS_LEASE(fl)) {
>  		if (fl->fl_flags & FL_DELEG)
>  			seq_puts(f, "DELEG  ");
> @@ -2727,10 +2731,19 @@ static void lock_get_status(struct seq_file *f, s=
truct file_lock *fl,
>  	} else {
>  		seq_puts(f, "UNKNOWN UNKNOWN  ");
>  	}
> -	type =3D IS_LEASE(fl) ? target_leasetype(fl) : fl->fl_type;
> =20
> -	seq_printf(f, "%s ", (type =3D=3D F_WRLCK) ? "WRITE" :
> -			     (type =3D=3D F_RDLCK) ? "READ" : "UNLCK");
> +	if (fl->fl_type & LOCK_MAND) {
> +		seq_printf(f, "%s ",
> +			   (fl->fl_type & LOCK_READ)
> +			   ? (fl->fl_type & LOCK_WRITE) ? "RW   " : "READ "
> +			   : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");
> +	} else {
> +		type =3D IS_LEASE(fl) ? target_leasetype(fl) : fl->fl_type;
> +
> +		seq_printf(f, "%s ", (type =3D=3D F_WRLCK) ? "WRITE" :
> +			   (type =3D=3D F_RDLCK) ? "READ" : "UNLCK");
> +	}
> +
>  	if (inode) {
>  		/* userspace relies on this representation of dev_t */
>  		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/=
fcntl.h
> index 1ecdb911add8..94fb8c6fd543 100644
> --- a/include/uapi/asm-generic/fcntl.h
> +++ b/include/uapi/asm-generic/fcntl.h
> @@ -180,11 +180,6 @@ struct f_owner_ex {
>  #define LOCK_NB		4	/* or'd with one of the above to prevent
>  				   blocking */
>  #define LOCK_UN		8	/* remove lock */
> -
> -/*
> - * LOCK_MAND support has been removed from the kernel. We leave the symb=
ols
> - * here to not break legacy builds, but these should not be used in new =
code.
> - */
>  #define LOCK_MAND	32	/* This is a mandatory flock ... */
>  #define LOCK_READ	64	/* which allows concurrent read operations */
>  #define LOCK_WRITE	128	/* which allows concurrent write operations */

NACK.

This may break legacy userland code that sets LOCK_MAND on flock calls
(e.g. old versions of samba).

If you want to add a new mechanism that does something similar with a
new flag, then that may be possible, but please don't overload old flags
that could still be used in the field with new meanings.

If you do decide to use flock for this functionality (and I'm not sure
this is a good idea), then I'd also like to see a clear description of
the semantics this provides.
--=20
Jeff Layton <jlayton@kernel.org>
