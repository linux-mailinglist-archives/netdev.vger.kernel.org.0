Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B14C6B8F2F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCNKDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCNKDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:03:34 -0400
X-Greylist: delayed 434 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 03:03:28 PDT
Received: from mail.sgstbr.de (mail.sgstbr.de [IPv6:2a01:4f8:10b:1515::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2671EBCB;
        Tue, 14 Mar 2023 03:03:28 -0700 (PDT)
Received: from [IPV6:2a02:810d:ab40:2500:3b46:4127:c750:bf0] (unknown [IPv6:2a02:810d:ab40:2500:3b46:4127:c750:bf0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: fabian@blaese.de)
        by mail.sgstbr.de (Postfix) with ESMTPSA id CD29A249440;
        Tue, 14 Mar 2023 10:56:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blaese.de; s=201803;
        t=1678787793; bh=2YHHIOnfCNb0tl9AGjKfzZ+jPiMxd5LIoKufI4ihP0c=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=wadZqMqq6kk9Y3Z29PL08r1mM8MJuJg10klMiJ1n0XzL6l0Zyqk9ibZ9OVjIFYZzu
         SUJ4nviYK36Z9U64Oxz3J84nk9EoH8BRWu6c5ePrVaVeXnd5VvSXgG8xBeOGXhY5Gj
         UgRbwH2mcggyFnxPc6BSL3MWGcf5kkMxAfJZSIqUidqpt21qIDeUJbZjb9OAxRmALs
         I7LmnONEayviRGhIepyd8MPjGDYstdAqVgmsI2micefL5No1rTR8uIDy2IBIfg0Wn7
         RRzXtWfafKSXmsHhW00rnxzsVX26sc6TlfkVfbXLH2ulX29LQl8hdvPUmXP2slNABu
         WrB6edUDgWytw==
Message-ID: <e9a84798-84c6-1d4b-499b-072868577330@blaese.de>
Date:   Tue, 14 Mar 2023 10:56:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 2/2] net: stmmac: move fixed-link support fixup
 code
Content-Language: de-DE
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <20230314070208.3703963-3-michael.wei.hong.sit@intel.com>
From:   =?UTF-8?Q?Fabian_Bl=c3=a4se?= <fabian@blaese.de>
In-Reply-To: <20230314070208.3703963-3-michael.wei.hong.sit@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.03.23 08:02, Michael Sit Wei Hong wrote:
> xpcs_an_inband value is updated in the speed_mode_2500 function
> which turns on the xpcs_an_inband mode.
> 
> Moving the fixed-link fixup code to right before phylink setup to
> ensure no more fixup will affect the fixed-link mode configurations.
> 
> Fixes: 72edaf39fc65 ("stmmac: intel: add phy-mode and fixed-link ACPI _DSD setting support")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>

Tested-by: Fabian Bläse <fabian@blaese.de>
