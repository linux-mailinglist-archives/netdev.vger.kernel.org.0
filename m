Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAA320CABA
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 23:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgF1VUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 17:20:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36957 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726080AbgF1VUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 17:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593379228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PRgc2g0Ojg/UFEUY5mUxOQF8F4RTlNOReX7eEYTBsx0=;
        b=QD5gLQH9dStfjNQjw0rdrcP/guaun0DT9GVeb34DK1gfWRfov7APsw/5fcYOaKTP0dDQeN
        Hs35ELzwGWfYLZUdVSt8FFqhzXX4NKLW4YWq0l23ZQbONyXKb3vvQq/KZeJdRey69C/Wbk
        SidnA/rRfQpa7HzjYqoErDmvM1p3ERQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-kKf1MKz5MYKNWyxVqENnPw-1; Sun, 28 Jun 2020 17:20:26 -0400
X-MC-Unique: kKf1MKz5MYKNWyxVqENnPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B256818C35A0;
        Sun, 28 Jun 2020 21:20:24 +0000 (UTC)
Received: from krava (unknown [10.40.192.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2ED6C7166A;
        Sun, 28 Jun 2020 21:20:20 +0000 (UTC)
Date:   Sun, 28 Jun 2020 23:20:19 +0200
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
Subject: Re: [PATCH v4 bpf-next 05/14] bpf: Remove btf_id helpers resolving
Message-ID: <20200628212019.GH2988321@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-6-jolsa@kernel.org>
 <7480f7b2-01f0-f575-7e4f-cf3bde851c3f@fb.com>
 <20200628201608.GG2988321@krava>
 <7c0a5ea0-9425-071d-0f41-b7e5c5ef04f0@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c0a5ea0-9425-071d-0f41-b7e5c5ef04f0@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 01:59:54PM -0700, Yonghong Song wrote:

SNIP

> > > 
> > > The corresponding BTF_ID definition here is:
> > >    BTF_ID_LIST(bpf_skb_output_btf_ids)
> > >    BTF_ID(struct, sk_buff)
> > > 
> > > The bpf helper writer needs to ensure proper declarations
> > > of BTF_IDs like the above matching helpers definition.
> > > Support we have arg1 and arg3 as BTF_ID. then the list
> > > definition may be
> > > 
> > >    BTF_ID_LIST(bpf_skb_output_btf_ids)
> > >    BTF_ID(struct, sk_buff)
> > >    BTF_ID(struct, __unused)
> > >    BTF_ID(struct, task_struct)
> > > 
> > > This probably okay, I guess.
> > 
> > right, AFAIK we don't have such case yet, but would be good
> > to be ready and have something like
> > 
> >    BTF_ID(struct, __unused)
> > 
> > maybe adding new type for that will be better:
> > 
> >    BTF_ID(none, unused)
> 
> Maybe we can have a separate macro BTF_ID_UNUSED macro
> which simply adds 4 bytes hole in the .btf_ids* section.

right, we don't need symbols for that

jirka

