Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33522F0DF3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbhAKIYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:24:09 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:57990 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbhAKIYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 03:24:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6AB172026E;
        Mon, 11 Jan 2021 09:23:25 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q-7srmRMf-yq; Mon, 11 Jan 2021 09:23:24 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id ECC4520068;
        Mon, 11 Jan 2021 09:23:24 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 09:23:24 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 11 Jan
 2021 09:23:24 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 55B95318028B; Mon, 11 Jan 2021 09:23:23 +0100 (CET)
Date:   Mon, 11 Jan 2021 09:23:23 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        "Willem de Bruijn" <willemb@google.com>
Subject: Re: [PATCH net v2 3/3] esp: avoid unneeded kmap_atomic call
Message-ID: <20210111082323.GB3576117@gauss3.secunet.de>
References: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
 <20210109221834.3459768-4-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210109221834.3459768-4-willemdebruijn.kernel@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 05:18:34PM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> esp(6)_output_head uses skb_page_frag_refill to allocate a buffer for
> the esp trailer.
> 
> It accesses the page with kmap_atomic to handle highmem. But
> skb_page_frag_refill can return compound pages, of which
> kmap_atomic only maps the first underlying page.
> 
> skb_page_frag_refill does not return highmem, because flag
> __GFP_HIGHMEM is not set. ESP uses it in the same manner as TCP.
> That also does not call kmap_atomic, but directly uses page_address,
> in skb_copy_to_page_nocache. Do the same for ESP.
> 
> This issue has become easier to trigger with recent kmap local
> debugging feature CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP.
> 
> Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
> Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>

As this patchset goes through the net tree:

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Thanks!
