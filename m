Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18C614525F
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgAVKQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:16:54 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47890 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbgAVKQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:16:54 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4802E48005F;
        Wed, 22 Jan 2020 10:16:52 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 22 Jan
 2020 10:16:45 +0000
Subject: Re: [PATCH net v2] net: Fix packet reordering caused by GRO and
 listified RX cooperation
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>
References: <20200121150917.6279-1-maximmi@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <df97177e-0b73-8173-584a-54643c6cac6f@solarflare.com>
Date:   Wed, 22 Jan 2020 10:16:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200121150917.6279-1-maximmi@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25182.003
X-TM-AS-Result: No-9.683200-8.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1j4ECMHJTM/ufZvT2zYoYOwC/ExpXrHizwZFDQxUvPcmHHU
        HCqTYbHtYAIccCx167ZNO6zg+DuNub0kF91WvsxyHC7hAz/oKnIGchEhVwJY3+/B4+w4rEIoXbc
        3p8FzfQ9ptlksWquS/bmfJmowNGYSiMZbbAaMrx6a+cpJvTbSHOdppbZRNp/ISg8ufp5n3T7Ljq
        rNNKG3t2CgtpuqkYfNslpqQqeaW5whI43itsPGuSD3NF+wUeO9fglgnB0nDhOExk6c4qzx8ognL
        dHU7oiOj7s+B55MfTuk0VYTefV9UGThjzEdM4lcoxjrap5AGQs5iooXtStiHlAoBBK61BhcWl4l
        rHxOiZQGS8HOsupFLgN9nYxBzliar78SC5iivxyDGx/OQ1GV8rHlqZYrZqdI+gtHj7OwNO2+Szu
        wiNJ7e7BpPzUcDsR0bcSd9+Q1VxCPGv3NCL5uToTfQzyJaFyAVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.683200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25182.003
X-MDID: 1579688213-wsPgfQ1bjfxL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2020 15:09, Maxim Mikityanskiy wrote:
> Commit 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL
> skbs") introduces batching of GRO_NORMAL packets in napi_frags_finish,
> and commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()") adds the same to napi_skb_finish. However,
> dev_gro_receive (that is called just before napi_{frags,skb}_finish) can
> also pass skbs to the networking stack: e.g., when the GRO session is
> flushed, napi_gro_complete is called, which passes pp directly to
> netif_receive_skb_internal, skipping napi->rx_list. It means that the
> packet stored in pp will be handled by the stack earlier than the
> packets that arrived before, but are still waiting in napi->rx_list. It
> leads to TCP reorderings that can be observed in the TCPOFOQueue counter
> in netstat.
>
> This commit fixes the reordering issue by making napi_gro_complete also
> use napi->rx_list, so that all packets going through GRO will keep their
> order. In order to keep napi_gro_flush working properly, gro_normal_list
> calls are moved after the flush to clear napi->rx_list.
>
> iwlwifi calls napi_gro_flush directly and does the same thing that is
> done by gro_normal_list, so the same change is applied there:
> napi_gro_flush is moved to be before the flush of napi->rx_list.
>
> A few other drivers also use napi_gro_flush (brocade/bna/bnad.c,
> cortina/gemini.c, hisilicon/hns3/hns3_enet.c). The first two also use
> napi_complete_done afterwards, which performs the gro_normal_list flush,
> so they are fine. The latter calls napi_gro_receive right after
> napi_gro_flush, so it can end up with non-empty napi->rx_list anyway.
>
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Cc: Alexander Lobakin <alobakin@dlink.ru>
> Cc: Edward Cree <ecree@solarflare.com>
> ---
> v2 changes:
>
> Flush napi->rx_list after napi_gro_flush, not before. Do it in iwlwifi
> as well.
I believe David prefers for patch change logs to go in the commit message,
 not below the line.
> Please also pay attention that there is gro_flush_oldest that also calls
> napi_gro_complete and DOESN'T do gro_normal_list to flush napi->rx_list.
> I guess, it's not required in this flow, but if I'm wrong, please tell
> me.
>
>  drivers/net/wireless/intel/iwlwifi/pcie/rx.c |  4 +-
>  net/core/dev.c                               | 64 ++++++++++----------
>  2 files changed, 35 insertions(+), 33 deletions(-)
Acked-by: Edward Cree <ecree@solarflare.com>
