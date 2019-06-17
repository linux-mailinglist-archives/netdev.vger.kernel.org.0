Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E178E491B8
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfFQUxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:53:42 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35147 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfFQUxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:53:42 -0400
Received: by mail-lf1-f67.google.com with SMTP id a25so7583485lfg.2;
        Mon, 17 Jun 2019 13:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z9GFw1Go2U+fB4X4rM4wNbKnVxIFKuItgqQdfim6+1I=;
        b=goIr/JmPUlLK70x5rqD9mWttUm2o+XZyBiIF16flSrlTEhsKBEWi3y6NyKxuCaZTAE
         Pn86mm0FvAUqHmVRz0OICQD5JTu87YAU05zNC7exE6fUBremokp1au9olscN9aNf8Xct
         IQ97pCxGwZqrPiaGMNH3554b4X0PJmvkmpx6R+cOd/z9OIz4qHl+z1HjlgB4yae8SALT
         Q+B3heP2YoVy9tSV10bGCrU/bwzDO8Asp2zOxUw1Cdk9TqT5h0NZ8Gr/SKAY6MLiNCAo
         c+tZLMPOT9MzilPWBfBTJWAvQXnMbEpRexes0spw1Tptrg4j2WRwjPQeTdOJ9TGtODx7
         +u6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9GFw1Go2U+fB4X4rM4wNbKnVxIFKuItgqQdfim6+1I=;
        b=CFs+9JS3yCETUb7qgFUI+MVZGdjwSVeD3AcPMJZVODiipn+DF5Od8vpWKUx00RYwul
         xsOJhXvoqflnsxwUaSBF/DbVtkoMdmEUBiIt/QHcbqW/A4DNwR0/9/TzyluwFg7/g4if
         3y3n25gEOerdGdwLgKNBwCj1/0lspMRzkv1K95yjzmpPlxnsBej7m76xOuP6zKeVASPy
         8nz/ZT3MM+Dw7z93kuL3uv0Hxe7/60fIVdHY8wQ1BAGt3y8yKGLPzEPecUpqHARgWCQ7
         2VTcIsqgPZo5GDOi5vo7Pg88SC+WkchyW60SJOmevFut8LlibkGeN7Umow0V4p/s+brC
         oj8Q==
X-Gm-Message-State: APjAAAWAdnq3G82H1na2RjSy5s2Int6m53lnXjZ3jmvhbOo01mzr+4gD
        kWXv3DAIxTMcX1mfHf97su0WUZrTny5AzcRiFlvJpw==
X-Google-Smtp-Source: APXvYqwdc4EOMDwJzPlb/gSGqbggL2n5jo2GCiKRyMOlyRalKo7cQ4kBFrjtF3PbY1MrkjYUISrXJWpYrKcI74gqZyI=
X-Received: by 2002:a19:e05c:: with SMTP id g28mr42662678lfj.167.1560804820104;
 Mon, 17 Jun 2019 13:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190612113208.21865-1-naveen.n.rao@linux.vnet.ibm.com>
 <CAADnVQLp+N8pYTgmgEGfoubqKrWrnuTBJ9z2qc1rB6+04WfgHA@mail.gmail.com>
 <87sgse26av.fsf@netronome.com> <87r27y25c3.fsf@netronome.com>
 <CAADnVQJZkJu60jy8QoomVssC=z3NE4402bMnfobaWNE_ANC6sg@mail.gmail.com>
 <87ef3w5hew.fsf@netronome.com> <41dfe080-be03-3344-d279-e638a5a6168d@solarflare.com>
 <878su0geyt.fsf@netronome.com> <58d86352-4989-38d6-666b-5e932df9ed46@solarflare.com>
 <877e9kgd39.fsf@netronome.com>
In-Reply-To: <877e9kgd39.fsf@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 17 Jun 2019 13:53:28 -0700
Message-ID: <CAADnVQLt7=9XQRccerLqHO8cdXTLy-uNBt-JOjbx=bAFouLf3Q@mail.gmail.com>
Subject: Re: [PATCH] bpf: optimize constant blinding
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 1:40 PM Jiong Wang <jiong.wang@netronome.com> wrote:
>
> After digest Alexei and Andrii's reply, I still don't see the need to turn
> branch target into list, and I am not sure whether pool based list sound
> good? it saves size, resize pool doesn't invalid allocated node (the offset
> doesn't change) but requires one extra addition to calculate the pointer.

I don't think it worth to do a pool to accelerate kmalloc.
I doubt it will be faster either.
