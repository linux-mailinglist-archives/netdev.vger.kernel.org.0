Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A0D43DD91
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 11:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhJ1JUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 05:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229992AbhJ1JUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 05:20:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635412662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYb49CUJnsqbEGH495iJBbfqlJAQ8lsg5dpvdMeVuOo=;
        b=Yi7sMCEGh3LoE1ffMDBNEO9kOGXrukBRwpOWTddQn1s3J1i5dm0idaVSy9qlkvB16/jk74
        0BYbRCwxxUun+FRA6W3T7fMBULQ25fco8UgcGK+M59OB1A/4Vo5ts5XAjqAphCZ6yWnEVq
        5rSBF3Kig6uxTZ+PwDn7ynbEUpZX/7A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-CQe9_fAxNA-6gby8UqQBZw-1; Thu, 28 Oct 2021 05:17:41 -0400
X-MC-Unique: CQe9_fAxNA-6gby8UqQBZw-1
Received: by mail-ed1-f70.google.com with SMTP id f4-20020a50e084000000b003db585bc274so4949334edl.17
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 02:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XYb49CUJnsqbEGH495iJBbfqlJAQ8lsg5dpvdMeVuOo=;
        b=Q5bV/sQh3aW3I5x1d04Kp6bp7mGSt8EC9sHR4dPtAGHH0eAMIkDFQi6JERTDkVsVyR
         0T09fjDvrzlaWSC9L4QezhOHb2IW5OVtHXQ5ZlziU7GVPVXFfpfaPzrdl1LwKcBLCzjE
         Mp8h+93qkfC2qgQQxRqmMBRfhWqEynATfwS1mxbDXPqJYXA0pNaAYIVl+y+QpwONpplG
         wiSu4/kQDeS47zl1EJISlhmLvAgJC9OHu/9gYwDSWKEwtPZOUdFh+8uE3KtJGnqKrO9M
         RUK9fLwINALp3O+XftmMvSKVgwOzrNv7oVrSMgmPELlrgdDgiE/CHO1tXxLALFqaWDC4
         Ww6w==
X-Gm-Message-State: AOAM530FXC4rICXvSSMhjX15YUV58i3Bf0CefX47gyuOc+tw+l7gim/3
        EGYexs++/ooGvFFX9AxFVaiS6uJ3ZY5zu3R3QvhLmDWBfhMdIRpUDn1bwiNVQh0o94Xk1xLTIlv
        l03bUH8vWJnw+D06t
X-Received: by 2002:aa7:dbca:: with SMTP id v10mr4514444edt.280.1635412659884;
        Thu, 28 Oct 2021 02:17:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyErkSvFKeRyepEgpLv8FRrpQIaiOwQw6qPzorfehEgRmVuwdbrpK46uIWESSl+EZchFOB9Q==
X-Received: by 2002:aa7:dbca:: with SMTP id v10mr4514396edt.280.1635412659539;
        Thu, 28 Oct 2021 02:17:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id mp5sm1112484ejc.68.2021.10.28.02.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 02:17:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7B83B180262; Thu, 28 Oct 2021 11:17:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net
Cc:     kuba@kernel.org, ast@kernel.org, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: pull-request: bpf 2021-10-26
In-Reply-To: <07334aca-9b58-fdae-0de9-43d44e087d76@iogearbox.net>
References: <20211026201920.11296-1-daniel@iogearbox.net>
 <87bl3a9lc5.fsf@toke.dk>
 <07334aca-9b58-fdae-0de9-43d44e087d76@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 28 Oct 2021 11:17:38 +0200
Message-ID: <878ryda4p9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 10/28/21 12:03 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>=20
>>> The following pull-request contains BPF updates for your *net* tree.
>>>
>>> We've added 12 non-merge commits during the last 7 day(s) which contain
>>> a total of 23 files changed, 118 insertions(+), 98 deletions(-).
>>=20
>> Hi Daniel
>>=20
>> Any chance we could also get bpf merged into bpf-next? We'd like to use
>> this fix:
>>=20
>>> 1) Fix potential race window in BPF tail call compatibility check,
>>> from Toke H=C3=B8iland-J=C3=B8rgensen.
>
> Makes sense! I presume final net tree PR before merge win might go out to=
day
> or tomorrow (Jakub/David?) and would get fast-fwd'ed into net-next after =
that
> as well, which means we get the current batch for bpf-next out by then. By
> that we'd have mentioned commit in bpf-next after re-sync.

Alright, sounds good - thanks! :)

-Toke

