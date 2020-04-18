Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD1B1AF543
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgDRWCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:02:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F7DC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:02:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD0911276E50A;
        Sat, 18 Apr 2020 15:02:53 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:02:53 -0700 (PDT)
Message-Id: <20200418.150253.423349293606830966.davem@davemloft.net>
To:     julien.beraud@orolia.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: stmmac: Fix sub-second increment
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415122432.70972-2-julien.beraud@orolia.com>
References: <20200415122432.70972-1-julien.beraud@orolia.com>
        <20200415122432.70972-2-julien.beraud@orolia.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:02:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Beraud <julien.beraud@orolia.com>
Date: Wed, 15 Apr 2020 14:24:32 +0200

>     In fine adjustement mode, which is the current default, the sub-second
>     increment register is the number of nanoseconds that will be added to
>     the clock when the accumulator overflows. At each clock cycle, the
>     value of the addend register is added to the accumulator.
>     Currently, we use 20ns = 1e09ns / 50MHz as this value whatever the
>     frequency of the ptp clock actually is.
>     The adjustment is then done on the addend register, only incrementing
>     every X clock cycles X being the ratio between 50MHz and ptp_clock_rate
>     (addend = 2^32 * 50MHz/ptp_clock_rate).
>     This causes the following issues :
>     - In case the frequency of the ptp clock is inferior or equal to 50MHz,
>       the addend value calculation will overflow and the default
>       addend value will be set to 0, causing the clock to not work at
>       all. (For instance, for ptp_clock_rate = 50MHz, addend = 2^32).
>     - The resolution of the timestamping clock is limited to 20ns while it
>       is not needed, thus limiting the accuracy of the timestamping to
>       20ns.
> 
>     Fix this by setting sub-second increment to 2e09ns / ptp_clock_rate.
>     It will allow to reach the minimum possible frequency for
>     ptp_clk_ref, which is 5MHz for GMII 1000Mps Full-Duplex by setting the
>     sub-second-increment to a higher value. For instance, for 25MHz, it
>     gives ssinc = 80ns and default_addend = 2^31.
>     It will also allow to use a lower value for sub-second-increment, thus
>     improving the timestamping accuracy with frequencies higher than
>     100MHz, for instance, for 200MHz, ssinc = 10ns and default_addend =
>     2^31.
> 
> v1->v2:
>  - Remove modifications to the calculation of default addend, which broke
>  compatibility with clock frequencies for which 2000000000 / ptp_clk_freq
>  is not an integer.
>  - Modify description according to discussions.
> 
> Signed-off-by: Julien Beraud <julien.beraud@orolia.com>

Applied.
