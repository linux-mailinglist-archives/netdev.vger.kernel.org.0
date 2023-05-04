Return-Path: <netdev+bounces-259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3378F6F6744
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 803611C20986
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE5984A39;
	Thu,  4 May 2023 08:26:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553B41C10
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F311DC433EF;
	Thu,  4 May 2023 08:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683188787;
	bh=rcaycbeN8aPOjP9E5Mbp7ZhlZYzPrs40+UjyKL7xQXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OcsYHAUx9pW2KkBahMehpenMUQCkGke3bY/1G5R6e89EXzRf8GkLlvzyNcqCTTkAQ
	 41Ze/gCJZoVWE8oDBLRwjiQ8VFbs2Y5gQo5dA1OUaqaSdtUJ3B6Hy6UAK8UZmLya19
	 cVsVC3prmiOyuWEftJhEqUmDesq2duZEdGygqhb1sishq7x3SPOXRdyxWIMljHHKKA
	 25IWhSiM+JbBQRCb7s8CDumiPuvPgnMKCgPjkn1tR4eoGIFbyw/URvm/zD/l3iNjiA
	 0hxqjeiV+1n01JsC/cYOdPkcUjbpcCtOTSssMILIKXQQ/Ar02d9eEzUgAVszYp3L+Y
	 gYvJwkRVUxUPg==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1puUIM-0005Nf-5x; Thu, 04 May 2023 10:26:34 +0200
Date: Thu, 4 May 2023 10:26:34 +0200
From: Johan Hovold <johan@kernel.org>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Johan Hovold <johan+linaro@kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Bluetooth: fix debugfs registration
Message-ID: <ZFNsOm7GvSkBi4Tc@hovoldconsulting.com>
References: <20230424124852.12625-1-johan+linaro@kernel.org>
 <20230424124852.12625-2-johan+linaro@kernel.org>
 <CABBYNZLBQjWVb=z8mffi4RmeKS-+RDLV+XF8bR2MiJ-ZOaFVHA@mail.gmail.com>
 <ZFIHj9OAJkRvSscs@hovoldconsulting.com>
 <CABBYNZJ23E50J2gfi5NgHj_bXMuVTHk29s+BH-zMhhWmRsd0Pg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZJ23E50J2gfi5NgHj_bXMuVTHk29s+BH-zMhhWmRsd0Pg@mail.gmail.com>

On Wed, May 03, 2023 at 10:34:06AM -0700, Luiz Augusto von Dentz wrote:
> Hi Johan,
> 
> On Wed, May 3, 2023 at 12:04 AM Johan Hovold <johan@kernel.org> wrote:
> >
> > On Tue, May 02, 2023 at 04:37:51PM -0700, Luiz Augusto von Dentz wrote:
> > > Hi Johan,
> > >
> > > On Mon, Apr 24, 2023 at 5:50 AM Johan Hovold <johan+linaro@kernel.org> wrote:
> > > >
> > > > Since commit ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for
> > > > unconfigured controllers") the debugfs interface for unconfigured
> > > > controllers will be created when the controller is configured.
> > > >
> > > > There is however currently nothing preventing a controller from being
> > > > configured multiple time (e.g. setting the device address using btmgmt)
> > > > which results in failed attempts to register the already registered
> > > > debugfs entries:
> > > >
> > > >         debugfs: File 'features' in directory 'hci0' already present!
> > > >         debugfs: File 'manufacturer' in directory 'hci0' already present!
> > > >         debugfs: File 'hci_version' in directory 'hci0' already present!
> > > >         ...
> > > >         debugfs: File 'quirk_simultaneous_discovery' in directory 'hci0' already present!
> > > >
> > > > Add a controller flag to avoid trying to register the debugfs interface
> > > > more than once.
> > > >
> > > > Fixes: ec6cef9cd98d ("Bluetooth: Fix SMP channel registration for unconfigured controllers")
> > > > Cc: stable@vger.kernel.org      # 4.0
> > > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > > > ---
> >
> > > > diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> > > > index 632be1267288..a8785126df75 100644
> > > > --- a/net/bluetooth/hci_sync.c
> > > > +++ b/net/bluetooth/hci_sync.c
> > > > @@ -4501,6 +4501,9 @@ static int hci_init_sync(struct hci_dev *hdev)
> > > >             !hci_dev_test_flag(hdev, HCI_CONFIG))
> > > >                 return 0;
> > > >
> > > > +       if (hci_dev_test_and_set_flag(hdev, HCI_DEBUGFS_CREATED))
> > > > +               return 0;
> > >
> > > Can't we just use HCI_SETUP like we do with in create_basic:
> > >
> > >     if (hci_dev_test_flag(hdev, HCI_SETUP))
> > >         hci_debugfs_create_basic(hdev);
> > >
> > > Actually we might as well move these checks directly inside the
> > > hci_debugfs function to make sure these only take effect during the
> > > setup/first init.
> >
> > The problem is that commit ec6cef9cd98d ("Bluetooth: Fix SMP channel
> > registration for unconfigured controllers") started deferring creation
> > of most parts of the debugfs interface until the controller is
> > configured (e.g. as some information is not available until then).
> >
> > Moving everything back to setup-time would effectively revert that.
> 
> Not moving back but just doing something like:
> 
> diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
> index ec0df2f9188e..a6e94c29fc5a 100644
> --- a/net/bluetooth/hci_debugfs.c
> +++ b/net/bluetooth/hci_debugfs.c
> @@ -310,6 +310,9 @@ DEFINE_INFO_ATTRIBUTE(firmware_info, fw_info);
> 
>  void hci_debugfs_create_common(struct hci_dev *hdev)
>  {
> +       if (!hci_dev_test_flag(hdev, HCI_SETUP))
> +               return;
> +
>         debugfs_create_file("features", 0444, hdev->debugfs, hdev,
>                             &features_fops);
>         debugfs_create_u16("manufacturer", 0444, hdev->debugfs,
> 

What I tried to explain above is that doing this would always create
the attributes as setup-time rather than at config-time, which
effectively reverts commit ec6cef9cd98d ("Bluetooth: Fix SMP channel
registration for unconfigured controllers"). And doing so looks like it
would amount to a regression.

Johan

