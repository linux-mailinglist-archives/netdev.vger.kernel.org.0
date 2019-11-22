Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EC71066EE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfKVHSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:18:51 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34620 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKVHSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:18:50 -0500
Received: by mail-lj1-f193.google.com with SMTP id 139so6182986ljf.1;
        Thu, 21 Nov 2019 23:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PaB+ipD3pNGZf/8QHqLAg3I39OlA4++uMtle/oXHtm4=;
        b=RzpkEpinMIsiB2ZERD/ZsxbzvTnbFhFlDajslXMdZy9OEhg9L8As8QtIk+n8arFsd3
         D2/YcyU7FSO80OfuMCAV7FyJRPAtWMpJvUwDZzYH/+5ONoyx47s+FpJqWTQimenZJ0qY
         lOw7wrhp6iZ8RyrprHg2ZHREk9+RSHPsBJW5kF6P82jPcXxceQbAQf15MsVbkBql6lk2
         bDssQR2x6lf2j6/62sgfC7ewxv5TCHZAh/5a9NTCKImzVA2jKB/bohaIYOlbLEsXMy6Q
         Fsw9VuP97E33GW45xf1MNmtvNJI2FKA1tcZCP9tC0o0g0Ie0Kp7/E3XJFSzIsQXZYZe0
         XYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PaB+ipD3pNGZf/8QHqLAg3I39OlA4++uMtle/oXHtm4=;
        b=RWxU+lyWMT/fqgnsiAizRIOp4Lo2+SVtaCSXxZcMsRkmMwC9OtLuA2C+ZDIkn7Wmc7
         8t7fr+O00Ya1GBhpwW7xR3yWr0JRfNXxDR1IVXPrmdItqPjICtg+atugwG82UBjgFlkK
         M+rBQCNbWd6G+SnrQUbd4bvTkhAykoVOPMeOBYJnTXuisToO0UC/cNyulrvCJEphLSk7
         HENxKo57Ks9y2iFXprpOvZNWKBtbrBC9HcYKE2dsmuF6CbsLgnr79I0LRF+tQOOn/CHB
         hJAmmVgmOfmevzQ7k6UAr13IZ13H3Ri59Enu1ElV2LBt7I4u9db3wRINjDf3+/Lr1yr3
         AA0g==
X-Gm-Message-State: APjAAAX4ofMUuxuE1W6LEIdXQtE9jIfgvuowlUDFxWxON/j4YQZ77C1e
        fHzvRp56XyEOdJn6umELQT73vyH0+1IMa1jJozw=
X-Google-Smtp-Source: APXvYqyEgpCtKdVGO8Uu6ZGLbHC8FUHBlInecGSrSpKvuMDZYSRFZBYuZyolxSHe99C/kXipKkg8lOyk/Ab8IlROB1Q=
X-Received: by 2002:a2e:b5b8:: with SMTP id f24mr10648602ljn.188.1574407128518;
 Thu, 21 Nov 2019 23:18:48 -0800 (PST)
MIME-Version: 1.0
References: <20191121133612.430414-1-toke@redhat.com> <5dd701c21871b_4e932af130aba5bc48@john-XPS-13-9370.notmuch>
In-Reply-To: <5dd701c21871b_4e932af130aba5bc48@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Nov 2019 23:18:36 -0800
Message-ID: <CAADnVQJ6rd7Y7ZgoKLwpQNs6dni=jhbE+2OtedwHcZ71yyry7g@mail.gmail.com>
Subject: Re: [PATCH] xdp: Fix cleanup on map free for devmap_hash map type
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 1:32 PM John Fastabend <john.fastabend@gmail.com> w=
rote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Tetsuo pointed out that it was not only the device unregister hook that=
 was
> > broken for devmap_hash types, it was also cleanup on map free. So bette=
r
> > fix this as well.
> >
> > While we're add it, there's no reason to allocate the netdev_map array =
for
>               ^^^
>               at
> > DEVMAP_HASH, so skip that and adjust the cost accordingly.
>
> Beyond saving space without pulling these apart the free would have gotte=
n
> fairly ugly.
>
> >
> > Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devi=
ces by hashed index")
> > Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > ---
> >  kernel/bpf/devmap.c | 74 ++++++++++++++++++++++++++++-----------------
> >  1 file changed, 46 insertions(+), 28 deletions(-)
>
> small typo in commit message otherwise
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Fixed the typo and applied to bpf-next. Thanks
