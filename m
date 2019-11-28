Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E49410CDDC
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfK1RZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:25:25 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:45314 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfK1RYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:24:45 -0500
Received: by mail-lf1-f67.google.com with SMTP id 203so20557329lfa.12;
        Thu, 28 Nov 2019 09:24:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AWIsUNUBq4Dwz0cIArwIvo4yXMQZOnNjmlUY90hEg3c=;
        b=VytegU+3FG0xyu80nd+WJEXpNhRX6xcar8sa+cvmh25D/SWUv6F4DAOlOQtY+tCoOH
         HmRs8hVJcx+XdjN+ZdncvX+ixDH5U1L7Cma6s4GqjRGIVoY9da2xRbJMlJNRBmb+Nv6E
         EQgNlnWsu6vXTPkQdgp/pIfxDJhOYUwniYBSWq1pTM6+ro6y08yxdEZLG1qwnBye0nly
         0QNgXxNZqVxMup1v4UhHGc3E8ppOWowwR51ZrpVqKrXM5dGQfeMH1n+E2BS1DUMjtwHC
         Eb43H3qtulHFMYH/9tVGMMUq8pUdmTrs14AQaKfBjUs/tk2bxyghmnh8ipeDxaZCWj2K
         rCig==
X-Gm-Message-State: APjAAAXtzSOnwLmY1LHZXsEZT991o9mNlYMZMVfUiGoLHLUnNbm9aH3j
        0lnkisbJF/6aUWGg5Ug1Ge4weFmW
X-Google-Smtp-Source: APXvYqyGQ+dl8mFz1yMZ8m53S07teEo9C3EYzmzo4P+OaSDV4T/S6Nal03t5H/RlfWUyB7J0f2eR7Q==
X-Received: by 2002:ac2:4212:: with SMTP id y18mr5297266lfh.2.1574961882298;
        Thu, 28 Nov 2019 09:24:42 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id z20sm9302723ljj.85.2019.11.28.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:24:41 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iaNWz-0006wN-Dj; Thu, 28 Nov 2019 18:24:41 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/5] rsi: fix use-after-free, memleak and sleep-while-atomic
Date:   Thu, 28 Nov 2019 18:21:59 +0100
Message-Id: <20191128172204.26600-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The syzbot fuzzer has reported two separate use-after-free issues,
which are fixed by the first two patches.

Turns out there were more gems in this driver and the next two patches
fixes a memory leak and a potential sleep-while-atomic found through
inspection.

The last one tightens the seemingly broken endpoint sanity check which
would have the driver try to submit a bulk URB to the default pipe (and
fail).

Tested using a mockup device.

Johan


Johan Hovold (5):
  rsi: fix use-after-free on failed probe and unbind
  rsi: fix use-after-free on probe errors
  rsi: fix memory leak on failed URB submission
  rsi: fix non-atomic allocation in completion handler
  rsi: add missing endpoint sanity checks

 drivers/net/wireless/rsi/rsi_91x_hal.c | 12 +++----
 drivers/net/wireless/rsi/rsi_91x_usb.c | 47 ++++++++++++++++++++------
 2 files changed, 43 insertions(+), 16 deletions(-)

-- 
2.24.0

