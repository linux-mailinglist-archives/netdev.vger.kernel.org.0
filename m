Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808FC51588F
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343714AbiD2WmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiD2WmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:42:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2106C848E
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9626FB835F5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 22:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2756C385A7;
        Fri, 29 Apr 2022 22:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651271927;
        bh=80ZFm4ptxxAtLBvRA26j6Ts1jm9UqI8AXLSqH5ihhD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DJVwUC2rPcPEdl2nSHLX+g9PAYjZNz2+vm08gy6KVGFrVUQwCOkKOuGWrZs/tHCSP
         jAiPDUYvTzNacZh1ItaOgRPOqJE72/udpDxfyt6pEkyNg5UDb3Asn9iye5whRdZxR9
         i8iVlj6spXV5QVqKgZqKzEXk1GgpOzkSm2/tfRFbI77SUwaj2uLyelS7BkkISp4RtA
         qlJA3grR6tKDRPQDKLD6dHJnt0ZKEuplaApWjU/HSsU2AafLiyDHuh5EUjkwFFDXG1
         CSIG8JtMvHYF453jzCTc+52wyYTL8Ygq4b2fRsBwbjkICtb10ZoZqKeAMzwD3PtV5u
         JyiHG3kp3vkgg==
Date:   Fri, 29 Apr 2022 15:38:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220429153845.5d833979@kernel.org>
In-Reply-To: <Ymw8jBoK3Vx8A/uq@nanopsycho>
References: <Ymb5DQonnrnIBG3c@shredder>
        <20220425125218.7caa473f@kernel.org>
        <YmeXyzumj1oTSX+x@nanopsycho>
        <20220426054130.7d997821@kernel.org>
        <Ymf66h5dMNOLun8k@nanopsycho>
        <20220426075133.53562a2e@kernel.org>
        <YmjyRgYYRU/ZaF9X@nanopsycho>
        <20220427071447.69ec3e6f@kernel.org>
        <YmvRRSFeRqufKbO/@nanopsycho>
        <20220429114535.64794e94@kernel.org>
        <Ymw8jBoK3Vx8A/uq@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 21:29:16 +0200 Jiri Pirko wrote:
> >The main question to me is whether users will want to flash the entire
> >device, or update line cards individually.  
> 
> I think it makes sense to update them individually. The versions are
> also reported individually.

Okay, but neither I want that, nor does it match what Ido described as
the direction for mlxsw, quoting:

  The idea (implemented in the next patchset) is to let these devices
  expose their own "component name", which can then be plugged into the
  existing flash command:

    $ devlink lc show pci/0000:01:00.0 lc 8
    pci/0000:01:00.0:
      lc 8 state active type 16x100G
        supported_types:
           16x100G
        devices:
          device 0 flashable true component lc8_dev0
          device 1 flashable false
          device 2 flashable false
          device 3 flashable false
    $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2 component lc8_dev0

Your "devices" are _not_ individually flashable. It seems natural for
single-board devices like a NIC or a line card to have a single flash
with all the images burned together.

> What's the benefit of not doing that.

As already mentioned in my previous reply the user will likely have 
a database of all their networking assets, and having to break them
up further than the physical piece of gear they order from the supplier
is a pain. Plus the vendor will likely also prefer to ship a single
validated image rather than a blob for every board component with FW.

> Also, how would you name the "group" component. Sounds odd to me.

To flash the whole device we skip the component.

> >What's inside mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2? Doesn't
> >sound like it's FW just for a single gearbox?

Please answer questions. I already complained about this once in 
this thread.
