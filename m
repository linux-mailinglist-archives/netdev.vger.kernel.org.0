Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701AE67981E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 13:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbjAXMb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 07:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjAXMb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 07:31:28 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5ED170F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 04:31:26 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30OCURhB046356
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 12:30:30 GMT
Received: from miraculix.mork.no ([IPv6:2a01:799:c9a:3202:549f:9f7a:c9d8:875b])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 30OCUMPb611792
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 13:30:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674563422; bh=6l8RoV/7zzFJTp/dFD410fdMGjzFaQJChmenaJ4kn0I=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=MrU4z6MGP8rCS93aal3b6Vtknzhz0wEaZ2Sdt/e/h3GS7N05BsPdBAoXYCJNKvzTa
         Rj397RVmPsE/8Po55wlB9+wxHw5PztSMTASbSZ+j/OI/XNp42WKDI5UfvO8KVI6dX3
         IbT5KFoow6lRY1vRgFZnIT0z2g6RcMCZCjbdP96g=
Received: (nullmailer pid 708469 invoked by uid 1000);
        Tue, 24 Jan 2023 12:30:20 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v3 net 1/3] net: mediatek: sgmii: ensure the SGMII PHY
 is powered down on configuration
Organization: m
References: <20230122212153.295387-1-bjorn@mork.no>
        <20230122212153.295387-2-bjorn@mork.no>
        <a9e7d8f528828c0c7cd0966a4f3023027425011b.camel@redhat.com>
Date:   Tue, 24 Jan 2023 13:30:20 +0100
In-Reply-To: <a9e7d8f528828c0c7cd0966a4f3023027425011b.camel@redhat.com>
        (Paolo Abeni's message of "Tue, 24 Jan 2023 13:19:15 +0100")
Message-ID: <87lelsp12b.fsf@miraculix.mork.no>
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

Paolo Abeni <pabeni@redhat.com> writes:
> On Sun, 2023-01-22 at 22:21 +0100, Bj=C3=B8rn Mork wrote:
>> From: Alexander Couzens <lynxis@fe80.eu>
>>=20
>> The code expect the PHY to be in power down which is only true after res=
et.
>> Allow changes of the SGMII parameters more than once.
>>=20
>> Only power down when reconfiguring to avoid bouncing the link when there=
's
>> no reason to - based on code from Russell King.
>>=20
>> There are cases when the SGMII_PHYA_PWD register contains 0x9 which
>> prevents SGMII from working. The SGMII still shows link but no traffic
>> can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
>> taken from a good working state of the SGMII interface.
>
> This looks like a legitimate fix for -net, but we need a suitable Fixes
> tag pointing to the culprit commit.
>
> Please repost including such tag. While at that you could also consider
> including Simon's suggestion.

Thanks.  Will do.  Taking advantage of the hole is a good idea.

> The following 2 patches looks like new features/refactor that would be
> more suitable for net-next, and included here due to the code
> dependency.
>
> If so, please repost the later 2 separately for net-next after the fix
> will land there.

I believe all these 3 patches are fixes and therefore appropriate for
net.  I will verify and add Fixes tags for all of them.


Bj=C3=B8rn
