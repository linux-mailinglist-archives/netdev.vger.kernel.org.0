Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E1B30332F
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 05:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbhAZEru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbhAYJPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:15:23 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F663C06121F
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 00:47:48 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id p13so14330552ljg.2
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 00:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RP0/td3PSkDs6xFktP/sLPs5MJxfK4uj+AF77ecmWuQ=;
        b=a/GnleVXuo/R/3KXHzpV8RWiyiTEAJY6TE+35giQQrU33/eVn5NnXRL4j87utXkxiu
         ogWvvsGTp0go5FUiLLTMDAn4GOm0DDQnmNnY5LotgDyhzVqmLW52XsKAbyXpyUOMOMgH
         fOyjd1clLrRkxOkjsMUJdQp11MP1fZEHyKCa+DfHGRoft4oDslz5ciNWDI1X5hxzCVxo
         r+GUQbarRVhrPn91cEAFudjq1u7dA9uKPhxkxmr96P7SczTFn0Nbf2nnoPuB05EcWgxC
         Dmfo9zVqk2Ku0MybnLVR/+/N/kk+TvtIdox8p7a+y5JG1Tw2cYLX01Vad6ppgZASRvmS
         EmAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RP0/td3PSkDs6xFktP/sLPs5MJxfK4uj+AF77ecmWuQ=;
        b=aoCMn7LxDh6IMqLdPNpdUVhJTXgWZc9Mlc4OEWRO2suLi6g0FWM3tSU79KYbqXr/OD
         fOgqqQxuhSsdVo2cZ6ZlUCfYI9/JhTd6QnVmZAlc7TaNfpNZgJT8EcteDaQX4BbTIMDq
         JE+lkUbRlLBAYgKuLAUdmZHl/zY8Z+dMqL72RV5zXKEzoodG/cWJomD13UXQzQmbYbvY
         4/IsX4KgZ3FjmdbyI+Nj1NRkfDlmdL3hxAHiVtsxW2fiC6W81HQZFdb84heV6rDJsaBv
         zTa9SprkvEj7t4mqcT5Veh5LNIHjoSgGrAh/4mNwaPQo+5BoERUBNP2RnyhB/QNq/w5j
         xOJw==
X-Gm-Message-State: AOAM533HykNFbDhdV17Ckd/gxLDDLUVLknFJbtdSB14pqMDx1bt9Yq0S
        LJcZzPDAWy469gA++H5ahFSguw==
X-Google-Smtp-Source: ABdhPJzImt7HTrN4eIRu4mGrpTnzkUmHviTUOjX1udjNlU7SivtqeBljAjJTVAXooh7RAqJSuXGfpw==
X-Received: by 2002:a2e:3612:: with SMTP id d18mr730599lja.211.1611564466646;
        Mon, 25 Jan 2021 00:47:46 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id l4sm732873lfh.96.2021.01.25.00.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 00:47:46 -0800 (PST)
Subject: Re: [RFC PATCH 14/16] gtp: add support for flow based tunneling
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-15-jonas@norrbonn.se>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <c9331481-4b6b-4451-d54b-93a1b31680dc@norrbonn.se>
Date:   Mon, 25 Jan 2021 09:47:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210123195916.2765481-15-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin,

On 23/01/2021 20:59, Jonas Bonn wrote:
> From: Pravin B Shelar <pbshelar@fb.com>
> 
> @@ -617,29 +686,84 @@ static void gtp_push_header(struct sk_buff *skb, struct pdp_ctx *pctx,
>   static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>   {
>   	struct gtp_dev *gtp = netdev_priv(dev);
> +	struct gtpu_metadata *opts = NULL;
> +	struct pdp_ctx md_pctx;
>   	struct pdp_ctx *pctx;
> +	__be16 port;
>   	struct rtable *rt;
> -	__be32 saddr;
>   	struct iphdr *iph;
> +	__be32 saddr;
>   	int headroom;
> -	__be16 port;
> +	__u8 tos;
>   	int r;
>   
> -	/* Read the IP destination address and resolve the PDP context.
> -	 * Prepend PDP header with TEI/TID from PDP ctx.
> -	 */
> -	iph = ip_hdr(skb);
> -	if (gtp->role == GTP_ROLE_SGSN)
> -		pctx = ipv4_pdp_find(gtp, iph->saddr);
> -	else
> -		pctx = ipv4_pdp_find(gtp, iph->daddr);
> +	if (gtp->collect_md) {

Why do we have this restriction that the device be exclusively "collect 
metadata" mode or PDP context mode?  Why are we not able to mix the two?

Furthermore, since the collect_md_sock will effectively always be 
listening on INADDR_ANY, that precludes any other PDP context devices 
from co-existing with it.  So setting up a secondary device for PDP 
contexts isn't a feasible workaround.

If mixing isn't possible, then I suppose PDP context management needs to 
be made to fail gracefully in "collect_md" mode... with the current 
patches I think that contexts can be set up but they are just silently 
ignored, which seems like a potential source of confusion.

/Jonas


> +		/* LWT GTP1U encap */
> +		struct ip_tunnel_info *info = NULL;
>   
> -	if (!pctx) {
> -		netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
> -			   &iph->daddr);
> -		return -ENOENT;
> +		info = skb_tunnel_info(skb);
> +		if (!info) {
> +			netdev_dbg(dev, "missing tunnel info");
> +			return -ENOENT;
> +		}
> +		if (info->key.tp_dst && ntohs(info->key.tp_dst) != GTP1U_PORT) {
> +			netdev_dbg(dev, "unexpected GTP dst port: %d", ntohs(info->key.tp_dst));
> +			return -EOPNOTSUPP;
> +		}
> +
> +		if (!gtp->sk1u) {
> +			netdev_dbg(dev, "missing tunnel sock");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		pctx = &md_pctx;
> +		memset(pctx, 0, sizeof(*pctx));
> +		pctx->sk = gtp->sk1u;
> +		pctx->gtp_version = GTP_V1;
> +		pctx->u.v1.o_tei = ntohl(tunnel_id_to_key32(info->key.tun_id));
> +		pctx->peer_addr_ip4.s_addr = info->key.u.ipv4.dst;
> +
> +		saddr = info->key.u.ipv4.src;
> +		tos = info->key.tos;
> +
> +		if (info->options_len != 0) {
> +			if (info->key.tun_flags & TUNNEL_GTPU_OPT) {
> +				opts = ip_tunnel_info_opts(info);
> +			} else {
> +				netdev_dbg(dev, "missing tunnel metadata for control pkt");
> +				return -EOPNOTSUPP;
> +			}
> +		}
> +		netdev_dbg(dev, "flow-based GTP1U encap: tunnel id %d\n",
> +			   pctx->u.v1.o_tei);
> +	} else {
> +		struct iphdr *iph;
> +
> +		if (ntohs(skb->protocol) != ETH_P_IP)
> +			return -EOPNOTSUPP;
> +
> +		iph = ip_hdr(skb);
> +
> +		/* Read the IP destination address and resolve the PDP context.
> +		 * Prepend PDP header with TEI/TID from PDP ctx.
> +		 */
> +		if (gtp->role == GTP_ROLE_SGSN)
> +			pctx = ipv4_pdp_find(gtp, iph->saddr);
> +		else
> +			pctx = ipv4_pdp_find(gtp, iph->daddr);
> +
> +		if (!pctx) {
> +			netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
> +				   &iph->daddr);
> +			return -ENOENT;
> +		}
> +		netdev_dbg(dev, "found PDP context %p\n", pctx);
> +
> +		saddr = inet_sk(pctx->sk)->inet_saddr;
> +		tos = iph->tos;
> +		netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
> +			   &iph->saddr, &iph->daddr);
>   	}
> -	netdev_dbg(dev, "found PDP context %p\n", pctx);
>   
>   	rt = gtp_get_v4_rt(skb, dev, pctx, &saddr);
>   	if (IS_ERR(rt)) {
> @@ -691,7 +815,7 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>   
>   	udp_tunnel_xmit_skb(rt, pctx->sk, skb,
>   			    saddr, pctx->peer_addr_ip4.s_addr,
> -			    iph->tos,
> +			    tos,
>   			    ip4_dst_hoplimit(&rt->dst),
>   			    0,
>   			    port, port,
> diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
> index 79f9191bbb24..62aff78b7c56 100644
> --- a/include/uapi/linux/gtp.h
> +++ b/include/uapi/linux/gtp.h
> @@ -2,6 +2,8 @@
>   #ifndef _UAPI_LINUX_GTP_H_
>   #define _UAPI_LINUX_GTP_H_
>   
> +#include <linux/types.h>
> +
>   #define GTP_GENL_MCGRP_NAME	"gtp"
>   
>   enum gtp_genl_cmds {
> @@ -34,4 +36,14 @@ enum gtp_attrs {
>   };
>   #define GTPA_MAX (__GTPA_MAX + 1)
>   
> +enum {
> +	GTP_METADATA_V1
> +};
> +
> +struct gtpu_metadata {
> +	__u8    ver;
> +	__u8    flags;
> +	__u8    type;
> +};
> +
>   #endif /* _UAPI_LINUX_GTP_H_ */
> diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
> index 7d9105533c7b..802da679fab1 100644
> --- a/include/uapi/linux/if_tunnel.h
> +++ b/include/uapi/linux/if_tunnel.h
> @@ -176,6 +176,7 @@ enum {
>   #define TUNNEL_VXLAN_OPT	__cpu_to_be16(0x1000)
>   #define TUNNEL_NOCACHE		__cpu_to_be16(0x2000)
>   #define TUNNEL_ERSPAN_OPT	__cpu_to_be16(0x4000)
> +#define TUNNEL_GTPU_OPT		__cpu_to_be16(0x8000)
>   
>   #define TUNNEL_OPTIONS_PRESENT \
>   		(TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index d208b2af697f..28d649bda686 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -617,6 +617,7 @@ enum {
>   	IFLA_GTP_FD1,
>   	IFLA_GTP_PDP_HASHSIZE,
>   	IFLA_GTP_ROLE,
> +	IFLA_GTP_COLLECT_METADATA,
>   	__IFLA_GTP_MAX,
>   };
>   #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
> 
