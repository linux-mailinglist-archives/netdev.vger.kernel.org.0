Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5016AD2B2
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 00:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCFXPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 18:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCFXPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 18:15:07 -0500
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CB2EC75;
        Mon,  6 Mar 2023 15:14:38 -0800 (PST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1678144472; bh=bXYuXw1nXD9PxOc5tauF440JDT46qSdZD2UV4o2Whcw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=aU5viVmUd36Sn8KAdQhPK2BiZRrPYvWO1eF573qzuT+VtpFaLvpyPMPSmW/jGwPte
         1h63keH7tJxfTjOo46DtimcaRXEb12nDYR5MJ2yXu9WCs0W4OUfusAfV5Okj/sx2ov
         sNY9IHcdRUmtO3vsqv4C6MWThIVTBR3mKJA9eg7dY+wReIYt6tnJhORH6xY3O7SC/j
         l5WQATcCMXtPLmtNC/MyRbcmzFfbyJIJ6E1lqDJFforv4SJ9BlBGcBopmiXsp1x8Qy
         iDZOa2i8138FDPmBwm+N3tuS4J02c0rA0qm4FM0R5FQSXE7gp5gPwJmFktai/PMtvC
         C6L/4m83QciKw==
To:     Aleksander Bajkowski <olek2@wp.pl>, linux-wireless@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: ath9k: HE capabilities are incorrectly parsed on big endian
 platforms
In-Reply-To: <1188c4fb-a621-e5ff-3c4b-a8d16903f7ed@wp.pl>
References: <1188c4fb-a621-e5ff-3c4b-a8d16903f7ed@wp.pl>
Date:   Tue, 07 Mar 2023 00:14:30 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87zg8pa2w9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aleksander Bajkowski <olek2@wp.pl> writes:
> Hi,
>
> During a scan of the WiFi network, I discovered that HE capabilities=20
> (WiFi 6)
> are incorrectly displayed. This problem exists on OpenWRT running stable
> versions of the kernel (5.10 and 5.15). I verified later that the problem
> is present on other devices. I found that it only affects devices with
> Atheros radio (ath9k and ath10k-ct) running on the big endian platforms.
> On little endian platforms, everything looks OK.
>
> I suspect that the problem is in the ath9k driver because the mt76 driver
> on the big endian platform shows the correct capabilities.
>
> Most interesting is the comparison of raw data. The order of bytes in the
> words is reversed:
>
> |HE MAC Capabilities (0x010008120010): ||HE MAC Capabilities (0x000112081=
000):|
>
> Below you can see a summary of the tested routers, and the good and bad
> logs. The WiFI networks were scanned using the 'iw dev wlanX scan' comman=
d.
>
> Device=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 =C2=A0=C2=A0 Driver Endianess=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 HE Capab=
ilities
>
> TL-WDR4300=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 ath9k big=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Bad
> BT Home Hub 5A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ath10k-ct=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 big=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 Bad
> Xiaomi AX3200=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0 mt76=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 little=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Good
> AVM 7530=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ath10k-ct=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 little=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Good
> Netgear R6220=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mt76=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 big=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Good
>
>
> Bad:
>
> |HE capabilities: HE MAC Capabilities (0x010008120010): Minimum Payload=20
> size of 128 bytes: 1 All Ack Broadcast TWT Maximum A-MPDU Length=20
> Exponent: 1 NDP Feedback Report HE PHY Capabilities:=20
> (0x4c2002c06f5b951800cc00): HE160/HE80+80/5GHz Punctured Preamble RX: 2=20
> Doppler Rx DCM Max Constellation: 3 DCM Max NSS Tx: 1 DCM Max=20
> Constellation Rx: 1 DCM Max NSS Rx: 1 Rx HE MU PPDU from Non-AP STA=20
> Beamformee STS > 80Mhz: 6 Sounding Dimensions <=3D 80Mhz: 5 Sounding=20
> Dimensions > 80Mhz: 2 Ng =3D 16 MU Feedback Codebook Size SU Feedback=20
> Codebook Size MU Feedback Triggered MU Beamforming Feedback Triggered=20
> CQI Feedback Partial Bandwidth DL MU-MIMO 80MHz in 160/80+80MHz HE PPDU=20
> HE ER SU PPDU 1x HE-LTF 0.8us GI HE RX MCS and NSS set 80+80 MHz 1=20
> streams: MCS 0-7 2 streams: not supported 3 streams: MCS 0-9 4 streams:=20
> MCS 0-7 5 streams: not supported 6 streams: MCS 0-11 7 streams: not=20
> supported 8 streams: MCS 0-9 HE TX MCS and NSS set 80+80 MHz 1 streams:=20
> MCS 0-9 2 streams: MCS 0-7 3 streams: not supported 4 streams: MCS 0-9 5=
=20
> streams: not supported 6 streams: MCS 0-9 7 streams: MCS 0-7 8 streams:=20
> not supported|
>
>
> Good:
>
> |HE capabilities: HE MAC Capabilities (0x000112081000): +HTC HE=20
> Supported BSR OM Control Maximum A-MPDU Length Exponent: 2 OM Control UL=
=20
> MU Data Disable RX HE PHY Capabilities: (0x4c2002c06f5b951800cc00):=20
> HE40/HE80/5GHz HE160/5GHz 242 tone RUs/5GHz LDPC Coding in Payload NDP=20
> with 4x HE-LTF and 3.2us GI Rx HE MU PPDU from Non-AP STA SU Beamformer=20
> SU Beamformee MU Beamformer Beamformee STS <=3D 80Mhz: 3 Beamformee STS >=
=20
> 80Mhz: 3 Sounding Dimensions <=3D 80Mhz: 3 Sounding Dimensions > 80Mhz: 3=
=20
> Ng =3D 16 SU Feedback Codebook Size SU Feedback Triggered SU Beamforming=
=20
> Feedback Triggered CQI Feedback PPE Threshold Present Max NC: 3 TX=20
> 1024-QAM RX 1024-QAM HE RX MCS and NSS set <=3D 80 MHz 1 streams: MCS 0-1=
1=20
> 2 streams: MCS 0-11 3 streams: MCS 0-11 4 streams: MCS 0-11 5 streams:=20
> not supported 6 streams: not supported 7 streams: not supported 8=20
> streams: not supported HE TX MCS and NSS set <=3D 80 MHz 1 streams: MCS=20
> 0-11 2 streams: MCS 0-11 3 streams: MCS 0-11 4 streams: MCS 0-11 5=20
> streams: not supported 6 streams: not supported 7 streams: not supported=
=20
> 8 streams: not supported HE RX MCS and NSS set 160 MHz 1 streams: MCS=20
> 0-11 2 streams: MCS 0-11 3 streams: MCS 0-11 4 streams: MCS 0-11 5=20
> streams: not supported 6 streams: not supported 7 streams: not supported=
=20
> 8 streams: not supported HE TX MCS and NSS set 160 MHz 1 streams: MCS=20
> 0-11 2 streams: MCS 0-11 3 streams: MCS 0-11 4 streams: MCS 0-11 5=20
> streams: not supported 6 streams: not supported 7 streams: not supported=
=20
> 8 streams: not supported PPE Threshold 0x7b 0x1c 0xc7 0x71 0x1c 0xc7=20
> 0x71 0x1c 0xc7 0x71 0x1c 0xc7 0x71|

+Felix, in the hope he has an idea of where to go looking for the cause
of this...

-Toke
