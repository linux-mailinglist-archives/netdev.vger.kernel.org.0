Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9AC36AC7A
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 08:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhDZGzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 02:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhDZGzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 02:55:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAC1C061763
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 23:55:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lav91-00040V-9U
        for netdev@vger.kernel.org; Mon, 26 Apr 2021 08:54:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3225F616F8D
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 06:54:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 67160616F6C;
        Mon, 26 Apr 2021 06:54:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f54d6cd7;
        Mon, 26 Apr 2021 06:54:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Erik Flodin <erik@flodin.me>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 3/4] can: add a note that RECV_OWN_MSGS frames are subject to filtering
Date:   Mon, 26 Apr 2021 08:54:51 +0200
Message-Id: <20210426065452.3411360-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426065452.3411360-1-mkl@pengutronix.de>
References: <20210426065452.3411360-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erik Flodin <erik@flodin.me>

Some parts of the documentation may lead the reader to think that the
socket's own frames are always received when CAN_RAW_RECV_OWN_MSGS is
enabled, but all frames are subject to filtering.

As explained by Marc Kleine-Budde:

On TX complete of a CAN frame it's pushed into the RX path of the
networking stack, along with the information of the originating socket.

Then the CAN frame is delivered into AF_CAN, where it is passed on to
all registered receivers depending on filters. One receiver is the
sending socket in CAN_RAW. Then in CAN_RAW the it is checked if the
sending socket has RECV_OWN_MSGS enabled.

Link: https://lore.kernel.org/r/20210420191212.42753-1-erik@flodin.me
Signed-off-by: Erik Flodin <erik@flodin.me>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/can.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index f8dae662e454..f34cb0e4460e 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -608,6 +608,8 @@ demand:
     setsockopt(s, SOL_CAN_RAW, CAN_RAW_RECV_OWN_MSGS,
                &recv_own_msgs, sizeof(recv_own_msgs));
 
+Note that reception of a socket's own CAN frames are subject to the same
+filtering as other CAN frames (see :ref:`socketcan-rawfilter`).
 
 .. _socketcan-rawfd:
 
-- 
2.30.2


