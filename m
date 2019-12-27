Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F3812B5A0
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 16:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfL0PaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 10:30:22 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39729 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfL0PaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 10:30:22 -0500
Received: by mail-ed1-f65.google.com with SMTP id t17so25526067eds.6
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 07:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eBPSeHXoWaD7J24/OLrh9LsLy9ZttxlUJgtUhEblvKI=;
        b=aU6IPPCkY7x4mKFcdcgrCTN+05IQSfj0ou96aJRItqEz3ZQ+h7c6shLv2oyYAbMe37
         tXhWNjXc3Y0y5jP3UznJZ07Crx08/T84UBO6ycyMnhRX6ycrsyU3SbJtSbi07+cKi3Ms
         y8vRmq3LZKVtpKjpawLsFpk2eTrd0Kn/nmk8EMNf960tMHCoAWWkZdZf7HWl2mBbDrON
         vIrofYbplyue2t7gl2N3jWssZmbCy8HpqJ/xilm+7vmpaIFTcOEKuhD2bzL3s6ZJfh/e
         TEb2G1qTmFPPaoKeHefJo7LhFgGrEu8FKlU86wEyrBgQ/E6FOMMs5KulwjX0BgLFHilT
         5a/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eBPSeHXoWaD7J24/OLrh9LsLy9ZttxlUJgtUhEblvKI=;
        b=l3KDhAmCOb7Y5lvxqCDyMuDODovzXktAOcHsM+Yv/1lICeTh6aRrkJkG+lbS6E0/RR
         oLxkBetyRk/gvFYPYKKMeHevXXpnW7i28UrUt65HgjaX/lAuEi448nJP8vujFBzpeBQV
         PKLwPosJ7i7aQ5Y65L2IEhTsyABU4XwxGfo8r7OZfiv2Dp5jyzxkH+eUDi0yiFN7MLTO
         fzkw6CNKfs636pTtRpUHCf0HKIsMHFnbUvp141XWeNRxkQI24CB7+G9DtMAjGv6LPXmt
         C6ZOCmZKYY9jAbJzoEaUNYmtX3Ifw0M6ZkslCpbchL/FpOFvZvpAbQtL5cWrRwhMfgct
         HhaQ==
X-Gm-Message-State: APjAAAVQ0fzDOSYbz1T9zB3ink/UJD2hJrUUkO6Uq9WFTBmO0ILW5LDM
        WRNRQTcBN5bDgC0tJ3up0wMa8b+Vlzcwx39J51w=
X-Google-Smtp-Source: APXvYqz9oeH4Tez8s2aZZf7vo7o45p7xZOldMx7YKEsMgMaSlcIHMc0wv4DVwkNaNHNRHyi6BYpM75IpCXyqYthkz2A=
X-Received: by 2002:a50:fb96:: with SMTP id e22mr55996161edq.18.1577460620435;
 Fri, 27 Dec 2019 07:30:20 -0800 (PST)
MIME-Version: 1.0
References: <20191216223344.2261-1-olteanv@gmail.com> <02874ECE860811409154E81DA85FBB58B26DEDC3@fmsmsx101.amr.corp.intel.com>
 <CA+h21hob3FmbQYyXMeLTtbHF1SeFO=LZVGyQt4jniS9-VXEO-w@mail.gmail.com>
 <02874ECE860811409154E81DA85FBB58B26DF1C9@fmsmsx101.amr.corp.intel.com>
 <20191224190531.GA426@localhost> <CA+h21hrBLedLHCfP3oY2U96BJXqMQO=Uof3tsjji_Fp-b0smHQ@mail.gmail.com>
 <20191227015232.GA6436@localhost> <20191227151916.GC1435@localhost>
In-Reply-To: <20191227151916.GC1435@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 27 Dec 2019 17:30:09 +0200
Message-ID: <CA+h21hoq2-CAVfv7zQkQCsaTFmOTrxj-93MbHpJLPAt7jbOgbg@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: Fix double delivery of TX
 timestamps to socket error queue
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Dec 2019 at 17:19, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Thu, Dec 26, 2019 at 05:52:32PM -0800, Richard Cochran wrote:
> > On Thu, Dec 26, 2019 at 08:24:19PM +0200, Vladimir Oltean wrote:
> > > How will these drivers not transmit a second hw TX timestamp to the
> > > stack, if they don't check whether TX timestamping is enabled for
> > > their netdev?
> >
> > Ah, so they are checking SKBTX_HW_TSTAMP on the socket without
> > checking for HWTSTAMP first?
>
> Thinking a bit more about this, MAC drivers should not attempt any
> time stamping unless that functionality has been enabled at the device
> level using HWTSTAMP.  This is the user space API.
>
> So, if you want to fix those drivers, you can submit patches with the
> above justification.  That is a stronger argument than saying it
> breaks DSA drivers!
>
> Thanks,
> Richard

But in the case that I _do_ care about, it _is_ caused by DSA. The
gianfar driver is not expecting anybody else to set SKBTX_IN_PROGRESS,
which in itself is not illegal, whether or not you argue that it is
needed or not.
For the rest of the drivers, sure, they commit even more flagrant API
breaches, such as not checking previous calls of the HWTSTAMP ioctl.
But the flagrant issues are at least easier to catch (aka PTP is never
going to work), so I'm not as concerned about them, as long as user
space (e.g. ptp4l) has the necessary checks in place to detect such
error conditions.

Thanks.
-Vladimir
