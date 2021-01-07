Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29CB2ED6AE
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 19:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbhAGSZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 13:25:44 -0500
Received: from mail.nic.cz ([217.31.204.67]:47812 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbhAGSZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 13:25:44 -0500
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id AAA971420C4;
        Thu,  7 Jan 2021 19:25:00 +0100 (CET)
Date:   Thu, 7 Jan 2021 19:25:00 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Wolfram Sang <wsa@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Pali =?UTF-8?B?Um9ow6Fy?= <pali@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: question about i2c_transfer() function (regarding mdio-i2c on
 RollBall SFPs)
Message-ID: <20210107192500.54d2d0f0@nic.cz>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram and Russell,

I have a question regarding whether the struct i2c_msg array passed to
the i2c_transfer() function can have multiple messages refer to the
same buffers.

Previously Russell raised a point on my patch series adding support
for RollBall SFPs regarding the I2C MDIO access, which is done on I2C
address 0x51 on the upper 128 bytes when SFP page is set to 3.

https://lore.kernel.org/netdev/20201030152033.GC1551@shell.armlinux.org.uk/

Russell wrote
  "Also, shouldn't we ensure that we are on page 1 before attempting
   any access?"
  "I think this needs to be done in the MDIO driver - if we have
   userspace or otherwise expand what we're doing, relying on page 3
   remaining selected will be very fragile."

I have been thinking about this, and I think it is possible to switch
SFP_PAGE to a needed value, do some reads and writes on that page, and
restore the page to original value, all in one call to i2c_transfer.
This would have the advantage to be atomic (unless something breaks int
he I2C driver).

My question is whether this is allowed, whether the msgs array passed
to the i2c_transfer() function can have multiple msgs pointing to the
same buffer (the one into which the original page is first stored
with first i2c_msg and then restored from it in the last i2c_msg).

I looked into I2C drivers i2c-mv64xxx and i2c-pxa, and it looks that at
least for these two drivers, it should work.

What do you think?

It could look like this:

  struct i2c_msg msgs[10], *ptr;
  u8 saved_page[2], new_page[2];

  saved_page[0] = SFP_PAGE;
  new_page[0] = SFP_PAGE;
  new_page[1] = 3; /* RollBall MDIO access page */

  ptr = msgs;
  ptr = fill_read_msg(ptr, 0x51, &saved_page[0], 1, &saved_page[1], 1);
  ptr = fill_write_msg(ptr, 0x51, new_page, 2);

  /* here some more commands can be added */
  ...

  /* and this should restore the original page */
  ptr = fill_write_msg(ptr, 0x51, saved_page, 2);

  return i2c_transfer(i2c, msgs, ptr - msgs);

--
With fill_read_msg and fill_write_msg defined as such

  static inline struct i2c_msg *
  fill_read_msg(struct i2c_msg *msg, int addr,
		void *wbuf, size_t wlen,
		void *rbuf, size_t rlen)
  {
	msg->addr = addr;
	msg->flags = 0;
	msg->len = wlen;
	msg->buf = wbuf;
	++msg;
	msg->addr = addr;
	msg->flags = I2C_M_RD;
	msg->len = rlen;
	msg->buf = rbuf;
	++msg;

	return msg;
  }

  static inline struct i2c_msg *
  fill_write_msg(struct i2c_msg *msg, int addr, void *buf, size_t len)
  {
	msg->addr = addr;
	msg->flags = 0;
	msg->len = len;
	msg->buf = buf;	
	++msg;

	return msg;
  }
