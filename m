Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A649D5843CA
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiG1QHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiG1QHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:07:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2544C6E2D6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1071B822C4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 16:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA27C433D6;
        Thu, 28 Jul 2022 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659024420;
        bh=vfbaTi45sC+6arSBdV0gTQJZMNtHX4XjvepxEYCWHXA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=EV+BuS/+XZrxjyAtGJSOVfqdSEsiITjWmP3F66XTwWUj+6jkQJFLsKQvWnc2Cq0Xe
         DS8cs/ErRd7+DqmvrUZKp1khAVH8eLzxgHtSFmNAsKNwep1EMd8vg5mqNbqhcqGT2C
         qwxfpaFtYe3vry4LBHuAsUpsJL1eXY3iNDVEz85nJoiw65TzeHjR9aEK5O4AW6pFc0
         28WAnC31XTIqwP5IBP0x2AX60KSqWgTU/YOvw+7tpkwnKUhrv+aww60JVh128R/OhW
         D1Zn7jy5jF8/fA3YGUyWk1L+c0vTX+wMYNEw6ANPFjC184sgrfbvaYyQb9lDKF22Nj
         95XlYp2Rlm46w==
Message-ID: <ceaf6af0-de27-01b7-c84c-5699ae2a0b8d@kernel.org>
Date:   Thu, 28 Jul 2022 10:06:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] net: gro: skb_gro_header_try_fast helper function
Content-Language: en-US
To:     Richard Gobert <richardbgobert@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        xeb@mail.ru, edumazet@google.com, iwienand@redhat.com,
        arnd@arndb.de, netdev@vger.kernel.org
References: <20220728113844.GA53749@debian>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220728113844.GA53749@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/22 5:39 AM, Richard Gobert wrote:
> @@ -160,6 +160,17 @@ static inline void *skb_gro_header_slow(struct sk_buff *skb, unsigned int hlen,
>  	return skb->data + offset;
>  }
>  
> +static inline void *skb_gro_header_try_fast(struct sk_buff *skb,
> +					unsigned int hlen, unsigned int offset)
> +{
> +	void *ptr;
> +
> +	ptr = skb_gro_header_fast(skb, offset);
> +	if (skb_gro_header_hard(skb, hlen))
> +		ptr = skb_gro_header_slow(skb, hlen, offset);
> +	return ptr;
> +}
> +


skb_get_gro_header() or just skb_gro_header() since it does fast then
slow variants?
