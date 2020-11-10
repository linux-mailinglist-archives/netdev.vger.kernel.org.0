Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A279B2ADD3E
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgKJRo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgKJRo3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 12:44:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C85572076E;
        Tue, 10 Nov 2020 17:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605030269;
        bh=A8zVlL/t8rEgJcCsmw7gpjI9i3zi4wwuuGk60Hugyas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UbLB04UnnxKK0p2UVvqQ0Ie8sd1CoS2ruISHbFY4fob4DtEW2qWY4N1msGaBkC8QH
         9ibJyEXkx1j+5+ZogE7KaEqrSW2NmuTKd6GyHjC6gZDLlw0aqIusmbXTdUx6JfG+qA
         QM1U2sp5bv+ZsDPpXVDDRmOQi9HEpiwTIrYK1Jkc=
Date:   Tue, 10 Nov 2020 09:44:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cjhuang@codeaurora.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] net: qrtr: Add distant node support
Message-ID: <20201110094427.5ffb1d1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMZdPi88N8WjA7ZEU0X_dhX_t-kXkAjhnhjzK7TY7HCurrLSqA@mail.gmail.com>
References: <1604684010-24090-1-git-send-email-loic.poulain@linaro.org>
        <20201107162640.357a2b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi-5Qp7jOHDZLZoWKJ4zwU6Sa9ULAts0eY6ObCu91Awx+w@mail.gmail.com>
        <20201109103946.4598e667@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi88N8WjA7ZEU0X_dhX_t-kXkAjhnhjzK7TY7HCurrLSqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 10:03:29 +0100 Loic Poulain wrote:
> On Mon, 9 Nov 2020 at 19:39, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 9 Nov 2020 09:49:24 +0100 Loic Poulain wrote:  
> > > > Looks like patch 1 is a bug fix and patches 2-5 add a new feature.
> > > > Is that correct?  
> > >
> > > That's correct, though strictly speaking 2-5 are also bug fix since remote node
> > > communication is supposed to be supported in QRTR to be compatible with
> > > other implementations (downstream or private implementations).  
> >
> > Is there a spec we can quote to support that, or is QRTR purely
> > a vendor interface?  
> 
> There is no public spec AFAIK, this is a vendor interface.
> 
> > What's the end user issue that we're solving? After firmware upgrade
> > things stop working? Things don't work on HW platforms on which this
> > was not tested? Don't work on new HW platforms?  
> 
> QRTR is usually something used in SoC context as communication
> protocol for accessing the differents IPs (modem, WiFi, DSP, etc)
> around the CPU. In that case, these components (nodes), identified
> with a 'node ID', are directly reachable by the CPU (QRTR over shared
> memory). This case is not impacted by the series, all nodes beeing CPU
> immediate neighbours.
> 
> But today QRTR is no more a ARCH_QCOM thing only, It is also exposed
> as communication channel for QCOM based wireless modules (e.g. SDX55
> modem), over PCIe/MHI. In that case, the host is only connected to the
> Modem CPU QRTR endpoint that in turn gives access to other embedded
> Modem endpoints, acting as a gateway/bridge for accessing
> non-immediate nodes from the host. currently, this case is not working
> and the series fix it.
> 
> However, AFAIK, the only device would request this support is the
> SDX55 PCIe module, that just landed in mhi-next. So I assume it's fine
> if the related part of the series targets net-next.

Thanks! Sounds like net-next will work just fine, but won't you need
these changes in mhi-next, then? In which case you should send a pull
request based on Linus' tree so that both Mani and netdev can pull it
in.

Mani, WDYT?
