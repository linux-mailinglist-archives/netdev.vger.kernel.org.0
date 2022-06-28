Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C8B55EA7A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbiF1RDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbiF1RDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:03:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01C01BEB5
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 10:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90B68618E2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 17:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A63C341C6;
        Tue, 28 Jun 2022 17:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656435793;
        bh=sk5qPNKnZb631sj9d6GJgvK8tN9yfk31SrSkLt0Q3iE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FumXuewzZu1PCzetiZCbN6qbLwmNVxGTSuGydHcxSld0rHkhkQcb4L8NVK5F/YFcx
         WysOcObKUrdJFIZ43z0LbO9DaRnMBt/fi+Hor7UfsAZJ6u0TSdIx8ADPupLK2/rUN/
         0/MosYVkj81qhH1GeB9KBrnUzgXFPlyrhoyrURtsJ7XrEojEHwurQ025LlA4k8zhD1
         yK9B41F4BrAofGLUUvOM65CaefZW7gMnufuGHwX18vLKvjMCxijhUM1akai0Rctb5W
         v6GRPpJkqQtOty13mL3KS/Ykjdas5jixZgTfX+gIe/pWfZzcPp8gPPmEQ2uNS6aZ5s
         ED02qw7fX+n3A==
Date:   Tue, 28 Jun 2022 10:03:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Yonan <james@openvpn.net>
Cc:     netdev@vger.kernel.org, therbert@google.com,
        stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] rfs: added /proc/sys/net/core/rps_allow_ooo
 flag to tweak flow alg
Message-ID: <20220628100126.5a906259@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220628051754.365238-1-james@openvpn.net>
References: <20220624100536.4bbc1156@hermes.local>
        <20220628051754.365238-1-james@openvpn.net>
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

On Mon, 27 Jun 2022 23:17:54 -0600 James Yonan wrote:
> rps_allow_ooo (0|1, default=0) -- if set to 1, allow RFS (receive flow
> steering) to move a flow to a new CPU even if the old CPU queue has
> pending packets.  Note that this can result in packets being delivered
> out-of-order.  If set to 0 (the default), the previous behavior is
> retained, where flows will not be moved as long as pending packets remain.
> 
> The motivation for this patch is that while it's good to prevent
> out-of-order packets, the current RFS logic requires that all previous
> packets for the flow have been dequeued before an RFS CPU switch is made,
> so as to preserve in-order delivery.  In some cases, on links with heavy
> VPN traffic, we have observed that this requirement is too onerous, and
> that it prevents an RFS CPU switch from occurring within a reasonable time
> frame if heavy traffic causes the old CPU queue to never fully drain.
> 
> So rps_allow_ooo allows the user to select the tradeoff between a more
> aggressive RFS steering policy that may reorder packets on a CPU switch
> event (rps_allow_ooo=1) vs. one that prioritizes in-order delivery
> (rps_allow_ooo=0).

Can you give a practical example where someone would enable this?
What is the traffic being served here that does not care about getting
severely chopped up? Also why are you using RPS, it's 2022, don't all
devices of note have multi-queue support?
