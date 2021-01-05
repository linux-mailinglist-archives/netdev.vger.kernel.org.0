Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A3A2EB3B1
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbhAETwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:52:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727923AbhAETwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:52:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609876241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iFhGX/boR597Qzif0ABlZ08czqgKgSHgMvsdLOdlXc0=;
        b=BRtk7aqTxtfIc8Qb57g4NGz5Af76wiauSHwjmqSz/QL9Zr65RHlCFtUsdzVrUNpuVyFuSz
        FLfDI2bCGKO1NTzP7R3UrjjkowHHGPHS9fRC6DYmpPiz25+igyyFDPdHGjDuQDaBOmQWng
        MzGKRCUiPYjjNQJlBcBv+XVfDnb0yVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-7S5NHi88OHe_eyxfpX3FMQ-1; Tue, 05 Jan 2021 14:50:37 -0500
X-MC-Unique: 7S5NHi88OHe_eyxfpX3FMQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B3D910054FF;
        Tue,  5 Jan 2021 19:50:35 +0000 (UTC)
Received: from krava (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with SMTP id 222CD62460;
        Tue,  5 Jan 2021 19:50:31 +0000 (UTC)
Date:   Tue, 5 Jan 2021 20:50:30 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Warn when having multiple
 IDs for single type
Message-ID: <20210105195030.GA936454@krava>
References: <20210105153944.951019-1-jolsa@kernel.org>
 <CAADnVQJSry=o-GOPT0XL0=qGrikz=TuP=Wx7fHyiQVjLqMcOxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJSry=o-GOPT0XL0=qGrikz=TuP=Wx7fHyiQVjLqMcOxA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 11:37:09AM -0800, Alexei Starovoitov wrote:
> On Tue, Jan 5, 2021 at 7:39 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The kernel image can contain multiple types (structs/unions)
> > with the same name. This causes distinct type hierarchies in
> > BTF data and makes resolve_btfids fail with error like:
> >
> >   BTFIDS  vmlinux
> > FAILED unresolved symbol udp6_sock
> >
> > as reported by Qais Yousef [1].
> >
> > This change adds warning when multiple types of the same name
> > are detected:
> >
> >   BTFIDS  vmlinux
> > WARN: multiple IDs found for 'file' (526, 113351)
> > WARN: multiple IDs found for 'sk_buff' (2744, 113958)
> >
> > We keep the lower ID for the given type instance and let the
> > build continue.
> 
> I think it would make sense to mention this decision in the warning.
> 'WARN: multiple IDs' is ambiguous and confusing when action is not specified.

ok, how about:

WARN: multiple IDs found for 'file': 526, 113351 - using 526

jirka

