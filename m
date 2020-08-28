Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A496C255EEE
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 18:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgH1Qmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 12:42:40 -0400
Received: from correo.us.es ([193.147.175.20]:46664 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbgH1Qmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 12:42:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D323B18D00D
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 18:42:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3F39DA856
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 18:42:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7010DA84D; Fri, 28 Aug 2020 18:42:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89478DA844;
        Fri, 28 Aug 2020 18:42:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Aug 2020 18:42:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 51A0642EF4E1;
        Fri, 28 Aug 2020 18:42:35 +0200 (CEST)
Date:   Fri, 28 Aug 2020 18:42:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Will McVicker <willmcvicker@google.com>
Cc:     stable@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 1/1] netfilter: nat: add a range check for l3/l4
 protonum
Message-ID: <20200828164234.GA30990@salvia>
References: <20200804113711.GA20988@salvia>
 <20200824193832.853621-1-willmcvicker@google.com>
 <20200824193832.853621-2-willmcvicker@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824193832.853621-2-willmcvicker@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

Given this is for -stable maintainers only, I'd suggest:

1) Specify what -stable kernel versions this patch applies to.
   Explain that this problem is gone since what kernel version.

2) Maybe clarify that this is only for stable in the patch subject,
   e.g. [PATCH -stable v3] netfilter: nat: add a range check for l3/l4

Otherwise, this -stable maintainers might not identify this patch as
something that is targetted to them.

Thanks.

On Mon, Aug 24, 2020 at 07:38:32PM +0000, Will McVicker wrote:
> The indexes to the nf_nat_l[34]protos arrays come from userspace. So
> check the tuple's family, e.g. l3num, when creating the conntrack in
> order to prevent an OOB memory access during setup.  Here is an example
> kernel panic on 4.14.180 when userspace passes in an index greater than
> NFPROTO_NUMPROTO.
> 
> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> Modules linked in:...
> Process poc (pid: 5614, stack limit = 0x00000000a3933121)
> CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
> Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
> task: 000000002a3dfffe task.stack: 00000000a3933121
> pc : __cfi_check_fail+0x1c/0x24
> lr : __cfi_check_fail+0x1c/0x24
> ...
> Call trace:
> __cfi_check_fail+0x1c/0x24
> name_to_dev_t+0x0/0x468
> nfnetlink_parse_nat_setup+0x234/0x258
> ctnetlink_parse_nat_setup+0x4c/0x228
> ctnetlink_new_conntrack+0x590/0xc40
> nfnetlink_rcv_msg+0x31c/0x4d4
> netlink_rcv_skb+0x100/0x184
> nfnetlink_rcv+0xf4/0x180
> netlink_unicast+0x360/0x770
> netlink_sendmsg+0x5a0/0x6a4
> ___sys_sendmsg+0x314/0x46c
> SyS_sendmsg+0xb4/0x108
> el0_svc_naked+0x34/0x38
> 
> Fixes: c1d10adb4a521 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
> Signed-off-by: Will McVicker <willmcvicker@google.com>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 31fa94064a62..0b89609a6e9d 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1129,6 +1129,8 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
>  	if (!tb[CTA_TUPLE_IP])
>  		return -EINVAL;
>  
> +	if (l3num != NFPROTO_IPV4 && l3num != NFPROTO_IPV6)
> +		return -EOPNOTSUPP;
>  	tuple->src.l3num = l3num;
>  
>  	err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple);
> -- 
> 2.28.0.297.g1956fa8f8d-goog
> 
