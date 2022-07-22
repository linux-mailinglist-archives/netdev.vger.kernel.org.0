Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1915557E8E0
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiGVV3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiGVV3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D727A876B
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 14:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 082E9620FD
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 21:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAB3C341C6;
        Fri, 22 Jul 2022 21:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658525383;
        bh=/Hl19ZHopwHB2jmOqrlzq4aiXuvU1o07YYOGggoyDRU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F9Z2vc88s/j+2Op6T5YNX3yLjVE3zcc7Z7BU00eZU+FILiMuVU7CFNz99GaH1mdl7
         ERnTE7NTFoGKhJmc/Ers/Y3jtMLPQGrPQnU+7cdh983ufgtwr6MRSBUIyy5nnfYBSK
         kuImwqZGgITQJwnSABh1Uz7g2KmTdBqi4Wl3VY26Rj/UybvG4lePkUkzw/g/cO5jBW
         joEtBkuX/OcuPRpbcH2ygfUm6tvDU3Dg6fvUDGJvrSMIhnVNbYxSU9fD6qgtdtCvKR
         b64wzvGVxG1BHzX05Dr7qyLIsXUEXNtm4wRT4lKoUN7AC4lqbhtDI5DGqQeidxyFZN
         UrdTwPiGbMFHw==
Date:   Fri, 22 Jul 2022 14:29:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jules Maselbas <jmaselbas@kalray.eu>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: ethtool generate a buffer overflow in strlen
Message-ID: <20220722142942.48f4332c@kernel.org>
In-Reply-To: <20220722173745.GB13990@tellis.lin.mbt.kalray.eu>
References: <20220722173745.GB13990@tellis.lin.mbt.kalray.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jul 2022 19:37:46 +0200 Jules Maselbas wrote:
> There is suspicious lines in the file drivers/net/ethernet/freescale/enetc/enetc_ethtool.c:
>    { ENETC_PM0_R1523X, "MAC rx 1523 to max-octet packets" },
> and:
>    { ENETC_PM0_T1523X, "MAC tx 1523 to max-octet packets" },
> 
> Where the string length is actually greater than 32 bytes which is more
> than the reserved space for the name. This structure is defined as
> follow:
>     static const struct {
>         int reg;
>         char name[ETH_GSTRING_LEN];
>     } enetc_port_counters[] = { ...
> 
> In the function enetc_get_strings(), there is a strlcpy call on the
> counters names which in turns calls strlen on the src string, causing
> an out-of-bound read, at least out-of the string.
> 
> I am not sure that's what caused the BUG, as I don't really know how
> fortify works but I thinks this might only be visible when fortify is
> enabled.
> 
> I am not sure on how to fix this issue, maybe use `char *` instead of
> an byte array.

Thanks for the report!

I'd suggest to just delete the RMON stats in the unstructured API
in this driver and report them via
 
	ethtool -S eth0 --groups rmon

No point trying to figure out a way to make the old API more
resilient IMO when we have an alternative.
