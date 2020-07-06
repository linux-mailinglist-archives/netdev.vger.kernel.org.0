Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1D5215FCE
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgGFUCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:02:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:56566 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:02:11 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsXJP-0002nL-MO; Mon, 06 Jul 2020 22:01:59 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsXJP-000BEO-F9; Mon, 06 Jul 2020 22:01:59 +0200
Subject: Re: [PATCH net] vlan: consolidate VLAN parsing code and limit max
 parsing depth
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>
References: <20200706122951.48142-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4f7b2b71-8b2a-3aea-637d-52b148af1802@iogearbox.net>
Date:   Mon, 6 Jul 2020 22:01:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200706122951.48142-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25865/Mon Jul  6 16:07:44 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/20 2:29 PM, Toke Høiland-Jørgensen wrote:
> Toshiaki pointed out that we now have two very similar functions to extract
> the L3 protocol number in the presence of VLAN tags. And Daniel pointed out
> that the unbounded parsing loop makes it possible for maliciously crafted
> packets to loop through potentially hundreds of tags.
> 
> Fix both of these issues by consolidating the two parsing functions and
> limiting the VLAN tag parsing to an arbitrarily-chosen, but hopefully
> conservative, max depth of 32 tags. As part of this, switch over
> __vlan_get_protocol() to use skb_header_pointer() instead of
> pskb_may_pull(), to avoid the possible side effects of the latter and keep
> the skb pointer 'const' through all the parsing functions.
> 
> Reported-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> Reported-by: Daniel Borkmann <daniel@iogearbox.net>
> Fixes: d7bf2ebebc2b ("sched: consistently handle layer3 header accesses in the presence of VLANs")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>   include/linux/if_vlan.h | 57 ++++++++++++++++-------------------------
>   1 file changed, 22 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
> index 427a5b8597c2..855d16192e6a 100644
> --- a/include/linux/if_vlan.h
> +++ b/include/linux/if_vlan.h
> @@ -25,6 +25,8 @@
>   #define VLAN_ETH_DATA_LEN	1500	/* Max. octets in payload	 */
>   #define VLAN_ETH_FRAME_LEN	1518	/* Max. octets in frame sans FCS */
>   
> +#define VLAN_MAX_DEPTH	32		/* Max. number of nested VLAN tags parsed */
> +

Any insight on limits of nesting wrt QinQ, maybe from spec side? Why not 8 as max, for
example (I'd probably even consider a depth like this as utterly broken setup ..)?

Thanks,
Daniel
