Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2AE38A03B
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 10:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhETIwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 04:52:54 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61312 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhETIwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 04:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621500692; x=1653036692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M9gfNngD0bJlkjc4rg47T5qwp5ZouzRsDXymH0+hpU4=;
  b=k9gLUJvkoCGDkXYZBQI4jItmLeYZRw/OfpkxPoTONT17UBv0lBk4VcEF
   KNgD5BwqFXzanVwQV8SSJBioGNXejHMlnzhA3kfZcXfq7JzVXkYD5CIyW
   1fh1MntN4z147aeDIZsQje2h9cJaNo+C8dFYEFHtUFQWp5hMqCaCrlK+h
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="110462845"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 20 May 2021 08:51:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 46E99A1B79;
        Thu, 20 May 2021 08:51:28 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 20 May 2021 08:51:26 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.200) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 20 May 2021 08:51:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the reuseport group.
Date:   Thu, 20 May 2021 17:51:17 +0900
Message-ID: <20210520085117.48629-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210520062648.ejqufb6m5wr6z7k2@kafai-mbp.dhcp.thefacebook.com>
References: <20210520062648.ejqufb6m5wr6z7k2@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.200]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 19 May 2021 23:26:48 -0700
> On Mon, May 17, 2021 at 09:22:50AM +0900, Kuniyuki Iwashima wrote:
> 
> > +static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> > +			       struct sock_reuseport *reuse, bool bind_inany)
> > +{
> > +	if (old_reuse == reuse) {
> > +		/* If sk was in the same reuseport group, just pop sk out of
> > +		 * the closed section and push sk into the listening section.
> > +		 */
> > +		__reuseport_detach_closed_sock(sk, old_reuse);
> > +		__reuseport_add_sock(sk, old_reuse);
> > +		return 0;
> > +	}
> > +
> > +	if (!reuse) {
> > +		/* In bind()/listen() path, we cannot carry over the eBPF prog
> > +		 * for the shutdown()ed socket. In setsockopt() path, we should
> > +		 * not change the eBPF prog of listening sockets by attaching a
> > +		 * prog to the shutdown()ed socket. Thus, we will allocate a new
> > +		 * reuseport group and detach sk from the old group.
> > +		 */
> For the reuseport_attach_prog() path, I think it needs to consider
> the reuse->num_closed_socks != 0 case also and that should belong
> to the resurrect case.  For example, when
> sk_unhashed(sk) but sk->sk_reuseport == 0.

In the path, reuseport_resurrect() is called from reuseport_alloc() only
if reuse->num_closed_socks != 0.


> @@ -92,6 +117,14 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
>  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
>  					  lockdep_is_held(&reuseport_lock));
>  	if (reuse) {
> +		if (reuse->num_closed_socks) {

But, should this be

	if (sk->sk_state == TCP_CLOSE && reuse->num_closed_socks)

because we need not allocate a new group when we attach a bpf prog to
listeners?


> +			/* sk was shutdown()ed before */
> +			int err = reuseport_resurrect(sk, reuse, NULL, bind_inany);
> +
> +			spin_unlock_bh(&reuseport_lock);
> +			return err;
> +		}
> +
>  		/* Only set reuse->bind_inany if the bind_inany is true.
>  		 * Otherwise, it will overwrite the reuse->bind_inany
>  		 * which was set by the bind/hash path.
