Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B0D3B4175
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 12:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhFYKWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 06:22:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51280 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbhFYKWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 06:22:48 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 86567607EB;
        Fri, 25 Jun 2021 12:20:24 +0200 (CEST)
Date:   Fri, 25 Jun 2021 12:20:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Colin King <colin.king@canonical.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netfilter: nf_tables: Fix dereference of null
 pointer flow
Message-ID: <20210625102021.GA32352@salvia>
References: <20210624195718.170796-1-colin.king@canonical.com>
 <20210625095901.GH2040@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210625095901.GH2040@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jun 25, 2021 at 12:59:01PM +0300, Dan Carpenter wrote:
> Btw, why is there no clean up if nft_table_validate() fails?

See below.

> net/netfilter/nf_tables_api.c
>   3432                                  list_add_tail_rcu(&rule->list, &old_rule->list);
>   3433                          else
>   3434                                  list_add_rcu(&rule->list, &chain->rules);
>   3435                  }
>   3436          }
>   3437          kvfree(expr_info);
>   3438          chain->use++;
>   3439  
>   3440          if (flow)
>   3441                  nft_trans_flow_rule(trans) = flow;
>   3442  
>   3443          if (nft_net->validate_state == NFT_VALIDATE_DO)
>   3444                  return nft_table_validate(net, table);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> The cleanup for this would be quite involved unfortunately...  Not
> necessarily something to attempt without being able to test the code.

At this stage, the transaction has been already registered in the
list, and the nf_tables_abort() path takes care of undoing what has
been updated in the preparation phase.

Having said this, Colin patch is correct, it's fixing up the error
path.
