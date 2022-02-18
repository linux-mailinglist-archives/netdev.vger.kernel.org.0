Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3774BC1CD
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 22:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbiBRVYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 16:24:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238263AbiBRVYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 16:24:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183EC36B52;
        Fri, 18 Feb 2022 13:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7FC2B826F3;
        Fri, 18 Feb 2022 21:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4713DC340E9;
        Fri, 18 Feb 2022 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645219423;
        bh=d8XDys7K7nUuahPS9gIDaGWDjUn6oOQjOqqDtWx4Q94=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WhO3tBIUtMd1nNnGhBF0nEB1u0UA4xvCuZpYf3BA4R/NgQKnPvs7B40TO4uc3FN6v
         yZrWiHA0xtUHBmUn6psNhOaSALaBTlULArMCrsKxFb2wRLk3jXER2I7v8vqXVo4aXK
         t2i5Cv68mHBwAtoG69+8UoCQmp8aa6ulARDgRj6EqXo+BfVTsWkf8JZAVzlNR2OkFV
         SV+qmCUZAhCii1RXJOezw/by0NTtuvpEXamZero+Ui1sJ+VnjGOw2+ocfxY0j+yznQ
         xAmz2lr3ccwyds4Zm+X11VGop+EEhGDu7Ge/YOMn3WFwGzo9DPny5flNLtkiNHAjK3
         c+LY23bjy2S3w==
Message-ID: <ac145b7b-8c78-88dd-ded5-c780bf7e94e1@kernel.org>
Date:   Fri, 18 Feb 2022 14:23:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v2 0/9] net: add skb drop reasons to TCP packet
 receive
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
References: <20220218083133.18031-1-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220218083133.18031-1-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/22 1:31 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()"),
> we added the support of reporting the reasons of skb drops to kfree_skb
> tracepoint. And in this series patches, reasons for skb drops are added
> to TCP layer (both TCPv4 and TCPv6 are considered).
> Following functions are processed:
> 
> tcp_v4_rcv()
> tcp_v6_rcv()
> tcp_v4_inbound_md5_hash()
> tcp_v6_inbound_md5_hash()
> tcp_add_backlog()
> tcp_v4_do_rcv()
> tcp_v6_do_rcv()
> tcp_rcv_established()
> tcp_data_queue()
> tcp_data_queue_ofo()
> 
> The functions we handled are mostly for packet ingress, as skb drops
> hardly happens in the egress path of TCP layer. However, it's a little
> complex for TCP state processing, as I find that it's hard to report skb
> drop reasons to where it is freed. For example, when skb is dropped in
> tcp_rcv_state_process(), the reason can be caused by the call of
> tcp_v4_conn_request(), and it's hard to return a drop reason from
> tcp_v4_conn_request(). So such cases are skipped  for this moment.
> 
> Following new drop reasons are introduced (what they mean can be see
> in the document for them):
> 
> /* SKB_DROP_REASON_TCP_MD5* corresponding to LINUX_MIB_TCPMD5* */
> SKB_DROP_REASON_TCP_MD5NOTFOUND
> SKB_DROP_REASON_TCP_MD5UNEXPECTED
> SKB_DROP_REASON_TCP_MD5FAILURE
> SKB_DROP_REASON_SOCKET_BACKLOG
> SKB_DROP_REASON_TCP_FLAGS
> SKB_DROP_REASON_TCP_ZEROWINDOW
> SKB_DROP_REASON_TCP_OLD_DATA
> SKB_DROP_REASON_TCP_OVERWINDOW
> /* corresponding to LINUX_MIB_TCPOFOMERGE */
> SKB_DROP_REASON_TCP_OFOMERGE
> 
> Here is a example to get TCP packet drop reasons from ftrace:
> 
> $ echo 1 > /sys/kernel/debug/tracing/events/skb/kfree_skb/enable
> $ cat /sys/kernel/debug/tracing/trace
> $ <idle>-0       [036] ..s1.   647.428165: kfree_skb: skbaddr=000000004d037db6 protocol=2048 location=0000000074cd1243 reason: NO_SOCKET
> $ <idle>-0       [020] ..s2.   639.676674: kfree_skb: skbaddr=00000000bcbfa42d protocol=2048 location=00000000bfe89d35 reason: PROTO_MEM
> 
> From the reason 'PROTO_MEM' we can know that the skb is dropped because
> the memory configured in net.ipv4.tcp_mem is up to the limition.
> 
> Changes since v1:
> - enrich the document for this series patches in the cover letter,
>   as Eric suggested
> - fix compile warning report by Jakub in the 6th patch
> - let NO_SOCKET trump the XFRM failure in the 2th and 3th patches
> 
> Menglong Dong (9):
>   net: tcp: introduce tcp_drop_reason()
>   net: tcp: add skb drop reasons to tcp_v4_rcv()
>   net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
>   net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
>   net: tcp: add skb drop reasons to tcp_add_backlog()
>   net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
>   net: tcp: use tcp_drop_reason() for tcp_rcv_established()
>   net: tcp: use tcp_drop_reason() for tcp_data_queue()
>   net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
> 
>  include/linux/skbuff.h     | 34 ++++++++++++++++++++++++++++++
>  include/net/tcp.h          |  3 ++-
>  include/trace/events/skb.h | 10 +++++++++
>  net/ipv4/tcp_input.c       | 42 +++++++++++++++++++++++++++++---------
>  net/ipv4/tcp_ipv4.c        | 32 +++++++++++++++++++++--------
>  net/ipv6/tcp_ipv6.c        | 39 +++++++++++++++++++++++++++--------
>  6 files changed, 132 insertions(+), 28 deletions(-)
> 

LGTM. for the set:

Reviewed-by: David Ahern <dsahern@kernel.org>

