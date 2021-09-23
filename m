Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562BC416657
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 22:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243063AbhIWUGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 16:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242982AbhIWUGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 16:06:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 500BB60F12;
        Thu, 23 Sep 2021 20:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632427499;
        bh=ZKNWk17HrzTqvQp5Di2o37qBgDZukscxNZeQBRyeBW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pUjP4SebHmdbfZgdyLks7kwxj29svzYxOZ2upndAb/wLgzBFktzw0j6RXKk0YYRGr
         Zpqc/Ah+VQ23p4pjQAQVgDpVkSzWA6CN2o+6PZ39OxTZAxpiJtw+REjcqLbues7+V8
         HvtLFfFy94nI5ZHIwqvz0ZXXmskxR0bNWe1X0VIbEY47/ckXCBC96zxWL209O5cfwB
         7AUv62Z6SNcbgPw3fRhaxHtUjdcplZdNz1XcnDcNySTpiGsrLd4o05Sg7NokrdiXLp
         rXap7pxQEHbeNH8pzKnw6Dx/0EFOIXNE4KO2q+MkD8xKmbBwT2iKnisvK14mxjez/Z
         owke4WLm6SArw==
Date:   Thu, 23 Sep 2021 13:04:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: Re: [PATCH net-next] ptp: clockmatrix: use rsmu driver to access
 i2c/spi bus
Message-ID: <20210923130458.23cd40f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <TYCPR01MB66086FB0DF1CBCC00F716A7ABAA39@TYCPR01MB6608.jpnprd01.prod.outlook.com>
References: <1632319034-3515-1-git-send-email-min.li.xe@renesas.com>
        <20210923083032.093c3859@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <TYCPR01MB66084980E50015D3C3F1F43CBAA39@TYCPR01MB6608.jpnprd01.prod.outlook.com>
        <20210923094146.0caaf4e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <TYCPR01MB66086FB0DF1CBCC00F716A7ABAA39@TYCPR01MB6608.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 19:49:56 +0000 Min Li wrote:
> > > I did build it through 32 bit arm and didn't get the problem.
> > >
> > > make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-  
> > 
> > We're testing x86, maybe arm32 can handle 64bit divisions natively?
> > 
> > ERROR: modpost: "__divdi3" [drivers/ptp/ptp_clockmatrix.ko] undefined!
> > ERROR: modpost: "__udivdi3" [drivers/ptp/ptp_clockmatrix.ko] undefined!  
> 
> Hi Jakub
> 
> I tried "make ARCH=i386" but it also passed on my machine. Can you tell me how to
> reproduce this? Thanks

Hm, are you sure the config does not have CONFIG_64BIT=y ? Getting this
right can be tricky, here is the script which patchwork runs, FWIW:

https://github.com/kuba-moo/nipa/blob/master/tests/patch/build_32bit/build_32bit.sh

There is a small chance it's a glitch in the test system, but seems
unlikely, this looks like a 64b divide:

+static u32 idtcm_get_dco_delay(struct idtcm_channel *channel)
...
+	u64 m;
+	u16 n;
...
+	fodFreq = m / n;
...
+		return 18 * (u64)NSEC_PER_SEC / fodFreq;
