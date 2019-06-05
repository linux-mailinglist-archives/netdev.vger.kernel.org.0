Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F073567B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 07:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfFEF7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 01:59:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39659 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFEF7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 01:59:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so18104722wrt.6
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 22:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=E3PmNvUOt509UAPa8pmeQr0tDoKWZlSXD6TLuZ+DrPM=;
        b=tHnDWbm4yy9u1ldr0zpcWsqlyYBin+GsTCf3V8noGaz3UmRj2ugfbCpwkdMBDoo59P
         b6KvSymYg7WBFZEkoe17cLsFPzuqNWbkccnqypGki7AN9+5XV0BJHzCEd/hxuJdNiLsg
         +c5lCuFTS3ojN8RP3hCZR4Dkk3qPlz3Za2BwZ7j2EguIs79Ka5SLa/CugIH/k+felZV7
         KwiQJnqj0W/M4XSmrk96So69CEKIuljozHpV8mFEEJbeq1V3kMzS6fzWz0F7K9lTi+lL
         wq1c5u+/8zF1pN/a/SNm8WoOx//yKlwtsAbaJXZ6j0h/f0JfxXrGT9opMvHMOSbsb9CO
         u2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=E3PmNvUOt509UAPa8pmeQr0tDoKWZlSXD6TLuZ+DrPM=;
        b=RvuuZ+4EBtQAkbVtaVWOXXyrqJVgh3B05KnAcDLAgI1rd+bTcRlg00UYM5eEqioDWW
         Vtoi8bwA7OsxfEzuaoiASUqYxRgR1weOcUp4JF90HuRu67RcbL0YjMRnKivIRKgUnO3y
         FHK3whz/oucN/aNTHVzCT3HaePo/80ihoOj9neADAK7zRc0Hb+k263X+zVkp8Dgg89I4
         ijkdrjTejEPgugJoGWiRtt1NTulk+dux1netnVTVumOYlQiEb5Q8cYZWLQgoHhD5Imif
         /u/otD8TZW8yRbsLRTIbz2We28yFztEU67YLhXbcI3EyEmhrt4jKFjYysfdVFDni0s1N
         RwwA==
X-Gm-Message-State: APjAAAUhjutlCvEBXlDcAxJNg3n3P2OeNzHFZlcU13hn91VV2VTNKXqp
        qa7n0mxJ7FUuaYYTvdloPA4ra2TF
X-Google-Smtp-Source: APXvYqz+b8FLT+70+tyvpOLuwuR4CwiMBXIDzDrmpXlSp1WPj7Wk43HSlFSdq+oAJygZ7wD/DgpqyA==
X-Received: by 2002:a5d:5342:: with SMTP id t2mr5999649wrv.126.1559714350087;
        Tue, 04 Jun 2019 22:59:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8871:c3cd:95c8:45d1? (p200300EA8BF3BD008871C3CD95C845D1.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8871:c3cd:95c8:45d1])
        by smtp.googlemail.com with ESMTPSA id f3sm19025534wre.93.2019.06.04.22.59.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 22:59:09 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/2] r8169: factor out firmware handling
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <58ea4445-954f-4a97-397f-5d681125b9bb@gmail.com>
Date:   Wed, 5 Jun 2019 07:59:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's factor out firmware handling into a separate source code file.
This simplifies reading the code and makes clearer what the interface
between driver and firmware handling is.

v2:
- fix small whitespace issue in patch 2

Heiner Kallweit (2):
  r8169: rename r8169.c to r8169_main.c
  r8169: factor out firmware handling

 drivers/net/ethernet/realtek/Makefile         |   1 +
 drivers/net/ethernet/realtek/r8169_firmware.c | 231 +++++++++++++++++
 drivers/net/ethernet/realtek/r8169_firmware.h |  39 +++
 .../realtek/{r8169.c => r8169_main.c}         | 243 +-----------------
 4 files changed, 274 insertions(+), 240 deletions(-)
 create mode 100644 drivers/net/ethernet/realtek/r8169_firmware.c
 create mode 100644 drivers/net/ethernet/realtek/r8169_firmware.h
 rename drivers/net/ethernet/realtek/{r8169.c => r8169_main.c} (97%)

-- 
2.21.0

