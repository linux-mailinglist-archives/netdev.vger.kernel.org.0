Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F7E5A2CC3
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbiHZQvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344919AbiHZQug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:50:36 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EABBE1A81;
        Fri, 26 Aug 2022 09:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661532534; x=1693068534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oNPV4BNVK8w46WC89R5F/TMeysI1ei1JoTS87dugVG4=;
  b=q0ABLHs/D8HGrZSrKfCNSD1SnHllNnJkXGXZrD+UVP/4Iz03V/7GULfI
   2uUFC8YqHFg1tKqzePmeqE4Fxqq9x6vDQU48ON296g6U8Kmu6A94K1WQe
   AYWVW67e6CxBggOUQj3ttpyvTzERY4F7asJyc13NmxDGITD5feVQqpry4
   M=;
X-IronPort-AV: E=Sophos;i="5.93,265,1654560000"; 
   d="scan'208";a="253268213"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 16:48:20 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com (Postfix) with ESMTPS id 7D9E3C0292;
        Fri, 26 Aug 2022 16:48:16 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 16:48:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.158) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 16:48:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <jlayton@kernel.org>
CC:     <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <keescook@chromium.org>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <linux-fsdevel@vger.kernel.org>, <mcgrof@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <yzaikin@google.com>
Subject: Re: [PATCH v1 net-next 01/13] fs/lock: Revive LOCK_MAND.
Date:   Fri, 26 Aug 2022 09:48:02 -0700
Message-ID: <20220826164802.95813-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <9312834e427a551479e1ad138b5085edaa395cdd.camel@kernel.org>
References: <9312834e427a551479e1ad138b5085edaa395cdd.camel@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.158]
X-ClientProxiedBy: EX13D43UWA004.ant.amazon.com (10.43.160.108) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jeff Layton <jlayton@kernel.org>
Date:   Fri, 26 Aug 2022 06:02:44 -0400
> On Thu, 2022-08-25 at 17:04 -0700, Kuniyuki Iwashima wrote:
> > The commit 90f7d7a0d0d6 ("locks: remove LOCK_MAND flock lock support")
> > removed LOCK_MAND support from the kernel because nothing checked the
> > flag, nor was there no use case.  This patch revives LOCK_MAND to
> > introduce a mandatory lock for read/write on /proc/sys.  Currently, it's
> > the only use case, so we added two changes while reverting the commit.
> > 
> > First, we used to allow any f_mode for LOCK_MAND, but now we don't get
> > it back.  Instead, we enforce being FMODE_READ|FMODE_WRITE as LOCK_SH
> > and LOCK_EX.
> > 
> > Second, when f_ops->flock() was called with LOCK_MAND, each function
> > returned -EOPNOTSUPP.  The following patch does not use f_ops->flock(),
> > so we put the validation before calling f_ops->flock().
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  fs/locks.c                       | 57 ++++++++++++++++++++------------
> >  include/uapi/asm-generic/fcntl.h |  5 ---
> >  2 files changed, 35 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/locks.c b/fs/locks.c
> > index c266cfdc3291..03ff10a3165e 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -421,6 +421,10 @@ static inline int flock_translate_cmd(int cmd) {
> >  	case LOCK_UN:
> >  		return F_UNLCK;
> >  	}
> > +
> > +	if (cmd & LOCK_MAND)
> > +		return cmd & (LOCK_MAND | LOCK_RW);
> > +
> >  	return -EINVAL;
> >  }
> >  
> > @@ -879,6 +883,10 @@ static bool flock_locks_conflict(struct file_lock *caller_fl,
> >  	if (caller_fl->fl_file == sys_fl->fl_file)
> >  		return false;
> >  
> > +	if (caller_fl->fl_type & LOCK_MAND ||
> > +	    sys_fl->fl_type & LOCK_MAND)
> > +		return true;
> > +
> >  	return locks_conflict(caller_fl, sys_fl);
> >  }
> >  
> > @@ -2077,9 +2085,7 @@ EXPORT_SYMBOL(locks_lock_inode_wait);
> >   *	- %LOCK_SH -- a shared lock.
> >   *	- %LOCK_EX -- an exclusive lock.
> >   *	- %LOCK_UN -- remove an existing lock.
> > - *	- %LOCK_MAND -- a 'mandatory' flock. (DEPRECATED)
> > - *
> > - *	%LOCK_MAND support has been removed from the kernel.
> > + *	- %LOCK_MAND -- a 'mandatory' flock. (only supported on /proc/sys/)
> >   */
> >  SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
> >  {
> > @@ -2087,19 +2093,6 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
> >  	struct file_lock fl;
> >  	struct fd f;
> >  
> > -	/*
> > -	 * LOCK_MAND locks were broken for a long time in that they never
> > -	 * conflicted with one another and didn't prevent any sort of open,
> > -	 * read or write activity.
> > -	 *
> > -	 * Just ignore these requests now, to preserve legacy behavior, but
> > -	 * throw a warning to let people know that they don't actually work.
> > -	 */
> > -	if (cmd & LOCK_MAND) {
> > -		pr_warn_once("Attempt to set a LOCK_MAND lock via flock(2). This support has been removed and the request ignored.\n");
> > -		return 0;
> > -	}
> > -
> >  	type = flock_translate_cmd(cmd & ~LOCK_NB);
> >  	if (type < 0)
> >  		return type;
> > @@ -2109,6 +2102,7 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
> >  	if (!f.file)
> >  		return error;
> >  
> > +	/* LOCK_MAND supports only read/write on proc_sysctl for now */
> >  	if (type != F_UNLCK && !(f.file->f_mode & (FMODE_READ | FMODE_WRITE)))
> >  		goto out_putf;
> >  
> > @@ -2122,12 +2116,18 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
> >  	if (can_sleep)
> >  		fl.fl_flags |= FL_SLEEP;
> >  
> > -	if (f.file->f_op->flock)
> > +	if (f.file->f_op->flock) {
> > +		if (cmd & LOCK_MAND) {
> > +			error = -EOPNOTSUPP;
> > +			goto out_putf;
> > +		}
> > +
> >  		error = f.file->f_op->flock(f.file,
> >  					    (can_sleep) ? F_SETLKW : F_SETLK,
> >  					    &fl);
> > -	else
> > +	} else {
> >  		error = locks_lock_file_wait(f.file, &fl);
> > +	}
> >  
> >   out_putf:
> >  	fdput(f);
> > @@ -2711,7 +2711,11 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
> >  		seq_printf(f, " %s ",
> >  			     (inode == NULL) ? "*NOINODE*" : "ADVISORY ");
> >  	} else if (IS_FLOCK(fl)) {
> > -		seq_puts(f, "FLOCK  ADVISORY  ");
> > +		if (fl->fl_type & LOCK_MAND) {
> > +			seq_puts(f, "FLOCK  MANDATORY ");
> > +		} else {
> > +			seq_puts(f, "FLOCK  ADVISORY  ");
> > +		}
> >  	} else if (IS_LEASE(fl)) {
> >  		if (fl->fl_flags & FL_DELEG)
> >  			seq_puts(f, "DELEG  ");
> > @@ -2727,10 +2731,19 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
> >  	} else {
> >  		seq_puts(f, "UNKNOWN UNKNOWN  ");
> >  	}
> > -	type = IS_LEASE(fl) ? target_leasetype(fl) : fl->fl_type;
> >  
> > -	seq_printf(f, "%s ", (type == F_WRLCK) ? "WRITE" :
> > -			     (type == F_RDLCK) ? "READ" : "UNLCK");
> > +	if (fl->fl_type & LOCK_MAND) {
> > +		seq_printf(f, "%s ",
> > +			   (fl->fl_type & LOCK_READ)
> > +			   ? (fl->fl_type & LOCK_WRITE) ? "RW   " : "READ "
> > +			   : (fl->fl_type & LOCK_WRITE) ? "WRITE" : "NONE ");
> > +	} else {
> > +		type = IS_LEASE(fl) ? target_leasetype(fl) : fl->fl_type;
> > +
> > +		seq_printf(f, "%s ", (type == F_WRLCK) ? "WRITE" :
> > +			   (type == F_RDLCK) ? "READ" : "UNLCK");
> > +	}
> > +
> >  	if (inode) {
> >  		/* userspace relies on this representation of dev_t */
> >  		seq_printf(f, "%d %02x:%02x:%lu ", fl_pid,
> > diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
> > index 1ecdb911add8..94fb8c6fd543 100644
> > --- a/include/uapi/asm-generic/fcntl.h
> > +++ b/include/uapi/asm-generic/fcntl.h
> > @@ -180,11 +180,6 @@ struct f_owner_ex {
> >  #define LOCK_NB		4	/* or'd with one of the above to prevent
> >  				   blocking */
> >  #define LOCK_UN		8	/* remove lock */
> > -
> > -/*
> > - * LOCK_MAND support has been removed from the kernel. We leave the symbols
> > - * here to not break legacy builds, but these should not be used in new code.
> > - */
> >  #define LOCK_MAND	32	/* This is a mandatory flock ... */
> >  #define LOCK_READ	64	/* which allows concurrent read operations */
> >  #define LOCK_WRITE	128	/* which allows concurrent write operations */
> 
> NACK.
> 
> This may break legacy userland code that sets LOCK_MAND on flock calls
> (e.g. old versions of samba).
> 
> If you want to add a new mechanism that does something similar with a
> new flag, then that may be possible, but please don't overload old flags
> that could still be used in the field with new meanings.

Exactly, that makes sense.
Thanks for feedback!


> If you do decide to use flock for this functionality (and I'm not sure
> this is a good idea),

Actually, the patch 1-2 were experimental to show all available options
(flock()'s latency vs unshare()'s memory cost), and I like unshare().
If both of them were unacceptable, I would have added clone() BPF hook.

But it seems unshare() works at least, I'll drop this part in the next
spin.

Thank you.


> then I'd also like to see a clear description of
> the semantics this provides.
> -- 
> Jeff Layton <jlayton@kernel.org>
