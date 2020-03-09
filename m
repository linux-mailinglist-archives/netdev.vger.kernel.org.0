Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD9C517E50A
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 17:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgCIQwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 12:52:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:41648 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727132AbgCIQwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 12:52:32 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4F82818006D;
        Mon,  9 Mar 2020 16:52:29 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 16:52:20 +0000
Subject: Re: [patch net-next v4 01/10] flow_offload: Introduce offload of HW
 stats type
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <saeedm@mellanox.com>,
        <leon@kernel.org>, <michael.chan@broadcom.com>,
        <vishal@chelsio.com>, <jeffrey.t.kirsher@intel.com>,
        <idosch@mellanox.com>, <aelior@marvell.com>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <pablo@netfilter.org>, <mlxsw@mellanox.com>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-2-jiri@resnulli.us>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
Date:   Mon, 9 Mar 2020 16:52:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200307114020.8664-2-jiri@resnulli.us>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-9.307200-8.000000-10
X-TMASE-MatchedRID: VPleTT1nwdTmLzc6AOD8DfHkpkyUphL9eouvej40T4iRoQLwUmtov7oY
        /8zM5lCggH71Hvwg6bRM7g1j0AuHEWJZXQNDzktSbBMSu4v05tOrcyxAHgzswryRVeaM8Kzf9di
        MilcQBqvfNm9SJCTV2xit2OqfFZiNYL8QSGy41Gr1MIl9eZdLb2lYsa84w2hT1y0aXF5eX+hdr3
        7dknN8wruwuIYnhcFSX7bicKxRIU23sNbcHjySQd0H8LFZNFG7hqz53n/yPnoNLhfDCqPJyISvF
        V+S5t+vxHJR8AzkOBJr6iCOdZDf/boOfFLgUu3n
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.307200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583772751-ryyUxHO2owGQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2020 11:40, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
>
> Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
> current implicit value coming down to flow_offload. Add a bool
> indicating that entries have mixed HW stats type.
>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v3->v4:
> - fixed member alignment
> v2->v3:
> - moved to bitfield
> - removed "mixed" bool
> v1->v2:
> - moved to actions
> - add mixed bool
> ---
>  include/net/flow_offload.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index cd3510ac66b0..93d17f37e980 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -154,6 +154,8 @@ enum flow_action_mangle_base {
>  	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
>  };
>  
> +#define FLOW_ACTION_HW_STATS_TYPE_ANY 0
I'm not quite sure why switching to a bit fieldapproach means these
 haveto become #defines rather than enums...

> +
>  typedef void (*action_destr)(void *priv);
>  
>  struct flow_action_cookie {
> @@ -168,6 +170,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>  
>  struct flow_action_entry {
>  	enum flow_action_id		id;
> +	u8				hw_stats_type;
... causing this to become a u8with nothing obviously preventing
 a HW_STATS_TYPE bigger than 255 getting defined.
An enum type seems safer.

-ed

>  	action_destr			destructor;
>  	void				*destructor_priv;
>  	union {

