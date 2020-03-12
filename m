Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8E9183AC5
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCLUnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgCLUnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:43:03 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC45206CD;
        Thu, 12 Mar 2020 20:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584045783;
        bh=rkqApRKdIrFMFmMtL8ufrp4ZxfSUDHaxLpWEn2KxGjQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gCMzMLjG7/3DaAULGswXrrSmD2SAr8uUoUlO6Q/pT3uiXFZps+99KXiRe02agId9Q
         Qr8zXiwpSO3nTW9M08J6N26bO5J7HZfn1kOMeF4lu9EO0HwMJjk4aCV01FkMbu43W/
         bg1zJkXcuavGFKPcTkI+Nv1SJijW1R4YAuMQyH3k=
Date:   Thu, 12 Mar 2020 13:43:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v3 2/6] net: sched: Allow extending set of
 supported RED flags
Message-ID: <20200312134300.219924b8@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200312180507.6763-3-petrm@mellanox.com>
References: <20200312180507.6763-1-petrm@mellanox.com>
        <20200312180507.6763-3-petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 20:05:03 +0200 Petr Machata wrote:
> @@ -183,9 +189,12 @@ static void red_destroy(struct Qdisc *sch)
>  }
>  
>  static const struct nla_policy red_policy[TCA_RED_MAX + 1] = {
> -	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt) },
> +	[TCA_RED_PARMS]	= { .len = sizeof(struct tc_red_qopt),
> +			    .strict_start_type = TCA_RED_FLAGS },

I think this needs to be set on attr 0, i.e. TCA_RED_UNSPEC,
otherwise feel free to add:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

>  	[TCA_RED_STAB]	= { .len = RED_STAB_SIZE },
>  	[TCA_RED_MAX_P] = { .type = NLA_U32 },
> +	[TCA_RED_FLAGS] = { .type = NLA_BITFIELD32,
> +			    .validation_data = &red_supported_flags },
>  };
>  
>  static int red_change(struct Qdisc *sch, struct nlattr *opt,

