Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D3C3815B7
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 06:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhEOEWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 00:22:22 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20507 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhEOEWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 00:22:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621052469; x=1652588469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PTkPak1XHe87ydZUwsitoS7ANVA6oSXKJMketGrsuDo=;
  b=IGP8VmyLZkKxTXl1/Q79GTkd1uP3mkJ8hG+FrtLdSivY9HJmivA3cF/j
   BSC+n1PmBniFqWewlTgi0bHgQIHg7uutR0DSu9dWwmjLU1Av3B4dul0YQ
   dfYOwCBOtoGSd+xFMizG8SMw+NP6UDTWuj6OWZ+gnaV9l+SUjr8hLNhJq
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,300,1613433600"; 
   d="scan'208";a="109443918"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 15 May 2021 04:21:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 0905CA22F7;
        Sat, 15 May 2021 04:21:04 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:21:04 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.63) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:20:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 08/11] bpf: Support BPF_FUNC_get_socket_cookie() for BPF_PROG_TYPE_SK_REUSEPORT.
Date:   Sat, 15 May 2021 13:20:56 +0900
Message-ID: <20210515042056.81877-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210515011655.q5v7nnbonvo3a7wg@kafai-mbp>
References: <20210515011655.q5v7nnbonvo3a7wg@kafai-mbp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.63]
X-ClientProxiedBy: EX13D07UWB002.ant.amazon.com (10.43.161.131) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 14 May 2021 18:16:55 -0700
> On Mon, May 10, 2021 at 12:44:30PM +0900, Kuniyuki Iwashima wrote:
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index cae56d08a670..3d0f989f5d38 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -10135,6 +10135,8 @@ sk_reuseport_func_proto(enum bpf_func_id func_id,
> >  		return &sk_reuseport_load_bytes_proto;
> >  	case BPF_FUNC_skb_load_bytes_relative:
> >  		return &sk_reuseport_load_bytes_relative_proto;
> > +	case BPF_FUNC_get_socket_cookie:
> > +		return &bpf_get_socket_ptr_cookie_proto;
> >  	default:
> >  		return bpf_base_func_proto(func_id);
> >  	}
> > @@ -10164,6 +10166,10 @@ sk_reuseport_is_valid_access(int off, int size,
> >  	case offsetof(struct sk_reuseport_md, hash):
> >  		return size == size_default;
> >  
> > +	case offsetof(struct sk_reuseport_md, sk):
> > +		info->reg_type = ARG_PTR_TO_SOCKET;
> s/ARG_PTR_TO_SOCKET/PTR_TO_SOCKET/

I'll fix it.
Thank you.


> 
> > +		return size == sizeof(__u64);
> > +
> >  	/* Fields that allow narrowing */
> >  	case bpf_ctx_range(struct sk_reuseport_md, eth_protocol):
> >  		if (size < sizeof_field(struct sk_buff, protocol))
