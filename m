Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ECD6E50A8
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjDQTLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjDQTLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:11:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34B935A2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45C1F6208F
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 19:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451A7C433D2;
        Mon, 17 Apr 2023 19:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681758707;
        bh=ZXiY5/ZCwLsBDi0GdwAdAzVnflo2CkJapJ9/139Z6uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cfLB0C/Z/2VlWMDAQxBYaJImooW+Oi5QyMMKHoUCZxYQcJKIHYo42dxoKejOYtMk8
         DSreW4/2fmiReERVXSgW2BtWwwc/2pm2Iyghj6fT0tZ2jF6b6cOdGwQeqBBwAPKu/D
         K6101Bl+XwCl7jSED/D9yYWQfFzGaamTe3JRs9E0DXwqSvuYZBpCSrU9H52LW0ynlK
         ZYgoxLyuy+mzwtVSN/OPpGvJ81ILdw8+t3Gr7C+t1/bYwtINbA6VgEFIqrjrK9FE8B
         O8Vp5i/6VTXG4es1YLFj0rDojVB4m3e4foaXfEqcKLBum0Zev+EN/ZsvSyLLuFJlzm
         Th7Brr8QOM9sg==
Date:   Mon, 17 Apr 2023 12:11:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Corinna Vinschen <vinschen@redhat.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Message-ID: <20230417121146.654b980d@kernel.org>
In-Reply-To: <ZD2X8ALO3m7dmbOu@calimero.vinschen.de>
References: <20230411130028.136250-1-vinschen@redhat.com>
        <20230412211513.2d6fc1f7@kernel.org>
        <ZDgfBEnxLWczPLQO@calimero.vinschen.de>
        <20230413090040.44aa0d55@kernel.org>
        <ZD2X8ALO3m7dmbOu@calimero.vinschen.de>
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

On Mon, 17 Apr 2023 21:03:12 +0200 Corinna Vinschen wrote:
> Yes, that was a good idea.  Turns out, TSO doesn't really work well
> with VLANs.  The speed is... suboptimal.  Here are some results
> with iperf, showing only the summary lines.

Hah, good to find out before users did :)

IIRC there is something in the TCP stack which retries sending 
as non-TSO if TSO keeps failing so "TSO is very slow" may in fact 
mean TSO is completely broken but TCP is managing to deliver a little
bit with just retransmissions or super tiny cwnd or some such.
