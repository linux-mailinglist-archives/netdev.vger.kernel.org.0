Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334EA20CA3B
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgF1Tzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:55:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58902 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726805AbgF1Tzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:55:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593374143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nfqPhF3lvN4h/B9bniqckxejp+wMT3NwRwz4gTOC/+0=;
        b=DgCsLZlA7PdQE9CgPDH3CG3ivRGX+kxH3goGZqibmajCOdqNDM1M7SrxdFRDCC5jma6nZ2
        8xqIva3iLS9KYjFjXeIaF7I8Pg8kaG/+9SnXyzuCtDLGf8t1D8a1ikkS2HexcZ0QdQixX1
        FMmN7Z1wuxb9Hoo+GLmq/idNzH3JcVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-56RVICpsN_aRuJuzkhhObg-1; Sun, 28 Jun 2020 15:55:39 -0400
X-MC-Unique: 56RVICpsN_aRuJuzkhhObg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45F521005513;
        Sun, 28 Jun 2020 19:55:37 +0000 (UTC)
Received: from krava (unknown [10.40.192.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id EF36196B62;
        Sun, 28 Jun 2020 19:55:33 +0000 (UTC)
Date:   Sun, 28 Jun 2020 21:55:33 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 13/14] selftests/bpf: Add test for d_path
 helper
Message-ID: <20200628195533.GF2988321@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-14-jolsa@kernel.org>
 <CAEf4BzYpYXN6nZc1CT3ZHUoeYfALK_SY2cLUZ7G72ka5GL_33Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYpYXN6nZc1CT3ZHUoeYfALK_SY2cLUZ7G72ka5GL_33Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:55:34PM -0700, Andrii Nakryiko wrote:

SNIP

> > +       if (cnt_stat >= MAX_EVENT_NUM)
> > +               return 0;
> > +
> > +       bpf_d_path(path, paths_stat[cnt_stat], MAX_PATH_LEN);
> > +       cnt_stat++;
> > +       return 0;
> > +}
> > +
> > +SEC("fentry/filp_close")
> > +int BPF_PROG(prog_close, struct file *file, void *id)
> > +{
> > +       pid_t pid = bpf_get_current_pid_tgid() >> 32;
> > +
> > +       if (pid != my_pid)
> > +               return 0;
> > +
> > +       if (cnt_close >= MAX_EVENT_NUM)
> > +               return 0;
> > +
> > +       bpf_d_path((struct path *) &file->f_path,
> > +                  paths_close[cnt_close], MAX_PATH_LEN);
> 
> Can you please capture the return result of bpf_d_path() (here and
> above) and validate that it's correct? That will help avoid future
> breakages if anyone changes this.

right, good idea, will add

thanks,
jirka

