Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AD01748DE
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 20:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgB2T3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 14:29:54 -0500
Received: from correo.us.es ([193.147.175.20]:42536 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgB2T3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 14:29:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D7B25C22F8
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 20:29:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAF82DA3C4
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 20:29:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B553ADA3A8; Sat, 29 Feb 2020 20:29:39 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EE35DA788;
        Sat, 29 Feb 2020 20:29:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 29 Feb 2020 20:29:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.24.68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 36E1842EE38E;
        Sat, 29 Feb 2020 20:29:37 +0100 (CET)
Date:   Sat, 29 Feb 2020 20:29:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, jeffrey.t.kirsher@intel.com,
        idosch@mellanox.com, aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, ecree@solarflare.com, mlxsw@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200229192947.oaclokcpn4fjbhzr@salvia>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228172505.14386-2-jiri@resnulli.us>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 06:24:54PM +0100, Jiri Pirko wrote:
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

Why do you want to place this built-in into the struct flow_action as
a boolean?

You can express the same thing through a new FLOW_ACTION_COUNTER.
I know tc has implicit counters in actions, in that case tc can just
generate the counter right after the action.

Please, explain me why it would be a problem from the driver side to
provide a separated counter action.
