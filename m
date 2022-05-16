Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5442152955C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 01:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350410AbiEPXjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 19:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350404AbiEPXjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 19:39:16 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBFF42EFE;
        Mon, 16 May 2022 16:39:13 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L2G166yl7z4xZ2;
        Tue, 17 May 2022 09:39:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1652744351;
        bh=shMAgr3KnLfduKB2nfq7HCfF2fOXsMLLY0bGSFIz4Ms=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QLY2t/FKtddLoKYu8LG0sSKbrlIDbQb907F8fJRC5dkfgoQ4VcE8ZYWVwVOoK7EM4
         xzfu8+So2JKiaEzF7GSQJ9gueS9zaiy8W0ZSlhez0VFXy4Wb0j8KP+yhCabzAY1A+C
         0FgNnaqMk20UWxmOM3R6jumDaJQD3hLDqa2kTOU3pR8ceSVpLscdB0G74mWPjxfypW
         1YbJXhatDs5+BG95Jjxs9mw7zFQliQ6Q027nffmAN+9od+JVIb8Te0z/N9Z2mv7B/v
         RTBKi84QByAmv5PC2z6tmhRB7b8jCnaApdBNfdiJ8XpCmLW2Ws4btTP6KU81mSwIaj
         LQs8XWcGd88vg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Wolfram Sang <wsa@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mark Brown <broonie@kernel.org>,
        chris.packham@alliedtelesis.co.nz,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>
Subject: Re: [PATCH v2 4/4] powerpc/52xx: Convert to use fwnode API
In-Reply-To: <YoJbaTNJFV2A1Etw@smile.fi.intel.com>
References: <20220507100147.5802-1-andriy.shevchenko@linux.intel.com>
 <20220507100147.5802-4-andriy.shevchenko@linux.intel.com>
 <877d6l7fmy.fsf@mpe.ellerman.id.au> <YoJaGGwfoSYhaT13@smile.fi.intel.com>
 <YoJbaTNJFV2A1Etw@smile.fi.intel.com>
Date:   Tue, 17 May 2022 09:38:56 +1000
Message-ID: <874k1p6oa7.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> On Mon, May 16, 2022 at 05:05:12PM +0300, Andy Shevchenko wrote:
>> On Mon, May 16, 2022 at 11:48:05PM +1000, Michael Ellerman wrote:
>> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
>> > > We may convert the GPT driver to use fwnode API for the sake
>> > > of consistency of the used APIs inside the driver.
>> > 
>> > I'm not sure about this one.
>> > 
>> > It's more consistent to use fwnode in this driver, but it's very
>> > inconsistent with the rest of the powerpc code. We have basically no
>> > uses of the fwnode APIs at the moment.
>> 
>> Fair point!
>> 
>> > It seems like a pretty straight-forward conversion, but there could
>> > easily be a bug in there, I don't have any way to test it. Do you?
>> 
>> Nope, only compile testing. The important part of this series is to
>> clean up of_node from GPIO library, so since here it's a user of
>> it I want to do that. This patch is just ad-hoc conversion that I
>> noticed is possible. But there is no any requirement to do so.
>> 
>> Lemme drop this from v3.
>
> I just realize that there is no point to send a v3. You can just apply
> first 3 patches. Or is your comment against entire series?

No, my comment is just about this patch.

I don't mind converting to new APIs when it's blocking some other
cleanup. But given the age of this code I think it's probably better to
just leave the rest of it as-is, unless someone volunteers to test it.

So yeah I'll just take patches 1-3 of this v2 series, no need to resend.

cheers
