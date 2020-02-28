Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3F1173F05
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgB1SCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:02:51 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:56557 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgB1SCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:02:49 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9F51023E29;
        Fri, 28 Feb 2020 19:02:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582912966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IIolW/9xNzEYpVQY0js/vSS0I6ZWuT1Q1y2sroTURdE=;
        b=Znlmd4OB3KWqQcko68ASQwF820vLtU5RtY/1R64OoTIUaut6v58lUdMIoc0EKOD78btNk+
        7BtAQnV89tRAXk6ZINTxxQDJVVV06m2pdQf4OliaVvLN+L1x5ZtgdjGZMai0HOttIJyZXU
        7kRpx5d6wsHy7xfp6o7GlCIU30MUiIc=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [RFC PATCH v2 0/2] AT8031 PHY timestamping support
Date:   Fri, 28 Feb 2020 19:02:24 +0100
Message-Id: <20200228180226.22986-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 9F51023E29
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[9];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've put some additional time into figuring out how the PHY works since my
last RFC. My previous comments on the interrupt handling was caused by my
broken setup.

This patchset is the current state of my work for adding PHY
timestamping support. I just wanted to post this to the mailinglist
before I never do it. Maybe its a starting point for other people. That
being said, I wouldn't mind comments ;) Also I like to share my findings
about the PHY. The PHY has three major caveats which IMHO makes it really
hard to work properly.

 (1) The PHY doesn't support atomic reading of the (timestamp,
     messageType, sequenceId) tuple. The workaround is to read the
     timestamp again and check if it has changed. Actually, you'd have
     to read the complete tuple again.
 (2) The PHY generates an interrupt on every PTP packet not only on
     event messages. Thus the interrupt handler may read the capture
     registers and then determine that nothing has changed. This also
     means we have to remember the last read timestamp. I make the
     assumption that the timestamp is unique.
 (3) The biggest drawback is that the PHY only provide one set of RX and
     TX capture registers. It is possible that the timestamp will change
     when another PTP event message is received while we are still
     reading the timestamp of the previously received packet.

Example A
The driver basically works when there is low PTP traffic. Eg. the
following works pretty good.

ptp4l -m -2 -i eth0 -f ptp.cfg -s

ptp.cfg:
  [global]
  tx_timestamp_timeout 100

Example B
But if you're using a P2P clock with peer delay requests this whole
thing falls apart because of caveat (3). You'll often see messages like
  received SYNC without timestamp
or
 received PDELAY_RESP without timestamp
in linuxptp. Sometimes it working for some time and then it starts to
loosing packets. I suspect this depends on how the PDELAY messages are
interleaved with the SYNC message. If there is not enough time to until
the next event message is received either of these two messages won't
have a timestamp.

ptp4l -m -f gPTP.cfg -i eth0 -s

gPTP.cfg is the one from stock linuxptp with tx_timestamp_timeout set to
100.

The PHY also supports appending the timestamp to the actual ethernet frame,
but this seems to only work when the PHY is connected via RGMII. I've never
get it to work with a SGMII connection.

The first patch might actually be useful outside of this series. See also
  https://lore.kernel.org/netdev/bd47f8e1ebc04fa98856ed8d89b91419@walle.cc/

Changes since RFC v1:
net: phy: let the driver register its own IRQ handler
 - fixed mistake for calling phy_request_interrupt(). Thanks Heiner.
 - removed phy_drv_interrupt(). just calling phy_mac_interrupt()

net: phy: at803x: add PTP support for AR8031
 - moved rereading the timestamp out of at8031_read_ts() to
   at8031_get_rxts()/at8031_get_txts().
 - call phy_mac_interrupt() instead of phy_drv_interrupt()

Please note that Heiner suggested that I should use handle_interrupt()
instead of registering my own handler. I've still included my old patch
here because the discussion is still ongoing and the proposed fix is only
working for this use case. See also
  https://lore.kernel.org/netdev/2e4371354d84231abf3a63deae1a0d04@walle.cc/

-michael

Michael Walle (2):
  net: phy: let the driver register its own IRQ handler
  net: phy: at803x: add PTP support for AR8031

 drivers/net/phy/Kconfig      |  17 +
 drivers/net/phy/at803x.c     | 855 ++++++++++++++++++++++++++++++++++-
 drivers/net/phy/phy_device.c |   6 +-
 include/linux/phy.h          |   1 +
 4 files changed, 852 insertions(+), 27 deletions(-)

-- 
2.20.1

