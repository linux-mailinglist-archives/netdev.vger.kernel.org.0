Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E485AE1DE
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238654AbiIFIHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIFIHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:07:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E93851420
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0263DB8163D
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E9CC433C1;
        Tue,  6 Sep 2022 08:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662451657;
        bh=rz8yCoQQwuxmvDhy+2F1MGuVTyQFLoxGDHcm0eNxzmE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hwNHm5GUrDVxnSiE9aa9J5d8HnGps10H67U2kb0iHpP1fSMIaEDhBooH/4l1icRsv
         mt4DVxMbjkrFy27TLAnYPMYb+8BemeeVwCi4e4ZIyiYN7w6py6wJ5YTOWY34o5tUQw
         yfJfHX4IOEV2v2aurDKfR+cXRzCF1mrfMuuQbZdroHzOsu0+ZRv94KYrW8DQROLgyZ
         OAwWYCxibQzEllzj3r7Pg82/ammsU7/ZImcsrzmIhBN6gOH48/O/qDQU/lB/dmtiY1
         Bpm4qzCfVJP1hwww0EU80MHMUaFou1kJUM95xU5EVhFOqMNaoWYDcdJzXETIZT//by
         CfAS/oYNy2hSg==
Date:   Tue, 6 Sep 2022 10:07:32 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4 0/6] net: dsa: mv88e6xxx: qca8k: rmon: Add
 RMU support
Message-ID: <20220906100732.775d0fe1@dellmb>
In-Reply-To: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
References: <20220906063450.3698671-1-mattias.forsblad@gmail.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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

On Tue,  6 Sep 2022 08:34:44 +0200
Mattias Forsblad <mattias.forsblad@gmail.com> wrote:

> The Marvell SOHO switches have the ability to receive and transmit
> Remote Management Frames (Frame2Reg) to the CPU through the
> attached network interface.
> This is handled by the Remote Management Unit (RMU) in the switch
> These frames can contain different payloads:
> single switch register read and writes, daisy chained switch
> register read and writes, RMON/MIB dump/dump clear and ATU dump.
> The dump functions are very costly over MDIO but it's
> only a couple of network packets via the RMU.
> 
> Next step could be to implement ATU dump.
> We've found that the gain to use RMU for single register
> read and writes is neglible.
> 
> qca8k
> =====
> There's a newly introduced convenience function for sending
> and waiting for frames. Changes have been made for the qca8k
> driver to use this. Please test for regressions.
> 
> RFC -> v1:
>   - Track master interface availability.
>   - Validate destination MAC for incoming frames.
>   - Rate limit outputs.
>   - Cleanup setup function validating upstream port on switch.
>   - Fix return values when setting up RMU.
>   - Prefix defines correctly.
>   - Fix aligned accesses.
>   - Validate that switch exists for incoming frames.
>   - Split RMON stats function.
> 
> v1 -> v2:
>   - Remove unused variable.
> 
> v2 -> v3:
>   - Rewrite after feedback. Use tagger_data to handle
>     frames more like qca8k.
>   - qca8k: Change to use convenience functions introduced.
>     Requesting test of this.
>     
> v3 -> v4:
>   - Separated patches more granular.
>   
> Regards,
> Mattias Forsblad

Nitpick: in subject, the order of components separated by ':' infers
hierarchy, so your subject
  net: dsa: mv88e6xxx: qca8k: rmon: Add RMU support
means:
  component net
    subcompoment dsa
      subcomponent mv88e6xxx
        subcomponent qca8k (this is wrong since qca8k is separate
                            driver, not a subcomponent of mv88e6xxx)

You should use ',' to separate mv88e6xxx and qca8k, something like
  net: dsa: mv88e6xxx, qca8k: rmon: Add RMU support

Since this is not an actual patch, but instead a cover letter only,
it's not a problem (at least not for me). But please try not to do it
in actual patches.

Marek
