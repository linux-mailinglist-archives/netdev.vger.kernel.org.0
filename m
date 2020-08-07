Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D4523E8FD
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 10:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgHGIfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 04:35:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36581 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726511AbgHGIfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 04:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596789336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PjQsyo972jBXB2/eilIUlzA8PEGVZAXBOaZf9znBbfs=;
        b=KYt2vRqUytAx3z/141DYuAJuf8hQPf0Pora95k5KdOpI8D+6iJQuhBY15Uru50146MpNf+
        /1v/wsSNwROAUrNybhQhyct73E/ewKMGIuc61StCxkI9ya1yl9bxsmN77Mm5SW3mb+Dsyy
        j/invvUfbofE8mrhqWG6r84M/KUL3Jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-fOdHQlw-OOeqEvKVGIC9tA-1; Fri, 07 Aug 2020 04:35:34 -0400
X-MC-Unique: fOdHQlw-OOeqEvKVGIC9tA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C43F58;
        Fri,  7 Aug 2020 08:35:32 +0000 (UTC)
Received: from krava (unknown [10.40.194.188])
        by smtp.corp.redhat.com (Postfix) with SMTP id EFAAD65C88;
        Fri,  7 Aug 2020 08:35:28 +0000 (UTC)
Date:   Fri, 7 Aug 2020 10:35:28 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     KP Singh <kpsingh@chromium.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: Add d_path helper
Message-ID: <20200807083528.GA561444@krava>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-11-jolsa@kernel.org>
 <CACYkzJ57H391Xe20iGyHPkLWDumAcMuRu_oqV0ZzBPUOZBqNvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACYkzJ57H391Xe20iGyHPkLWDumAcMuRu_oqV0ZzBPUOZBqNvA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 02:31:52AM +0200, KP Singh wrote:
> On Sat, Aug 1, 2020 at 7:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding d_path helper function that returns full path for
> 
> [...]
> 
> > +}
> > +
> > +BTF_SET_START(btf_allowlist_d_path)
> > +BTF_ID(func, vfs_truncate)
> > +BTF_ID(func, vfs_fallocate)
> > +BTF_ID(func, dentry_open)
> > +BTF_ID(func, vfs_getattr)
> > +BTF_ID(func, filp_close)
> > +BTF_SET_END(btf_allowlist_d_path)
> > +
> 
> > +static bool bpf_d_path_allowed(const struct bpf_prog *prog)
> > +{
> > +       return btf_id_set_contains(&btf_allowlist_d_path, prog->aux->attach_btf_id);
> > +}
> 
> Can we allow it for LSM programs too?

yes, that's why I used struct bpf_prog as argument, so we could reach the
program type.. but I was hoping we could do that in follow up patchset,
because I assume there might be still some discussion about that?

I plan to post new version today

jirka

> 
> - KP
> 
> > +
> > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > +BTF_ID(struct, path)
> > +
> 
> [...]
> 
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > --
> > 2.25.4
> >
> 

