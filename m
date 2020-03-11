Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B0F181E31
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 17:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgCKQpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 12:45:12 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:40718 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729809AbgCKQpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 12:45:12 -0400
Received: by mail-wr1-f53.google.com with SMTP id p2so3524124wrw.7
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 09:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=2FyLM1glfWEEIL1y2h67Mbi0dhz3fT8aZIsT6NQjYo4=;
        b=rK+m5l6+C6/SIzA5E029VlZk6kxv1FZRPkwid/zoC5Uzp6HgHaUpz7f9XB8QJyZzLf
         g97VBKOUmyij6uTQRqBPkBlZiGIol0VygV43JN5lDBFYIvjKkr6HViRUZDRvM0a65ij/
         GKR1AapqP1BhTTQro7BK3yssJpoGQtkZoUpgGcmB32ouNiQ9S8bVrk1AwT4AK7bvRzJQ
         jgwd3b2N2SmrbkirXMyNctOYmg2dUOUvCxnTHvOVgIJww7YFQj6zwZrSjh2G1t9RC22F
         uIBDa4triVNNFLc/h37J5UoZwicO6PWQ++o2Ot8v580a7D/iDkETDJ8fz3wq9HX/s2z1
         fxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=2FyLM1glfWEEIL1y2h67Mbi0dhz3fT8aZIsT6NQjYo4=;
        b=eAJRV9tw3DZ+Wbx7qnK/CaOyigJG2mQb9xElpR+KGjuvgzyVKnuJpX2Adb8tByMhrK
         6eQJ64mATPtYfrzVSQrrd1kZ4XtWI/+1rgc/Coc3NFF7SfyxsW8fuarkqActebG2ZF5o
         R3MRCEuu1BW5UDGiC3mozlf0nAf/y64Tcfl88EwUkzky5h15k8qiwRrH7H6aRtzEPX6V
         lY0v66EJQSCUyGAPr7Ak49ugzwWZCctCyBCEwYWCs4MFYsQGrwdyK3j3JOlUZathyQZk
         iNxlOesrrzVlSnX0cjDeBkUfnbFyA/L4tOyhtmwnXf/i8AnB02l0XTEbQGRs6yCMuBq5
         xrdA==
X-Gm-Message-State: ANhLgQ1CqpS/7wyK+tkCLSKkAJmz9AAZp4s37/7Muins1UHa2ZGSkP8e
        BY0fXfB+baoZmjoDeqGtozX6/IO67nirhRri6YtiT+GD
X-Google-Smtp-Source: ADFU+vskgipGsBpSWwqRewmiAzmAPBe5gSanH4yBWH2n9wJfOjJTgE+gizLRQG2F6KNBRSYoEC9VAeg9Dgm3loFi+74=
X-Received: by 2002:a5d:4a49:: with SMTP id v9mr5375482wrs.343.1583945109184;
 Wed, 11 Mar 2020 09:45:09 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Preimesberger <ccpisme@gmail.com>
Date:   Wed, 11 Mar 2020 11:44:33 -0500
Message-ID: <CAM0+VB8HvLR-KRPZZ643djhGzVPbECm_-ffh5vxp+80mxeANBg@mail.gmail.com>
Subject: ethtool -m bug: transceiver made for fiber is misreported as
 supporting copper
To:     linville@tuxdriver.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


I noticed a problem of fiber optic transceiver OM4 distance ratings
being mis-reported as copper distance when using ethtool v5.4, and I
thing the root cause is an ethtool bug. Can this be fixed so that
ethtool reports "Length (OM4)" in meters while fiber optic
transceivers are installed, and "Length (Copper)" in meters while
copper transceivers are installed?  Thank you.

Here's more info:

According to SFF-8472 rev 12.3, Table 4-1:
A0h 18, Byte 1 is dedicated to indicating the supported length of
either 50=C2=B5m OM4 fiber cable, or copper cable, with this description:
=E2=80=9C
Link length supported for 50um OM4 fiber, units of 10m.
Alternatively copper or direct attach cable, units of m
=E2=80=9C

Below is a CLI transcript showing the problem; ethtool incorrectly
indicates that a fiber optic transceiver rated for up to 100m of OM4
fiber is made for up to 10m of copper:

tech1@E13:~$ ethtool --version
ethtool version 5.4
tech1@E13:~$ sudo ethtool -m enp3s0f1
                Identifier                                : 0x03 (SFP)
                Extended identifier                       : 0x04
(GBIC/SFP defined by 2-wire interface ID)
                Connector                                 : 0x07 (LC)
                Transceiver codes                         : 0x00 0x00
0x00 0x00 0x00 0x00 0x00 0x00 0x02
                Transceiver type                          : Extended:
100G Base-SR4 or 25GBase-SR
                Encoding                                  : 0x06 (64B/66B)
                BR, Nominal                               : 26000MBd
                Rate identifier                           : 0x00 (unspecifi=
ed)
                Length (SMF,km)                           : 0km
                Length (SMF)                              : 0m
                Length (50um)                             : 100m
                Length (62.5um)                           : 100m
                Length (Copper)                           : 10m
                Length (OM3)                              : 70m
                Laser wavelength                          : 850nm
                Vendor name                               : FS
                Vendor OUI                                : 00:17:6a
                Vendor PN                                 : SFP28-25GSR-85
                Vendor rev                                : 01
                Option values                             : 0x08 0x1a
                Option                                    : RX_LOS implemen=
ted
                Option                                    : TX_FAULT implem=
ented
                Option                                    : TX_DISABLE
implemented
                Option                                    : Retimer or
CDR implemented
                BR margin, max                            : 0%
                BR margin, min                            : 0%
                Vendor SN                                 : G1907043057
                Date code                                 : 190922
                Optical diagnostics support               : Yes
                Laser bias current                        : 6.104 mA
                Laser output power                        : 1.5198 mW / 1.8=
2 dBm
                Receiver signal average optical power     : 1.4392 mW / 1.5=
8 dBm
                Module temperature                        : 41.52
degrees C / 106.74 degrees F
                Module voltage                            : 3.3840 V
                Alarm/warning flags implemented           : Yes
                Laser bias current high alarm             : Off
                Laser bias current low alarm              : Off
                Laser bias current high warning           : Off
                Laser bias current low warning            : Off
                Laser output power high alarm             : Off
                Laser output power low alarm              : Off
                Laser output power high warning           : Off
                Laser output power low warning            : Off
                Module temperature high alarm             : Off
                Module temperature low alarm              : Off
                Module temperature high warning           : Off
                Module temperature low warning            : Off
                Module voltage high alarm                 : Off
                Module voltage low alarm                  : Off
                Module voltage high warning               : Off
                Module voltage low warning                : Off
                Laser rx power high alarm                 : Off
                Laser rx power low alarm                  : Off
                Laser rx power high warning               : Off
                Laser rx power low warning                : Off
                Laser bias current high alarm threshold   : 11.000 mA
                Laser bias current low alarm threshold    : 2.000 mA
                Laser bias current high warning threshold : 10.000 mA
                Laser bias current low warning threshold  : 3.000 mA
                Laser output power high alarm threshold   : 2.2387 mW / 3.5=
0 dBm
                Laser output power low alarm threshold    : 0.1258 mW
/ -9.00 dBm
                Laser output power high warning threshold : 2.0000 mW / 3.0=
1 dBm
                Laser output power low warning threshold  : 0.1737 mW
/ -7.60 dBm
                Module temperature high alarm threshold   : 80.00
degrees C / 176.00 degrees F
                Module temperature low alarm threshold    : -10.00
degrees C / 14.00 degrees F
                Module temperature high warning threshold : 70.00
degrees C / 158.00 degrees F
                Module temperature low warning threshold  : 0.00
degrees C / 32.00 degrees F
                Module voltage high alarm threshold       : 3.6000 V
                Module voltage low alarm threshold        : 3.0000 V
                Module voltage high warning threshold     : 3.5000 V
                Module voltage low warning threshold      : 3.1000 V
                Laser rx power high alarm threshold       : 2.2387 mW / 3.5=
0 dBm
                Laser rx power low alarm threshold        : 0.0630 mW
/ -12.01 dBm
                Laser rx power high warning threshold     : 2.0000 mW / 3.0=
1 dBm
                Laser rx power low warning threshold      : 0.0870 mW
/ -10.60 dBm
tech1@E13:~$ sudo ethtool -m enp3s0f1 hex on
Offset                   Values
------                      ------
0x0000:                 03 04 07 00 00 00 00 00 00 00 00 06 ff 00 00 00
0x0010:                 0a 0a 0a 07 46 53 20 20 20 20 20 20 20 20 20 20
0x0020:                 20 20 20 20 02 00 17 6a 53 46 50 32 38 2d 32 35
0x0030:                 47 53 52 2d 38 35 20 20 30 31 20 20 03 52 00 b7
0x0040:                 08 1a 68 00 47 31 39 30 37 30 34 33 30 35 37 20
0x0050:                 20 20 20 20 31 39 30 39 32 32 20 20 68 fa 08 56
0x0060:                 00 00 11 cc 89 48 9f a4 5a 30 d2 72 a0 2d 5c fe
0x0070:                 4d b0 fe 00 00 00 00 00 00 00 00 00 09 18 d7 8f
0x0080:                 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0090:                 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00a0:                 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00b0:                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00c0:                 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00d0:                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00e0:                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00f0:                 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0100:                 50 00 f6 00 46 00 00 00 8c a0 75 30 88 b8 79 18
0x0110:                 15 7c 03 e8 13 88 05 dc 57 73 04 ea 4e 20 06 c9
0x0120:                 57 73 02 76 4e 20 03 66 00 00 00 00 00 00 00 00
0x0130:                 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0140:                 00 00 00 00 3f 80 00 00 00 00 00 00 01 00 00 00
0x0150:                 01 00 00 00 01 00 00 00 01 00 00 00 00 00 00 f7
0x0160:                 29 64 84 30 0b ec 3a ee 38 38 00 00 00 00 30 00
0x0170:                 00 00 82 25 00 00 00 00 00 00 00 00 00 00 00 00
0x0180:                 43 4d 55 49 41 52 41 43 41 41 31 30 2d 33 32 32
0x0190:                 37 2d 30 31 56 30 31 20 01 00 46 00 00 00 00 cf
0x01a0:                 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01b0:                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01c0:                 53 46 50 2d 32 35 47 2d 53 52 2d 53 20 20 20 20
0x01d0:                20 20 20 20 30 34 00 00 00 00 00 00 00 00 00 7a
0x01e0:                00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x01f0:                 00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00
tech1@E13:~$


If you have any questions, or need more info, please ask. Thank you!!

--=20
Best regards,
Chris Preimesberger
Otsego, MN
