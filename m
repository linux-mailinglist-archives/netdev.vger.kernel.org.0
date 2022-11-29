Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4294A63BD06
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiK2JfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiK2Je7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:34:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823031EEE1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669714445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=caP/rC0nnvQymu6mA/gslxl2NmWqltTNr7bvQqqM/dg=;
        b=EPIvXs1Y0ax137NV8v7Qwk376wQl+e5TJVKFjjdITT0f+xRJLlWCAceBGc8pW2bLFBBQGO
        9pEpfz/pg1Um/lY1zrPHLy6IQE0yRfV6gHB6GrOzrD1IJKGGIDhApEeHJirIL6BHRDFkqM
        46jcYDeU2g6HTK+lUn+Cd/Cy4+nbHCU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-475-mchWJ0ppPpOZpkbdqv_F-g-1; Tue, 29 Nov 2022 04:34:04 -0500
X-MC-Unique: mchWJ0ppPpOZpkbdqv_F-g-1
Received: by mail-qv1-f72.google.com with SMTP id nn2-20020a056214358200b004bb7bc3dfdcso18774707qvb.23
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:34:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=caP/rC0nnvQymu6mA/gslxl2NmWqltTNr7bvQqqM/dg=;
        b=CEJSj80pFQgp0OEFPOwpoJ9yX0Z8o24kPcOuj4F08pOg1t1Ko+pz5loLMUW4I6Q9Se
         Zldxw/AocnCsZBlxjDsEx55VBP3/wrGADVx30dGJrQyqELRH5Vn8/1fuKR6DO1c9GhRO
         PBRdTgSqyFXpfRqCr57O4lEZ9sF7ru/nm32A1E84qjNpRTr8R1kFJnu352PrIlB/CK06
         T/7/eNyYw1I9dBNMYmjvwWDFDd5e3KVt87+22pG6iv+K7E3EgWDy6tEcA3QyrJ5Breiz
         JbEGMpkRLM9c8CLbMrywnHFMM7NGXg2vjnVPygei+SNCnKWr/fB7hmlMVtDTxkQK70xN
         eLQQ==
X-Gm-Message-State: ANoB5pkLD0POHo8VEz1/hnGczpcaUk2nKe9KPnnYTKShUOw1B6lRzOaQ
        Jc6ypSxmBuqP20wrsTddBmyFQBuVRuxqe1QItc2D6hKGRb0+Ea4Kzx5DCAfiwijjzqhk5mxh7PA
        iBsJmfGquOapTpt69
X-Received: by 2002:ac8:4603:0:b0:3a5:6131:6438 with SMTP id p3-20020ac84603000000b003a561316438mr33520774qtn.164.1669714443535;
        Tue, 29 Nov 2022 01:34:03 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6m27Q0PzOclZymNF2y2LFVCKpiqKpzsGGtqKJh/5Fu4cvl+5y9qR0W9NW/G+sNNzTdOotjUA==
X-Received: by 2002:ac8:4603:0:b0:3a5:6131:6438 with SMTP id p3-20020ac84603000000b003a561316438mr33520760qtn.164.1669714443186;
        Tue, 29 Nov 2022 01:34:03 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id q11-20020a37f70b000000b006ed61f18651sm9941800qkj.16.2022.11.29.01.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:34:02 -0800 (PST)
Message-ID: <9480856d183c88a205fd79d9dbc156a7fd3ea0d3.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] IPv6/GRO: generic helper to remove
 temporary HBH/jumbo header in driver
From:   Paolo Abeni <pabeni@redhat.com>
To:     Coco Li <lixiaoyan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 29 Nov 2022 10:33:59 +0100
In-Reply-To: <20221123191627.3442831-1-lixiaoyan@google.com>
References: <20221123191627.3442831-1-lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Only a couple of minor things below, reporting them as this is still a
RFC, right ? ;)

On Wed, 2022-11-23 at 11:16 -0800, Coco Li wrote:
> IPv6/TCP and GRO stacks can build big TCP packets with an added
> temporary Hop By Hop header.
> 
> Is GSO is not involved, then the temporary header needs to be removed in
> the driver. This patch provides a generic helper for drivers that need
> to modify their headers in place.
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> ---
>  include/net/ipv6.h     | 36 ++++++++++++++++++++++++++++++++++++
>  net/ipv6/ip6_offload.c | 26 ++++----------------------
>  2 files changed, 40 insertions(+), 22 deletions(-)
> 
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index d383c895592a..c5a1daaf5056 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -500,6 +500,42 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
>  	return jhdr->nexthdr;
>  }
>  
> +/* Return 0 if HBH header is successfully removed
> + * Or if HBH removal is unnecessary (packet is not big TCP)
> + * Return error to indicate dropping the packet
> + */
> +static inline int ipv6_hopopt_jumbo_remove(struct sk_buff *skb)
> +{
> +	const int hophdr_len = sizeof(struct hop_jumbo_hdr);
> +	int nexthdr = ipv6_has_hopopt_jumbo(skb);
> +	struct ipv6hdr *h6;
> +	int err = 0;
> +
> +	if (!nexthdr)
> +		return err;

You can help a bit the compiler avoiding err initialization:

	int err;

	if (!nexthdr)
		return 0;

> +
> +	err = skb_cow_head(skb, 0);
> +	if (err)
> +		return err;
> +
> +	/* Remove the HBH header.
> +	 * Layout: [Ethernet header][IPv6 header][HBH][L4 Header]
> +	 */
> +	memmove(skb_mac_header(skb) + hophdr_len, skb_mac_header(skb),
> +		skb_network_header(skb) - skb_mac_header(skb) +

The have could be:

		skb_mac_header_len(skb)

which is IMHO a little more clear.

Thanks!

Paolo

