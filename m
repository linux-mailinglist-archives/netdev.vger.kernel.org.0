Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C4451A4AA
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352943AbiEDP7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352986AbiEDP7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:59:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398B31659A
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE88AB82752
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4B7C385A5;
        Wed,  4 May 2022 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651679754;
        bh=C7uWhIXFmyspPFN/85L75F+rF1xMT5aGQwbMEywRFXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fKRjVSG8k6C68q3JjClkw02cs/cgMN8cD02cgstl90VkjMhrYTa3URmK0o5PSR31s
         PL2MW6gsrjMZu80yWpWiaddO2OzwEoJRSlH5NToiON0hO9Z2dl+U7wUE3h1f+/m4MM
         9eI4oyWBkq8n5DYWHnXBBGdLHWL5Q4eIlFVH48cmeQbfzlCkSh36gpeM4jeGvWzevf
         3Fc7m9Eke0ESEczoi6GJy1fJ0jnM7a/zyZntm/luoFf1KnYLIkVc/hKQx6nlcI2l0N
         84STLOL0dbuE+ToZjR2OuCs2SnubVlgYsApFZsPkAxkb1vs4cQcpJ7R1s/Y5NOLpis
         Dx/azcxCeJzBA==
Date:   Wed, 4 May 2022 08:55:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, mlichvar@redhat.com,
        netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next v3 0/6] ptp: Support hardware clocks with
 additional free running cycle counter
Message-ID: <20220504085552.3ff84d0c@kernel.org>
In-Reply-To: <20220501111836.10910-1-gerhard@engleder-embedded.com>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  1 May 2022 13:18:30 +0200 Gerhard Engleder wrote:
> ptp vclocks require a clock with free running time for the timecounter.
> Currently only a physical clock forced to free running is supported.
> If vclocks are used, then the physical clock cannot be synchronized
> anymore. The synchronized time is not available in hardware in this
> case. As a result, timed transmission with TAPRIO hardware support
> is not possible anymore.
> 
> If hardware would support a free running time additionally to the
> physical clock, then the physical clock does not need to be forced to
> free running. Thus, the physical clocks can still be synchronized while
> vclocks are in use.
> 
> The physical clock could be used to synchronize the time domain of the
> TSN network and trigger TAPRIO. In parallel vclocks can be used to
> synchronize other time domains.
> 
> One year ago I thought for two time domains within a TSN network also
> two physical clocks are required. This would lead to new kernel
> interfaces for asking for the second clock, ... . But actually for a
> time triggered system like TSN there can be only one time domain that
> controls the system itself. All other time domains belong to other
> layers, but not to the time triggered system itself. So other time
> domains can be based on a free running counter if similar mechanisms
> like 2 step synchroisation are used.
> 
> Synchronisation was tested with two time domains between two directly
> connected hosts. Each host run two ptp4l instances, the first used the
> physical clock and the second used the virtual clock. I used my FPGA
> based network controller as network device. ptp4l was used in
> combination with the virtual clock support patches from Miroslav
> Lichvar.

The netdev parts looks sane, I think.

Richard? Let me also add Willem, Jonathan and Martin.
