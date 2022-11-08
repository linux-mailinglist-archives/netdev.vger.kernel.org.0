Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D03362138A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiKHNv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiKHNvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:51:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C32D13A
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667915423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I465AeOPfiJsRmTzJzyR2fZLNaUngeS0XWRpht65yzc=;
        b=WtfYDUCq9fXL3Wre+rNVcwb/ES1HczrfjlHiBHPyHGdHwHfWWF/UcAoc0uMoBP4N5qdN7/
        6fF88oyomfX2xCFdnnd+6dqBdT6N9pKAl37QqEqFrZ+dkaYH09R2lbziM5l3+u/tZXC460
        0/kD9GTmMYwnsIoeg1GSSfub5/sT3PM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-FeH7ObrpMIKoak9AtpIDpg-1; Tue, 08 Nov 2022 08:50:21 -0500
X-MC-Unique: FeH7ObrpMIKoak9AtpIDpg-1
Received: by mail-qt1-f200.google.com with SMTP id cj6-20020a05622a258600b003a519d02f59so10226464qtb.5
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I465AeOPfiJsRmTzJzyR2fZLNaUngeS0XWRpht65yzc=;
        b=MjaU59jGVsVR2wL7krdsQkHaq7vWMmf89MJJBrCQpq6U0EQRFPKYx8ihyiProQID46
         hSkq110AKZZHlbSxeT0EylkaTeQAfv+vnhZuy7tLUyfluoRMxLIHmXCDdIiQWFtFLZbE
         sjQMG5JbhV60OPr5ro1oXIGIKQDCEY6pMb2gVRF9bugit2YbAhEVITFtlhFvsYTCtcHO
         gNJBMRxI9zvYyA+ZuMdxzvr46jwTRQiEIjhNfSBod8gO/xtW2dDitlhbfsHbJYNoI1js
         PVF/3Og/qf9vAldcGuU+T9anA8HXXF0P5DmUB73ht68a/mOGTbAcmR7zHqFwXIqWnmJw
         SpQQ==
X-Gm-Message-State: ANoB5pk0zIxsHzjbA5mXpY6TvUApHI5/B67pUnMAG7mxJ0eyOaAzz79V
        hsjZbrndsxlRDvpqAsic/KJzn3nV1ejlHe/A7jxobIv4/YOqjKdYUaYfCNbIOZ2Avi41o0e00Un
        rc4qRU9IK5i2Wk8BW
X-Received: by 2002:a05:6214:1ccc:b0:4c5:5ab0:1939 with SMTP id g12-20020a0562141ccc00b004c55ab01939mr13976943qvd.106.1667915421391;
        Tue, 08 Nov 2022 05:50:21 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6+0W5hDM9BzyVHbp60nUYtFDWWzSX+px6iMYF8K3RK+Ub7agBCd1ls0zj3Cm74JAMeJv73Ig==
X-Received: by 2002:a05:6214:1ccc:b0:4c5:5ab0:1939 with SMTP id g12-20020a0562141ccc00b004c55ab01939mr13976925qvd.106.1667915421159;
        Tue, 08 Nov 2022 05:50:21 -0800 (PST)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id bk37-20020a05620a1a2500b006ee77f1ecc3sm9266297qkb.31.2022.11.08.05.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 05:50:20 -0800 (PST)
Message-ID: <9f57d2a6-c0ac-5273-86c5-a1bc03246de4@redhat.com>
Date:   Tue, 8 Nov 2022 08:50:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCHv2 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
References: <20221108070035.177036-1-liuhangbin@gmail.com>
Content-Language: en-US
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20221108070035.177036-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/22 02:00, Hangbin Liu wrote:
> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
> transport header to be set first. But there is no rule to ask driver set
> transport header before netif_receive_skb() and bond_handle_frame(). So
> we will not able to get correct icmp6hdr on some drivers.
> 
> Fix this by checking the skb length manually and getting icmp6 header based
> on the IPv6 header offset.
> 
> Reported-by: Liang Li <liali@redhat.com>
> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
> ---
>   drivers/net/bonding/bond_main.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index e84c49bf4d0c..4599cf340201 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3231,12 +3231,16 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
>   		       struct slave *slave)
>   {
>   	struct slave *curr_active_slave, *curr_arp_slave;
> -	struct icmp6hdr *hdr = icmp6_hdr(skb);
> +	const struct icmp6hdr *hdr, _hdr;
>   	struct in6_addr *saddr, *daddr;
>   
>   	if (skb->pkt_type == PACKET_OTHERHOST ||
>   	    skb->pkt_type == PACKET_LOOPBACK ||
> -	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> +	    ipv6_hdr(skb)->nexthdr != NEXTHDR_ICMP)
> +		goto out;
> +
> +	hdr = skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(_hdr), &_hdr);
> +	if (!hdr || hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
>   		goto out;
>   
>   	saddr = &ipv6_hdr(skb)->saddr;


Acked-by: Jonathan Toppins <jtoppins@redhat.com>

