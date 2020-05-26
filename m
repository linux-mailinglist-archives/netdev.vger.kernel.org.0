Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D270A1E1CED
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 10:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgEZIIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 04:08:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20545 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731286AbgEZIIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 04:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590480475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4qPuy21thUmWYvEWAv8ubPfXDGwVw2Do/ZSlrhPm0P4=;
        b=QnWzARIvUXD76nXu8lLTHQ8DdTRPy7eVfoRLx3saz/9LpUNUWzwmp0OHfQkvU+kZBxBti3
        cmLozKfjCl7kKdVzgiz5R2fAapL1/UgSsvK0trkIRhAhcOmqXoAJ3hvTLsdd1mERmUFNw9
        Z5ZezqVcGMl7Eooe0VO4rGcQtYwXXIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-UMV5ZecxOJ6Rb2WnsxjQJg-1; Tue, 26 May 2020 04:07:54 -0400
X-MC-Unique: UMV5ZecxOJ6Rb2WnsxjQJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C51AF460;
        Tue, 26 May 2020 08:07:52 +0000 (UTC)
Received: from [10.36.114.116] (ovpn-114-116.ams2.redhat.com [10.36.114.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 874D15D9E5;
        Tue, 26 May 2020 08:07:45 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Subject: Re: [PATCH bpf-next] libbpf: add API to consume the perf ring buffer
 content
Date:   Tue, 26 May 2020 10:07:42 +0200
Message-ID: <51FAF2C0-F843-45EF-8CE7-69FD0334AD84@redhat.com>
In-Reply-To: <CAEf4BzZqDz=0nKpxjfkowkXkGiH67eSJCZQxRywFcVT+2UeZ+w@mail.gmail.com>
References: <159042332675.79900.6845937535091126683.stgit@ebuild>
 <CAEf4BzZqDz=0nKpxjfkowkXkGiH67eSJCZQxRywFcVT+2UeZ+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 May 2020, at 7:29, Andrii Nakryiko wrote:

> On Mon, May 25, 2020 at 2:01 PM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>> This new API, perf_buffer__consume, can be used as follows:
>
> I wonder, was it inspired by yet-to-be committed
> ring_buffer__consume() or it's just a coincidence?

Just coincidence, I was needing a function to flush the remaining ring 
entries, as I was using a larger wakeup_events value.
Initially, I called the function ring_buffer_flush(), but once I noticed 
your patch I renamed it :)

>> - When you have a perf ring where wakeup_events is higher than 1,
>>   and you have remaining data in the rings you would like to pull
>>   out on exit (or maybe based on a timeout).
>> - For low latency cases where you burn a CPU that constantly polls
>>   the queues.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>  tools/lib/bpf/libbpf.c   |   23 +++++++++++++++++++++++
>>  tools/lib/bpf/libbpf.h   |    1 +
>>  tools/lib/bpf/libbpf.map |    1 +
>>  3 files changed, 25 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index fa04cbe547ed..cbef3dac7507 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -8456,6 +8456,29 @@ int perf_buffer__poll(struct perf_buffer *pb, 
>> int timeout_ms)
>>         return cnt < 0 ? -errno : cnt;
>>  }
>>
>> +int perf_buffer__consume(struct perf_buffer *pb)
>> +{
>> +       int i;
>> +
>> +       if (!pb)
>> +               return -EINVAL;
>
> we don't check this in perf_buffer__poll, IMO, checking this in every
> "method" is an overkill.

Ack, will fix in v2

>> +
>> +       if (!pb->cpu_bufs)
>> +               return 0;
>
> no need to check. It's either non-NULL for valid perf_buffer, or
> calloc could return NULL if pb->cpu_cnt is zero (not sure it's
> possible, but still), but then loop below will never access
> pb->cpu_bufs[i].

Agreed, was just adding some safety checks, but in the constantly poll 
mode this is a lot of overhead. Will remover in v2.

>> +
>> +       for (i = 0; i < pb->cpu_cnt && pb->cpu_bufs[i]; i++) {
>
> I think pb->cpu_bufs[i] check is wrong, it will stop iteration
> prematurely if cpu_bufs are sparsely populated. So move check inside
> and continue loop if NULL.

Mimicked the behavior from other functions, however just to be safe I 
split it up.

>> +               int err;
>
> nit: declare it together with "i" above, similar to how
> perf_buffer__poll does it

Put it down here as it’s only used in the context of the for loop, but 
will move it up in the v2.

>> +               struct perf_cpu_buf *cpu_buf = pb->cpu_bufs[i];
>> +
>> +               err = perf_buffer__process_records(pb, cpu_buf);
>> +               if (err) {
>> +                       pr_warn("error while processing records: 
>> %d\n", err);
>> +                       return err;
>> +               }
>> +       }
>> +       return 0;
>> +}
>> +
>>  struct bpf_prog_info_array_desc {
>>         int     array_offset;   /* e.g. offset of jited_prog_insns */
>>         int     count_offset;   /* e.g. offset of jited_prog_len */
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index 8ea69558f0a8..1e2e399a5f2c 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -533,6 +533,7 @@ perf_buffer__new_raw(int map_fd, size_t page_cnt,
>>
>>  LIBBPF_API void perf_buffer__free(struct perf_buffer *pb);
>>  LIBBPF_API int perf_buffer__poll(struct perf_buffer *pb, int 
>> timeout_ms);
>> +LIBBPF_API int perf_buffer__consume(struct perf_buffer *pb);
>>
>>  typedef enum bpf_perf_event_ret
>>         (*bpf_perf_event_print_t)(struct perf_event_header *hdr,
>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>> index 0133d469d30b..381a7342ecfc 100644
>> --- a/tools/lib/bpf/libbpf.map
>> +++ b/tools/lib/bpf/libbpf.map
>> @@ -262,4 +262,5 @@ LIBBPF_0.0.9 {
>>                 bpf_link_get_fd_by_id;
>>                 bpf_link_get_next_id;
>>                 bpf_program__attach_iter;
>> +               perf_buffer__consume;
>>  } LIBBPF_0.0.8;
>>

Thanks for the review, will send out a v2 soon.

