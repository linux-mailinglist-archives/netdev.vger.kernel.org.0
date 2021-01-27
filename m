Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E208C3054A4
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhA0H3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbhA0H1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:27:14 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6EFC061756;
        Tue, 26 Jan 2021 23:26:33 -0800 (PST)
Received: from miraculix.mork.no (fwa142.mork.no [192.168.9.142])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 10R7QEIM026868
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 27 Jan 2021 08:26:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1611732374; bh=GjRh26o1Is5WVgOZIdPJpiicVRyo7DIBmSPIpdBoMZk=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=GuIOS7lHrgOK2KYxWCs3r+Hh6sZUyavIA3p5yIOfa8XGT5zgwxYzOWkUUJoGDlH5s
         xMjlyC5RQhXS/UbuBLTANyzYkLQRwoiE5kRqE2/wU6JoJKJxuXoaW87Hk6x5saweta
         UgBoMtR5iH54TbMsng+8DXU8MUFdQWfLxk07fW0k=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1l4fDR-000K0O-F5; Wed, 27 Jan 2021 08:26:13 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>
Subject: Re: [PATCH net-next 1/2] net: usb: qmi_wwan: add qmap id sysfs file
 for qmimux interfaces
Organization: m
References: <20210125152235.2942-1-dnlplm@gmail.com>
        <20210125152235.2942-2-dnlplm@gmail.com>
        <87wnw1f0yj.fsf@miraculix.mork.no>
        <20210126180231.75e19557@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 27 Jan 2021 08:26:13 +0100
In-Reply-To: <20210126180231.75e19557@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Tue, 26 Jan 2021 18:02:31 -0800")
Message-ID: <87mtwudene.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:
> On Mon, 25 Jan 2021 17:14:28 +0100 Bj=C3=B8rn Mork wrote:
>> Daniele Palmas <dnlplm@gmail.com> writes:
>>=20
>> > Add qmimux interface sysfs file qmap/mux_id to show qmap id set
>> > during the interface creation, in order to provide a method for
>> > userspace to associate QMI control channels to network interfaces.
>> >
>> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>=20=20
>>=20
>> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>
> We got two patches adding new sysfs files for QMI in close succession -
> is there a sense of how much this interface will grow over time?

The honest answer is no.

I do not expect this interface to grow at all.  But then I didn't expect
it to grow before the two recent additions either...  Both are results
of feedback from the userspace developers actually using this interface.

If I try to look into the future, then I do believe the first addition,
the "pass_through" flag, makes further changes unnecessary.  It allows
the "rmnet" driver to take over all the functionality related to
qmap/qmimux.  The rmnet driver has a proper netlink interface for
management.  This is how the design should have been from the start, and
would have been if the "rmnet" driver had existed when we added qmap
support to qmi_wwan.  Or if I had been aware that someone was working on
such a driver.

So why do we still need this last addition discussed here? Well, there
are users of the qmi_wwan internal qmimux interface.  They should move
to "rmnet", but this might take some time and we obviously can't remove
the old interface in any case. But there is a design flaw in that
interface, which makes it rather difficult to use. This last addition
fixes that flaw.

I'll definitely accept the judgement if you want to put your foot down
and say that this has to stop here, and that we are better served
without this last fix.

> It's no secret that we prefer netlink in networking land.

Yes.  But given that we have the sysfs interface for managing this
qmimux feature, I don't see netlink as an alternative to this patch.

The same really applies to the previous sysfs attribute, adding another
flag to a set which is already exposed as sysfs attributes.

The good news is that it allowed further qmimux handling to be offloaded
to "rmnet", which does have a netlink interface.


Bj=C3=B8rn
