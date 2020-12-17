Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523DC2DD911
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgLQTGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:06:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729187AbgLQTGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:06:12 -0500
Date:   Thu, 17 Dec 2020 11:05:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608231932;
        bh=Rp3ih+9nNJOV/UJ4Ehozvu9d1Af6SW1T2ch7jqoRwfw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=S30dX8Oz/w6qq2tk8ZGgOmyU5K7N5aqn7u8B3qeWyUAc/EOADKvTTaFtRcYCWxau6
         W4X1Mq9drSFf5KHMpQLyKzyrtGjk5+VN4jZfWD3wvGTBMA+i4gwXZnAiBX5zLD96UR
         XVPGi2KhlbkkFWRcnwZRk3p38jFSVX9yNUf0r73SboSh8T8eGUiiAh96Lkq80kjERx
         yi1Pcwza1Tb2ka8PZEfe42gcJTlhXfSHV53ZQkeSKZ9fH/HAnGAOAEUOTV07Ad/Mwd
         IJJHAPMmk9gnTm7tZ4KT4QueHaUpfkJxKEqN6y60GlB9lcWaWK4rdTzs2CRY7/VVTb
         TTYNuf72pfx7w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: sch_taprio: reset child qdiscs before
 freeing them
Message-ID: <20201217110531.6fd60fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
References: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 19:33:29 +0100 Davide Caratti wrote:
> +	if (q->qdiscs) {
> +		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
> +			qdisc_reset(q->qdiscs[i]);

Are you sure that we can't graft a NULL in the middle of the array?
Shouldn't this be:

	for (i = 0; i < dev->num_tx_queues; i++)
		if (q->qdiscs[i])
			qdisc_reset(q->qdiscs[i]);

?

If this is a problem it already exists in destroy so I'll apply anyway.
