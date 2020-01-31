Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F7614F12F
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgAaRTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:19:34 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:19719 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgAaRTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 12:19:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580491173; x=1612027173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=lX2hQxn14moiobTnuwiF6uoIzzmnrWCBB7fi2DoQlSI=;
  b=sFHFN5ijqTv/w2Dl68hrEbgLuapunmuQ7Igx5QqAQ+XKt9IJaY6kU3FI
   gmwWLkxLmHN6StesddVT0E1lM2s+L42qPH7d1vwNAyYbz1GxdxXwFiiV/
   Grmk8gTOFQ0u0H23VQ7r+LT+vMjZA+DzZaTXs/z8LjyC76fbs6cs6ojvm
   c=;
IronPort-SDR: /mcyIm53pr1n0E/JMKP1LhWTKEQGZxezRbOl+4So93rVLMdMQQgq4i5lRpuOXGhMfcRlhtv91s
 RExgp8VOwccQ==
X-IronPort-AV: E=Sophos;i="5.70,386,1574121600"; 
   d="scan'208";a="23648667"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 31 Jan 2020 17:19:33 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-4e24fd92.us-west-2.amazon.com (Postfix) with ESMTPS id 599A6A217A;
        Fri, 31 Jan 2020 17:19:32 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 17:19:31 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.161.67) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 17:19:28 +0000
From:   <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        SeongJae Park <sjpark@amazon.de>
Subject: Re: [PATCH net] tcp: clear tp->total_retrans in tcp_disconnect()
Date:   Fri, 31 Jan 2020 18:19:14 +0100
Message-ID: <20200131171914.24433-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131171447.102357-1-edumazet@google.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.67]
X-ClientProxiedBy: EX13D30UWC004.ant.amazon.com (10.43.162.4) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 09:14:47 -0800 Eric Dumazet <edumazet@google.com> wrote:

> total_retrans needs to be cleared in tcp_disconnect().
> 
> tcp_disconnect() is rarely used, but it is worth fixing it.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: SeongJae Park <sjpark@amazon.de>
> ---
>  net/ipv4/tcp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 484485ae74c26eb43d49d972e068bcf5d0e33d58..dd57f1e3618160c1e51d6ff54afa984292614e5c 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2626,6 +2626,7 @@ int tcp_disconnect(struct sock *sk, int flags)
>  	tcp_set_ca_state(sk, TCP_CA_Open);
>  	tp->is_sack_reneg = 0;
>  	tcp_clear_retrans(tp);
> +	tp->total_retrans = 0;
>  	inet_csk_delack_init(sk);
>  	/* Initialize rcv_mss to TCP_MIN_MSS to avoid division by 0
>  	 * issue in __tcp_select_window()

Reviewed-by: SeongJae Park <sjpark@amazon.de>

> -- 
> 2.25.0.341.g760bfbb309-goog
