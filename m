Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91E9E543D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 21:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfJYTU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 15:20:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44949 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726265AbfJYTU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 15:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572031257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b4AyKgmfE6msyrF0y4ZsMwrJUW61YLBt7GbBRKBk9yQ=;
        b=Z4ggmgeUstdoIIEkl6OVJG2ubNEEa1nEz5Dto33Yyc+zvmaU9iU2S45QBrWb3CaBfY0Z3J
        dmLv41M82MgVpcjvPceBEfj+Fh9yoCrDpOFfvR68GRWykPkUpjzA0VxAUrWfQllLawyQUG
        ZBfngPgXUT74rpOZREvb5RZ8no9thPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-RryGXTfiNLSng7gCOjlTfA-1; Fri, 25 Oct 2019 15:20:50 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DF7480183E;
        Fri, 25 Oct 2019 19:20:48 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8614660167;
        Fri, 25 Oct 2019 19:20:34 +0000 (UTC)
Date:   Fri, 25 Oct 2019 15:20:31 -0400
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
Subject: Re: [PATCH ghak90 V7 08/21] audit: add contid support for signalling
 the audit daemon
Message-ID: <20191025192031.ul3yjy2q57vsvier@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <0850eaa785e2ff30c8c4818fd53e9544b34ed884.1568834524.git.rgb@redhat.com>
 <CAHC9VhQoFFaQACbV4QHG_NPUCJu1+V=x3=i-yyGjbsYq8HuPtg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQoFFaQACbV4QHG_NPUCJu1+V=x3=i-yyGjbsYq8HuPtg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: RryGXTfiNLSng7gCOjlTfA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-10 20:39, Paul Moore wrote:
> On Wed, Sep 18, 2019 at 9:25 PM Richard Guy Briggs <rgb@redhat.com> wrote=
:
> > Add audit container identifier support to the action of signalling the
> > audit daemon.
> >
> > Since this would need to add an element to the audit_sig_info struct,
> > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > audit_sig_info2 struct.  Corresponding support is required in the
> > userspace code to reflect the new record request and reply type.
> > An older userspace won't break since it won't know to request this
> > record type.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  include/linux/audit.h       |  7 +++++++
> >  include/uapi/linux/audit.h  |  1 +
> >  kernel/audit.c              | 28 ++++++++++++++++++++++++++++
> >  kernel/audit.h              |  1 +
> >  security/selinux/nlmsgtab.c |  1 +
> >  5 files changed, 38 insertions(+)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 0c18d8e30620..7b640c4da4ee 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -23,6 +23,13 @@ struct audit_sig_info {
> >         char            ctx[0];
> >  };
> >
> > +struct audit_sig_info2 {
> > +       uid_t           uid;
> > +       pid_t           pid;
> > +       u64             cid;
> > +       char            ctx[0];
> > +};
> > +
> >  struct audit_buffer;
> >  struct audit_context;
> >  struct inode;
> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index 4ed080f28b47..693ec6e0288b 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -72,6 +72,7 @@
> >  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or =
off */
> >  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabl=
ed */
> >  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and =
info */
> > +#define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sende=
r */
> >
> >  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly un=
interesting to kernel */
> >  #define AUDIT_USER_AVC         1107    /* We filter this differently *=
/
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index adfb3e6a7f0c..df3db29f5a8a 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -125,6 +125,7 @@ struct audit_net {
> >  kuid_t         audit_sig_uid =3D INVALID_UID;
> >  pid_t          audit_sig_pid =3D -1;
> >  u32            audit_sig_sid =3D 0;
> > +u64            audit_sig_cid =3D AUDIT_CID_UNSET;
> >
> >  /* Records can be lost in several ways:
> >     0) [suppressed in audit_alloc]
> > @@ -1094,6 +1095,7 @@ static int audit_netlink_ok(struct sk_buff *skb, =
u16 msg_type)
> >         case AUDIT_ADD_RULE:
> >         case AUDIT_DEL_RULE:
> >         case AUDIT_SIGNAL_INFO:
> > +       case AUDIT_SIGNAL_INFO2:
> >         case AUDIT_TTY_GET:
> >         case AUDIT_TTY_SET:
> >         case AUDIT_TRIM:
> > @@ -1257,6 +1259,7 @@ static int audit_receive_msg(struct sk_buff *skb,=
 struct nlmsghdr *nlh)
> >         struct audit_buffer     *ab;
> >         u16                     msg_type =3D nlh->nlmsg_type;
> >         struct audit_sig_info   *sig_data;
> > +       struct audit_sig_info2  *sig_data2;
> >         char                    *ctx =3D NULL;
> >         u32                     len;
> >
> > @@ -1516,6 +1519,30 @@ static int audit_receive_msg(struct sk_buff *skb=
, struct nlmsghdr *nlh)
> >                                  sig_data, sizeof(*sig_data) + len);
> >                 kfree(sig_data);
> >                 break;
> > +       case AUDIT_SIGNAL_INFO2:
> > +               len =3D 0;
> > +               if (audit_sig_sid) {
> > +                       err =3D security_secid_to_secctx(audit_sig_sid,=
 &ctx, &len);
> > +                       if (err)
> > +                               return err;
> > +               }
> > +               sig_data2 =3D kmalloc(sizeof(*sig_data2) + len, GFP_KER=
NEL);
> > +               if (!sig_data2) {
> > +                       if (audit_sig_sid)
> > +                               security_release_secctx(ctx, len);
> > +                       return -ENOMEM;
> > +               }
> > +               sig_data2->uid =3D from_kuid(&init_user_ns, audit_sig_u=
id);
> > +               sig_data2->pid =3D audit_sig_pid;
> > +               if (audit_sig_sid) {
> > +                       memcpy(sig_data2->ctx, ctx, len);
> > +                       security_release_secctx(ctx, len);
> > +               }
> > +               sig_data2->cid =3D audit_sig_cid;
> > +               audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
> > +                                sig_data2, sizeof(*sig_data2) + len);
> > +               kfree(sig_data2);
> > +               break;
> >         case AUDIT_TTY_GET: {
> >                 struct audit_tty_status s;
> >                 unsigned int t;
> > @@ -2384,6 +2411,7 @@ int audit_signal_info(int sig, struct task_struct=
 *t)
> >                 else
> >                         audit_sig_uid =3D uid;
> >                 security_task_getsecid(current, &audit_sig_sid);
> > +               audit_sig_cid =3D audit_get_contid(current);
> >         }
>=20
> I've been wondering something as I've been working my way through
> these patches and this patch seems like a good spot to discuss this
> ... Now that we have the concept of an audit container ID "lifetime"
> in the kernel, when do we consider the ID gone?  Is it when the last
> process in the container exits, or is it when we generate the last
> audit record which could possibly contain the audit container ID?
> This patch would appear to support the former, but if we wanted the
> latter we would need to grab a reference to the audit container ID
> struct so it wouldn't "die" on us before we could emit the signal info
> record.

Are you concerned with the availability of the data when the audit
signal info record is generated, when the kernel last deals with a
particular contid or when userspace thinks there will be no more
references to it?

I've got a bit of a dilemma with this one...

In fact, the latter situation you describe isn't a concern at present to
be able to deliver the information since the value is copied into the
audit signal global internal variables before the signalling task dies
and the audit signal info record is created from those copied (cached)
values when requested from userspace.

So the issue raised above I don't think is a problem.  However, patch 18
(which wasn't reviewed because it was a patch to a number of preceeding
patches) changes the reporting approach to give a chain of nested
contids which isn't reflected in the same level of reporting for the
audit signal patch/mechanism.  Solving this is a bit more complex.  We
could have the audit signal internal caching store a pointer to the
relevant container object and bump its refcount to ensure it doesn't
vanish until we are done with it, but the audit signal info binary
record format already has a variable length due to the selinux context
at the end of that struct and adding a second variable length element to
it would make it more complicated (but not impossible) to handle.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

