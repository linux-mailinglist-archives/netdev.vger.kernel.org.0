Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4F9648EBF
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiLJM7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 07:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLJM7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 07:59:43 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A81210B6E
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 04:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1670677181; x=1702213181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2RaANevEHe33/Lb9Q3L4J/alP20UlJyK+rus+iX268c=;
  b=Bye3Tw5qhGUAi6wSdhWbtcbO+0Ld1PmkW3kU9/8kn4VVNogL4jxXQhn6
   EbZwF59/Gk5Nw/KojbbT+/c8Nhzyuk4ne7YqRDdthGGZuS3zqb1AQOROw
   BU67SCQwRK5i2k7fiiSdcezf8UV2NZIlxnaMtoQpMns2qIPnvFliwUA7K
   o=;
X-IronPort-AV: E=Sophos;i="5.96,234,1665446400"; 
   d="scan'208";a="160008614"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 12:59:39 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-dc7c3f8b.us-west-2.amazon.com (Postfix) with ESMTPS id A2E2CA29F2;
        Sat, 10 Dec 2022 12:59:38 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 10 Dec 2022 12:59:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sat, 10 Dec 2022 12:59:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <yangyingliang@huawei.com>
CC:     <andrii@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <jakub@cloudflare.com>, <jiang.wang@bytedance.com>,
        <john.fastabend@gmail.com>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [PATCH net] af_unix: call proto_unregister() in the error path in af_unix_init()
Date:   Sat, 10 Dec 2022 21:59:23 +0900
Message-ID: <20221210125923.47456-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221208150158.2396166-1-yangyingliang@huawei.com>
References: <20221208150158.2396166-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D43UWA003.ant.amazon.com (10.43.160.9) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Yang Yingliang <yangyingliang@huawei.com>
Date:   Thu, 8 Dec 2022 23:01:58 +0800
> If register unix_stream_proto returns error, unix_dgram_proto needs
> be unregistered.
> 
> Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks for the patch.

It's rare though, sock_register() and register_pernet_subsys() also could
fail, and it will need another Fixes tag, so I'll send a follow-up patch
after this is merged.


> ---
>  net/unix/af_unix.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index b3545fc68097..ede2b2a140a4 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -3738,6 +3738,7 @@ static int __init af_unix_init(void)
>  	rc = proto_register(&unix_stream_proto, 1);
>  	if (rc != 0) {
>  		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
> +		proto_unregister(&unix_dgram_proto);
>  		goto out;
>  	}
>  
> -- 
> 2.25.1
