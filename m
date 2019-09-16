Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF67B3BDF
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388129AbfIPNzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:55:02 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:38926 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbfIPNzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:55:02 -0400
Received: by mail-qt1-f170.google.com with SMTP id n7so43416214qtb.6
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wLZUKEaKKG5KeCtmtCn+PaYuIKI2inXHjrkWFS8OIKY=;
        b=N++lhkcM3qbxEhPOnE2aNR4Gv0+uRZ/q8F2i8is/cY83uwGZ+K5ckD6xqYAs+6RGfu
         kZm/c/7cC7OeBPwIjInGXQrDMCsIKLe4/AStmQDNkJpRyO98P3tgtHMZBpN+8RHQrbv3
         u21VAZXHc4Yp1rbSvqDlJqveVmLKiCgWIFix5n1QMUtZemcfMMh77j7M+u2WlSVmwKYn
         rTTDz/I4kR7yiSS9g1XshFK4iuy8sTgOeCgYcU/XQmxz/23IBM6o9BwkFksJmDuiGkd/
         9el0bizo5PR0RbAqd9VfqulqdXM/CIAXPJEajWxwooWwI+vLsksWFWrnVyJ9lWIxMb63
         XuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLZUKEaKKG5KeCtmtCn+PaYuIKI2inXHjrkWFS8OIKY=;
        b=G64xOXbEyIlr6A1LyyPzvsOrr3xnGjLFiCBe1RowK/JJIVskatjp3JG0fYiXqjVTPO
         vEeOKRgArTBFC2t7zfZXnDnUhnVrQlQuApej+b13PIS4fRUpRnj+TR5QyCIsK9FzL1Vo
         p7VlCgR+MD6u5hnfoRQO0laLs+NGhyG57g2OzdHfe33lZu1pRrnedk9g6avhZ1XhKtQp
         wRYDe5GbrZqYB2a2FRBYWqT/bHTa15k1wpVQ8wLvJSBy1pBW+49CpCdhHDmdPMW9CaAb
         ZItuBTNPsXCBfFZTcxjibp3TmldyQ5Z6NDIpPomwyJldG0O0tVga40FRfGhh8B7Hd7Bu
         ZQ8g==
X-Gm-Message-State: APjAAAUkxtZl3MjMTVwl2oINGBa3dkijiNQGBAzn7tP/c4+nk9RIiipO
        p/SYAMNDC8tSTB97dVYEQqdjDEUEKY16bsqqQdY=
X-Google-Smtp-Source: APXvYqzV8FQi5MWoZ0bF/oZcvqC5wH90vXXU0l/QJr/6VDLBa6fU3TSBh2JS8PPVwNWI2M/0VRsaH3WGx7dJO/fCSwQ=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr5360147qtn.80.1568642100833;
 Mon, 16 Sep 2019 06:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAD56B7fEGm439yn_MaWxbyfMUEtfjbijH8as99Xh2N+6bUQEGQ@mail.gmail.com>
 <20190914145443.GE27922@lunn.ch>
In-Reply-To: <20190914145443.GE27922@lunn.ch>
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Mon, 16 Sep 2019 09:54:49 -0400
Message-ID: <CAD56B7dF9Dqf1wwu=w60z0q+hkE5-noZRS4uuUfF4PhyNSa4Kw@mail.gmail.com>
Subject: Re: net: phy: micrel KSZ9031 ifdown ifup issue
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

I did some more investigation, and what seems to be happening is the
device get's stuck in auto-negotiation. I looked at this using
phytool:
https://github.com/wkz/phytool

When it is in the good state I see that reg 0x01 is 0x796d where bit
1.2 reports 'Link is up' and bit 1.5 reports 'Auto-negotiation process
complete'. However, once I get to the bad state (it may take several
tries of ifdown, ifup to get there) then reg 0x01 is 0x7649 reporting
'Link is down' and 'Auto-negotiation process not completed'. This can
be fixed by resetting the phy './phytool write eth0/3/0 0x9140'

So, I guess that means the driver is doing what it is supposed to?
Could we add quirk or something to reset the phy again from the driver
if auto-negotiation doesn't complete with x seconds?

> Are you using interrupts, or polling? If interrupts, try polling?
> Seems unlikely, but you could be missing an interrupt.
It must be polling, the interrupt from the PHY is run in the
schematic, but it is not used in the hw or device-tree configuration.

>
> There is a fix from Antoine Tenart which suggests asym pause can be an
> issue? What pause setup are you using? But this is a known issue,
> which 5.2 should have the fix for.
Yes, this kernel includes this asym pause workaround. Reg 4.11:10 is 0
# ./phytool read eth0/3/4
0x01e1

This is the last little Ethernet issue that we are having, it would be
nice if we could find a solution.

thanks,
Paul
