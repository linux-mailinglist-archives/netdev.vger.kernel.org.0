Return-Path: <netdev+bounces-4371-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24AC470C3F4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 718C4280BFC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D18A11548B;
	Mon, 22 May 2023 17:04:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C691279D2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:04:32 +0000 (UTC)
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BB210C4;
	Mon, 22 May 2023 10:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1684775051; x=1716311051;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=FkZjmny3A+Qtr0Bo9FMNjP8dRKN2KNqVdFZad59YTLc=;
  b=k0il5zKu5MdKM1FSaIjd5Lce66bkPdPR+n47AOqVEa5QfUZDgrdmiIAs
   /3rtZWQKRUnHA2L8c9Sf8Yq7tY+NEG/rx8UvL43bVnSgvNzSXkLw8MI6h
   Qxpf0gl3gc9SoSkZwLLcNoHfSuPG9kvpL+7w4rwe9Kg1W1y1yMIM8u6VS
   c=;
X-IronPort-AV: E=Sophos;i="6.00,184,1681171200"; 
   d="scan'208";a="1132821963"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 17:04:02 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com (Postfix) with ESMTPS id 17E05A08BA;
	Mon, 22 May 2023 17:04:02 +0000 (UTC)
Received: from EX19D004ANC004.ant.amazon.com (10.37.240.211) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 17:04:01 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D004ANC004.ant.amazon.com (10.37.240.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 22 May 2023 17:04:00 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 22 May 2023 17:03:59 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
	id 6D9CD20C6F; Mon, 22 May 2023 19:03:59 +0200 (CEST)
From: Pratyush Yadav <ptyadav@amazon.de>
To: SeongJae Park <sj@kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, "Willem de
 Bruijn" <willemb@google.com>, Norbert Manthey <nmanthey@amazon.de>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH net] net: fix skb leak in __skb_tstamp_tx()
References: <20230522165505.90105-1-sj@kernel.org>
Date: Mon, 22 May 2023 19:03:59 +0200
In-Reply-To: <20230522165505.90105-1-sj@kernel.org> (SeongJae Park's message
	of "Mon, 22 May 2023 16:55:05 +0000")
Message-ID: <mafs0cz2sxpq8.fsf@amazon.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: Bulk
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22 2023, SeongJae Park wrote:

> Hi Pratyush,
>
> On Mon, 22 May 2023 17:30:20 +0200 Pratyush Yadav <ptyadav@amazon.de> wrote:
>
>> Commit 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with
>> TX timestamp.") added a call to skb_orphan_frags_rx() to fix leaks with
>> zerocopy skbs. But it ended up adding a leak of its own. When
>> skb_orphan_frags_rx() fails, the function just returns, leaking the skb
>> it just cloned. Free it before returning.
>>
>> This bug was discovered and resolved using Coverity Static Analysis
>> Security Testing (SAST) by Synopsys, Inc.
>>
>> Fixes: 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.")
>
> Seems the commit has merged in several stable kernels.  Is the bug also
> affecting those?  If so, would it be better to Cc stable@vger.kernel.org?
>

It affects v5.4.243 at least, since that is where I first saw this. But
I would expect it to affect other stable kernels it has been backported
to as well. I thought using the Fixes tag pointing to the bad upstream
commit would be enough for the stable maintainers' tooling/bots to pick
this patch up.

In either case, +Cc stable. Link to the patch this thread is talking
about [0].

[0] https://lore.kernel.org/netdev/20230522153020.32422-1-ptyadav@amazon.de/T/#u

>
>
> Thanks,
> SJ
>
>> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>> ---
>>
>> I do not know this code very well, this was caught by our static
>> analysis tool. I did not try specifically reproducing the leak but I did
>> do a boot test by adding this patch on 6.4-rc3 and the kernel boots
>> fine.
>>
>>  net/core/skbuff.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 515ec5cdc79c..cea28d30abb5 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -5224,8 +5224,10 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>>       } else {
>>               skb = skb_clone(orig_skb, GFP_ATOMIC);
>>
>> -             if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
>> +             if (skb_orphan_frags_rx(skb, GFP_ATOMIC)) {
>> +                     kfree_skb(skb);
>>                       return;
>> +             }
>>       }
>>       if (!skb)
>>               return;
>> --
>> 2.39.2
>>

-- 
Regards,
Pratyush Yadav



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




