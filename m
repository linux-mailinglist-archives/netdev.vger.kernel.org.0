Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4001662B092
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 02:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiKPBcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 20:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKPBcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 20:32:35 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25424E11;
        Tue, 15 Nov 2022 17:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668562354; x=1700098354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=krUTVhVzrdHdkD1nk+LgEUOCh7gwCMNFY1Zu3pVBBMw=;
  b=kkbxS5CcGr8PsbT6xKDXoYYP7+TURvty4KAjAcNIx6vbRMsUnuBsp/U9
   lJzsCOvXOgvM4ZnidK22/uAIaD5mnKlEADPCaW1Z5KChvlFvhjzeR4RqF
   ua94dM+SrROtS4ZnqT+4Xf7YzAu200b+yC4Lo4XSj3Xl3kQZzGJMTuLTs
   U=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 01:32:32 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-93c3b254.us-east-1.amazon.com (Postfix) with ESMTPS id B4A6CE2B12;
        Wed, 16 Nov 2022 01:32:28 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 16 Nov 2022 01:32:27 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 16 Nov 2022 01:32:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <glex.spb@gmail.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <paul@crapouillou.net>, <yoshfuji@linux-ipv6.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH 1/1] tcp: configurable source port perturb table size
Date:   Tue, 15 Nov 2022 17:32:08 -0800
Message-ID: <20221116013208.29716-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221114225616.16715-1-glex.spb@gmail.com>
References: <20221114225616.16715-1-glex.spb@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D22UWB002.ant.amazon.com (10.43.161.28) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Gleb Mazovetskiy <glex.spb@gmail.com>
Date:   Mon, 14 Nov 2022 22:56:16 +0000
> On embedded systems with little memory and no relevant
> security concerns, it is beneficial to reduce the size
> of the table.
> 
> Reducing the size from 2^16 to 2^8 saves 255 KiB
> of kernel RAM.
> 
> Makes the table size configurable as an expert option.
> 
> The size was previously increased from 2^8 to 2^16
> in commit 4c2c8f03a5ab ("tcp: increase source port perturb table to
> 2^16").
> 
> Signed-off-by: Gleb Mazovetskiy <glex.spb@gmail.com>

Looks good.

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
>  net/ipv4/Kconfig           | 10 ++++++++++
>  net/ipv4/inet_hashtables.c | 10 +++++-----
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
> index e983bb0c5012..2dfb12230f08 100644
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -402,6 +402,16 @@ config INET_IPCOMP
>  
>  	  If unsure, say Y.
>  
> +config INET_TABLE_PERTURB_ORDER
> +	int "INET: Source port perturbation table size (as power of 2)" if EXPERT
> +	default 16
> +	help
> +	  Source port perturbation table size (as power of 2) for
> +	  RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm.
> +
> +	  The default is almost always what you want.
> +	  Only change this if you know what you are doing.
> +
>  config INET_XFRM_TUNNEL
>  	tristate
>  	select INET_TUNNEL
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index d3dc28156622..033bf3c2538f 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -906,13 +906,13 @@ EXPORT_SYMBOL_GPL(inet_bhash2_update_saddr);
>   * Note that we use 32bit integers (vs RFC 'short integers')
>   * because 2^16 is not a multiple of num_ephemeral and this
>   * property might be used by clever attacker.
> + *
>   * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
> - * attacks were since demonstrated, thus we use 65536 instead to really
> - * give more isolation and privacy, at the expense of 256kB of kernel
> - * memory.
> + * attacks were since demonstrated, thus we use 65536 by default instead
> + * to really give more isolation and privacy, at the expense of 256kB
> + * of kernel memory.
>   */
> -#define INET_TABLE_PERTURB_SHIFT 16
> -#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
> +#define INET_TABLE_PERTURB_SIZE (1 << CONFIG_INET_TABLE_PERTURB_ORDER)
>  static u32 *table_perturb;
>  
>  int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> -- 
> 2.37.2
