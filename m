Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE5316AAAC
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgBXQET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:04:19 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58952 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726806AbgBXQES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:04:18 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 455F480082;
        Mon, 24 Feb 2020 16:04:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 24 Feb
 2020 16:04:10 +0000
Subject: Re: [PATCH net-next 6/6] net/sched: act_ct: Software offload of
 established flows
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Oz Shlomo" <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
 <1582458307-17067-7-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <00bede7c-1140-f2ec-05c5-f9db855ca90f@solarflare.com>
Date:   Mon, 24 Feb 2020 16:04:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1582458307-17067-7-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25250.003
X-TM-AS-Result: No-7.466300-8.000000-10
X-TMASE-MatchedRID: VPleTT1nwdTAIiGVQCd+FvZvT2zYoYOwC/ExpXrHizyzU0R+5DbDbMMy
        cr0b1vBAm8P3v96SVAT3kTwbsL5T2UkCYvX2c9GkuwdUMMznEA+rcyxAHgzswgdkFovAReUoaUX
        s6FguVy2rQYgRWAo7NATr53V4VI0b3Nbo+e3gGSTp9R8QuoVQfzVfUuzvrtymdPj9LUBj/ktFwU
        mNE9YYouLzNWBegCW2RYvisGWbbS+3sNbcHjySQd0H8LFZNFG7CKFCmhdu5cVe4tuGw1UcSBUOO
        Q6pXLylKb+AxN9hm+IkgZRduRW747PXoIp9J+1ZRcIGM+LZIY5gyNXjTItnvEksKHaRZzS+MQRk
        cyKwE69YcqTGA0A88Q/QLt7G/oc63pgQ4q/O6wuOSonfQdQNip6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.466300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25250.003
X-MDID: 1582560258-A1rqpEJCRByN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/02/2020 11:45, Paul Blakey wrote:
> Offload nf conntrack processing by looking up the 5-tuple in the
> zone's flow table.
>
> The nf conntrack module will process the packets until a connection is
> in established state. Once in established state, the ct state pointer
> (nf_conn) will be restored on the skb from a successful ft lookup.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/sched/act_ct.c | 163 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 160 insertions(+), 3 deletions(-)
>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index b2bc885..3592e24 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
<snip>
> @@ -645,6 +802,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  			goto out_push;
>  	}
>  
> +do_nat:
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if (!ct)
>  		goto out_push;
> @@ -662,9 +820,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  		 * even if the connection is already confirmed.
>  		 */
>  		nf_conntrack_confirm(skb);
> -	}
> -
> -	tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
> +	} else if (!skip_add)
> +		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
>  
Elseif body should be enclosed in braces, since if body was.
-ed
