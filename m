Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE5526AC2A
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 20:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgIORjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 13:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbgIORjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 13:39:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DC24206E6;
        Tue, 15 Sep 2020 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600191555;
        bh=q6/vtIli3hB216LWuU3XYOwRxBzS3keDJIUS6tSNOJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VFMVR0MLklmoyEleNIMTtjWVVCNaqO+HCd5EJK15kqUb/mD2ZXgD9OyVyn+Gr1kY2
         Sk24sPy9nQ4papEy9c48Y8/vt18FSw2UHpk9htCk+8S3vXaabB/GNNvfh5zKTLw46J
         MCXXCCHmvZa+egc4Mcginytw/e8XHB5EibeRDlKw=
Date:   Tue, 15 Sep 2020 10:39:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200915103913.46cebf69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ad9b1163-fe3b-6793-c799-75a9c4ce87f9@pensando.io>
References: <20200908224812.63434-1-snelson@pensando.io>
        <20200908165433.08afb9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9938e3cc-b955-11a1-d667-8e5893bb6367@pensando.io>
        <20200909094426.68c417fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <581f2161-1c55-31ae-370b-bbea5a677862@pensando.io>
        <20200909122233.45e4c65c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3d75c4be-ae5d-43b0-407c-5df1e7645447@pensando.io>
        <20200910105643.2e2d07f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a04313f7-649e-a928-767c-b9d27f3a0c7c@intel.com>
        <20200914163605.750b0f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3b18d92f-3a0a-c0b0-1b46-ecfd4408038c@pensando.io>
        <7e44037cedb946d4a72055dd0898ab1d@intel.com>
        <f4e4e9c3-b293-cef1-bb84-db7fe691882a@pensando.io>
        <20200915085045.446b854b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4b5e3547f3854fd399b26a663405b1f8@intel.com>
        <ad9b1163-fe3b-6793-c799-75a9c4ce87f9@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 10:20:11 -0700 Shannon Nelson wrote:
> >>> What should the userland program do when the timeout expires?=C2=A0 S=
tart
> >>> counting backwards?=C2=A0 Stop waiting?=C2=A0 Do we care to define th=
is at the moment? =20
> >> [component] bla bla X% (timeout reached)
> > =20
> > Yep. I don't think userspace should bail or do anything but display
> > here. Basically: the driver will timeout and then end the update
> > process with an error. The timeout value is just a useful display
> > so that users aren't confused why there is no output going on while
> > waiting.
> >
> If individual notify messages have a timeout, how can we have a=20
> progress-percentage reported with a timeout?=C2=A0 This implies to me tha=
t=20
> the timeout is on the component:bla-bla pair, but there are many
> notify messages in order to show the progress in percentage done.
> This is why I was suggesting that if the timeout and component and
> status messages haven't changed, then we're still working on the same
> timeout.

My thinking is that the timeout is mostly useful for commands which
can't meaningfully provide the progress percentage, or the percentage
update is at a very high granularity. If percentage updates are reported
often they should usually be sufficient.

We mostly want to make sure user doesn't think the system has hung.
