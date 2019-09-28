Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB09C1202
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 21:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbfI1TUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 15:20:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33582 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfI1TUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 15:20:37 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iEIGW-0002v0-CP; Sat, 28 Sep 2019 21:20:24 +0200
Message-ID: <2e836018c7ea299037d732e5138ca395bd1ae50f.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 00/12] net: fix nested device bugs
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        jakub.kicinski@netronome.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Date:   Sat, 28 Sep 2019 21:20:21 +0200
In-Reply-To: <20190928164843.31800-1-ap420073@gmail.com> (sfid-20190928_184857_724786_E6D9EE1A)
References: <20190928164843.31800-1-ap420073@gmail.com>
         (sfid-20190928_184857_724786_E6D9EE1A)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> VLAN, BONDING, TEAM, MACSEC, MACVLAN, IPVLAN, VIRT_WIFI and VXLAN.
> But I couldn't test all interface types so there could be more device
> types which have similar problems.

Did you test virt_wifi? I don't see how it *doesn't* have the nesting
problem, and you didn't change it?

No, I see. You're limiting the nesting generally now in patch 1, and the
others are just lockdep fixups (I guess it's surprising virt_wifi
doesn't do this at all?).

FWIW I don't think virt_wifi really benefits at all from stacking, so we
could just do something like

--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -508,6 +508,9 @@ static int virt_wifi_newlink(struct net *src_net, struct net_device *dev,
        else if (dev->mtu > priv->lowerdev->mtu)
                return -EINVAL;
 
+       if (priv->lowerdev->ieee80211_ptr)
+               return -EINVAL;
+
        err = netdev_rx_handler_register(priv->lowerdev, virt_wifi_rx_handler,
                                         priv);
        if (err) {



IMHO, but of course generally limiting the stack depth is needed anyway
and solves the problem well enough for virt_wifi.


johannes

