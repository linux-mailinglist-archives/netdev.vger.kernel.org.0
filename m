Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CF32D131F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 15:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgLGOJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 09:09:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726890AbgLGOJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 09:09:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607350055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f68iZRu/WdBikSsVv8YlnpzV5Hi/mSgEQNVLgxBduMA=;
        b=L2K7gG8lQFDn+fewR1oj1qlA0g3FrYq6OA8rdytQs9Y9Y8smzxaAmOp7QB1GGBzw7VFWxD
        H2IXf/POCa1lPlsAnTvUk1tS0e2A75zwstCFAdI4AD90TYi5kGReY6cZ23spaOncCwZz7R
        mgkQj0eLQCqAEIL1HEzkHGIuPDTt9MA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-ZxFeUHh-NpSZTsxJhBSfDA-1; Mon, 07 Dec 2020 09:07:32 -0500
X-MC-Unique: ZxFeUHh-NpSZTsxJhBSfDA-1
Received: by mail-wm1-f71.google.com with SMTP id v5so5399688wmj.0
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 06:07:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=f68iZRu/WdBikSsVv8YlnpzV5Hi/mSgEQNVLgxBduMA=;
        b=REl1DLC1WlEM+st4eIG/NbLd00V8BXCNFytFLX08mln/HStFaZCuYFrcvpM5AM9D5j
         BaNACFlv/kkywfvxjFSCWM5Us/eHd2HsVCrSzFjcBR7VwDuZB7IE1JonsGOa0fPBDLfH
         ROBKVErW4h/PautMPDoU7q5Xxvqmgqyiqj6dNSIo3Sk3LcWv/28FsEFbUlw6ji0v8MKs
         drmXfkm+fQGzZzHGhm/4aEYWm7x9luBl96WJI4SCTp4abbdXMemab9p/qOwvk6x0hrkw
         F80VuBn6bBmmvvrKo5WxT9GNmPowUEdonVjBNDhkF5jke8Wslr8UuV4AIzY+avzLmrvu
         CU3w==
X-Gm-Message-State: AOAM5314oR/J+WvQ29lGLmg2sEFBK835XS+ZqJ8pOOXR7eg+hvNXQAuk
        tPmI6kJzpcUV/KEjowVUaHMvbFMUaYgc9lvFKsKgbSFUsitpscgdUMEPZ7N9OGT4LBi5KH7unBw
        I60xFE70mx0RtvjNQ
X-Received: by 2002:a1c:b0c4:: with SMTP id z187mr18648339wme.113.1607350051333;
        Mon, 07 Dec 2020 06:07:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuKTXT9VjylEoopad3wtGlqLGRN+AzCEv1obwJwK40XnFtEennVUhJypx48PWbq6Rl81Mz4w==
X-Received: by 2002:a1c:b0c4:: with SMTP id z187mr18648282wme.113.1607350050863;
        Mon, 07 Dec 2020 06:07:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z21sm13853864wmk.20.2020.12.07.06.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:07:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E0FD61843F5; Mon,  7 Dec 2020 15:07:28 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH bpf-next] bpf: return -EOPNOTSUPP when attaching to
 non-kernel BTF
In-Reply-To: <CAADnVQK25OLC+C7LLCvGY7kgr_F2vh5-s_4rnwCY7CqMEcfisw@mail.gmail.com>
References: <20201205030952.520743-1-andrii@kernel.org>
 <CAADnVQK25OLC+C7LLCvGY7kgr_F2vh5-s_4rnwCY7CqMEcfisw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 07 Dec 2020 15:07:28 +0100
Message-ID: <87lfe9676n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Dec 4, 2020 at 7:11 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>> +                               return -EOPNOTSUPP;
>
> $ cd kernel/bpf
> $ git grep ENOTSUPP|wc -l
> 46
> $ git grep EOPNOTSUPP|wc -l
> 11

But also

$ cd kernel/include/uapi
$ git grep ENOTSUPP | wc -l
0
$ git grep EOPNOTSUPP | wc -l
8

(i.e., ENOTSUPP is not defined in userspace headers at all)

-Toke

