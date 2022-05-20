Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E52452F0CA
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351847AbiETQet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351762AbiETQeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:34:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682EF18542C
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 09:34:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBDBB61D44
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCBCC34100;
        Fri, 20 May 2022 16:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653064467;
        bh=3x68Hp85JyGEbNuZ/ykGM4mtkSsncwfrqQZuYQFENYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eoeYkDRlUuMF74GBz5i8vG0afMVQL5kt+gKuuWggPzV9gMYKbVi+fThXaAwW7LAzb
         UlGIvJh+VZ44chMtjcVusSwHoL5wtWuThsxCEvjGGzWatw5yKoiXl5A9eohCxUPyer
         yRFCrHHru9kHvagWukVLy5MNpuZXlzUQrNiJfAEwM48lR+845cYut3EasYFGIBBzL3
         /O2tSt7LERORWvhu/eHsQHYOij6sphkOAYuKW1jyX/ySGOcN9kPkT1Leyf7iWM1Vj+
         jiYcVNi8kdKTfLuFAai3BhQMNe+roFrhuog85s9gAObLe58nZIYLDvDAjjcEdvgHj2
         SofKTLFBPkp1w==
Date:   Fri, 20 May 2022 09:34:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        flyingpeng@tencent.com, imagedong@tencent.com,
        benbjiang@tencent.com
Subject: Re: [PATCH net-next] tcp_ipv6: set the drop_reason in the right
 place
Message-ID: <20220520093425.0489d6d9@kernel.org>
In-Reply-To: <4deccb83-79c4-5276-3183-d6e6ffa3ec53@tessares.net>
References: <20220520021347.2270207-1-kuba@kernel.org>
        <4deccb83-79c4-5276-3183-d6e6ffa3ec53@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 18:22:22 +0200 Matthieu Baerts wrote:
> On 20/05/2022 04:13, Jakub Kicinski wrote:
> > Looks like the IPv6 version of the patch under Fixes was
> > a copy/paste of the IPv4 but hit the wrong spot.
> > It is tcp_v6_rcv() which uses drop_reason as a boolean, and
> > needs to be protected against reason == 0 before calling free.
> > tcp_v6_do_rcv() has a pretty straightforward flow.  
> 
> Thank you for the patch!
> 
> It looks like this fixes an issue our MPTCP CI detected recently:
> 
> https://github.com/multipath-tcp/mptcp_net-next/issues/277
> 
> 
> Just in case someone else had this issue on their side, here is the call
> trace we had:

Ack, I got the same trace. Let me add the trace to the commit msg and
fast-path merging this fix so more people don't hit the stack trace.
