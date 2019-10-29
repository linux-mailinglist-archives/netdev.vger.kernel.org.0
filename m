Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 103EEE8DB8
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390815AbfJ2RKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:10:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54832 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390790AbfJ2RKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:10:16 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A10C6580075;
        Tue, 29 Oct 2019 17:10:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 29 Oct
 2019 17:10:09 +0000
Subject: Re: [PATCH nf-next] netfilter: nf_tables_offload: allow ethernet
 interface type only
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <jiri@resnulli.us>, <netdev@vger.kernel.org>
References: <20191029104057.21894-1-pablo@netfilter.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <0a5a341a-5576-8cc5-dcf1-f9780f57fd66@solarflare.com>
Date:   Tue, 29 Oct 2019 17:10:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191029104057.21894-1-pablo@netfilter.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25008.003
X-TM-AS-Result: No-9.950900-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfsbF9xF7zzuNfZvT2zYoYOwC/ExpXrHizxJK2eJhY02w1ym
        Rv3NQjsEWOGEF3GcKHq3527awMNqBOAPeckQjI1VDdN6n3Qne5Bezmeoa8MJ89MgOgDPfBRBh80
        vsP8cwQ77KNSlSdJEoDlEAfxuxr73z7SeYv9tPb0sYOarN8c4H8AYvJUUzMgaI0YrtQLsSUwKHk
        UYQmViAXxs7qFZ9FbOj0IvV7jlqDiUkDPUhpX2viwgwmow2VqdfS0Ip2eEHny+qryzYw2E8LLn+
        0Vm71Lcq7rFUcuGp/F5zdAzex5xZoq+3QlLD/dpuBhsF3hVEgwxxmVE3KOJic1O3nShL3Ap6zLW
        QOgkIiWUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.950900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25008.003
X-MDID: 1572369014-JF98_rzzwt1v
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/10/2019 10:40, Pablo Neira Ayuso wrote:
> Hardware offload support at this stage assumes an ethernet device in
> place. The flow dissector provides the intermediate representation to
> express this selector, so extend it to allow to store the interface
> type. Flower does not uses this, so skb_flow_dissect_meta() is not
> extended to allow to match on this new field.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Jiri: flower ignores this when checking for the ingress device, probably
>        that should restricted there too?
>
>  include/net/flow_dissector.h | 2 ++
>  net/netfilter/nft_cmp.c      | 7 +++++++
>  net/netfilter/nft_meta.c     | 4 ++++
>  3 files changed, 13 insertions(+)
>
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index 5cd12276ae21..7d804db85442 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -204,9 +204,11 @@ struct flow_dissector_key_ip {
>  /**
>   * struct flow_dissector_key_meta:
>   * @ingress_ifindex: ingress ifindex
> + * @iiftype: interface type
>   */
>  struct flow_dissector_key_meta {
>  	int ingress_ifindex;
> +	u16 ingress_iftype;
>  };
Comment does not match code wrt name of this new member.
