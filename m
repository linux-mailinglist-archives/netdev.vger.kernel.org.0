Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CC448D7DF
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 13:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiAMM1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 07:27:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56552 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiAMM13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 07:27:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA222B8226A;
        Thu, 13 Jan 2022 12:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD9EC36AE9;
        Thu, 13 Jan 2022 12:27:25 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pNHTZ90I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642076843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RZmY2qIaiurYA/mKJE7ohEEiru8H9JdVZELIj1PxIoA=;
        b=pNHTZ90IApTGB11vIl/VF0ODy6Loqda26jRcYs+JQGuKkhFz+WEgF7SguXvUtETp9+fJgq
        N5a+hAPHhhOOiIyRH/y6VRInUkZyPEuShsYD1v3UChYodhWsWWe6PMJSV/pBDFkY4jXkfZ
        OkoHXX6ZEYf0uXUum9WD5/LlUuu5VJM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e8048666 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 13 Jan 2022 12:27:23 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id p187so14552328ybc.0;
        Thu, 13 Jan 2022 04:27:23 -0800 (PST)
X-Gm-Message-State: AOAM532mUUlUxyBCiQAVk6Caeuu1/5qGMQu6+8oJA0FepE7TWXo27vHM
        6MC0M/PfcE7g1oly0n4TfCPS0FLWVOjVI4xLHiI=
X-Google-Smtp-Source: ABdhPJyjblO80oVVfKtvp+fpCD1/tdJaccCxyhOaUzN+ACfnKycKaW4Jfx66NtSUKzLtNUvaew12fpw4QtJ8EzhwKwM=
X-Received: by 2002:a25:8c4:: with SMTP id 187mr5368723ybi.245.1642076842465;
 Thu, 13 Jan 2022 04:27:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:209:b0:11c:1b85:d007 with HTTP; Thu, 13 Jan 2022
 04:27:22 -0800 (PST)
In-Reply-To: <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-2-Jason@zx2c4.com>
 <87tue8ftrm.fsf@toke.dk> <CAADnVQJqoHy+EQ-G5fUtkPpeHaA6YnqsOjjhUY6UW0v7eKSTZw@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 13 Jan 2022 13:27:22 +0100
X-Gmail-Original-Message-ID: <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
Message-ID: <CAHmME9ork6wh-T=sRfX6X0B4j-Vb36GVO0v=Yda0Hac1hiN_KA@mail.gmail.com>
Subject: Re: [PATCH RFC v1 1/3] bpf: move from sha1 to blake2s in tag calculation
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei,

On 1/13/22, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> Nack.
> It's part of api. We cannot change it.

This is an RFC patchset, so there's no chance that it'll actually be
applied as-is, and hence there's no need for the strong hammer nack.
The point of "request for comments" is comments. Specifically here,
I'm searching for information on the ins and outs of *why* it might be
hard to change. How does userspace use this? Why must this 64-bit
number be unchanged? Why did you do things this way originally? Etc.
If you could provide a bit of background, we might be able to shake
out a solution somewhere in there.

Thanks,
Jason
