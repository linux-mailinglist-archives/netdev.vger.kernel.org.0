Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7D510C5D2
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 10:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfK1JS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 04:18:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37878 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726227AbfK1JS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 04:18:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574932705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ivgRySp7HXdy74NVDZQ8z6ua1hfAKiRCI5B51vs3R4U=;
        b=S3TnHd5vlTeO4Fs6WVph3/Tv0Gb0aysxVSC/HNygJHNxPMFtKpuF2b/R4ZfbZfOUDd0wFf
        vJ95JWoW+O89EDEL7Mn+MOKNpGagz6iaDJhaFOij4ivqpprGoZi+/07jZhfJD/k37hP0wj
        qgHNn7DxtY4q102fc9zwYehJs/hVKZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-2XaMsMtDOA6P_pPZMaq-Uw-1; Thu, 28 Nov 2019 04:18:20 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 011F6800EBD;
        Thu, 28 Nov 2019 09:18:18 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id B84EE5D9E1;
        Thu, 28 Nov 2019 09:18:12 +0000 (UTC)
Date:   Thu, 28 Nov 2019 10:18:12 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [RFC] bpf: Emit audit messages upon successful prog load and
 unload
Message-ID: <20191128091812.GC1209@krava>
References: <20191128091633.29275-1-jolsa@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20191128091633.29275-1-jolsa@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 2XaMsMtDOA6P_pPZMaq-Uw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 10:16:32AM +0100, Jiri Olsa wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
>=20
> Allow for audit messages to be emitted upon BPF program load and
> unload for having a timeline of events. The load itself is in
> syscall context, so additional info about the process initiating
> the BPF prog creation can be logged and later directly correlated
> to the unload event.
>=20
> The only info really needed from BPF side is the globally unique
> prog ID where then audit user space tooling can query / dump all
> info needed about the specific BPF program right upon load event
> and enrich the record, thus these changes needed here can be kept
> small and non-intrusive to the core.
>=20
> Raw example output:
>=20
>   # auditctl -D
>   # auditctl -a always,exit -F arch=3Dx86_64 -S bpf
>   # ausearch --start recent -m 1334
>   ...
>   ----
>   time->Wed Nov 27 16:04:13 2019
>   type=3DPROCTITLE msg=3Daudit(1574867053.120:84664): proctitle=3D"./bpf"
>   type=3DSYSCALL msg=3Daudit(1574867053.120:84664): arch=3Dc000003e sysca=
ll=3D321   \
>     success=3Dyes exit=3D3 a0=3D5 a1=3D7ffea484fbe0 a2=3D70 a3=3D0 items=
=3D0 ppid=3D7477    \
>     pid=3D12698 auid=3D1001 uid=3D1001 gid=3D1001 euid=3D1001 suid=3D1001=
 fsuid=3D1001    \
>     egid=3D1001 sgid=3D1001 fsgid=3D1001 tty=3Dpts2 ses=3D4 comm=3D"bpf" =
               \
>     exe=3D"/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"             =
     \
>     subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(n=
ull)
>   type=3DUNKNOWN[1334] msg=3Daudit(1574867053.120:84664): prog-id=3D76 op=
=3DLOAD
>   ----
>   time->Wed Nov 27 16:04:13 2019
>   type=3DUNKNOWN[1334] msg=3Daudit(1574867053.120:84665): prog-id=3D76 op=
=3DUNLOAD
>   ...
>=20
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

fyi I prepared userspace changes:
  https://github.com/olsajiri/audit-userspace/commit/3108a81fa8d937f07b4c78=
be8ae00fcd3d64f94d
  https://github.com/olsajiri/audit-testsuite/commit/16888ea7f14fa0269feef6=
23d2a96f15f9ea71c9

I'll sumbit github PRs once the kernel change is pulled in

thanks,
jirka

