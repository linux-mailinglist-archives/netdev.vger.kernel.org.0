Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55606392AF1
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 11:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhE0JmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 05:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbhE0JmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 05:42:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477CDC061574;
        Thu, 27 May 2021 02:40:48 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lmCVP-00FGDj-Fx; Thu, 27 May 2021 11:40:43 +0200
Message-ID: <c7b149f5f3014e02a0b94b11d957cfc73d675ad7.camel@sipsolutions.net>
Subject: Re: [PATCH V3 15/16] net: iosm: net driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>,
        linuxwwan <linuxwwan@intel.com>, Dan Williams <dcbw@redhat.com>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 27 May 2021 11:40:42 +0200
In-Reply-To: <CAMZdPi99Un=AQeUMZUWzudubr2kR6=YciefdaXxYbhebSy+yVQ@mail.gmail.com> (sfid-20210525_165141_517994_A41499CB)
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
         <20210520140158.10132-16-m.chetan.kumar@intel.com>
         <CAMZdPi-Xs00vMq-im_wHnNE5XkhXU1-mOgrNbGnExPbHYAL-rw@mail.gmail.com>
         <90f93c17164a4d8299d17a02b1f15bfa@intel.com>
         <CAMZdPi_VbLcbVA34Bb3uBGDsDCkN0GjP4HmHUbX95PF9skwe2Q@mail.gmail.com>
         <c7d2dd39e82ada5aa4e4d6741865ecb1198959fe.camel@sipsolutions.net>
         <CAMZdPi99Un=AQeUMZUWzudubr2kR6=YciefdaXxYbhebSy+yVQ@mail.gmail.com>
         (sfid-20210525_165141_517994_A41499CB)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Loic,

> Yes, I guess it's all about timings... At least, I care now...

:)

> I've recently worked on the mhi_net driver, which is basically the
> netdev driver for Qualcomm PCIe modems. MHI being similar to IOSM
> (exposing logical channels over PCI). Like QCOM USB variants, data can
> be transferred in QMAP format (I guess what you call QMI), via the
> `rmnet` link type (setup via iproute2).

Right.

(I know nothing about the formats, so if I said anything about 'QMI'
just ignore and think 'qualcomm stuff')

> 
> This a legitimate point, but it's not too late to do the 'right'
> thing, + It should not be too much change in the IOSM driver.

Agree. Though I looked at it now in the last couple of hours, and it's
actually not easy to do.

I came up with these patches for now:
https://p.sipsolutions.net/d8d8897c3f43cb85.txt

(on top of 5.13-rc3 + the patchset we're discussing here)

The key problem is that rtnetlink ops are meant to be for a single
device family, and don't really generalize well. For example:

+static void wwan_rtnl_setup(struct net_device *dev)
+{
+       /* FIXME - how do we implement this? we dont have any data
+        * at this point ..., i.e. we can't look up the context yet?
+        * We'd need data[IFLA_WWAN_DEV_NAME], see wwan_rtnl_newlink().
+        */
+}

or 

+static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
[...]
+       .priv_size = WWAN_MAX_NETDEV_PRIV,

are both rather annoying.

Making this more generic should of course be possible, but would require
fairly large changes all over the kernel - passing the tb/data to all
the handlers involved here, etc. That seems awkward?

What do you think?

The alternative I could see is doing what wifi did and create a
completely new (generic) netlink family, but that's also awkward to some
extend and requires writing more code to handle stuff that rtnetlink
already does ...


Please take a look. I suppose we could change rtnetlink to make it
possible to have this behind it ... but that might even be tricky,
because setup() is called in the context of alloc_netdev_mqs(), and that
also has no private data to pass through. So would we have to extend
rtnetlink ops with a "get_setup()" method that actually *returns* a
pointer to the setup method, so that it can be per-user (such as IOSM)?
Tricky stuff.


> Regarding Qualcomm, I think it should be possible to fit QCOM Modem
> drivers into that solution. It would consist of creating a simple
> wrapper in QMAP/rmnet so that the rmnet link can (also) be created
> from the kernel side (e.g. from mhi_net driver):
> wwan_new_link() => wwan->add_intf_cb() => mhi_net_add_intf() => rmnet_newlink()
> 
> That way mhi_net driver would comply with the new hw agnostic wwan link
> API, without breaking backward compatibility if someone wants to
> explicitly create a rmnet link. Moreover, it could also be applicable
> to USB modems based on MBIM and their VLAN link types.

Maybe. It'd just need some incentive, and there's none now that the
Qualcomm stuff is already there :)

johannes

