Return-Path: <netdev+bounces-100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2933B6F5261
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF23B280FB8
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B0C4A1E;
	Wed,  3 May 2023 07:55:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23435138F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E66C433EF;
	Wed,  3 May 2023 07:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683100552;
	bh=FZMKes64ZPppiPezNOHRmqzODpBye3KiXu+nc+tWIhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DGq4koC1vPyO7XupIKVDi3uZXrcwJiz9Uv4oyLnDFOHU7xwcFaO8ELMl2JWrNVVM6
	 4eqJZYVHUWbabsA2O53GS2qtBiwY6oEpRhzEZBXr+zYyd/7qPOQARzFkGWjsL7swmQ
	 eBAUcB27nYzIckSkL6iE4DbbnX1q6CH4YSUdn2tdxlbNUxCAab137X5LPZ94PGvxQ4
	 c/yq5lRlk4BCuM/MPNRhIlx+QPG/B69rZFvA7GN9DkC63YzYo8mWA9zQ3hbJbjHvMz
	 7ksS95eeVUlFnTJwHrpoNJP/rq5p45z6Zm+R9ByEB1vmXuiXkMaT7N4tLvNgvEyeU/
	 BRPAUieR1kzDw==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1pu7LB-0007la-QM; Wed, 03 May 2023 09:55:57 +0200
Date: Wed, 3 May 2023 09:55:57 +0200
From: Johan Hovold <johan@kernel.org>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Johan Hovold <johan+linaro@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Matthias Kaehlcke <mka@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Bluetooth: fix invalid-bdaddr quirk for
 non-persistent setup
Message-ID: <ZFITjVD_7nPYUgjf@hovoldconsulting.com>
References: <20230424133542.14383-1-johan+linaro@kernel.org>
 <20230424133542.14383-2-johan+linaro@kernel.org>
 <CABBYNZ++1hjeP9r-3Y4j6gPx42-Gk6dNZOYzuRe5bgdz+YHL6g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZ++1hjeP9r-3Y4j6gPx42-Gk6dNZOYzuRe5bgdz+YHL6g@mail.gmail.com>

On Tue, May 02, 2023 at 04:44:48PM -0700, Luiz Augusto von Dentz wrote:
> Hi Johan,
> 
> On Mon, Apr 24, 2023 at 6:35 AM Johan Hovold <johan+linaro@kernel.org> wrote:
> >
> > Devices that lack persistent storage for the device address can indicate
> > this by setting the HCI_QUIRK_INVALID_BDADDR which causes the controller
> > to be marked as unconfigured until user space has set a valid address.
> >
> > Once configured, the device address must be set on every setup for
> > controllers with HCI_QUIRK_NON_PERSISTENT_SETUP to avoid marking the
> > controller as unconfigured and requiring the address to be set again.
> >
> > Fixes: 740011cfe948 ("Bluetooth: Add new quirk for non-persistent setup settings")
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >  net/bluetooth/hci_sync.c | 28 +++++++++++-----------------
> >  1 file changed, 11 insertions(+), 17 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > index a8785126df75..f45598b5a532 100644
> > --- a/net/bluetooth/hci_sync.c
> > +++ b/net/bluetooth/hci_sync.c
> > @@ -4573,23 +4573,17 @@ static int hci_dev_setup_sync(struct hci_dev *hdev)
> >         invalid_bdaddr = test_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks);
> >
> >         if (!ret) {
> > -               if (test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks)) {
> > -                       if (!bacmp(&hdev->public_addr, BDADDR_ANY))
> > -                               hci_dev_get_bd_addr_from_property(hdev);
> > -
> > -                       if (bacmp(&hdev->public_addr, BDADDR_ANY) &&
> > -                           hdev->set_bdaddr) {
> > -                               ret = hdev->set_bdaddr(hdev,
> > -                                                      &hdev->public_addr);
> > -
> > -                               /* If setting of the BD_ADDR from the device
> > -                                * property succeeds, then treat the address
> > -                                * as valid even if the invalid BD_ADDR
> > -                                * quirk indicates otherwise.
> > -                                */
> > -                               if (!ret)
> > -                                       invalid_bdaddr = false;
> > -                       }
> > +               if (test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks) &&
> > +                   !bacmp(&hdev->public_addr, BDADDR_ANY))
> > +                       hci_dev_get_bd_addr_from_property(hdev);
> > +
> > +               if ((invalid_bdaddr ||
> > +                    test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks)) &&
> > +                   bacmp(&hdev->public_addr, BDADDR_ANY) &&
> > +                   hdev->set_bdaddr) {
> > +                       ret = hdev->set_bdaddr(hdev, &hdev->public_addr);
> > +                       if (!ret)
> > +                               invalid_bdaddr = false;
> 
> I'd keep the original comments since it appears you haven't changed
> its logic with respect to invalid_bdaddr.

The comment no longer applies as set_bdaddr can now be called also when
there is no "device property" holding the address (e.g. when one has
been set using btmgmt and HCI_QUIRK_NON_PERSISTENT_SETUP is set).

And obviously we shouldn't mark the controller as unconfigured after
we've successfully set an address.

Johan

