Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02535312E34
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhBHJ7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:59:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231977AbhBHJw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 04:52:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AD4664DAF;
        Mon,  8 Feb 2021 09:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612777900;
        bh=vUGvH2rTgv3CsvnCqAs4max/LMW/UGzO/ndyuBSY3fM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zn162aXLG25NO5WLQmuhTLjBLoHL0KH0pVwfvYsEvu1z9lmk/ZRgGzPQPS2t/c8yN
         XzWScKJlJ46dpEcMZ8d+Wqs995+eArmDADX1Wn5CnMlfQSRNKepqC98TUpnThfg58P
         3a13thVuljgD+lrH1ZMpZH9mZYsH3Uij7jaPrtXnyIqRh6I8NdA2GmhqHPnlNvk9+8
         WSONfag48oCrOdhs9EIYunsMEcYjvKFC8u7UcG6se7fIEWlWDNajP9+rjoxRdpnr65
         fGjvwlzh23uBoM5PdV27kT/phQZZJZG5b742S5N04/R8CUc0OsKplwWqDaCAk2v5bo
         00o9iFoR31NtQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1l93D1-0006w0-4n; Mon, 08 Feb 2021 10:51:55 +0100
Date:   Mon, 8 Feb 2021 10:51:55 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Lech Perczak <lech.perczak@gmail.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v3] usb: serial: option: update interface mapping for ZTE
 P685M
Message-ID: <YCEJu7lic8Sf4EoL@hovoldconsulting.com>
References: <20210206121322.074ddbd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207005443.12936-1-lech.perczak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210207005443.12936-1-lech.perczak@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 01:54:43AM +0100, Lech Perczak wrote:
> This patch prepares for qmi_wwan driver support for the device.
> Previously "option" driver mapped itself to interfaces 0 and 3 (matching
> ff/ff/ff), while interface 3 is in fact a QMI port.
> Interfaces 1 and 2 (matching ff/00/00) expose AT commands,
> and weren't supported previously at all.
> Without this patch, a possible conflict would exist if device ID was
> added to qmi_wwan driver for interface 3.
> 
> Update and simplify device ID to match interfaces 0-2 directly,
> to expose QCDM (0), PCUI (1), and modem (2) ports and avoid conflict
> with QMI (3), and ADB (4).
> 
> The modem is used inside ZTE MF283+ router and carriers identify it as
> such.
> Interface mapping is:
> 0: QCDM, 1: AT (PCUI), 2: AT (Modem), 3: QMI, 4: ADB
> 
> T:  Bus=02 Lev=02 Prnt=02 Port=05 Cnt=01 Dev#=  3 Spd=480  MxCh= 0
> D:  Ver= 2.01 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> P:  Vendor=19d2 ProdID=1275 Rev=f0.00
> S:  Manufacturer=ZTE,Incorporated
> S:  Product=ZTE Technologies MSM
> S:  SerialNumber=P685M510ZTED0000CP&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&0
> C:* #Ifs= 5 Cfg#= 1 Atr=a0 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
> E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
> E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> E:  Ad=87(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
> E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> I:* If#= 4 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=(none)
> E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
> ---
> v3: No changes to contents of the patch.
> Resend as separate patch to be merged through USB subsystem, the
> following patch for qmi_wwan will go through netdev tree after this is
> merged.
> Updated commit description, added note about possible qmi_wwan conflict.
> 
> v2: Blacklist ports 3-4 and simplify device ID,
> as suggested by Lars Melin.

Now applied for -next, thanks.

Johan
