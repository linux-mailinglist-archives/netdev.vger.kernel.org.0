Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D27E6E5063
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjDQSrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjDQSrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:47:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704182116
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 11:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7F7B6113D
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 18:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1C4C433EF;
        Mon, 17 Apr 2023 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681757232;
        bh=0dq523vYqK8ilah2x0GDYVTqqLzwbggHvWf64YQHH1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rK51A+6cqLTwqVMhkdouOfxS3/yW4RKQtfPzNdxXWmgOBoEnHva77GlygbQFJx0R1
         W6/210fY7RibA1m/EYEq6/DXAmkPsk2T6qMFt3NSuXFwEgip/eTgdNLVQOE99+Lbqr
         7geqY42o49Jjcs7Q3jRbcPg5gnY3t2TsWa/8wOa1hUYrhjT8Gu0zITBuMnIJ9xXH+T
         QkPSHSBjcV7T4L4jznKUStFmdnEwnn+zKKQmaKdg+fNKwY6E6pSv+F2mXvCGuybnTH
         Bn51KZ7DbjfUhYfpfRwku4o1kYatCuUeWDxQgazFsHHIAXSBLqZoSUg2DhYI/LuRhn
         b5OUqyZwKpZ9w==
Date:   Mon, 17 Apr 2023 11:47:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv4 net-next] bonding: add software tx timestamping
 support
Message-ID: <20230417114710.57ae73ea@kernel.org>
In-Reply-To: <ZDyQIwhC6Bu05VLf@Laptop-X1>
References: <20230414083526.1984362-1-liuhangbin@gmail.com>
        <20230414180205.1220135d@kernel.org>
        <6105.1681530194@famine>
        <ZDyQIwhC6Bu05VLf@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 08:17:39 +0800 Hangbin Liu wrote:
> I remember why I use bond_for_each_slave_rcu() here now. In commit
> 9b80ccda233f ("bonding: fix missed rcu protection"), I added the
> rcu_read_lock() as syzbot reported[1] the following path doesn't hold
> rtnl lock.
> - sock_setsockopt
>   - sock_set_timestamping
>     - sock_timestamping_bind_phc
>       - ethtool_get_phc_vclocks
>         - __ethtool_get_ts_info
> 	  - bond_ethtool_get_ts_info

Well spotted, okay :(
Could you respin with this info added to the commit message and an
update to the kdoc in include/linux/ethtool.h for @get_ts_info
that it may be called with RCU, or rtnl or reference on the device?
