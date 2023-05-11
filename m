Return-Path: <netdev+bounces-1754-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 908756FF0C4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 347CA281549
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979432102;
	Thu, 11 May 2023 11:59:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D55A817
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:59:20 +0000 (UTC)
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86E1420B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 04:59:15 -0700 (PDT)
Received: (Authenticated sender: i.maximets@ovn.org)
	by mail.gandi.net (Postfix) with ESMTPSA id 4AE72240009;
	Thu, 11 May 2023 11:59:13 +0000 (UTC)
Message-ID: <5215f88a-bd31-ccdf-25c9-f06ec602295e@ovn.org>
Date: Thu, 11 May 2023 13:59:32 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To: Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: netdev@vger.kernel.org, i.maximets@ovn.org
References: <20230511093456.672221-1-atenart@kernel.org>
From: Ilya Maximets <i.maximets@ovn.org>
Subject: Re: [PATCH net-next 0/4] net: tcp: make txhash use consistent for
 IPv4
In-Reply-To: <20230511093456.672221-1-atenart@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/11/23 11:34, Antoine Tenart wrote:
> Hello,
> 
> Series is divided in two parts. First two commits make the txhash (used
> for the skb hash in TCP) to be consistent for all IPv4/TCP packets (IPv6
> doesn't have the same issue). Last two commits improve doc/comment
> hash-related parts.
> 
> One example is when using OvS with dp_hash, which uses skb->hash, to
> select a path. We'd like packets from the same flow to be consistent, as
> well as the hash being stable over time when using net.core.txrehash=0.
> Same applies for kernel ECMP which also can use skb->hash.

FWIW, same also applies to seg6_flowlabel that is used for flowlable
based load balancing, because seg6_make_flowlabel() is using skb hash.

Best regards, Ilya Maximets.

> 
> IMHO the series makes sense in net-next, but we could argue (some)
> commits be seen as fixes and I can resend if necessary.
> 
> Thanks!
> Antoine
> 
> Antoine Tenart (4):
>   net: tcp: make the txhash available in TIME_WAIT sockets for IPv4 too
>   net: ipv4: use consistent txhash in TIME_WAIT and SYN_RECV
>   Documentation: net: net.core.txrehash is not specific to listening
>     sockets
>   net: skbuff: fix l4_hash comment
> 
>  Documentation/admin-guide/sysctl/net.rst |  4 ++--
>  include/linux/skbuff.h                   |  4 ++--
>  include/net/ip.h                         |  2 +-
>  net/ipv4/ip_output.c                     |  4 +++-
>  net/ipv4/tcp_ipv4.c                      | 14 +++++++++-----
>  net/ipv4/tcp_minisocks.c                 |  2 +-
>  6 files changed, 18 insertions(+), 12 deletions(-)
> 


