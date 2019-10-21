Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBB7DF77F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 23:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730387AbfJUViy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 17:38:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28058 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729388AbfJUViy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 17:38:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571693932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ydo/TL5LDscvwdIxWlFvz3d4kbBSbMTez/KsfHBMEM=;
        b=aW5eOUlpsUnlhg9LVoJ/+KqAWiJqJJ0rVV6jwt2GiW1hCAwVWjUf/tB/VSbSteyLZKNeGv
        XmVBldIXztH0/acGET+J7lY4Vmz+5k9KUtq/iStCaNNQUec493rWmVliWRgRZusCYnUZpV
        0Y4sa4imLjm76BYj9AsSB4X4x1sWPNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-2lBc4Mw4NFGMJ83795y3WA-1; Mon, 21 Oct 2019 17:38:49 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3658800D41;
        Mon, 21 Oct 2019 21:38:45 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2D4E1001B20;
        Mon, 21 Oct 2019 21:38:27 +0000 (UTC)
Date:   Mon, 21 Oct 2019 17:38:24 -0400
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
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Message-ID: <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca>
 <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 2lBc4Mw4NFGMJ83795y3WA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-21 15:53, Paul Moore wrote:
> On Fri, Oct 18, 2019 at 9:39 PM Richard Guy Briggs <rgb@redhat.com> wrote=
:
> > On 2019-09-18 21:22, Richard Guy Briggs wrote:
> > > Provide a mechanism similar to CAP_AUDIT_CONTROL to explicitly give a
> > > process in a non-init user namespace the capability to set audit
> > > container identifiers.
> > >
> > > Use audit netlink message types AUDIT_GET_CAPCONTID 1027 and
> > > AUDIT_SET_CAPCONTID 1028.  The message format includes the data
> > > structure:
> > > struct audit_capcontid_status {
> > >         pid_t   pid;
> > >         u32     enable;
> > > };
> >
> > Paul, can I get a review of the general idea here to see if you're ok
> > with this way of effectively extending CAP_AUDIT_CONTROL for the sake o=
f
> > setting contid from beyond the init user namespace where capable() can'=
t
> > reach and ns_capable() is meaningless for these purposes?
>=20
> I think my previous comment about having both the procfs and netlink
> interfaces apply here.  I don't see why we need two different APIs at
> the start; explain to me why procfs isn't sufficient.  If the argument
> is simply the desire to avoid mounting procfs in the container, how
> many container orchestrators can function today without a valid /proc?

Ok, sorry, I meant to address that question from a previous patch
comment at the same time.

It was raised by Eric Biederman that the proc filesystem interface for
audit had its limitations and he had suggested an audit netlink
interface made more sense.

The intent was to switch to the audit netlink interface for contid,
capcontid and to add the audit netlink interface for loginuid and
sessionid while deprecating the proc interface for loginuid and
sessionid.  This was alluded to in the cover letter, but not very clear,
I'm afraid.  I have patches to remove the contid and loginuid/sessionid
interfaces in another tree which is why I had forgotten to outline that
plan more explicitly in the cover letter.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

