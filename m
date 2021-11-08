Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799DD449C44
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 20:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhKHTUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 14:20:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236660AbhKHTUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 14:20:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E582860EE0;
        Mon,  8 Nov 2021 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636399035;
        bh=2IxtNUyHKhkd6eiyG6ElYifoOrhnwft/XDlYFK/h9ik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KktbBxN/ObvH1Jul/wPb38mvaxoeauHTa6xc8idkKeHwukQ0NWSjFfHtRdU5xLmFO
         ov9FA0hXoAJxA71lkvzE4Utkj5aMrPL7x+juilFwJW8VaQCd7/6IzZH51nnODvchB1
         JFjX/N7mtsP6aDbGVBhoG3dGekuAeDnlYyxG3WBoiKtNwT/QG1nS3/3zZGVNoE/n5I
         f3AzGpH5st1YRv3jsn+0IhIpajjBDMsiwiSyMRk5KH8FIXMNHAllwCq9EGCAACXvCx
         h/O6SW9nuwvatTmGxbbHRB4X0m78bByEH8R1Wzy8bxWvfYajGG5HJxg5QN2rHZkXap
         jSgXP5dKCMDlA==
Date:   Mon, 8 Nov 2021 20:17:10 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <20211108201710.39cff848@thinkpad>
In-Reply-To: <YYl1xSKg4vrsbTdw@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
        <20211108002500.19115-2-ansuelsmth@gmail.com>
        <YYkuZwQi66slgfTZ@lunn.ch>
        <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
        <20211108171312.0318b960@thinkpad>
        <YYlUSr586WiZxMn6@Ansuel-xps.localdomain>
        <20211108183537.134ee04c@thinkpad>
        <YYllTn9W5tZLmVN8@Ansuel-xps.localdomain>
        <20211108194142.58630e60@thinkpad>
        <YYl1xSKg4vrsbTdw@Ansuel-xps.localdomain>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 20:08:53 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> > Well, if the PHY allows to manipulate the LEDs ON/OFF state (in other
> > words "full control by SW", or ability to implement brightness_set()
> > method), then netdev trigger should blink the LED in SW via this
> > mechanism (which is something it would do now). A new sysfs file,
> > "offloaded", can indicate whether the trigger is offloaded to HW or not.
> >   
> 
> Are all these sysfs entry OK? I mean if we want to add support for he
> main blinking modes, the number will increase to at least 10 additional
> entry. 

See below.

> > If, on the other hand, the LED cannot be controlled by SW, and it only
> > support some HW control modes, then there are multiple ways how to
> > implement what should be done, and we need to discuss this.
> > 
> > For example suppose that the PHY LED pin supports indicating LINK,
> > blinking on activity, or both, but it doesn't support blinking on rx
> > only, or tx only.
> > 
> > Since the LED is always indicating something about one network device,
> > the netdev trigger should be always activated for this LED and it
> > should be impossible to deactivate it. Also, it should be impossible to
> > change device_name.
> > 
> >   $ cd /sys/class/leds/<LED>
> >   $ cat device_name
> >   eth0
> >   $ echo eth1 >device_name
> >   Operation not supported.
> >   $ echo none >trigger
> >   Operation not supported.
> > 
> > Now suppose that the driver by default enabled link indication, so we
> > have:
> >   $ cat link
> >   1
> >   $ cat rx
> >   0
> >   $ cat tx
> >   0
> > 
> > We want to enable blink on activity, but the LED supports only blinking
> > on both rx/tx activity, rx only or tx only is not supported.
> > 
> > Currently the only way to enable this is to do
> >   $ echo 1 >rx
> >   $ echo 1 >tx
> > but the first call asks for (link=1, rx=1, tx=0), which is impossible.
> > 
> > There are multiple things which can be done:
> > - "echo 1 >rx" indicates error, but remembers the setting
> > - "echo 1 >rx" quietly fails, without error indication. Something can
> >   be written to dmesg about nonsupported mode
> > - "echo 1 >rx" succeeds, but also sets tx=1
> > - rx and tx are non-writable, writing always fails. Another sysfs file
> >   is created, which lists modes that are actually supported, and allows
> >   to select between them. When a mode is selected, link,rx,tx are
> >   filled automatically, so that user may read them to know what the LED
> >   is actually doing
> > - something different?
> >   
> 
> Expose only the supported blinking modes? (in conjunciong with a generic
> traffic blinking mode)

The problem with exposing only supported blinking modes is that you
can't hide rx and tx files and create a new, rxtx file. That would
break netdev trigger ABI.

> The initial question was Should we support a mixed mode offloaed
> blinking modes and blinking modes simulated by sw? I assume no as i
> don't think a device that supports that exist.

If you mean something like: the PHY can blink on tx, but not on rx, and
I want to blink on rx/tx, do I will enable HW blinking on tx, and on rx
I will blink from software, then no. If I can blink in software, then
this case should be all done in software. If software blinking is not
supported, then this setting is simply unsupported by the LED.


Let's at first implement offloading of only those things that are
supported by netdev trigger already in SW, so link, rx and tx.

When this works OK and gets merged, we can try to extend the netdev
trigger to support more modes in SW, and then implement offloading of
these modes.

Marek
