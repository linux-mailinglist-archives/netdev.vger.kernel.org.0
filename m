Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7FDE8787
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 12:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbfJ2Lyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 07:54:38 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34245 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfJ2Lyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 07:54:38 -0400
Received: by mail-lj1-f196.google.com with SMTP id 139so14765163ljf.1
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 04:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aY6EYaegNeZcRsm3y6Fc/tP8DJiXWZJIyRTKtd4cdOY=;
        b=JX0+XLqvhhWwVNTSgLUt+U4eE0m6e2mXHAUy3HfntwvD5/OKXPWzF8iv+b/aLzKwV6
         nQUVRpKHMScYLWs/xrEptfreJXn0kPvyjh6KthqiaLKubSpOwcy8cjI0oBmz+OSRXe12
         7MQFbyfdhSjoKWhX/bpnEYFEY5GuNntiSS9eE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aY6EYaegNeZcRsm3y6Fc/tP8DJiXWZJIyRTKtd4cdOY=;
        b=bDGetWizqDiusDTt/Uw+mhkw5jNBCDdq5tCJZqZxIUZFkmUiGrPu712YXoll79PlUc
         MRMmcVu2K6/zcQb+qphWnuNwFyRxa/MKwtk5p2iTsE3eg8EWjkhprCwAo5PKEn29pYjl
         CZGc/yzN0YOPCUJAwqxhu1MaU16tqsIDk7Ga/Jfoi18EZGpAHiQGNMGNzk2epuTqPvOc
         raR4nRpuuI+tGAmoKl/w5dhpxdT7g7QQL+rl0lWBh1Lvf57zbi9uSRUc+oDB93sbJrbE
         D5LWPAv1WaSxnIH9zWJ9OzDQx43XEPmQM703fon4b+f2/hY0/kCFxh1WKsXiAR5/XFeF
         Dmsg==
X-Gm-Message-State: APjAAAVBjI44FFZ5fPrB1xTPuoth+GMjx4Sqm+IzttZ1CBMCPuZ2H/TB
        oR0jlLDq64wpAwtmbSTG0FRueewQmjY=
X-Google-Smtp-Source: APXvYqz19QJm2NAQDzY8qIOD/xkAWtvO6aW4OMuxGcTXUV0/uorPYMZFZtvZiI8SAs7etQsX8elXpA==
X-Received: by 2002:a2e:9149:: with SMTP id q9mr2443837ljg.49.1572350074595;
        Tue, 29 Oct 2019 04:54:34 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r12sm11953310lfp.63.2019.10.29.04.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 04:54:33 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 0/7] net: bridge: convert fdbs to use bitops
Date:   Tue, 29 Oct 2019 13:45:52 +0200
Message-Id: <20191029114559.28653-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
We'd like to have a well-defined behaviour when changing fdb flags. The
problem is that we've added new fields which are changed from all
contexts without any locking. We are aware of the bit test/change races
and these are fine (we can remove them later), but it is considered
undefined behaviour to change bitfields from multiple threads and also
on some architectures that can result in unexpected results,
specifically when all fields between the changed ones are also
bitfields. The conversion to bitops shows the intent clearly and
makes them use functions with well-defined behaviour in such cases.
There is no overhead for the fast-path, the bit changing functions are
used only in special cases when learning and in the slow path.
In addition this conversion allows us to simplify fdb flag handling and
avoid bugs for future bits (e.g. a forgetting to clear the new bit when
allocating a new fdb). All bridge selftests passed, also tried all of the
converted bits manually in a VM.

Thanks,
 Nik

Nikolay Aleksandrov (7):
  net: bridge: fdb: convert is_local to bitops
  net: bridge: fdb: convert is_static to bitops
  net: bridge: fdb: convert is_sticky to bitops
  net: bridge: fdb: convert added_by_user to bitops
  net: bridge: fdb: convert added_by_external_learn to use bitops
  net: bridge: fdb: convert offloaded to use bitops
  net: bridge: fdb: set flags directly in fdb_create

 net/bridge/br_fdb.c       | 133 +++++++++++++++++++-------------------
 net/bridge/br_input.c     |   2 +-
 net/bridge/br_private.h   |  17 +++--
 net/bridge/br_switchdev.c |  12 ++--
 4 files changed, 85 insertions(+), 79 deletions(-)

-- 
2.21.0

