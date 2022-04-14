Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED5500C27
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242682AbiDNLat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbiDNLas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:30:48 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED99B793BE;
        Thu, 14 Apr 2022 04:28:22 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nexe8-0004nU-GT; Thu, 14 Apr 2022 13:28:20 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nexe8-000PZ9-8X; Thu, 14 Apr 2022 13:28:20 +0200
Subject: Re: [PATCH net 1/2] wireguard: device: fix metadata_dst xmit null
 pointer dereference
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     Martynas Pumputis <m@lambda.lt>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, wireguard@lists.zx2c4.com,
        kuba@kernel.org, davem@davemloft.net, stable@vger.kernel.org
References: <20220414104458.3097244-1-razor@blackwall.org>
 <20220414104458.3097244-2-razor@blackwall.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <24cac92b-4981-4ddc-9a05-32b61799e688@iogearbox.net>
Date:   Thu, 14 Apr 2022 13:28:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220414104458.3097244-2-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26512/Thu Apr 14 10:28:56 2022)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/22 12:44 PM, Nikolay Aleksandrov wrote:
> When we try to transmit an skb with md_dst attached through wireguard
> we hit a null pointer dereference[1] in wg_xmit() due to the use of
> dst_mtu() which calls into dst_blackhole_mtu() which in turn tries to
> dereference dst->dev. Since wireguard doesn't use md_dsts we should use
> skb_valid_dst() which checks for DST_METADATA flag and if it's set then
> fallback to wireguard's device mtu. That gives us the best chance of
> transmitting the packet, otherwise if the blackhole netdev is used we'd
> get ETH_MIN_MTU.
> 
[...]
> 
> CC: stable@vger.kernel.org
> CC: wireguard@lists.zx2c4.com
> CC: Jason A. Donenfeld <Jason@zx2c4.com>
> CC: Daniel Borkmann <daniel@iogearbox.net>
> CC: Martynas Pumputis <m@lambda.lt>
> Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
> Reported-by: Martynas Pumputis <m@lambda.lt>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>

Looks good to me, thanks Nik!

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
