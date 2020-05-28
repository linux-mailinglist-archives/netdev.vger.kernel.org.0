Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E611E5879
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgE1HZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:25:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37741 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725747AbgE1HZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:25:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590650711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ADDvCVwhY+dTdngWcQCLEaIkiGvZRIq6qVnshHarZLs=;
        b=Tn5lsfdL/vwxIjDCarL5raKp4qnOKo4ClUtepe1Nj5tf2/BJSJs1l9qsVwc1lHb+s2s6iB
        g4Q8/DoxKU8nccL0DfSM3P/BE7swG0wXBjDLNMZJEVkyYHmJO5ttArZZgZTcTn/l71E0I6
        6pd1aFok1TW4XvKm5ss4Y4mSsviacpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-Si8YFYnNM6WVudonpDdLZA-1; Thu, 28 May 2020 03:25:07 -0400
X-MC-Unique: Si8YFYnNM6WVudonpDdLZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4BC1872FE0;
        Thu, 28 May 2020 07:25:05 +0000 (UTC)
Received: from [10.36.112.109] (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 053A89CB9;
        Thu, 28 May 2020 07:25:00 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>, "Martin Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        "Andrii Nakryiko" <andriin@fb.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Subject: Re: [PATCH bpf-next] libbpf: fix perf_buffer__free() API for sparse
 allocs
Date:   Thu, 28 May 2020 09:24:58 +0200
Message-ID: <54F16472-92CB-4A18-BC7D-0DB8741496E4@redhat.com>
In-Reply-To: <CAEf4BzZ8h89QXQLFKM34iggW3M1AzBFKcqvq2J9Jn=Ur9yM7YA@mail.gmail.com>
References: <159056888305.330763.9684536967379110349.stgit@ebuild>
 <CAEf4BzZ8h89QXQLFKM34iggW3M1AzBFKcqvq2J9Jn=Ur9yM7YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27 May 2020, at 19:58, Andrii Nakryiko wrote:

> On Wed, May 27, 2020 at 1:42 AM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>> In case the cpu_bufs are sparsely allocated they are not
>> all free'ed. These changes will fix this.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>
> Thanks a lot!
>
> You forgot:
>
> Fixes: fb84b8224655 ("libbpf: add perf buffer API")

Thanks, I forgot that :(  Daniel do you want me to send a v2, or will 
you add it when you apply it?

> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
>>  tools/lib/bpf/libbpf.c |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 5d60de6fd818..74d967619dcf 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -8137,9 +8137,12 @@ void perf_buffer__free(struct perf_buffer *pb)
>>         if (!pb)
>>                 return;
>>         if (pb->cpu_bufs) {
>> -               for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) 
>> {
>> +               for (i = 0; i < pb->cpu_cnt; i++) {
>>                         struct perf_cpu_buf *cpu_buf = 
>> pb->cpu_bufs[i];
>>
>> +                       if (!cpu_buf)
>> +                               continue;
>> +
>>                         bpf_map_delete_elem(pb->map_fd, 
>> &cpu_buf->map_key);
>>                         perf_buffer__free_cpu_buf(pb, cpu_buf);
>>                 }
>>

