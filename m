Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8504A998
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfFRSNt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Jun 2019 14:13:49 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37010 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRSNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:13:48 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so16576722qtk.4;
        Tue, 18 Jun 2019 11:13:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w/xlY6xol5lf89nkUnLZ/jayARXa1aMFCE0hjokc+O8=;
        b=fLyYW6ScU7Ty41H+HJz3Mqo4eNbbOaZNn8Q4cWeN21lBs7yww/p93LKHuKcMKK/sBV
         yFGuHtHoWWU7UoJRcVITns1c9+aC+sJ4oj5BHBPQl3BqbfH6vdF/BdeXi6TerB+f7V1W
         2DfZwK6uu009XdTIpgGRB7j/YlQspYDINv5/6oA7t50IxiCYKyB/wRQ5Cl6KLh60myTo
         RQhh/g3YWK3RfJDEU3F5pY+oIB//camBwf/aq3/LJYGJfAboc8aoG4GXpxnsCUf4hP2s
         HiwM2T8+NC/pZgpreIgrXyN+qJ7IBrYNJHETSuksq3h+bYL0qPAKXgrdLE0fjlnz+8IN
         gYug==
X-Gm-Message-State: APjAAAUQ3uiEjUqi/dMgGr9JkOXxRxbIL3/J9v8p7dIA93BDlZ02o7VJ
        d6tprbA80ECoNuopnIOBqY50DpexU85tapwDebY=
X-Google-Smtp-Source: APXvYqxWN9uiDpVCChCHyvJd6aLuZyuz/iLlNyW8I7/V9Xv1Z1pOi4MTh2sG9WE3hIzry6wiyeO2d389bmfue5+Cs/A=
X-Received: by 2002:a0c:d941:: with SMTP id t1mr18022762qvj.176.1560881627568;
 Tue, 18 Jun 2019 11:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190304204019.2142770-1-arnd@arndb.de> <20190308160441.ler2hs44oaozoq7w@salvia>
 <CAF1oqRAuk7h2Z2iheq3Ze1vTMNWLf5HHn83fZt07hXA4nOPbAg@mail.gmail.com> <CAK8P3a2Go0=9wMfOvdw+GGRNqNZ9c2TJy=jN6dB1VR3K8qz-rg@mail.gmail.com>
In-Reply-To: <CAK8P3a2Go0=9wMfOvdw+GGRNqNZ9c2TJy=jN6dB1VR3K8qz-rg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 18 Jun 2019 20:13:31 +0200
Message-ID: <CAK8P3a2wewn5fqK_EB=hCkSN3cXcZbG1i3cZewkz93PGmGDBnA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix IPV6 dependency
To:     =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?TcOhdMOpIEVja2w=?= <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 8:09 PM Arnd Bergmann <arnd@arndb.de> wrote:
> On Fri, Mar 8, 2019 at 5:23 PM Alin Năstac <alin.nastac@gmail.com> wrote:
> > On Fri, Mar 8, 2019 at 5:04 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Mon, Mar 04, 2019 at 09:40:12PM +0100, Arnd Bergmann wrote:
> > > > With CONFIG_IPV6=m and CONFIG_NF_CONNTRACK_SIP=y, we now get a link failure:
> > > >
> > > > net/netfilter/nf_conntrack_sip.o: In function `process_sdp':
> > > > nf_conntrack_sip.c:(.text+0x4344): undefined reference to `ip6_route_output_flags'
> > >
> > > I see. We can probably use nf_route() instead.
> > >
> > > Or if needed, use struct nf_ipv6_ops for this.
> > >
> > >         if (v6ops)
> > >                 ret = v6ops->route_xyz(...);
> > >
> > > @Alin: Would you send us a patch to do so to fix a3419ce3356cf1f
> > > netfilter: nf_conntrack_sip: add sip_external_media logic".
> >
> > nf_ip6_route(net, &dst, &fl6, false) seems to be appropriate.
> > I'll send the patch Monday.
>
> I see the original bug I reported is still there. Can you send that patch
> you had planned to do?

Hmm, I think I mixed up this patch with a different one that is missing.
Please ignore my reply above.

      Arnd
