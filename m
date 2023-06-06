Return-Path: <netdev+bounces-8266-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 780957235E8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 05:53:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DB932814C3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 03:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497AE7FE;
	Tue,  6 Jun 2023 03:53:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEB6395
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:52:59 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B8312D
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:52:57 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QZxJm669RzqTg3;
	Tue,  6 Jun 2023 11:48:08 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 6 Jun
 2023 11:52:55 +0800
Subject: Re: [PATCH net-next 6/6] sfc: generate encap headers for TC offload
To: <edward.cree@amd.com>, <linux-net-drivers@amd.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <672e66e6a4cf0f54917eddbca7c27a6f0d2823bf.1685992503.git.ecree.xilinx@gmail.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
From: Hao Lan <lanhao@huawei.com>
Message-ID: <dd491618-6a36-ee7a-0581-c533fa245ce9@huawei.com>
Date: Tue, 6 Jun 2023 11:52:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <672e66e6a4cf0f54917eddbca7c27a6f0d2823bf.1685992503.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/6 3:17, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Support constructing VxLAN and GENEVE headers, on either IPv4 or IPv6,
>  using the neighbouring information obtained in encap->neigh to
>  populate the Ethernet header.
> Note that the ef100 hardware does not insert UDP checksums when
>  performing encap, so for IPv6 the remote endpoint will need to be
>  configured with udp6zerocsumrx or equivalent.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/tc_encap_actions.c | 194 +++++++++++++++++++-
>  1 file changed, 185 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.c b/drivers/net/ethernet/sfc/tc_encap_actions.c
> index 601141190f42..9a51d91d16bd 100644
> --- a/drivers/net/ethernet/sfc/tc_encap_actions.c
> +++ b/drivers/net/ethernet/sfc/tc_encap_actions.c
> @@ -239,12 +239,183 @@ static void efx_release_neigh(struct efx_nic *efx,
>  	efx_free_neigh(neigh);
>  }
>  
> -static void efx_gen_encap_header(struct efx_tc_encap_action *encap)
> +static void efx_gen_tun_header_eth(struct efx_tc_encap_action *encap, u16 proto)
>  {
> -	/* stub for now */
> -	encap->n_valid = false;
> -	memset(encap->encap_hdr, 0, sizeof(encap->encap_hdr));
> -	encap->encap_hdr_len = ETH_HLEN;
> +	struct efx_neigh_binder *neigh = encap->neigh;
> +	struct ethhdr *eth;
> +
> +	encap->encap_hdr_len = sizeof(*eth);
> +	eth = (struct ethhdr *)encap->encap_hdr;
> +
> +	if (encap->neigh->n_valid)
> +		ether_addr_copy(eth->h_dest, neigh->ha);
> +	else
> +		eth_zero_addr(eth->h_dest);
> +	ether_addr_copy(eth->h_source, neigh->egdev->dev_addr);
> +	eth->h_proto = htons(proto);
> +}
> +
> +static void efx_gen_tun_header_ipv4(struct efx_tc_encap_action *encap, u8 ipproto, u8 len)
> +{
> +	struct efx_neigh_binder *neigh = encap->neigh;
> +	struct ip_tunnel_key *key = &encap->key;
> +	struct iphdr *ip;
> +
> +	ip = (struct iphdr *)(encap->encap_hdr + encap->encap_hdr_len);
> +	encap->encap_hdr_len += sizeof(*ip);
> +
> +	ip->daddr = key->u.ipv4.dst;
> +	ip->saddr = key->u.ipv4.src;
> +	ip->ttl = neigh->ttl;
> +	ip->protocol = ipproto;
> +	ip->version = 0x4;
> +	ip->ihl = 0x5;
> +	ip->tot_len = cpu_to_be16(ip->ihl * 4 + len);
> +	ip_send_check(ip);
> +}
> +
> +#ifdef CONFIG_IPV6
> +static void efx_gen_tun_header_ipv6(struct efx_tc_encap_action *encap, u8 ipproto, u8 len)
> +{
> +	struct efx_neigh_binder *neigh = encap->neigh;
> +	struct ip_tunnel_key *key = &encap->key;
> +	struct ipv6hdr *ip;
> +
> +	ip = (struct ipv6hdr *)(encap->encap_hdr + encap->encap_hdr_len);
> +	encap->encap_hdr_len += sizeof(*ip);
> +
> +	ip6_flow_hdr(ip, key->tos, key->label);
> +	ip->daddr = key->u.ipv6.dst;
> +	ip->saddr = key->u.ipv6.src;
> +	ip->hop_limit = neigh->ttl;
> +	ip->nexthdr = ipproto;
> +	ip->version = 0x6;
> +	ip->payload_len = cpu_to_be16(len);
> +}
> +#endif
> +
> +static void efx_gen_tun_header_udp(struct efx_tc_encap_action *encap, u8 len)
> +{
> +	struct ip_tunnel_key *key = &encap->key;
> +	struct udphdr *udp;
> +
> +	udp = (struct udphdr *)(encap->encap_hdr + encap->encap_hdr_len);
> +	encap->encap_hdr_len += sizeof(*udp);
> +
> +	udp->dest = key->tp_dst;
> +	udp->len = cpu_to_be16(sizeof(*udp) + len);
> +}
> +
> +static void efx_gen_tun_header_vxlan(struct efx_tc_encap_action *encap)
> +{
> +	struct ip_tunnel_key *key = &encap->key;
> +	struct vxlanhdr *vxlan;
> +
> +	vxlan = (struct vxlanhdr *)(encap->encap_hdr + encap->encap_hdr_len);
> +	encap->encap_hdr_len += sizeof(*vxlan);
> +
> +	vxlan->vx_flags = VXLAN_HF_VNI;
> +	vxlan->vx_vni = vxlan_vni_field(tunnel_id_to_key32(key->tun_id));
> +}
> +
> +static void efx_gen_tun_header_geneve(struct efx_tc_encap_action *encap)
> +{
> +	struct ip_tunnel_key *key = &encap->key;
> +	struct genevehdr *geneve;
> +	u32 vni;
> +
> +	geneve = (struct genevehdr *)(encap->encap_hdr + encap->encap_hdr_len);
> +	encap->encap_hdr_len += sizeof(*geneve);
> +
> +	geneve->proto_type = htons(ETH_P_TEB);
> +	/* convert tun_id to host-endian so we can use host arithmetic to
> +	 * extract individual bytes.
> +	 */
> +	vni = ntohl(tunnel_id_to_key32(key->tun_id));
> +	geneve->vni[0] = vni >> 16;
> +	geneve->vni[1] = vni >> 8;
> +	geneve->vni[2] = vni;
> +}
> +
> +#define vxlan_header_l4_len	(sizeof(struct udphdr) + sizeof(struct vxlanhdr))
> +#define vxlan4_header_len	(sizeof(struct ethhdr) + sizeof(struct iphdr) + vxlan_header_l4_len)
> +static void efx_gen_vxlan_header_ipv4(struct efx_tc_encap_action *encap)
> +{
> +	BUILD_BUG_ON(sizeof(encap->encap_hdr) < vxlan4_header_len);
> +	efx_gen_tun_header_eth(encap, ETH_P_IP);
> +	efx_gen_tun_header_ipv4(encap, IPPROTO_UDP, vxlan_header_l4_len);
> +	efx_gen_tun_header_udp(encap, sizeof(struct vxlanhdr));
> +	efx_gen_tun_header_vxlan(encap);
> +}
> +
> +#define geneve_header_l4_len	(sizeof(struct udphdr) + sizeof(struct genevehdr))
> +#define geneve4_header_len	(sizeof(struct ethhdr) + sizeof(struct iphdr) + geneve_header_l4_len)
> +static void efx_gen_geneve_header_ipv4(struct efx_tc_encap_action *encap)
> +{
> +	BUILD_BUG_ON(sizeof(encap->encap_hdr) < geneve4_header_len);
> +	efx_gen_tun_header_eth(encap, ETH_P_IP);
> +	efx_gen_tun_header_ipv4(encap, IPPROTO_UDP, geneve_header_l4_len);
> +	efx_gen_tun_header_udp(encap, sizeof(struct genevehdr));
> +	efx_gen_tun_header_geneve(encap);
> +}
> +
> +#ifdef CONFIG_IPV6
> +#define vxlan6_header_len	(sizeof(struct ethhdr) + sizeof(struct ipv6hdr) + vxlan_header_l4_len)
> +static void efx_gen_vxlan_header_ipv6(struct efx_tc_encap_action *encap)
> +{
> +	BUILD_BUG_ON(sizeof(encap->encap_hdr) < vxlan6_header_len);
> +	efx_gen_tun_header_eth(encap, ETH_P_IPV6);
> +	efx_gen_tun_header_ipv6(encap, IPPROTO_UDP, vxlan_header_l4_len);
> +	efx_gen_tun_header_udp(encap, sizeof(struct vxlanhdr));
> +	efx_gen_tun_header_vxlan(encap);
> +}
> +
> +#define geneve6_header_len	(sizeof(struct ethhdr) + sizeof(struct ipv6hdr) + geneve_header_l4_len)
> +static void efx_gen_geneve_header_ipv6(struct efx_tc_encap_action *encap)
> +{
> +	BUILD_BUG_ON(sizeof(encap->encap_hdr) < geneve6_header_len);
> +	efx_gen_tun_header_eth(encap, ETH_P_IPV6);
> +	efx_gen_tun_header_ipv6(encap, IPPROTO_UDP, geneve_header_l4_len);
> +	efx_gen_tun_header_udp(encap, sizeof(struct genevehdr));
> +	efx_gen_tun_header_geneve(encap);
> +}
> +#endif
> +
> +static void efx_gen_encap_header(struct efx_nic *efx,
> +				 struct efx_tc_encap_action *encap)
> +{
> +	encap->n_valid = encap->neigh->n_valid;
> +
> +	/* GCC stupidly thinks that only values explicitly listed in the enum
> +	 * definition can _possibly_ be sensible case values, so without this
> +	 * cast it complains about the IPv6 versions.
> +	 */
> +	switch ((int)encap->type) {
> +	case EFX_ENCAP_TYPE_VXLAN:
> +		efx_gen_vxlan_header_ipv4(encap);
> +		break;
> +	case EFX_ENCAP_TYPE_GENEVE:
> +		efx_gen_geneve_header_ipv4(encap);
> +		break;
> +#ifdef CONFIG_IPV6
> +	case EFX_ENCAP_TYPE_VXLAN | EFX_ENCAP_FLAG_IPV6:
> +		efx_gen_vxlan_header_ipv6(encap);
> +		break;
> +	case EFX_ENCAP_TYPE_GENEVE | EFX_ENCAP_FLAG_IPV6:
> +		efx_gen_geneve_header_ipv6(encap);
> +		break;
> +#endif
> +	default:
> +		/* unhandled encap type, can't happen */
> +		if (net_ratelimit())
> +			netif_err(efx, drv, efx->net_dev,
> +				  "Bogus encap type %d, can't generate\n",
> +				  encap->type);
> +
> +		/* Use fallback action. */
> +		encap->n_valid = false;
> +		break;
> +	}
>  }
>  
Hello Edward Cree,

Why do you need to refactor the efx_gen_encap_header function in the same series?
I saw that patch 5 defined this function, and patch 6 refactored it,
instead of writing it all at once?

Regards,
Hao Lan

>  static void efx_tc_update_encap(struct efx_nic *efx,
> @@ -278,14 +449,19 @@ static void efx_tc_update_encap(struct efx_nic *efx,
>  		}
>  	}
>  
> +	/* Make sure we don't leak arbitrary bytes on the wire;
> +	 * set an all-0s ethernet header.  A successful call to
> +	 * efx_gen_encap_header() will overwrite this.
> +	 */
> +	memset(encap->encap_hdr, 0, sizeof(encap->encap_hdr));
> +	encap->encap_hdr_len = ETH_HLEN;
> +
>  	if (encap->neigh) {
>  		read_lock_bh(&encap->neigh->lock);
> -		efx_gen_encap_header(encap);
> +		efx_gen_encap_header(efx, encap);
>  		read_unlock_bh(&encap->neigh->lock);
>  	} else {
>  		encap->n_valid = false;
> -		memset(encap->encap_hdr, 0, sizeof(encap->encap_hdr));
> -		encap->encap_hdr_len = ETH_HLEN;
>  	}
>  
>  	rc = efx_mae_update_encap_md(efx, encap);
> @@ -482,7 +658,7 @@ struct efx_tc_encap_action *efx_tc_flower_create_encap_md(
>  	}
>  	encap->dest_mport = rc;
>  	read_lock_bh(&encap->neigh->lock);
> -	efx_gen_encap_header(encap);
> +	efx_gen_encap_header(efx, encap);
>  	read_unlock_bh(&encap->neigh->lock);
>  
>  	rc = efx_mae_allocate_encap_md(efx, encap);
> 
> .
> 

