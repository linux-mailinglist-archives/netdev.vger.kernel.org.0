Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1BC3C7552
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhGMQyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhGMQyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:54:22 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2099DC0613DD;
        Tue, 13 Jul 2021 09:51:32 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h8so20793715eds.4;
        Tue, 13 Jul 2021 09:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=jK04uo/vbPumFkNdoQhNVaBxn4ECjuVk27Ah92guxCA=;
        b=hIj4hm3wa9Jwhuac51irKj6AHVqXGklo5FnHKD7G/1ok7xKjd/AmZeXW15mITNuvFd
         RP28X74N2aYXREaZZ39P8vVU2hrPWlP6kQE9alhP5gY+wC9zqeP89wA2Np2NU+WWihFi
         gKo+vwOQZmp2W8zVocMwKGFKuxTgRDe1/3oad5C85gLKgZ2k6aUj84pnxwYUfFWyzxaF
         WnxOrM40p/8fKcCFFGkUAeuxbGI/4xaHMUryaltDsE1vcnayrPiIxrI/jby7eyGKoZkZ
         twvKwQYJCb+j8/uWKN0dIVTaqUOTavqQVFNQJRhD+Q9HLOXpFw/GwPmwz8d7nIh4TcbH
         gvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jK04uo/vbPumFkNdoQhNVaBxn4ECjuVk27Ah92guxCA=;
        b=gr3LtyQ370/AVcHi30Q5J45nCZDN+HBwCfjmm7ugw13wewIus0EU4fh38P4LJGWgBv
         r2dgegcFzS8c7uaA1PgtLR/RLYpBUS3hOtkaAxbbmN3Jf+2RyntNv/k8heMmAU52lur/
         xWmWltrJshr0dNppxCHSx/HXvDbKSlVwtHMneJkJmVcYmF+pJtofM8WVkoDjMBb4+0LO
         4gNNyEq074sRDRThXkvA7ofyV/Ytp4cZjBgjNKS4hsYA9uhhC1j9U88bQUwbeiPm1p2F
         LtAGK3nnguM9nmXuNIOABkgwxvjPOWONeuioDn7a/cs93j2RbQCfRTYmRFdGNBy1gstg
         XcsA==
X-Gm-Message-State: AOAM531xLgEjiOS9KBET6XZnGNqmREyeDDz3/WTJT9egu8/UBaF9jszY
        G6Ikp9i1yl3TTZjk2RONFwt+MDV4U5m3zx7nxBc=
X-Google-Smtp-Source: ABdhPJw8X2p5IxZBQy1jaGkEyPanT0fFHgKMLDAa1u05Qjr/OUWHblxSymBtLtDI1PUz6/WNesmzFRtmBkXHtMR1ULU=
X-Received: by 2002:aa7:cd5a:: with SMTP id v26mr6873891edw.287.1626195090723;
 Tue, 13 Jul 2021 09:51:30 -0700 (PDT)
MIME-Version: 1.0
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 13 Jul 2021 18:51:20 +0200
Message-ID: <CAFBinCDMPPJ7qW7xTkep1Trg+zP0B9Jxei6sgjqmF4NDA1JAhQ@mail.gmail.com>
Subject: rtw88: rtw_{read,write}_rf locking questions
To:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Tzu-En Huang <tehuang@realtek.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: multipart/mixed; boundary="000000000000b7ef4e05c7040c65"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b7ef4e05c7040c65
Content-Type: text/plain; charset="UTF-8"

Hello rtw88 maintainers and contributors,

there is an ongoing effort where Jernej and I are working on adding
SDIO support to the rtw88 driver.
The hardware we use at the moment is RTL8822BS and RTL8822CS.
Work-in-progress code can be found in Jernej's repo (note: this may be
rebased): [0]

We are at a point where we can communicate with the SDIO card and
successfully upload the firmware to it.
Right now I have two questions about the locking in
rtw_{read,write}_rf from hci.h:
1) A spinlock is used to protect RF register access. This is
problematic for SDIO, more information below. Would you accept a patch
to convert this into a mutex? I don't have any rtw88 PCIe card for
testing any regressions there myself.
2) I would like to understand why the RF register access needs to be
protected by a lock. From what I can tell RF register access doesn't
seem to be used from IRQ handlers.

Some background on why SDIO access (for example: sdio_writeb) cannot
be done with a spinlock held:
- when using for example sdio_writeb the MMC subsystem in Linux
prepares a so-called MMC request
- this request is submitted to the MMC host controller hardware
- the host controller hardware forwards the MMC request to the card
- the card signals when it's done processing the request
- the MMC subsystem in Linux waits for the card to signal that it's
done processing the request in mmc_wait_for_req_done() -> this uses
wait_for_completion() internally, which might sleep (which is not
allowed while a spinlock is held)

I am looking forward to your advice on this rtw_{read,write}_rf locking topic.


Thank you and best regards,
Martin


[0] https://github.com/jernejsk/linux-1/commits/rtw88-sdio

--000000000000b7ef4e05c7040c65
Content-Type: text/plain; charset="US-ASCII"; name="rtw88-sdio-scheduling-while-atomic.txt"
Content-Disposition: attachment; 
	filename="rtw88-sdio-scheduling-while-atomic.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kr2a9vr30>
X-Attachment-Id: f_kr2a9vr30

WyAgIDI3LjI0OTQzNV0gQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzogaXAvMjc0OS8weDAw
MDAwMDAyClsgICAyNy4yNDk0ODJdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgMjcuMjUyNDg1XSBD
UFU6IDIgUElEOiAyNzQ5IENvbW06IGlwIE5vdCB0YWludGVkIDUuMTQuMC1yYzErICMzMApbICAg
MjcuMjU4NTIxXSBIYXJkd2FyZSBuYW1lOiBTaGVuemhlbiBBbWVkaWF0ZWNoIFRlY2hub2xvZ3kg
Q28uLCBMdGQgWDk2IEFpciAoRFQpClsgICAyNy4yNjU3NjddIENhbGwgdHJhY2U6ClsgICAyNy4y
NjgxODFdICBkdW1wX2JhY2t0cmFjZSsweDAvMHgxOWMKWyAgIDI3LjI3MTgwNF0gIHNob3dfc3Rh
Y2srMHgxYy8weDMwClsgICAyNy4yNzUwODFdICBkdW1wX3N0YWNrX2x2bCsweDY4LzB4ODQKWyAg
IDI3LjI3ODcwMl0gIGR1bXBfc3RhY2srMHgxYy8weDM4ClsgICAyNy4yODE5ODBdICBfX3NjaGVk
dWxlX2J1ZysweDYwLzB4ODAKWyAgIDI3LjI4NTYwMl0gIF9fc2NoZWR1bGUrMHg2MDAvMHg2YzAK
WyAgIDI3LjI4OTA1Ml0gIHNjaGVkdWxlKzB4NzQvMHgxMTAKWyAgIDI3LjI5MjI0M10gIHNjaGVk
dWxlX3RpbWVvdXQrMHhjMC8weGYwClsgICAyNy4yOTYwMzldICB3YWl0X2Zvcl9jb21wbGV0aW9u
KzB4ODAvMHgxMjAKWyAgIDI3LjMwMDE3OF0gIG1tY193YWl0X2Zvcl9yZXFfZG9uZSsweDZjLzB4
YTAKWyAgIDI3LjMwNDQwNF0gIG1tY193YWl0X2Zvcl9yZXErMHhiNC8weDEwNApbICAgMjcuMzA4
Mjg2XSAgbW1jX2lvX3J3X2V4dGVuZGVkKzB4MWNjLzB4MmMwClsgICAyNy4zMTI0MjZdICBzZGlv
X2lvX3J3X2V4dF9oZWxwZXIrMHgxOTQvMHgyNDAKWyAgIDI3LjMxNjgyNF0gIHNkaW9fbWVtY3B5
X3RvaW8rMHgyOC8weDM0ClsgICAyNy4zMjA2MTldICBydHdfc2Rpb193cml0ZV9ibG9jaysweDg4
LzB4ZjAKWyAgIDI3LjMyNDc2MF0gIHJ0d19zZGlvX3dyaXRlKzB4MTM4LzB4MThjClsgICAyNy4z
Mjg1NTVdICBydHdfc2Rpb193cml0ZTMyKzB4M2MvMHg5MApbICAgMjcuMzMyMzQ5XSAgcnR3X3Bo
eV93cml0ZV9yZl9yZWdfc2lwaSsweDk4LzB4ZjQKWyAgIDI3LjMzNjkyMV0gIHJ0d19waHlfd3Jp
dGVfcmZfcmVnX21peCsweDE4LzB4NDAKWyAgIDI3LjM0MTQwNl0gIHJ0d19waHlfY2ZnX3JmKzB4
NzQvMHhkMApbICAgMjcuMzQ1MDI4XSAgcnR3X3BhcnNlX3RibF9waHlfY29uZCsweDEzMC8weDE4
MApbICAgMjcuMzQ5NTEzXSAgcnR3X3BoeV9sb2FkX3RhYmxlcysweDE3OC8weDFhMApbICAgMjcu
MzUzNzM5XSAgcnR3ODgyMmNfcGh5X3NldF9wYXJhbSsweDExNC8weGU0MApbICAgMjcuMzU4MjI0
XSAgcnR3X2NvcmVfc3RhcnQrMHhiMC8weDI0MApbICAgMjcuMzYxOTM0XSAgcnR3X29wc19zdGFy
dCsweDMwLzB4NTAKWyAgIDI3LjM2NTQ2OV0gIGRydl9zdGFydCsweDM4LzB4NjAKWyAgIDI3LjM2
ODY2MV0gIGllZWU4MDIxMV9kb19vcGVuKzB4MTg4LzB4N2QwClsgICAyNy4zNzI3MTRdICBpZWVl
ODAyMTFfb3BlbisweDY0LzB4YjAKWyAgIDI3LjM3NjMzN10gIF9fZGV2X29wZW4rMHgxMGMvMHgx
YzAKWyAgIDI3LjM3OTc4N10gIF9fZGV2X2NoYW5nZV9mbGFncysweDE5NC8weDIxMApbICAgMjcu
MzgzOTI3XSAgZGV2X2NoYW5nZV9mbGFncysweDI4LzB4NmMKWyAgIDI3LjM4NzcyM10gIGRvX3Nl
dGxpbmsrMHgyMDQvMHhkMTQKWyAgIDI3LjM5MTE3M10gIF9fcnRubF9uZXdsaW5rKzB4NDg0LzB4
ODMwClsgICAyNy4zOTQ5NjddICBydG5sX25ld2xpbmsrMHg1MC8weDgwClsgICAyNy4zOTg0MThd
ICBydG5ldGxpbmtfcmN2X21zZysweDEyMC8weDMzNApbICAgMjcuNDAyNDcyXSAgbmV0bGlua19y
Y3Zfc2tiKzB4NWMvMHgxMzAKWyAgIDI3LjQwNjI2N10gIHJ0bmV0bGlua19yY3YrMHgxYy8weDJj
ClsgICAyNy40MDk4MDNdICBuZXRsaW5rX3VuaWNhc3QrMHgyYmMvMHgzMTAKWyAgIDI3LjQxMzY4
M10gIG5ldGxpbmtfc2VuZG1zZysweDFhOC8weDNkMApbICAgMjcuNDE3NTY1XSAgX19fX3N5c19z
ZW5kbXNnKzB4MjUwLzB4Mjk0ClsgICAyNy40MjE0NDddICBfX19zeXNfc2VuZG1zZysweDdjLzB4
YzAKWyAgIDI3LjQyNTA2OF0gIF9fc3lzX3NlbmRtc2crMHg2OC8weGM0ClsgICAyNy40Mjg2MDVd
ICBfX2FybTY0X3N5c19zZW5kbXNnKzB4MjgvMHgzYwpbICAgMjcuNDMyNjU5XSAgaW52b2tlX3N5
c2NhbGwrMHg0OC8weDExNApbICAgMjcuNDM2MzY3XSAgZWwwX3N2Y19jb21tb24rMHhjNC8weGRj
ClsgICAyNy40Mzk5OTFdICBkb19lbDBfc3ZjKzB4MmMvMHg5NApbICAgMjcuNDQzMjY3XSAgZWww
X3N2YysweDJjLzB4NTQKWyAgIDI3LjQ0NjI4Nl0gIGVsMHRfNjRfc3luY19oYW5kbGVyKzB4YTgv
MHgxMmMKWyAgIDI3LjQ1MDUxM10gIGVsMHRfNjRfc3luYysweDE5OC8weDE5Ywo=
--000000000000b7ef4e05c7040c65--
