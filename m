Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEECB142B60
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 13:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbgATM5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 07:57:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36932 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726589AbgATM5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 07:57:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579525030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FEDkrujKlTJc5+7hmDpzcA7gq/UPeEUXrVOs87I/0F4=;
        b=ZMLeD5tjnFEBf/cMnSaxCPw/LCop+Ch3/a+nN/o419wWleOMBhfPNAkqf9Ljs+6nXi8ngX
        k3mB7CddPlaYsKodvymMgTXXm6uM5uCqbkOU3MEW7i+mMYvuxDn6Z5DOVtHhq3QSv9tch3
        sstA2WWxE6grWwnarTABMVb1HwlYLmQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-SusPhk_dPJOwzljW0l5L6Q-1; Mon, 20 Jan 2020 07:57:02 -0500
X-MC-Unique: SusPhk_dPJOwzljW0l5L6Q-1
Received: by mail-lj1-f198.google.com with SMTP id s25so7530237ljm.9
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 04:57:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FEDkrujKlTJc5+7hmDpzcA7gq/UPeEUXrVOs87I/0F4=;
        b=TeyxvwNa9UgiwGnDQaGXiPm19a+FBJ48mH8Wzq5s/0+GmcdmJmvCeyOKRBxasg+Cto
         YAU+EeDpNZq+5eiRhsJUdQZau3F2xAQYt5bX6Dz216ysy0Nx+XtuNl5LI1jvxuVUrY7s
         vsvaRJr67jRtJdpqlDTbbGiqwVIXr6o0uXPScLOIbp7zHjiR/dFVmoPKoP5mRRvclMvV
         qy4zxwqyXHld7dE3fTSIq+ZCM8pMNxfqK0sw29pUxN9dXw8og1gzjDm9wNPMp+qmXcrn
         fk+FlRvJYuT79ZN1cVLgfMXM4Se5R0p5JRZWWwWuma3e/aUNacNR1k1rSX4fWiZGshLk
         Lg7Q==
X-Gm-Message-State: APjAAAUokXTAO48wYjmZSZXs3joXClMu52IrIw+mcssGEHpfiI3zd2x5
        VCK+0A24C7ofplLxq47LiMr7erSzlbVhI3ftH5cJZFIiuLYP55pr3fdtN0j+kxzT+2tq0Iez9J/
        MHyh6C/NSawxGx1iu
X-Received: by 2002:a2e:721a:: with SMTP id n26mr13678534ljc.128.1579525021237;
        Mon, 20 Jan 2020 04:57:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqylZwrQxfS+zP3D15CF1fcweaXgkNnfdqeyFKArvqvKbNKna0d4DC4s5krAr4PrBm9NHLxAlw==
X-Received: by 2002:a2e:721a:: with SMTP id n26mr13678516ljc.128.1579525020966;
        Mon, 20 Jan 2020 04:57:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 2sm16813782ljq.38.2020.01.20.04.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 04:57:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5785F1804D6; Mon, 20 Jan 2020 13:56:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list\:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next v4 04/10] tools/runqslower: Use consistent include paths for libbpf
In-Reply-To: <CAEf4BzbAV0TmEUL=62jz+RD6SPmu927z-dhGL9JHepcAOGMSJA@mail.gmail.com>
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk> <157926820131.1555735.1177228853838027248.stgit@toke.dk> <CAEf4BzbAV0TmEUL=62jz+RD6SPmu927z-dhGL9JHepcAOGMSJA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 20 Jan 2020 13:56:59 +0100
Message-ID: <875zh6p9pg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Jan 17, 2020 at 5:37 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> Fix the runqslower tool to include libbpf header files with the bpf/
>> prefix, to be consistent with external users of the library. Also ensure
>> that all includes of exported libbpf header files (those that are export=
ed
>> on 'make install' of the library) use bracketed includes instead of quot=
ed.
>>
>> To not break the build, keep the old include path until everything has b=
een
>> changed to the new one; a subsequent patch will remove that.
>>
>> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken =
from selftests dir")
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  tools/bpf/runqslower/Makefile         |    5 +++--
>>  tools/bpf/runqslower/runqslower.bpf.c |    2 +-
>>  tools/bpf/runqslower/runqslower.c     |    4 ++--
>>  3 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefi=
le
>> index b62fc9646c39..9f022f7f2593 100644
>> --- a/tools/bpf/runqslower/Makefile
>> +++ b/tools/bpf/runqslower/Makefile
>> @@ -5,6 +5,7 @@ LLC :=3D llc
>>  LLVM_STRIP :=3D llvm-strip
>>  DEFAULT_BPFTOOL :=3D $(OUTPUT)/sbin/bpftool
>>  BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
>> +INCLUDES :=3D -I$(OUTPUT) -I$(abspath ../../lib) -I$(abspath ../../lib/=
bpf)
>>  LIBBPF_SRC :=3D $(abspath ../../lib/bpf)
>
> drop LIBBPF_SRC, it's not used anymore

It is: in the rule for building libbpf there's a '-C $(LIBBPF_SRC)'

-Toke

