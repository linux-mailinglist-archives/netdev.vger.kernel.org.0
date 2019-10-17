Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21FF3DB23C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502028AbfJQQWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:22:41 -0400
Received: from correo.us.es ([193.147.175.20]:56862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391091AbfJQQWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 12:22:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4139C4A706E
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 18:22:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31BB1FF13C
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 18:22:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1FCC6B8009; Thu, 17 Oct 2019 18:22:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30B6D59B;
        Thu, 17 Oct 2019 18:22:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 18:22:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0162C42EF4E1;
        Thu, 17 Oct 2019 18:22:34 +0200 (CEST)
Date:   Thu, 17 Oct 2019 18:22:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, saeedm@mellanox.com,
        vishal@chelsio.com, vladbu@mellanox.com, ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at byte
 level
Message-ID: <20191017162237.h4e6bdoosd5b2ipj@salvia>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-4-pablo@netfilter.org>
 <20191016163651.230b60e1@cakuba.netronome.com>
 <20191017161157.rr4lrolsjbnmk3ke@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017161157.rr4lrolsjbnmk3ke@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 06:11:57PM +0200, Pablo Neira Ayuso wrote:
[...]
> >  (3) it causes loss of functionality (looks like a single u32 changing
> >      both sport and dport is rejected by the IR since it wouldn't
> >      match fields);
> 
> Not correct.
> 
> tc filter add dev eth0 protocol ip \
>         parent ffff: \
>         pref 11 \
>         flower ip_proto tcp \
>         dst_port 80 \
>         src_ip 1.1.2.3/24 \
>         action pedit ex munge tcp src 2004 \
>         action pedit ex munge tcp dst 80
> 
> This results in two independent tc pedit actions:
> 
> * One tc pedit action with one single key, with value 0xd4070000 /
>   0x0000ffff.
> * Another tc pedit action with one single key, with value 0x00005000
>   / 0xffff0000.
> 
> This works perfectly with this patchset.

You refer to single u32 word changing both sport and dport.

What's the point with including this in the subset of the uAPI to be
supported?

In software, it really makes sense to use this representation since it
is speeding up packet processing.

In hardware, supporting this uAPI really gets you nothing at all.

We have to document what subset of the uAPI is support through
hardware offloads. Pretending that we can support all uAPI is not
true, we only support for tc pedit extended mode right now.
