Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FACF134910
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 18:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgAHRR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 12:17:59 -0500
Received: from www62.your-server.de ([213.133.104.62]:41726 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbgAHRR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 12:17:58 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipExw-0003F9-Fv; Wed, 08 Jan 2020 18:17:56 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ipExw-000LPG-8a; Wed, 08 Jan 2020 18:17:56 +0100
Subject: Re: [PATCH][bpf-next] bpf: return EOPNOTSUPP when invalid map type in
 __bpf_tx_xdp_map
To:     Li RongQing <lirongqing@baidu.com>
References: <1578032749-18197-1-git-send-email-lirongqing@baidu.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, brouer@redhat.com
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5185e163-2c63-34bf-f521-5d643c95c0e6@iogearbox.net>
Date:   Wed, 8 Jan 2020 18:17:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1578032749-18197-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25688/Wed Jan  8 10:56:24 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/20 7:25 AM, Li RongQing wrote:
> a negative value -EOPNOTSUPP should be returned if map->map_type
> is invalid although that seems unlikely now, then the caller will
> continue to handle buffer, or else the buffer will be leaked
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>   net/core/filter.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 1cbac34a4e11..40fa5905321c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3512,7 +3512,7 @@ static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
>   	case BPF_MAP_TYPE_XSKMAP:
>   		return __xsk_map_redirect(fwd, xdp);
>   	default:
> -		break;
> +		return -EOPNOTSUPP;

So in case of generic XDP we return with -EBADRQC in xdp_do_generic_redirect_map().
I would suggest we adapt the same error code here as well, so it's consistent for
the tracepoint output and not to be confused with -EOPNOTSUPP from other locations
like dev_map_enqueue() when ndo_xdp_xmit is missing or such.

>   	}
>   	return 0;
>   }
> 

