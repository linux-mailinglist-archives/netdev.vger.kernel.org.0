Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444264F767F
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241473AbiDGGpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241435AbiDGGpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:45:09 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6689A13E400;
        Wed,  6 Apr 2022 23:43:10 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9f:8600:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 2376h4i2489857
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 07:43:06 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 2376h4dN1754943
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:43:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1649313784; bh=D9SGvO/3scVtMLwH/SMZQk2V+EuVPSVqaiWVdu2IoKQ=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=NRLpxhMVtavVFubMf//zBw0v72ckkWR1k4fGDb/neUh89Yf8Qcn8X2I00agL5XqnR
         0cIAQWnNXkDILAqIBzWFepyEgpYT4hv4Voj7ChAECxBPBSIhvg9F82e6HMXhC31sMc
         +jdhStX/n4R99YkuaWtm7VCipzjFOEa5ixh8tIqM=
Received: (nullmailer pid 687895 invoked by uid 1000);
        Thu, 07 Apr 2022 06:43:04 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 3/3] rndis_host: limit scope of bogus MAC address
 detection to ZTE devices
Organization: m
References: <20220407001926.11252-1-lech.perczak@gmail.com>
        <20220407001926.11252-4-lech.perczak@gmail.com>
Date:   Thu, 07 Apr 2022 08:43:04 +0200
In-Reply-To: <20220407001926.11252-4-lech.perczak@gmail.com> (Lech Perczak's
        message of "Thu, 7 Apr 2022 02:19:26 +0200")
Message-ID: <87ilrl1jif.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.5 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lech Perczak <lech.perczak@gmail.com> writes:

> Reporting of bogus MAC addresses and ignoring configuration of new
> destination address wasn't observed outside of a range of ZTE devices,
> among which this seems to be the common bug. Align rndis_host driver
> with implementation found in cdc_ether, which also limits this workaround
> to ZTE devices.

Reviewed-by: Bj=C3=B8rn Mork <bjorn@mork.no>

Yes, this is a much better solution.

We have no business rejecting the address chosen by the device, even if
it is "locally administered".  The device has every right to use a local
address on a link with no other devices, which is the case for every
cellular modem for example.

And even if we believe the device is wrong there isn't much we can do
about that.

Rejecting the device address, with no way to inform the device about a
new address, implies that host and device disagrees about it.  This does
not fix anything.  It just makes the host to silentlig drop all packets,
leaving the user with a non-working device.

I take full responibility for coming up with the idea of over-
simplifying the original workaround proposed by Kristian. It wasn't very
well thought over.

Thanks to Lech for fixing this!



Bj=C3=B8rn
