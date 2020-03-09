Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7BB17EB26
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 22:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgCIV0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 17:26:01 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:51764 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgCIV0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 17:26:01 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A4A4AA40058;
        Mon,  9 Mar 2020 21:25:59 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 21:25:53 +0000
Subject: Re: [PATCH net-next ct-offload v2 05/13] net/sched: act_ct: Enable
 hardware offload of flow table entires
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "Oz Shlomo" <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
 <1583676662-15180-6-git-send-email-paulb@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <62d6cfde-5749-b2d6-ee04-d0a49b566d1a@solarflare.com>
Date:   Mon, 9 Mar 2020 21:25:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1583676662-15180-6-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-5.231000-8.000000-10
X-TMASE-MatchedRID: VPleTT1nwdTmLzc6AOD8DfHkpkyUphL9eouvej40T4gqAZlo5C3Li2/B
        wZI7pijP+LMvZ1fdJAgcYnFbzUCEUwXjSpVHn22DgmAd4Attpn/pVMb1xnESMhQTXyPPP3faQBz
        oPKhLasiPqQJ9fQR1znxCC5IJNss3qF4dEohoxMx1e7Xbb6Im2jQAl7cHmp8GI0YrtQLsSUxGIz
        SvkOhmQGlJBRQEXrYxX7bicKxRIU23sNbcHjySQd0H8LFZNFG7CKFCmhdu5cWNqhoF92IKWU/kN
        u4T8aEz7AvQYx+PufncKPedX3ozj+C8TF8M2Y23HgVd2XfOA+n1hX1AKaF8PCMPv9eybtILQ8Po
        myr6J5lYcqTGA0A88Q/QLt7G/oc63pgQ4q/O6wuOSonfQdQNip6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.231000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583789160-m-atnUvUeR9p
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/03/2020 14:10, Paul Blakey wrote:
> Pass the zone's flow table instance on the flow action to the drivers.
> Thus, allowing drivers to register FT add/del/stats callbacks.
>
> Finally, enable hardware offload on the flow table instance.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
> <snip>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 84d5abf..d52185d 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -292,6 +292,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>  		goto err_insert;
>  
>  	ct_ft->nf_ft.type = &flowtable_ct;
> +	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD;
>  	err = nf_flow_table_init(&ct_ft->nf_ft);
>  	if (err)
>  		goto err_init;
> @@ -299,6 +300,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>  	__module_get(THIS_MODULE);
>  take_ref:
>  	params->ct_ft = ct_ft;
> +	params->nf_ft = &ct_ft->nf_ft;
>  	ct_ft->ref++;
>  	spin_unlock_bh(&zones_lock);
This doesn't seem to apply to net-next (34a568a244be); the label after
 the __module_get() is 'out_unlock', not 'take_ref'.  Is there a missing
 prerequisite patch?  Or am I just failing to drive 'git am' correctly?

-ed
