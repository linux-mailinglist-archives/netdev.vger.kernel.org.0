Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782A3136458
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 01:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730231AbgAJAZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 19:25:47 -0500
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38756 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730173AbgAJAZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 19:25:47 -0500
Received: by mail-wr1-f43.google.com with SMTP id y17so126293wrh.5
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 16:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=26STNBKjIyeQ98C2vLlPkuIlpru3KKPtwhMyfycTQ8Y=;
        b=XDR3weAIZbBFuf0fWW7vaOER3nD3jebzjP4ff+duyHBJrtUUa4W9ZRVpqUafPhxPpV
         eWOQ1z8JNdx/dcgluduiqGRIiC0cHlze5LCb9VG+BW+91gZjbrbYKZB4tK2zHXO26LML
         4SP42TlUC+Pfg88OzLpdGmYriAnlTVrnUaee8kq0nNdVnbKMIU55ULwC6V/qH22qWZnx
         3Z1GaCM3qaz+wR2m+UrEmn6V79HjEtmYzHF16a3X4K/ZzZwZzxcHLJ+4MpYlerBDHGri
         tmic9Uni4Y2VBrSJKEvSrWwK6inW597JVOvLk6lXssz8lC/InvoQdi0TKmY3wRwxMxP/
         EgTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=26STNBKjIyeQ98C2vLlPkuIlpru3KKPtwhMyfycTQ8Y=;
        b=Yx7IBLnSRXg3Pn5isC7exjjbQB9qI/8eE2HUayaLICk6BXa9sG2p2LLzwIHkgeeyqH
         iYmtB2lAepKV/tM+edSLni/pkV4el1Xlz+7yysksoj5aZkA7l2JVvV2mbcTRxQEO0s73
         CkuG7dY6zqOi0+GcZJO88wYi6MakdzS2B151K/v6vlYs15Bj2AvYe0w2DlIhosoLHYtd
         99NF81cwThVwLyQvfAB6SI+QDKW9Bxwex+b1D6wKK03FwrezKjvMU5YL3LbXYdKCLSA9
         M5nBM2Wv6ktCOEr1+I8yfLbstQ4SdIFCnjGTr1Y98ojVJpr4ZhIRAcjCUn+RdkMgR6LZ
         odrw==
X-Gm-Message-State: APjAAAXrg25kOw3haeXLJQ0DN7UNFyp0kYgn2VIUTP65cnmjmvjx0Gwa
        MtC9lKl/eh/YEzLGAHIrMghFOvy0/ItdS1RpVHnA3fQU
X-Google-Smtp-Source: APXvYqyPnhw5qu6m458i4ezxKpokg4NO7ParCrrtQaikLeTqXeduF6FkuMtQOorZB/kUCdBJNh+HFLpdKLOMZGyxB0k=
X-Received: by 2002:a5d:6408:: with SMTP id z8mr171265wru.122.1578615943695;
 Thu, 09 Jan 2020 16:25:43 -0800 (PST)
MIME-Version: 1.0
From:   Chris Preimesberger <ccpisme@gmail.com>
Date:   Thu, 9 Jan 2020 18:25:07 -0600
Message-ID: <CAM0+VB-Zwr2Z+s1SS_rqokWcku43dwbZcRRFHZRdZJLFpkxXdQ@mail.gmail.com>
Subject: ethtool option to force interpretation of diagnostics?
To:     linville@tuxdriver.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


Problem:
I am testing some 10GbE RJ45 SFP+ modules and noticed that they
accurately report their operating temperature while installed in a
switch, but not while installed in a NIC that's being probed by
ethtool.  The ethtool install and NIC port in question are known to
properly report all diagnostics of installed fiber transceivers, so I
suspect that maybe my copper transceiver's diagnostics are being
ignored by ethtool because the diagnostic data from them is considered
incomplete, due to the transceiver not reporting any valid Laser
related diagnostics (because they have no laser); this is just a guess
as to why, and I don't know whether that's the case; I'd appreciate it
if anyone could confirm whether that's the case.

Question:
Is there currently a way to, or can an option be made to force ethtool
to read and interpret the transceiver's diagnostic data for cases like
mine, where diagnostic data exists, but is not displayed by default?


In case it helps, here is an example ethtool output from a transceiver
that accurately reports temp while installed in a switch, but not
while in a NIC and being probed by ethtool (some values masked with
xxxxxxxx for privacy):

tech1@E1:~$ ethtool --version
ethtool version 5.3
tech1@E1:~$
tech1@E1:~$ ethtool -i enp3s0f1
driver: ixgbe
version: 5.1.0-k
firmware-version: 0x0001546c
expansion-rom-version:
bus-info: 0000:03:00.1
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
tech1@E1:~$
tech1@E1:~$ sudo ethtool -m enp3s0f1
        Identifier                                : 0x03 (SFP)
        Extended identifier                       : 0x04 (GBIC/SFP
defined by 2-wire interface ID)
        Connector                                 : 0x22 (RJ45)
        Transceiver codes                         : 0x10 0x00 0x00
0x00 0x00 0x00 0x00 0x00 0x00
        Transceiver type                          : 10G Ethernet: 10G Base-SR
        Encoding                                  : 0x06 (64B/66B)
        BR, Nominal                               : 10300MBd
        Rate identifier                           : 0x00 (unspecified)
        Length (SMF,km)                           : 0km
        Length (SMF)                              : 0m
        Length (50um)                             : 0m
        Length (62.5um)                           : 0m
        Length (Copper)                           : 30m
        Length (OM3)                              : 0m
        Laser wavelength                          : 0nm
        Vendor name                               : xxxxxxxx
        Vendor OUI                                : xxxxxxxx
        Vendor PN                                 : xxxxxxxx
        Vendor rev                                : xxxxxxxx
        Option values                             : 0x00 0x1a
        Option                                    : RX_LOS implemented
        Option                                    : TX_FAULT implemented
        Option                                    : TX_DISABLE implemented
        BR margin, max                            : 0%
        BR margin, min                            : 0%
        Vendor SN                                 : xxxxxxxx
        Date code                                 : 191202
tech1@E1:~$


For reference, a more verbose output like this is what I'm hoping to
see, even if parts of the data displayed are invalid.  I'm willing to
figure out what data is or isn't valid:

tech1@E1:~$ sudo ethtool -m enp3s0f0
Identifier                                : 0x03 (SFP)
Extended identifier                       : 0x04 (GBIC/SFP defined by
2-wire interface ID)
Connector                                 : 0x07 (LC)
Transceiver codes                         : 0x20 0x00 0x00 0x00 0x00
0x00 0x00 0x00 0x00
Transceiver type                          : 10G Ethernet: 10G Base-LR
Encoding                                  : 0x06 (64B/66B)
BR, Nominal                               : 10300MBd
Rate identifier                           : 0x00 (unspecified)
Length (SMF,km)                           : 10km
Length (SMF)                              : 10000m
Length (50um)                             : 0m
Length (62.5um)                           : 0m
Length (Copper)                           : 0m
Length (OM3)                              : 0m
Laser wavelength                          : 1310nm
Vendor name                               : Transition
Vendor OUI                                : 00:c0:f2
Vendor PN                                 : TN-SFP-10G-LR
Vendor rev                                : V1.0
Option values                             : 0x00 0x1a
Option                                    : RX_LOS implemented
Option                                    : TX_FAULT implemented
Option                                    : TX_DISABLE implemented
BR margin, max                            : 0%
BR margin, min                            : 0%
Vendor SN                                 : AX19080004387
Date code                                 : 190218
Optical diagnostics support               : Yes
Laser bias current                        : 32.066 mA
Laser output power                        : 0.5547 mW / -2.56 dBm
Receiver signal average optical power     : 0.0001 mW / -40.00 dBm
Module temperature                        : 41.05 degrees C / 105.90 degrees F
Module voltage                            : 3.2768 V
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
Laser rx power low alarm                  : On
Laser rx power high warning               : Off
Laser rx power low warning                : On
Laser bias current high alarm threshold   : 100.000 mA
Laser bias current low alarm threshold    : 6.000 mA
Laser bias current high warning threshold : 90.000 mA
Laser bias current low warning threshold  : 7.000 mA
Laser output power high alarm threshold   : 1.2589 mW / 1.00 dBm
Laser output power low alarm threshold    : 0.1349 mW / -8.70 dBm
Laser output power high warning threshold : 1.1220 mW / 0.50 dBm
Laser output power low warning threshold  : 0.1514 mW / -8.20 dBm
Module temperature high alarm threshold   : 75.00 degrees C / 167.00 degrees F
Module temperature low alarm threshold    : -5.00 degrees C / 23.00 degrees F
Module temperature high warning threshold : 70.00 degrees C / 158.00 degrees F
Module temperature low warning threshold  : 0.00 degrees C / 32.00 degrees F
Module voltage high alarm threshold       : 3.6300 V
Module voltage low alarm threshold        : 2.9700 V
Module voltage high warning threshold     : 3.4650 V
Module voltage low warning threshold      : 3.1350 V
Laser rx power high alarm threshold       : 1.2589 mW / 1.00 dBm
Laser rx power low alarm threshold        : 0.0490 mW / -13.10 dBm
Laser rx power high warning threshold     : 1.1220 mW / 0.50 dBm
Laser rx power low warning threshold      : 0.0550 mW / -12.60 dBm
tech1@E1:~$


Thanks and best regards,
Chris Preimesberger
