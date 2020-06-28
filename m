Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954C120CA06
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgF1TxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:53:11 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23204 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726685AbgF1TxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:53:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593373990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kjh6+7qkYOIN790UM7SJifYau+EcKXp+6OkRqmBfbI4=;
        b=hIH3iJjU2Gd4imT7afz+ZI2EhueFa0R3ONT4QWVMNDOGBP3fkRp/5dTfi8zvrkPjpTzB5n
        O1CzGKMj1AtsB4ZAcqigMbCIa+/fdsXBz4C8eDb/N1SZeXYsXMTeNWbmzVlO7nAZoRc72R
        MPTKyUyHo68oTCvcSqBGYjjGWXpy67E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-lJ05nxoLMyaso4bGpVCH0Q-1; Sun, 28 Jun 2020 15:53:00 -0400
X-MC-Unique: lJ05nxoLMyaso4bGpVCH0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBC091800D4A;
        Sun, 28 Jun 2020 19:52:58 +0000 (UTC)
Received: from krava (unknown [10.40.192.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id A82C15BAD6;
        Sun, 28 Jun 2020 19:52:55 +0000 (UTC)
Date:   Sun, 28 Jun 2020 21:52:54 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 06/14] bpf: Use BTF_ID to resolve
 bpf_ctx_convert struct
Message-ID: <20200628195254.GE2988321@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-7-jolsa@kernel.org>
 <2de85be7-0910-3129-b881-edbc2854d38e@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2de85be7-0910-3129-b881-edbc2854d38e@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:44:39PM -0700, Yonghong Song wrote:
> 
> 
> On 6/25/20 3:12 PM, Jiri Olsa wrote:
> > This way the ID is resolved during compile time,
> > and we can remove the runtime name search.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   kernel/bpf/btf.c | 12 ++++++++----
> >   1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 4da6b0770ff9..701a2cb5dfb2 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -18,6 +18,7 @@
> >   #include <linux/sort.h>
> >   #include <linux/bpf_verifier.h>
> >   #include <linux/btf.h>
> > +#include <linux/btf_ids.h>
> >   #include <linux/skmsg.h>
> >   #include <linux/perf_event.h>
> >   #include <net/sock.h>
> > @@ -3621,6 +3622,9 @@ static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
> >   	return kern_ctx_type->type;
> >   }
> > +BTF_ID_LIST(bpf_ctx_convert_btf_id)
> > +BTF_ID(struct, bpf_ctx_convert)
> > +
> >   struct btf *btf_parse_vmlinux(void)
> >   {
> >   	struct btf_verifier_env *env = NULL;
> > @@ -3659,10 +3663,10 @@ struct btf *btf_parse_vmlinux(void)
> >   	if (err)
> >   		goto errout;
> > -	/* find struct bpf_ctx_convert for type checking later */
> > -	btf_id = btf_find_by_name_kind(btf, "bpf_ctx_convert", BTF_KIND_STRUCT);
> > -	if (btf_id < 0) {
> > -		err = btf_id;
> > +	/* struct bpf_ctx_convert for type checking later */
> > +	btf_id = bpf_ctx_convert_btf_id[0];
> > +	if (btf_id <= 0) {
> 
> Just want to double check. Is it possible btf_id < 0 since previous patch
> did not check < 0?

right.. resolve_btfids would fail during linking,
so this is not necessary

thanks,
jirka

