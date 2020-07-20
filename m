Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC3B226E6A
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgGTShk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGTShk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:37:40 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8FEC061794;
        Mon, 20 Jul 2020 11:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=DHipU8PXyOBHTZ8RvxCfXBZ+HdncvH5dlTXWYPNFa+8=; b=SqwVTwWuLFBpDS46jLn6+he0Gy
        DKLleQlm3Ny7WFFKDDIxaaVz4203CHBxp5TEy513Wl/lHItN8BOZYBbWrmnumTYZ1iQthlBRDMgRO
        jzmw6rqb5Bxkxe+aK8CUXkClTs+pupk5XZYO/aoWxB8ctwuOAPgRHPU+SyNqYwvq1mfY3Y0v+weqU
        UTHxMP9tOql7Ek70g4pEc1KZLuW5MFqKtmkPPfM24VPiNlQnrCy5oqo93rLG2j9owDSxtfuKlACqY
        KCM8YZgewMxg5dVTCObZ298jT31tfJqZlg4JRV5m07bOdKLMNCCF3l6vgo0VejxRJdGl1Ls3nSJ+A
        W6JWlWDA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxafN-0001pS-1m; Mon, 20 Jul 2020 18:37:33 +0000
Subject: Re: [net-next v4 PATCH 1/7] hsr: enhance netlink socket interface to
 support PRP
To:     Murali Karicheri <m-karicheri2@ti.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nsekhar@ti.com, grygorii.strashko@ti.com, vinicius.gomes@intel.com
References: <20200720165803.17793-1-m-karicheri2@ti.com>
 <20200720165803.17793-2-m-karicheri2@ti.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f1675af9-f057-0b7b-c245-e15ead602bbc@infradead.org>
Date:   Mon, 20 Jul 2020 11:37:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720165803.17793-2-m-karicheri2@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/20 9:57 AM, Murali Karicheri wrote:
> diff --git a/net/hsr/Kconfig b/net/hsr/Kconfig
> index 8095b034e76e..e2e396870230 100644
> --- a/net/hsr/Kconfig
> +++ b/net/hsr/Kconfig
> @@ -4,24 +4,35 @@
>  #
>  
>  config HSR
> -	tristate "High-availability Seamless Redundancy (HSR)"
> -	help
> +	tristate "High-availability Seamless Redundancy (HSR & PRP)"
> +	---help---

Just use:
	help

The use of "---help---" has been discontinued.

> +	  This enables IEC 62439 defined High-availability Seamless
> +	  Redundancy (HSR) and Parallel Redundancy Protocol (PRP).
> +
>  	  If you say Y here, then your Linux box will be able to act as a
> -	  DANH ("Doubly attached node implementing HSR"). For this to work,
> -	  your Linux box needs (at least) two physical Ethernet interfaces,
> -	  and it must be connected as a node in a ring network together with
> -	  other HSR capable nodes.
> +	  DANH ("Doubly attached node implementing HSR") or DANP ("Doubly
> +	  attached node implementing PRP"). For this to work, your Linux box
> +	  needs (at least) two physical Ethernet interfaces.
> +
> +	  For DANH, it must be connected as a node in a ring network together
> +	  with other HSR capable nodes. All Ethernet frames sent over the hsr

	                                                                  HSR

> +	  device will be sent in both directions on the ring (over both slave
> +	  ports), giving a redundant, instant fail-over network. Each HSR node
> +	  in the ring acts like a bridge for HSR frames, but filters frames
> +	  that have been forwarded earlier.
>  
> -	  All Ethernet frames sent over the hsr device will be sent in both
> -	  directions on the ring (over both slave ports), giving a redundant,
> -	  instant fail-over network. Each HSR node in the ring acts like a
> -	  bridge for HSR frames, but filters frames that have been forwarded
> -	  earlier.
> +	  For DANP, it must be connected as a node connecting to two
> +	  separate networks over the two slave interfaces. Like HSR, Ethernet
> +	  frames sent over the prp device will be sent to both networks giving

	                       PRP

> +	  a redundant, instant fail-over network. Unlike HSR, PRP networks
> +	  can have Singly Attached Nodes (SAN) such as PC, printer, bridges
> +	  etc and will be able to communicate with DANP nodes.
>  
>  	  This code is a "best effort" to comply with the HSR standard as
>  	  described in IEC 62439-3:2010 (HSRv0) and IEC 62439-3:2012 (HSRv1),
> -	  but no compliancy tests have been made. Use iproute2 to select
> -	  the version you desire.
> +	  and PRP standard described in IEC 62439-4:2012 (PRP), but no
> +	  compliancy tests have been made. Use iproute2 to select the protocol
> +	  you would like to use.
>  
>  	  You need to perform any and all necessary tests yourself before
>  	  relying on this code in a safety critical system!

thanks.
-- 
~Randy

