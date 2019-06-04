Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE3035089
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfFDUAh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jun 2019 16:00:37 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41562 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDUAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:00:37 -0400
Received: by mail-ed1-f68.google.com with SMTP id x25so2180460eds.8
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=noDwviL+4rBDVse1gNVnZx4mNT7DQGI6SZB0FNaozME=;
        b=i+yIlEzJAwd+ukmdhOJJ/myMGxgBs3lLB5UjSpRkuFtGnGxIMFHEAq7AW0AjMgK+53
         UYqxWUWJnvSAl8O9rl+jkB1uIz10sD8WrdniN1h1JdASoQX7lOla1UO4LS/8eHKzjKo8
         Do9Q5JRysVrM41BRUoTUp/Po5QbJJRsalxextSG5xw7bG8qhqHStvrCYhGbs/o3ciVu1
         WddV+Filv3HWmSUl1inYbjyh2JE3XSBCn7D5uWIO5lKK1oeHKdH1YWodB+XM+3fmROc0
         yITvn2Po0Tzh4sg6uu4Rlid3AJiCxDWoDQtAyD13F+9JNBu18+2edO26z4nsTeK7Kr9R
         /NEA==
X-Gm-Message-State: APjAAAWEbPxjBa+8C47V05j3TnCEjELQW0kFPBasGw1T8nJ6+6DiGTdT
        uxVM4CCca+lXi6hlA8B48kQdiQ==
X-Google-Smtp-Source: APXvYqwCLLHjpCA0YK1MmzStYYe0ZKWj2FWZdTKlNfoGD9J5ErnAJdp04fJi4fPrCNlUDs2sTfniRw==
X-Received: by 2002:a50:86b7:: with SMTP id r52mr9125906eda.100.1559678435755;
        Tue, 04 Jun 2019 13:00:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id a5sm1785202ejv.62.2019.06.04.13.00.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 13:00:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7D938181CC1; Tue,  4 Jun 2019 22:00:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH net-next 2/2] devmap: Allow map lookups from eBPF
In-Reply-To: <A5CA54A9-34A0-4583-84E8-0530BAEE215B@gmail.com>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1> <155966185078.9084.7775851923786129736.stgit@alrua-x1> <20190604183559.10db09d2@carbon> <A5CA54A9-34A0-4583-84E8-0530BAEE215B@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Jun 2019 22:00:34 +0200
Message-ID: <877ea1f7dp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Lemon <jonathan.lemon@gmail.com> writes:

> On 4 Jun 2019, at 9:35, Jesper Dangaard Brouer wrote:
>
>> On Tue, 04 Jun 2019 17:24:10 +0200
>> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>>> We don't currently allow lookups into a devmap from eBPF, because the map
>>> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
>>> modifiable from eBPF.
>>>
>>> However, being able to do lookups in devmaps is useful to know (e.g.)
>>> whether forwarding to a specific interface is enabled. Currently, programs
>>> work around this by keeping a shadow map of another type which indicates
>>> whether a map index is valid.
>>>
>>> To allow lookups, simply copy the ifindex into a scratch variable and
>>> return a pointer to this. If an eBPF program does modify it, this doesn't
>>> matter since it will be overridden on the next lookup anyway. While this
>>> does add a write to every lookup, the overhead of this is negligible
>>> because the cache line is hot when both the write and the subsequent
>>> read happens.
>>
>> When we choose the return value, here the ifindex, then this basically
>> becomes UABI, right?
>>
>> Can we somehow use BTF to help us to make this extensible?
>>
>> As Toke mention in the cover letter, we really want to know if the
>> chosen egress have actually enabled/allocated resources for XDP
>> transmitting, but as we currently don't have in-kernel way to query
>> thus (thus, we cannot expose such info).
>
> Would it be better to add a helper like bpf_map_element_present(), which
> just returns a boolean value indicating whether the entry is NULL or not?
>
> This would solve this problem (and my xskmap problem).

Ah, totally missed that other thread; will go reply there :)

-Toke
