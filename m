Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F614EE5C9
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 03:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbiDABnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 21:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbiDABnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 21:43:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC58256679
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 18:41:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72F4FB822B3
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 01:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF04C340ED;
        Fri,  1 Apr 2022 01:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648777272;
        bh=IYG4oFYimfFnga7P1+WSKoisadAQx2CM/7ZkW6EVbmo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ETDg1cUQ/EfBWtcO6xuZ8fuJOTuPJqb03HntECY1maOssbSocNvHjwyiKTaPVx+HY
         XrOc+X3nqjvF7M2fVy3O3Y9TwtmGeubWOyDKmtUzEFyBBXeK9ngyT/W7Y1rBvTCjKK
         TkSOeidaaTf/qA3QF6xQm2Rp7Tyy2YfILYxtoLWfDL87e7duSqI2fRYEGfJuQ2poQ6
         Is+P2+hXbdn1up/aWjVAAVpoSVL3KTHyulCPnqnFkxwCDhSxySufVigX9z3pGUUrGb
         x7yP/cjfhCdQ4fL6ns9bZuVDGfmOT+6s2zpAowYOtoYvycbNx+FFYxXn3JbTi8GQQu
         6XU56qKXkFRrA==
Message-ID: <d49e7e72-49cd-fbc7-1b2e-7cc6e38b1dc6@kernel.org>
Date:   Thu, 31 Mar 2022 19:41:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net] vrf: fix packet sniffing for traffic originating from
 ip tunnels
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, andrea.mayer@uniroma2.it
Cc:     netdev@vger.kernel.org
References: <20220331072643.3026742-1-eyal.birger@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220331072643.3026742-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/22 1:26 AM, Eyal Birger wrote:
> in commit 048939088220
> ("vrf: add mac header for tunneled packets when sniffer is attached")
> an Ethernet header was cooked for traffic originating from tunnel devices.
> 
> However, the header is added based on whether the mac_header is unset
> and ignores cases where the device doesn't expose a mac header to upper
> layers, such as in ip tunnels like ipip and gre.
> 
> Traffic originating from such devices still appears garbled when capturing
> on the vrf device.
> 
> Fix by observing whether the original device exposes a header to upper
> layers, similar to the logic done in af_packet.
> 
> In addition, skb->mac_len needs to be adjusted after adding the Ethernet
> header for the skb_push/pull() surrounding dev_queue_xmit_nit() to work
> on these packets.
> 
> Fixes: 048939088220 ("vrf: add mac header for tunneled packets when sniffer is attached")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---
>  drivers/net/vrf.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


