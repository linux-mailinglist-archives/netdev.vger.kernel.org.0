Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213446F147D
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345402AbjD1Jru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjD1Jrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:47:49 -0400
Received: from mail-40136.proton.ch (mail-40136.proton.ch [185.70.40.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99E32701
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 02:47:47 -0700 (PDT)
Date:   Fri, 28 Apr 2023 09:47:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samwein.com;
        s=protonmail3; t=1682675265; x=1682934465;
        bh=400q36v16Um8iOhsXu7kYx5iF4YbEJN7im8EQlHzc30=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=e5fjtKn/I/qrB+g6FjwZ6mVkIwo5jyY/uVsNLS7DH2Hl/N27Hey6Xr7659u+M8ATp
         4y/vm/V8NEG2TJs2lotW3IIgeYHg46b52s99+olIYaIKZLnJi3tfvzbMnxPfc7xbjw
         /Zv2zzeqGYK6PLU/2bSTSYvHh3UyI2HrvILkCuH9zqSvxBh3+jbprO8K4ZyepWgiop
         V4H9+Iu1xvgv/av1mSKr3ipHgtl9a2FcSHPLiCs5Ld4zxr75wFUZuKArB9n+nD8V2w
         30GbbGfJnPhoNppxvf2oCtZP4zDC7UTR7jGjnkCQWxC0gsskJuyNhC+ydOSX07J3Si
         ZX2PhXsO88GQA==
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
From:   Samuel Wein PhD <sam@samwein.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
Subject: RE: NULL pointer dereference when removing xmm7360 PCI device
Message-ID: <dTcfnhONbF32TfGTW1PwZCTLPv23F7YdudIWGSzoIrQ8Kc0Y1L3l5qlfXn4RvrrRxEDVAkDc5K6rbXf11FNRmteF8RztBMYZ1rkTvdp5R34=@samwein.com>
In-Reply-To: <SJ0PR11MB5008C45C06B1DDE78A8CC874D76B9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <Yhw4a065te-PH2rfqCYhLt4RZwLJLek2VsfLDrc8TLjfPqxbw6QKbd7L2PwjA81XlBhUr04Nm8-FjfdSsTlkKnIJCcjqHenPx4cbpRLym-U=@samwein.com> <20230427140819.1310f4bd@kernel.org> <SJ0PR11MB5008C45C06B1DDE78A8CC874D76B9@SJ0PR11MB5008.namprd11.prod.outlook.com>
Feedback-ID: 2153553:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've added the full set of logs to the gist. The sequence was:
boot PC
suspend PC
resume PC
repeat the following several (it varies) times until the error:
`sudo echo 1 > /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/remove`
`echo 1 > /sys/devices/pci0000:00/0000:00:1c.0/rescan`

The XMM7360 card doesn't resume properly from suspend, with the AT devices =
not responding to any commands. I've been working off of some of Shane Pars=
low's code to try to get ModemManager control of the device and was basical=
ly trying a bunch of ways to try to reset the card, this one clearly didn't=
 work, but it also clearly exposed some weirdness in how the kernel handled=
 the attempt. The fact that there is not a proper MBIM interface for this c=
ard really makes managing it difficult.


------- Original Message -------
On Friday, April 28th, 2023 at 11:21 AM, Kumar, M Chetan <m.chetan.kumar@in=
tel.com> wrote:


>=20
>=20
> > -----Original Message-----
>=20
> > From: Jakub Kicinski kuba@kernel.org
> > Sent: Friday, April 28, 2023 2:38 AM
> > To: Kumar, M Chetan m.chetan.kumar@intel.com
> > Cc: Samuel Wein PhD sam@samwein.com; netdev@vger.kernel.org;
> > linuxwwan linuxwwan@intel.com
> > Subject: Re: NULL pointer dereference when removing xmm7360 PCI device
> >=20
> > On Thu, 27 Apr 2023 10:31:29 +0000 Samuel Wein PhD wrote:
> >=20
> > > Hi Folks,
> > > I've been trying to get the xmm7360 working with IOSM and the
> > > ModemManager. This has been what my highschool advisor would call a
> > > "learning process".
> > > When trying `echo 1 > /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00=
.0/remove` I get a
> > > variety of errors. One of these is a kernel error
> > > `2023-04-27T12:23:38.937223+02:00 Nase kernel: [ 587.997430] BUG: ker=
nel NULL pointer dereference, address: 0000000000000048 2023-04-27T12:23:38=
.937237+02:00 Nase kernel: [ 587.997447] #PF: supervisor read access in ker=
nel mode 2023-04-27T12:23:38.937238+02:00 Nase kernel: [ 587.997455] #PF: e=
rror_code(0x0000) - not-present page 2023-04-27T12:23:38.937241+02:00 Nase =
kernel: [ 587.997463] PGD 0 P4D 0 2023-04-27T12:23:38.937242+02:00 Nase ker=
nel: [ 587.997476] Oops: 0000 [#1] PREEMPT SMP NOPTI 2023-04-27T12:23:38.93=
7242+02:00 Nase kernel: [ 587.997489] CPU: 1 PID: 4767 Comm: bash Not taint=
ed 6.3.0-060300-generic #202304232030 ...`
> > > the full log is available at
> > > https://gist.github.com/poshul/0c5ffbde6106a71adcbc132d828dbcd7
> > >=20
> > > Steps to reproduce: Boot device with xmm7360 installed and in PCI mod=
e,
> > > place into suspend. Resume, and start issuing reset/remove commands t=
o
> > > the PCI interface (without properly unloading the IOSM module first).
> > >=20
> > > I'm not sure how widely applicable this is but wanted to at least rep=
ort it.
> >=20
> > Intel folks, PTAL.
>=20
>=20
> I tried reproducing the issue by following the steps you mentioned but so=
 far could not
> reproduce it. Could you please share the logs from boot-up and procedure =
you carried out in steps.
>=20
> Once you boot-up the laptop, driver will be in working condition why devi=
ce removal ?
