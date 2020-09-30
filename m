Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13AD27F445
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgI3VhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:37:11 -0400
Received: from mx4.wp.pl ([212.77.101.11]:51690 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3VhK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:37:10 -0400
Received: (wp-smtpd smtp.wp.pl 8102 invoked from network); 30 Sep 2020 23:37:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1601501826; bh=q74dYXS/gPUj7dsUvnJgWMW3uG7sDA6Xj7vVfjfRnjM=;
          h=From:To:Cc:Subject;
          b=iQLD7Eono2lueUgaAXDEXVHrRjGEwCR+4bPPfi6PrBMubag1pEthB9nDgWh5aSExi
           PL7RFSIoJWnN4ap5YKR6tn6dn1YJqavd++A6BBXvpE+uHWVGDuy74vPXAxY0pQiVYC
           gspxGqpHvRanVYemlicVkIoIdTpJzlvHm7z/HgJE=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.7])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jacob.e.keller@intel.com>; 30 Sep 2020 23:37:05 +0200
Date:   Wed, 30 Sep 2020 14:36:59 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
Subject: Re: [iproute2-next v1] devlink: display elapsed time during flash
 update
Message-ID: <20200930143659.7fee35d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1f8a0423-97ef-29c4-4d77-4b91d23a9e7c@intel.com>
References: <20200929215651.3538844-1-jacob.e.keller@intel.com>
        <df1ad702-ab31-e027-e711-46d09f8fa095@pensando.io>
        <1f8a0423-97ef-29c4-4d77-4b91d23a9e7c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-WP-MailID: b17586ce82d6eb42bc5d2c1c2beb28d2
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000003 [cRDi]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 14:20:43 -0700 Jacob Keller wrote:
> > Thanks, Jake.=C2=A0 In general this seems to work pretty well.=C2=A0 On=
e thing,=20
> > tho'...
> >=20
> > Our fw download is slow (I won't go into the reasons here) so we're=20
> > clicking through the Download x% over maybe 100+ seconds.=C2=A0 Since w=
e send=20
> > an update every 3% or so, we end up seeing the ( 0m 3s ) pop up and sta=
y=20
> > there the whole time, looking a little odd:
> >=20
> >  =C2=A0=C2=A0=C2=A0 ./iproute2-5.8.0/devlink/devlink dev flash pci/0000=
:b5:00.0 file=20
> > ionic/dsc_fw_1.15.0-150.tar
> >  =C2=A0=C2=A0=C2=A0 Preparing to flash
> >  =C2=A0=C2=A0=C2=A0 Downloading=C2=A0 37% ( 0m 3s )
> >  =C2=A0 ...
> >  =C2=A0=C2=A0=C2=A0 Downloading=C2=A0 59% ( 0m 3s )
> >  =C2=A0 ...
> >  =C2=A0=C2=A0=C2=A0 Downloading=C2=A0 83% ( 0m 3s )

I'm not sure how to interpret this - are you saying that the timer
doesn't tick up or that the FW happens to complete the operation right
around the 3sec mark?

> > And at the end we see:
> >=20
> >  =C2=A0=C2=A0=C2=A0 Preparing to flash
> >  =C2=A0=C2=A0=C2=A0 Downloading 100% ( 0m 3s )
> >  =C2=A0=C2=A0=C2=A0 Installing ( 0m 43s : 25m 0s )
> >  =C2=A0=C2=A0=C2=A0 Selecting ( 0m 5s : 0m 30s )
> >  =C2=A0=C2=A0=C2=A0 Flash done
> >=20
> > I can have the driver do updates more often in order to stay under the =
3=20
> > second limit and hide this, but it looks a bit funky, especially at the=
=20
> > end where I know that 100% took a lot longer than 3 seconds.
> >  =20
>=20
> I think we have two options here:
>=20
> 1) never display an elapsed time when we have done/total information
>=20
> or
>=20
> 2) treat elapsed time as a measure since the last status message
> changed, refactoring this so that it shows the total time spent on that
> status message.
>=20
> Thoughts on this? I think I'm leaning towards (2) at the moment myself.
> This might lead to displaying the timing info on many % calculations
> though... Hmm

Is the time information useful after stage is complete? I'd just wipe
it before moving on to the next message.
