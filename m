Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A167D3749BC
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 22:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbhEEU4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 16:56:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:54246 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhEEU4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 16:56:11 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1leOY3-000GTl-Hv; Wed, 05 May 2021 22:55:11 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1leOY3-000Xhw-9R; Wed, 05 May 2021 22:55:11 +0200
Subject: Re: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
To:     Dongseok Yi <dseok.yi@samsung.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
Date:   Wed, 5 May 2021 22:55:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26161/Wed May  5 13:06:38 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 12:08 PM, Dongseok Yi wrote:
> tcp_gso_segment check for the size of GROed payload if it is bigger
> than the mss. bpf_skb_proto_6_to_4 increases mss, but the mss can be
> bigger than the size of GROed payload unexpectedly if data_len is not
> big enough.
> 
> Assume that skb gso_size = 1372 and data_len = 8. bpf_skb_proto_6_to_4
> would increse the gso_size to 1392. tcp_gso_segment will get an error
> with 1380 <= 1392.
> 
> Check for the size of GROed payload if it is really bigger than target
> mss when increase mss.
> 
> Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> ---
>   net/core/filter.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9323d34..3f79e3c 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
>   		}
>   
>   		/* Due to IPv4 header, MSS can be upgraded. */
> -		skb_increase_gso_size(shinfo, len_diff);
> +		if (skb->data_len > len_diff)

Could you elaborate some more on what this has to do with data_len specifically
here? I'm not sure I follow exactly your above commit description. Are you saying
that you're hitting in tcp_gso_segment():

         [...]
         mss = skb_shinfo(skb)->gso_size;
         if (unlikely(skb->len <= mss))
                 goto out;
         [...]

Please provide more context on the bug, thanks!

> +			skb_increase_gso_size(shinfo, len_diff);
> +
>   		/* Header must be checked, and gso_segs recomputed. */
>   		shinfo->gso_type |= SKB_GSO_DODGY;
>   		shinfo->gso_segs = 0;
> 

