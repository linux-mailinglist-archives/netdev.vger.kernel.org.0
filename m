Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1FE25EB3F
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgIEWHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:07:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbgIEWHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 18:07:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3558420760;
        Sat,  5 Sep 2020 22:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599343661;
        bh=qKQfp74MCznuWfzYhae+OMhn867lXMUvVr9jnpemmK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TDBe4VMzKt6l2j28K+nakFfGBehIWXBs/1SlYHWjhDv0alhklXrIh3o38MvBNyq25
         +TKzq2Up27BW5GWBs8ie38DFamErElz1qrbj//RxImi2MHytCGW7FV2Tdw2+ZLyTyT
         Xod8BIRHxMJO+9lv/QL2ymHj+qoJeM+oR4kKvxLI=
Date:   Sat, 5 Sep 2020 15:07:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200905150739.4853fd0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c18aca84-7cd4-64be-1222-2c36c795f024@pensando.io>
References: <20200904000534.58052-1-snelson@pensando.io>
        <20200904000534.58052-3-snelson@pensando.io>
        <20200905125214.7a13b32b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c18aca84-7cd4-64be-1222-2c36c795f024@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 14:47:58 -0700 Shannon Nelson wrote:
> On 9/5/20 12:52 PM, Jakub Kicinski wrote:
> > On Thu,  3 Sep 2020 17:05:34 -0700 Shannon Nelson wrote: =20
> >> +		if (offset > next_interval) {
> >> +			devlink_flash_update_status_notify(dl, "Downloading",
> >> +							   NULL, offset, fw->size);
> >> +			next_interval =3D offset + (fw->size / IONIC_FW_INTERVAL_FRACTION);
> >> +		}
> >> +	}
> >> +	devlink_flash_update_status_notify(dl, "Downloading", NULL, 1, 1); =
=20
> > This is quite awkward. You send a notification with a different size,
> > and potentially an unnecessary one if last iteration of the loop
> > triggered offset > next_interval.
> >
> > Please just add || offset =3D=3D fw->size to the condition at the end of
> > the loop and it will always trigger, with the correct length. =20
>=20
> Or maybe make that last one look like
>  =C2=A0=C2=A0=C2=A0 devlink_flash_update_status_notify(dl, "Downloading",=
 NULL,=20
> fw->size, fw->size);
> to be less awkward and to keep the style of using a final status_notify=20
> at the end of the block, as done in the Install and Select blocks=20
> further along?
=20
That may still generate two notifications at the end tho, no?
Unless the loop one in the loop is && offset !=3D fw->size.
