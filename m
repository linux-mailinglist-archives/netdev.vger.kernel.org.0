Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39008583B4
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfF0NiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:38:14 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:33097 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0NiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:38:14 -0400
Received: from [192.168.1.6] (unknown [116.234.5.199])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id E9665E00D7D;
        Thu, 27 Jun 2019 21:38:04 +0800 (CST)
Subject: Re: [PATCH 2/2 nf-next] netfilter:nft_meta: add NFT_META_VLAN support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1561601357-20486-1-git-send-email-wenxu@ucloud.cn>
 <1561601357-20486-2-git-send-email-wenxu@ucloud.cn>
 <20190627123550.vx7r4rmzduzabig6@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <c9ce6a77-a5db-b3a1-ab48-eb6bc97337e1@ucloud.cn>
Date:   Thu, 27 Jun 2019 21:37:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190627123550.vx7r4rmzduzabig6@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVT0JDS0tLSk9PQk5DTllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mio6CTo6Qzg2IgtPPR8qDEwz
        CgJPFE5VSlVKTk1KTU9JTUNOSUlNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VTlVKQkJZV1kIAVlBTkJMQjcG
X-HM-Tid: 0a6b992852bb20bdkuqye9665e00d7d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/6/27 20:35, Pablo Neira Ayuso 写道:
> On Thu, Jun 27, 2019 at 10:09:17AM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This patch provide a meta vlan to set the vlan tag of the packet.
>>
>> for q-in-q vlan id 20:
>> meta vlan set 0x88a8:20
> Actually, I think this is not very useful for stacked vlan since this
> just sets/mangles the existing meta vlan data.
>
> We'll need infrastructure that uses skb_vlan_push() and _pop().
>
> Patch looks good anyway, such infrastructure to push/pop can be added
> later on.
>
> Thanks.

yes, It's just ste/mangle the meta vlan data. I just wonder if we set for stacked vlan.

vlan meta 0x88a8:20. The packet should contain a 0x8100 vlan tag, we just push the

inner vlan and the the vlan meta with the outer 0x88a8:20. Or the packet don't contain

only vlan tag, we add a inner 0x8100:20 tag and outer 0x88a8:20 tag?

So wen should check for this

>
>> set the default 0x8100 vlan type with vlan id 20
>> meta vlan set 20
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  include/uapi/linux/netfilter/nf_tables.h |  4 ++++
>>  net/netfilter/nft_meta.c                 | 27 ++++++++++++++++++++++++++-
>>  2 files changed, 30 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>> index 0b18646..cf037f2 100644
>> --- a/include/uapi/linux/netfilter/nf_tables.h
>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>> @@ -797,6 +797,7 @@ enum nft_exthdr_attributes {
>>   * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
>>   * @NFT_META_BRI_PVID: packet input bridge port pvid
>>   * @NFT_META_BRI_VLAN_PROTO: packet input bridge vlan proto
>> + * @NFT_META_VLAN: packet vlan metadata
>>   */
>>  enum nft_meta_keys {
>>  	NFT_META_LEN,
>> @@ -829,6 +830,7 @@ enum nft_meta_keys {
>>  	NFT_META_OIFKIND,
>>  	NFT_META_BRI_PVID,
>>  	NFT_META_BRI_VLAN_PROTO,
>> +	NFT_META_VLAN,
>>  };
>>  
>>  /**
>> @@ -895,12 +897,14 @@ enum nft_hash_attributes {
>>   * @NFTA_META_DREG: destination register (NLA_U32)
>>   * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
>>   * @NFTA_META_SREG: source register (NLA_U32)
>> + * @NFTA_META_SREG2: source register (NLA_U32)
>>   */
>>  enum nft_meta_attributes {
>>  	NFTA_META_UNSPEC,
>>  	NFTA_META_DREG,
>>  	NFTA_META_KEY,
>>  	NFTA_META_SREG,
>> +	NFTA_META_SREG2,
>>  	__NFTA_META_MAX
>>  };
>>  #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
>> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
>> index e3adf6a..29a6679 100644
>> --- a/net/netfilter/nft_meta.c
>> +++ b/net/netfilter/nft_meta.c
>> @@ -28,7 +28,10 @@ struct nft_meta {
>>  	enum nft_meta_keys	key:8;
>>  	union {
>>  		enum nft_registers	dreg:8;
>> -		enum nft_registers	sreg:8;
>> +		struct {
>> +			enum nft_registers	sreg:8;
>> +			enum nft_registers	sreg2:8;
>> +		};
>>  	};
>>  };
>>  
>> @@ -312,6 +315,17 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
>>  		skb->secmark = value;
>>  		break;
>>  #endif
>> +	case NFT_META_VLAN: {
>> +		u32 *sreg2 = &regs->data[meta->sreg2];
>> +		__be16 vlan_proto;
>> +		u16 vlan_tci;
>> +
>> +		vlan_tci = nft_reg_load16(sreg);
>> +		vlan_proto = nft_reg_load16(sreg2);
>> +
>> +		__vlan_hwaccel_put_tag(skb, vlan_proto, vlan_tci);
>> +		break;
>> +	}
>>  	default:
>>  		WARN_ON(1);
>>  	}
>> @@ -321,6 +335,7 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
>>  	[NFTA_META_DREG]	= { .type = NLA_U32 },
>>  	[NFTA_META_KEY]		= { .type = NLA_U32 },
>>  	[NFTA_META_SREG]	= { .type = NLA_U32 },
>> +	[NFTA_META_SREG2]	= { .type = NLA_U32 },
>>  };
>>  
>>  static int nft_meta_get_init(const struct nft_ctx *ctx,
>> @@ -483,6 +498,13 @@ static int nft_meta_set_init(const struct nft_ctx *ctx,
>>  	case NFT_META_PKTTYPE:
>>  		len = sizeof(u8);
>>  		break;
>> +	case NFT_META_VLAN:
>> +		len = sizeof(u16);
>> +		priv->sreg2 = nft_parse_register(tb[NFTA_META_SREG2]);
>> +		err = nft_validate_register_load(priv->sreg2, len);
>> +		if (err < 0)
>> +			return err;
>> +		break;
>>  	default:
>>  		return -EOPNOTSUPP;
>>  	}
>> @@ -521,6 +543,9 @@ static int nft_meta_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
>>  		goto nla_put_failure;
>>  	if (nft_dump_register(skb, NFTA_META_SREG, priv->sreg))
>>  		goto nla_put_failure;
>> +	if (priv->key == NFT_META_VLAN &&
>> +	    nft_dump_register(skb, NFTA_META_SREG2, priv->sreg2))
>> +		goto nla_put_failure;
>>  
>>  	return 0;
>>  
>> -- 
>> 1.8.3.1
>>
