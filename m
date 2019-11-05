Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA4FEFD1E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 13:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388386AbfKEMZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 07:25:26 -0500
Received: from canardo.mork.no ([148.122.252.1]:53839 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387833AbfKEMZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 07:25:26 -0500
Received: from miraculix.mork.no ([IPv6:2a02:2121:34b:47e9:c09a:74ff:fe7f:b715])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id xA5CPB1d025114
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 5 Nov 2019 13:25:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1572956713; bh=tOwwi/WeOCAIXQ192WTBNFpglAaamg3ZODywVvTUHmw=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=TQPqrfusN90nUJlTRNsYyYncuPUeOojDV5YcLmLltY5hrfo64AICKxTw4DIG5zqFE
         0ST3hDUderArNKlqL89Mw65AK+mf2BghLbW5Il2OLsV+xVFi/GFPx2RcU74UKBcPeM
         81UTV4gprHWz5YN/XYQX6UmnScSjuCPXZxKdToxk=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1iRxtR-00044x-QL; Tue, 05 Nov 2019 13:25:05 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>,
        davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
Organization: m
References: <00000000000013c4c1059625a655@google.com>
        <87ftj32v6y.fsf@miraculix.mork.no> <1572952516.2921.6.camel@suse.com>
Date:   Tue, 05 Nov 2019 13:25:05 +0100
In-Reply-To: <1572952516.2921.6.camel@suse.com> (Oliver Neukum's message of
        "Tue, 05 Nov 2019 12:15:16 +0100")
Message-ID: <875zjy33z2.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> writes:
> Am Montag, den 04.11.2019, 22:22 +0100 schrieb Bj=C3=B8rn Mork:
>> This looks like a false positive to me. max_datagram_size is two bytes
>> declared as
>>=20
>>         __le16 max_datagram_size;
>>=20
>> and the code leading up to the access on drivers/net/usb/cdc_ncm.c:587
>> is:
>>=20
>>         /* read current mtu value from device */
>>         err =3D usbnet_read_cmd(dev, USB_CDC_GET_MAX_DATAGRAM_SIZE,
>>                               USB_TYPE_CLASS | USB_DIR_IN | USB_RECIP_IN=
TERFACE,
>>                               0, iface_no, &max_datagram_size, 2);
>
> At this point err can be 1.
>
>>         if (err < 0) {
>>                 dev_dbg(&dev->intf->dev, "GET_MAX_DATAGRAM_SIZE failed\n=
");
>>                 goto out;
>>         }
>>=20
>>         if (le16_to_cpu(max_datagram_size) =3D=3D ctx->max_datagram_size)
>>=20
>>=20
>>=20
>> AFAICS, there is no way max_datagram_size can be uninitialized here.
>> usbnet_read_cmd() either read 2 bytes into it or returned an error,
>
> No. usbnet_read_cmd() will return the number of bytes transfered up
> to the number requested or an error.

Ah, OK. So that could be fixed with e.g.

  if (err < 2)
       goto out;


Or would it be better to add a strict length checking variant of this
API?  There are probably lots of similar cases where we expect a
multibyte value and a short read is (or should be) considered an error.
I can't imagine any situation where we want a 2, 4, 6 or 8 byte value
and expect a flexible length returned.

>> causing the access to be skipped.  Or am I missing something?
>
> Yes. You can get half the MTU. We have a similar class of bugs
> with MAC addresses.

Right.  And probably all 16 or 32 bit integer reads...

Looking at the NCM spec, I see that the wording is annoyingly flexible
wrt length - both ways.  E.g for GetNetAddress:

  To get the entire network address, the host should set wLength to at
  least 6. The function shall never return more than 6 bytes in response
  to this command.

Maybe the correct fix is simply to let usbnet_read_cmd() initialize the
full buffer regardless of what the device returns?  I.e.

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index dde05e2fdc3e..df3efafca450 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1982,7 +1982,7 @@ static int __usbnet_read_cmd(struct usbnet *dev, u8 c=
md, u8 reqtype,
                   cmd, reqtype, value, index, size);
=20
        if (size) {
-               buf =3D kmalloc(size, GFP_KERNEL);
+               buf =3D kzalloc(size, GFP_KERNEL);
                if (!buf)
                        goto out;
        }
@@ -1992,7 +1992,7 @@ static int __usbnet_read_cmd(struct usbnet *dev, u8 c=
md, u8 reqtype,
                              USB_CTRL_GET_TIMEOUT);
        if (err > 0 && err <=3D size) {
         if (data)
-            memcpy(data, buf, err);
+            memcpy(data, buf, size);
         else
             netdev_dbg(dev->net,
                 "Huh? Data requested but thrown away.\n");




What do you think?

Personally, I don't think it makes sense for a device to return a 1-byte
mtu or 3-byte mac address. But the spec allows it and this would at
least make it safe.

We have a couple of similar bugs elsewhere in the same driver, BTW..


Bj=C3=B8rn
