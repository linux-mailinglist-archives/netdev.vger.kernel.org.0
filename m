Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF1F631341
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 10:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiKTJxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 04:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiKTJxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 04:53:09 -0500
X-Greylist: delayed 761 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Nov 2022 01:53:07 PST
Received: from canardo.dyn.mork.no (fwa5cad-106.bb.online.no [88.92.173.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B609D14D26
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 01:53:07 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9c:2c02:34cc:c78d:869d:3d9d])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 2AK9dRTi1652278
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Sun, 20 Nov 2022 10:39:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1668937168; bh=PdJ+aYpOmlHpVIzjVD0/OwJIdZrqeCtt7pLRP1OQdA4=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=FWoAhED8NgfgPwClN+0HaFpV6YXLn98xUYyg+50nl2kC6dO/fc2g5DsYL8gLEHVgv
         N+vv6AP3S3vcIQ9eXmMLIDWXIyZbqi9/qw+0OqZVFbMvQooX/fqW/HY1S+xUAZ7WwI
         VRHOHTD5iioqdxm/aHtjzNfOSzJ0JFgxAvrT42CU=
Received: (nullmailer pid 155756 invoked by uid 1000);
        Sun, 20 Nov 2022 09:39:27 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
Organization: m
References: <20221109180249.4721-1-dnlplm@gmail.com>
        <20221109180249.4721-3-dnlplm@gmail.com>
        <20221110173222.3536589-1-alexandr.lobakin@intel.com>
        <CAGRyCJHmNgzVVnGunUh7wwKxYA7GzSvfgqPDAxL+-NcO2P+1wg@mail.gmail.com>
        <20221116162016.3392565-1-alexandr.lobakin@intel.com>
        <CAGRyCJHX9WMeHLBgh5jJj2mNJh3hqzAhHacVnLqP_CpoHQaTaw@mail.gmail.com>
Date:   Sun, 20 Nov 2022 10:39:27 +0100
In-Reply-To: <CAGRyCJHX9WMeHLBgh5jJj2mNJh3hqzAhHacVnLqP_CpoHQaTaw@mail.gmail.com>
        (Daniele Palmas's message of "Sun, 20 Nov 2022 10:25:53 +0100")
Message-ID: <87tu2unewg.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SORBS_DUL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniele Palmas <dnlplm@gmail.com> writes:

> Ok, so rmnet would only take care of qmap rx packets deaggregation and
> qmi_wwan of the tx aggregation.
>
> At a conceptual level, implementing tx aggregation in qmi_wwan for
> passthrough mode could make sense, since the tx aggregation parameters
> belong to the physical device and are shared among the virtual rmnet
> netdevices, which can't have different aggr configurations if they
> belong to the same physical device.
>
> Bj=C3=B8rn, would this approach be ok for you?

Sounds good to me, if this can be done within the userspace API
restrictions we've been through.

I assume it's possible to make this Just Work(tm) in qmi_wwan
passthrough mode?  I do not think we want any solution where the user
will have to configure both qmi_wwan and rmnet to make things work
properly.


Bj=C3=B8rn
