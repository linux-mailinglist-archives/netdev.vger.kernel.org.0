Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3B539FE49
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 19:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhFHR7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 13:59:52 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:40760 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbhFHR7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 13:59:50 -0400
Received: by mail-pj1-f52.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso6365769pjb.5
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 10:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aternos.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=NtFUkXFeSM5JJGxJce9fbpNpmFBiYRG+AnaGSrBu2Qo=;
        b=iFL6slB8LabhOSOgOCwIxpLNxap2wgwCR8d3ezoyIVOOT+V3umE3PyPDgLGs20WOud
         dj5EcFpaFAX25INZtWOIk+krpnXJ0rtJ/MUlO8w3KxbsvoVSD8tb0ADZlNv+4Xc0nZA1
         Wk5rj1a24jy+D9jQ5Chi4BMRgRKdmF12SNYaH3F2FLUb0ksG2lEHXCtf3EFHb+u/wqBu
         lx520AqFBdm0i1m8c+q2ZdV6NISFSJt+k8cNowPKYiHbXUiy/W5dytXbXfBh8VonWKfx
         D4NInh0Drq8iQsfnom2rlePjqxVoM/0E+aht0bnafu2an0sE3AWmJsvUOcGBa5dwOxtf
         N6Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NtFUkXFeSM5JJGxJce9fbpNpmFBiYRG+AnaGSrBu2Qo=;
        b=RTBiCCreh6KjiWNGVxX3jhCsfD4BcglONa33hWSL60gtYHdwvhmi4ExpaAYct7Cbcn
         yWU0JUwS74kW2YGwlBJV8Du8raDFVETQp32i+4oG0bBw4cmEh9NmqM6Tm0+VpBMNbnHC
         2CYIETPdXf0s/cKnkYJtpGIbgI4Z/+udK0g+SzVFZ5W0coaOQOpMRHcXrNZaOlFbk9Ju
         xoy28tRAr8yKIfwF+dhDJsVEj1R1yhSqra8Fu4L0ORZeI27GMQnx636hjakkRzj95Vbp
         ODlX5cQMK1plYNeAf7BuxrHeNg37w03RKPhw1981qhjYMH32oWz1JKfRTcIsHpmclma2
         sMww==
X-Gm-Message-State: AOAM533FilrJMq/K+86m+xoiFVUZ38WG4wYdkI3MhVFgx718P6jFBUkW
        dc17Pov5OuZSbgi6DOXlQRtGcLxFz4MM+9cABKf5VKmCv7VufQ==
X-Google-Smtp-Source: ABdhPJxKMNqTNwCJ7Zr4MnngsZ/J65SNxzJWpGbRCgH/7LHU+VAB/AnyqhWbXv/pX98vnMB+t4vGnqH0Z/YBY54rNjM=
X-Received: by 2002:a17:90b:108f:: with SMTP id gj15mr28504137pjb.124.1623175004485;
 Tue, 08 Jun 2021 10:56:44 -0700 (PDT)
MIME-Version: 1.0
From:   Roman Steinhart <roman@aternos.org>
Date:   Tue, 8 Jun 2021 19:56:33 +0200
Message-ID: <CAKrGhHKUqG1P7FOTYFnLebGGorucRByQk9oVTohGcBkSJY8heg@mail.gmail.com>
Subject: bnxt_en NIC driver crashes IO_PAGE_FAULT
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

You receive this mail because I raised a bug report against the
bnxt_en driver in the Linux kernel on launchpad.net:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1931106
I was advised there to get in touch with you here.

We received a bunch of new servers with a Supermicro H12SSL-NT
mainboard that has an embedded Broadcom BCM57416 NIC.

On all those servers we observe crashes of the NIC driver (bnxt_en)
from time to time. We're not able to manually reproduce this issue, it
just occurs at some point. Also our monitoring does not show any
irregularities(high traffic flow or sth. like this).

All servers are running with up-to-date packages:
$ lsb_release -rd
Description: Ubuntu 20.04.2 LTS
Release: 20.04

We tested the kernel versions 5.4.0-73 back to -66, the current HWE
kernel 5.8.0-55 as well as the latest mainline kernel
5.13.0-051300rc5.
On those 20 servers the crash occurs like ~1-2 times a week.
Just with the 5.13.0 kernel the driver crashed on all 5 servers
running that version within 1-2 hours after installing that kernel
version.

Syslog 5.4.0-73 kernel: https://pastebin.com/yDAyjHvF
Syslog 5.13-rc5 kernel: https://pastebin.com/GWqtVaA3
Apport file: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1931106/+attachment/5502930/+files/apport.linux-image-5.8.0-55-generic.cime34c6.apport

related Launchpad.net Bug report:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1931106


Thanks in advance.
~ Roman
