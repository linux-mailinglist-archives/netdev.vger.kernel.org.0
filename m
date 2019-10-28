Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B332E713C
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 13:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731333AbfJ1MVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 08:21:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55726 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfJ1MVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 08:21:17 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-115f.dyn6.twc.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iP416-0002vS-W3; Mon, 28 Oct 2019 08:21:09 -0400
Date:   Mon, 28 Oct 2019 08:20:55 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        dwalsh@redhat.com, mpatel@redhat.com
Subject: Re: [PATCH ghak90 V7 04/21] audit: convert to contid list to check
 for orch/engine ownership
Message-ID: <20191028122055.GA27683@hmswarspite.think-freely.org>
References: <cover.1568834524.git.rgb@redhat.com>
 <6fb4e270bfafef3d0477a06b0365fdcc5a5305b5.1568834524.git.rgb@redhat.com>
 <20190926144629.GB7235@hmswarspite.think-freely.org>
 <20191025200019.vfd66aygccpf5yoe@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025200019.vfd66aygccpf5yoe@madcap2.tricolour.ca>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 04:00:19PM -0400, Richard Guy Briggs wrote:
> On 2019-09-26 10:46, Neil Horman wrote:
> > On Wed, Sep 18, 2019 at 09:22:21PM -0400, Richard Guy Briggs wrote:
> > > Store the audit container identifier in a refcounted kernel object that
> > > is added to the master list of audit container identifiers.  This will
> > > allow multiple container orchestrators/engines to work on the same
> > > machine without danger of inadvertantly re-using an existing identifier.
> > > It will also allow an orchestrator to inject a process into an existing
> > > container by checking if the original container owner is the one
> > > injecting the task.  A hash table list is used to optimize searches.
> > > 
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h | 26 ++++++++++++++--
> > >  kernel/audit.c        | 86 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > >  kernel/audit.h        |  8 +++++
> > >  3 files changed, 112 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index f2e3b81f2942..e317807cdd3e 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -95,10 +95,18 @@ struct audit_ntp_data {
> > >  struct audit_ntp_data {};
> > >  #endif
> > >  
> > > +struct audit_cont {
> > > +	struct list_head	list;
> > > +	u64			id;
> > > +	struct task_struct	*owner;
> > > +	refcount_t              refcount;
> > > +	struct rcu_head         rcu;
> > > +};
> > > +
> > >  struct audit_task_info {
> > >  	kuid_t			loginuid;
> > >  	unsigned int		sessionid;
> > > -	u64			contid;
> > > +	struct audit_cont	*cont;
> > >  #ifdef CONFIG_AUDITSYSCALL
> > >  	struct audit_context	*ctx;
> > >  #endif
> > > @@ -203,11 +211,15 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
> > >  
> > >  static inline u64 audit_get_contid(struct task_struct *tsk)
> > >  {
> > > -	if (!tsk->audit)
> > > +	if (!tsk->audit || !tsk->audit->cont)
> > >  		return AUDIT_CID_UNSET;
> > > -	return tsk->audit->contid;
> > > +	return tsk->audit->cont->id;
> > >  }
> > >  
> > > +extern struct audit_cont *audit_cont(struct task_struct *tsk);
> > > +
> > > +extern void audit_cont_put(struct audit_cont *cont);
> > > +
> > I see that you manual increment this refcount at various call sites, why
> > no corresponding audit_contid_hold function?
> 
> I was trying to avoid the get function due to having one site where I
> needed the pointer for later but didn't need a refcount to it so that I
> could release the refcount it if it was replaced by another cont object.
> A hold function would just contain one line that would call the
> refcount_inc().  If I did convert things over to a get function, it
> would hide some of this extra conditional code in the main calling
> function, but in one place I could just call put immediately to
> neutralize that unneeded refcount.
> 
Ok, but this pattern:

static inline u64 __audit_contid_get(struct audit_cont *c) {
        return c->id;
}

audit_contid_get(struct audit_cont *c) {
        refcount_hold(c)
        return __audit_contid_get(c)
}

Squares that up, doesn't it?  It gives you an internal non refcount
holding version then to use.

> Would you see any issue with that extra get/put refcount that would only
> happen in the case of changing a contid in a nesting situation?
> 
No, I personally wouldn't have an issue with it, but the above would
make it pretty readable I think

> > Neil
> > 
> > >  extern u32 audit_enabled;
> > >  
> > >  extern int audit_signal_info(int sig, struct task_struct *t);
> > > @@ -277,6 +289,14 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
> > >  	return AUDIT_CID_UNSET;
> > >  }
> > >  
> > > +static inline struct audit_cont *audit_cont(struct task_struct *tsk)
> > > +{
> > > +	return NULL;
> > > +}
> > > +
> > > +static inline void audit_cont_put(struct audit_cont *cont)
> > > +{ }
> > > +
> > >  #define audit_enabled AUDIT_OFF
> > >  
> > >  static inline int audit_signal_info(int sig, struct task_struct *t)
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index a36ea57cbb61..ea0899130cc1 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -137,6 +137,8 @@ struct audit_net {
> > >  
> > >  /* Hash for inode-based rules */
> > >  struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
> > > +/* Hash for contid-based rules */
> > > +struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
> > >  
> > >  static struct kmem_cache *audit_buffer_cache;
> > >  
> > > @@ -204,6 +206,8 @@ struct audit_reply {
> > >  
> > >  static struct kmem_cache *audit_task_cache;
> > >  
> > > +static DEFINE_SPINLOCK(audit_contid_list_lock);
> > > +
> > >  void __init audit_task_init(void)
> > >  {
> > >  	audit_task_cache = kmem_cache_create("audit_task",
> > > @@ -231,7 +235,9 @@ int audit_alloc(struct task_struct *tsk)
> > >  	}
> > >  	info->loginuid = audit_get_loginuid(current);
> > >  	info->sessionid = audit_get_sessionid(current);
> > > -	info->contid = audit_get_contid(current);
> > > +	info->cont = audit_cont(current);
> > > +	if (info->cont)
> > > +		refcount_inc(&info->cont->refcount);
> > >  	tsk->audit = info;
> > >  
> > >  	ret = audit_alloc_syscall(tsk);
> > > @@ -246,7 +252,7 @@ int audit_alloc(struct task_struct *tsk)
> > >  struct audit_task_info init_struct_audit = {
> > >  	.loginuid = INVALID_UID,
> > >  	.sessionid = AUDIT_SID_UNSET,
> > > -	.contid = AUDIT_CID_UNSET,
> > > +	.cont = NULL,
> > >  #ifdef CONFIG_AUDITSYSCALL
> > >  	.ctx = NULL,
> > >  #endif
> > > @@ -266,6 +272,9 @@ void audit_free(struct task_struct *tsk)
> > >  	/* Freeing the audit_task_info struct must be performed after
> > >  	 * audit_log_exit() due to need for loginuid and sessionid.
> > >  	 */
> > > +	spin_lock(&audit_contid_list_lock); 
> > > +	audit_cont_put(tsk->audit->cont);
> > > +	spin_unlock(&audit_contid_list_lock); 
> > >  	info = tsk->audit;
> > >  	tsk->audit = NULL;
> > >  	kmem_cache_free(audit_task_cache, info);
> > > @@ -1657,6 +1666,9 @@ static int __init audit_init(void)
> > >  	for (i = 0; i < AUDIT_INODE_BUCKETS; i++)
> > >  		INIT_LIST_HEAD(&audit_inode_hash[i]);
> > >  
> > > +	for (i = 0; i < AUDIT_CONTID_BUCKETS; i++)
> > > +		INIT_LIST_HEAD(&audit_contid_hash[i]);
> > > +
> > >  	mutex_init(&audit_cmd_mutex.lock);
> > >  	audit_cmd_mutex.owner = NULL;
> > >  
> > > @@ -2356,6 +2368,32 @@ int audit_signal_info(int sig, struct task_struct *t)
> > >  	return audit_signal_info_syscall(t);
> > >  }
> > >  
> > > +struct audit_cont *audit_cont(struct task_struct *tsk)
> > > +{
> > > +	if (!tsk->audit || !tsk->audit->cont)
> > > +		return NULL;
> > > +	return tsk->audit->cont;
> > > +}
> > > +
> > > +/* audit_contid_list_lock must be held by caller */
> > > +void audit_cont_put(struct audit_cont *cont)
> > > +{
> > > +	if (!cont)
> > > +		return;
> > > +	if (refcount_dec_and_test(&cont->refcount)) {
> > > +		put_task_struct(cont->owner);
> > > +		list_del_rcu(&cont->list);
> > > +		kfree_rcu(cont, rcu);
> > > +	}
> > > +}
> > > +
> > > +static struct task_struct *audit_cont_owner(struct task_struct *tsk)
> > > +{
> > > +	if (tsk->audit && tsk->audit->cont)
> > > +		return tsk->audit->cont->owner;
> > > +	return NULL;
> > > +}
> > > +
> > >  /*
> > >   * audit_set_contid - set current task's audit contid
> > >   * @task: target task
> > > @@ -2382,9 +2420,12 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >  	}
> > >  	oldcontid = audit_get_contid(task);
> > >  	read_lock(&tasklist_lock);
> > > -	/* Don't allow the audit containerid to be unset */
> > > +	/* Don't allow the contid to be unset */
> > >  	if (!audit_contid_valid(contid))
> > >  		rc = -EINVAL;
> > > +	/* Don't allow the contid to be set to the same value again */
> > > +	else if (contid == oldcontid) {
> > > +		rc = -EADDRINUSE;
> > >  	/* if we don't have caps, reject */
> > >  	else if (!capable(CAP_AUDIT_CONTROL))
> > >  		rc = -EPERM;
> > > @@ -2397,8 +2438,43 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >  	else if (audit_contid_set(task))
> > >  		rc = -ECHILD;
> > >  	read_unlock(&tasklist_lock);
> > > -	if (!rc)
> > > -		task->audit->contid = contid;
> > > +	if (!rc) {
> > > +		struct audit_cont *oldcont = audit_cont(task);
> > > +		struct audit_cont *cont = NULL;
> > > +		struct audit_cont *newcont = NULL;
> > > +		int h = audit_hash_contid(contid);
> > > +
> > > +		spin_lock(&audit_contid_list_lock);
> > > +		list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> > > +			if (cont->id == contid) {
> > > +				/* task injection to existing container */
> > > +				if (current == cont->owner) {
> > > +					refcount_inc(&cont->refcount);
> > > +					newcont = cont;
> > > +				} else {
> > > +					rc = -ENOTUNIQ;
> > > +					goto conterror;
> > > +				}
> > > +			}
> > > +		if (!newcont) {
> > > +			newcont = kmalloc(sizeof(struct audit_cont), GFP_ATOMIC);
> > > +			if (newcont) {
> > > +				INIT_LIST_HEAD(&newcont->list);
> > > +				newcont->id = contid;
> > > +				get_task_struct(current);
> > > +				newcont->owner = current;
> > > +				refcount_set(&newcont->refcount, 1);
> > > +				list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> > > +			} else {
> > > +				rc = -ENOMEM;
> > > +				goto conterror;
> > > +			}
> > > +		}
> > > +		task->audit->cont = newcont;
> > > +		audit_cont_put(oldcont);
> > > +conterror:
> > > +		spin_unlock(&audit_contid_list_lock);
> > > +	}
> > >  	task_unlock(task);
> > >  
> > >  	if (!audit_enabled)
> > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > index 16bd03b88e0d..e4a31aa92dfe 100644
> > > --- a/kernel/audit.h
> > > +++ b/kernel/audit.h
> > > @@ -211,6 +211,14 @@ static inline int audit_hash_ino(u32 ino)
> > >  	return (ino & (AUDIT_INODE_BUCKETS-1));
> > >  }
> > >  
> > > +#define AUDIT_CONTID_BUCKETS	32
> > > +extern struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
> > > +
> > > +static inline int audit_hash_contid(u64 contid)
> > > +{
> > > +	return (contid & (AUDIT_CONTID_BUCKETS-1));
> > > +}
> > > +
> > >  /* Indicates that audit should log the full pathname. */
> > >  #define AUDIT_NAME_FULL -1
> > >  
> > > -- 
> > > 1.8.3.1
> > > 
> > > 
> 
> - RGB
> 
> --
> Richard Guy Briggs <rgb@redhat.com>
> Sr. S/W Engineer, Kernel Security, Base Operating Systems
> Remote, Ottawa, Red Hat Canada
> IRC: rgb, SunRaycer
> Voice: +1.647.777.2635, Internal: (81) 32635
> 
> 
