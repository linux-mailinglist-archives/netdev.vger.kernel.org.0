Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E042B9D74
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgKSWKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:10:52 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:42599 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgKSWKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:10:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605823850; x=1637359850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=KakZVEyQaYj6Wtym9hbgZZFBg0Ru32Ep8T3605AucoY=;
  b=Wh2XjkHsHKxTM5jzH3Kh3dTGVG1bLAR7D6IBUDJrfg81GdgVLxUTZxsn
   E2rY/bh5d+kKSG98vYXbCk8eXH+Ts2DYhSkMI2+sebP2m3vedLJEV+hmL
   AMhrl2Eog1qiS+qkqh1YGGpbKM+kXPamnijK0NpDp2lZ3GIRS3Oi3SEY8
   o=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="97174361"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 19 Nov 2020 22:10:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 2BC1EBEB14;
        Thu, 19 Nov 2020 22:10:47 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:10:47 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.144) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 22:10:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 6/8] bpf: Add cookie in sk_reuseport_md.
Date:   Fri, 20 Nov 2020 07:10:39 +0900
Message-ID: <20201119221039.77142-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201119001154.kapwihc2plp4f7zc@kafai-mbp.dhcp.thefacebook.com>
References: <20201119001154.kapwihc2plp4f7zc@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D14UWC004.ant.amazon.com (10.43.162.99) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Wed, 18 Nov 2020 16:11:54 -0800
> On Tue, Nov 17, 2020 at 06:40:21PM +0900, Kuniyuki Iwashima wrote:
> > We will call sock_reuseport.prog for socket migration in the next commit,
> > so the eBPF program has to know which listener is closing in order to
> > select the new listener.
> > 
> > Currently, we can get a unique ID for each listener in the userspace by
> > calling bpf_map_lookup_elem() for BPF_MAP_TYPE_REUSEPORT_SOCKARRAY map.
> > This patch exposes the ID to the eBPF program.
> > 
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  include/linux/bpf.h            | 1 +
> >  include/uapi/linux/bpf.h       | 1 +
> >  net/core/filter.c              | 8 ++++++++
> >  tools/include/uapi/linux/bpf.h | 1 +
> >  4 files changed, 11 insertions(+)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 581b2a2e78eb..c0646eceffa2 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1897,6 +1897,7 @@ struct sk_reuseport_kern {
> >  	u32 hash;
> >  	u32 reuseport_id;
> >  	bool bind_inany;
> > +	u64 cookie;
> >  };
> >  bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
> >  				  struct bpf_insn_access_aux *info);
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 162999b12790..3fcddb032838 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4403,6 +4403,7 @@ struct sk_reuseport_md {
> >  	__u32 ip_protocol;	/* IP protocol. e.g. IPPROTO_TCP, IPPROTO_UDP */
> >  	__u32 bind_inany;	/* Is sock bound to an INANY address? */
> >  	__u32 hash;		/* A hash of the packet 4 tuples */
> > +	__u64 cookie;		/* ID of the listener in map */
> Instead of only adding the cookie of a sk, lets make the sk pointer available:
> 
> 	__bpf_md_ptr(struct bpf_sock *, sk);
> 
> and then use the BPF_FUNC_get_socket_cookie to get the cookie.
> 
> Other fields of the sk can also be directly accessed too once
> the sk pointer is available.

Oh, I did not know BPF_FUNC_get_socket_cookie.
I will add the sk pointer and use the helper function in the next spin!
Thank you.
