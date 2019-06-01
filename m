Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2188B31932
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfFADMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:12:21 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35632 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfFADMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 23:12:21 -0400
Received: by mail-qt1-f195.google.com with SMTP id d23so3399727qto.2
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 20:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=crroeZ2ak4A3hlcXUIvwivp/Wr0QwnN8izvC6t6VRi8=;
        b=LozYsvxjBKkp13kBcyAccrlDHbooWyppTwFCF1kTkvG1FadWNFJeFMdPEL6C3ag0Z4
         gwnhgXuU492GZpJG/BRBXWvqI5CT1zTRj5nghm3M/uRLNvasrCLcr487DDbnO2uFHWH2
         dzZgiTcVr/R5NtMOrqVSwnuNcTGkIL1O0aXE/IHVf5FtgAtnyI5cvs5tAIypdhOwnASb
         +3vPux46U9xESc7AK4KhSqWCLE6Cq/CMbQBxrNm8B7rnalcVSPKsNf1ziW4ud//Cdnkr
         dA5aYM+dQfwHTnTQ1LAnoyDzO3iqKGZD1RupXmlT2NnLBAqWpf+Ja+jf8UsVUgXC+YCX
         cLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=crroeZ2ak4A3hlcXUIvwivp/Wr0QwnN8izvC6t6VRi8=;
        b=UwYRbMxzwzZXL92CbHZ0Z0IZNEPf0JNBax3Sqc2o1UmqLI7zGJ/PRS0B1hTIjlCMPy
         aJvQvUERuas0NO4PMWjZbOUIyGrSLKDFDCs6nO1MWypVbHoCC7isuOOygA/p2PGfegj3
         EhgiwMHrhAkFr/h9IhWlMAZ2OlBx+I66DrIEJQ6ZZOMP6Cih4S9qyVSyBRt+6qU16zKq
         zlEDrh9ZLY3m7bALl1e4bvCO6YFW1pewS20cuBpOWW/w7d2Wcy1tuURzxtAYZmfafWhg
         Qn3a4edQ7YwQtU9Bt0CS2gg28IhTNK1JjNzUmwzaJyzDECKWNIVFvEOzEvTYhh2ozdyn
         xSaw==
X-Gm-Message-State: APjAAAXFuwohRy63uMkGDN4pGQmaHkNV1oXbyXtMW0jhsGEMzE26PG/Y
        qiIsoL71SXSEGH01lKiCsmXFOw==
X-Google-Smtp-Source: APXvYqxn8SiAs2KiMiu/oofpVmPvYYolCf1of3Hl1DPwQDj3a9n3DrPr6bt0FAjMj03bngmLWTwqQw==
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr12575906qtl.117.1559358740396;
        Fri, 31 May 2019 20:12:20 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j26sm5354267qtj.70.2019.05.31.20.12.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 20:12:19 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/2] net/tls: redo the RX resync locking
Date:   Fri, 31 May 2019 20:11:59 -0700
Message-Id: <20190601031201.32027-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Take two of making sure we don't use a NULL netdev pointer
for RX resync.  This time using a bit and an open coded
wait loop.

Posting as revert + new patch, hopefully this will make it
easier to backport to stable (unless third time is the charm,
and this one is buggy as well :().

Jakub Kicinski (2):
  Revert "net/tls: avoid NULL-deref on resync during device removal"
  net/tls: replace the sleeping lock around RX resync with a bit lock

 include/net/tls.h    |  4 ++++
 net/tls/tls_device.c | 27 +++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

-- 
2.21.0

