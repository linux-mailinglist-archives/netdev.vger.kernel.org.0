Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5059B6243D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 17:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391002AbfGHPlB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 11:41:01 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33793 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388961AbfGHPk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 11:40:59 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so15012360edb.1
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 08:40:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gpabKwZ1bNUL7t3UenMyF9Ve1OhXBiRptpD+URICtjo=;
        b=APAl+ahPeHoVoLDFumSMN+DnZt+5ldUJR0pjLBk74Wprp8sDBU2MMar6i68EnqbWMW
         LYgsBI5c4eBIxHjLDZETHWmTRLE9j6LmVjGNKkVHOe0V0uCayAu/u8DDcCSFCCi+wphB
         ULdQcgVtcmm54futj0ybNfaSv2Si1PMlK+NCmeSsVhEMdXSRxikCxMdoQEvvLtgUhj1t
         B42WjGfZiPpMLKhFT22IGTeIRbDNLgs97xmvx/shrhjyji14X87G+y6G3pFsmfuFsKoT
         eRIOl8TR9cGFUiwxMa30JD/LJPq02x6hWEgOsR6DYEsHMo5U3cDnmYGi82Z7/JlO95wC
         TCCg==
X-Gm-Message-State: APjAAAUx/4s3PjN3OftMjBpv+hS9WEqaXgHnsY4NnLZG9aNG2Xjos066
        uwulzBbdZZPh9+Q/2PjOntwb7w==
X-Google-Smtp-Source: APXvYqxyj+h6BlmPXsp5aYKBY+4iBkJVhJuv2TafN22quB7QdHm+S/e2sGeXnMWpSMEfyMoB0Nnw0A==
X-Received: by 2002:a17:906:ece1:: with SMTP id qt1mr17424095ejb.171.1562600457767;
        Mon, 08 Jul 2019 08:40:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b30sm5847389ede.88.2019.07.08.08.40.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 08:40:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 925B8181CE7; Mon,  8 Jul 2019 17:40:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jonathan Lemon <jlemon@flugsvamp.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] xdp: Add devmap_hash map type
In-Reply-To: <53906C87-8AF9-4048-8CA0-AE38C023AEF7@flugsvamp.com>
References: <156234940798.2378.9008707939063611210.stgit@alrua-x1> <53906C87-8AF9-4048-8CA0-AE38C023AEF7@flugsvamp.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Jul 2019 17:40:56 +0200
Message-ID: <87bly4zg8n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jonathan Lemon" <jlemon@flugsvamp.com> writes:

> On 5 Jul 2019, at 10:56, Toke Høiland-Jørgensen wrote:
>
>> This series adds a new map type, devmap_hash, that works like the 
>> existing
>> devmap type, but using a hash-based indexing scheme. This is useful 
>> for the use
>> case where a devmap is indexed by ifindex (for instance for use with 
>> the routing
>> table lookup helper). For this use case, the regular devmap needs to 
>> be sized
>> after the maximum ifindex number, not the number of devices in it. A 
>> hash-based
>> indexing scheme makes it possible to size the map after the number of 
>> devices it
>> should contain instead.
>
> This device hash map is sized at NETDEV_HASHENTRIES == 2^8 == 256. Is
> this actually smaller than an array? What ifindex values are you
> seeing?

Well, not in all cases, certainly. But machines with lots of virtual
interfaces (e.g., container hosts) can easily exceed that. Also, for a
devmap we charge the full size of max_entries * struct bpf_dtab_netdev
towards the locked memory cost on map creation. And since sizeof(struct
bpf_dtab_netdev) is 64, the size of the hashmap only corresponds to 32
entries...

But more importantly, it's a UI issue: Say you want to create a simple
program that uses the fib_lookup helper (something like the xdp_fwd
example under samples/bpf/). You know that you only want to route
between a couple of interfaces, so you naturally create a devmap that
can hold, say, 8 entries (just to be sure). This works fine on your
initial test, where the machine only has a couple of physical interfaces
brought up at boot. But then you try to run the same program on your
production server, where the interfaces you need to use just happen to
have ifindexes higher than 8, and now it breaks for no discernible
reason. Or even worse, if you remove and re-add an interface, you may no
longer be able to insert it into your map because the ifindex changed...

-Toke
