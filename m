Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F4F35016
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 21:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFDTAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 15:00:25 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42460 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDTAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 15:00:25 -0400
Received: by mail-qk1-f195.google.com with SMTP id b18so3542694qkc.9
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 12:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LM7aaYP/01BDzRnX5iKBabEgiyBZDUAQI4ilgGYCG0s=;
        b=c4um6PNTUMgDpwzVlTFqnObbS2VoDfouT+LfCRrBMPKvtD16w7qhrCyBLzGY2dPYyT
         x3zq1BysJc2/ZYfKfz3PszhIDt8iEvOs7IUNvoPSdpLJD1YHX8WX3Yu6B0exnvgaWQHi
         A4/3LZqcrBEo+TLI1hP23nw20LxTVgp96KcxSr7x6NbcyickVx4SAtsIRmmFnqrOQt1w
         iKpHmDJJRKU3g4QaKefMgmbiUR4bjU1Oxs+YVpvIm6UUk41vl+d2Okxh13IB6yoSRXbk
         NTDGWfFNbsbWVLqCakTMWM/jCscH3FpshTSTaqRgSJ3XCJ9Y8opkvdY6tIpaWGgOtxvT
         R8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LM7aaYP/01BDzRnX5iKBabEgiyBZDUAQI4ilgGYCG0s=;
        b=rEhwzL9u/XEZTY2VVPNJvFspx1jnTgY+1IbLz9I2qEH60AJ5Qa5aYfKzwEa/XOtmWG
         xqy0p7GHTz6PCF6sbCFhfMPQziwlmfs8wpfKi0dpX1R1y4uJXHkKxUpTGICw+Gsj7imt
         2AjoiH2WhAHbG5Pu8CKoDdnn5px4YxEvBntMKoSHG6DXOt23zvKoZohcf3Rbzngdz0jN
         ffFZXDYIrDQvWiaRE095yuVg7CMmDiPgz42mCpZb5FFemOXjTUsYr/P7b5fYVZq5kjCt
         sq3yDhVieurpC3FSfBjakmkrQgKh75nU58ZaCxNaDXj3noo6wa0pNRx837fEDSyuFJm9
         Qfsw==
X-Gm-Message-State: APjAAAVCedJCXn2oQaGxgLCK87TtLrEzqPJmxd4zvPe/fOLDLC5MyDBw
        01PnzCaU69+MO3Xy1+VFQeGPBw==
X-Google-Smtp-Source: APXvYqxOe8KqGtnlg5MBGeyMydJrhDW5DUGWOE5kcs+xuCtM4E9QLSJX4dIc4znWTM5dW5kXekstmw==
X-Received: by 2002:a37:4d41:: with SMTP id a62mr26127409qkb.99.1559674824260;
        Tue, 04 Jun 2019 12:00:24 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e66sm11011893qtb.55.2019.06.04.12.00.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 12:00:23 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net v2 0/2] net/tls: redo the RX resync locking
Date:   Tue,  4 Jun 2019 12:00:10 -0700
Message-Id: <20190604190012.6327-1-jakub.kicinski@netronome.com>
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

v2:
 - fix build warning (DaveM).

Jakub Kicinski (2):
  Revert "net/tls: avoid NULL-deref on resync during device removal"
  net/tls: replace the sleeping lock around RX resync with a bit lock

 include/net/tls.h    |  4 ++++
 net/tls/tls_device.c | 26 ++++++++++++++++++--------
 2 files changed, 22 insertions(+), 8 deletions(-)

-- 
2.21.0

