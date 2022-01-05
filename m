Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DDE484F48
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbiAEIZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiAEIZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:25:39 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F792C061761;
        Wed,  5 Jan 2022 00:25:39 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 757D0223EA;
        Wed,  5 Jan 2022 09:25:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1641371133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fedfQgsr6x9sO3yER1l6Ln3QpkNkKoaDU8cBMzFGN+Q=;
        b=sY7Ujav2tztK21oJXfBxaCMq+iQ5cXCzRUQAp0RpDAoO7/iKxJbuM12oT/IIq0js0jcnSM
        YchXyLgsb8/IjCbvNI7vboWmRX0aF1VVMVk6aGYTftIYnObjbnxWI7754yVlDccBYZ70kW
        wgck4SYQ2XLf90IPCA+qGcF5BVvLUfs=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 05 Jan 2022 09:25:29 +0100
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 2/8] dt-bindings: nvmem: add transformation bindings
In-Reply-To: <YdRh2lp5Ca08gHtR@robh.at.kernel.org>
References: <20211228142549.1275412-1-michael@walle.cc>
 <20211228142549.1275412-3-michael@walle.cc>
 <YdRh2lp5Ca08gHtR@robh.at.kernel.org>
User-Agent: Roundcube Webmail/1.4.12
Message-ID: <084b306b7c49ce8085dd867663945d29@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-01-04 16:03, schrieb Rob Herring:
> On Tue, Dec 28, 2021 at 03:25:43PM +0100, Michael Walle wrote:
>> Just add a simple list of the supported devices which need a nvmem
>> transformations.
>> 
>> Also, since the compatible string is prepended to the actual nvmem
>> compatible string, we need to match using "contains" instead of an 
>> exact
>> match.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  .../devicetree/bindings/mtd/mtd.yaml          |  7 +--
>>  .../bindings/nvmem/nvmem-transformations.yaml | 46 
>> +++++++++++++++++++
>>  2 files changed, 50 insertions(+), 3 deletions(-)
>>  create mode 100644 
>> Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
>> 
>> diff --git a/Documentation/devicetree/bindings/mtd/mtd.yaml 
>> b/Documentation/devicetree/bindings/mtd/mtd.yaml
>> index 376b679cfc70..0291e439b6a6 100644
>> --- a/Documentation/devicetree/bindings/mtd/mtd.yaml
>> +++ b/Documentation/devicetree/bindings/mtd/mtd.yaml
>> @@ -33,9 +33,10 @@ patternProperties:
>> 
>>      properties:
>>        compatible:
>> -        enum:
>> -          - user-otp
>> -          - factory-otp
>> +        contains:
>> +          enum:
>> +            - user-otp
>> +            - factory-otp
> 
> If the addition is only compatible strings, then I would just add them
> here. Otherwise this needs to be structured a bit differently. More on
> that below.

I wanted to avoid having these compatible strings "cluttered" all around
the various files. Esp. having a specific compatible string in a generic
mtd.yaml. But if everyone is fine with that, I'll just move it here.

>> 
>>      required:
>>        - compatible
>> diff --git 
>> a/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml 
>> b/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
>> new file mode 100644
>> index 000000000000..8c8d85fd6d27
>> --- /dev/null
>> +++ 
>> b/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
>> @@ -0,0 +1,46 @@
>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/nvmem/nvmem-transformations.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NVMEM transformations Device Tree Bindings
>> +
>> +maintainers:
>> +  - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> +
>> +description: |
>> +  This is a list NVMEM devices which need transformations.
>> +
>> +properties:
>> +  compatible:
>> +    oneOf:
>> +      - items:
>> +        - enum:
>> +          - kontron,sl28-vpd
>> +        - const: user-otp
>> +      - const: user-otp
> 
> This will be applied to any node containing 'user-otp'. You need a
> custom 'select' to avoid that.

Out of curiosity, you mean something like:

select:
   compatible:
     contains:
       enum:
         - kontron,sl28-vpd

