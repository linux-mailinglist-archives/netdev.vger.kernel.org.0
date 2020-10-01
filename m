Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA3C280317
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbgJAPqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:46:09 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:17347 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732449AbgJAPqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 11:46:09 -0400
Received: from tomoyo.flets-east.jp ([153.230.197.127])
        by mwinf5d31 with ME
        id afls2300W2lQRaH03fm0uA; Thu, 01 Oct 2020 17:46:06 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Thu, 01 Oct 2020 17:46:06 +0200
X-ME-IP: 153.230.197.127
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Subject: Re: [PATCH v2 2/6] can: dev: add a helper function
Date:   Fri,  2 Oct 2020 00:45:31 +0900
Message-Id: <20201001154531.3217-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1798400d-abc1-e6dd-2d19-41e82ca6e43e@pengutronix.de>
References: <20200926175810.278529-1-mailhol.vincent@wanadoo.fr> <20200930144602.10290-3-mailhol.vincent@wanadoo.fr> <1798400d-abc1-e6dd-2d19-41e82ca6e43e@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static inline int get_can_len(struct sk_buff *skb)
> 
> make this return an u8
> make the skb const
> 
> > +{
> > +	struct canfd_frame *cf =3D (struct canfd_frame *)skb->data;
> 
> const
> 
> > +
> > +	if (can_is_canfd_skb(skb))
> > +		return min_t(__u8, cf->len, CANFD_MAX_DLEN);
> 
> u8
> 
> > +	else if (cf->can_id & CAN_RTR_FLAG)
> > +		return 0;
> > +	else
> > +		return min_t(__u8, cf->len, CAN_MAX_DLEN);
> 
> u8

Noted. All those changes will be addressed in v3 series.
Thank you.

As a side note, macros get_can_dlc() and get_canfd_dlc of the same
file (include/linux/can/dev.h) also use __u8 instead of u8. Do you
want me to add a patch to change these as below?

 /*
  * get_can_dlc(value) - helper macro to cast a given data length code (dlc)
- * to __u8 and ensure the dlc value to be max. 8 bytes.
+ * to u8 and ensure the dlc value to be max. 8 bytes.
  *
  * To be used in the CAN netdriver receive path to ensure conformance with
  * ISO 11898-1 Chapter 8.4.2.3 (DLC field)
  */
-#define get_can_dlc(i)         (min_t(__u8, (i), CAN_MAX_DLC))
-#define get_canfd_dlc(i)       (min_t(__u8, (i), CANFD_MAX_DLC))
+#define get_can_dlc(i)         (min_t(u8, (i), CAN_MAX_DLC))
+#define get_canfd_dlc(i)       (min_t(u8, (i), CANFD_MAX_DLC))
 
 /* Check for outgoing skbs that have not been created by the CAN subsystem */
 static inline bool can_skb_headroom_valid(struct net_device *dev,
