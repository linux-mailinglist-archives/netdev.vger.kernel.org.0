Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7B84DB845
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357825AbiCPS4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243715AbiCPS4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:56:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BA16E360;
        Wed, 16 Mar 2022 11:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A28CDB80E52;
        Wed, 16 Mar 2022 18:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84988C340E9;
        Wed, 16 Mar 2022 18:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647456917;
        bh=ozTEfgBeUFBy1XJl7pt8AtUWH1vTyITH+waCRZz6NIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=avi21eeLUFSsX47X8JiQW+kdgRyLhJs3MGuORB2fxnxMzKtZCYYjX5z1zHw5PmDdD
         CAhBOU9a4PFQ8YhtbYQkyKwOmGNn0/rn1RDZsbEohdc8AOjphI3QMaHFTyJHlGwJQu
         vHFrBHjGqxD0NuQQBdRDyybfxRLJAd3JEhZ/9Rf6KxBEhCbdUxXat4vpLAD0CqNfsf
         8o0wkyH47RYAJhIR5UwjKwLrNBEsWIEXhErtEQWNOn1LcSIdil5tZW2WQWIic6vB51
         Hr43xxeSQJrZiWMshNfVMDgZ/ZqzKgktWAcLN/zOzx2mJ6k8yQQEOhdlSw5K/5PtFq
         xj/D1FB6QsfaQ==
Date:   Wed, 16 Mar 2022 11:55:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     David Ahern <dsahern@kernel.org>,
        "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "xeb@mail.ru" <xeb@mail.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "talalahmad@google.com" <talalahmad@google.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        "flyingpeng@tencent.com" <flyingpeng@tencent.com>,
        "mengensun@tencent.com" <mengensun@tencent.com>,
        "dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Message-ID: <20220316115515.7f1fa90a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5f73ddd6ee4940d79e846a0eb624c73f@AcuMS.aculab.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-2-imagedong@tencent.com>
        <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
        <20220315215553.676a5d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f73ddd6ee4940d79e846a0eb624c73f@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 10:12:00 +0000 David Laight wrote:
> Is it worth considering splitting the 'reason' into two parts?
> Eg x << 16 | y
> One part being the overall reason - and probably a define.
> The other qualifying the actual failing test and probably just
> being a number.
> 
> Then you get an overall view of the fails (which might even
> be counted) while still being able to locate the actual
> failing test.

That popped to my mind, but other than the fact that it "seems fine" 
I can't really convince myself that (a) 2 levels are enough, why not 3;
(b) I personally don't often look at the drops, so IDK what'd fit the
needs of the consumer of this API. TCP bad csum drops are the only ones
I have experience with, and we have those already covered.
