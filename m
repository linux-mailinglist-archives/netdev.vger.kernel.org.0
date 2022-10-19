Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E5E604AEB
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiJSPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiJSPM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:12:57 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD39616D886;
        Wed, 19 Oct 2022 08:05:13 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9c:2c00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 29JF4akO009427
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 16:04:38 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9c:2c02:34cc:c78d:869d:3d9d])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 29JF4VnP052259
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 19 Oct 2022 17:04:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1666191871; bh=LJCnM3YAgkdlJZWdcjae8h64Q6JFjYVZRen0elz/ql8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=mtHHmh8fOheuKiLEub3V7z/OotTNSy7j1gETxlE7wAB1KlMoNzPaJ3TZfumcxyOgW
         BF0bQS4F/OulIS3MvbwIqtmnlvl/jbSmAQEsDUNAXzxDDwIaeMdp0LhlI3Hop5U2hV
         +MJXRmSitvO8w2WGqaXqQixtDQSNfr+gUZVEtXCA=
Received: (nullmailer pid 11689 invoked by uid 1000);
        Wed, 19 Oct 2022 15:04:31 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: usb: qmi_wwan implement tx packets
 aggregation
Organization: m
References: <20221019132503.6783-1-dnlplm@gmail.com>
Date:   Wed, 19 Oct 2022 17:04:31 +0200
In-Reply-To: <20221019132503.6783-1-dnlplm@gmail.com> (Daniele Palmas's
        message of "Wed, 19 Oct 2022 15:25:01 +0200")
Message-ID: <87lepbsvls.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> I verified this problem by using a MDM9207 Cat. 4 based modem (50Mbps/150=
Mbps
> max throughput). What is actually happening is pictured at
> https://drive.google.com/file/d/1xuAuDBfBEIM3Cdg2zHYQJ5tdk-JkfQn7/view?us=
p=3Dsharing
>
> When rx and tx flows are tested singularly there's no issue in tx and min=
or
> issues in rx (a few spikes). When there are concurrent tx and rx flows, tx
> throughput has an huge drop. rx a minor one, but still present.
>
> The same scenario with tx aggregation enabled is pictured at
> https://drive.google.com/file/d/1Kw8TVFLVgr31o841fRu4fuMX9DNZqJB5/view?us=
p=3Dsharing
> showing a regular graph.

That's pretty extreme.  Are these tcp tests?  Did you experiment with
qdisc options? What about latency here?

> This issue does not happen with high-cat modems (e.g. SDX20), or at least=
 it
> does not happen at the throughputs I'm able to test currently: maybe the =
same
> could happen when moving close to the maximum rates supported by those mo=
dems.
> Anyway, having the tx aggregation enabled should not hurt.
>
> It is interesting to note that, for what I can understand, rmnet too does=
 not
> support tx aggregation.

Looks like that is missing, yes. Did you consider implementing it there
instead?

> I'm aware that rmnet should be the preferred way for qmap, but I think th=
ere's
> still value in adding this feature to qmi_wwan qmap implementation since =
there
> are in the field many users of that.
>
> Moreover, having this in mainline could simplify backporting for those wh=
o are
> using qmi_wwan qmap feature but are stuck with old kernel versions.
>
> I'm also aware of the fact that sysfs files for configuration are not the
> preferred way, but it would feel odd changing the way for configuring the=
 driver
> just for this feature, having it different from the previous knobs.

It's not just that it's not the preferred way.. I believe I promised
that we wouldn't add anything more to this interface.  And then I broke
that promise, promising that it would never happen again.  So much for
my integrity.

This all looks very nice to me, and the results are great, and it's just
another knob...

But I don't think we can continue adding this stuff.  The QMAP handling
should be done in the rmnet driver. Unless there is some reason it can't
be there? Wouldn't the same code work there?

Luckily I can chicken out here, and leave final the decision to Jakub
and David.



Bj=C3=B8rn
