Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE65460AA
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfFNO0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:26:34 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41906 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbfFNO0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:26:34 -0400
Received: by mail-qt1-f193.google.com with SMTP id 33so2643854qtr.8;
        Fri, 14 Jun 2019 07:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fsH/gim6l6XO8QfAbuJALk4V1gTdlhygBm6XyVxI9qg=;
        b=jfpFSeAQUlfIBpExHyjmqaCtIM2EwUfLpZAkckzOUPiTdDiKYp8K7fiOemtmwiq3jq
         I+txdOa8Dvk7DoCUWiRs2jkOX3od8w2VWuLj/vXR4/hQ8CPNlrGEUe4BuxY/wgOZv8No
         XKVQAut6yLbzNUotLe7cA+wmMzbGuYkBpKgQrbL1UQWatwSdis20WiZSSUMgESokzvdW
         1GcsUS+0AeL7OANQd0M13Zp73mXmsDNSDNRIksg7xHbQSf53cGupF5/e+xlJNicFYx8j
         yDDhSHa6bvOhvsap9plPjddqYXSzuWAqnfbpszChjzjzsm/c0PoaHeTVH0pXdNasNIVZ
         O5Vw==
X-Gm-Message-State: APjAAAV5v4LBj+W09YDXUGN5maogq1DArfOmJDOaOAvMIey6lm5zI//J
        +jcJqfnCrfHcMISRJ6/aPVeweudA+RVXYtmPUObM/A6e
X-Google-Smtp-Source: APXvYqxXhm7TnuxtaEh9KXMmRib1D32rPPmeRe/uOuM/a+gnrmMNxZtrulilU22MG6n4lcM7rLKib+JuXvUF08xN6qk=
X-Received: by 2002:aed:33a4:: with SMTP id v33mr46597878qtd.18.1560522393205;
 Fri, 14 Jun 2019 07:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190608125019.417-1-mcroce@redhat.com> <20190609.195742.739339469351067643.davem@davemloft.net>
 <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org> <CAGnkfhyS15NPEO2ygkjazECULtUDkJgPk8wCYFhA9zL2+w27pg@mail.gmail.com>
 <49b58181-90da-4ee4-cbb0-80e226d040fc@infradead.org> <CAK8P3a1mwnDFeD3xnQ6bm1x8C6yX=YEccxN2jknvTbRiCfD=Bg@mail.gmail.com>
 <47f1889a-e919-e3fd-f90c-39c26cb1ccbb@gmail.com>
In-Reply-To: <47f1889a-e919-e3fd-f90c-39c26cb1ccbb@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 14 Jun 2019 16:26:14 +0200
Message-ID: <CAK8P3a0w3K1O23616g3Nz4XQdgw-xHDPWSQ+Rb_O3VAy-3FnQg@mail.gmail.com>
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
To:     David Ahern <dsahern@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Matteo Croce <mcroce@redhat.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 4:07 PM David Ahern <dsahern@gmail.com> wrote:
> On 6/14/19 8:01 AM, Arnd Bergmann wrote:
> > On Wed, Jun 12, 2019 at 9:41 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> >> On 6/11/19 5:08 PM, Matteo Croce wrote:
> >
> > It clearly shouldn't select PROC_SYSCTL, but I think it should not
> > have a 'depends on' statement either. I think the correct fix for the
> > original problem would have been something like
> >
> > --- a/net/mpls/af_mpls.c
> > +++ b/net/mpls/af_mpls.c
> > @@ -2659,6 +2659,9 @@ static int mpls_net_init(struct net *net)
> >         net->mpls.ip_ttl_propagate = 1;
> >         net->mpls.default_ttl = 255;
> >
> > +       if (!IS_ENABLED(CONFIG_PROC_SYSCTL))
> > +               return 0;
> > +
> >         table = kmemdup(mpls_table, sizeof(mpls_table), GFP_KERNEL);
> >         if (table == NULL)
> >                 return -ENOMEM;
> >
>
> Without sysctl, the entire mpls_router code is disabled. So if sysctl is
> not enabled there is no point in building this file.

Ok, I see.

There are a couple of other drivers that use 'depends on SYSCTL',
which may be the right thing to do here. In theory, one can still
build a kernel with CONFIG_SYSCTRL_SYSCALL=y and no
procfs.

        Arnd
