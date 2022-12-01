Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3276F63E72A
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 02:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiLABjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 20:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiLABjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 20:39:13 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3675199F2A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 17:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bAsCsbVkUZCAyAT2MekAfJoxCspTGh7BiExlq2JDXTs=; b=B92lYs0pneGJHQMeRZ6VsKCMQJ
        wVSFxzEnpscDfR2Gzgt4b0kdLwLAebeqmVhNgjM0AzlL8YbGrBQKcwW9zV3rk8YAgDtmImWpHajkh
        KNg7MBx8zZpyUfIuVoUvHSR6OVISRRBFpCvy8JDH3JHxwtSWJNoZwqHj8+IZewj6SX2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0YXX-0041Gf-7R; Thu, 01 Dec 2022 02:39:03 +0100
Date:   Thu, 1 Dec 2022 02:39:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: [PATCH net] stmmac: fix potential division by 0
Message-ID: <Y4gFt9GBRyv3kl2Y@lunn.ch>
References: <Y4f3NGAZ2rqHkjWV@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4f3NGAZ2rqHkjWV@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 01:37:08AM +0100, Piergiorgio Beruto wrote:
> Depending on the HW platform and configuration, the
> stmmac_config_sub_second_increment() function may return 0 in the
> sec_inc variable. Therefore, the subsequent div_u64 operation can Oops
> the kernel because of the divisor being 0.

I'm wondering why it would return 0? Is the configuration actually
invalid? Is ptp_clock is too small, such that the value of data is
bigger than 255, but when masked with 0xff it gives zero?

I'm wondering if the correct thing to do is return -EINVAL in
stmmac_init_tstamp_counter().

So i would like an explanation of why it is zero.

Thanks
	Andrew
