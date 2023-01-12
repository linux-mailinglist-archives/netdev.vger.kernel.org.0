Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311A9666FC3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 11:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbjALKgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 05:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236789AbjALKfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 05:35:22 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DDD50F7F;
        Thu, 12 Jan 2023 02:30:07 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30CATjjR1796956
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 10:29:47 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30CATenM3820531
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 11:29:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1673519380; bh=q65tD7oXhhlM7mbc/basdUYlkSC0DmP9LIm8r+kgxPs=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=e0p2iZbr9VQv3xhxrP9rgnAGktc78I+tRa0D7180JoL8SHqlLOmiBSIMaKbQF/B//
         MpwvVcOu6Is/1Fxk/zXyZLv3D3apsDjBidioB5xANWJWPSAEYiYBNeoBWM5QRQ++fr
         22P+rfGT1GbXXhfS9ioP/8yU73hV8LMwq00jC5gQ=
Received: (nullmailer pid 181829 invoked by uid 1000);
        Thu, 12 Jan 2023 10:29:40 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Greg KH <greg@kroah.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] r8152; preserve device list format
Organization: m
References: <87k01s6tkr.fsf@miraculix.mork.no>
        <20230112100100.180708-1-bjorn@mork.no> <Y7/dBXrI2QkiBFlW@kroah.com>
        <87cz7k6ooc.fsf@miraculix.mork.no>
Date:   Thu, 12 Jan 2023 11:29:40 +0100
In-Reply-To: <87cz7k6ooc.fsf@miraculix.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of
        "Thu, 12 Jan 2023 11:18:59 +0100")
Message-ID: <878ri86o6j.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B8rn Mork <bjorn@mork.no> writes:
> Greg KH <greg@kroah.com> writes:
>
>> No need for this, just backport the original change to older kernels and
>> all will be fine.
>>
>> Don't live with stuff you don't want to because of stable kernels,
>> that's not how this whole process works at all :)
>
> OK, thanks.  Will prepare a patch for stable instead then.
>
> But I guess the original patch is unacceptable for stable as-is? It
> changes how Linux react to these devces, and includes a completely new
> USB device driver (i.e not interface driver).

Doh!  I gotta start thinking before I send email.  Will start right
after sending this one ;-)

We cannot backport the device-id table change to stable without taking
the rest of the patch. The strategy used by the old driver needs two
entries per device ID, which is why the macro was there.

So the question is: Can commit ec51fbd1b8a2 ("r8152: add USB device
driver for config selection") be accepted in stable?

( Direct link for convenience since it's not yet in mainline:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/=
drivers/net/usb/r8152.c?id=3Dec51fbd1b8a2bca2948dede99c14ec63dc57ff6b
)

This is not within the rules as I read them, but it's your call...


Bj=C3=B8rn


