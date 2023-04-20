Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629BD6E99F5
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDTQya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDTQy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:54:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE4C183
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682009628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FnYpivfBK4PPgB8pNrUj5N5IEnwLdxg7j3WfB2CTdzE=;
        b=MA0L8yOhWfPEDLOUCSUKCcG3jq5u3bhxAXsj7zsjrTy/hWwRMt9u3/DcoO3JYONlUTMu77
        mKB+UXgNvXOGgB0A5/n0rksuuFD0Dl8nB+laYAAQhNycvldPmBqOSMq3koxqrpGS+ft1ox
        I+X+ojFseTDa36eGrZ1LSd8orO9Yp9s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-8y--BH5jMv2d-JkgZv8qJw-1; Thu, 20 Apr 2023 12:53:47 -0400
X-MC-Unique: 8y--BH5jMv2d-JkgZv8qJw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f08ed462c0so15392795e9.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:53:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009626; x=1684601626;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnYpivfBK4PPgB8pNrUj5N5IEnwLdxg7j3WfB2CTdzE=;
        b=IvThqZNyI/nw6GYMgaWxKz2seDMrJ9MEtGEnfDl4v0VRJtrVFtlSShDLsxVn21detj
         TjYy2p+dNoixie8zWswotawIcQOMJqe58wFyL3cItg4e4Y6d7tWlNaWAaXKJNKs6/31s
         5m2+JfT3zGUHfaaPsqmN3pQJuZhfTduuZer6psEwZK1tz6krPK/53zoZINkfkHFfIFMX
         H8if553ulz+NPoUfgs0/5pW2L0AGLH5AX7Nv19W7ckPHwjQzLiswgp9+30rMLw90CCLE
         Phzrn+4hFDysH6CZwKcSdo6fCQQvnmaPPJCvDSZWkkvK9/eQ+XtW0rSni1hBJtGpzok6
         f6NA==
X-Gm-Message-State: AAQBX9caDoIXf7tKMEgSJRei7CHi82eJ8FlsmpkAcIt34vKCfV0Ndc9o
        qD2CxWnQwB0Kd4sr0C6ZuJQjGVMW+crDonD8Kss6LkT+Hms8F/PbYjj8Gd/1XLphX/cFocY1kbV
        m1nCFrWPCcEDEdO0h
X-Received: by 2002:adf:f88b:0:b0:2fb:1f34:dc72 with SMTP id u11-20020adff88b000000b002fb1f34dc72mr1732116wrp.8.1682009625852;
        Thu, 20 Apr 2023 09:53:45 -0700 (PDT)
X-Google-Smtp-Source: AKy350bJphwnVECwH8hCQ7yP5ttcRYgJDyLLjCBuTmdM0jAEXXq/VSogBCTSFKlRSNFjj07UI0RS1Q==
X-Received: by 2002:adf:f88b:0:b0:2fb:1f34:dc72 with SMTP id u11-20020adff88b000000b002fb1f34dc72mr1732104wrp.8.1682009625547;
        Thu, 20 Apr 2023 09:53:45 -0700 (PDT)
Received: from debian ([2001:4649:fcb8:0:bac2:a5a6:5482:8a9e])
        by smtp.gmail.com with ESMTPSA id c18-20020adfed92000000b002f27dd92643sm2358803wro.99.2023.04.20.09.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:53:45 -0700 (PDT)
Date:   Thu, 20 Apr 2023 18:53:42 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Aleksey Shumnik <ashumnik9@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, waltje@uwalt.nl.mugnet.org,
        gw4pts@gw4pts.ampr.org, xeb@mail.ru, kuznet@ms2.inr.ac.ru,
        rzsfl@rz.uni-sb.de
Subject: Re: [BUG] In af_packet.c::dev_parse_header() skb.network_header does
 not point to the network header
Message-ID: <ZEFuFqMjO19De/e/@debian>
References: <CAJGXZLgcH6bjmj7YR-hAWpEQW1CPjEcOdMN01hqsVk18E4ScZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJGXZLgcH6bjmj7YR-hAWpEQW1CPjEcOdMN01hqsVk18E4ScZQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:47:34PM +0300, Aleksey Shumnik wrote:
> Dear maintainers,
> 
> I wrote the ip6gre_header_parser() function in ip6_gre.c, the
> implementation is similar to ipgre_header_parser() in ip_gre.c. (By
> the way, it is strange that this function is not implemented in
> ip6_gre.c)
> The implementation of the function is presented below.
> It should parse the ip6 header and take the source address and its
> length from there. To get a pointer to the ip header, it is logical to
> use skb_network_header(), but it does not work correctly and returns a
> pointer to payload (skb.data).

At this point, the tunnel device has already removed the outer headers.
So skb_network_header() points to the _inner_ network header.

> Also in ip_gre.c::ipgre_header_parser() skb_mac_header() returns a
> pointer to the ip header and everything works correctly (although it
> seems that this is also an error, because the pointer to the mac
> header should have been returned, and logically the
> skb_network_header() function should be applied),

Well, skb_mac_header() and skb_network_header() should point to the
inner mac and network headers respectively. However, because ip_gre
has no inner mac header, skb_mac_header() was repurposed to save the
position of the outer network header (so that ipgre_header_parse() can
find it).

> but in ip6_gre.c all
> skb_mac_header(), skb_network_header(), skb_tranport_header() returns
> a pointer to payload (skb.data).

The packet has already been decapsulated by the tunnel device: the
outer headers are gone. Therefore, the packet now starts right after
the gre header. So skb_mac_header() points there. And since ip6_gre
transports packets with no mac header, the mac header length is zero,
which means skb_network_header() equals skb_mac_header() and points to
the inner network header. Finally, as the inner network header hasn't
been parsed yet, we don't know where it ends, so skb_tranport_header()
isn't usable yet.

> This function is called when receiving a packet and parsing it in
> af_packet.c::packet_rcv() in dev_parse_header().
> The problem is that there is no way to accurately determine the
> beginning of the ip header.
> 
> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index 90565b8..0d0c37b 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -1404,8 +1404,16 @@ static int ip6gre_header(struct sk_buff *skb,
> struct net_device *dev,
>   return -t->hlen;
>  }
> 
> +static int ip6gre_header_parse(const struct sk_buff *skb, unsigned char *haddr)
> +{
> + const struct ipv6hdr *ipv6h = (const struct ipv6hdr *) skb_mac_header(skb);
> + memcpy(haddr, &ipv6h->saddr, 16);
> + return 16;
> +}
> +
>  static const struct header_ops ip6gre_header_ops = {
>   .create = ip6gre_header,
> + .parse = ip6gre_header_parse,
>  };
> 
>  static const struct net_device_ops ip6gre_netdev_ops = {
> 
> Would you answer whether this behavior is an error and why the
> behavior in ip_gre.c and ip6_gre.c differs?

For me, ip_gre should make the mac header point to the inner mac
header, which incidentally is also the inner network header.

The difference in behaviour between ip_gre and ip6_gre certainly comes
from the fact that both modules were implemented at different times, by
different people.

> Regards,
> Aleksey
> 

