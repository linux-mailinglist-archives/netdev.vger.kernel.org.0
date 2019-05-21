Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D11825441
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbfEUPnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 11:43:18 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59164 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbfEUPnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:43:18 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x4LFh2nH060385;
        Tue, 21 May 2019 10:43:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1558453383;
        bh=BebSjCfBsCHEUo8I5RDowvI6IDOnbTWjcg7QUO5FfrM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=h0zR2Ex78soeWXHccWYN5lSFojeRjqGReAnhHKRzbOM/jJdQomnfQg7SW6BdB9boI
         ZGYWJvAsuY6yUSt7rZ0LqqvfiVUk6bZSnZZ7AkPrzZXYXaODNtzPlgX3jL6zyBPT3U
         krs8Ghev7wAggZb8m1p7KLQSAQQ4bgZUIFoUkSXU=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x4LFh2UO126742
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 10:43:02 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 21
 May 2019 10:43:02 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 21 May 2019 10:43:01 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x4LFh0dS006810;
        Tue, 21 May 2019 10:43:01 -0500
Subject: Re: [PATCH] hsr: fix don't prune the master node from the node_db
To:     Andreas Oetken <andreas.oetken@siemens.com>
CC:     <andreas@oetken.name>, Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190521105241.16234-1-andreas.oetken@siemens.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <88831c42-41f1-b56a-e0ac-21788292a903@ti.com>
Date:   Tue, 21 May 2019 11:46:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190521105241.16234-1-andreas.oetken@siemens.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andreas,

On 05/21/2019 06:52 AM, Andreas Oetken wrote:
> Don't prune master node in the hsr_prune_nodes function.
> Neither time_in[HSR_PT_SLAVE_A], nor time_in[HSR_PT_SLAVE_B],
> will ever be updated by hsr_register_frame_in for the master port.
> Thus the master node will be repeatedly pruned leading to
> repeated packet loss.
> This bug never appeared because the hsr_prune_nodes function
> was only called once. Since commit 5150b45fd355
> ("net: hsr: Fix node prune function for forget time expiry") this issue
> is fixed unvealing the issue described above.
> 
> Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
> ---
>   net/hsr/hsr_framereg.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index 9af16cb68f76..317cddda494e 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -387,6 +387,14 @@ void hsr_prune_nodes(struct timer_list *t)
>   
>   	rcu_read_lock();
>   	list_for_each_entry_rcu(node, &hsr->node_db, mac_list) {
> +		/* Don't prune own node. Neither time_in[HSR_PT_SLAVE_A]
> +		 * nor time_in[HSR_PT_SLAVE_B], will ever be updated for
> +		 * the master port. Thus the master node will be repeatedly
> +		 * pruned leading to packet loss.
> +		 */
> +		if (hsr_addr_is_self(hsr, node->MacAddressA))
This gives me a compilation issue in the latest master branch

   AR      drivers/base/regmap/built-in.a
   AR      drivers/base/built-in.a
net/hsr/hsr_framereg.c: In function ‘hsr_prune_nodes’:
net/hsr/hsr_framereg.c:373:35: error: ‘struct hsr_node’ has no member 
named ‘MacAddressA’; did you mean ‘macaddress_A’?
    if (hsr_addr_is_self(hsr, node->MacAddressA))
                                    ^~~~~~~~~~~
                                    macaddress_A
   CC      net/core/gen_stats.o
scripts/Makefile.build:278: recipe for target 'net/hsr/hsr_framereg.o' 
failed

Could you address it and re-send?

Thanks

Murali
> +			continue;
> +
>   		/* Shorthand */
>   		time_a = node->time_in[HSR_PT_SLAVE_A];
>   		time_b = node->time_in[HSR_PT_SLAVE_B];
> 

