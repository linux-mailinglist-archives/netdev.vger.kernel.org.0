Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB99B226A
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 16:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbfIMOmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 10:42:52 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:45831 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfIMOmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 10:42:52 -0400
Received: by mail-qt1-f175.google.com with SMTP id r15so34165578qtn.12
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 07:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2CCVTa6zjmurVBVgn4pJlMxfr+Kf8TqJnd9jxobUEWE=;
        b=iYS/Z/ZGpMkO5J/BuaRCgW02CUcytKpQNQ7/6Kpv+SV3qyxw8mjJVMIp7jQzACQwfo
         sklA04tyB27nxjDlKz1k/VS+syyH+JAmevDe95oez6s2LKnGd+z9vekLuA1pWTzSNi73
         1se5o2+AUtXYHJigr9ljMDBs3h4wiZQcirzgfLOzwNkd5+kcfH0ejPM1u9ppA1EpK/5I
         eWpEEaKk4EqblJM3reYCQK9/mPCz/f2ETT++z5mAZKmGrKI2fJ1ttMxu7kG9hZhEChCr
         hTVZsHXESBp2etimDrwVjfdUk7iiMSQx+jnGSNHOz38yrn+vH03+0l3Yj34OGbL6G/9L
         dc+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2CCVTa6zjmurVBVgn4pJlMxfr+Kf8TqJnd9jxobUEWE=;
        b=UIXUGQeox7rJUNqjSPj5eJRLU1/NpKusub2LQftiZlHk8FEHINtqdtNbjmS4dvql2h
         Fw+flW1lvG3sE63PwrYO/MP2M8E4DcDD6Kjxw2lwtTp6Rf4rFiP9MstwNpeXL5OL1Ggt
         +vkC1oolSY3+czLvalXGzm9uEKub4rDIFNQ+543+YHa+VOIMUdHuqMEfJG1PL1FhLcND
         eg7MSsR69IJdUsfiignZdKxaCGWKklFU3u1+uxwRSg1jDxNb22b/D4zFn0tDsYbGiQxC
         /xD76X3RjMN1gjPJpr/J1dKEKJ+nWIwB2Z8td6usjqABGbppTWJnSIVLl7JB3zSlD2s4
         /Obw==
X-Gm-Message-State: APjAAAW0ielJNfW8cjhEKXyJAmZ47HRDi4mzLcxOSNcNEJBF1hUvQnBl
        NeFDcXLi9E96zhR8OYuNvCg/K4x3BhRnOq/fJmcaCTnn
X-Google-Smtp-Source: APXvYqzMnttOMOpS46JrwZSUIMAnVGrBemH8GALeLVr6ipEDMQK0LApHWb6/pAnE5HE5OXtistZXdxyw90DeBYBRlkk=
X-Received: by 2002:aed:3c52:: with SMTP id u18mr3355851qte.194.1568385771144;
 Fri, 13 Sep 2019 07:42:51 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Fri, 13 Sep 2019 10:42:38 -0400
Message-ID: <CAD56B7fEGm439yn_MaWxbyfMUEtfjbijH8as99Xh2N+6bUQEGQ@mail.gmail.com>
Subject: net: phy: micrel KSZ9031 ifdown ifup issue
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I think I'm seeing an issue with the PHY hardware or PHY driver. What
happens is sometimes (but not always) when I do 'ip link set eth0
down' followed by 'ip link set eth0 up' I don't ever see an
auto-negotiation again. LEDs don't come on, ethtool reports 'Link
detected: no'. Even physically unplugging and plugging the network
cable doesn't bring it back. I have to do a reboot to get the
networking back.

When the networking is started I don't see any issue forcing
negotiations by unplugging and plugging the cable. I get standard
messages like this all day long:
[   21.031793] 003: macb ff0b0000.ethernet eth0: link down
[   26.142835] 003: macb ff0b0000.ethernet eth0: link up (1000/Full)

One thing that makes me think this is the PHY is that we have another
Ethernet port using the DP83867 PHY and I can always do ifdown/ifup
with it.

This is using a 5.2.10 kernel on arm64 zynqmp platform with the macb driver.

Is this something anyone else has seen? I know there is some Errata
with this part, but I'm hoping there is something to fix or work
around this. Any thoughts on where to look or add debugging would
appreciated.

thanks,
Paul
