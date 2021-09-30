Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4336941DF30
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352174AbhI3Qku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352163AbhI3Qkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 12:40:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 843FB615E0;
        Thu, 30 Sep 2021 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633019946;
        bh=l4psnDS2L4mNszZp3eSV39BLlsLnxaYRmZiaPEPx/DM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDo+iZBLh61LjGBdXtXCGg7fsozqORH2v8dvTewaNZuP59U/Tsyw6NNHDzlLGYhBo
         CF9isbBPlTNlRlq7dCzjxMalsuQvDx6tXPcmP6f16p2QZb2SabvCEmSBo06LdJWhTN
         OojibY9LjoCfTYpycpQmrt4vdbw0OHqS0Wmn40pBQU6CLxnexuJf5LJKksESIdZAvF
         XcddVlKSFw1KCtom961I8wGjttZ5Rpktiy3T4+cjjm9U0BIGTCy5WD2EPRNBEWtLNm
         WJA8/cUlExi3NbnzJbwTjSmds5GYJzQKYu6z/Bskr/1+lWC+034E8CZXffMcc6Q/Bk
         tBO+WvnLLZC+w==
Received: by pali.im (Postfix)
        id 466D7E79; Thu, 30 Sep 2021 18:39:04 +0200 (CEST)
Date:   Thu, 30 Sep 2021 18:39:04 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
Message-ID: <20210930163904.asr3ugj7oj7l2arx@pali>
References: <CA+ASDXNMhrxX-nFrr6kBo0a0c-25+Ge2gBP2uTjE8UWJMeQO2A@mail.gmail.com>
 <bd64c142-93d0-c348-834c-34ed80c460f9@v0yd.nl>
 <e4cbf804-c374-79a3-53ac-8a0fbd8f75b8@v0yd.nl>
 <CAHp75Vd5iCLELx8s+Zvcj8ufd2bN6CK26soDMkZyC1CwMO2Qeg@mail.gmail.com>
 <20210923202231.t2zjoejpxrbbe5hc@pali>
 <db583b3c-6bfc-d765-a588-eb47c76cea31@v0yd.nl>
 <20210930154202.cvw3it3edv7pmqtb@pali>
 <6ba104fa-a659-c192-4dc0-291ca3413f99@v0yd.nl>
 <20210930161905.5a552go73c2o4e7l@pali>
 <4e4f3b6a-25c6-289f-2de0-660aeee2b695@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e4f3b6a-25c6-289f-2de0-660aeee2b695@v0yd.nl>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 30 September 2021 18:22:42 Jonas Dreßler wrote:
> On 9/30/21 6:19 PM, Pali Rohár wrote:
> > On Thursday 30 September 2021 18:14:04 Jonas Dreßler wrote:
> > > On 9/30/21 5:42 PM, Pali Rohár wrote:
> > > > On Thursday 30 September 2021 17:38:43 Jonas Dreßler wrote:
> > > > > On 9/23/21 10:22 PM, Pali Rohár wrote:
> > > > > > On Thursday 23 September 2021 22:41:30 Andy Shevchenko wrote:
> > > > > > > On Thu, Sep 23, 2021 at 6:28 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
> > > > > > > > On 9/22/21 2:50 PM, Jonas Dreßler wrote:
> > > > > > > 
> > > > > > > ...
> > > > > > > 
> > > > > > > > - Just calling mwifiex_write_reg() once and then blocking until the card
> > > > > > > > wakes up using my delay-loop doesn't fix the issue, it's actually
> > > > > > > > writing multiple times that fixes the issue
> > > > > > > > 
> > > > > > > > These observations sound a lot like writes (and even reads) are actually
> > > > > > > > being dropped, don't they?
> > > > > > > 
> > > > > > > It sounds like you're writing into a not ready (fully powered on) device.
> > > > > > 
> > > > > > This reminds me a discussion with Bjorn about CRS response returned
> > > > > > after firmware crash / reset when device is not ready yet:
> > > > > > https://lore.kernel.org/linux-pci/20210922164803.GA203171@bhelgaas/
> > > > > > 
> > > > > > Could not be this similar issue? You could check it via reading
> > > > > > PCI_VENDOR_ID register from config space. And if it is not valid value
> > > > > > then card is not really ready yet.
> > > > > > 
> > > > > > > To check this, try to put a busy loop for reading and check the value
> > > > > > > till it gets 0.
> > > > > > > 
> > > > > > > Something like
> > > > > > > 
> > > > > > >      unsigned int count = 1000;
> > > > > > > 
> > > > > > >      do {
> > > > > > >        if (mwifiex_read_reg(...) == 0)
> > > > > > >          break;
> > > > > > >      } while (--count);
> > > > > > > 
> > > > > > > 
> > > > > > > -- 
> > > > > > > With Best Regards,
> > > > > > > Andy Shevchenko
> > > > > 
> > > > > I've tried both reading PCI_VENDOR_ID and the firmware status using a busy
> > > > > loop now, but sadly none of them worked. It looks like the card always
> > > > > replies with the correct values even though it sometimes won't wake up after
> > > > > that.
> > > > > 
> > > > > I do have one new observation though, although I've no clue what could be
> > > > > happening here: When reading PCI_VENDOR_ID 1000 times to wakeup we can
> > > > > "predict" the wakeup failure because exactly one (usually around the 20th)
> > > > > of those 1000 reads will fail.
> > > > 
> > > > What does "fail" means here?
> > > 
> > > ioread32() returns all ones, that's interpreted as failure by
> > > mwifiex_read_reg().
> > 
> > Ok. And can you check if PCI Bridge above this card has enabled CRSSVE
> > bit (CRSVisible in RootCtl+RootCap in lspci output)? To determinate if
> > Bridge could convert CRS response to all-ones as failed transaction.
> > 
> 
> Seems like that bit is disabled:
> > RootCap: CRSVisible-
> > RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-

So it means that CRSSVE is unsupported by upper bridge. In case card
returns CRS response to system (via bridge) that is not ready yet,
bridge re-issue read request, and after some failures it returns to
system all-ones to indicate failed transaction. But all-ones can be
returned also by bridge when card does not send any response.

So from this test we do not know what happened. It would be nice to know
it, but such test requires to connect this card into system which
supports CRSSVE, in which case CRS response it passed directly to OS as
value 0xffff0001. Look at the link above where I discussed with Bjorn
about buggy wifi cards which resets internally, for more details.

But in this setup when CRSSVE is not supported, I think there is no
other option than just adding sleep prior accessing card...

For debugging such issues I got the only advice to use PCIe analyzer and
look at what is really happening on the bus. But required equipment for
this debugging is not cheap...

> > > > 
> > > > > Maybe the firmware actually tries to wake up,
> > > > > encounters an error somewhere in its wakeup routines and then goes down a
> > > > > special failure code path. That code path keeps the cards CPU so busy that
> > > > > at some point a PCI_VENDOR_ID request times out?
> > > > > 
> > > > > Or well, maybe the card actually wakes up fine, but we don't receive the
> > > > > interrupt on our end, so many possibilities...
