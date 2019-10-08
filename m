Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECF5CFCF5
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 16:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfJHO6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 10:58:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35412 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfJHO6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 10:58:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=um/YDnaMyJyTyg2497iRiQ1U1v5lC65azQYBJjF93eM=; b=PRr0Opr8UV7AUfTX7z0fwHzCS
        6vw0As44Qw4HJ7kmKni2TCAMXlbcnZbyD8VvrVFnvewbIddZfkKcEsXG/B32LruTqfMSczgH4jOK0
        XmzM1YdhLOO2pozR/AS7w3iSwt//ld18MVdpfjvh9ZftXc2F1hSFBJ3/gjAUmLy8pMDeeMJLIZUks
        nnXNZ3MTjgGva9hFBWucr9NYviLhafzulEK25O3ddYkAHYwr6FgQiinBpopuc4oMITbym/VdoX2v7
        lI5u1J5rdvYgLPcoNMaYojtdhZtg/yJouNESb9mz+IC4u6Rk8bLfh9T2coEOnu08REGJqK8pShRDb
        4RNUxSQpA==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHqw6-0006CE-Fl; Tue, 08 Oct 2019 14:58:02 +0000
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <547e7e47-d2f3-c226-2384-7110eb019fec@infradead.org>
Date:   Tue, 8 Oct 2019 07:57:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/19 2:48 AM, Martin Varghese wrote:
> From: Martin <martin.varghese@nokia.com>
> 
> The Bareudp tunnel module provides a generic L3 encapsulation
> tunnelling module for tunnelling different protocols like MPLS,
> IP,NSH etc inside a UDP tunnel.
> 
> Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> ---
>  Documentation/networking/bareudp.txt |  23 +
>  drivers/net/Kconfig                  |  13 +
>  drivers/net/Makefile                 |   1 +
>  drivers/net/bareudp.c                | 930 +++++++++++++++++++++++++++++++++++
>  include/net/bareudp.h                |  19 +
>  include/uapi/linux/if_link.h         |  12 +
>  6 files changed, 998 insertions(+)
>  create mode 100644 Documentation/networking/bareudp.txt
>  create mode 100644 drivers/net/bareudp.c
>  create mode 100644 include/net/bareudp.h
> 
> diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
> new file mode 100644
> index 0000000..d2530e2
> --- /dev/null
> +++ b/Documentation/networking/bareudp.txt
> @@ -0,0 +1,23 @@
> +Bare UDP Tunnelling Module Documentation
> +========================================
> +
> +There are various L3 encapsulation standards using UDP being discussed to
> +leverage the UDP based load balancing capability of different networks.
> +MPLSoUDP (https://tools.ietf.org/html/rfc7510)is one among them.

add space after ')'.

> +
> +The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> +support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> +a UDP tunnel.
> +
> +Usage
> +------
> +
> +1. Device creation & deletion
> +
> +a. ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847
> +
> +This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
> +0x8847 (MPLS traffic).The destination port of the UDP header will be set to 6635

add space after '.'.
add ending '.'.

> +The device will listen on UDP port 6635 to receive traffic.
> +
> +b. ip link delete bareudp0
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 48e209e..a389fac 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -215,6 +215,19 @@ config GENEVE
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called geneve.
>  
> +config BAREUDP
> +       tristate "Bare UDP  Encapsulation"

	  drop one space between UDP and Encapsulation.

> +       depends on INET && NET_UDP_TUNNEL
> +       depends on IPV6 || !IPV6
> +       select NET_IP_TUNNEL
> +       select GRO_CELLS
> +       help
> +          This adds a bare udp tunnel module for tunnelling different

		s/udp/UDP/

> +          kind of traffic like MPLS, IP, etc. inside a UDP tunnel.
> +
> +          To compile this driver as a module, choose M here: the module
> +          will be called bareudp.
> +
>  config GTP
>  	tristate "GPRS Tunneling Protocol datapath (GTP-U)"
>  	depends on INET


-- 
~Randy
