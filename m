Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4644C16B9
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 16:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242019AbiBWP2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 10:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240685AbiBWP17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 10:27:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC3F0583BC
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 07:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645630050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kH8WIN2Y5/0MeVxcsZQrx8+wnwcyD8nghWH8KM7iDsA=;
        b=KqGPnCiA9/zHrRCA/5D8/wtJT2Ta5jx2iXBBfODLq8XjCNaXE2N/vsB+GQkrTj7vtNPZDY
        7BZZBLsQxERDySUZ8/byMA052D8md+SvUj/yxf6H/MylTItoOU8qVCDMaFFTUn+HUZl+Uz
        duGPRj6oLEwBUTM6XmQd0UVwhlzqu/Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-crTVu_LRO_Ofjg3n3XZXHA-1; Wed, 23 Feb 2022 10:27:29 -0500
X-MC-Unique: crTVu_LRO_Ofjg3n3XZXHA-1
Received: by mail-ej1-f70.google.com with SMTP id d7-20020a1709061f4700b006bbf73a7becso7232415ejk.17
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 07:27:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kH8WIN2Y5/0MeVxcsZQrx8+wnwcyD8nghWH8KM7iDsA=;
        b=iwCbxaYZEK1YaQ83mMd/URHCyp4743/goFDxndgE5e4eFsauOVlpe1bq9abRlvat6F
         Eb/F8ERpB00xAd7hSIftHH2FST/iy3glwiwcfdBKZ5wo1NefVkVYvfrd0FsMbFbspB/M
         ERM3UunktBvghcQh5ruAK+dc7t0Hu9a7aKzEPPz6UC1s7bSUz/YcQGO+rAUVcXrt5zOp
         Vd+pXOanz/XEnLJLk0nNVj7H4ej22XaYZ7VOS/bRKxfQ/2ZFXV2dMe3BK9dTKfGEO2SQ
         gBs5M5BkeLBQODaL7gCfe1cObVeLxcLamkeAuEnoWS6INESOV5eqkBTGq9qUtewmSSk4
         +Kng==
X-Gm-Message-State: AOAM5325yMui5xgeNT0bRq7wazcboV46+9hPsad+FI1uqzL+61DTXaF/
        UtgiGInABqpkAzwk2rASYkLeOIMCOdzhHEwe7IK8mVUN6m3ZmoAoQ2i3r66VL6zNGwWp50mgT0E
        kgbSSiBy0VVH2yxA4
X-Received: by 2002:a17:907:3f95:b0:6d3:feb2:ef88 with SMTP id hr21-20020a1709073f9500b006d3feb2ef88mr207532ejc.480.1645630047611;
        Wed, 23 Feb 2022 07:27:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxd10eUh+0Ou6b2l+D1KhQmrVXRkGHIS5KWx3uTpl+yTqghprex4MQO/OYDY3rFz0PeTTOFsw==
X-Received: by 2002:a17:907:3f95:b0:6d3:feb2:ef88 with SMTP id hr21-20020a1709073f9500b006d3feb2ef88mr207520ejc.480.1645630047444;
        Wed, 23 Feb 2022 07:27:27 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1? (2001-1c00-0c1e-bf00-1db8-22d3-1bc9-8ca1.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1db8:22d3:1bc9:8ca1])
        by smtp.gmail.com with ESMTPSA id fn5sm7554851ejc.179.2022.02.23.07.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 07:27:26 -0800 (PST)
Message-ID: <2a34b9e5-be7b-9f08-d9f8-bdd40f06ff87@redhat.com>
Date:   Wed, 23 Feb 2022 16:27:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-11-clement.leger@bootlin.com>
 <YhPSkz8+BIcdb72R@smile.fi.intel.com> <20220222142513.026ad98c@fixe.home>
 <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
 <888f9f1a-ca5a-1250-1423-6c012ec773e2@redhat.com>
 <YhYriwvHJKjrDQRf@shell.armlinux.org.uk>
 <4d611fe8-b82a-1709-507a-56be94263688@redhat.com>
 <20220223151436.4798e5ad@fixe.home> <YhZRgnPG5Yd8mvc/@lunn.ch>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <YhZRgnPG5Yd8mvc/@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/23/22 16:23, Andrew Lunn wrote:
>> As Russell asked, I'm also really interested if someone has a solution
>> to reuse device-tree description (overlays ?) to describe such
>> hardware. However, the fact that CONFIG_OF isn't enabled on x86 config
>> seems a bit complicated on this side.
> 
> It does work, intel even used it for one of there tiny x86 SoCs. Maybe
> it was Newton?

IIRC those SoCs did not use standard EFI/ACPI though, but rather some
other special firmware, I think it was SFI ?  This is not so much about
the CPU architecture as it is about the firmware/bootloader <->
OS interface.

Note I'm not saying this can not be done with EFI/ACPI systems, but
I think it has never been tried.

Regards,

Hans

