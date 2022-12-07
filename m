Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06685645207
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLGC23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGC22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20F7101CD
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 18:28:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DAE3B81BBA
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF8CC433D6;
        Wed,  7 Dec 2022 02:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670380105;
        bh=51irAAigSD8CTDChPJsIxhxIBXW+6KYBypkfWAsuqf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OJN7aWbAFsRQgpHgd5tPi3CdalyIvOEKVqloL2USZs4fjByDwY+Ljo5XpmZaYH734
         C3lvM498NFD+gkCjM2udnH8751A7hvRC9peKzOWQO4FOyiw5rDjxUVlEn38LAsqtc/
         dKdQ5I+KCvu2izsBgDRca/XMWeXHiNtUyvdNL557iFdflLVYhEiFhKY63obWqznuKh
         iNeDL+5uE0Q7fbX3Z+yWnAVIqAmybYgpb7+sXuC8RRO/yhmeJOxzA8lypuf5o16e2/
         +qmxqbWplpupKPtQR6nsqAth1wvVweldKPjyD6XSz3EAKfa0WQXtALuLZuBluJ6jy9
         bEgRq7ApvCzGg==
Date:   Tue, 6 Dec 2022 18:28:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        netdev@vger.kernel.org, peppe.cavallaro@st.com,
        Voon Weifeng <weifeng.voon@intel.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] stmmac: fix potential division by 0
Message-ID: <20221206182823.08e5f917@kernel.org>
In-Reply-To: <Y4i/Aeqh94ZP/mA0@lunn.ch>
References: <Y4f3NGAZ2rqHkjWV@gvm01>
        <Y4gFt9GBRyv3kl2Y@lunn.ch>
        <Y4iA6mwSaZw+PKHZ@gvm01>
        <Y4i/Aeqh94ZP/mA0@lunn.ch>
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

On Thu, 1 Dec 2022 15:49:37 +0100 Andrew Lunn wrote:
> > The root cause is the MAC using the internal clock as a PTP reference
> > (default), which should be allowed since the connection to an external
> > PTP clock is optional from an HW perspective. The internal clock seems
> > to be derived from the MII clock speed, which is 2.5 MHz at 10 Mb/s.  
> 
> I think we need help from somebody who understands PTP on this device.
> The clock is clearly out of range, but how important is that to PTP?
> Will PTP work if the value is clamped to 0xff? Or should we be
> returning -EINVAL and disabling PTP because it has no chance of
> working?

Indeed, we need some more info here :( Like does the PTP actually
work with 2.5 MHz clock? The frequency adjustment only cares about 
the addend, what is sub_second_inc thing?
