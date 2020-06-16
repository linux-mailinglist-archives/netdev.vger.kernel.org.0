Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED15D1FBFC3
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731477AbgFPUNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:13:54 -0400
Received: from correo.us.es ([193.147.175.20]:36412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729167AbgFPUNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 16:13:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3B0BCF2367
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 22:13:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DF22DA722
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 22:13:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1494DDA78C; Tue, 16 Jun 2020 22:13:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB729DA798;
        Tue, 16 Jun 2020 22:13:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jun 2020 22:13:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B714F426CCB9;
        Tue, 16 Jun 2020 22:13:48 +0200 (CEST)
Date:   Tue, 16 Jun 2020 22:13:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vladbu@mellanox.com
Subject: Re: [PATCH net v3 2/4] flow_offload: fix incorrect cb_priv check for
 flow_block_cb
Message-ID: <20200616201348.GB26932@salvia>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592277580-5524-3-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:19:38AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the function __flow_block_indr_cleanup, The match stataments
> this->cb_priv == cb_priv is always false, the flow_block_cb->cb_priv
> is totally different data with the flow_indr_dev->cb_priv.
> 
> Store the representor cb_priv to the flow_block_cb->indr.cb_priv in
> the driver.
> 
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
>  drivers/net/ethernet/netronome/nfp/flower/offload.c | 1 +
>  include/net/flow_offload.h                          | 1 +
>  net/core/flow_offload.c                             | 2 +-
>  5 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index ef7f6bc..042c285 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -1918,6 +1918,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
>  
>  		flow_block_cb_add(block_cb, f);
>  		list_add_tail(&block_cb->driver_list, &bnxt_block_cb_list);
> +		block_cb->indr.cb_priv = bp;

cb_indent ?

Why are you splitting the fix in multiple patches? This makes it
harder to review.

I think patch 1/4, 2/4 and 4/4 belong to the same logical change?
Collapse them.
