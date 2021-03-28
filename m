Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B1C34BEA6
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 21:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhC1T7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 15:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhC1T6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 15:58:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 459A261477;
        Sun, 28 Mar 2021 19:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616961533;
        bh=4NUAVBaMypj7d1A+DL+VHh2KO4VM/TobWc73V8gAcSg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=pEjHvaLYV61mFlV5diapBBYlnnZ1YxWskcYw2tYybAhxDeeCATqyeZfCURSvAd+gy
         UY0gAwrh/ceGYWYOd4NzBVAiHVGkFcfrNaih0xurxpMchH1AkM4QR+vr1tdB8gb/xq
         6z0r6oLNxL9PjNXRXnJH8TjdrGsNy7bXlmm0N/tzpK2dLxPpz229SBOwfku8oox1kZ
         C+gMpNFdbb8+XpW6MkeiwNOTisDHaHjARTLiF3+OCugesT/JETxukfUxbM7uXNTFX5
         wkpSBIb4EqOsjSZ7Km0SCkUg9ZtLuFr4N16AEXxczc7vUY2qazphpTOc9iX1Kl5ndH
         CDnEfywdSJR0A==
Date:   Sun, 28 Mar 2021 14:58:52 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Chen <Peter.Chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
Message-ID: <20210328195852.GA1088869@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b59c7b3-6e41-b7cf-b77d-274a88f2c5e1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 12:04:35AM +0100, Heiner Kallweit wrote:
> On 26.03.2021 22:26, Bjorn Helgaas wrote:
> > [+cc Randy, Andrew (though I'm sure you have zero interest in this
> > ancient question :))]
> > 
> > On Wed, Dec 09, 2020 at 09:31:21AM +0100, Heiner Kallweit wrote:
> >> pci_set_mwi() and pci_try_set_mwi() do exactly the same, just that the
> >> former one is declared as __must_check. However also some callers of
> >> pci_set_mwi() have a comment that it's an optional feature. I don't
> >> think there's much sense in this separation and the use of
> >> __must_check. Therefore remove pci_try_set_mwi() and remove the
> >> __must_check attribute from pci_set_mwi().
> >> I don't expect either function to be used in new code anyway.
> > 
> > There's not much I like better than removing things.  But some
> > significant thought went into adding pci_try_set_mwi() in the first
> > place, so I need a little more convincing about why it's safe to
> > remove it.
> > 
> 
> Thanks for the link to the 13 yrs old discussion. Unfortunately it
> doesn't mention any real argument for the __must_check, just:
> 
> "And one of the reasons for adding the __must_check annotation is to
> weed out design errors."
> And the very next response in the discussion calls this a "non-argument".
> Plus not mentioning what the other reasons could be.

I think you're referring to Alan's response [1]:

  akpm> And we *need* to be excessively anal in the PCI setup code.
  akpm> We have metric shitloads of bugs due to problems in that area,
  akpm> and the more formality and error handling and error reporting
  akpm> we can get in there the better off we will be.

  ac> No argument there

So Alan is actually *agreeing* that "we need to be excessively anal in
the PCI setup code,"  not saying that "weeding out design errors is
not an argument for __must_check."

> Currently we have three ancient drivers that bail out if the call fails.
> Most callers of pci_set_mwi() use the return code only to emit an
> error message, but they proceed normally. Majority of users calls
> pci_try_set_mwi(). And as stated in the commit message I don't expect
> any new usage of pci_set_mwi().

I would love to merge this patch.  We just need to clarify the commit
log.  Right now the only justification is "I don't think there's much
sense in the __must_check annotation," which may well be true but
could use some support.

If MWI is purely an optimization and there's never a functional
problem if pci_set_mwi() fails, we should say that (and maybe
update any drivers that bail out on failure).

Andrew and Alan both seem to agree that MSI *is* purely advisory:

  akpm> pci_set_mwi() is an advisory thing, and on certain platforms
  akpm> it might fail to set the cacheline size to the desired number.
  akpm> This is not a fatal error and the driver can successfully run
  akpm> at a lesser performance level.

  ac> Correct.

But even after that, Andrew proposed adding pci_try_set_mwi().  So it
makes sense to really understand what was going on there so we don't
break something in the name of cleaning it up.

[1] https://lore.kernel.org/linux-ide/20070405211609.5263d627@the-village.bc.nu/

> > The argument should cite the discussion about adding it.  I think one
> > of the earliest conversations is here:
> > https://lore.kernel.org/linux-ide/20070404213704.224128ec.randy.dunlap@oracle.com/
