Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBAD5C284
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfGASB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:01:59 -0400
Received: from mail.us.es ([193.147.175.20]:45088 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbfGASB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 14:01:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B7F4511F02C
        for <netdev@vger.kernel.org>; Mon,  1 Jul 2019 20:01:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9015114D9A
        for <netdev@vger.kernel.org>; Mon,  1 Jul 2019 20:01:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 961A2FB37C; Mon,  1 Jul 2019 20:01:55 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C068DA704;
        Mon,  1 Jul 2019 20:01:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 01 Jul 2019 20:01:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 414634265A2F;
        Mon,  1 Jul 2019 20:01:53 +0200 (CEST)
Date:   Mon, 1 Jul 2019 20:01:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     David Ahern <dsahern@gmail.com>,
        "kadlec@blackhole.kfki.hu" <kadlec@blackhole.kfki.hu>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mingfangsen <mingfangsen@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjRdIG5l?= =?utf-8?Q?t=3A?=
 netfilter: Fix rpfilter dropping vrf packets by mistake
Message-ID: <20190701180152.65ajqxmht56dxmxi@salvia>
References: <2213b3e722a14ee48768ecc7118efc46@huawei.com>
 <08740476-acfb-d35a-50b7-3aee42f23bfa@gmail.com>
 <cef929f9a14f462f9f7d3fa475f84e76@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cef929f9a14f462f9f7d3fa475f84e76@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 02:13:59PM +0000, linmiaohe wrote:
> On 6/29/19 20:20 PM, David Ahern wrote:
> > On 6/28/19 8:13 PM, linmiaohe wrote:
> > > You're right. Fib rules code would set FLOWI_FLAG_SKIP_NH_OIF flag.  
> > > But I set it here for distinguish with the flags & XT_RPFILTER_LOOSE 
> > > branch. Without this, they do the same work and maybe should be  
> > > combined. I don't want to do that as that makes code confusing.
> > > Is this code snipet below ok ? If so, I would delete this flag setting.
> > >  
> > >        } else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev)) {
> > >                fl6.flowi6_oif = dev->ifindex;
> > >         } else if ((flags & XT_RPFILTER_LOOSE) == 0)
> > >                 fl6.flowi6_oif = dev->ifindex;
> 
> > that looks fine to me, but it is up to Pablo.
> 
> @David Ahern  Many thanks for your valuable advice.
> 
> @ Pablo Hi, could you please tell me if this code snipet is ok?
> If not, which code would you prefer? It's very nice of you to
> figure it out for me. Thanks a lot.

Probably this?

        } else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev) ||
                   (flags & XT_RPFILTER_LOOSE) == 0) {
                fl6.flowi6_oif = dev->ifindex;
        }

Thanks.
