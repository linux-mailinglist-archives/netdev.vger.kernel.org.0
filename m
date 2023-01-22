Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB33A67724E
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 21:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjAVUVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 15:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjAVUVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 15:21:41 -0500
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726B715CA2;
        Sun, 22 Jan 2023 12:21:24 -0800 (PST)
Received: from [192.168.0.2] (ip5f5ae93c.dynamic.kabel-deutschland.de [95.90.233.60])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6E30F61CC457B;
        Sun, 22 Jan 2023 21:21:21 +0100 (CET)
Message-ID: <1bb796f9-b2dd-1c96-831a-34585770d80d@molgen.mpg.de>
Date:   Sun, 22 Jan 2023 21:21:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH net] ixgbe: allow to increase MTU to
 some extent with XDP enalbed
Content-Language: en-US
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.co,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
References: <20230121085521.9566-1-kerneljasonxing@gmail.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230121085521.9566-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jason,


Thank you for your patch.

Am 21.01.23 um 09:55 schrieb Jason Xing:
> From: Jason Xing <kernelxing@tencent.com>

There is a small typo in the summary: ena*bl*ed

> I encountered one case where I cannot increase the MTU size with XDP
> enabled if the server is equipped with IXGBE card, which happened on
> thousands of servers. I noticed it was prohibited from 2017[1] and

That’s included since Linux 4.19-rc1.

> added size checks[2] if allowed soon after the previous patch.
> 
> Interesting part goes like this:
> 1) Changing MTU directly from 1500 (default value) to 2000 doesn't
> work because the driver finds out that 'new_frame_size >
> ixgbe_rx_bufsz(ring)' in ixgbe_change_mtu() function.
> 2) However, if we change MTU to 1501 then change from 1501 to 2000, it
> does work, because the driver sets __IXGBE_RX_3K_BUFFER when MTU size
> is converted to 1501, which later size check policy allows.
> 
> The default MTU value for most servers is 1500 which cannot be adjusted
> directly to the value larger than IXGBE_MAX_2K_FRAME_BUILD_SKB (1534 or
> 1536) if it loads XDP.
> 
> After I do a quick study on the manner of i40E driver allowing two kinds
> of buffer size (one is 2048 while another is 3072) to support XDP mode in
> i40e_max_xdp_frame_size(), I believe the default MTU size is possibly not
> satisfied in XDP mode when IXGBE driver is in use, we sometimes need to
> insert a new header, say, vxlan header. So setting the 3K-buffer flag
> could solve the issue.

What card did you test with exactly?

> [1] commit 38b7e7f8ae82 ("ixgbe: Do not allow LRO or MTU change with XDP")
> [2] commit fabf1bce103a ("ixgbe: Prevent unsupported configurations with
> XDP")

I’d say to not break the line in references.

> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..dc016582f91e 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -4313,6 +4313,9 @@ static void ixgbe_set_rx_buffer_len(struct ixgbe_adapter *adapter)
>   		if (IXGBE_2K_TOO_SMALL_WITH_PADDING ||
>   		    (max_frame > (ETH_FRAME_LEN + ETH_FCS_LEN)))
>   			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
> +
> +		if (ixgbe_enabled_xdp_adapter(adapter))
> +			set_bit(__IXGBE_RX_3K_BUFFER, &rx_ring->state);
>   #endif
>   	}
>   }


Kind regards,

Paul
