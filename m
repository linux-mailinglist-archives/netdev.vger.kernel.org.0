Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A213B4C4E7
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 03:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbfFTBTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 21:19:52 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:41434 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfFTBTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 21:19:51 -0400
Received: from [192.168.1.3] (unknown [58.38.4.250])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id E7349C1875;
        Thu, 20 Jun 2019 09:19:46 +0800 (CST)
Subject: Re: [PATCH 1/2 nf-next] netfilter: nft_meta: add NFT_META_BRI_PVID
 support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1560928585-18352-1-git-send-email-wenxu@ucloud.cn>
 <20190619170254.an2aklx6abqh646l@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <26bb807a-4021-b06e-53cb-d30f3f188555@ucloud.cn>
Date:   Thu, 20 Jun 2019 09:19:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190619170254.an2aklx6abqh646l@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVTk1CS0tLSE1ISE9CQkpZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N006Lww4PTgxHBcdFgFOOA8B
        TjEwCkJVSlVKTk1LQkJITkNMT0xKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWU5DVUhD
        VU9VSU5LWVdZCAFZQU9ITE03Bg++
X-HM-Tid: 0a6b7277e0092085kuqye7349c1875
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I will post the nftable patches latter. Thanks!

在 2019/6/20 1:02, Pablo Neira Ayuso 写道:
> On Wed, Jun 19, 2019 at 03:16:24PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> nft add table bridge firewall
>> nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
>> nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }
>> As above set the bridge port with pvid, the received packet don't contain
>> the vlan tag which means the packet should belong to vlan 200 through pvid.
>> With this pacth user can get the pvid of bridge ports: "meta brpvid"
> Would you also post the patches for nftables for review?
>
> Would you post an example on how you use "meta brpvid" in your
> ruleset? I don't see this is used in the example above,
>
> More comments below.
>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>>  net/netfilter/nft_meta.c                 | 17 +++++++++++++++++
>>  2 files changed, 19 insertions(+)
>>
>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>> index 31a6b8f..4a16124 100644
>> --- a/include/uapi/linux/netfilter/nf_tables.h
>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>> @@ -793,6 +793,7 @@ enum nft_exthdr_attributes {
>>   * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
>>   * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
>>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>> + * @NFT_META_BRI_PVID: packet input bridge port pvid
>>   */
>>  enum nft_meta_keys {
>>  	NFT_META_LEN,
>> @@ -823,6 +824,7 @@ enum nft_meta_keys {
>>  	NFT_META_SECPATH,
>>  	NFT_META_IIFKIND,
>>  	NFT_META_OIFKIND,
>> +	NFT_META_BRI_PVID,
>>  };
>>  
>>  /**
>> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
>> index 987d2d6..1fdb565 100644
>> --- a/net/netfilter/nft_meta.c
>> +++ b/net/netfilter/nft_meta.c
>> @@ -243,6 +243,18 @@ void nft_meta_get_eval(const struct nft_expr *expr,
>>  			goto err;
>>  		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
>>  		return;
>> +	case NFT_META_BRI_PVID:
>> +		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
>> +			goto err;
>> +		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
>> +			u16 pvid = br_get_pvid(nbp_vlan_group_rcu(p));
>> +
>> +			if (pvid) {
>> +				nft_reg_store16(dest, pvid);
> I think you should store pvid into dest if pvid is zero too, right?
> You cannot assume destination register is set to zero.
>
>> +				return;
>> +			}
>> +		}
>> +		goto err;
>>  #endif
>>  	case NFT_META_IIFKIND:
>>  		if (in == NULL || in->rtnl_link_ops == NULL)
>> @@ -370,6 +382,11 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
>>  			return -EOPNOTSUPP;
>>  		len = IFNAMSIZ;
>>  		break;
>> +	case NFT_META_BRI_PVID:
>> +		if (ctx->family != NFPROTO_BRIDGE)
>> +			return -EOPNOTSUPP;
>> +		len = sizeof(u16);
>> +		break;
>>  #endif
>>  	default:
>>  		return -EOPNOTSUPP;
>> -- 
>> 1.8.3.1
>>
