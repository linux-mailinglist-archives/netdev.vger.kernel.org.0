Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A49F45FD9
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfFNOB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:01:27 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39266 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbfFNOB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:01:27 -0400
Received: by mail-qt1-f194.google.com with SMTP id i34so2538109qta.6;
        Fri, 14 Jun 2019 07:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wpw3AWpfObWMxUO5E9/EiXoVCL1fsmyaqZTpwMAOnN4=;
        b=N0OuxOVQi12nddEcHPJuUChIPpM2OxpKMcOvJbKT4gjY1imfUyCp31lqxWnnSpK5px
         SsCKCLwWuC28ZmjMxrDNFB6Wf1O0tPI/Ifonn7UdF1GayYNb8KY15mAQvGLN/Gca1Jq/
         xacAaV7JaVQ8WRZSosoJG5NxbUfLRQ04+rQqTnfZ6j97bAm1wnp+w/2ZtVy25g3cObpI
         Dq/mGy3+jT2gO11mIO1wIMTw6vp3VSYRjABp4eQsWyfLdtVg34lJ1JsvGOJAvVSpX6Xf
         03vnGcuLBEk4u5kHbxL3bo8nci9jW1boh5mQQ8In3ubA+0iQnHVRwl1duDln7ifpm7NM
         JMlw==
X-Gm-Message-State: APjAAAV5jz+OcwKM77/hVDXCIu/dwYgGsccoQ18ifsaIlXqr10fFHB2J
        I2c5/qUku0CIMf8Co+LxeFpP2Jj0TBPtDKaYlSI=
X-Google-Smtp-Source: APXvYqzCSmCVbwwTOwLPtqV1HEGZ8gC9pwYWAUVrnDvtG7SjzmKaFkXZI+FEsL178qgIHTzOOGWG1po2Yh4TFf6b85w=
X-Received: by 2002:a0c:9e0f:: with SMTP id p15mr8426675qve.176.1560520885824;
 Fri, 14 Jun 2019 07:01:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190608125019.417-1-mcroce@redhat.com> <20190609.195742.739339469351067643.davem@davemloft.net>
 <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org> <CAGnkfhyS15NPEO2ygkjazECULtUDkJgPk8wCYFhA9zL2+w27pg@mail.gmail.com>
 <49b58181-90da-4ee4-cbb0-80e226d040fc@infradead.org>
In-Reply-To: <49b58181-90da-4ee4-cbb0-80e226d040fc@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 14 Jun 2019 16:01:09 +0200
Message-ID: <CAK8P3a1mwnDFeD3xnQ6bm1x8C6yX=YEccxN2jknvTbRiCfD=Bg@mail.gmail.com>
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Matteo Croce <mcroce@redhat.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 9:41 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> On 6/11/19 5:08 PM, Matteo Croce wrote:
> > On Wed, Jun 12, 2019 at 1:07 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> > * Configure standard kernel features (expert users)
> > *
> > Configure standard kernel features (expert users) (EXPERT) [Y/?] y
> >   Multiple users, groups and capabilities support (MULTIUSER) [Y/n/?] y
> >   sgetmask/ssetmask syscalls support (SGETMASK_SYSCALL) [N/y/?] n
> >   Sysfs syscall support (SYSFS_SYSCALL) [N/y/?] n
> >   Sysctl syscall support (SYSCTL_SYSCALL) [N/y/?] (NEW)
>
> So I still say that MPLS_ROUTING should depend on PROC_SYSCTL,
> not select it.

It clearly shouldn't select PROC_SYSCTL, but I think it should not
have a 'depends on' statement either. I think the correct fix for the
original problem would have been something like

--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2659,6 +2659,9 @@ static int mpls_net_init(struct net *net)
        net->mpls.ip_ttl_propagate = 1;
        net->mpls.default_ttl = 255;

+       if (!IS_ENABLED(CONFIG_PROC_SYSCTL))
+               return 0;
+
        table = kmemdup(mpls_table, sizeof(mpls_table), GFP_KERNEL);
        if (table == NULL)
                return -ENOMEM;
