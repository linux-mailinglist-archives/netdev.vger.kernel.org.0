Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D81E39C0A4
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFDTuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhFDTuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 15:50:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8D7C061766;
        Fri,  4 Jun 2021 12:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eiQrNqdISPy8DYhhvO2OscxdNKhEOxSE8gN4mRiagEk=; b=O2upqpo6o6nhEWDpsc9Hs9Z3c9
        faGUrFI+9BTj6l6tBDhH1UeU8hlXS/n/boLKdmkumKnrRFA/sduZ4gJBPM/CSHeENVstyMcZ6VVkX
        3SO5Z49XSHCW/fDktp58ABTAD6S8TrZ4gL99DkyjHkI2SbZ6erV75nVvwlKZxoNWLjxIk8R04MUW4
        kScJh+ZpTG97XID+HsY3rznGAdmWNSdAdebBr0wx6Gecr80F3JUrH2wqCk8kgVug0fKARVsicWTMi
        KPI+pzJHvglr9vrZcT65UproKpAB6kQ72iRNwymhjN6BFeJAYjXpsICthEk73CcsRewjHbMltPieE
        2iqI0vMw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lpFnV-00DWt8-Va; Fri, 04 Jun 2021 19:48:11 +0000
Date:   Fri, 4 Jun 2021 20:48:01 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v7 4/5] mvpp2: recycle buffers
Message-ID: <YLqDcVGPomZRLJYd@casper.infradead.org>
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-5-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604183349.30040-5-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 08:33:48PM +0200, Matteo Croce wrote:
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -3997,7 +3997,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  		}
>  
>  		if (pp)
> -			page_pool_release_page(pp, virt_to_page(data));
> +			skb_mark_for_recycle(skb, virt_to_page(data), pp);

Does this driver only use order-0 pages?  Should it be using
virt_to_head_page() here?  or should skb_mark_for_recycle() call
compound_head() internally?
