Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D436C118CAB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 16:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfLJPhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 10:37:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727615AbfLJPhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 10:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575992224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/UN284g7iI6B6yJziwS2LsAhtN9pj39NTYCrCHscB4=;
        b=R76oBbdK7ao0aB8dz2Xb5NZFFXVxHjW6kEy2a7Eu2IqoScXHxd/91K4jL6tjxD9Rcabn4W
        8mquOsDoQue3OXnbIhVQJbIBvOIzw6P8WFnnQDTEp40VdIkMITMC/sK/0SD+L56eqNyY/S
        iUE1cuYSVC2gt7WVohy6OBq34mIc9R4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280--O-3HyJBO6-0Xp0XTl8lgg-1; Tue, 10 Dec 2019 10:37:01 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D706800D41;
        Tue, 10 Dec 2019 15:36:59 +0000 (UTC)
Received: from krava (unknown [10.43.17.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 545566E3FF;
        Tue, 10 Dec 2019 15:36:54 +0000 (UTC)
Date:   Tue, 10 Dec 2019 16:36:52 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCHv3] bpf: Emit audit messages upon successful prog load and
 unload
Message-ID: <20191210153652.GA14123@krava>
References: <20191206214934.11319-1-jolsa@kernel.org>
 <20191209121537.GA14170@linux.fritz.box>
 <CAHC9VhQdOGTj1HT1cwvAdE1sRpzk5mC+oHQLHgJFa3vXEij+og@mail.gmail.com>
 <d387184e-9c5f-d5b2-0acb-57b794235cbd@iogearbox.net>
 <CAHC9VhRDsEDGripZRrVNcjEBEEULPk+0dRp-uJ3nmmBK7B=sYQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRDsEDGripZRrVNcjEBEEULPk+0dRp-uJ3nmmBK7B=sYQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: -O-3HyJBO6-0Xp0XTl8lgg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 06:53:23PM -0500, Paul Moore wrote:
> On Mon, Dec 9, 2019 at 6:19 PM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
> > On 12/9/19 3:56 PM, Paul Moore wrote:
> > > On Mon, Dec 9, 2019 at 7:15 AM Daniel Borkmann <daniel@iogearbox.net>=
 wrote:
> > >> On Fri, Dec 06, 2019 at 10:49:34PM +0100, Jiri Olsa wrote:
> > >>> From: Daniel Borkmann <daniel@iogearbox.net>
> > >>>
> > >>> Allow for audit messages to be emitted upon BPF program load and
> > >>> unload for having a timeline of events. The load itself is in
> > >>> syscall context, so additional info about the process initiating
> > >>> the BPF prog creation can be logged and later directly correlated
> > >>> to the unload event.
> > >>>
> > >>> The only info really needed from BPF side is the globally unique
> > >>> prog ID where then audit user space tooling can query / dump all
> > >>> info needed about the specific BPF program right upon load event
> > >>> and enrich the record, thus these changes needed here can be kept
> > >>> small and non-intrusive to the core.
> > >>>
> > >>> Raw example output:
> > >>>
> > >>>    # auditctl -D
> > >>>    # auditctl -a always,exit -F arch=3Dx86_64 -S bpf
> > >>>    # ausearch --start recent -m 1334
> > >>>    ...
> > >>>    ----
> > >>>    time->Wed Nov 27 16:04:13 2019
> > >>>    type=3DPROCTITLE msg=3Daudit(1574867053.120:84664): proctitle=3D=
"./bpf"
> > >>>    type=3DSYSCALL msg=3Daudit(1574867053.120:84664): arch=3Dc000003=
e syscall=3D321   \
> > >>>      success=3Dyes exit=3D3 a0=3D5 a1=3D7ffea484fbe0 a2=3D70 a3=3D0=
 items=3D0 ppid=3D7477    \
> > >>>      pid=3D12698 auid=3D1001 uid=3D1001 gid=3D1001 euid=3D1001 suid=
=3D1001 fsuid=3D1001    \
> > >>>      egid=3D1001 sgid=3D1001 fsgid=3D1001 tty=3Dpts2 ses=3D4 comm=
=3D"bpf"                \
> > >>>      exe=3D"/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"      =
            \
> > >>>      subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 k=
ey=3D(null)
> > >>>    type=3DUNKNOWN[1334] msg=3Daudit(1574867053.120:84664): prog-id=
=3D76 op=3DLOAD
> > >>>    ----
> > >>>    time->Wed Nov 27 16:04:13 2019
> > >>>    type=3DUNKNOWN[1334] msg=3Daudit(1574867053.120:84665): prog-id=
=3D76 op=3DUNLOAD
> > >>>    ...
> > >>>
> > >>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > >>> Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> > >>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > >>
> > >> Paul, Steve, given the merge window is closed by now, does this vers=
ion look
> > >> okay to you for proceeding to merge into bpf-next?
> > >
> > > Given the change to audit UAPI I was hoping to merge this via the
> > > audit/next tree, is that okay with you?
> >
> > Hm, my main concern is that given all the main changes are in BPF core =
and
> > usually the BPF subsystem has plenty of changes per release coming in t=
hat we'd
> > end up generating unnecessary merge conflicts. Given the include/uapi/l=
inux/audit.h
> > UAPI diff is a one-line change, my preference would be to merge via bpf=
-next with
> > your ACK or SOB added. Does that work for you as well as?
>=20
> I regularly (a few times a week) run the audit and SELinux tests
> against Linus+audit/next+selinux/next to make sure things are working
> as expected and that some other subsystem has introduced a change
> which has broken something.  If you are willing to ensure the tests
> get run, including your new BPF audit tests I would be okay with that;
> is that acceptable?

hi,
would you please let me know which tree this landed at the end?

thanks,
jirka

