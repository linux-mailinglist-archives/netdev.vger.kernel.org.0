Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1286DA389
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240229AbjDFUkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 16:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240721AbjDFUkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 16:40:32 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBE69767;
        Thu,  6 Apr 2023 13:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680813396; x=1712349396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=glRId3TCjvVwkSyTTe1OVXVyxecEefJVI+EkBN/jPxc=;
  b=D3d/72cr7XzDezJrhwct98a/FY/gL2KCZOGFUDIZumVI1kPS0ueN/CPZ
   gmegO0blWZUGGS5DiR68LrVrQbmw7n/c6iZyj2UbuGOlKZeitgt26y3yV
   s8OcKCxxckFJFOiDU9TCLDxiuF5pMn7r6lEV37fKHZtgPLKQ0q7+TesbC
   8=;
X-IronPort-AV: E=Sophos;i="5.98,323,1673913600"; 
   d="scan'208";a="311400107"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 20:36:33 +0000
Received: from EX19MTAUWA002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id 6F94EC18F0;
        Thu,  6 Apr 2023 20:36:30 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 6 Apr 2023 20:36:29 +0000
Received: from 88665a182662.ant.amazon.com (10.119.181.3) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 6 Apr 2023 20:36:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <yuehaibing@huawei.com>
CC:     <corbet@lwn.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net] tcp: restrict net.ipv4.tcp_app_win
Date:   Thu, 6 Apr 2023 13:36:15 -0700
Message-ID: <20230406203615.43591-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230406063450.19572-1-yuehaibing@huawei.com>
References: <20230406063450.19572-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.181.3]
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   YueHaibing <yuehaibing@huawei.com>
Date:   Thu, 6 Apr 2023 14:34:50 +0800
> UBSAN: shift-out-of-bounds in net/ipv4/tcp_input.c:555:23
> shift exponent 255 is too large for 32-bit type 'int'
> CPU: 1 PID: 7907 Comm: ssh Not tainted 6.3.0-rc4-00161-g62bad54b26db-dirty #206
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x136/0x150
>  __ubsan_handle_shift_out_of_bounds+0x21f/0x5a0
>  tcp_init_transfer.cold+0x3a/0xb9
>  tcp_finish_connect+0x1d0/0x620
>  tcp_rcv_state_process+0xd78/0x4d60
>  tcp_v4_do_rcv+0x33d/0x9d0
>  __release_sock+0x133/0x3b0
>  release_sock+0x58/0x1b0
> 
> 'maxwin' is int, shifting int for 32 or more bits is undefined behaviour.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks!

> ---
>  Documentation/networking/ip-sysctl.rst | 2 ++
>  net/ipv4/sysctl_net_ipv4.c             | 3 +++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 87dd1c5283e6..58a78a316697 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -340,6 +340,8 @@ tcp_app_win - INTEGER
>  	Reserve max(window/2^tcp_app_win, mss) of window for application
>  	buffer. Value 0 is special, it means that nothing is reserved.
>  
> +	Possible values are [0, 31], inclusive.
> +
>  	Default: 31
>  
>  tcp_autocorking - BOOLEAN
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 0d0cc4ef2b85..40fe70fc2015 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -25,6 +25,7 @@ static int ip_local_port_range_min[] = { 1, 1 };
>  static int ip_local_port_range_max[] = { 65535, 65535 };
>  static int tcp_adv_win_scale_min = -31;
>  static int tcp_adv_win_scale_max = 31;
> +static int tcp_app_win_max = 31;
>  static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
>  static int tcp_min_snd_mss_max = 65535;
>  static int ip_privileged_port_min;
> @@ -1198,6 +1199,8 @@ static struct ctl_table ipv4_net_table[] = {
>  		.maxlen		= sizeof(u8),
>  		.mode		= 0644,
>  		.proc_handler	= proc_dou8vec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= &tcp_app_win_max,
>  	},
>  	{
>  		.procname	= "tcp_adv_win_scale",
> -- 
> 2.34.1
