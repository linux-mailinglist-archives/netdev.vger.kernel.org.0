Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E2F667EF3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbjALTWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240378AbjALTVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:21:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E14676D4;
        Thu, 12 Jan 2023 11:09:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE766B82016;
        Thu, 12 Jan 2023 19:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE6BC433D2;
        Thu, 12 Jan 2023 19:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673550586;
        bh=LfVocOPeuXU9PT7e7b20/1KuExU0UCPaV8icE6vvT7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tD3acM42NClnAlycdRwkO7q9r46gNcdJFDIYdMPkYmnnUqI3U+ftoqv8VLWoTUFMA
         VCOK8H1uJWoeYJIvUSMS+Ks20CTQDiERDYDrPGQ9IzLqJGvSsYro79DI6VzutKvKye
         hdSRNCMao/RrkYacvCTYmTq5UmYV8XTZaN8HCnbZbvC08lhy3pPQoAvZMT1zLOz4Bs
         cjaxqjnZAhr4/H+d7sQ9WpXd3cvIgE0PHVmsN1yW82a3qLKPnPcReHWq0NPb+75Uwz
         bf7E6a7WTx4Yc+zQDVRNuFyCavpSPsjsDEumoH5G3A01NkyMLjku5GGBNIIISO0uDp
         s5zRzOUYXpPhg==
Date:   Thu, 12 Jan 2023 11:09:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <20230112110945.6f168a3e@kernel.org>
In-Reply-To: <DM6PR11MB4657BF81BEBC10E6EC5044149BFD9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <DM6PR11MB4657BF81BEBC10E6EC5044149BFD9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Jan 2023 12:23:29 +0000 Kubalewski, Arkadiusz wrote:
> Then we would create and register muxed pins with existing dpll pins.
> Each muxed pin is allocated and registered with each parent it can provide
> signal with, like below (number in bracket is parent idx):
>                            +---+   
>                         0--|   |   
>                 +---+      |   |   
>  8(2) /  9(3)---|   |   1--| D |--5
>                 |   |      | P |   
> 10(2) / 11(3)---| M |---2--| L |--6
>                 | U |      | L |   
> 12(2) / 13(3)---| X |---3--|   |--7
>                 |   |      |   |   
> 14(2) / 15(3)---|   |   4--|   |   
>                 +---+      +---+
> 
> Controlling the mux input/output:
> In this case selecting pin #8 would provide its signal into DPLLs input#2 and
> selecting #9 would provide its signal into DPLLs input#3.

I agree with Jiri, the duplication seems unnecessary. My thinking would
be to handle this as follows:

                             +---+   
                          0--|   |   
                +---+        |   |   
           10---|   |     1--| D |--5
                |   |        | P |   
           11---| M |-8---2--| L |--6
                | U |        | L |   
           12---| X |-9---3--|   |--7
                |   |        |   |   
           13---|   |     4--|   |   
                +---+        +---+

Give the user the ability to both select the inputs to DPLL from 
0-4 and from 10-13. If 10-13 are selected the core should give mapping
things automatically a try (but we don't need to support auto-mapping 
for muxes with more than one output from the start).
There should also be an API for manually configuring muxes. 

Eg.

User requests DPLL inputs: 0, 1, 10, 11
  Core automatically maps 10 -> 8, 11 -> 9

User requests DPLL inputs: 0, 1, 10, 11, 12
  Core responds with an error

User requests DPLL inputs: 0, 1, 2, 3
  Core doesn't touch the mux
User requests mux to direct 10 -> 8
User requests mux to direct 11 -> 9
  Now the config is equivalent to case #1
