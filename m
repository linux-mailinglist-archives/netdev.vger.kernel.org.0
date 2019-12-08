Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE11A1160BB
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 06:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfLHFkk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Dec 2019 00:40:40 -0500
Received: from c.mail.sonic.net ([64.142.111.80]:49980 "EHLO c.mail.sonic.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfLHFkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Dec 2019 00:40:40 -0500
X-Greylist: delayed 652 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2019 00:40:40 EST
Received: from [192.168.42.66] (173-228-4-7.dsl.dynamic.fusionbroadband.com [173.228.4.7])
        (authenticated bits=0)
        by c.mail.sonic.net (8.15.1/8.15.1) with ESMTPSA id xB85TkBK005092
        (version=TLSv1.2 cipher=DHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 7 Dec 2019 21:29:46 -0800
From:   Guy Harris <guy@alum.mit.edu>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Should TPACKET_ALIGNMENT be defined as 16U rather than just 16, to
 avoid undefined behavior warnings?
Message-Id: <E6234DB1-C99F-48EC-8D33-3285BD8BD496@alum.mit.edu>
Date:   Sat, 7 Dec 2019 21:29:45 -0800
To:     netdev <netdev@vger.kernel.org>
X-Mailer: Apple Mail (2.3445.104.11)
X-Sonic-CAuth: UmFuZG9tSVYzUXSinkcRyjU/hit4FzvmC1y/DLKAnO2MgQwSyt8zTcWccppDlqjaRT1s4Zn7BcG2TBNuGIKMhOssJ96rOkBg
X-Sonic-ID: C;hJ3BvnsZ6hGdbP7Ubmlb6w== M;jp0lv3sZ6hGdbP7Ubmlb6w==
X-Spam-Flag: No
X-Sonic-Spam-Details: 0.0/5.0 by cerberusd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if_packet.h defines:

	#define TPACKET_ALIGNMENT	16
	#define TPACKET_ALIGN(x)	(((x)+TPACKET_ALIGNMENT-1)&~(TPACKET_ALIGNMENT-1))

Some compilers may, if TPACKET_ALIGN() is passed an unsigned value, give a warning that the result of converting ~(TPACKET_ALIGNMENT-1) to an unsigned int is undefined, as ~(TPACKET_ALIGNMENT-1) evaluates to -16 (0xFFFFFFF0), and C doesn't specify the behavior when converting negative values to an unsigned type.

In *practice*, with all the compilers we're likely to see, it just converts it to 4294967280U (0xFFFFFFF0), which is the desired behavior, but it might be cleaner (and produce fewer warnings when compiling code using TPACKET_ALIGN() or any of the macros using it) if TPACKET_ALIGNMENT were defined as 16U, rather than 16, as the entire computation will be done with unsigned integers.

netlink.h was changed to define NLMSG_ALIGNTO as 4U rather than 4, perhaps for the same reason.
