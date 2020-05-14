Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E611D38B5
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgENR64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:58:56 -0400
Received: from correo.us.es ([193.147.175.20]:40014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgENR64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 13:58:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4B1DC11EB35
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 19:58:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D7B0DA70F
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 19:58:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 32FFCDA717; Thu, 14 May 2020 19:58:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CE67DA721;
        Thu, 14 May 2020 19:58:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 May 2020 19:58:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1FB2A42EF42A;
        Thu, 14 May 2020 19:58:52 +0200 (CEST)
Date:   Thu, 14 May 2020 19:58:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] libiptc.c: pragma disable a gcc compiler warning
Message-ID: <20200514175851.GA886@salvia>
References: <20200511213404.248715-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200511213404.248715-1-zenczykowski@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 02:34:04PM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Fixes:
>   In file included from libip4tc.c:113:
>   In function ‘iptcc_compile_chain’,
>       inlined from ‘iptcc_compile_table’ at libiptc.c:1246:13,
>       inlined from ‘iptc_commit’ at libiptc.c:2575:8,
>       inlined from ‘iptc_commit’ at libiptc.c:2513:1:
>   libiptc.c:1172:2: warning: writing 16 bytes into a region of size 0 [-Wstringop-overflow=]
>    1172 |  memcpy(&foot->e.counters, &c->counters, sizeof(STRUCT_COUNTERS));
>         |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   In file included from ../include/libiptc/libiptc.h:12,
>                    from libip4tc.c:29:
>   libiptc.c: In function ‘iptc_commit’:
>   ../include/linux/netfilter_ipv4/ip_tables.h:202:19: note: at offset 0 to object ‘entries’ with size 0 declared here
>     202 |  struct ipt_entry entries[0];
>         |                   ^~~~~~~
> 
> Which was found via compilation on Fedora 32.
> 
> Test: builds without warnings
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  libiptc/libiptc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> index 58882015..1a92b267 100644
> --- a/libiptc/libiptc.c
> +++ b/libiptc/libiptc.c
> @@ -1169,7 +1169,10 @@ static int iptcc_compile_chain(struct xtc_handle *h, STRUCT_REPLACE *repl, struc
>  	else
>  		foot->target.verdict = RETURN;
>  	/* set policy-counters */
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Wstringop-overflow"
>  	memcpy(&foot->e.counters, &c->counters, sizeof(STRUCT_COUNTERS));
> +#pragma GCC diagnostic pop

Probably make a casting from foot->e.counters to the counters object
to make gcc happy?
