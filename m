Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA26F4AB20C
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 21:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbiBFU1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 15:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiBFU1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 15:27:11 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAD1C06173B
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 12:27:10 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id k17so9713373plk.0
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 12:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=h/0tdtlXs0f2c74BKbU4EN4hCZdI7RmdqckXJLTQnvE=;
        b=JxfoPPHDBdE3nzlX6BozZ9VP4EcqS6ft4D+w46EQwAupfpC0hc3n/uzIrF1ZobqnmG
         LpJhJ7AuMQW2TlbMSGk0BFp/laj3A9JixbJ4VySEY/Qm9LvYsAp+Kmb94QvESdtYqt6L
         34KS32bFtUqIYALFGA4oJPVE3C4ZzUHYfFpDJxv7JpuhorZtx7GSybEYFSML1Rw49qJh
         wORq2inRC6nMRCNaO1k7TIlB/k3r4DlDc40gqT5qCN9/nYjIL8jeUBHdB0OgDk+nATbL
         RwZKuRse75ZDZ1s5cTSrVzvhuQUtxr6ji0m0DEF2rdDGmWE+rFqfKeUaLOBGs5odU0r8
         GlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=h/0tdtlXs0f2c74BKbU4EN4hCZdI7RmdqckXJLTQnvE=;
        b=H4VRwohKig+qRbfpwMwTVAmuKIrzZzcbE98dTrlv9ES+FXiE+gGVt/6fKk8pqeyYOj
         vvZzBJNDTl+IeCG8sqyJ1TmvXK0lBcwvgv+zlGIi2qvGW86CYRMdxDThWy292bxX7wtt
         iAvox6iZfc/wJwRDRGnMOmqExwkaucwJNDDrfVLG6HSom85LHW8PWvXfkVSbitZLLiwC
         +3BSM9TjmRKOzt5YMtrM6/ePmFv0uwNKuSu4KTo0zYE0z2YA6YmIYfKRNOGaU5pLYpuW
         mhmXujC/xVtLZzUBvH0A+qmtDswOu2RczEnIdkGt9ZOMR3m1QT9vS2+7XdOJDpDtemnN
         iw7A==
X-Gm-Message-State: AOAM530mPOk8lNPQKOI3Mqw5thjdxEnd+Di863Yxd4NJGcXL5+fdIlmQ
        40q8wBrV2ToyfQ/lsp2yG89L9GwZ27avt4+El9he81rJ1nvhfQ==
X-Google-Smtp-Source: ABdhPJynS7lj/K51JN6hv4UpvU2m6GHCArA1uG90ie3Al733juiFlj0OiHXLd52gl73tymr/6Zyqds+UY80IkmpbOBA=
X-Received: by 2002:a17:90a:f198:: with SMTP id bv24mr14996275pjb.32.1644179229606;
 Sun, 06 Feb 2022 12:27:09 -0800 (PST)
MIME-Version: 1.0
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sun, 6 Feb 2022 17:26:58 -0300
Message-ID: <CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com>
Subject: net: dsa: realtek: silent indirect reg read failures on SMP
To:     netdev@vger.kernel.org,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Arin=C3=A7 reported an issue with interfaces going down and up in a fixed
interval (a little less than 40s). It happened with both SMI or MDIO
interfaces for two different rtl8365mb supported models.

The indirect read procedure is something like this:

rtl8365mb_phy_read
  rtl8365mb_phy_ocp_read
    rtl8365mb_phy_poll_busy
      regmap_read_poll_timeout(RTL8365MB_INDIRECT_ACCESS_STATUS_REG)
    rtl8365mb_phy_ocp_prepare
      regmap_update_bits(RTL8365MB_GPHY_OCP_MSB_0_REG)
      regmap_write(RTL8365MB_INDIRECT_ACCESS_ADDRESS_REG)
    regmap_write(RTL8365MB_INDIRECT_ACCESS_CTRL_REG)
    rtl8365mb_phy_poll_busy
      regmap_read_poll_timeout(RTL8365MB_INDIRECT_ACCESS_STATUS_REG)
    regmap_read(RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG)

And the write is similar. The regmap read/write does have its own
mutex. realtek-mdio does use a sequence of read/writes to mdio for
each read/write ops but beyond regmap internal locks, I also lock
bus->mdio_lock.

In a non-SMP system or with extra cores disabled, everything works as
expected. However, with an SMP system, there is some kind of
concurrent access to registers and
regmap_read(RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG) will eventually
read 0x0000. It is like the chip didn't have time to update that
register or got lost in the way. It only happens when the system is
idle. If you stress the CPU, the simultaneous register access gets
unsynchronized or serialized.

I can "simulate" a similar issue in a non-SMP system by dumping regmap
from non-used registers like 0x20a0 to 0x20ff (0x20a0 is related to
port 5 state, but I have 0,1,2,3,4 + 6,7). There are other regions
that cause the same behavior but [0x20a0,0x20ff] is the first one I
found. It never failed while reading good memory regions. Maybe it is
just caused by another issue like the chip getting confused while
reading undefined memory regions.

for a in $(seq 1000); do dd
if=3D/sys/kernel/debug/regmap/mdio-bus:1d/registers bs=3D11
skip=3D$((0x20a0)) count=3D$((0x1)) 2>/dev/null; done

(That range might not be precise as I don't know if dd is enough to
select only a specific range)

While the script is running, I can see both the driver and the debugfs
dump flicking between good data, garbage and zero. When DSA reads
0x0000, it brings the port down and up.

I tried to add a simple mutex over rtl8365mb_phy_ocp_read call but it
still failed to prevent the event in a SMP system (it would not
protect the debugfs dump). Maybe I'm missing something obvious.

I also wonder if all those functions that use a sequence of
regmap_{read,write} might need a mutex to protect from parallel
execution. I didn't find a way to create a "regmap transaction" by
locking it externally as its lock control is private as well as the
non-locked _regmap_read(). I could disable its lock and do it inside
the driver, but it would also disable the debugfs dump and add a bunch
of new code. And I don't even know if it would fix the issue.
Is there a better way to deal with this issue? Maybe force dsa polling
to use a single processor?

This is the failed patch.

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c
b/drivers/net/dsa/realtek/rtl8365mb.c
index 1a0562811c1a..5572271a2514 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -817,6 +817,7 @@ struct rtl8365mb_port {
 * @port_mask: mask of all ports
 * @learn_limit_max: maximum number of L2 addresses the chip can learn
 * @mib_lock: prevent concurrent reads of MIB counters
+ * @indirect_reg_lock: prevent concurrent access of indirect registers
 * @ports: per-port data
 * @jam_table: chip-specific initialization jam table
 * @jam_size: size of the chip's jam table
@@ -832,6 +833,7 @@ struct rtl8365mb {
       u32 port_mask;
       u32 learn_limit_max;
       struct mutex mib_lock;
+       struct mutex indirect_reg_lock;
       struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
       const struct rtl8365mb_jam_tbl_entry *jam_table;
       size_t jam_size;
@@ -989,6 +991,7 @@ static int rtl8365mb_phy_ocp_write(struct
realtek_priv *priv, int phy,

static int rtl8365mb_phy_read(struct realtek_priv *priv, int phy, int regnu=
m)
{
+       struct rtl8365mb *mb =3D priv->chip_data;
       u32 ocp_addr;
       u16 val;
       int ret;
@@ -1001,16 +1004,24 @@ static int rtl8365mb_phy_read(struct
realtek_priv *priv, int phy, int regnum)

       ocp_addr =3D RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE + regnum * 2;

-       ret =3D rtl8365mb_phy_ocp_read(priv, phy, ocp_addr, &val);
+       ret =3D mutex_lock_interruptible(&mb->indirect_reg_lock);
       if (ret) {
               dev_err(priv->dev,
-                       "failed to read PHY%d reg %02x @ %04x, ret %d\n", p=
hy,
+                       "read PHY%d reg %02x @ %04x, ret %d interrupted\n",=
 phy,
                       regnum, ocp_addr, ret);
               return ret;
       }

-       dev_dbg(priv->dev, "read PHY%d register 0x%02x @ %04x, val <- %04x\=
n",
-               phy, regnum, ocp_addr, val);
+       ret =3D rtl8365mb_phy_ocp_read(priv, phy, ocp_addr, &val);
+       if (ret)
+               dev_err(priv->dev,
+                       "failed to read PHY%d reg %02x @ %04x, ret %d\n", p=
hy,
+                       regnum, ocp_addr, ret);
+       else
+               dev_dbg(priv->dev, "read PHY%d register 0x%02x @ %04x,
val <- %04x\n",
+                       phy, regnum, ocp_addr, val);
+
+       mutex_unlock(&mb->indirect_reg_lock);

       return val;
}
@@ -1018,6 +1029,7 @@ static int rtl8365mb_phy_read(struct
realtek_priv *priv, int phy, int regnum)
static int rtl8365mb_phy_write(struct realtek_priv *priv, int phy, int regn=
um,
                              u16 val)
{
+       struct rtl8365mb *mb =3D priv->chip_data;
       u32 ocp_addr;
       int ret;

@@ -1029,18 +1041,26 @@ static int rtl8365mb_phy_write(struct
realtek_priv *priv, int phy, int regnum,

       ocp_addr =3D RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE + regnum * 2;

-       ret =3D rtl8365mb_phy_ocp_write(priv, phy, ocp_addr, val);
+       ret =3D mutex_lock_interruptible(&mb->indirect_reg_lock);
       if (ret) {
               dev_err(priv->dev,
-                       "failed to write PHY%d reg %02x @ %04x, ret %d\n", =
phy,
+                       "write PHY%d reg %02x @ %04x, ret %d
interrupted\n", phy,
                       regnum, ocp_addr, ret);
               return ret;
       }

-       dev_dbg(priv->dev, "write PHY%d register 0x%02x @ %04x, val -> %04x=
\n",
-               phy, regnum, ocp_addr, val);
+       ret =3D rtl8365mb_phy_ocp_write(priv, phy, ocp_addr, val);
+       if (ret)
+               dev_err(priv->dev,
+                       "failed to write PHY%d reg %02x @ %04x, ret %d\n", =
phy,
+                       regnum, ocp_addr, ret);
+       else
+               dev_dbg(priv->dev, "write PHY%d register 0x%02x @
%04x, val -> %04x\n",
+                       phy, regnum, ocp_addr, val);

-       return 0;
+       mutex_unlock(&mb->indirect_reg_lock);
+
+       return ret;
}

static int rtl8365mb_dsa_phy_read(struct dsa_switch *ds, int phy, int regnu=
m)
@@ -2215,6 +2235,8 @@ static int rtl8365mb_setup(struct dsa_switch *ds)

       mb =3D priv->chip_data;

+       mutex_init(&mb->indirect_reg_lock);
+
       ret =3D rtl8365mb_reset_chip(priv);
       if (ret) {
               dev_err(priv->dev, "failed to reset chip: %d\n", ret);
--
2.34.1


---
   Luiz
