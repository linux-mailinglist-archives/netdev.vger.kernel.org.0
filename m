Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40CE679FCF
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbjAXRLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbjAXRLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:11:11 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93795AF
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:11:09 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id DFB2A38;
        Tue, 24 Jan 2023 18:11:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674580268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XrcXCJVbSA8n38iKNlLfn8r9apwEAV34IyMbEs6bHsk=;
        b=rq7oxHn6BHnfgAak0rtiJTUeyZuuyggIKzJPUIF0oE54E0AL04AJuZO6ki23d2b1PjBaTI
        uaDH+G0bJYX0OeZf2n52nAdX3QsOwQlYQfmrVcYJKIXPVmgooFh2MNBq9a/8KQuFDFrzmm
        aXZFw8B7av7Ypl6N7h26uuaRRq547KUVjrPToDep09TR0ReKNhaZQi737p7LuTH9urkhfI
        1Yeg0m6pKoEo777W/4xPZCAcsC6/0LkbW2hLUitXXzRgfGmw61WhlQ51Z1gyFMJIVnKXDN
        rIsjpZv5ebLsMbXb6ylcEH60KBo3f9rEKkzLAs5ihkRJD8g8DVTuRKNLfSKMdQ==
MIME-Version: 1.0
Date:   Tue, 24 Jan 2023 18:11:07 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Keller Jacob E <jacob.e.keller@intel.com>
Subject: Re: PHY firmware update method
In-Reply-To: <Yzbi335GQGbGLL4k@lunn.ch>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
 <YzQ96z73MneBIfvZ@lunn.ch> <YzVDZ4qrBnANEUpm@nanopsycho>
 <YzWPXcf8kXrd73PC@lunn.ch> <20220929071209.77b9d6ce@kernel.org>
 <YzWxV/eqD2UF8GHt@lunn.ch> <Yzan3ZgAw3ImHfeK@nanopsycho>
 <Yzbi335GQGbGLL4k@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <ced75f7f596a146b58b87dd2d6bad210@walle.cc>
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

[sorry for the very late response, but I was working on getting an
acceptable license for the PHY binary in the meantime]

>> Yeah, I tend to agree here. I believe that phylib should probably find 
>> a
>> separate way to to the flash.
>> 
>> But perhaps it could be a non-user-facing flash. I mean, what if 
>> phylib
>> has internal routine to:
>> 1) do query phy fw version
>> 2) load a fw bin related for this phy (easy phy driver may provide the
>> 				       path/name of the file)
>> 3) flash if there is a newer version available
> 
> That was my first suggestion. One problem is getting the version from
> the binary blob firmware. But this seems like a generic problem for
> linux-firmware, so maybe somebody has worked on a standardised header
> which can be preppended with this meta data?

In my case, the firmware binary blob has some static offset to get
firmware version (I need to double check that one with the vendor).
Of course we could put that PLDM thingy around it. But it seems we are
mangling with the binary provided by the vendor before putting it into
linux-firmware.git. If I understand Jacob correct, Intel will already
provide the binaries in PLDM format.

Another problem I see is how we can determine if a firmware update
is possible at all - or if we just try it anyway if that is possible.
In my case there is already an integrated firmware and the external
flash is optional. The PHY will try to boot from external flash and
fall back to the internal one. AFAIK you can read out where the PHY
was booted from. If the external flash is empty, you cannot detect if
you could update the firmware.

So if you'd do this during the PHY probe, it might try to update the
firmware on every boot and fail. Would that be acceptable?

How long could can a firmware update during probe run? Do we need
to do it in the background with the PHY being offline. Sounds like
not something we want.

-michael
