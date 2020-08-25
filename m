Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939ED2523C7
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 00:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgHYWrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 18:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgHYWri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 18:47:38 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57A8C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 15:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=1oYN+RG/fj4y1sMv5AhatKH6mvUnJq87n/PGVTOGtXo=; b=JWAVACNc1EBijZpeCba+mLAiZR
        Ueyt8ovgAGADmGkYMgLy7cHmnTYEltmwsFyd2KzW2HNlKCi/1UV+u41H0uZ3dcQoW8RVE/TVlBT6D
        8RXruk1+91aR+WkA/feqC4alUbZsS+zM5Y6wTGVBzoMUU5Nik2vJaNaPkI6QKaIaSsXl4Ibbu7kNp
        sa6ZhpkKwICcxArdyWAdfUhgjyzfmlQ0P8d0//suKx6OyR1f47t66CSyiaSC8zQIMnpTD6L3Jxcjy
        qhAPT8qMJ7+KCHeQRVdYUVbPlc9BVLvSLFfAyJXmKCrdEPZLey2YI8DEssZW/2nyNNwbnie+yOBvc
        E6kKNyCw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAhj0-0006Xd-84; Tue, 25 Aug 2020 22:47:30 +0000
Subject: Re: [PATCHv2 next] net: add option to not create fall-back tunnels in
 root-ns as well
To:     Mahesh Bandewar <maheshb@google.com>,
        Netdev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Maciej Zenczykowski <maze@google.com>,
        Jian Yang <jianyang@google.com>
References: <20200825224208.1268641-1-maheshb@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9fce7d7e-aa33-a451-ab4a-a297b1317310@infradead.org>
Date:   Tue, 25 Aug 2020 15:47:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825224208.1268641-1-maheshb@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/20 3:42 PM, Mahesh Bandewar wrote:
> The sysctl that was added  earlier by commit 79134e6ce2c ("net: do
> not create fallback tunnels for non-default namespaces") to create
> fall-back only in root-ns. This patch enhances that behavior to provide
> option not to create fallback tunnels in root-ns as well. Since modules
> that create fallback tunnels could be built-in and setting the sysctl
> value after booting is pointless, so added a kernel cmdline options to
> change this default. The default setting is preseved for backward
> compatibility. The kernel command line option of fb_tunnels=initns will
> set the sysctl value to 1 and will create fallback tunnels only in initns
> while kernel cmdline fb_tunnels=none will set the sysctl value to 2 and
> fallback tunnels are skipped in every netns.
> 
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Maciej Zenczykowski <maze@google.com>
> Cc: Jian Yang <jianyang@google.com>
> ---
> v1->v2
>   Removed the Kconfig option which would force rebuild and replaced with
>   kcmd-line option
> 
>  .../admin-guide/kernel-parameters.txt         |  5 +++++
>  Documentation/admin-guide/sysctl/net.rst      | 20 +++++++++++++------
>  include/linux/netdevice.h                     |  7 ++++++-
>  net/core/sysctl_net_core.c                    | 17 ++++++++++++++--
>  4 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a1068742a6df..09a51598c792 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -801,6 +801,11 @@
>  
>  	debug_objects	[KNL] Enable object debugging
>  
> +	fb_tunnels=	[NET]
> +			Format: { initns | none }
> +			See Documentation/admin-guide/sysctl/net.rst for
> +			fb_tunnels_only_for_init_ns
> +

Not at this location in this file.
Entries in this file are meant to be in alphabetical order (mostly).

So leave debug_objects and no_debug_objects together, and insert fb_tunnels
between fail_make_request= and floppy=.

Thanks.

>  	no_debug_objects
>  			[KNL] Disable object debugging
>  

-- 
~Randy

