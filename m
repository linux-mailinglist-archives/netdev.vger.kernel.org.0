Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2470F3D8A44
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbhG1JGr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Jul 2021 05:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhG1JGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:06:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9F7C061757;
        Wed, 28 Jul 2021 02:06:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1m8fWN-00060Q-S5; Wed, 28 Jul 2021 11:06:35 +0200
Date:   Wed, 28 Jul 2021 11:06:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: Re: [PATCH] net: netfilter: Fix port selection of FTP for
 NF_NAT_RANGE_PROTO_SPECIFIED
Message-ID: <20210728090635.GB15121@breakpoint.cc>
References: <20210728032134.21983-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210728032134.21983-1-Cole.Dishington@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cole Dishington <Cole.Dishington@alliedtelesis.co.nz> wrote:
> FTP port selection ignores specified port ranges (with iptables
> masquerade --to-ports) when creating an expectation, based on
> FTP commands PORT or PASV, for the data connection.
> 
> Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
> Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
> Co-developed-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
> Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
> Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     Currently with iptables -t nat -j MASQUERADE -p tcp --to-ports 10000-10005,
>     creating a passive ftp connection from a client will result in the control
>     connection being within the specified port range but the data connection being
>     outside of the range. This patch fixes this behaviour to have both connections
>     be in the specified range.
> 
>  include/net/netfilter/nf_conntrack.h |  3 +++
>  net/netfilter/nf_nat_core.c          | 10 ++++++----
>  net/netfilter/nf_nat_ftp.c           | 26 ++++++++++++--------------
>  net/netfilter/nf_nat_helper.c        | 12 ++++++++----
>  4 files changed, 29 insertions(+), 22 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index cc663c68ddc4..b98d5d04c7ab 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -24,6 +24,8 @@
>  
>  #include <net/netfilter/nf_conntrack_tuple.h>
>  
> +#include <uapi/linux/netfilter/nf_nat.h>
> +
>  struct nf_ct_udp {
>  	unsigned long	stream_ts;
>  };
> @@ -99,6 +101,7 @@ struct nf_conn {
>  
>  #if IS_ENABLED(CONFIG_NF_NAT)
>  	struct hlist_node	nat_bysource;
> +	struct nf_nat_range2 range;
>  #endif

Thats almost a 20% size increase of this structure.

Could you try to rework it based on this?
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -27,12 +27,18 @@ union nf_conntrack_nat_help {
 #endif
 };
 
+struct nf_conn_nat_range_info {
+	union nf_conntrack_man_proto	min_proto;
+	union nf_conntrack_man_proto	max_proto;
+};
+
 /* The structure embedded in the conntrack structure. */
 struct nf_conn_nat {
 	union nf_conntrack_nat_help help;
 #if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE)
 	int masq_index;
 #endif
+	struct nf_conn_nat_range_info range_info;
 };
 
 /* Set up the info structure to map into this range. */

... and then store the range min/max proto iff nf_nat_setup_info had
NF_NAT_RANGE_PROTO_SPECIFIED flag set.

I don't think there is a need to keep the information in nf_conn.

