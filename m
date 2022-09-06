Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA535AE73E
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 14:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiIFMIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 08:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239430AbiIFMIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 08:08:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E372679A76
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eEHsxs7qJrZ5ujGUxGcFl8gZpMiW0vMPKDd4ouEf0FU=; b=h0zOEWrAGijCULdJsk8Gnxbel6
        VI86WDuMQfOG1DKsOot0WWB3Zgea9zzeepqHygqhYfl8K/JUzcx0EAAG/nVimQa5OH1dWigVP5d4f
        pkSFxXJsF5jBE0HdGvUgWOXRzDZa6tRDTh3bgMi+adphzQIcLzuHsCP/hBCPiRa7X3Lg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVXMu-00FkK4-Rq; Tue, 06 Sep 2022 14:07:52 +0200
Date:   Tue, 6 Sep 2022 14:07:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next 2] net: ngbe: sw init and hw init
Message-ID: <Yxc4GF/Xo8vVxfzZ@lunn.ch>
References: <20220905125224.2279-1-mengyuanlou@net-swift.com>
 <YxaYytbu2LyJ6edV@lunn.ch>
 <DC1F2305-9590-4107-8BB5-366B6E978F82@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC1F2305-9590-4107-8BB5-366B6E978F82@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is it necessary to pull the common code out into a library?
> There are some differences in register configuration.

More code, means more bugs. Somebody fixes the bug in one copy of the
code and has no idea there is a second copy of the code in another
driver with the same bug etc.

It also does not look like any of this is on the fast path. If you
have benchmarks which show using common code slows down the fast path,
moving frames into/out of the interface then you can have similar code
repeated in each driver.

So yes, it is necessary to create a collection of shared code.

> It is not convenient for customers to use.

Customers just installs the kernel RPM/deb from their Linux
distribution and it has all the drivers.  Backporting the drivers to a
vendor kernel should not be any more difficult because of the shared
code.

       Andrew
