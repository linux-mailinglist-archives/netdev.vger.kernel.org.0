Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6069949592F
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 06:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbiAUFUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 00:20:54 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:55664
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234044AbiAUFUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 00:20:47 -0500
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 09FDC3F1DD
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 05:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642742443;
        bh=wVTM0hztIXfCr6VERNnZ+oanrOCPjJFihg5+LQI64SE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=POSNok0KXBIxym6N+ah8Tr996m8ocsuRSYi3wJM10c9bQ8LuGFtbiXxzmbuQBQ0Jh
         vejiFMEURj1bSqs3UJdFsCQYoidSHEqzJreOYPATFZc//qvJAhJlVB1V1VX+R1gz+j
         uN92ZTga5cD2wVg+GXCLeS2fMX5sYqBqfK32EPg+A6zz4+ugctu+O70BceiyvSKgYN
         q2/hHioUmzkbbJez38+f0eum8XYJj6rH2dW1+VvuJdNhb04us4clF1FDfKT52GYFFt
         CgZJ745bK11Ysals23zcyJ8KnccXRw2YLx22ZEJ0ixBxcICcjXyuGxHXcgGEFXWrXu
         mIKEsLPrxPkyA==
Received: by mail-pj1-f69.google.com with SMTP id w15-20020a17090aea0f00b001b53b829d6bso742315pjy.5
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 21:20:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:content-transfer-encoding:date
         :message-id;
        bh=wVTM0hztIXfCr6VERNnZ+oanrOCPjJFihg5+LQI64SE=;
        b=N1vEQnQZp9wqzXNFd9Riq1aTFTjpPZzN/52yD3U8t7Efvj4E+JfOCFsSUupchS2KGc
         6y0Cqo09PNIHRZNJLGantDBILMJW0Tk6mwfaIXGaFXxcb6y5g0gBhq9Kjto5cyhllNvc
         xv9r1m1TmRxwPtzEnd749FjTKKg+urNRKmlLScBKdlmCODThh9/5Tmprz+4u+vNbk3tX
         hdwSrBbHw2Rs62GuMvIp+Dhs4+BISDWeCF4BnC4gsZwi4zUX2cdEu///kYg9VyRoMHAM
         lXx2/9b+i0/s1p1Mw8YEHMpyyOVPrM9F0TmQE4BK6+hGZNNRCffFTgJ0Slvy7rwI3s5d
         VYzA==
X-Gm-Message-State: AOAM532ydqYl2n6DLbR3UiZJ1Ae0TO1kdO4gpRfYn4K04Pasa4a07NtG
        Eksefd8vFcVpaggCIffXN3OrOh8DY3miet7cM2JHsbCwcPvt+v3IX1bf/c0HnCWjnJaK2FZ9g2u
        lQQxtVh+ov2DeL1G8Iw+jAG/rGAV6o5Vzwg==
X-Received: by 2002:a17:903:230c:b0:14b:1f90:1caf with SMTP id d12-20020a170903230c00b0014b1f901cafmr1083946plh.56.1642742441655;
        Thu, 20 Jan 2022 21:20:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzB5b29KmUT5Ex0X0xL3q8l6oU9nyhDbH92zpSPKF5WrKFImrNT06M8H4VUkBWZPVyw30L7aA==
X-Received: by 2002:a17:903:230c:b0:14b:1f90:1caf with SMTP id d12-20020a170903230c00b0014b1f901cafmr1083927plh.56.1642742441375;
        Thu, 20 Jan 2022 21:20:41 -0800 (PST)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id d1sm5047341pfu.206.2022.01.20.21.20.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jan 2022 21:20:40 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id B9A556093D; Thu, 20 Jan 2022 21:20:39 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id B337DA0B22;
        Thu, 20 Jan 2022 21:20:39 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH RFC V1 net-next 1/4] net: ethtool: Refactor identical get_ts_info implementations.
In-reply-to: <Yeou9TKzW1NcBOKW@Laptop-X1>
References: <20220103232555.19791-2-richardcochran@gmail.com> <20220120161329.fbniou5kzn2x4rp7@skbuf> <Yeou9TKzW1NcBOKW@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Fri, 21 Jan 2022 11:56:37 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27564.1642742439.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 20 Jan 2022 21:20:39 -0800
Message-ID: <27565.1642742439@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Thu, Jan 20, 2022 at 04:13:29PM +0000, Vladimir Oltean wrote:
>> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bo=
nd_main.c
>> > index b60e22f6394a..f28b88b67b9e 100644
>> > --- a/drivers/net/bonding/bond_main.c
>> > +++ b/drivers/net/bonding/bond_main.c
>> > @@ -5353,23 +5353,13 @@ static int bond_ethtool_get_ts_info(struct ne=
t_device *bond_dev,
>> >  				    struct ethtool_ts_info *info)
>> >  {
>> >  	struct bonding *bond =3D netdev_priv(bond_dev);
>> > -	const struct ethtool_ops *ops;
>> >  	struct net_device *real_dev;
>> > -	struct phy_device *phydev;
>> >  =

>> >  	rcu_read_lock();
>> >  	real_dev =3D bond_option_active_slave_get_rcu(bond);
>> >  	rcu_read_unlock();
>> =

>> Side note: I'm a bit confused about this rcu_read_lock() ->
>> rcu_dereference_protected() -> rcu_read_unlock() pattern, and use of th=
e
>> real_dev outside the RCU critical section. Isn't ->get_ts_info()
>> protected by the rtnl_mutex? Shouldn't there be a
>> bond_option_active_slave_get() which uses rtnl_dereference()?
>> I see the code has been recently added by Hangbin Liu.
>
>Hi Vladimir,
>
>Yes, it should be enough to use rtnl_dereference() since ->get_ts_info is
>protected by the rtnl_lock. I just thought there is an existing get activ=
e
>slave function and rcu read should be OK to be used here. So I just used =
the
>existing one.
>
>Hi Jay,
>
>Do you think if there is a need to add a rtnl version of
>bond_option_active_slave_get()?

	I think the RCU primitives used should match the calling
context, so, yes, there should be an "rtnl" flavor in this call path as
that's really what's being relied upon.

	You could add a "...active_slave_get_rtnl" variant, or there's
rcu_deference_rtnl() that goes both ways (rcu_read_lock or RTNL).  That
could be used in bond_option_active_slave_get_rcu() in place of the
current rcu_dereference().  I don't have a strong preference one way or
the other.

	Either way, as mentioned, I agree that the rcu_read_lock/unlock
in bond_ethtool_get_ts_info() is superfluous, since the whole call is
under RTNL.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
