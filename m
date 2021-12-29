Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7600C4812C1
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 13:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhL2MlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 07:41:11 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:46161 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbhL2MlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 07:41:11 -0500
Received: from mwalle01.kontron.local. (unknown [IPv6:2a02:810b:4340:43bf:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6309A22205;
        Wed, 29 Dec 2021 13:41:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1640781669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZBdQ60/rUyG27LO09Ctkjdzy3ER36+khvbalnFF3uTA=;
        b=jOBy2Hv43KswJJdSySlryR812hnc/o8N5CB9IlzPZv6EgyB0Ab7p2WFEcJIUqA6Gv0Q8wf
        pYvFx77O+4sOKkbvnaYHCJRiNptwUpDmyu1vvwzE7yPbIs/y/wYuwxBHF5iiUJUAtSQfMB
        f7aPufNRV9qloO1jklM/Ot/hcvn4pNU=
From:   Michael Walle <michael@walle.cc>
To:     zajec5@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, rafal@milecki.pl, robh+dt@kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH] of: net: support NVMEM cells with MAC in text format
Date:   Wed, 29 Dec 2021 13:40:47 +0100
Message-Id: <20211229124047.1286965-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211223122747.30448-1-zajec5@gmail.com>
References: <20211223122747.30448-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Some NVMEM devices have text based cells. In such cases MAC is stored in
> a XX:XX:XX:XX:XX:XX format. Use mac_pton() to parse such data and
> support those NVMEM cells. This is required to support e.g. a very
> popular U-Boot and its environment variables.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> Please let me know if checking NVMEM cell length (6 B vs. 17 B) can be
> considered a good enough solution. Alternatively we could use some DT
> property to make it explicity, e.g. something like:
> 
> ethernet@18024000 {
> 	compatible = "brcm,amac";
> 	reg = <0x18024000 0x800>;
> 
> 	nvmem-cells = <&mac_addr>;
> 	nvmem-cell-names = "mac-address";
> 	nvmem-mac-format = "text";
> };

Please note, that there is also this proposal, which had such a conversion
in mind:
https://lore.kernel.org/linux-devicetree/20211228142549.1275412-1-michael@walle.cc/

With this patch, there are now two different places where a mac address
format is converted. In of_get_mac_addr_nvmem() and in the imx otp driver.
And both have their shortcomings and aren't really flexible. Eg. this one
magically detects the format by comparing the length, but can't be used for
to swap bytes (because the length is also ETH_ALEN), which apparently is a
use case in the imx otp driver. And having the conversion in an nvmem
provider device driver is still a bad thing IMHO.

I'd really like to see all these kind of transformations in one place.

-michael
