Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DBA10A24B
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 17:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfKZQi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 11:38:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57815 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728524AbfKZQi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 11:38:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574786304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=anXZWHoEcSwWRUQoUrNlVQjmGsi0tQ0H4YTU8oYJxKI=;
        b=D5ZEbspg9PCaEX/RD1No23sb17YYsuve4ckCwfJ3K6juoKD/m37khTFruLC8eQX4EsMH8g
        Wua5BLWKyxQOMDz/NdblDGhqMx7XaPUUr0JGsmyE8aylKSuHgcbvwiDGYxLxa8VmPxwjAv
        vDMEloUTb3LYwVg9NnWXc1Q/68Be7ks=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-e2dz7MHrNba4jEWihZkW6w-1; Tue, 26 Nov 2019 11:38:23 -0500
Received: by mail-lf1-f69.google.com with SMTP id r187so524728lff.21
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 08:38:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uGs8+mN+FP1MpfYBftFdn/64T7U3SLneZcgzkzYr5xg=;
        b=Ydm1EqvZwmAKtaR7UwfGZO4wbudfne6d77Jb0wONrI+DlG8iU8gTwtvP2F9W+ZrDfi
         JBqHh5/lyBIY1RTjsAcyrmIF8njMGHKyxGhnbtem1oWuEw4B9NLdHVACN+3rHSMdbo8v
         sQ5lXLoW+e0y6H4hwa6DPmQH9rUaFuxXCfaBYzHTmK8UdfJpuVYp7QmOZkV4jOO13miV
         499AVIr3H+f8WA2CwJPCp+8kogwSJJyqeZ8fwU2MvKCWTRl9AmzGNzTvoECsTPlRcPgU
         4evU6cPtnlIe70bvLULQE65DslGNNBr+UeUrk+bumugCBVwGzxjpG8oXTqgNn6hGjmmY
         fXfA==
X-Gm-Message-State: APjAAAWlG0hB0cH7oViRfYtqiX7TyIgelS6AHTUNDREOD34h5y657aSB
        0BWqQkKI7o+moVYi/OP2NR7pUa4yZerch7KWW8QEG074sKWF5SqNSUwqswcsrTTDADKPufvkv0+
        SfRnYILDxX7gNiPZm
X-Received: by 2002:ac2:455c:: with SMTP id j28mr21876069lfm.184.1574786300958;
        Tue, 26 Nov 2019 08:38:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwO71NfUdX2GkLzmZfMSf8/8rWJ+HDzBVXqR8hvYWGVAFJ8D/K8I+K4dM6DhBO6pGqc0WhRIg==
X-Received: by 2002:ac2:455c:: with SMTP id j28mr21876056lfm.184.1574786300761;
        Tue, 26 Nov 2019 08:38:20 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d4sm5451338lfi.32.2019.11.26.08.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 08:38:20 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 052671818C0; Tue, 26 Nov 2019 17:38:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
In-Reply-To: <20191126154836.GC19483@kernel.org>
References: <20191126151045.GB19483@kernel.org> <20191126154836.GC19483@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 26 Nov 2019 17:38:18 +0100
Message-ID: <87imn6y4n9.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: e2dz7MHrNba4jEWihZkW6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:

> Em Tue, Nov 26, 2019 at 12:10:45PM -0300, Arnaldo Carvalho de Melo escrev=
eu:
>> Hi guys,
>>=20
>>    While merging perf/core with mainline I found the problem below for
>> which I'm adding this patch to my perf/core branch, that soon will go
>> Ingo's way, etc. Please let me know if you think this should be handled
>> some other way,
>
> This is still not enough, fails building in a container where all we
> have is the tarball contents, will try to fix later.

Wouldn't the right thing to do not be to just run the script, and then
put the generated bpf_helper_defs.h into the tarball?

-Toke

