Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF42928AB2F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 02:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgJLAO6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Oct 2020 20:14:58 -0400
Received: from smtp.h3c.com ([60.191.123.50]:62718 "EHLO h3cspam02-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgJLAO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 20:14:57 -0400
Received: from DAG2EX02-BASE.srv.huawei-3com.com ([10.8.0.65])
        by h3cspam02-ex.h3c.com with ESMTPS id 09C0EcWI014370
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 12 Oct 2020 08:14:38 +0800 (GMT-8)
        (envelope-from tian.xianting@h3c.com)
Received: from DAG2EX03-BASE.srv.huawei-3com.com (10.8.0.66) by
 DAG2EX02-BASE.srv.huawei-3com.com (10.8.0.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 08:14:39 +0800
Received: from DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074])
 by DAG2EX03-BASE.srv.huawei-3com.com ([fe80::5d18:e01c:bbbd:c074%7]) with
 mapi id 15.01.1713.004; Mon, 12 Oct 2020 08:14:39 +0800
From:   Tianxianting <tian.xianting@h3c.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: Avoid allocing memory on memoryless numa node
Thread-Topic: [PATCH] net: Avoid allocing memory on memoryless numa node
Thread-Index: AQHWn4X33nOETvWn/EOdjwgvT00GhKmSQVKAgADYw6A=
Date:   Mon, 12 Oct 2020 00:14:39 +0000
Message-ID: <b77011b20e85434e8e5135ea1c0f51ac@h3c.com>
References: <20201011041140.8945-1-tian.xianting@h3c.com>
 <20201011121803.2c003c7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011121803.2c003c7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.141.128]
x-sender-location: DAG2
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: h3cspam02-ex.h3c.com 09C0EcWI014370
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
Thanks for your suggestion,
Let me try it :-)

-----Original Message-----
From: Jakub Kicinski [mailto:kuba@kernel.org] 
Sent: Monday, October 12, 2020 3:18 AM
To: tianxianting (RD) <tian.xianting@h3c.com>
Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Avoid allocing memory on memoryless numa node

On Sun, 11 Oct 2020 12:11:40 +0800 Xianting Tian wrote:
> In architecture like powerpc, we can have cpus without any local 
> memory attached to it. In such cases the node does not have real memory.
> 
> Use local_memory_node(), which is guaranteed to have memory.
> local_memory_node is a noop in other architectures that does not 
> support memoryless nodes.
> 
> Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
> ---
>  net/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c index 
> 266073e30..dcb4533ef 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2590,7 +2590,7 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
>  		new_map = kzalloc(XPS_MAP_SIZE(alloc_len), GFP_KERNEL);
>  	else
>  		new_map = kzalloc_node(XPS_MAP_SIZE(alloc_len), GFP_KERNEL,
> -				       cpu_to_node(attr_index));
> +				       local_memory_node(cpu_to_node(attr_index)));
>  	if (!new_map)
>  		return NULL;
>  

Are we going to patch all kmalloc_node() callers now to apply local_memory_node()?  Can't the allocator take care of this?

