Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD05109398
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 19:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfKYSiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 13:38:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53738 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727031AbfKYSit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 13:38:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574707128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R3RH8N0QS/qQQisGjQZQUD6VSu8VqJqcaqGnlmglgPQ=;
        b=SCzDA6QYUV1K6G0ZZyQ+AZbpsYWGXmq9D6Px1HvPw6YwjU9ldptLy9R5ACrQlrwYmXkQ/k
        PEjLcu+O8V3SbD6nUJpooJ9HjdM4d9OW/b/+innzNcNKug2/jpj0HM4XheUOgRpFRefpKi
        np2ZkcDzE4s/tnrxa85vn7Dl/yPTyJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-MnlgQCqFMayi0SM-rPToZA-1; Mon, 25 Nov 2019 13:38:44 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1905A18557C0;
        Mon, 25 Nov 2019 18:38:43 +0000 (UTC)
Received: from x2.localnet (ovpn-116-255.phx2.redhat.com [10.3.116.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF9755D6A0;
        Mon, 25 Nov 2019 18:38:38 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-audit@redhat.com, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and unload
Date:   Mon, 25 Nov 2019 13:38:38 -0500
Message-ID: <1862228.bWCyuaZ6x9@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhRi0JtKgHyAOdAJ=_--vL1VbK7BDq1FnRQ_GwW9P4J_zA@mail.gmail.com>
References: <20191120213816.8186-1-jolsa@kernel.org> <20191122192353.GA2157@krava> <CAHC9VhRi0JtKgHyAOdAJ=_--vL1VbK7BDq1FnRQ_GwW9P4J_zA@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: MnlgQCqFMayi0SM-rPToZA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Friday, November 22, 2019 4:19:55 PM EST Paul Moore wrote:
> On Fri, Nov 22, 2019 at 2:24 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > Paul,
> > would following output be ok:
> > 
> > type=SYSCALL msg=audit(1574445211.897:28015): arch=c000003e syscall=321
> > success=no exit=-13 a0=5 a1=7fff09ac6c60 a2=78 a3=6 items=0 ppid=1408
> > pid=9266 auid=1001 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
> > fsgid=0 tty=pts0 ses=1 comm="test_verifier"
> > exe="/home/jolsa/linux/tools/testing/selftests/bpf/test_verifier"
> > subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > key=(null)ARCH=x86_64 SYSCALL=bpf AUID="jolsa" UID="root" GID="root"
> > EUID="root" SUID="root" FSUID="root" EGID="root" SGID="root"
> > FSGID="root" type=PROCTITLE msg=audit(1574445211.897:28015):
> > proctitle="./test_verifier" type=BPF msg=audit(1574445211.897:28016):
> > prog-id=8103 event=LOAD
> > 
> > type=SYSCALL msg=audit(1574445211.897:28016): arch=c000003e syscall=321
> > success=yes exit=14 a0=5 a1=7fff09ac6b80 a2=78 a3=0 items=0 ppid=1408
> > pid=9266 auid=1001 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
> > fsgid=0 tty=pts0 ses=1 comm="test_verifier"
> > exe="/home/jolsa/linux/tools/testing/selftests/bpf/test_verifier"
> > subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > key=(null)ARCH=x86_64 SYSCALL=bpf AUID="jolsa" UID="root" GID="root"
> > EUID="root" SUID="root" FSUID="root" EGID="root" SGID="root"
> > FSGID="root" type=PROCTITLE msg=audit(1574445211.897:28016):
> > proctitle="./test_verifier" type=BPF msg=audit(1574445211.897:28017):
> > prog-id=8103 event=UNLOAD
>
> There is some precedence in using "op=" instead of "event=" (an audit
> "event" is already a thing, using "event=" here might get confusing).
> I suppose if we are getting really nit-picky you might want to
> lower-case the LOAD/UNLOAD, but generally Steve cares more about these
> things than I do.
> 
> For reference, we have a searchable database of fields here:
> *
> https://github.com/linux-audit/audit-documentation/blob/master/specs/field
> s/field-dictionary.csv

Paul's comments are correct. We generally use op for what operation is being 
performed. This approach looks better. This is fitting in with the audit way 
of doing things. I don't think there would be any user space issues adding 
support for the BPF record.

-Steve


