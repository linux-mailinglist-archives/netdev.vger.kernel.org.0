Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DACFBC924E
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 21:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfJBTZd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 15:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbfJBTZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 15:25:32 -0400
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDABFC05168C
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 19:25:31 +0000 (UTC)
Received: by mail-ed1-f71.google.com with SMTP id c23so11552181edb.14
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 12:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XYLH/eSvYfP4T+yaZoRpDMgk4K46a6j6sY2430KIKmI=;
        b=TW8mvh0fAgJ06m8jEA9iYvsKQBzPv3toudMDCXn2mz5bqmVLXqHVcMsu5JOh/sNTyI
         84AJibOMAnkAjR9cepfv52zzHEzKeH3u5n9TZtfOnmX2Os4GRMejmylDShEtZHsEtL41
         eQVNQ/cLkJ1+yzEZNBhEFNA8+65tYdNIIs762TSRYw38dvLMLiWBq0bx/Sn8ojNKPJzK
         G8qECJ5LZ2lWElnl76FSETgVJ8fAeGE9sooXmMx4EMd0toT5elEkeOOHH41BNIyFaNik
         c79IuraXGaSuKx4XnmkKu7p3Yb8itGfJKH9i9tyBZ8R4MhBNvmuu7U1z/Xgc6+kgKHfC
         1ArA==
X-Gm-Message-State: APjAAAWiqawyYRpC8XOgBLv+v0Js4rQ+J9vqEEVSBoCYVzQUPEGyq8C+
        1vYY9YL4aDvL/neRcwZL0XWslxaaCV+kjk1ONPJXgPdTrgBey+/Aug2uwckzu6L0fj8UnkryPmq
        S12RmO6XGENVIjk3T
X-Received: by 2002:a50:a7e4:: with SMTP id i91mr5769049edc.9.1570044330613;
        Wed, 02 Oct 2019 12:25:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwWhyzReZjcf6IR2hRbnOirmpmgfEgDgwTh4ybBvfLeePo9Z7Eo45A/LnMpHAgACll8D+ZqIg==
X-Received: by 2002:a50:a7e4:: with SMTP id i91mr5768963edc.9.1570044329509;
        Wed, 02 Oct 2019 12:25:29 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id z20sm13398edb.3.2019.10.02.12.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 12:25:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6718D18063D; Wed,  2 Oct 2019 21:25:28 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single interface through chain calls
In-Reply-To: <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com> <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 21:25:28 +0200
Message-ID: <87r23vq79z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Song Liu <songliubraving@fb.com> writes:

>> On Oct 2, 2019, at 11:38 AM, Song Liu <songliubraving@fb.com> wrote:
>> 
>> 
>> 
>>> On Oct 2, 2019, at 6:30 AM, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>> 
>>> This series adds support for executing multiple XDP programs on a single
>>> interface in sequence, through the use of chain calls, as discussed at the Linux
>>> Plumbers Conference last month:
>>> 
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__linuxplumbersconf.org_event_4_contributions_460_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=dR8692q0_uaizy0jkrBJQM5k2hfm4CiFxYT8KaysFrg&m=YXqqHTC51zXBviPBEk55y-fQjFQwcXWFlH0IoOqm2KU&s=NF4w3eSPmNhSpJr1-0FLqqlqfgEV8gsCQb9YqWQ9p-k&e= 
>>> 
>>> # HIGH-LEVEL IDEA
>>> 
>>> The basic idea is to express the chain call sequence through a special map type,
>>> which contains a mapping from a (program, return code) tuple to another program
>>> to run in next in the sequence. Userspace can populate this map to express
>>> arbitrary call sequences, and update the sequence by updating or replacing the
>>> map.
>>> 
>>> The actual execution of the program sequence is done in bpf_prog_run_xdp(),
>>> which will lookup the chain sequence map, and if found, will loop through calls
>>> to BPF_PROG_RUN, looking up the next XDP program in the sequence based on the
>>> previous program ID and return code.
>>> 
>>> An XDP chain call map can be installed on an interface by means of a new netlink
>>> attribute containing an fd pointing to a chain call map. This can be supplied
>>> along with the XDP prog fd, so that a chain map is always installed together
>>> with an XDP program.
>> 
>> Interesting work!
>> 
>> Quick question: can we achieve the same by adding a "retval to call_tail_next" 
>> map to each program? I think one issue is how to avoid loop like A->B->C->A, 
>> but this should be solvable? 
>
> Also, could you please share a real word example? I saw the example
> from LPC slides, but I am more curious about what does each program do
> in real use cases.

The only concrete program that I have that needs this is xdpcap:
https://github.com/cloudflare/xdpcap

Right now that needs to be integrated into the calling program to work;
I want to write a tool like it, but that can insert itself before or
after arbitrary XDP programs.

Lorenz, can you say more about your use case? :)

-Toke
