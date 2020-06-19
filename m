Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D041E2009C2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732401AbgFSNQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:16:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28191 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732567AbgFSNQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592572602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cn/IgFlV5a9p139kru5VBf7uuCUJH4gRqnd0QpLi8Go=;
        b=NdWZYJRsm6/tjVGZ8jp/xUXRn0oZsjk9Knw7FT3fwKIlydFSMhSEvQS5EFPxFbaMNCvKPv
        hK/yEypGb63D33lvN+510ZCUBfJR24qGK4k+I8+//4b+0gqM+JJjEt3vH19d1fw3KvoFuQ
        WRUe0iWG5H6sxw5tRAp40mSmuPiTxLk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-Od4io1H_Mxuh7AV71NNihw-1; Fri, 19 Jun 2020 09:16:38 -0400
X-MC-Unique: Od4io1H_Mxuh7AV71NNihw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B4B48015CB;
        Fri, 19 Jun 2020 13:16:36 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id AE1B21CA;
        Fri, 19 Jun 2020 13:16:32 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:16:31 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 03/11] bpf: Add btf_ids object
Message-ID: <20200619131631.GE2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-4-jolsa@kernel.org>
 <CAEf4BzZ=BN7zDU_8xMEEoF7khjC4bwGitU+iYf+6uFXPZ_=u-g@mail.gmail.com>
 <CAEf4BzZivgf2r+tAnY4+cMTKN3dCb_M-PyVWL_ZSa7SY=x2efA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZivgf2r+tAnY4+cMTKN3dCb_M-PyVWL_ZSa7SY=x2efA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 06:06:49PM -0700, Andrii Nakryiko wrote:

SNIP

> > > +/*
> > > + * The BTF_ID_LIST macro defines pure (unsorted) list
> > > + * of BTF IDs, with following layout:
> > > + *
> > > + * BTF_ID_LIST(list1)
> > > + * BTF_ID(type1, name1)
> > > + * BTF_ID(type2, name2)
> > > + *
> > > + * list1:
> > > + * __BTF_ID__type1__name1__1:
> > > + * .zero 4
> > > + * __BTF_ID__type2__name2__2:
> > > + * .zero 4
> > > + *
> > > + */
> > > +#define BTF_ID_LIST(name)                              \
> >
> > nit: btw, you call it a list here, but btfids tool talks about
> > "sorts". Maybe stick to consistent naming. Either "list" or "set"
> > seems to be appropriate. Set implies a sorted aspect a bit more, IMO.

so how about we keep BTF_ID_LIST as it is and rename
BTF_WHITELIST_* to BTF_SET_*

> >
> > > +asm(                                                   \
> > > +".pushsection " SECTION ",\"a\";               \n"     \
> > > +".global " #name ";                            \n"     \
> >
> > I was expecting to see reserved 4 bytes for list size? I also couldn't
> > find where btfids tool prepends it. From what I could understand, it
> > just assumed the first 4 bytes are the length prefix? Sorry if I'm
> > slow...
> 
> Never mind, this is different from whitelisting you do in patch #8.
> But now I'm curious how this list symbol gets its size correctly
> calculated?..

so the BTF_ID_LIST list does not care about the size,
each symbol in the 'list' gets resolved based on its
__BTF_ID__XX__symbol__XX symbol

the count is kept in BTF_WHITELIST_* list because we
need it to sort it and search in it

thanks,
jirka

