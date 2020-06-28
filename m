Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A0F20CA01
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgF1TvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:51:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57018 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726685AbgF1TvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:51:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593373861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aBt8TTLXBtA0AIspUHvTPZ2DOJfClH4KsrBMJCwxsDs=;
        b=c2S7vyOsWltbHVju52d5INZYck/bnR+wipkvsjX9WKQ8uFBsQ1v19+s4m9FnFUEUcrYD66
        GTHlxdxo/NWqEIrLdqajp5h/RhwFeokJj2DsArmZPDlejswViDfXXv7RM4lcRnTlbYZrz+
        mAxD0WKTA4K9fLbYHYpEWn4J8b+JK/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-OmoOoU0jOb6bf1Wiygkrgg-1; Sun, 28 Jun 2020 15:50:57 -0400
X-MC-Unique: OmoOoU0jOb6bf1Wiygkrgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F0738015F8;
        Sun, 28 Jun 2020 19:50:55 +0000 (UTC)
Received: from krava (unknown [10.40.192.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2C1895D9C9;
        Sun, 28 Jun 2020 19:50:51 +0000 (UTC)
Date:   Sun, 28 Jun 2020 21:50:51 +0200
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
Subject: Re: [PATCH v4 bpf-next 03/14] bpf: Add BTF_ID_LIST/BTF_ID macros
Message-ID: <20200628195051.GD2988321@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-4-jolsa@kernel.org>
 <CAEf4BzbceMFA60=7Jp7oC9x-gMvhKQtWmuhV3ncVKUhHHDzugA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbceMFA60=7Jp7oC9x-gMvhKQtWmuhV3ncVKUhHHDzugA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:32:48PM -0700, Andrii Nakryiko wrote:

SNIP

> 
> [...]
> 
> > diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
> > new file mode 100644
> > index 000000000000..f7f9dc4d9a9f
> > --- /dev/null
> > +++ b/include/linux/btf_ids.h
> > @@ -0,0 +1,69 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef _LINUX_BTF_IDS_H
> > +#define _LINUX_BTF_IDS_H 1
> 
> this "1", is it necessary? I think it's always just `#define HEADER_GUARD`?

I followed btf.h header:

#ifndef _LINUX_BTF_H
#define _LINUX_BTF_H 1

I don't mind changing it

> 
> > +
> > +#include <linux/compiler.h> /* for __PASTE */
> > +
> 
> [...]
> 
> > +#define __BTF_ID_LIST(name)                            \
> > +asm(                                                   \
> > +".pushsection " BTF_IDS_SECTION ",\"a\";       \n"     \
> > +".local " #name ";                             \n"     \
> > +#name ":;                                      \n"     \
> > +".popsection;                                  \n");   \
> > +
> > +#define BTF_ID_LIST(name)                              \
> > +__BTF_ID_LIST(name)                                    \
> > +extern int name[];
> 
> nit: extern u32 (or __u32) perhaps?

right, should be u32 

thanks,
jirka

