Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F320560FA1
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 05:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiF3DbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 23:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiF3DbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 23:31:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1620F35861;
        Wed, 29 Jun 2022 20:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB844B82564;
        Thu, 30 Jun 2022 03:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14460C34114;
        Thu, 30 Jun 2022 03:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656559879;
        bh=45V2rK/EMKJ5wqO3rGVVD1iD1K4xgsTwAGfgbXYh1UU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vQZiYre0oat4t/NXMmAl37qNgNRWvhEirzu5bcniq07JYOj9pFffUcNkbt3zWyR0v
         LV3QHmY0EWvaQMWT+Zq7kCT28N+8UiIh9MLk+3syP3GBhFlcjnOp+cflojHDkaD1Oi
         l2ujR6k78ipHiyZIlWWF0e9xcZ5jaqMc9DzTrdkuTHvytkEaPJRy6Z3MQKSAnha+Ja
         sRs9j8APppdx0k+NeklOAF0HMmHpmTH5BtddoKuOmUGcXCkgLqbeSCU/vyuZ/xWKrI
         epKoR1fIij3jL1pzs53T98z/h6gz3hxEn4SeuOV0qYmcht92E9CXYBRwLinEK9WH/D
         eNu2Hd8UE9hqQ==
Date:   Wed, 29 Jun 2022 20:31:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        tung.q.nguyen@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: tipc: fix possible infoleak in tipc_mon_rcv()
Message-ID: <20220629203118.7bdcc87f@kernel.org>
In-Reply-To: <20220628083122.26942-1-hbh25y@gmail.com>
References: <20220628083122.26942-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 16:31:22 +0800 Hangyu Hua wrote:
> dom_bef is use to cache current domain record only if current domain
> exists. But when current domain does not exist, dom_bef will still be used
> in mon_identify_lost_members. This may lead to an information leak.

AFAICT applied_bef must be zero if peer->domain was 0, so I don't think
mon_identify_lost_members() will do anything.

> Fix this by adding a memset before using dom_bef.
> 
> Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
