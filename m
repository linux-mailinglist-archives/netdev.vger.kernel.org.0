Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6222965FE0F
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbjAFJg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 04:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbjAFJfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 04:35:45 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF8477D10;
        Fri,  6 Jan 2023 01:27:44 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id C6FB542165;
        Fri,  6 Jan 2023 09:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1672997262; bh=pqxtamDoWidS7O09w7HZAMcUH3w/MyHbr77vLOidp7c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=ndaDkCSoEI92lNXnG1YNs5b8oVjNVGvjl+Mr2Hc7C3fMM3GOx5s7fW5/CtiHV1fil
         ND4cScruX7TWwbiOv2Smrp8JLArJIXQpVzeJ7kJxnfFrtRc/vOOo9oC3WlUf2k9E4r
         BGD+KqMAamhVW8Uvd83rFubB9Fh1TbdHbKWNWo51FfKe+h13dmto1CIm+xxBvjSg5m
         +WgVXXCcM41YfUHD91Ws7QU6UvPFKUGqBMj2F4yIKhhf5VcFd9owLqNnI2VnnjxXnJ
         BKX0V1NAfmV6RuukcT4eU33YfSoquItPhRp9lz8vzafh6EniMgC5Ofwgn2C9NiM07y
         dvaqcnDYBw8aQ==
Message-ID: <fc6d3c3b-1352-4f75-cbef-d29bd74c0e40@marcan.st>
Date:   Fri, 6 Jan 2023 18:27:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] brcmfmac: of: Use board compatible string for board type
Content-Language: en-US
To:     "Ivan T. Ivanov" <iivanov@suse.de>, aspriel@gmail.com
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        rmk+kernel@armlinux.org.uk, kvalo@kernel.org, davem@davemloft.net,
        devicetree@vger.kernel.org, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20230106072746.29516-1-iivanov@suse.de>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <20230106072746.29516-1-iivanov@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/01/06 16:27, Ivan T. Ivanov wrote:
> When "brcm,board-type" is not explicitly set in devicetree
> fallback to board compatible string for board type.
> 
> Some of the existing devices rely on the most compatible device
> string to find best firmware files, including Raspberry PI's[1].
> 
> Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
> 
> [1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>

The existing code already falls back to the compatible string, *as long
as there is no board_type set already*.

As far as I can tell, the only way the board_type can get another value
first is if it comes from DMI. This behavior was inadvertently changed
by commit 7682de8b3351 (since I was not expecting platforms to have
*both* DT and DMI information).

I'm guessing the Raspberry Pi is one such platform, and
`/sys/devices/virtual/dmi` exists? Hybrid UEFI+ACPI+DT platform I take it?

If so, your commit description should probably be something like:

===
brcmfmac: Prefer DT board type over DMI board type

The introduction of support for Apple board types inadvertently changed
the precedence order, causing hybrid ACPI+DT platforms to look up the
firmware using the DMI information instead of the device tree compatible
to generate the board type. Revert back to the old behavior,
as affected platforms use firmwares named after the DT compatible.

Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
===

An also add a Cc: stable@vger.kernel.org to make sure this gets backported.

With the fixed description,

Reviewed-by: Hector Martin <marcan@marcan.st>

- Hector
