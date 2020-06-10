Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F121F5025
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 10:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgFJISC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 04:18:02 -0400
Received: from mail.intenta.de ([178.249.25.132]:27424 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgFJISC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 04:18:02 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2020 04:18:01 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date; bh=+0KOUw6hIxtU3M3QzmhsdFeWgUzaaM5n4g/Nv7EbMCA=;
        b=iyoCV4/GV0w85tJOYKyK50aD7a7JzYwfcQuuJSPdbmPmgsw7ud+Eq3GRVliwgMHbacjcWnPRcC2v2HCN2YvfetzyzhdMFGgIY4XxZLAxZxYi+jXEaqtMtX0zWA4OMvu3PW1oHquziq+b0TXWR/pt7z1HIxcHPSAcgv/Wv+oSaBJPRXsqnFFjG0JU83Na3R5kDkXufge0pcEMrb/veld8M/syBKXK4vlKE/AtA3MNwiQ1nVI96+R1C6XAcuvxgpcQYLezyQEhK/+1KecfWaQvE4yvhqGbQLX2M21+Ld8kn6oka1u3JziGLLW3PjlToh4+CdU/disPjzXwFAxeblYwNQ==;
Date:   Wed, 10 Jun 2020 10:12:37 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     <netdev@vger.kernel.org>
Subject: correct use of PHY_INTERFACE_MODE_RGMII{,_TXID,_RXID,_ID}
Message-ID: <20200610081236.GA31659@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been trying to write a dt for a board and got quite confused about
the RGMII delays. That's why I looked into it and got even more confused
by what I found. Different drivers handle this quite differently. Let me
summarize.

Some drivers handle the RGMII modes individually. This is how I expected
it to be. Examples:
* renesas/ravb_main.c
* stmicro/stmmac/dwmac-rk.c

A number of drivers handle all RGMII modes in uniformly. They don't
actually configure any dealys. Is that supposed to work?  Examples:
* apm/xgene/xgene_enet_main.c
* aurora/nb8800.c
* cadence/macb_main.c
* freescale/fman/fman_memac.c
* freescale/ucc_geth.c
* ibm/emac/rgmii.c
* renesas/sh_eth.c
* socionext/sni_ave.c
* stmicro/stmmac/dwmac-stm32.c

freescale/dpaa2/dpaa2-mac.c is interesting. It checks whether any rgmii
mode other than PHY_INTERFACE_MODE_RGMII is used and complains that
delays are not supported in that case. The above comment says that the
MAC does not support adding delays. It seems that in that case, the only
working mode should be PHY_INTERFACE_MODE_RGMII_ID rather than
PHY_INTERFACE_MODE_RGMII. Is the code mixed up or my understanding?

Another interesting one is cadence/macb_main.c. While it handles all the
RGMII modes uniformly, the Zynq GEM hardware (supported by the driver)
does not actually support adding any delays. The driver happily accepts
these modes without telling the user that it really is using
PHY_INTERFACE_MODE_RGMII_ID. Should the driver warn about or reject the
other modes? Rejecting could break existing users. Some feedback
(failure or warning) would be very useful however.

stmicro/stmmac/dwmac-sti.c has a #define IS_PHY_IF_MODE_RGMII, which
seems to be a duplicate of phy_interface_mode_is_rgmii from
<linux/phy.h>. Should that or phy_interface_is_rgmii be used instead?

Helmut
