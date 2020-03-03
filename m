Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66AB71782EE
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgCCTNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:13:38 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:42660 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729586AbgCCTNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 14:13:37 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C414BB4005F;
        Tue,  3 Mar 2020 19:13:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 3 Mar 2020
 19:13:27 +0000
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <saeedm@mellanox.com>,
        <leon@kernel.org>, <michael.chan@broadcom.com>,
        <vishal@chelsio.com>, <jeffrey.t.kirsher@intel.com>,
        <idosch@mellanox.com>, <aelior@marvell.com>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <pablo@netfilter.org>, <mlxsw@mellanox.com>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <ef1dd85e-dea3-6568-62c9-b363c8cac72b@solarflare.com>
Date:   Tue, 3 Mar 2020 19:13:23 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200228172505.14386-2-jiri@resnulli.us>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25266.003
X-TM-AS-Result: No-10.395800-8.000000-10
X-TMASE-MatchedRID: +f/wAVSGjujmLzc6AOD8DfHkpkyUphL9eouvej40T4iRoQLwUmtovz6P
        hj6DfZCErdoLblq9S5rIJOxIgBZkp1m1mTB2rVQG4jRkIImnX0M1TzP60UkdHZh4xM9oAcsthe+
        15n9pLpEMGFtZ+fVSEJMfUJb9OR2qFC1+JwI1dIfaEs3AIB1Q+Gz/G1X22faHs1NEfuQ2w2yqgH
        L9oEAOzOcsiTcGEhzQhMr5euyyJsdUdrkDHQOEiGfd6M+N3X1xcVr+FAe3UDVHik1ZbG9HgOLSd
        VP2tZn5PNUcTj3KnwbO2GKHTjFXIQ0qmJSh4JL/SMFvyr5L84KcdOLvYd0mZpqz+nVmAjSUo8WM
        kQWv6iWhMIDkR/KfwI2j49Ftap9EOwBXM346/+zR9RgYl4HrA9ND/kz4jiwoi8aRvW50mlEN+f4
        SYCnDreFxC+O+fohh
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.395800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25266.003
X-MDID: 1583262816-sZAb6-uHFjXd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/02/2020 17:24, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
>
> Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
> current implicit value coming down to flow_offload. Add a bool
> indicating that entries have mixed HW stats type.
>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v1->v2:
> - moved to actions
> - add mixed bool
> ---
>  include/net/flow_offload.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 4e864c34a1b0..eee1cbc5db3c 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -154,6 +154,10 @@ enum flow_action_mangle_base {
>  	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
>  };
>  
> +enum flow_action_hw_stats_type {
> +	FLOW_ACTION_HW_STATS_TYPE_ANY,
> +};
> +
>  typedef void (*action_destr)(void *priv);
>  
>  struct flow_action_cookie {
> @@ -168,6 +172,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>  
>  struct flow_action_entry {
>  	enum flow_action_id		id;
> +	enum flow_action_hw_stats_type	hw_stats_type;
>  	action_destr			destructor;
>  	void				*destructor_priv;
>  	union {
> @@ -228,6 +233,7 @@ struct flow_action_entry {
>  };
>  
>  struct flow_action {
> +	bool				mixed_hw_stats_types;
Some sort of comment in the commit message the effect that this will
 be set in patch #12 would be nice (and would have saved me some
 reviewing time looking for it ;)
Strictly speaking this violates SPOT; I know a helper to calculate
 this 'at runtime' in the driver would have to loop over actions,
 but it's control-plane so performance doesn't matter :grin:
I'd suggest something like adding an internal-use-only MIXED value to
 the enum, and then having a helper
 enum flow_action_hw_state_type flow_action_single_stats_type(struct flow_action *action);
 which could return FLOW_ACTION_HW_STATS_TYPE_MIXED or else whichever
 type all the actions have (except that the 'different' check might
 be further complicated to ignore DISABLED, since most
 flow_action_entries will be for TC actions with no .update_stats()
 which thus don't want stats and can use DISABLED to express that).
That then avoids having to rely on the first entry having the stats
 type (so flow_action_first_entry_get() goes away).

-ed
>  	unsigned int			num_entries;
>  	struct flow_action_entry 	entries[0];
>  };
