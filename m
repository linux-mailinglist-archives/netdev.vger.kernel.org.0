Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3F91C98DE
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgEGSJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:09:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:28106 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgEGSJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 14:09:25 -0400
IronPort-SDR: s76za/UhaHC15ngBpvCD2cWKJEUoQbphkETl9JfhV97psMRSPwcIF7m2PRWHFBPTLIGY6hXIEh
 r6uSckYkzevg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 11:09:25 -0700
IronPort-SDR: eLRRNEO+LV4Ah0RljpbSCMCiXtZjxFquKpaYZKHLBDjqlagMnxfL3DeHV40pF+Wy2KwYU/ZWeR
 nZhJROVPIxkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="462231494"
Received: from unknown (HELO ellie) ([10.213.191.132])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2020 11:09:24 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next] net: relax SO_TXTIME CAP_NET_ADMIN check
In-Reply-To: <20200507170539.157454-1-edumazet@google.com>
References: <20200507170539.157454-1-edumazet@google.com>
Date:   Thu, 07 May 2020 11:09:24 -0700
Message-ID: <87mu6jsjl7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Eric Dumazet <edumazet@google.com> writes:

> Now sch_fq has horizon feature, we want to allow QUIC/UDP applications
> to use EDT model so that pacing can be offloaded to the kernel (sch_fq)
> or the NIC.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> ---
>  net/core/sock.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index b714162213aeae98bfee24d8b457547fe7abab4f..fd85e651ce284b6987f0e8fae94f76ec2c432899 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1152,23 +1152,31 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>  		break;
>  
>  	case SO_TXTIME:
> -		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
> -			ret = -EPERM;
> -		} else if (optlen != sizeof(struct sock_txtime)) {
> +		if (optlen != sizeof(struct sock_txtime)) {
>  			ret = -EINVAL;
> +			break;
>  		} else if (copy_from_user(&sk_txtime, optval,
>  			   sizeof(struct sock_txtime))) {
>  			ret = -EFAULT;
> +			break;
>  		} else if (sk_txtime.flags & ~SOF_TXTIME_FLAGS_MASK) {
>  			ret = -EINVAL;
> -		} else {
> -			sock_valbool_flag(sk, SOCK_TXTIME, true);
> -			sk->sk_clockid = sk_txtime.clockid;
> -			sk->sk_txtime_deadline_mode =
> -				!!(sk_txtime.flags & SOF_TXTIME_DEADLINE_MODE);
> -			sk->sk_txtime_report_errors =
> -				!!(sk_txtime.flags & SOF_TXTIME_REPORT_ERRORS);
> +			break;
>  		}
> +		/* CLOCK_MONOTONIC is only used by sch_fq, and this packet
> +		 * scheduler has enough safe guards.
> +		 */
> +		if (sk_txtime.clockid != CLOCK_MONOTONIC &&
> +		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
> +			ret = -EPERM;
> +			break;
> +		}

I was a bit worried until I saw the check above.

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


> +		sock_valbool_flag(sk, SOCK_TXTIME, true);
> +		sk->sk_clockid = sk_txtime.clockid;
> +		sk->sk_txtime_deadline_mode =
> +			!!(sk_txtime.flags & SOF_TXTIME_DEADLINE_MODE);
> +		sk->sk_txtime_report_errors =
> +			!!(sk_txtime.flags & SOF_TXTIME_REPORT_ERRORS);
>  		break;
>  
>  	case SO_BINDTOIFINDEX:
> -- 
> 2.26.2.526.g744177e7f7-goog
>

-- 
Vinicius
