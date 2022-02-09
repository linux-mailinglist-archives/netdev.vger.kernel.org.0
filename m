Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3A94AE808
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245538AbiBIEH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347577AbiBIDxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:53:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD1BC061578;
        Tue,  8 Feb 2022 19:53:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8F44B81E57;
        Wed,  9 Feb 2022 03:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF50C340E7;
        Wed,  9 Feb 2022 03:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644378787;
        bh=Oc+0rxoouhEihO/315hEcvgikG9b9foUt2wGnQjHwD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SDtglcHhO8YlhIwCwa7FN6XJI8bnbLRRDxwVDrZFjlw1M4t9MGJF/DbzqI9GN5N4d
         gJmMOb0gqy+R9rUuW1SI/RgJlvRDhwLjid3bK+UELQJlfHB93lilx4aFEiznQl6kqH
         tFG6voxDp1J/VCfNnzK1jCJfvESDzWMBaU3DM+5rRlanrd3999B8strjUIdlJknTac
         XiVtZpKGpvbjyQD9dAk4Dxm57QgIy5xcVAAqiTgux4mV7u9Q7wjsnYAD5G3JlyYkq4
         BS/tEf6bnkOwxNQ2pJiYYR+klRxftSoDDRjCLb52NVrRTpjrF42ZMVerPmwTvdu9Dg
         0PMjhnH6zeunA==
Date:   Tue, 8 Feb 2022 19:53:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     yajun.deng@linux.dev
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dev: introduce netdev_drop_inc()
Message-ID: <20220208195306.05a1760f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <753bb02bfa8c2cf5c08c63c31f193f90@linux.dev>
References: <20220208162729.41b62ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220208064318.1075849-1-yajun.deng@linux.dev>
        <753bb02bfa8c2cf5c08c63c31f193f90@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 09 Feb 2022 02:20:07 +0000 yajun.deng@linux.dev wrote:
> February 9, 2022 8:27 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:
> 
> > On Tue, 8 Feb 2022 14:43:18 +0800 Yajun Deng wrote:
> >   
> >> We will use 'sudo perf record -g -a -e skb:kfree_skb' command to trace
> >> the dropped packets when dropped increase in the output of ifconfig.
> >> But there are two cases, one is only called kfree_skb(), another is
> >> increasing the dropped and called kfree_skb(). The latter is what
> >> we need. So we need to separate these two cases.
> >> 
> >> From the other side, the dropped packet came from the core network and
> >> the driver, we also need to separate these two cases.
> >> 
> >> Add netdev_drop_inc() and add a tracepoint for the core network dropped
> >> packets. use 'sudo perf record -g -a -e net:netdev_drop' and 'sudo perf
> >> script' will recored the dropped packets by the core network.
> >> 
> >> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>  
> > 
> > Have you seen the work that's being done around kfree_skb_reason()?  
> 
> Yes, I saw it. The focus of kfree_skb_reason() is trace kfree_skb() and the reason, 
> but the focus of this patch only traces this case of the dropped packet.
> 
> I don't want to trace all kfree_skb(), but I just want to trace the dropped packet.
> 
> This command 'sudo perf record -g -a -e skb:kfree_skb' would trace all kfree_skb(),
> kfree_skb() would drowned out the case of dropped packets when the samples were too large.

IIRC perf support filters, I think with -f? We can't add a tracepoint
for every combination of attributes.
