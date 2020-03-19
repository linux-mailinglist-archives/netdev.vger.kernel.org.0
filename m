Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764DE18BBB7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 16:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgCSP5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 11:57:36 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33288 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727217AbgCSP5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 11:57:36 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D46D34C0051;
        Thu, 19 Mar 2020 15:57:34 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 19 Mar
 2020 15:57:28 +0000
Subject: Re: [PATCH net-next 6/6] netfilter: nf_flow_table: hardware offload
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <paulb@mellanox.com>, <ozsh@mellanox.com>, <majd@mellanox.com>,
        <saeedm@mellanox.com>
References: <20191111232956.24898-1-pablo@netfilter.org>
 <20191111232956.24898-7-pablo@netfilter.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <64004716-fdbe-9542-2484-8a1691d54e53@solarflare.com>
Date:   Thu, 19 Mar 2020 15:57:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191111232956.24898-7-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25300.003
X-TM-AS-Result: No-9.313900-8.000000-10
X-TMASE-MatchedRID: scwq2vQP8OEbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizz5+tteD5RzhUa8
        yKZOJ6C1JjovGzWxJ9SbmkwamF/Rlcf2eXl6VFIUO8xKBrjenTQxXH/dlhvLvyuGKh4AkqKV/cN
        c7UG2ksjxbDEqAUeozlwUyWghCE2RmlSCGmrTRTD9xyC38S1f/XkamQDZ6bhfVWQnHKxp38gRQP
        nsANQIhT1ExWdxi/VAVIKZ9Pa/e14YB2fOueQzjzl/1fD/GopdWQy9YC5qGvz6APa9i04WGCq2r
        l3dzGQ1oRBjtox9n9pUaznb1Oof98NGm2XwkcYX65h41kcF46p9MgV9gnmAIcC+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.313900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25300.003
X-MDID: 1584633455-EVp-fIOyl10N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2019 23:29, Pablo Neira Ayuso wrote:
> This patch adds the dataplane hardware offload to the flowtable
> infrastructure. Three new flags represent the hardware state of this
> flow:
>
> * FLOW_OFFLOAD_HW: This flow entry resides in the hardware.
> * FLOW_OFFLOAD_HW_DYING: This flow entry has been scheduled to be remove
>   from hardware. This might be triggered by either packet path (via TCP
>   RST/FIN packet) or via aging.
> * FLOW_OFFLOAD_HW_DEAD: This flow entry has been already removed from
>   the hardware, the software garbage collector can remove it from the
>   software flowtable.
>
> This patch supports for:
>
> * IPv4 only.
> * Aging via FLOW_CLS_STATS, no packet and byte counter synchronization
>   at this stage.
>
> This patch also adds the action callback that specifies how to convert
> the flow entry into the flow_rule object that is passed to the driver.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
<snip>
> +static int nf_flow_rule_match(struct nf_flow_match *match,
> +			      const struct flow_offload_tuple *tuple)
> +{
> +	struct nf_flow_key *mask = &match->mask;
> +	struct nf_flow_key *key = &match->key;
> +
> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
> +
> +	switch (tuple->l3proto) {
> +	case AF_INET:
> +		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
Is it intentional that mask->control.addr_type never gets set?

-ed
