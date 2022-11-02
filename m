Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FBD616D31
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbiKBSwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbiKBSwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:52:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B196CEF;
        Wed,  2 Nov 2022 11:52:20 -0700 (PDT)
Date:   Wed, 2 Nov 2022 19:52:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Lilja <michael.lilja@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
Message-ID: <Y2K8XnFZvZeD4MEg@salvia>
References: <20221023171658.69761-1-michael.lilja@gmail.com>
 <Y1fC5K0EalIYuB7Y@salvia>
 <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
 <Y1fd+DEPZ8xM2x5B@salvia>
 <F754AC3A-D89A-4CF7-97AE-CA59B18A758E@gmail.com>
 <Y1kQ9FhrwxCKIdoe@salvia>
 <25246B91-B5BE-43CA-9D98-67950F17F0A1@gmail.com>
 <03E5D5FA-5A0D-4E5A-BA32-3FE51764C02E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <03E5D5FA-5A0D-4E5A-BA32-3FE51764C02E@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 09:40:11PM +0200, Michael Lilja wrote:
> Hi,
> 
> I just quickly tried following the flow_offload_teardown() path instead of clearing IPS_OFFLOAD in flow_offload_del() and it does have some side effects. The flow is added again before the HW has actually reported it to be NF_FLOW_HW_DEAD. 
> 
> The sequence with my patch is:
>   : Retire -> Remove from hw tables -> Remove from sw tables -> kfree(flow) -> flow_offload_add()
> 
> But if flow_offload_teardown() is called on expire I see:
>   : Retire -> Remove from hw tables -> flow_offload_add() -> Remove from sw tables -> kfree(flow)
>  
> I need to investigate why this happens, maybe the IPS_OFFLOAD flag is cleared too early and should not be cleared until the flow is actually removed, like I do? Maybe the issue is not seen before because on timeout or flow_is_dying() no packet arrive to create the flow again prematurely?

Hm, IPS_OFFLOAD should be cleared from flow_offload_del() then, it is
cleared too early.

I'll post a fix for nf.git first then I propose to follow up on this
flowtable feature. I'll keep you on Cc.
