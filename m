Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A42923B9A7
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 13:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgHDLhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 07:37:20 -0400
Received: from correo.us.es ([193.147.175.20]:57976 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgHDLhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 07:37:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB2F6F2DEB
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 13:37:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD034DA852
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 13:37:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A6AC3DA7B6; Tue,  4 Aug 2020 13:37:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76A96DA73D;
        Tue,  4 Aug 2020 13:37:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 13:37:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [213.143.49.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EF7F042EE38E;
        Tue,  4 Aug 2020 13:37:14 +0200 (CEST)
Date:   Tue, 4 Aug 2020 13:37:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     William Mcvicker <willmcvicker@google.com>
Cc:     security@kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] netfilter: nat: add a range check for l3/l4
 protonum
Message-ID: <20200804113711.GA20988@salvia>
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com>
 <20200729214607.GA30831@salvia>
 <20200731002611.GA1035680@google.com>
 <20200731175115.GA16982@salvia>
 <20200731181633.GA1209076@google.com>
 <20200803183156.GA3084830@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803183156.GA3084830@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch is much smaller and if you confirm this is address the
issue, then this is awesome.

On Mon, Aug 03, 2020 at 06:31:56PM +0000, William Mcvicker wrote:
[...]
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 31fa94064a62..56d310f8b29a 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1129,6 +1129,8 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
>  	if (!tb[CTA_TUPLE_IP])
>  		return -EINVAL;
>  
> +	if (l3num >= NFPROTO_NUMPROTO)
> +		return -EINVAL;

l3num can only be either NFPROTO_IPV4 or NFPROTO_IPV6.

Other than that, bail out with EOPNOTSUPP.

Thank you.
