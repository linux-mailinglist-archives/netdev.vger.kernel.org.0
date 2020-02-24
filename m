Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9418B16AA92
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgBXP63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:58:29 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39088 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727359AbgBXP63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:58:29 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E7F01B4007E;
        Mon, 24 Feb 2020 15:58:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 24 Feb
 2020 15:58:13 +0000
Subject: Re: [PATCH net-next 4/6] net/sched: act_ct: Create nf flow table per
 zone
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Oz Shlomo" <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
 <1582458307-17067-5-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <97c2e036-6334-9818-f8cd-4c2671273eed@solarflare.com>
Date:   Mon, 24 Feb 2020 15:58:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1582458307-17067-5-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25250.003
X-TM-AS-Result: No-7.659100-8.000000-10
X-TMASE-MatchedRID: QfHZjzml1E/mLzc6AOD8DfHkpkyUphL9CwT2DH7iMm5v/W4eavUSar0E
        v48zkQ1BuvJP2tI8V/sWsp6eJb7A26H2g9syPs888Kg68su2wyGrcyxAHgzswgaYevV4zG3ZQBz
        oPKhLashW+rzIcpyAZh2Hg3YJOrAmRe7UNYLzDks1TzxKO8pZtAKflB9+9kWVT7zqZowzdpIDE6
        k/i6Y0RS84Nf6AzMJsUVDDZpJlenBarFKFj/o9tPbta0OAYFzy2LlbtF/6zpAcNByoSo036Wm3Y
        eujho7/585VzGMOFzABi3kqJOK62QtuKBGekqUpm+MB6kaZ2g4xi1AR6sx0/fXAL7AUDhbJDlcC
        N9qTwCPb3YtTMtmeQ5S8E/SWXRgGbxRMw8GphfCvaBbe8WTmfAfCg4wbLbsmKr/XZw2p5eqPgCD
        bAY3P7tVH8LonOSWy/S2A05ietQe2WKPzVcog4boOfFLgUu3n
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.659100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25250.003
X-MDID: 1582559908-yPrZhb_mcz64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/02/2020 11:45, Paul Blakey wrote:
> Use the NF flow tables infrastructure for CT offload.
>
> Create a nf flow table per zone.
>
> Next patches will add FT entries to this table, and do
> the software offload.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   1 +
>  include/net/tc_act/tc_ct.h                      |   2 +
>  net/sched/Kconfig                               |   2 +-
>  net/sched/act_ct.c                              | 159 +++++++++++++++++++++++-
>  4 files changed, 162 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 70b5fe2..eb16136 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -45,6 +45,7 @@
>  #include <net/tc_act/tc_tunnel_key.h>
>  #include <net/tc_act/tc_pedit.h>
>  #include <net/tc_act/tc_csum.h>
> +#include <net/tc_act/tc_ct.h>
>  #include <net/arp.h>
>  #include <net/ipv6_stubs.h>
>  #include "en.h"
> diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
> index a8b1564..cf3492e 100644
> --- a/include/net/tc_act/tc_ct.h
> +++ b/include/net/tc_act/tc_ct.h
> @@ -25,6 +25,8 @@ struct tcf_ct_params {
>  	u16 ct_action;
>  
>  	struct rcu_head rcu;
> +
> +	struct tcf_ct_flow_table *ct_ft;
>  };
>  
>  struct tcf_ct {
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index edde0e5..bfbefb7 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -972,7 +972,7 @@ config NET_ACT_TUNNEL_KEY
>  
>  config NET_ACT_CT
>  	tristate "connection tracking tc action"
> -	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
> +	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
Is it not possible to keep sensible/old behaviour in the case
 of NF_FLOW_TABLE=n?  (And what about NF_FLOW_TABLE=m, which is
 what its Kconfig help seems to advise...)

>  	help
>  	  Say Y here to allow sending the packets to conntrack module.
>  
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index f685c0d..4267d7d 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -15,6 +15,7 @@
>  #include <linux/pkt_cls.h>
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>
> +#include <linux/rhashtable.h>
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
> @@ -24,6 +25,7 @@
>  #include <uapi/linux/tc_act/tc_ct.h>
>  #include <net/tc_act/tc_ct.h>
>  
> +#include <net/netfilter/nf_flow_table.h>
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_zones.h>
> @@ -31,6 +33,133 @@
>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>  #include <uapi/linux/netfilter/nf_nat.h>
>  
> +static struct workqueue_struct *act_ct_wq;
> +
> +struct tcf_ct_flow_table {
> +	struct rhash_head node; /* In zones tables */
> +
> +	struct rcu_work rwork;
> +	struct nf_flowtable nf_ft;
> +	u16 zone;
> +	u32 ref;
Any reason this isn't using a refcount_t?
-ed
