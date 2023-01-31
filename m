Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6977683445
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjAaRsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbjAaRs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:48:27 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38D910F5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:48:23 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 09F4C1235;
        Tue, 31 Jan 2023 18:48:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1675187302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cggJyVcZ+cxRaEyvQWDXkAx7ynWzSTvoeRGLTMr56zo=;
        b=Z7dpkX22qeU6uYxnr0fLYvOhPi/tDEW5opj0iIbVy+UYLQp83HEaw3aSQ2QbU0ElCSbMsS
        yvwX9stt4Ne/8WTjvx9NoEvRppVIePF02WW6VA1eRXYvUZvjfHOKXRoYyhtDbR2vKAJvPC
        nWXQLGfl2NV1hQEafFPMXydNrREl1D/Tl5erBr+MTc7NVptMSBvhCMVNT+Be7zbXLOHAvd
        5JaKhA1NdWbQNarAaN52NcSnAhehyW7peAjEO5PKJyvfArZRizkDFWtW1BvfGRK6EVaW/z
        MHkmkKzkOujMhkTcQgx8NkIQ3O5Y+jJY4Dvi61NsC24Me8NEn0D9mE9Yw3h/qA==
MIME-Version: 1.0
Date:   Tue, 31 Jan 2023 18:48:21 +0100
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Keller Jacob E <jacob.e.keller@intel.com>
Subject: Re: PHY firmware update method
In-Reply-To: <Y9lB0MmgyCZxnk3N@shell.armlinux.org.uk>
References: <YzQ96z73MneBIfvZ@lunn.ch> <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch> <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch> <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch> <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
 <Y9BCrtlXXGO5WOKN@lunn.ch> <7bd02bf6880a092b64a0c27d3715f5b6@walle.cc>
 <Y9lB0MmgyCZxnk3N@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c60f97a680a6004a2c1d04d2007b6d09@walle.cc>
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

Am 2023-01-31 17:29, schrieb Russell King (Oracle):
> On Tue, Jan 31, 2023 at 05:10:08PM +0100, Michael Walle wrote:
>> Am 2023-01-24 21:42, schrieb Andrew Lunn:
>> > One device being slow to probe will slow down the probe of that
>> > bus. But probe of other busses should be unaffected. I _guess_ it
>> > might have a global affect on EPROBE_DEFER, the next cycle could be
>> > delayed?  Probably a question for GregKH, or reading the code.
>> >
>> > If it going to be really slow, then i would suggest making use of
>> > devlink and it being a user initiated operation.
>> 
>> One concern which raised internally was that you'll always do
>> the update (unconditionally) if there is a newer version. You seem
>> to make life easier for the user, because the update just runs
>> automatically. OTHO, what if a user doesn't want to update (for
>> whatever reason) to the particular version in linux-firmware.git.
>> I'm undecided on that.
> 
> On one hand, the user should always be asked whether they want to
> upgrade the firmware on their systems, but there is the argument
> about whether a user has sufficient information to make an informed
> choice about it.
> 
> Then there's the problem that a newer firmware might introduce a
> bug, but the user wants to use an older version (which is something
> I do with some WiFi setups, and it becomes a pain when linux-firmware
> is maintained by the distro, but you don't want to use that provided
> version.
> 
> I really don't like the idea of the kernel automatically updating
> non-volatile firmware - that sounds to me like a recipe for all
> sorts of disasters.

I agree. That leaves us with the devlink solution, right?

Where would the firmware be stored, fwupd.org was mentioned by
Jakub, or is it the users responsibility to fetch it from the
vendor? Andrew was against adding a firmware update mechanism
without having the binaries.

-michael
