Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D8513456E
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 15:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgAHOzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 09:55:36 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54361 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgAHOzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 09:55:36 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1ipCkB-0003ef-Bn; Wed, 08 Jan 2020 15:55:35 +0100
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: [BUG] pfifo_fast may cause out-of-order CAN frame transmission
Cc:     Sascha Hauer <kernel@pengutronix.de>
Message-ID: <661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de>
Date:   Wed, 8 Jan 2020 15:55:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've run into an issue of CAN frames being sent out-of-order on an i.MX6 Dual
with Linux v5.5-rc5. Bisecting has lead me down to this commit:

ba27b4cdaaa ("net: dev: introduce support for sch BYPASS for lockless qdisc")

With it, using pfifo_fast, every few hundred frames, FlexCAN's .ndo_start_xmit is
passed frames in an order different from how userspace stuffed them into the same
socket.

Reverting it fixes the issue as does booting with maxcpus=1 or using pfifo
instead of pfifo_fast.

According to [1], such reordering shouldn't be happening.

Details on my setup:
Kernel version: v5.5-rc5, (occurs much more often with LOCKDEP turned on)
CAN-Bitrate: 250 kbit/s
CAN frames are generated with:
cangen canX -I2 -L1 -Di -i -g0.12 -p 100
which keeps polling after ENOBUFS until socket is writable, sends out a CAN
frame with one incrementing payload byte and then waits 120 usec before repeating.

Please let me know if any additional info is needed.

Cheers
Ahmad

[1]: http://linux-tc-notes.sourceforge.net/tc/doc/sch_pfifo_fast.txt

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
