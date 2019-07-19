Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6586E9CE
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730815AbfGSRGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:06:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbfGSRGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 13:06:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 622863C936;
        Fri, 19 Jul 2019 17:06:08 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-14.phx2.redhat.com [10.3.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 589471001B32;
        Fri, 19 Jul 2019 17:05:54 +0000 (UTC)
Date:   Fri, 19 Jul 2019 13:05:52 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, nhorman@tuxdriver.com
Subject: Re: [PATCH ghak90 V6 03/10] audit: read container ID of a process
Message-ID: <20190719170552.nflcuammq6cacgqs@madcap2.tricolour.ca>
References: <cover.1554732921.git.rgb@redhat.com>
 <cover.1554732921.git.rgb@redhat.com>
 <846df5e5bf5a49094fede082a2ace135ab6f5772.1554732921.git.rgb@redhat.com>
 <87d0i6dnag.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0i6dnag.fsf@xmission.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 19 Jul 2019 17:06:19 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-19 11:03, Eric W. Biederman wrote:
> Richard Guy Briggs <rgb@redhat.com> writes:
> 
> > Add support for reading the audit container identifier from the proc
> > filesystem.
> >
> > This is a read from the proc entry of the form
> > /proc/PID/audit_containerid where PID is the process ID of the task
> > whose audit container identifier is sought.
> >
> > The read expects up to a u64 value (unset: 18446744073709551615).
> >
> > This read requires CAP_AUDIT_CONTROL.
> 
> This scares me.    As this seems to make it easy to reuse an audit
> containerid for non-audit purporses.

At this point, given that capable(CAP_AUDIT_CONTROL) is not available to
any userspaced container orchestrator/engine, it is moot anywaysand we
will need another method.

> I would think it would be safer and easier to poke audit and ask it to
> log a message with your audit container id.

For it to be useful to a container orchestrator/engine, I think that
would depend on whether we are setting the value, or it is being
assigned by the kernel.  At this stage it is set by the orchestrator so
this could work.

> Eric
> 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > Acked-by: Serge Hallyn <serge@hallyn.com>
> > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  fs/proc/base.c | 25 ++++++++++++++++++++++---
> >  1 file changed, 22 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 43fd0c4b87de..acc70239d0cb 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -1211,7 +1211,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
> >  };
> >  
> >  #ifdef CONFIG_AUDIT
> > -#define TMPBUFLEN 11
> > +#define TMPBUFLEN 21
> >  static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
> >  				  size_t count, loff_t *ppos)
> >  {
> > @@ -1295,6 +1295,24 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
> >  	.llseek		= generic_file_llseek,
> >  };
> >  
> > +static ssize_t proc_contid_read(struct file *file, char __user *buf,
> > +				  size_t count, loff_t *ppos)
> > +{
> > +	struct inode *inode = file_inode(file);
> > +	struct task_struct *task = get_proc_task(inode);
> > +	ssize_t length;
> > +	char tmpbuf[TMPBUFLEN];
> > +
> > +	if (!task)
> > +		return -ESRCH;
> > +	/* if we don't have caps, reject */
> > +	if (!capable(CAP_AUDIT_CONTROL))
> > +		return -EPERM;
> > +	length = scnprintf(tmpbuf, TMPBUFLEN, "%llu", audit_get_contid(task));
> > +	put_task_struct(task);
> > +	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> > +}
> > +
> >  static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> >  				   size_t count, loff_t *ppos)
> >  {
> > @@ -1325,6 +1343,7 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> >  }
> >  
> >  static const struct file_operations proc_contid_operations = {
> > +	.read		= proc_contid_read,
> >  	.write		= proc_contid_write,
> >  	.llseek		= generic_file_llseek,
> >  };
> > @@ -3067,7 +3086,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
> >  #ifdef CONFIG_AUDIT
> >  	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
> >  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> > -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> > +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> >  #endif
> >  #ifdef CONFIG_FAULT_INJECTION
> >  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> > @@ -3466,7 +3485,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
> >  #ifdef CONFIG_AUDIT
> >  	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
> >  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> > -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> > +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> >  #endif
> >  #ifdef CONFIG_FAULT_INJECTION
> >  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
