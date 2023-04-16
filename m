Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9396E3A4A
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjDPQhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDPQhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:37:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381231BE1
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 09:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C09B260EBB
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 16:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E14C433D2;
        Sun, 16 Apr 2023 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681663037;
        bh=q0Vk6M5A7ef9oGSMo4zVB01fnoE09Hu9/Z6IzpqNeNA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qZTMgTefkh03Te/Ih+/gXq8JumY2BQwziX76Xr6LQkKWNY3AvxFIifKhluU5hY+WI
         +u/pHwx8aZgJZM9VsvB32G/5INxrxfK5B5DBVObyc0s9YFkWpchckjjynezWGEMpXu
         TYicixUzhpNsEkiHUDAuDE4gKdYbiYWIcR2HsG3Zp5/oKbAKYb8fScPaifd0pKGfeo
         U/KKLabUlUezYpYKEfrMf4wGVcK1hK6dDAT/AxALy6wyS6+793e810mr9J90RJHeM8
         zqPGQYCv3QkxzJTeb4Wj2IPHSsHwCLH7al5ZtlFda9VJHL5GR9uXwyBDgNN4lFp13r
         zh6uZ+S7EcpYQ==
Message-ID: <2501c864-cbca-0b81-2e6a-0ee63473c31c@kernel.org>
Date:   Sun, 16 Apr 2023 10:37:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH net] net: rpl: fix rpl header size calculation
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.aring@gmail.com, daniel@iogearbox.net,
        ymittal@redhat.com, mcascell@redhat.com,
        torvalds@linuxfoundation.org, mcr@sandelman.ca
References: <20230415210506.2283603-1-aahringo@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230415210506.2283603-1-aahringo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/23 3:05 PM, Alexander Aring wrote:
> diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
> index 488aec9e1a74..16e19fec18a4 100644
> --- a/net/ipv6/rpl.c
> +++ b/net/ipv6/rpl.c
> @@ -32,7 +32,7 @@ static void *ipv6_rpl_segdata_pos(const struct ipv6_rpl_sr_hdr *hdr, int i)
>  size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
>  			 unsigned char cmpre)
>  {
> -	return (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
> +	return 8 + (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);



no magic numbers; there should be a macro for that size.
