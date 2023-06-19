Return-Path: <netdev+bounces-12029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2CF735BD9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B98B1C209D3
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293AE134C6;
	Mon, 19 Jun 2023 16:03:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D18612B72
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 16:03:12 +0000 (UTC)
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1D51A6
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1687190591; x=1718726591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uuv9pszhTynOhTRCojhmYbmGAvr1NbL+ux+UABNr6LA=;
  b=e6GNu5+UNCpr1+liSQ43hLYMqyh/HY3FIJc6GHFxI/7StF8gK32WZZPc
   crci6BoU52jHCTL7qy/fBKkns+J62fPB+MtXm8EdCUGKxzygvJQ9xxsSU
   JiIQRK+bhWsdplFj2/PgBp/T8yQFF2r9Rui6zlR9vkNrR2XlGyacioDx2
   w=;
X-IronPort-AV: E=Sophos;i="6.00,255,1681171200"; 
   d="scan'208";a="137826514"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 16:03:08 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id DDF7F60B09;
	Mon, 19 Jun 2023 16:03:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 19 Jun 2023 16:03:06 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.47) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 19 Jun 2023 16:03:03 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <kuba@kernel.org>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuni1840@gmail.com>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>
Subject: Re: [PATCH v1 net-next 1/5] ipv6: rpl: Remove pskb(_may)?_pull() in ipv6_rpl_srh_rcv().
Date: Mon, 19 Jun 2023 09:02:54 -0700
Message-ID: <20230619160254.33579-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230617010014.00f34757@kernel.org>
References: <20230617010014.00f34757@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.47]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jakub Kicinski <kuba@kernel.org>
Date: Sat, 17 Jun 2023 01:00:14 -0700
> On Wed, 14 Jun 2023 16:01:03 -0700 Kuniyuki Iwashima wrote:
> > -	if (!pskb_may_pull(skb, ipv6_rpl_srh_size(n, hdr->cmpri,
> > -						  hdr->cmpre))) {
> 
> Are we checking that 
> 
> 	ipv6_rpl_srh_size(n, hdr->cmpri, hdr->cmpre) < (hdrlen + 1) << 3
> 
> somewhere?

sizeof(struct ipv6_rpl_sr_hdr) is (1 << 3), and n is calculated from
hdrlen, cmpri, cmpre, and pad.

Here n could underflow, but the irregular case is caught by the two
conditionals below, where segments_left >= 1.

  1) n <  U64_MAX -> n + 1 > 255
  2) n == U64_MAX -> n + 1 == 0 < segments_left

So, the formula below holds.

  n1 = (hdr->hdrlen << 3) - hdr->pad - (16 - hdr->cmpre)
  n2 = n1 / (16 - hdr->cmpri)

  n2 * (16 - hdr->cmpri) + hdr->pad + (16 - hdr->cmpre) = hdr->hdrlen << 3
  (Here pad could be equal or greater than 0)

  n2 * (16 - hdr->cmpri) + (16 - hdr->cmpre) <= hdr->hdrlen << 3

  ipv6_rpl_srh_size(n, hdr->cmpri, hdr->cmpre) <= (hdrlen + 1) << 3

---8<---
	n = (hdr->hdrlen << 3) - hdr->pad - (16 - hdr->cmpre);
	r = do_div(n, (16 - hdr->cmpri));
	/* checks if calculation was without remainder and n fits into
	 * unsigned char which is segments_left field. Should not be
	 * higher than that.
	 */
	if (r || (n + 1) > 255) {
		kfree_skb(skb);
		return -1;
	}

	if (hdr->segments_left > n + 1) {
...
		return -1;
	}

	hdr->segments_left--;
	i = n - hdr->segments_left;
---8<---


> 
> also nit:
> 
> > As Eric Dumazet pointed out [0], ipv6_rthdr_rcv() pulls these data
> > 
> >   - Segment Routing Header : 8
> >   - Hdr Ext Len            : skb_transport_header(skb)[1] << 3
> 
> +1 missing here, AFAICT

The +1 here is the 8 bytes header.  Hdr Ext Len does not include
the header length.

In ipv6_rthdr_rcv(), the first pskb_may_pull() expresses it as 8,
and 2nd one uses (1 << 3).  We cannot use sizeof() here because
each Ext Hdr has different struct, although all of them are 8 bytes.

---8<---
	if (!pskb_may_pull(skb, skb_transport_offset(skb) + 8) ||
	    !pskb_may_pull(skb, (skb_transport_offset(skb) +
				 ((skb_transport_header(skb)[1] + 1) << 3)))) {
		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
		kfree_skb(skb);
		return -1;
	}
---8<---

Thanks!

