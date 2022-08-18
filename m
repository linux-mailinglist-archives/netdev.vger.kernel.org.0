Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432EA5988A9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344708AbiHRQUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344744AbiHRQUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:20:03 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B854C4830
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660839473; x=1692375473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=insXfA48zkd4uPDOlsQY6mlt4B99ycMH2LWYsaWpsKI=;
  b=ULU+DYbvnfnAtAJLo6Y8JkLZ3/12j/UnSUj2JIZzlI7tqwVRYS5tLP2U
   Dst4wDrFpVrvjBUnNEPd5YHTwKxRtWPfB1vzP2/L2IUaCENKlcCU+G/Ve
   /U0/wEa0c6631RgFHBGhYsmEwQDnWG5yP2ly5p0CSNHCy2InXYJLwNHpv
   E=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="120687262"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 16:17:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id A2EFC81580;
        Thu, 18 Aug 2022 16:17:14 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 16:17:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.201) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 16:17:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuniyu@amazon.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v2 net 13/17] net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
Date:   Thu, 18 Aug 2022 09:17:04 -0700
Message-ID: <20220818161704.32634-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818035227.81567-14-kuniyu@amazon.com>
References: <20220818035227.81567-14-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.201]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.com>
Date:   Wed, 17 Aug 2022 20:52:23 -0700
> While reading sysctl_fb_tunnels_only_for_init_net, it can be changed
> concurrently.  Thus, we need to add READ_ONCE() to its readers.
> 
> Fixes: 79134e6ce2c9 ("net: do not create fallback tunnels for non-default namespaces")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/linux/netdevice.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 1a3cb93c3dcc..89a9545d90db 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -640,9 +640,11 @@ extern int sysctl_devconf_inherit_init_net;
>   */
>  static inline bool net_has_fallback_tunnels(const struct net *net)
>  {
> +	int fb_tunnels_only_for_init_net = READ_ONCE(sysctl_fb_tunnels_only_for_init_net);
> +

This should be in the #if IS_ENABLED(CONFIG_SYSCTL) block...my bad.
I'll fix this in v3.


>  	return !IS_ENABLED(CONFIG_SYSCTL) ||
> -	       !sysctl_fb_tunnels_only_for_init_net ||
> -	       (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1);
> +	       !fb_tunnels_only_for_init_net ||
> +	       (net == &init_net && fb_tunnels_only_for_init_net == 1);
>  }
>  
>  static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
> -- 
> 2.30.2

