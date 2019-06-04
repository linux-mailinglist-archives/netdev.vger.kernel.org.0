Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A9234FF1
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 20:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFDSmx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jun 2019 14:42:53 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42145 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDSmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 14:42:52 -0400
Received: by mail-ed1-f68.google.com with SMTP id z25so1844269edq.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 11:42:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=GpKPDwRz+Iojpy+xD8QiMBUFJ/F4qJbSQkdkAm63KAs=;
        b=gSxgR1/Tw4x4C2GzcotdkkYkeV+H2gAwk4bqe+sFC35VzJmBBGhqhmcjYWWEgZYIDX
         Y28AxH6X3ipC/xa3oWtE7HMx6/s0pn/0Y7q5PM8AF5T6R2AzzjC5Kgorc8IxYz0AzyQp
         SSWR0MQci1mH4IpRu9cJiq22WVCrI0Q1/BwWZEH0znqqf2KxgyjrsaLo8b1ONbRLndWY
         haoZgnQFYFBO/gbqIZkVH8txeD42ovtcIq6ex7WVlnoaMNRn6/UmuNr9Jubg+4f/quvV
         ZOgaAbDOO1bVabDVVOnHGQsKn/W7cZOW2L13iRHMgoGa/O6aTEtRWH/krx6W+ju0HLD2
         51aQ==
X-Gm-Message-State: APjAAAUmfjNmW5U/oOHE3v2EQHlh8oad6fUKtzMbkV/uPTQpE6cQ2PdO
        nC+NH3xZj+a76IU3bI/FG29MJwFz0Zc=
X-Google-Smtp-Source: APXvYqxVm3D9aWr8bjZYYZZPUTbpTAOUJyim0b63UdnzhNNwSiOVoJ3e7BER1Jdi8OzwohbFy0fMEQ==
X-Received: by 2002:a17:906:7712:: with SMTP id q18mr30199032ejm.133.1559673771147;
        Tue, 04 Jun 2019 11:42:51 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id m6sm481491ede.2.2019.06.04.11.42.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 11:42:50 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C5B711800F7; Tue,  4 Jun 2019 20:42:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, brouer@redhat.com,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH net-next 2/2] devmap: Allow map lookups from eBPF
In-Reply-To: <20190604183559.10db09d2@carbon>
References: <155966185058.9084.14076895203527880808.stgit@alrua-x1> <155966185078.9084.7775851923786129736.stgit@alrua-x1> <20190604183559.10db09d2@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Jun 2019 20:42:49 +0200
Message-ID: <87blzdfaza.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Tue, 04 Jun 2019 17:24:10 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> We don't currently allow lookups into a devmap from eBPF, because the map
>> lookup returns a pointer directly to the dev->ifindex, which shouldn't be
>> modifiable from eBPF.
>> 
>> However, being able to do lookups in devmaps is useful to know (e.g.)
>> whether forwarding to a specific interface is enabled. Currently, programs
>> work around this by keeping a shadow map of another type which indicates
>> whether a map index is valid.
>> 
>> To allow lookups, simply copy the ifindex into a scratch variable and
>> return a pointer to this. If an eBPF program does modify it, this doesn't
>> matter since it will be overridden on the next lookup anyway. While this
>> does add a write to every lookup, the overhead of this is negligible
>> because the cache line is hot when both the write and the subsequent
>> read happens.
>
> When we choose the return value, here the ifindex, then this basically
> becomes UABI, right?

Well, we already have UABI on the insert side, where the value being
inserted has to be an ifindex. And we enforce value_size==4 when
creating the map. So IMO I'm just keeping to the already established
UAPI here.

That being said...

> Can we somehow use BTF to help us to make this extensible?

... this would not necessarily be a bad thing, it just needs to be done
on both the insert and lookup sides.

But I think this is a separate issue, which we need to solve anyway. And
I'm still not convinced that the map value is the right place to specify
what resources we want ;)

-Toke
