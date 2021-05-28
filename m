Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704B0393A6E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 02:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbhE1ArF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 20:47:05 -0400
Received: from linux.microsoft.com ([13.77.154.182]:58910 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhE1ArE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 20:47:04 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by linux.microsoft.com (Postfix) with ESMTPSA id 232C220B8013;
        Thu, 27 May 2021 17:45:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 232C220B8013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622162730;
        bh=gJOAEM/qWgeTmQ+5OlWHexIiLlQlSznhjnMwrDLR26A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tGsEGQoVWWobYMCevWyihyRyeYtDAZu/0V28GqhPsbLxGO/cV2GevSslRSpHyMJ/w
         UG92R2PxJmtsFh5kpnlvJ/lt446e5YXrf+EO+rsp7mQJ2u1jjDnLPXnn9qtDFZZ+3C
         Gp9FPe7kdURhI/IZg8W8CjLuGzL0TWNf1qhcP3AI=
Received: by mail-pg1-f173.google.com with SMTP id e22so1251772pgv.10;
        Thu, 27 May 2021 17:45:30 -0700 (PDT)
X-Gm-Message-State: AOAM5326mQ8sMbCfB9N2tQtL7H3uTXdN3RmY1dHcpgOhgKZ7bwgDNQu/
        7C8YuZzIhJGzb8jYEQy3h6Z5UXsWjZEHXR4NYAI=
X-Google-Smtp-Source: ABdhPJySR+SvD3TYa0wBijrGzLqj+wD1cE2OL/bszWdPJ3fAW5tlnPRlsMvwC9B9adpY8jt1rCKgFWG3XC/3Lvt1eDw=
X-Received: by 2002:a63:6f8e:: with SMTP id k136mr6409565pgc.326.1622162729506;
 Thu, 27 May 2021 17:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210521161527.34607-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210521161527.34607-1-mcroce@linux.microsoft.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Fri, 28 May 2021 02:44:53 +0200
X-Gmail-Original-Message-ID: <CAFnufp1Xv5V_6Rb_wpA43sfcSr+giqygGmUjr92RRi=fncKtTw@mail.gmail.com>
Message-ID: <CAFnufp1Xv5V_6Rb_wpA43sfcSr+giqygGmUjr92RRi=fncKtTw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 0/5] page_pool: recycle buffers
To:     netdev@vger.kernel.org, linux-mm@kvack.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
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
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 6:15 PM Matteo Croce <mcroce@linux.microsoft.com> wrote:
> Note that this series depends on the change "mm: fix struct page layout
> on 32-bit systems"[2] which is not yet in master.
>

I see that it just entered net-next:

commit 9ddb3c14afba8bc5950ed297f02d4ae05ff35cd1
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Fri May 14 17:27:24 2021 -0700

   mm: fix struct page layout on 32-bit systems

Regards,
-- 
per aspera ad upstream
