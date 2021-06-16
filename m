Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A485C3A8DFF
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 03:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhFPBCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 21:02:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:48771 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhFPBCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 21:02:42 -0400
IronPort-SDR: X9kyPnsoEFhKg6PhokrRvvGaWEj5FPoLt2CYNu5zWLJl3g8XAWr9ya1UCFb6Ju+kWVPNcHT494
 vSneQycR8tPQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="193214056"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="193214056"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 18:00:34 -0700
IronPort-SDR: jvksWilzoMhFJRsPBrDPqMXs0olHIdj6hY08OFKj6yuTzCN/hXw/YqvBQG9OaEBiSbuAlnyHfo
 d2GbciaOyD+A==
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="478899811"
Received: from reschenk-mobl1.amr.corp.intel.com ([10.255.230.223])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 18:00:33 -0700
Date:   Tue, 15 Jun 2021 18:00:33 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [net-next, v3, 07/10] net: sock: extend SO_TIMESTAMPING for PHC
 binding
In-Reply-To: <20210615094517.48752-8-yangbo.lu@nxp.com>
Message-ID: <66873ea1-a54b-8d2-5b68-ce474fb75e46@linux.intel.com>
References: <20210615094517.48752-1-yangbo.lu@nxp.com> <20210615094517.48752-8-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021, Yangbo Lu wrote:

> Since PTP virtual clock support is added, there can be
> several PTP virtual clocks based on one PTP physical
> clock for timestamping.
>
> This patch is to extend SO_TIMESTAMPING API to support
> PHC (PTP Hardware Clock) binding by adding a new flag
> SOF_TIMESTAMPING_BIND_PHC. When PTP virtual clocks are
> in use, user space can configure to bind one for
> timestamping, but PTP physical clock is not supported
> and not needed to bind.
>
> This patch is preparation for timestamp conversion from
> raw timestamp to a specific PTP virtual clock time in
> core net.
>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
> Changes for v3:
> 	- Added this patch.
> ---
> include/net/sock.h              |  8 +++-
> include/uapi/linux/net_tstamp.h | 17 ++++++++-
> net/core/sock.c                 | 65 +++++++++++++++++++++++++++++++--
> net/ethtool/common.c            |  1 +
> net/mptcp/sockopt.c             | 10 +++--
> 5 files changed, 91 insertions(+), 10 deletions(-)
>
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 9b341c2c924f..adb6c0edc867 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -316,7 +316,9 @@ struct bpf_local_storage;
>   *	@sk_timer: sock cleanup timer
>   *	@sk_stamp: time stamp of last packet received
>   *	@sk_stamp_seq: lock for accessing sk_stamp on 32 bit architectures only
> -  *	@sk_tsflags: SO_TIMESTAMPING socket options
> +  *	@sk_tsflags: SO_TIMESTAMPING flags
> +  *	@sk_bind_phc: SO_TIMESTAMPING bind PHC index of PTP virtual clock
> +  *	              for timestamping
>   *	@sk_tskey: counter to disambiguate concurrent tstamp requests
>   *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
>   *	@sk_socket: Identd and reporting IO signals
> @@ -493,6 +495,7 @@ struct sock {
> 	seqlock_t		sk_stamp_seq;
> #endif
> 	u16			sk_tsflags;
> +	int			sk_bind_phc;
> 	u8			sk_shutdown;
> 	u32			sk_tskey;
> 	atomic_t		sk_zckey;
> @@ -2744,7 +2747,8 @@ void sock_def_readable(struct sock *sk);
>
> int sock_bindtoindex(struct sock *sk, int ifindex, bool lock_sk);
> void sock_set_timestamp(struct sock *sk, int optname, bool valbool);
> -int sock_set_timestamping(struct sock *sk, int optname, int val);
> +int sock_set_timestamping(struct sock *sk, int optname, int val,
> +			  sockptr_t optval, unsigned int optlen);
>
> void sock_enable_timestamps(struct sock *sk);
> void sock_no_linger(struct sock *sk);
> diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
> index 7ed0b3d1c00a..9d4cde4ef7e6 100644
> --- a/include/uapi/linux/net_tstamp.h
> +++ b/include/uapi/linux/net_tstamp.h
> @@ -13,7 +13,7 @@
> #include <linux/types.h>
> #include <linux/socket.h>   /* for SO_TIMESTAMPING */
>
> -/* SO_TIMESTAMPING gets an integer bit field comprised of these values */
> +/* SO_TIMESTAMPING flags */
> enum {
> 	SOF_TIMESTAMPING_TX_HARDWARE = (1<<0),
> 	SOF_TIMESTAMPING_TX_SOFTWARE = (1<<1),
> @@ -30,8 +30,9 @@ enum {
> 	SOF_TIMESTAMPING_OPT_STATS = (1<<12),
> 	SOF_TIMESTAMPING_OPT_PKTINFO = (1<<13),
> 	SOF_TIMESTAMPING_OPT_TX_SWHW = (1<<14),
> +	SOF_TIMESTAMPING_BIND_PHC = (1<<15),
>
> -	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_OPT_TX_SWHW,
> +	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_BIND_PHC,
> 	SOF_TIMESTAMPING_MASK = (SOF_TIMESTAMPING_LAST - 1) |
> 				 SOF_TIMESTAMPING_LAST
> };
> @@ -46,6 +47,18 @@ enum {
> 					 SOF_TIMESTAMPING_TX_SCHED | \
> 					 SOF_TIMESTAMPING_TX_ACK)
>
> +/**
> + * struct so_timestamping - SO_TIMESTAMPING parameter
> + *
> + * @flags:	SO_TIMESTAMPING flags
> + * @bind_phc:	Index of PTP virtual clock bound to sock. This is available
> + *		if flag SOF_TIMESTAMPING_BIND_PHC is set.
> + */
> +struct so_timestamping {
> +	int flags;
> +	int bind_phc;
> +};
> +
> /**
>  * struct hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP parameter
>  *
> diff --git a/net/core/sock.c b/net/core/sock.c
> index ddfa88082a2b..70d2c2322429 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -139,6 +139,8 @@
> #include <net/tcp.h>
> #include <net/busy_poll.h>
>
> +#include <linux/ethtool.h>
> +
> static DEFINE_MUTEX(proto_list_mutex);
> static LIST_HEAD(proto_list);
>
> @@ -794,8 +796,53 @@ void sock_set_timestamp(struct sock *sk, int optname, bool valbool)
> 	}
> }
>
> -int sock_set_timestamping(struct sock *sk, int optname, int val)
> +static int sock_timestamping_bind_phc(struct sock *sk, int phc_index)
> {
> +	struct ethtool_phc_vclocks phc_vclocks = { };
> +	struct net *net = sock_net(sk);
> +	struct net_device *dev = NULL;
> +	bool match = false;
> +	int i;
> +
> +	if (sk->sk_bound_dev_if)
> +		dev = dev_get_by_index(net, sk->sk_bound_dev_if);
> +
> +	if (!dev) {
> +		pr_err("%s: sock not bind to device\n", __func__);
> +		return -EOPNOTSUPP;
> +	}
> +
> +	ethtool_op_get_phc_vclocks(dev, &phc_vclocks);
> +
> +	for (i = 0; i < phc_vclocks.num; i++) {
> +		if (phc_vclocks.index[i] == phc_index) {
> +			match = true;
> +			break;
> +		}
> +	}
> +
> +	if (!match)
> +		return -EINVAL;
> +
> +	sk->sk_bind_phc = phc_index;
> +
> +	return 0;
> +}
> +
> +int sock_set_timestamping(struct sock *sk, int optname, int val,
> +			  sockptr_t optval, unsigned int optlen)
> +{
> +	struct so_timestamping timestamping;
> +	int ret;
> +
> +	if (optlen == sizeof(timestamping)) {
> +		if (copy_from_sockptr(&timestamping, optval,
> +				      sizeof(timestamping)))
> +			return -EFAULT;
> +
> +		val = timestamping.flags;
> +	}
> +
> 	if (val & ~SOF_TIMESTAMPING_MASK)
> 		return -EINVAL;
>
> @@ -816,6 +863,15 @@ int sock_set_timestamping(struct sock *sk, int optname, int val)
> 	    !(val & SOF_TIMESTAMPING_OPT_TSONLY))
> 		return -EINVAL;
>
> +	if (optlen == sizeof(timestamping) &&
> +	    val & SOF_TIMESTAMPING_BIND_PHC) {
> +		ret = sock_timestamping_bind_phc(sk, timestamping.bind_phc);
> +		if (ret)
> +			return ret;
> +	} else {
> +		sk->sk_bind_phc = -1;
> +	}
> +
> 	sk->sk_tsflags = val;
> 	sock_valbool_flag(sk, SOCK_TSTAMP_NEW, optname == SO_TIMESTAMPING_NEW);
>
> @@ -1057,7 +1113,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>
> 	case SO_TIMESTAMPING_NEW:
> 	case SO_TIMESTAMPING_OLD:
> -		ret = sock_set_timestamping(sk, optname, val);
> +		ret = sock_set_timestamping(sk, optname, val, optval, optlen);
> 		break;
>
> 	case SO_RCVLOWAT:
> @@ -1332,6 +1388,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
> 		struct __kernel_old_timeval tm;
> 		struct  __kernel_sock_timeval stm;
> 		struct sock_txtime txtime;
> +		struct so_timestamping timestamping;
> 	} v;
>
> 	int lv = sizeof(int);
> @@ -1435,7 +1492,9 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
> 		break;
>
> 	case SO_TIMESTAMPING_OLD:
> -		v.val = sk->sk_tsflags;
> +		lv = sizeof(v.timestamping);
> +		v.timestamping.flags = sk->sk_tsflags;
> +		v.timestamping.bind_phc = sk->sk_bind_phc;
> 		break;
>
> 	case SO_RCVTIMEO_OLD:
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 14035f2dc6d4..4bf1bd3a3db6 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -398,6 +398,7 @@ const char sof_timestamping_names[][ETH_GSTRING_LEN] = {
> 	[const_ilog2(SOF_TIMESTAMPING_OPT_STATS)]    = "option-stats",
> 	[const_ilog2(SOF_TIMESTAMPING_OPT_PKTINFO)]  = "option-pktinfo",
> 	[const_ilog2(SOF_TIMESTAMPING_OPT_TX_SWHW)]  = "option-tx-swhw",
> +	[const_ilog2(SOF_TIMESTAMPING_BIND_PHC)]     = "bind-phc",
> };
> static_assert(ARRAY_SIZE(sof_timestamping_names) == __SOF_TIMESTAMPING_CNT);
>
> diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
> index 092d1f635d27..2ca90b230827 100644
> --- a/net/mptcp/sockopt.c
> +++ b/net/mptcp/sockopt.c
> @@ -140,7 +140,10 @@ static void mptcp_so_incoming_cpu(struct mptcp_sock *msk, int val)
> 	mptcp_sol_socket_sync_intval(msk, SO_INCOMING_CPU, val);
> }
>
> -static int mptcp_setsockopt_sol_socket_tstamp(struct mptcp_sock *msk, int optname, int val)
> +static int mptcp_setsockopt_sol_socket_tstamp(struct mptcp_sock *msk,
> +					      int optname, int val,
> +					      sockptr_t optval,
> +					      unsigned int optlen)
> {
> 	sockptr_t optval = KERNEL_SOCKPTR(&val);
> 	struct mptcp_subflow_context *subflow;
> @@ -166,7 +169,7 @@ static int mptcp_setsockopt_sol_socket_tstamp(struct mptcp_sock *msk, int optnam
> 			break;
> 		case SO_TIMESTAMPING_NEW:
> 		case SO_TIMESTAMPING_OLD:
> -			sock_set_timestamping(sk, optname, val);
> +			sock_set_timestamping(sk, optname, val, optval, optlen);

This is inside a loop, so in cases where optlen == sizeof(struct 
so_timestamping) this will end up re-copying the structure from userspace 
one extra time for each MPTCP subflow: once for the MPTCP socket, plus one 
time for each of the TCP subflows that are grouped under this MPTCP 
connection.

Given that the extra copies only happen when using the extended bind_phc 
option, it's not a huge cost. But sock_set_timestamping() was written to 
avoid the extra copies for 'int' sized options, and if that was worth the 
effort then the larger so_timestamping structure could be copied (once) 
before the sock_set_timestamping() call and passed in.

> 			break;
> 		}
>
> @@ -207,7 +210,8 @@ static int mptcp_setsockopt_sol_socket_int(struct mptcp_sock *msk, int optname,
> 	case SO_TIMESTAMPNS_NEW:
> 	case SO_TIMESTAMPING_OLD:
> 	case SO_TIMESTAMPING_NEW:
> -		return mptcp_setsockopt_sol_socket_tstamp(msk, optname, val);
> +		return mptcp_setsockopt_sol_socket_tstamp(msk, optname, val,
> +							  optval, optlen);

Rather than modifying mptcp_setsockopt_sol_socket_int(), I suggest adding 
a mptcp_setsockopt_sol_socket_timestamping() helper function that can 
handle the special copying for so_timestamping.

> 	}
>
> 	return -ENOPROTOOPT;
> -- 
> 2.25.1
>
>

--
Mat Martineau
Intel
