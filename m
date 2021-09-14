Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8CD40A912
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhINIXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:23:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229458AbhINIXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:23:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631607750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gNVTmJWvXN7yT7YJXggpc+xkZaGpVjdwRVHC2evi6qE=;
        b=grf6lt2vClp0v88p2bvql6ZgSdG771aIHC6Nk3V03LzSRJ8TlTCQuWq7i+a5xYtfHIifq3
        FVazIPaqrsPuJH7fJEAJ1eRyYMZy7gX1CQnJpMWPGL5UlZO8FuSqJ3hNOhQk6oYDJWjK0l
        iXCF2u+YVnIm4P7Mvui+F5IVW6+/iPg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-pRaiED3TM76riVzUuc4ULw-1; Tue, 14 Sep 2021 04:22:27 -0400
X-MC-Unique: pRaiED3TM76riVzUuc4ULw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48E52835DE0;
        Tue, 14 Sep 2021 08:22:26 +0000 (UTC)
Received: from [10.39.208.12] (unknown [10.39.208.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFD0B10016FE;
        Tue, 14 Sep 2021 08:22:20 +0000 (UTC)
Subject: Re: [PATCH iproute2] iptuntap: fix multi-queue flag display
To:     David Marchand <david.marchand@redhat.com>,
        stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, sriram.narasimhan@hp.com,
        jasowang@redhat.com
References: <20210901154826.31109-1-david.marchand@redhat.com>
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
Message-ID: <5bbe8709-9dc1-7655-2ddd-4db895591b52@redhat.com>
Date:   Tue, 14 Sep 2021 10:22:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210901154826.31109-1-david.marchand@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/21 5:48 PM, David Marchand wrote:
> When creating a tap with multi_queue flag, this flag is not displayed
> when dumping:
> 
> $ ip tuntap add tap23 mode tap multi_queue
> $ ip tuntap
> tap23: tap persist0x100
> 
> While at it, add a space between known flags and hexdump of unknown
> ones.
> 
> Fixes: c41e038f48a3 ("iptuntap: allow creation of multi-queue tun/tap device")
> Signed-off-by: David Marchand <david.marchand@redhat.com>
> ---
>  ip/iptuntap.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/ip/iptuntap.c b/ip/iptuntap.c
> index 9cdb4a80..96ca1ae7 100644
> --- a/ip/iptuntap.c
> +++ b/ip/iptuntap.c
> @@ -243,6 +243,9 @@ static void print_flags(long flags)
>  	if (flags & IFF_ONE_QUEUE)
>  		print_string(PRINT_ANY, NULL, " %s", "one_queue");
>  
> +	if (flags & IFF_MULTI_QUEUE)
> +		print_string(PRINT_ANY, NULL, " %s", "multi_queue");
> +
>  	if (flags & IFF_VNET_HDR)
>  		print_string(PRINT_ANY, NULL, " %s", "vnet_hdr");
>  
> @@ -253,9 +256,10 @@ static void print_flags(long flags)
>  		print_string(PRINT_ANY, NULL, " %s", "filter");
>  
>  	flags &= ~(IFF_TUN | IFF_TAP | IFF_NO_PI | IFF_ONE_QUEUE |
> -		   IFF_VNET_HDR | IFF_PERSIST | IFF_NOFILTER);
> +		   IFF_MULTI_QUEUE | IFF_VNET_HDR | IFF_PERSIST |
> +		   IFF_NOFILTER);
>  	if (flags)
> -		print_0xhex(PRINT_ANY, NULL, "%#llx", flags);
> +		print_0xhex(PRINT_ANY, NULL, " %#llx", flags);
>  
>  	close_json_array(PRINT_JSON, NULL);
>  }
> 

Reviewed-by: Maxime Coquelin <maxime.coquelin@redhat.com>

Thanks,
Maxime

