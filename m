Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EEA2A8997
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 23:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgKEWQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 17:16:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbgKEWQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 17:16:07 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1109E20735;
        Thu,  5 Nov 2020 22:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604614566;
        bh=imUVBYp5M4wmbLeT+9vciE49oS3Kkp42AlSUoxHmZhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VaJUVC2N2nUyV5925zEvK9jTWTGCpvlU1B0Vi/qCSuzJGlipDyRr1nXj11CqWWtea
         JsgkIA+VtMpZOSrKLvXhYoqKYBo3fEBkGTnxvv8tNQ5Rck4+1n6x4tLjCOt5xIemWJ
         rK25gTTc+/T3jYUPZV4eOobiMOQQh2EaSzL8ndDM=
Date:   Thu, 5 Nov 2020 14:16:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, davem@davemloft.net,
        ycheng@google.com, ncardwell@google.com, priyarjha@google.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH net-next] net: udp: introduce UDP_MIB_MEMERRORS for
 udp_mem
Message-ID: <20201105141605.06b936f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604560572-18582-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604560572-18582-1-git-send-email-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Nov 2020 02:16:11 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> When udp_memory_allocated is at the limit, __udp_enqueue_schedule_skb
> will return a -ENOBUFS, and skb will be dropped in __udp_queue_rcv_skb
> without any counters being done. It's hard to find out what happened
> once this happen.
> 
> So we introduce a UDP_MIB_MEMERRORS to do this job. Well, this change
> looks friendly to the existing users, such as netstat:
> 
> $ netstat -u -s
> Udp:
>     0 packets received
>     639 packets to unknown port received.
>     158689 packet receive errors
>     180022 packets sent
>     RcvbufErrors: 20930
>     MemErrors: 137759
> UdpLite:
> IpExt:
>     InOctets: 257426235
>     OutOctets: 257460598
>     InNoECTPkts: 181177
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Please CC Paolo since he have you feedback on v1 and Willem de Bruijn
<willemb@google.com>.

> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 09f0a23d1a01..aa1bd53dd9f9 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2038,6 +2038,9 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  		if (rc == -ENOMEM)
>  			UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS,
>  					is_udplite);
> +		else
> +			UDP_INC_STATS(sock_net(sk), UDP_MIB_MEMERRORS,
> +					is_udplite);

The alignment of the line above is off, just ignore it and align the
new code correctly so that checkpatch does not complain.
