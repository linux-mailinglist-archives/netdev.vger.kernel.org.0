Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F023EDE8E
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhHPUXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:23:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231307AbhHPUXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 16:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629145366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uix71rqb6jp//12514S8vWz8yBNxqhGs/GxTEFr1Nm0=;
        b=CFiiS2PlJh+GW89Rh4DdACzdntqZ9Ip7Wi7Q8R/XN31uPoSmL4wkZUT5kU8vFmvGL6XSe2
        nWzin1IabldGVbmqH96/S77UsELW4HTOF4LwYp2/qZ7xKi5kGKgFIHL0yGE62lBmqZIjio
        My3KKjkFAWVEFyHZCTSbSKyJ8axByGY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-fZobPHhfPg-eBR8h3-cWaA-1; Mon, 16 Aug 2021 16:22:44 -0400
X-MC-Unique: fZobPHhfPg-eBR8h3-cWaA-1
Received: by mail-ed1-f70.google.com with SMTP id m16-20020a056402511000b003bead176527so6842795edd.10
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 13:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Uix71rqb6jp//12514S8vWz8yBNxqhGs/GxTEFr1Nm0=;
        b=qyUnhpEBRBg8kL6a3uzhIZPkopJfAf0wi6YTec2IIKE3d71mdFnHRz4gocZHQ3JzLN
         PYOR1lH3FibzBVSuX52mJDk6JL8WdYacOJHA0+i7RMgNJ9F8SjVnay/+QWj14S2zVaCM
         1YoJopCGTk78sVuRqVcWpci+CetteT4PTHRA2LJPIn965nZFI4TbJeHHuhWjgnYLx9ft
         Akszjet6snyOSu6g6OsXorHMX6DNgCJgxryMl/eMA5t3ZurOQVw+AQn+HuR331XfP4+O
         twn7VXfw5guZz2UNAXiuAeHYfWhsa21aDS1k8sk0BfJX38p3Fw32Hy15gjA/d4/MDN1U
         QqOw==
X-Gm-Message-State: AOAM5319UzNfkR6JdTFTpDgEv7XuDqo8eg0ZBWKMA+0/jS7GuRIGwWXU
        fMSWF1BAMJNoBZi3MOlMFJvVgBS3t65yZh6W1dnHCh7mLM3/n+8XbPE0iaVeh1Dzyy7t4+iklhb
        FN4MTtTzxHgX2mMpp
X-Received: by 2002:aa7:c956:: with SMTP id h22mr404031edt.378.1629145363395;
        Mon, 16 Aug 2021 13:22:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo9owt0b7kL4PZgVWPNOZz1KLu5CtmxpPSaj6UuHSZKLzsrbiSpQVMnpQHSNAdEQFVuYa/Fw==
X-Received: by 2002:aa7:c956:: with SMTP id h22mr404008edt.378.1629145363022;
        Mon, 16 Aug 2021 13:22:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id jo17sm106553ejb.40.2021.08.16.13.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 13:22:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 80C74180608; Mon, 16 Aug 2021 22:22:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 2/8] samples: bpf: Add common infrastructure
 for XDP samples
In-Reply-To: <6a0ba11a-d2a5-38ec-0462-58212c8a4ca7@iogearbox.net>
References: <20210728165552.435050-1-memxor@gmail.com>
 <20210728165552.435050-3-memxor@gmail.com>
 <6a0ba11a-d2a5-38ec-0462-58212c8a4ca7@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 16 Aug 2021 22:22:41 +0200
Message-ID: <87pmudywa6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 7/28/21 6:55 PM, Kumar Kartikeya Dwivedi wrote:
>> This file implements some common helpers to consolidate differences in
>> features and functionality between the various XDP samples and give them
>> a consistent look, feel, and reporting capabilities.
>> 
>> Some of the key features are:
>>   * A concise output format accompanied by helpful text explaining its
>>     fields.
>>   * An elaborate output format building upon the concise one, and folding
>>     out details in case of errors and staying out of view otherwise.
>>   * Extended reporting of redirect errors by capturing hits for each
>>     errno and displaying them inline (ENETDOWN, EINVAL, ENOSPC, etc.)
>>     to aid debugging.
>>   * Reporting of each xdp_exception action for all samples that use these
>>     helpers (XDP_ABORTED, etc.) to aid debugging.
>>   * Capturing per ifindex pair devmap_xmit counts for decomposing the
>>     total TX count per devmap redirection.
>>   * Ability to jump to source locations invoking tracepoints.
>>   * Faster retrieval of stats per polling interval using mmap'd eBPF
>>     array map (through .bss).
>>   * Printing driver names for devices redirecting packets.
>>   * Printing summarized total statistics for the entire session.
>>   * Ability to dynamically switch between concise and verbose mode, using
>>     SIGQUIT (Ctrl + \).
>> 
>> The goal is sharing these helpers that most of the XDP samples implement
>> in some form but differently for each, lacking in some respect compared
>> to one another.
>> 
>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> Overall I think it's okay to try to streamline the individual XDP tools, but I
> also tend to wonder whether we keep going beyond the original purpose of kernel
> samples where the main goal is to provide small, easy to hack & stand-alone code
> snippets (like in samples/seccomp ... no doubt we have it more complex in BPF
> land, but still); things people can take away and extend for their purpose. A big
> portion of the samples are still better off in selftests so they can be run in CI,
> and those that are not should generally be simplified for developers to rip out,
> modify, experiment, and build actual applications on top.

FWIW the idea of improving the samples came from Jesper and myself;
we've come to rely on them quite a bit for benchmarking, and our QE
folks run them for testing as well. And I've lost count of the number of
times I had to redo tests because something wasn't working correctly and
I didn't notice that the numbers were off. Kumar took the "improve the
XDP samples" idea and ran with it, and I think the result is much
improved; having it be immediately obvious when something is off is a
huge benefit!

So while I do share your concern about expanding the samples code too
much, in this instance I think it's an improvement. I've toyed with the
idea of also distributing some of the XDP samples with xdp-tools so they
are easier to install as standalone utilities, but I think that is a
secondary concern for later.

-Toke

