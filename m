Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120A230136C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 06:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbhAWFlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 00:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbhAWFli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 00:41:38 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECEFC06174A;
        Fri, 22 Jan 2021 21:40:57 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id x6so7677224ybr.1;
        Fri, 22 Jan 2021 21:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=03/Y36mzYVxbtK/mFMaH4uFEzgZnAC+URADhOZPlVXk=;
        b=cDzMt/iorc7NK+p9noSntxgQqgucrYoB4D8MLvvC2cw7BBR0n7giTqtFAjgYUNyuIB
         1uviCzRakvco06yt87T8e+A+Wbe7pjYQ9mEkwZKXMugNIOsP5zgq9kA8sF/RmfQaKOdD
         f+z99Mgcg09fzonX11EEAKGDfttSDkBoZ4cCP3lIzPwcRGHPbwlK6li8S5Pb4lDM4ijJ
         iEazYvFxCa1YMgq0EMt7w/OUdxjPiafIZ7/Q9pJO4JcJfyaGCc8QydPyzSyOznxJApUE
         e2BeJzxsGw7C6CIiAr/jCl5GVqXSM3ARgk3oOEJiXpLolKTZiBSRIh39XiPkyOyW0Pa0
         pcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=03/Y36mzYVxbtK/mFMaH4uFEzgZnAC+URADhOZPlVXk=;
        b=GRgoQu922M35SSYAJ7U2J8VsaPDBE3o7+c4grwr/z3BvyVXR0cHFVWnPKYEJk9lpuc
         K7TZwSdsRSobuTj3b6bo2aJQjX1ITIsEzT7r9B3UfQfJneWOim+D4mfiIo5uufbRDBqL
         29j/0sW1xmMGS/MSsYSPGgJ4qs+maay/XjI950hM8+8TtvWVXEhr1PMBEYsom/Ww7Hta
         pLKsKIeImTQufz0msSNzkoFd7M/hxJZhWczBu7Wq/Ii5k2ena1GTwNaNkWzTeBvNjlFz
         tXXJ3R8xOtSHbOwdkdj5dwBhZh17M43GMMxeKYwFJJ3YYbtRthesTMPR0iL5zVLrjohh
         w+TQ==
X-Gm-Message-State: AOAM532HursR7tL+m5UlvnqCw9UxQWCt1wAm5E54Q92w6yhTg1ZZY1dS
        BgAuEVbWmsdY6cPgJH/APfKsG0IvhAQsm7caHNM=
X-Google-Smtp-Source: ABdhPJzUjLjUGt+ghARaavXE/vfDAzwC4IkMmm+GlQyG00bio39+Pf78Yh6USxsM0fZvprfT5EOt8RfFxJoPNVHeCmA=
X-Received: by 2002:a25:c544:: with SMTP id v65mr10612520ybe.167.1611380456246;
 Fri, 22 Jan 2021 21:40:56 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Date:   Sat, 23 Jan 2021 13:40:30 +0800
Message-ID: <CAD-N9QUdXFhTqZXpjg02Ya7viR8WmkORbU7pwNTquNg8k_kzMg@mail.gmail.com>
Subject: Duplicate crash reports related with smsc75xx/smsc95xx and root cause analysis
To:     davem@davemloft.net, kuba@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear kernel developers,

I found that on the syzbot dashboard, =E2=80=9CKMSAN: uninit-value in
smsc75xx_read_eeprom (2)=E2=80=9D [1],
"KMSAN: uninit-value in smsc95xx_read_eeprom (2)" [2], "KMSAN:
uninit-value in smsc75xx_bind" [3],
"KMSAN: uninit-value in smsc95xx_reset" [4], "KMSAN: uninit-value in
smsc95xx_wait_eeprom (2)" [5]
should share the same root cause.

## Root Cause Analysis && Different behaviors

The root cause of these crash reports resides in the
"__smsc75xx_read_reg/__smsc95xx_read_reg". Take __smsc95xx_read_reg as
an example,

---------------------------------------------------------------------------=
--------------------------------------
static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
                                            u32 *data, int in_pm)
{
        u32 buf;
        int ret;
        int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);

        BUG_ON(!dev);

        if (!in_pm)
                fn =3D usbnet_read_cmd;
        else
                fn =3D usbnet_read_cmd_nopm;

        ret =3D fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
                 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
                 0, index, &buf, 4);
        if (unlikely(ret < 0)) {
                netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\=
n",
                            index, ret);
                return ret;
        }

        le32_to_cpus(&buf);
        *data =3D buf;

        return ret;
}


static int __must_check smsc95xx_eeprom_confirm_not_busy(struct usbnet *dev=
)
{
        unsigned long start_time =3D jiffies;
        u32 val;
        int ret;

        do {
                ret =3D smsc95xx_read_reg(dev, E2P_CMD, &val);
                if (ret < 0) {
                        netdev_warn(dev->net, "Error reading E2P_CMD\n");
                        return ret;
                }

                if (!(val & E2P_CMD_BUSY_))
                        return 0;
        ......
}
---------------------------------------------------------------------------=
--------------------------------------

In a special situation, local variable "buf" is not initialized with
"fn" function invocation. And the ret is bigger than zero, and buf is
assigned to "*data". In its parent function -
smsc95xx_eeprom_confirm_not_busy, KMSAN reports "uninit-value" when
accessing variable "val".
Note, due to the lack of testing environment, I don't know the
concrete reason for the uninitialization of "buf" local variable.

The reason for such different crash behaviors is that the event -
"buf" is not initialized is random when
"__smsc75xx_read_reg/__smsc95xx_read_reg" is invoked.

## Patch

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 4353b370249f..a8e500d92285 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -76,7 +76,7 @@ static int smsc75xx_phy_gig_workaround(struct usbnet *dev=
);
 static int __must_check __smsc75xx_read_reg(struct usbnet *dev, u32 index,
                                            u32 *data, int in_pm)
 {
-       u32 buf;
+       u32 buf =3D 0;
        int ret;
        int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 4c8ee1cff4d4..dae3be723e0c 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -70,7 +70,7 @@ MODULE_PARM_DESC(turbo_mode, "Enable multiple frames
per Rx transaction");
 static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
                                            u32 *data, int in_pm)
 {
-       u32 buf;
+       u32 buf =3D 0;
        int ret;
        int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);

If you can have any issues with this statement or our information is
useful to you, please let us know. Thanks very much.

[1] =E2=80=9CKMSAN: uninit-value in smsc75xx_read_eeprom (2)=E2=80=9D - url
[2] =E2=80=9CKMSAN: uninit-value in smsc95xx_read_eeprom (2)=E2=80=9D - URL
[3] "KMSAN: uninit-value in smsc75xx_bind" -
[4] "KMSAN: uninit-value in smsc95xx_reset" -
[5] "KMSAN: uninit-value in smsc95xx_wait_eeprom (2)" -

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
