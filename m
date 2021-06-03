Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5734739A047
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhFCLzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhFCLzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 07:55:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CE9C06174A;
        Thu,  3 Jun 2021 04:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q6A8IcBGr2lD7OlyIiRQL/OR9300InynikBnSaCPKwM=; b=ZuPqOumz+VEGfVm7ZH1zldT/v
        dz+FbLOiRJPeGa+0DGKLRR0nv1uw+FmsbenRJHj+fUTdkjgsMsluc9qKB+iMFyuzqFMcne2vTqxHI
        Md+C7I4cKV3q8OqBt2PWdokcJk1SO7NcNuV9Dl0XkOKW6qPEe0E+wedZlEd9vJHsbiUvb86mRXd1L
        y1GsQ/urqrUK50RsV329mN/HWjaZBlgvmWtByxrC+9pyYsf7KGjn588SPpn2N1q6B4aUjyh0cFQ2a
        ATITlpIV9elZCuEcw9sso05ajkV5W0IhG9EOMrJAGYArqI9RG8i/tGjU5CS0PTRXNl770oKNzdyaW
        reIg2P2lg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44666)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1loluX-0002d5-SP; Thu, 03 Jun 2021 12:53:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1loluW-00024z-Tv; Thu, 03 Jun 2021 12:53:16 +0100
Date:   Thu, 3 Jun 2021 12:53:16 +0100
From:   Russell King <linux@armlinux.org.uk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH wireless-drivers-next 0/4] TI wlcore firmware log fixes
Message-ID: <20210603115316.GR30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

(I'm assuming this is the correct way to submit for
wireless-drivers-next.)

The following series fixes a number of issues with the firmware logging
on TI wireless devices, noticed while looking at AP mode issues on the
WL18xx family of devices.

Patch 1 tidies up the use of "fw_log.actual_buff_size" removing
multiple unnecessary endian conversions by caching the CPU endian value
in a local variable "actual_size".

Patch 2 makes the buffer calculations more obvious and adds comments
to describe what is going on. In particular, the addition of "addr_ptr"
eliminates several "addr + internal_fw_addrbase" calculations in the
code.

Patch 3 fixes an error in the calculation of "clean_addr" when it hits
the end of the buffer, which was causing the kernel console to spew
"errors" when firmware tracing is in effect.

Patch 4 removes the error message fixed in patch 3, which can still
occur when we race with the firmware reading the log structure. The
write pointer is where the firmware is writing its next message to,
whereas "clean_ptr" is the point that we've read the firmware log
to. It is fine that these may not match.

As this is a debug facility, I don't see any urgent need to push these
patches into -rc nor stable kernels.

 drivers/net/wireless/ti/wlcore/event.c | 67  +++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 29 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
