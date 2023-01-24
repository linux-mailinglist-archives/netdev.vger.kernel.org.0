Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BF96795BD
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjAXKuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjAXKuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:50:09 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B368449E;
        Tue, 24 Jan 2023 02:49:47 -0800 (PST)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 26D3B60027FD0;
        Tue, 24 Jan 2023 11:49:44 +0100 (CET)
Message-ID: <a23d0eb5-123f-a2ad-5585-59147bb9b172@molgen.mpg.de>
Date:   Tue, 24 Jan 2023 11:49:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH RESEND] igbvf: Fix rx_buffer_len
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        Yan Vugenfirer <yvugenfi@redhat.com>,
        linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20230124043915.12952-1-akihiko.odaki@daynix.com>
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230124043915.12952-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Akihiko,


Thank you for your patch.

Am 24.01.23 um 05:39 schrieb Akihiko Odaki:

Maybe improve the commit message summary to be more specific:

igbvf: Align rx_buffer_len to fix memory corrption

> When rx_buffer_len is not aligned by 1024, igbvf sets the aligned size
> to SRRCTL while the buffer is allocated with the unaligned size. This
> allows the device to write more data than rx_buffer_len, resulting in
> memory corruption. Align rx_buffer_len itself so that the buffer will
> be allocated with the aligned size.
> 
> The condition to split RX packet header, which uses rx_buffer_len, is
> also modified so that it doesn't change the behavior for the same
> actual (unaligned) packet size. Actually the new condition is not
> identical with the old one as it will no longer request splitting when
> the actual packet size is exactly 2048, but that should be negligible.

Is there an easy way to reproduce it?


Kind regards,

Paul


> Fixes: d4e0fe01a38a ("igbvf: add new driver to support 82576 virtual functions")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   drivers/net/ethernet/intel/igbvf/netdev.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
> index 3a32809510fc..b6bca78198fa 100644
> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c
> @@ -1341,10 +1341,9 @@ static void igbvf_setup_srrctl(struct igbvf_adapter *adapter)
>   	srrctl |= E1000_SRRCTL_DROP_EN;
>   
>   	/* Setup buffer sizes */
> -	srrctl |= ALIGN(adapter->rx_buffer_len, 1024) >>
> -		  E1000_SRRCTL_BSIZEPKT_SHIFT;
> +	srrctl |= adapter->rx_buffer_len >> E1000_SRRCTL_BSIZEPKT_SHIFT;
>   
> -	if (adapter->rx_buffer_len < 2048) {
> +	if (adapter->rx_buffer_len <= 2048) {
>   		adapter->rx_ps_hdr_size = 0;
>   		srrctl |= E1000_SRRCTL_DESCTYPE_ADV_ONEBUF;
>   	} else {
> @@ -1625,7 +1624,7 @@ static int igbvf_sw_init(struct igbvf_adapter *adapter)
>   	struct net_device *netdev = adapter->netdev;
>   	s32 rc;
>   
> -	adapter->rx_buffer_len = ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN;
> +	adapter->rx_buffer_len = ALIGN(ETH_FRAME_LEN + VLAN_HLEN + ETH_FCS_LEN, 1024);
>   	adapter->rx_ps_hdr_size = 0;
>   	adapter->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
>   	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
> @@ -2429,6 +2428,8 @@ static int igbvf_change_mtu(struct net_device *netdev, int new_mtu)
>   		adapter->rx_buffer_len = ETH_FRAME_LEN + VLAN_HLEN +
>   					 ETH_FCS_LEN;
>   
> +	adapter->rx_buffer_len = ALIGN(adapter->rx_buffer_len, 1024);
> +
>   	netdev_dbg(netdev, "changing MTU from %d to %d\n",
>   		   netdev->mtu, new_mtu);
>   	netdev->mtu = new_mtu;
