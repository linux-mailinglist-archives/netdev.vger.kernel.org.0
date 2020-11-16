Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373DD2B4BE6
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbgKPQ6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730972AbgKPQ6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:58:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C4AC0613CF;
        Mon, 16 Nov 2020 08:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=PtPDmo8/GjtPHgHqv0oqP2Nv3aCKfAoH8drpowN9sSU=; b=Ei+IOyRhl+ACi7w2CjFmCR3FnX
        YkebsWLnCfhSnb8pih7QZ3muaC3TWE70sk1nqcbM/P8q34oHSDW0iw3YXx9QqOnEnqiwdUE6TK0eL
        9JaPkWLWSW+b/udRGFdbSiVmgRW2dd1KxPCpYSMF24sWS7zNQTXClWWQ1w6Bdl2FxV+Kv2e0rcNq+
        Ik34Oyb2k3k8j6nC01bhzbvotVIGkcULY30bIIZo2tnKK7zpZ8/bSfeIFz/7lvcXFnwbe23j4+wV5
        cuaRNuOIwyogQMZwcjFYNQLeeXoRY68xF3Ze2knAYWEODBsRic/2se/kEoX9HdE3x+Y26emjaNQIJ
        J5m6bLiw==;
Received: from [2601:1c0:6280:3f0::f32]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kehpw-0006NI-SQ; Mon, 16 Nov 2020 16:58:41 +0000
Subject: Re: [PATCH net-next] netfilter: nf_reject: bridge: fix build errors
 due to code movement
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Jose M . Guisado Gomez" <guigom@riseup.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20201116034203.7264-1-rdunlap@infradead.org>
 <20201116092648.GA405@salvia>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c0200add-7970-dfea-b968-003d33bdfa72@infradead.org>
Date:   Mon, 16 Nov 2020 08:58:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201116092648.GA405@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/20 1:26 AM, Pablo Neira Ayuso wrote:
> Hi,
> 
> Thanks for catching up this.
> 
> On Sun, Nov 15, 2020 at 07:42:03PM -0800, Randy Dunlap wrote:
>> Fix build errors in net/bridge/netfilter/nft_reject_bridge.ko
>> by selecting NF_REJECT_IPV4, which provides the missing symbols.
>>
>> ERROR: modpost: "nf_reject_skb_v4_tcp_reset" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!
>> ERROR: modpost: "nf_reject_skb_v4_unreach" [net/bridge/netfilter/nft_reject_bridge.ko] undefined!
>>
>> Fixes: fa538f7cf05a ("netfilter: nf_reject: add reject skbuff creation helpers")
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: kernel test robot <lkp@intel.com>
>> Cc: Jose M. Guisado Gomez <guigom@riseup.net>
>> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
>> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
>> Cc: Florian Westphal <fw@strlen.de>
>> Cc: netfilter-devel@vger.kernel.org
>> Cc: coreteam@netfilter.org
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> ---
>>  net/bridge/netfilter/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- linux-next-20201113.orig/net/bridge/netfilter/Kconfig
>> +++ linux-next-20201113/net/bridge/netfilter/Kconfig
>> @@ -18,6 +18,7 @@ config NFT_BRIDGE_META
>>  config NFT_BRIDGE_REJECT
>>  	tristate "Netfilter nf_tables bridge reject support"
>>  	depends on NFT_REJECT
>> +	depends on NF_REJECT_IPV4
> 
> I can update the patch here before applying to add:
> 
>         depends on NF_REJECT_IPV6
> 
> as well. It seems both dependencies (IPv4 and IPv6) are missing.
> 
> Thanks.
> 
>>  	help
>>  	  Add support to reject packets.
>>  

Yes, that's good.

Thanks.

-- 
~Randy

