Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EBC679FDE
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbjAXRN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbjAXRN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:13:28 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D721246B1
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:13:27 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 140BF134F;
        Tue, 24 Jan 2023 18:13:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674580406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xniId7KsRetu1dnQbgc4eUTkxQx3XwaCwItvWy3TFFQ=;
        b=OUe4o8lXbjkTBpiJWapwnrEystUP4t9PsFMODhv+PumCejKsLqEWvxcQrb2FTkMrEqA9K9
        SLs5PRkSIOYyFDf0W7CIbmuQo95FoJbSmAD0rewjmtr1AxTbWWUwgYx7f1jfSh1W9OxYWd
        rRFrObxKyprvZIErqjPBsv+D9x+zKU3MesxKRWZeqh1rqHcadJ5J+pQURFsW/B7ASu4ubQ
        7M+RoX/++lV6hNMdXHBwU8DPl7we3CLmhsQaqn04nvLk5atRI8C/RJzf5bsZTF7K5502J5
        kM+HI6P2sX0RtsasvlcMW4VoCjWarbaNSreYzN5PklzYC7ql4FdoQekwvpLxkw==
MIME-Version: 1.0
Date:   Tue, 24 Jan 2023 18:13:25 +0100
From:   Michael Walle <michael@walle.cc>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: PHY firmware update method
In-Reply-To: <YzrTKwR/bEPJOs1P@shell.armlinux.org.uk>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch> <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch> <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch> <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch> <20220930074546.0873af1d@kernel.org>
 <YzrTKwR/bEPJOs1P@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <59c5af5bd238e6ccd5cbccc58766643e@walle.cc>
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

Am 2022-10-03 14:18, schrieb Russell King (Oracle):
> On Fri, Sep 30, 2022 at 07:45:46AM -0700, Jakub Kicinski wrote:
>> Actually maybe there's something in DMTF, does PLDM have standard 
>> image
>> format? Adding Jake. Not sure if PHYs would use it tho :S
> 
> DMTF? PLDM?
> 
>> What's the interface that the PHY FW exposes? Ben H was of the opinion
>> that we should just expose the raw mtd devices.. just saying..
> 
> Not all PHYs provide raw access to the firmware memory to the host; in
> some cases, firmware memory access needs the PHY to be shutdown, and
> programs loaded into the PHY to provide a "bridge" to program the
> external firmware memory. I'm thinking about 88x3310 here - effectively
> there it's write-only access via an intermediate program on the PHY,
> and there's things like checksums etc.
> 
> So, exposing everything as a MTD sounds like a solution, but not all
> PHYs provide such access. IMHO, if we say "everything must provide a
> MTD" then we're boxing ourselves into a corner.

I agree, the PHY I'm looking at right now, can't read back the
firmware binary. And there is also no random access, you basically
have to stream the whole binary in one go to the PHY.

-michael
