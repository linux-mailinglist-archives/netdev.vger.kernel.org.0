Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852FF325A2
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 01:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfFBXbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 19:31:46 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:37736 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfFBXbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 19:31:45 -0400
Received: by mail-wm1-f50.google.com with SMTP id 22so959552wmg.2
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 16:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SQv678lLk/VPktU7U8RESghFEs1ZOEYSnzU4ZYcYEb0=;
        b=lYfGZJRuh314NdVNz57oYz6lMCga+Zv3g+AaL5wZbjGF2Veo9BosfGIJ2dMFarhqwN
         +srHSeN8QTfBNaMWtdsyPfOagolWcoVTsWuFhmK+wLsGdjL2iQHAhKUMGm2yKjkF6cXF
         z7KQ3R4GW4Nsj3ub/joFU9F86bnSeK6gNVTaqO3nbrKqcrCLMY80QseAMoSX6tUlW5eD
         JqnQCQkCV1fyy6sLdt93v0T6bHRKds4vSlFXzCA5da9TbocTz+OaWSzLjA2YvkgrrUZe
         oXid5ai67aui5U4P2yWHmmQ2cIgizBZQ+ojShFcgYUWRlds+hNpIPicE4gqz6/k5kJ0A
         rRkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SQv678lLk/VPktU7U8RESghFEs1ZOEYSnzU4ZYcYEb0=;
        b=V9aISKwnwApzYj9xIpdCqUqpSgU2suh3nEUEyRY2cER5AifUDLWJ3AOUfrCWbXWzv5
         nOYvuLEsjTC4FGPLobd9bfrWYp//J4DKAOSxCTNoGe+hH8r9b0uCykWGNFiMsZBAr4UA
         5YpF5gvIUpTLHZWczCG0Af1Sk0jvkOdAN8hqE3ZttYzljQckqeo+p9W7rr+xXgtgd2tJ
         R9tc21qna6/ASco8EgSLNzqmUXcam4LqLxc5QqaAkaps6SKPqJZjAwJEZBa6ic8W7usm
         mJKJdQRCp/alGa+i6tKIvoiNsjhOgG31qNX0F02oQ2i2N5TLVRFXayCReZaJqNNjsfqm
         OE2A==
X-Gm-Message-State: APjAAAX62H1I+ZwD0ec+2W+W8UYjyrVgDzMsqO/EhmXmWyj5bzA15ss4
        B5D9kZxWQRWLYE8QDPaVPjY=
X-Google-Smtp-Source: APXvYqx/xQn4Rc6XzLLJCqAzRAmvcgSWqvh6WXury++ALCgqPamw0+9TVB3mlzyrnzKoSaOa7zImGg==
X-Received: by 2002:a1c:f116:: with SMTP id p22mr323264wmh.70.1559518303373;
        Sun, 02 Jun 2019 16:31:43 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 32sm39414631wra.35.2019.06.02.16.31.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 16:31:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 0/1] Fix link speed handling for SJA1105 DSA driver
Date:   Mon,  3 Jun 2019 02:31:36 +0300
Message-Id: <20190602233137.17930-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset avoids two bugs in the logic handling of the enum
sja1105_speed_t which caused link speeds of 10 and 100 Mbps to not be
interpreted correctly and thus not be applied to the switch MACs.

v1 patchset can be found at:
https://www.spinics.net/lists/netdev/msg574477.html

Changes from v1:
Applied Andrew Lunn's suggestion of removing the sja1105_get_speed_cfg
function altogether instead of trying to fix it.

Vladimir Oltean (1):
  net: dsa: sja1105: Fix link speed not working at 100 Mbps and below

 drivers/net/dsa/sja1105/sja1105_main.c | 32 +++++++++++++-------------
 1 file changed, 16 insertions(+), 16 deletions(-)

-- 
2.17.1

