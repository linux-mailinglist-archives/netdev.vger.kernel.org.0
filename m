Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600D65FE40
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfGDVu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:50:58 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44095 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfGDVu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:50:58 -0400
Received: by mail-qk1-f194.google.com with SMTP id d79so2226526qke.11
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=12otJBi6aeIpQYM0oEWIiXJ+x1CkIBQemw8xuUeZCJ4=;
        b=0gMZJNhh4+H9UuJjcC8Zb04qujRObrSf1MpRZIlO1ZGaL5FvZUfLfiVcWt98+kHFdI
         IoMIzIkVhSPbDp5esVS8MUmZx5sh3i67qpogCF2oYzwAoYKQB1QHEzPPd7h8h9wSsTHu
         j6gL+XGn6rEP+8+5qaWwzmeIpjXSTVyx2X+hZTBD63ffg/ibeRjTfgoua8M1gwUKDZ0g
         5Ff/Ujoz3G4RyXMbhwtF55NecRMePx2V/edHVVNA8qTrQuFChHsk2CTRxZ3+IDDCaMku
         qA5FnlzDYMWkVeCQmo7J3/lMaTS8D+8x9PcB320na1gpcbxsaPXtJsh4Jf5BrYwlhPYi
         YJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=12otJBi6aeIpQYM0oEWIiXJ+x1CkIBQemw8xuUeZCJ4=;
        b=krKyBoXwrqVKiqh1u4ngJajqsjOdA7MogJ+/de1s+/ykaKxMQWHxuAiPlXmADDw2iL
         iY7JoeQXIl7XXiO0llEewaA8U80cNnGtPmmRduVJTEUVPZSpEZEdNUKoW3RJOmwy3oc0
         Ji+Ns3J6jJd0lsyODpiMdT3mc29OHvh8kTAZs8hzaS/xgCMl0s6FfnrtEs2saeePXC9v
         NNLljADvfSXFDoQcEg9q97qUwCYfMvz84wCnXUIhGrH6BnqpBx6cjm0xzZjDWie46KzG
         9TcrQeywAP9I/utYgqo2nJEFyu8jwM/+U4LgOOPjFJ9Bd9kvUowgA8GBN3/j9pbd/WvJ
         EdJQ==
X-Gm-Message-State: APjAAAVGLS3eqUuQcFTfbw3UdJJujWA8F6HdXbOb1JsfbV6f/zq7/ddz
        0FTDiqkHRptOuUKaiNvBdX0Yig==
X-Google-Smtp-Source: APXvYqxKH9Q24VtpPMoZghLeZxwCHZqpmhYPxhY9vlnqPovwu2OF15OeX//idHI5KIRhb/QLQlkotA==
X-Received: by 2002:a37:490d:: with SMTP id w13mr464836qka.179.1562277057592;
        Thu, 04 Jul 2019 14:50:57 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t2sm3542329qth.33.2019.07.04.14.50.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 14:50:57 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 0/2] net/tls: fix poll() wake up
Date:   Thu,  4 Jul 2019 14:50:35 -0700
Message-Id: <20190704215037.6008-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This small fix + selftest series is very similar to the previous
commit 04b25a5411f9 ("net/tls: fix no wakeup on partial reads").
This time instead of recvmsg we're fixing poll wake up.

Jakub Kicinski (2):
  net/tls: fix poll ignoring partially copied records
  selftests/tls: add test for poll() with data in TLS ULP

 net/tls/tls_sw.c                  |  3 ++-
 tools/testing/selftests/net/tls.c | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

-- 
2.21.0

