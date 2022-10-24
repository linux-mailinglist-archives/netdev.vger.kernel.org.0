Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BF660BD82
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 00:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiJXWgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 18:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiJXWfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 18:35:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1332C4C9A;
        Mon, 24 Oct 2022 13:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89FE0615A7;
        Mon, 24 Oct 2022 20:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED7DC433C1;
        Mon, 24 Oct 2022 20:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666645002;
        bh=v1D71vDHs/TOFPH1UUaFAJFrQmOBQFf3jInDur3DtbE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V3t+wagk5Fw0To5RJ4dMzyGezxyEaKlKzC6GNC1b0x+OVjP2bRPkrcEIQ4bgpmpZc
         ljDUJnkaYmZ5liClrNqTmMTkovDPKccLF8owV9XdHzmKXLPUdxJj+mxK5kpr8SIqhy
         DpcF69Mxb90u7WTKRK4jZ1InVjgwRKearTId0gHKsMbqHsf6m3oVPszXe6hQ+NCDC9
         d3Q6E+T6iUColHG2cok7F9R8LbJxjAzFVv9NxB251bvW452WN40TyGYuciYWXamBoH
         DeCckNDT8qpFtS7T1PtCdKrerpEiiTTie5u0YN12TMHqpsvCKpKxwLd4uz86lNjKyJ
         z+y63qw1a91Yw==
Date:   Mon, 24 Oct 2022 13:56:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Osterried <thomas@osterried.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Bernard Pidoux <f6bvp@free.fr>,
        Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org
Subject: Re: [AX25] patch did not fix --  was: ax25: fix incorrect
 dev_tracker usage
Message-ID: <20221024135640.73e5eddf@kernel.org>
In-Reply-To: <2B6541B7-FF35-41D2-8A20-18D5EEE7A919@osterried.de>
References: <Yxw5siQ3FC6VHo7C@x-berg.in-berlin.de>
        <Yxx5sJh/TLzSR5xU@x-berg.in-berlin.de>
        <2B6541B7-FF35-41D2-8A20-18D5EEE7A919@osterried.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Oct 2022 20:00:00 +0200 Thomas Osterried wrote:
>  II) What consequences has the tracker counter?
> 
>      As far as I can see by kernel messages, the netdev tracker forces the
>      kernel to wait
>        (on ifdown (i.e. ifconfig ax0 down) 
>         or rmmod (i.e. rmmod bpqether or rmmod ax25) )
>      until all references to the network device are freed.
>      If there's a bug (refcount > 0 or < 0), kernel obviously waits for ever.

Small correction here - the wait is when netdev is unregistered,
which often happens on rmmod, but also when user asks for a sw
netdev to be deleted, or HW device is removed, etc.

> III) Is it only to track sessions initiated from userspace?
> 
>      I think no.

Correct, the trackers track the references taken on the device.
Doesn't really matter if the reference is somehow tracable to
a user request or not.

Sorry for lack of input on the actual ax25 problem, I had looked
briefly in September and it wasn't obvious how things work :S
