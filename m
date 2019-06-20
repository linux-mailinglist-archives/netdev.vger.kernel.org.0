Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05884CC3A
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 12:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbfFTKsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 06:48:09 -0400
Received: from mail.us.es ([193.147.175.20]:51270 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbfFTKsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 06:48:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6F397C4249
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 12:48:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6018BDA712
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 12:48:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 51EA4DA70E; Thu, 20 Jun 2019 12:48:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B240DA702;
        Thu, 20 Jun 2019 12:48:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 12:48:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1A69B4265A2F;
        Thu, 20 Jun 2019 12:48:05 +0200 (CEST)
Date:   Thu, 20 Jun 2019 12:48:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: bridge: Fix non-untagged fragment
 packet
Message-ID: <20190620104804.cbbodvw2llnt6qcl@salvia>
References: <1560954907-20071-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560954907-20071-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 10:35:07PM +0800, wenxu@ucloud.cn wrote:
[...]
> So if the first fragment packet don't contain vlan tag, all of the
> remain should not contain vlan tag..

If I understand correctly, the problem is this:

* First fragment comes with no vlan tag.
* Second fragment comes with vlan tag.

If you have a vlan setup, you have to use ct zone to map the vlan id
to the corresponding ct zone.

nf_ct_br_defrag4() calls:

        err = ip_defrag(state->net, skb,
                                IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id);

if ct zones are used, first fragment will go to defrag queue
IP_DEFRAG_CONNTRACK_BRIDGE_IN + 0, while second fragment will go to
IP_DEFRAG_CONNTRACK_BRIDGE_IN + zone_id.

So they will go to different defrag queues.

> Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index b675cd7..4f5444d 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -331,6 +331,8 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
>  	}
>  	if (data->vlan_present)
>  		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
> +	else if (skb_vlan_tag_present(skb))
> +		__vlan_hwaccel_clear_tag(skb);
>  
>  	skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
>  	skb_reset_mac_header(skb);
> -- 
> 1.8.3.1
> 
