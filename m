Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39BD19D80A
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390959AbgDCNzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:55:06 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:46287
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728023AbgDCNzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:55:06 -0400
X-IronPort-AV: E=Sophos;i="5.72,339,1580770800"; 
   d="scan'208";a="344842696"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 15:55:04 +0200
Date:   Fri, 3 Apr 2020 15:55:04 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org
cc:     linux-kernel@vger.kernel.org, joe@perches.com
Subject: question about drivers/atm/iphase.c
Message-ID: <alpine.DEB.2.21.2004031549270.2694@hadrien>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The function ia_frontend_intr in iphase.c contains the following code:

        if (iadev->phy_type & FE_25MBIT_PHY) {
                status = ia_phy_read32(iadev, MB25_INTR_STATUS);
                iadev->carrier_detect = (status & MB25_IS_GSB) ? 1 : 0;
        } else if (iadev->phy_type & FE_DS3_PHY) {
                ia_phy_read32(iadev, SUNI_DS3_FRM_INTR_STAT);
                status = ia_phy_read32(iadev, SUNI_DS3_FRM_STAT);
                iadev->carrier_detect = (status & SUNI_DS3_LOSV) ? 0 : 1;
        } else if (iadev->phy_type & FE_E3_PHY) {
                ia_phy_read32(iadev, SUNI_E3_FRM_MAINT_INTR_IND);
                status = ia_phy_read32(iadev, SUNI_E3_FRM_FRAM_INTR_IND_STAT);
                iadev->carrier_detect = (status & SUNI_E3_LOS) ? 0 : 1;
        } else {
                status = ia_phy_read32(iadev, SUNI_RSOP_STATUS);
                iadev->carrier_detect = (status & SUNI_LOSV) ? 0 : 1;
        }

Specifically, the second if does a bit and with FE_DS3_PHY and the third
if does a bit and with FE_E3_PHY.  According to drivers/atm/iphase.h, the
former is 0x0080 and the latter is 0x0090.  Therefore, if the third test
would be true, it will never be reached.  How should the code be changed?

thanks,
julia
