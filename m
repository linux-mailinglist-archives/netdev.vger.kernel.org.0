Return-Path: <netdev+bounces-4372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F354970C3F7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD77428103A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1368316401;
	Mon, 22 May 2023 17:05:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067BC13AE5
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:05:36 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7DA100;
	Mon, 22 May 2023 10:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684775118; x=1716311118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I/SNaVUdIc0hHy+oBRiw3L0eJufVVtqNYeP7Dn1/JwI=;
  b=d+P0z6zdAwqH52praqjdhvblzM/mKLup/k5YqYZqXA7WIuqlKADruWWM
   KG6Ywny66/t9QKmjki6M/bL8F2j0MPaJgwZ0ME8+j8DhSJet3dxbJqwIt
   uP+srQPibOln6v1Y6qraTWt3h++gIxhD2fPY5sdkfPPi/8hDOSRR9gRT3
   M=;
X-IronPort-AV: E=Sophos;i="6.00,184,1681171200"; 
   d="scan'208";a="327681135"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 17:04:53 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com (Postfix) with ESMTPS id 6452180EAB;
	Mon, 22 May 2023 17:04:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 17:04:41 +0000
Received: from 88665a182662.ant.amazon.com (10.119.123.82) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 17:04:38 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <sj@kernel.org>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <nmanthey@amazon.de>, <pabeni@redhat.com>,
	<ptyadav@amazon.de>, <willemb@google.com>
Subject: Re: [PATCH net] net: fix skb leak in __skb_tstamp_tx()
Date: Mon, 22 May 2023 10:04:30 -0700
Message-ID: <20230522170430.56198-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230522165505.90105-1-sj@kernel.org>
References: <20230522165505.90105-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.123.82]
X-ClientProxiedBy: EX19D033UWC004.ant.amazon.com (10.13.139.225) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: SeongJae Park <sj@kernel.org>
Date: Mon, 22 May 2023 16:55:05 +0000
> Hi Pratyush,
> 
> On Mon, 22 May 2023 17:30:20 +0200 Pratyush Yadav <ptyadav@amazon.de> wrote:
> 
> > Commit 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with
> > TX timestamp.") added a call to skb_orphan_frags_rx() to fix leaks with
> > zerocopy skbs. But it ended up adding a leak of its own. When
> > skb_orphan_frags_rx() fails, the function just returns, leaking the skb
> > it just cloned. Free it before returning.
> > 
> > This bug was discovered and resolved using Coverity Static Analysis
> > Security Testing (SAST) by Synopsys, Inc.
> > 
> > Fixes: 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.")
> 
> Seems the commit has merged in several stable kernels.  Is the bug also
> affecting those?  If so, would it be better to Cc stable@vger.kernel.org?

In netdev, we add 'net' in Subject for bugfix, then netdev maintainers
send a pull request weekly, and stable maintainers backport the fixes to
affected trees.

So we usually need not CC stable for netdev patches.

Thanks,
Kuniyuki

> 
> 
> Thanks,
> SJ
> 
> > Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> > ---
> > 
> > I do not know this code very well, this was caught by our static
> > analysis tool. I did not try specifically reproducing the leak but I did
> > do a boot test by adding this patch on 6.4-rc3 and the kernel boots
> > fine.
> > 
> >  net/core/skbuff.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 515ec5cdc79c..cea28d30abb5 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -5224,8 +5224,10 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
> >  	} else {
> >  		skb = skb_clone(orig_skb, GFP_ATOMIC);
> > 
> > -		if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
> > +		if (skb_orphan_frags_rx(skb, GFP_ATOMIC)) {
> > +			kfree_skb(skb);
> >  			return;
> > +		}
> >  	}
> >  	if (!skb)
> >  		return;
> > --
> > 2.39.2
> > 

