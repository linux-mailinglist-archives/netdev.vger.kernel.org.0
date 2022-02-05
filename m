Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF674AA644
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379235AbiBEDel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379234AbiBEDel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:34:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF33C061346
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 19:34:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F23BF60FC3
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 03:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25851C340E8;
        Sat,  5 Feb 2022 03:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644032079;
        bh=EoGKLt9/ajD3EZQB5b1HTmpp+eVhKZTsAsbgBEusvj8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e9bYYOiQrliAJiGM076EVPmZ6XKZ6PScAvCwCCU+v7WcFNdQ3pntLBUIHyqhzMe3Y
         zfjxg2yjf5IXPrSNHrdx412E6PkqCEN4FWMlCYItg1Aeu2GRs0LHfXdw2vUs0kB5MK
         wnY86/eFMTSf65i0ojXnSLZZmEie2ou9twc3Ie0kFnLvXUmGkKvh/he5o0snciq4Ru
         Rucg2FbeqsrJYbRDXJOorDU0JxTTyXbrX8QYVY+D5mhoOYw6I4gxqmAgvAjvJrEHJk
         q6BWqI4kUDGng54AR3S9uA8TCVqdBAMX7MJKYi3hb8ncMND+isXAKvTrg9CRZ+FCDe
         3A1OQHyWtLYMQ==
Date:   Fri, 4 Feb 2022 19:34:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: hsr: use hlist_head instead of
 list_head for mac addresses
Message-ID: <20220204193438.2f800f69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204105902.1421-1-claudiajkang@gmail.com>
References: <20220204105902.1421-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Feb 2022 10:59:02 +0000 Juhee Kang wrote:
> Currently, HSR manages mac addresses of known HSR nodes by using list_head.
> It takes a lot of time when there are a lot of registered nodes due to
> finding specific mac address nodes by using linear search. We can be
> reducing the time by using hlist. Thus, this patch moves list_head to
> hlist_head for mac addresses and this allows for further improvement of
> network performance.
> 
>     Condition: registered 10,000 known HSR nodes
>     Before:
>     # iperf3 -c 192.168.10.1 -i 1 -t 10
>     Connecting to host 192.168.10.1, port 5201
>     [  5] local 192.168.10.2 port 59442 connected to 192.168.10.1 port 5201
>     [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
>     [  5]   0.00-1.49   sec  3.75 MBytes  21.1 Mbits/sec    0    158 KBytes
>     [  5]   1.49-2.05   sec  1.25 MBytes  18.7 Mbits/sec    0    166 KBytes
>     [  5]   2.05-3.06   sec  2.44 MBytes  20.3 Mbits/sec   56   16.9 KBytes
>     [  5]   3.06-4.08   sec  1.43 MBytes  11.7 Mbits/sec   11   38.0 KBytes
>     [  5]   4.08-5.00   sec   951 KBytes  8.49 Mbits/sec    0   56.3 KBytes
> 
>     After:
>     # iperf3 -c 192.168.10.1 -i 1 -t 10
>     Connecting to host 192.168.10.1, port 5201
>     [  5] local 192.168.10.2 port 36460 connected to 192.168.10.1 port 5201
>     [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
>     [  5]   0.00-1.00   sec  7.39 MBytes  62.0 Mbits/sec    3    130 KBytes
>     [  5]   1.00-2.00   sec  5.06 MBytes  42.4 Mbits/sec   16    113 KBytes
>     [  5]   2.00-3.00   sec  8.58 MBytes  72.0 Mbits/sec   42   94.3 KBytes
>     [  5]   3.00-4.00   sec  7.44 MBytes  62.4 Mbits/sec    2    131 KBytes
>     [  5]   4.00-5.07   sec  8.13 MBytes  63.5 Mbits/sec   38   92.9 KBytes
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>

Does not apply to the current net-next tree, please rebase.
