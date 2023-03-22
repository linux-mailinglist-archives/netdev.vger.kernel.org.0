Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DC06C4955
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCVLk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCVLk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:40:58 -0400
X-Greylist: delayed 813 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Mar 2023 04:40:55 PDT
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9C450737
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:40:55 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.17.1.9/8.17.1.9) with ESMTPSA id 32MBQkO9222369
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 11:26:48 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 32MBQeNo915764
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 12:26:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1679484401; bh=o/ZNQD+hmv6MjEEnIv0f/NKtQNeWe+VyQPGQN+Ba0Yw=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=QS7xk/nX7pkAggtCAUk0epWuonr+iQkNMoZOUPjBGj5K7j1twqZ6sAJra+M3+eoYq
         pA34GtecGf94kki/xWYNJmgXFruKY38P5FJ8EoVh4e42kANXJWHY07WVqS8GooP/tu
         JSARHgrWTgkzmAy6huKaXYnlg+OA985Xx5ZyYR4Y=
Received: (nullmailer pid 2310025 invoked by uid 1000);
        Wed, 22 Mar 2023 11:26:40 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jan Hoffmann <jan@3e8.eu>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        openwrt-devel@lists.openwrt.org,
        Sander Vanheule <sander@svanheule.net>,
        erkin.bozoglu@xeront.com
Subject: Re: [PATCH 0/6] realtek: fix management of mdb entries
Organization: m
References: <20230303214846.410414-1-jan@3e8.eu>
        <dd0c8abb-ebb7-8ea5-12ed-e88b5e310a28@arinc9.com>
        <20230306134636.p2ufzoqk6kf3hu3y@skbuf>
Date:   Wed, 22 Mar 2023 12:26:40 +0100
In-Reply-To: <20230306134636.p2ufzoqk6kf3hu3y@skbuf> (Vladimir Oltean's
        message of "Mon, 6 Mar 2023 15:46:36 +0200")
Message-ID: <874jqdjabz.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> As a way to fix a bug quickly and get correct behavior, I guess there's
> also the option of stopping to process multicast packets in hardware,
> and configure the switch to always send any multicast to the CPU port
> only.

I don't think that's an option.  The CPU is dimensioned for switch
management. For the RTL838x, using the current ethernet driver, it tends
to break down completely at 30-40 Mbits/s.

Multicast offloading is necessary to be able to use one of these devices
for e.g IPTV.  Which definitely is a relevant use case.


Bj=C3=B8rn
