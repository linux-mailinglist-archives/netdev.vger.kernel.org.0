Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1B6199BD0
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbgCaQjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:39:14 -0400
Received: from correo.us.es ([193.147.175.20]:37626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731182AbgCaQjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 12:39:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92F6BEBACA
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 18:39:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8405012395E
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 18:39:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 640AB123963; Tue, 31 Mar 2020 18:39:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05C99DA736;
        Tue, 31 Mar 2020 18:39:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 18:39:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DC4AA4301DE0;
        Tue, 31 Mar 2020 18:39:04 +0200 (CEST)
Date:   Tue, 31 Mar 2020 18:39:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
Message-ID: <20200331163904.ilucynm3brvgfezw@salvia>
References: <20200331163559.132240-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200331163559.132240-1-zenczykowski@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 09:35:59AM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Android has long had an extension to IDLETIMER to send netlink
> messages to userspace, see:
>   https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/include/uapi/linux/netfilter/xt_IDLETIMER.h#42
> Note: this is idletimer target rev 1, there is no rev 0 in
> the Android common kernel sources, see registration at:
>   https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/net/netfilter/xt_IDLETIMER.c#483
> 
> When we compare that to upstream's new idletimer target rev 1:
>   https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/tree/include/uapi/linux/netfilter/xt_IDLETIMER.h#n46
> 
> We immediately notice that these two rev 1 structs are the
> same size and layout, and that while timer_type and send_nl_msg
> are differently named and serve a different purpose, they're
> at the same offset.
> 
> This makes them impossible to tell apart - and thus one cannot
> know in a mixed Android/vanilla environment whether one means
> timer_type or send_nl_msg.
> 
> Since this is iptables/netfilter uapi it introduces a problem
> between iptables (vanilla vs Android) userspace and kernel
> (vanilla vs Android) if the two don't match each other.
> 
> Additionally when at some point in the future Android picks up
> 5.7+ it's not at all clear how to resolve the resulting merge
> conflict.
> 
> Furthermore, since upgrading the kernel on old Android phones
> is pretty much impossible there does not seem to be an easy way
> out of this predicament.
> 
> The only thing I've been able to come up with is some super
> disgusting kernel version >= 5.7 check in the iptables binary
> to flip between different struct layouts.
> 
> By adding a dummy field to the vanilla Linux kernel header file
> we can force the two structs to be compatible with each other.
> 
> Long term I think I would like to deprecate send_nl_msg out of
> Android entirely, but I haven't quite been able to figure out
> exactly how we depend on it.  It seems to be very similar to
> sysfs notifications but with some extra info.
> 
> Currently it's actually always enabled whenever Android uses
> the IDLETIMER target, so we could also probably entirely
> remove it from the uapi in favour of just always enabling it,
> but again we can't upgrade old kernels already in the field.
> 
> (Also note that this doesn't change the structure's size,
> as it is simply fitting into the pre-existing padding, and
> that since 5.7 hasn't been released yet, there's still time
> to make this uapi visible change)
> 
> Cc: Manoj Basapathi <manojbm@codeaurora.org>
> Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  include/uapi/linux/netfilter/xt_IDLETIMER.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
> index 434e6506abaa..49ddcdc61c09 100644
> --- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
> +++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
> @@ -48,6 +48,7 @@ struct idletimer_tg_info_v1 {
>  
>  	char label[MAX_IDLETIMER_LABEL_SIZE];
>  
> +	__u8 send_nl_msg;   /* unused: for compatibility with Android */

Please, add client code for this send_nl_msg field.

Thank you.
