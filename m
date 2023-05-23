Return-Path: <netdev+bounces-4708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 575AD70DFA4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:49:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABCC8280FD7
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD82B1F198;
	Tue, 23 May 2023 14:49:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF374C7B;
	Tue, 23 May 2023 14:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8529C433EF;
	Tue, 23 May 2023 14:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684853358;
	bh=oXOmFChpbfSn0ji1bqaSPr69srXCRms6pIPi5d3extM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RnJ/biP0CNt2CzSCbIf5AInpWLS2/o3mAdml1gU6P8dZI5Svc0H4Kg/0k6HUOTDPR
	 eXUZo/gzxSjSCTyKGI7PT57SRJhvzT+4BdLb+ac5go6P2zZqw6FyoZcLzcV26wzAXr
	 TraGlq925UBUqOYgnfGNx7VPx6BnP8mH6zk+aD0v5THCuz8GjPZh1ALYKHfSQ5MDu7
	 W4xUR2+LIHBNTyaZSOTGH2VQEqWDITM1iHTMysKmRtyak4QwCnGE8EuynGMy3DZXmC
	 hHvQ64sPkPACq17iIp/8wp82Oi9NPWG5kGwN//D8qEld7TVXT7H59Q7AEsE41qeXmV
	 hcUwObqj4XWWA==
Message-ID: <2f02c9b6-1115-791d-cdaf-049c9eeaee0c@kernel.org>
Date: Tue, 23 May 2023 08:49:14 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v2] net: ioctl: Use kernel memory on protocol ioctl
 callbacks
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Alexander Aring <alex.aring@gmail.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Matthieu Baerts <matthieu.baerts@tessares.net>,
 Mat Martineau <martineau@kernel.org>,
 Remi Denis-Courmont <courmisch@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>
Cc: leit@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 dccp@vger.kernel.org, linux-wpan@vger.kernel.org, mptcp@lists.linux.dev,
 linux-sctp@vger.kernel.org
References: <20230522134735.2810070-1-leitao@debian.org>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230522134735.2810070-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/23 7:47 AM, Breno Leitao wrote:
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 5440e67bcfe3..a2cea95aec99 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -114,6 +114,8 @@
>  #include <linux/memcontrol.h>
>  #include <linux/prefetch.h>
>  #include <linux/compat.h>
> +#include <linux/mroute.h>
> +#include <linux/mroute6.h>
>  
>  #include <linux/uaccess.h>
>  
> @@ -138,6 +140,7 @@
>  
>  #include <net/tcp.h>
>  #include <net/busy_poll.h>
> +#include <net/phonet/phonet.h>
>  
>  #include <linux/ethtool.h>
>  
> @@ -4106,3 +4109,112 @@ int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len)
>  	return sk->sk_prot->bind_add(sk, addr, addr_len);
>  }
>  EXPORT_SYMBOL(sock_bind_add);
> +
> +#ifdef CONFIG_PHONET
> +/* Copy u32 value from userspace and do not return anything back */
> +static int sk_ioctl_in(struct sock *sk, unsigned int cmd, void __user *arg)
> +{
> +	int karg;
> +
> +	if (get_user(karg, (u32 __user *)arg))
> +		return -EFAULT;
> +
> +	return sk->sk_prot->ioctl(sk, cmd, &karg);
> +}
> +#endif
> +
> +#if defined(CONFIG_IP_MROUTE) || defined(CONFIG_IPV6_MROUTE)
> +/* Copy 'size' bytes from userspace and return `size` back to userspace */
> +static int sk_ioctl_inout(struct sock *sk, unsigned int cmd,
> +			  void __user *arg, void *karg, size_t size)
> +{
> +	int ret;
> +
> +	if (copy_from_user(karg, arg, size))
> +		return -EFAULT;
> +
> +	ret = sk->sk_prot->ioctl(sk, cmd, karg);
> +	if (ret)
> +		return ret;
> +
> +	if (copy_to_user(arg, karg, size))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +#endif
> +
> +/* This is the most common ioctl prep function, where the result (4 bytes) is
> + * copied back to userspace if the ioctl() returns successfully. No input is
> + * copied from userspace as input argument.
> + */
> +static int sk_ioctl_out(struct sock *sk, unsigned int cmd, void __user *arg)
> +{
> +	int ret, karg = 0;
> +
> +	ret = sk->sk_prot->ioctl(sk, cmd, &karg);
> +	if (ret)
> +		return ret;
> +
> +	return put_user(karg, (int __user *)arg);
> +}
> +
> +/* A wrapper around sock ioctls, which copies the data from userspace
> + * (depending on the protocol/ioctl), and copies back the result to userspace.
> + * The main motivation for this function is to pass kernel memory to the
> + * protocol ioctl callbacks, instead of userspace memory.
> + */
> +int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> +{
> +#ifdef CONFIG_IP_MROUTE
> +	if (sk->sk_family == PF_INET && sk->sk_protocol == IPPROTO_RAW) {
> +		switch (cmd) {
> +		/* These userspace buffers will be consumed by ipmr_ioctl() */
> +		case SIOCGETVIFCNT: {
> +			struct sioc_vif_req buffer;
> +
> +			return sk_ioctl_inout(sk, cmd, arg, &buffer,
> +					      sizeof(buffer));
> +			}
> +		case SIOCGETSGCNT: {
> +			struct sioc_sg_req buffer;
> +
> +			return sk_ioctl_inout(sk, cmd, arg, &buffer,
> +					      sizeof(buffer));
> +			}
> +		}
> +	}
> +#endif
> +#ifdef CONFIG_IPV6_MROUTE
> +	if (sk->sk_family == PF_INET6 && sk->sk_protocol == IPPROTO_RAW) {
> +		switch (cmd) {
> +		/* These userspace buffers will be consumed by ip6mr_ioctl() */
> +		case SIOCGETMIFCNT_IN6: {
> +			struct sioc_mif_req6 buffer;
> +
> +			return sk_ioctl_inout(sk, cmd, arg, &buffer,
> +					      sizeof(buffer));
> +			}
> +		case SIOCGETSGCNT_IN6: {
> +			struct sioc_mif_req6 buffer;
> +
> +			return sk_ioctl_inout(sk, cmd, arg, &buffer,
> +					      sizeof(buffer));
> +			}
> +		}
> +	}
> +#endif
> +#ifdef CONFIG_PHONET
> +	if (sk->sk_family == PF_PHONET && sk->sk_protocol == PN_PROTO_PHONET) {
> +		/* This userspace buffers will be consumed by pn_ioctl() */
> +		switch (cmd) {
> +		case SIOCPNADDRESOURCE:
> +		case SIOCPNDELRESOURCE:
> +			return sk_ioctl_in(sk, cmd, arg);
> +		}
> +	}
> +#endif

Rather than bleed some of these protocol specific details into core
code, how about something like this in include net/phonet/phonet.h

static inline bool sk_is_phonet(struct sock *sk)
{
	return sk->sk_family == PF_PHONET && \
		sk->sk_protocol == PN_PROTO_PHONET;
}

And then in net/core/sock.c:

	if (sk_is_phonet(sk)) {
		rc = phonet_sk_ioctl(...);
		if (rc <= 0)
			return rc;
	}

where < 0 means error, == 0 means handled and > 0 means (keep going).
Similarly for the other 2 above.


