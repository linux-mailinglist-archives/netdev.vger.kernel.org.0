Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38606C47F7
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 08:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfJBG4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 02:56:02 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29499 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726184AbfJBG4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 02:56:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569999359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efyYUpYxx029Ew+s+FaYOT0lLgYPQRTDAPERFvMlQUI=;
        b=hyeV0xZONfxgVfJlq3jnYoPCOQdD+Z57zgtVCJ4gmIv8km/kwuuCPXKvTdO+OMdVfYGWxO
        C0VxUqo3vJlEre4YiqFUPHEngxl/IB5GtIB29M+1spwWQMDAlQjUENMO75KCYLyhX9ssal
        61JupHO+AGaA1yb0957XFtxWifksyzU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-WRr9hRRaPrKIxly5Y-WH1A-1; Wed, 02 Oct 2019 02:55:57 -0400
Received: by mail-lj1-f198.google.com with SMTP id l15so4513024lje.17
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 23:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=efyYUpYxx029Ew+s+FaYOT0lLgYPQRTDAPERFvMlQUI=;
        b=LBqK+aeFDDLfUuW3V2OJo1utq3/i/Zqpr/aAPXYbtGgkyvLC/EVoUiCYp/IAShfEOC
         lMJokOXRNUsNfwxaQZJMlofv/HUnOGfrO2SbIcD69c/Ze3N65L0U/0P/P8X3jNgFU8jc
         gIZnSnxUTLbFjtTiVIx7SWRPdvYlni8FSxa2oErZDVQgwccOpVfJOq2tt09dKu6duMvI
         9k34fphLVc/W7rnauQ1ukeZfW0FpOZWNNRdpYuS3GrUYzI4MmMHaLI2YpRTDnTzYCwRi
         GEq3CE94G//LFyx90yWKn4p2Mbe+V52Lp29WyXvMyQwKFTUK+5hyeUvQDfOVrqDSKX+D
         lWOg==
X-Gm-Message-State: APjAAAU8UyHlJd8gA0FHot9MYzLT+KVTeH/Ixk1Aea3pW6toL+YXwZWW
        Z6a2xN4mzRFtd1hy/0cCulAcopk1lE3LRmHm1F69/dbEbJ2qkNAxulsQm20aSJTqjJtrLPe5qq3
        889wtfJbNa6sq3yMD
X-Received: by 2002:a2e:8603:: with SMTP id a3mr1213837lji.98.1569999355534;
        Tue, 01 Oct 2019 23:55:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxoLbMsdz/75inICUmz6CtpucmTyybdcjgnYInPuNAMpg3jL7kYgzGnAsEAo1c53JjH8BrcKw==
X-Received: by 2002:a2e:8603:: with SMTP id a3mr1213826lji.98.1569999355373;
        Tue, 01 Oct 2019 23:55:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b25sm5622012ljj.36.2019.10.01.23.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 23:55:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8B5F518063D; Wed,  2 Oct 2019 08:55:53 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem} w/ sized opts
In-Reply-To: <CAEf4BzZJFBdjCSAzJ3-rOrCkkaTJmPSDhx_0xKJt4+Vg2TEFwg@mail.gmail.com>
References: <20190930164239.3697916-1-andriin@fb.com> <871rvwx3fg.fsf@toke.dk> <CAEf4BzYvx7wpy79mTgKMuZop3_qYCCOzk4XWoDKiq7Fbj+gAow@mail.gmail.com> <87lfu4t9up.fsf@toke.dk> <CAEf4BzZJFBdjCSAzJ3-rOrCkkaTJmPSDhx_0xKJt4+Vg2TEFwg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 08:55:53 +0200
Message-ID: <87imp7tz46.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: WRr9hRRaPrKIxly5Y-WH1A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> Sure, LGTM! Should we still keep the bit where it expands _opts in the
>> struct name as part of the macro, or does that become too obtuse?
>
> For me it's a question of code navigation. When I'll have a code
>
> LIBBPF_OPTS(bpf_object_open, <whatever>);
>
> I'll want to jump to the definition of "bpf_object_open" (e.g., w/
> cscope)... and will find nothing, because it's actually
> bpf_object_open_opts. So I prefer user to spell it out exactly and in
> full, this is more maintainable in the long run, IMO.

That's a good point; we shouldn't break cscope!

BTW, speaking of cscope, how about having a 'make cscope' target for
libbpf to generate the definition file? :)

-Toke

