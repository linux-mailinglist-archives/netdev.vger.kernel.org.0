Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E3C152426
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 01:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBEAjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 19:39:51 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36358 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727494AbgBEAju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 19:39:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580863188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vVcjWGSIO/6HrV4SfXcKeCJavn13kL4kYAAWkT145to=;
        b=Kjc6S/SFv58vYefXKSod+MGbrzo8fVoQQYklNvJbswxoDlnpX1LYS2KG+pn1nFaH9PMunp
        dq3/TzQneonpk/yd9igPDz634TJxw6lbk+zzq1Wraa/n6AplggTafLT0q0D0hjRNQvHcw9
        NxJBNNs+Dy6K7MGM7PFmYKxujv24mPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-GYc-yhAzNTWtmmXelgC71A-1; Tue, 04 Feb 2020 19:39:46 -0500
X-MC-Unique: GYc-yhAzNTWtmmXelgC71A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 042521005513;
        Wed,  5 Feb 2020 00:39:45 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD3A9811F8;
        Wed,  5 Feb 2020 00:39:33 +0000 (UTC)
Date:   Tue, 4 Feb 2020 19:39:30 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Subject: Re: [PATCH ghak90 V8 16/16] audit: add capcontid to set contid
 outside init_user_ns
Message-ID: <20200205003930.2efpm4tvrisgmj4t@madcap2.tricolour.ca>
References: <cover.1577736799.git.rgb@redhat.com>
 <5941671b6b6b5de28ab2cc80e72f288cf83291d5.1577736799.git.rgb@redhat.com>
 <CAHC9VhQYXQp+C0EHwLuW50yUenfH4KF1xKQdS=bn_OzHfnFmmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQYXQp+C0EHwLuW50yUenfH4KF1xKQdS=bn_OzHfnFmmg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-22 16:29, Paul Moore wrote:
> On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > process in a non-init user namespace the capability to set audit
> > container identifiers.
> >
> > Provide /proc/$PID/audit_capcontid interface to capcontid.
> > Valid values are: 1==enabled, 0==disabled
> 
> It would be good to be more explicit about "enabled" and "disabled" in
> the commit description.  For example, which setting allows the target
> task to set audit container IDs of it's children processes?

Ok...

> > Report this action in message type AUDIT_SET_CAPCONTID 1022 with fields
> > opid= capcontid= old-capcontid=
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  fs/proc/base.c             | 55 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/audit.h      | 14 ++++++++++++
> >  include/uapi/linux/audit.h |  1 +
> >  kernel/audit.c             | 35 +++++++++++++++++++++++++++++
> >  4 files changed, 105 insertions(+)
> 
> ...
> 
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 26091800180c..283ef8e006e7 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -1360,6 +1360,59 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> >         .write          = proc_contid_write,
> >         .llseek         = generic_file_llseek,
> >  };
> > +
> > +static ssize_t proc_capcontid_read(struct file *file, char __user *buf,
> > +                                 size_t count, loff_t *ppos)
> > +{
> > +       struct inode *inode = file_inode(file);
> > +       struct task_struct *task = get_proc_task(inode);
> > +       ssize_t length;
> > +       char tmpbuf[TMPBUFLEN];
> > +
> > +       if (!task)
> > +               return -ESRCH;
> > +       /* if we don't have caps, reject */
> > +       if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
> > +               return -EPERM;
> > +       length = scnprintf(tmpbuf, TMPBUFLEN, "%u", audit_get_capcontid(task));
> > +       put_task_struct(task);
> > +       return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> > +}
> > +
> > +static ssize_t proc_capcontid_write(struct file *file, const char __user *buf,
> > +                                  size_t count, loff_t *ppos)
> > +{
> > +       struct inode *inode = file_inode(file);
> > +       u32 capcontid;
> > +       int rv;
> > +       struct task_struct *task = get_proc_task(inode);
> > +
> > +       if (!task)
> > +               return -ESRCH;
> > +       if (*ppos != 0) {
> > +               /* No partial writes. */
> > +               put_task_struct(task);
> > +               return -EINVAL;
> > +       }
> > +
> > +       rv = kstrtou32_from_user(buf, count, 10, &capcontid);
> > +       if (rv < 0) {
> > +               put_task_struct(task);
> > +               return rv;
> > +       }
> > +
> > +       rv = audit_set_capcontid(task, capcontid);
> > +       put_task_struct(task);
> > +       if (rv < 0)
> > +               return rv;
> > +       return count;
> > +}
> > +
> > +static const struct file_operations proc_capcontid_operations = {
> > +       .read           = proc_capcontid_read,
> > +       .write          = proc_capcontid_write,
> > +       .llseek         = generic_file_llseek,
> > +};
> >  #endif
> >
> >  #ifdef CONFIG_FAULT_INJECTION
> > @@ -3121,6 +3174,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
> >         REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
> >         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> >         REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> > +       REG("audit_capcontainerid", S_IWUSR|S_IRUSR|S_IRUSR, proc_capcontid_operations),
> >  #endif
> >  #ifdef CONFIG_FAULT_INJECTION
> >         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> > @@ -3522,6 +3576,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
> >         REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
> >         REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> >         REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
> > +       REG("audit_capcontainerid", S_IWUSR|S_IRUSR|S_IRUSR, proc_capcontid_operations),
> >  #endif
> >  #ifdef CONFIG_FAULT_INJECTION
> >         REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 28b9c7cd86a6..62c453306c2a 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -116,6 +116,7 @@ struct audit_task_info {
> >         kuid_t                  loginuid;
> >         unsigned int            sessionid;
> >         struct audit_contobj    *cont;
> > +       u32                     capcontid;
> 
> Where is the code change that actually uses this to enforce the
> described policy on setting an audit container ID?

Oops, lost in shuffle of refactorisation when dumping the netlink code in
favour of /proc.

> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index 2844d78cd7af..01251e6dcec0 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -73,6 +73,7 @@
> >  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
> >  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and info */
> >  #define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sender */
> > +#define AUDIT_SET_CAPCONTID    1022    /* Set cap_contid of a task */
> >
> >  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
> >  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 1287f0b63757..1c22dd084ae8 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -2698,6 +2698,41 @@ static bool audit_contid_isowner(struct task_struct *tsk)
> >         return false;
> >  }
> >
> > +int audit_set_capcontid(struct task_struct *task, u32 enable)
> > +{
> > +       u32 oldcapcontid;
> > +       int rc = 0;
> > +       struct audit_buffer *ab;
> > +
> > +       if (!task->audit)
> > +               return -ENOPROTOOPT;
> > +       oldcapcontid = audit_get_capcontid(task);
> > +       /* if task is not descendant, block */
> > +       if (task == current)
> > +               rc = -EBADSLT;
> > +       else if (!task_is_descendant(current, task))
> > +               rc = -EXDEV;
> 
> See my previous comments about error code sanity.

I'll go with EXDEV.

> > +       else if (current_user_ns() == &init_user_ns) {
> > +               if (!capable(CAP_AUDIT_CONTROL) && !audit_get_capcontid(current))
> > +                       rc = -EPERM;
> 
> I think we just want to use ns_capable() in the context of the current
> userns to check CAP_AUDIT_CONTROL, yes?  Something like this ...

I thought we had firmly established in previous discussion that
CAP_AUDIT_CONTROL in anything other than init_user_ns was completely irrelevant
and untrustable.

>   if (current_user_ns() != &init_user_ns) {
>     if (!ns_capable(CAP_AUDIT_CONTROL) || !audit_get_capcontid())
>       rc = -EPERM;
>   } else if (!capable(CAP_AUDIT_CONTROL))
>     rc = -EPERM;
> 
> > +       }
> > +       if (!rc)
> > +               task->audit->capcontid = enable;
> > +
> > +       if (!audit_enabled)
> > +               return rc;
> > +
> > +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_SET_CAPCONTID);
> > +       if (!ab)
> > +               return rc;
> > +
> > +       audit_log_format(ab,
> > +                        "opid=%d capcontid=%u old-capcontid=%u",
> > +                        task_tgid_nr(task), enable, oldcapcontid);
> > +       audit_log_end(ab);
> 
> My prior comments about recording the success/failure, or not emitting
> the record on failure, seem relevant here too.

It should be recorded in the syscall record.

> > +       return rc;
> > +}
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

