Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D548178CBC
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 09:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgCDIpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 03:45:10 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46855 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgCDIpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 03:45:10 -0500
Received: by mail-ot1-f65.google.com with SMTP id g96so1205751otb.13
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 00:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ma8ZuzcCeVEH6377/YAf0HxDb+sbrr8YMMlgCfFH6Lk=;
        b=FrMlwWsM6VLOsyh8IR/l2AzoOl3oFGBHNGhVWnWt1/tr3WhRWPJ0BMj3yX6YGBMea/
         TQXGkaFBa4jar3k26oX5MaEcapBB2a9JrNsHVM3OA9DUIQ5UDooYIFTp46eOZKBkaMDc
         08Zcri9aN5WHeb0oDzOIOw4JngUyWipsbPvd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ma8ZuzcCeVEH6377/YAf0HxDb+sbrr8YMMlgCfFH6Lk=;
        b=N2kfDm3E5rTBZbXdZAv0FDJhGSe07+OD76Lr/nMAur9sRyOkk4hyJTkhc5RHTMKwa0
         Xggcly1+2FeCizV6kvQ7N4hWgugrzcn0IQRJj1pWPGGvDmIpr/m9ttevZWpW/gkeIrla
         9jXFjk48WvuLvG1J/LxUu6r9kI+hopEL89GsyG5i8lY+nOxXzicNH1umT3nt1efmBsHO
         YXYAPuQIcNzatCbzHNZrXd/jAC1Qyv/nUsoqNfI4+AHRvDVVOzt5dXUEQNbxy7H7mqSD
         q+/j0d2NDsFKjsyHiRtfBeR/eqlhnV61DVlFDPwIhw+c02FGYam655+0gp4un/rNYwg0
         NnZA==
X-Gm-Message-State: ANhLgQ3YOAEyHqt4xCpWDZulTZnsKqe9NlKNSxQLZdvOmN1J4ekSmDja
        R24zvgFPQ4jHQMR36tnazvgYMA9CmXMWqfjwwdlWew==
X-Google-Smtp-Source: ADFU+vszsCH0gAioTE/0Oo9bJUmXm+Eq3B6gwTKHp5hf/N0BfkJM6SCshdG+Ifs/jv7uE2DSKKOkCsuTMscyII1dFjw=
X-Received: by 2002:a9d:10d:: with SMTP id 13mr1579216otu.334.1583311509322;
 Wed, 04 Mar 2020 00:45:09 -0800 (PST)
MIME-Version: 1.0
References: <20200228115344.17742-1-lmb@cloudflare.com> <20200228115344.17742-4-lmb@cloudflare.com>
 <20200303175051.zcxmo3c257pfpj7f@kafai-mbp>
In-Reply-To: <20200303175051.zcxmo3c257pfpj7f@kafai-mbp>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 4 Mar 2020 09:44:57 +0100
Message-ID: <CACAyw9_Ewe86YYgdffhz3dVaPPMnXeckMYhoPn+umvhAShtnBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/9] bpf: sockmap: move generic sockmap hooks
 from BPF TCP
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Mar 2020 at 18:51, Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Feb 28, 2020 at 11:53:38AM +0000, Lorenz Bauer wrote:
> > The close, unhash and clone handlers from TCP sockmap are actually generic,
> > and can be reused by UDP sockmap. Move the helpers into the sockmap code
> Is clone reused in UDP?

No, my bad. I'll update the commit message.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
