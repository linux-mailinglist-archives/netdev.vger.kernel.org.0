Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6260281162
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbgJBLn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgJBLn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 07:43:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E810D206E3;
        Fri,  2 Oct 2020 11:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601639004;
        bh=Um0ftaims7pCV0EgtbpdXAsPSGzpFNfGBGqMRGVKZDk=;
        h=Date:From:To:Cc:Subject:From;
        b=H017jt+AENqlGNPFcbs3k6i35nY2cX3xdETy+xt4hgTl/ENbHnxT2819pviiNxPny
         rOSe1grXkX5H33e0dFYd29v8z3K4uS/4vUKif55N4lqt/X31ds6JC/QHQgGzdLBBei
         bReBhEINXuK54Sa82lKc4iwK9cB3pPlRfBRaroXA=
Date:   Fri, 2 Oct 2020 13:43:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Tuba Yavuz <tuba@ece.ufl.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH v2] net: hso: do not call unregister if not registered
Message-ID: <20201002114323.GA3296553@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuba Yavuz <tuba@ece.ufl.edu>

On an error path inside the hso_create_net_device function of the hso
driver, hso_free_net_device gets called. This causes a use-after-free
and a double-free if register_netdev has not been called yet as
hso_free_net_device calls unregister_netdev regardless. I think the
driver should distinguish these cases and call unregister_netdev only if
register_netdev has been called.

Signed-off-by: Tuba Yavuz <tuba@ece.ufl.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v2: format cleaned up based on feedback from previous review
    Forward to Greg to submit due to email problems on Tuba's side

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 2bb28db89432..e6b56bdf691d 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2366,7 +2366,8 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 
 	remove_net_device(hso_net->parent);
 
-	if (hso_net->net)
+	if (hso_net->net &&
+	    hso_net->net->reg_state == NETREG_REGISTERED)
 		unregister_netdev(hso_net->net);
 
 	/* start freeing */
