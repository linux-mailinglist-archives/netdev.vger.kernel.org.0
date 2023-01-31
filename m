Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553FA683247
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjAaQKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjAaQKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:10:17 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF4E53997
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:10:10 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id A860C125C;
        Tue, 31 Jan 2023 17:10:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1675181408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RBubteLWYc53j30f9CrdrX9f9/wHtkve14BHFrdD0sQ=;
        b=WlDZJSl+y3kUskU3e5OAUtf5uXYCwSOO+/nSNhmdGPtu1tr+hBRb5y8WLf5Ly1W6fVe710
        XyC/H9saZ+1hhkN+lXWpDAeXxxA2VRnT6qcbTbpgJBiDBVoYwl2yPZv6vURI7ficWR8aDp
        uHoq8WAWQMoOw5KnN//CLvavIT7G8qOG8qWIsb4lG1YECFp9x1i51SzsnKPhll0Q8LhKSe
        dk9xnYEqNK5Bcfv1kMMfROSt0A82F4/qSUXlE6guPhqWTLu9VjQKLjvtG8bhLhDxf8AU8T
        SVl85iGcqFaULY+3LsxLVjtrmz5N9qRr75jTtqUK5a2gLy2LsLnhd36ijSDoxw==
MIME-Version: 1.0
Date:   Tue, 31 Jan 2023 17:10:08 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Keller Jacob E <jacob.e.keller@intel.com>
Subject: Re: PHY firmware update method
In-Reply-To: <Y9BCrtlXXGO5WOKN@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch> <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch> <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch> <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch> <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
 <Y9BCrtlXXGO5WOKN@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <7bd02bf6880a092b64a0c27d3715f5b6@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-01-24 21:42, schrieb Andrew Lunn:
>> So if you'd do this during the PHY probe, it might try to update the
>> firmware on every boot and fail. Would that be acceptable?
> 
> Do you have a feeling how long that takes?

As a ballpark, with my PoC it takes about 11s. The binary itself
is around 128k and the MDC has a frequency of 2.5MHz. Although,
I didn't do any testing for now with slower or faster clock
frequency. I'm polling for a ready bit most of the time.

> Also, is it possible to put the firmware into RAM and run it from
> there, rather than put it into the EEPROM?

Not that I'm aware of.

>> How long could can a firmware update during probe run? Do we need
>> to do it in the background with the PHY being offline. Sounds like
>> not something we want.
> 
> One device being slow to probe will slow down the probe of that
> bus. But probe of other busses should be unaffected. I _guess_ it
> might have a global affect on EPROBE_DEFER, the next cycle could be
> delayed?  Probably a question for GregKH, or reading the code.
> 
> If it going to be really slow, then i would suggest making use of
> devlink and it being a user initiated operation.

One concern which raised internally was that you'll always do
the update (unconditionally) if there is a newer version. You seem
to make life easier for the user, because the update just runs
automatically. OTHO, what if a user doesn't want to update (for
whatever reason) to the particular version in linux-firmware.git.
I'm undecided on that.

It's different than a firmware which is loaded into RAM and which
*needs* to be loaded anyway. In this case the update is voluntary.

-michael
