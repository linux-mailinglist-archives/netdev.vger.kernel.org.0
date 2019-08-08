Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CAE86A98
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbfHHTan convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 15:30:43 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41144 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHHTam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:30:42 -0400
Received: by mail-ed1-f67.google.com with SMTP id w5so3502440edl.8
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Wsw6Id5oaRGsi6j66DvfkEzdpI+jUJL6LTbJLknluVk=;
        b=UVSGWPWXuMRhqb8iDKpqaECp04QelZvoLTjoMLONSGht6GHJsU1gCGywQ/kaHZ6uWq
         Cmy9sPwXfUdGEafgkWZP6ujrOJv0mtRVW8WUUBl7EZJMet+74aN2BWtP/RtKWK0/vaCi
         APNXE8cozr5wzO/65IS0RT0xiBcSuMlP/lCLsiKgZ6W6+ObCNvnSq+DlUOWHcsAbeNXL
         n80hCLEsBnvMwFRogIpW3z8pW/qgxlTNYSGG7cl2yIRWn2kNjoPEEUeHJxhCSPXV9KFV
         ZKpWuTU00EpkJvrZq5w9oNwMSsGXHRpsTRybM7685R/Sucl6Q2Yrf1kNSIog55kc81nL
         3SrA==
X-Gm-Message-State: APjAAAUDbncQL2fqBM2UigirxSU//RZlQw4RVb0SN0o2DF3hStFBpTY5
        LHIgU4qnDIuR8MbEyLRRefKsqQ==
X-Google-Smtp-Source: APXvYqxna7NIJkL/qULpNj4zd8jkpFeZh5eY3Sn1dw8UJJuDUQQ+VYdteqyl2WxD1uDlnW47edBnJg==
X-Received: by 2002:a50:f98a:: with SMTP id q10mr17846227edn.267.1565292641093;
        Thu, 08 Aug 2019 12:30:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a18sm12876356ejp.2.2019.08.08.12.30.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 12:30:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CE8061804B2; Thu,  8 Aug 2019 21:30:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBl?= =?utf-8?B?bA==?= 
        <bjorn.topel@gmail.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v5 0/6] xdp: Add devmap_hash map type
In-Reply-To: <CAADnVQJpYeQ68V5BE2r3BhbraBh7G8dSd8zknFUJxtW4GwNkuA@mail.gmail.com>
References: <156415721066.13581.737309854787645225.stgit@alrua-x1> <CAADnVQJpYeQ68V5BE2r3BhbraBh7G8dSd8zknFUJxtW4GwNkuA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Aug 2019 21:30:39 +0200
Message-ID: <87k1bnsbds.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Fri, Jul 26, 2019 at 9:06 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> This series adds a new map type, devmap_hash, that works like the existing
>> devmap type, but using a hash-based indexing scheme. This is useful for the use
>> case where a devmap is indexed by ifindex (for instance for use with the routing
>> table lookup helper). For this use case, the regular devmap needs to be sized
>> after the maximum ifindex number, not the number of devices in it. A hash-based
>> indexing scheme makes it possible to size the map after the number of devices it
>> should contain instead.
>>
>> This was previously part of my patch series that also turned the regular
>> bpf_redirect() helper into a map-based one; for this series I just pulled out
>> the patches that introduced the new map type.
>>
>> Changelog:
>>
>> v5:
>>
>> - Dynamically set the number of hash buckets by rounding up max_entries to the
>>   nearest power of two (mirroring the regular hashmap), as suggested by Jesper.
>
> fyi I'm waiting for Jesper to review this new version.

Ping Jesper? :)

-Toke
