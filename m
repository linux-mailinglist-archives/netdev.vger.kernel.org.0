Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C63B4DB84E
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348812AbiCPS6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347175AbiCPS6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:58:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDEC6E4E6;
        Wed, 16 Mar 2022 11:57:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C7CF618F7;
        Wed, 16 Mar 2022 18:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AECCC340E9;
        Wed, 16 Mar 2022 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647457056;
        bh=uI3OHf8QFMUZgXo1+ATmSOG9B0obHF8fJChcWMf1sm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mYw10xgOwrJOxAsYfgDXXkfne9MuKmzWFeWnFyLjNjv3p+0lYQPgr+IvZ8jE3/PIV
         OJegMGGfoHv/pky0LNNOpVYsg2M0x5JLAqTZprndlXZp/hdrCOMVnHcnzzM+Yyyf87
         JVEQSZODxaJNK7WSJ0clmm2WX/9ahaMxqiRcY0Ri/b3FhlJonM6fN016pwgz1PIxfD
         OIgIvdqLLtp5pI0vbvdpcCWSUqKPLDCrBUDOIOcpEEotn2B4ajMQL5LBBey8BEBwCK
         CmNaeZ7q3RCUDsFUYzyH/d2R1NlhDPdDVTY5iAAZXfpdogA7Lbqz3Iwlv7bagVGwcc
         rZk9SIP+iiP9A==
Date:   Wed, 16 Mar 2022 11:57:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     menglong8.dong@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        xeb@mail.ru, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Message-ID: <20220316115734.1899bb11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <30b0991a-8c41-2571-b1b6-9edc7dc9c702@kernel.org>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-2-imagedong@tencent.com>
        <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
        <20220315215553.676a5d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <30b0991a-8c41-2571-b1b6-9edc7dc9c702@kernel.org>
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

On Wed, 16 Mar 2022 08:56:14 -0600 David Ahern wrote:
> > That's certainly true. I wonder if there is a systematic way of
> > approaching these additions that'd help us picking the points were 
> > we add reasons less of a judgment call.  
> 
> In my head it's split between OS housekeeping and user visible data.
> Housekeeping side of it is more the technical failure points like skb
> manipulations - maybe interesting to a user collecting stats about how a
> node is performing, but more than likely not. IMHO, those are ignored
> for now (NOT_SPECIFIED).
> 
> The immediate big win is for packets from a network where an analysis
> can show code location (instruction pointer), user focused reason (csum
> failure, 'otherhost', no socket open, no socket buffer space, ...) and
> traceable to a specific host (headers in skb data).

Maybe I'm oversimplifying but would that mean first order of business
is to have drop codes for where we already bump MIB exception stats?
