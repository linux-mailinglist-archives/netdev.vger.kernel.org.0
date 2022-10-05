Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A57E5F5A99
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 21:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiJET23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 15:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiJET2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 15:28:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6C42CE2E
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 12:28:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA358B81F2D
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 19:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33899C433D6;
        Wed,  5 Oct 2022 19:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664998080;
        bh=w8qLDQG7LAM+h+Wjop64rA2JGBRFHfVRe+zsh39tVCk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mSOng3B0sUWzgfznq3oTAJNoDcpqFbmhxkbCmaOHuOv1aKVhB1+Ysnt4V4p1rgw6d
         QwetIxf7grj2XaWLYSYKPzL6HAWIYzNb7XSDg0P7DzbLXVDhBiswxfy4A6s/Y3XiaY
         zD9WtMKMfxEvA5MyvLbyC5l+TTBtnOn+I3gW0vqGSuc4lGC3UtONTh+igH7ms8jO/i
         E5To9CBxV1qFmH/22JcZACIw+awGQIFqAmPf9ZTGUAEn0LpIsU2nb3usKZaw0XMb0p
         TeaNv33IPsaFnunbsEmLTCZ78bKcxg/DwhMWByFcTd2aSGe0RctENoAScnHJtx3oT4
         BtbGijrGYq9yQ==
Message-ID: <84202713-ec7c-1e5e-8d9f-d36e715c81e4@kernel.org>
Date:   Wed, 5 Oct 2022 13:27:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net] ipv4: Handle attempt to delete multipath route when
 fib_info contains an nh reference
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        netdev@vger.kernel.org, Gwangun Jung <exsociety@gmail.com>
References: <20221005181257.8897-1-dsahern@kernel.org>
 <Yz3WE+cBd9YUj7Bp@shredder>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <Yz3WE+cBd9YUj7Bp@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/22 1:08 PM, Ido Schimmel wrote:
> On Wed, Oct 05, 2022 at 12:12:57PM -0600, David Ahern wrote:
>> Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
>>     fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
>>     fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
>>     inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874
>>
>> Separate nexthop objects are mutually exclusive with the legacy
>> multipath spec. Fix fib_nh_match to return if the config for the
>> to be deleted route contains a multipath spec while the fib_info
>> is using a nexthop object.
> 
> Cool bug... Managed to reproduce with:
> 
>  # ip nexthop add id 1 blackhole
>  # ip route add 192.0.2.0/24 nhid 1
>  # ip route del 192.0.2.0/24 nexthop via 198.51.100.1 nexthop via 198.51.100.2

that's what I did as well.

> 
> Maybe add to tools/testing/selftests/net/fib_nexthops.sh ?

I have one in my tree, but in my tests nothing blew up or threw an error
message. It requires KASAN to be enabled otherwise the test does not
trigger anything.

> 
> Checked IPv6 and I don't think we can hit it there, but I will double
> check tomorrow morning.
> 
>>
>> Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
>> Reported-by: Gwangun Jung <exsociety@gmail.com>
>> Signed-off-by: David Ahern <dsahern@kernel.org>
>> ---
>>  net/ipv4/fib_semantics.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>

> 
> There is already such a check above for the non-multipath check, maybe
> we can just move it up to cover both cases? Something like:
> 
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 2dc97583d279..e9a7f70a54df 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -888,13 +888,13 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
>  		return 1;
>  	}
>  
> +	/* cannot match on nexthop object attributes */
> +	if (fi->nh)
> +		return 1;

that should work as well. I went with the simplest change that would
definitely not have a negative impact on backports.


> +
>  	if (cfg->fc_oif || cfg->fc_gw_family) {
>  		struct fib_nh *nh;
>  
> -		/* cannot match on nexthop object attributes */
> -		if (fi->nh)
> -			return 1;
> -
>  		nh = fib_info_nh(fi, 0);
>  		if (cfg->fc_encap) {
>  			if (fib_encap_match(net, cfg->fc_encap_type,

