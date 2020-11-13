Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEAB2B20BC
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgKMQp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:45:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgKMQp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:45:59 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64B78208D5;
        Fri, 13 Nov 2020 16:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605285958;
        bh=oERuKVqEwahLtpjWsv0m7+tmOx5YNdBC3MAN2DY7uEc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OQ8Nrb0tY4MnA36Mw9CMYO2OLupEInHEOEelq+k47rQYla+563JzjYlH3h9tDEwr9
         HsE43wgRtodCEG6legtbOBTq0uL3fFQ5PuZJ59NpgY8h7xOs/YBX3oqxgklAtBiehK
         +XLZjYhYziXmsZRtLifLXD6Qtnj47a89mt6JTxnA=
Date:   Fri, 13 Nov 2020 08:45:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
Subject: Re: [PATCH net-next v4 09/15] net/smc: Introduce SMCR get linkgroup
 command
Message-ID: <20201113084557.4905813d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3be40d64-3952-3de9-559b-2ee55449b54c@linux.ibm.com>
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
        <20201109151814.15040-10-kgraul@linux.ibm.com>
        <20201111143405.7f5fb92f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3be40d64-3952-3de9-559b-2ee55449b54c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 16:08:39 +0100 Karsten Graul wrote:
> On 11/11/2020 23:34, Jakub Kicinski wrote:
> > On Mon,  9 Nov 2020 16:18:08 +0100 Karsten Graul wrote:  
> >> @@ -295,6 +377,14 @@ static int smc_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
> >>  
> >>  static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
> >>  {
> >> +	struct smc_diag_req_v2 *req = nlmsg_data(cb->nlh);
> >> +
> >> +	if (req->cmd == SMC_DIAG_GET_LGR_INFO) {
> >> +		if ((req->cmd_ext & (1 << (SMC_DIAG_LGR_INFO_SMCR - 1))))
> >> +			smc_diag_fill_lgr_list(smc_diag_ops->get_lgr_list(),
> >> +					       skb, cb, req);
> >> +	}
> >> +
> >>  	return skb->len;
> >>  }  
> > 
> > IDK if this is appropriate for socket diag handler.
> > 
> > Is there precedent for funneling commands through socket diag instead
> > of just creating a genetlink family?
> 
> Thank you for your valuable comments. We are looking into a better way
> to retrieve the various information from the kernel into user space, 
> and we will come up with a v5 for that.

Thanks, but do double check that no other socket type is doing this, 
I'm far from a socket layer expert.
