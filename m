Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF194D3BA7
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbiCIVEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiCIVEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:04:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E358935240;
        Wed,  9 Mar 2022 13:03:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0389C61A74;
        Wed,  9 Mar 2022 21:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF41AC340E8;
        Wed,  9 Mar 2022 21:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646859813;
        bh=OcrV5azfQFTJQc6og+7xhBeiB30HvqTIYzMyp9F7t2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GwC+mlky5WDv+hgPz4JGzC13hH+nx5jE80JAiLmK6xXfpCn3QGRh+PU7TQ0AqIFzD
         hg7+8RzJ2zz1k+Ue4bFReKzn3s+erH2ejpPt+fNOHtcBXbor3sp7eSshGqZUK0TqW9
         T/NXobudWvS0coKBwzC9sKiQRlfUyXU4Zh2UncywRGK3GO32T85vNitpJwvHHwZTyX
         HsNlGjiYuGCO5Vg06Cr5j9U8ylQpdxTzftyLyaRogsCrEVOW3KKxN64dXMtwkftO9l
         yZgXmsruK3lmeixn3lnP1CqlCzypEp3Z9q/Ddu8VHiF642ivqkiRjagss1W3hmFek/
         xZzq1jA4UqS1A==
Date:   Wed, 9 Mar 2022 13:03:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH net] xdp: xdp_mem_allocator can be NULL in
 trace_mem_connect().
Message-ID: <20220309130331.0f28ab36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YikSiGjkOtM7zMkM@linutronix.de>
References: <YiC0BwndXiwxGDNz@linutronix.de>
        <875yovdtm4.fsf@toke.dk>
        <YiDM0WRlWuM2jjNJ@linutronix.de>
        <87y21l7lmr.fsf@toke.dk>
        <YiZIEVTRMQVYe8DP@linutronix.de>
        <87sfrt7i1i.fsf@toke.dk>
        <20220309091508.4e48511f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YikSiGjkOtM7zMkM@linutronix.de>
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

On Wed, 9 Mar 2022 21:48:08 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-03-09 09:15:08 [-0800], Jakub Kicinski wrote:
> > Was the patch posted? This seems to be a 5.17 thing, so it'd be really
> > really good if the fix was in net by tomorrow morning! :S  
> 
> Just posted v2.

Perfect, thank you!
