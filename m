Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5A0D02AD
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 23:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730988AbfJHVQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 17:16:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46999 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730674AbfJHVQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 17:16:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id q24so9003435plr.13
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 14:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=ym7Po/ipIr5qsZP6Wss4YgBN/Fdm72GjN294jAaAbXM=;
        b=BtKrJlf9z/iIQeSybJI790Nc8Ch0XBlYX7hUUYU2k5P1NSzuCbhvLuQ9Fasj8c/RLV
         7T9QSQgP592on+stFymuyY7HFtJYHHmaQUld1uHY4mDzn9QBKe5aNWMNF3+4DT8w1kc9
         oq2QFLB9RxUoq7mkv+UsOinrHBJVOoDETFv/nMlzdP9AWvscwIStfHxPOcf16FYFRrkf
         i/IMHnflmMNpPgwv19O3DHEJEGpmCbrEad859AEJVEOzmrQBr4UvxvV2eWEp8u0isxTD
         pOorsK0jbEjry86XHen7qyBzn9t1ValfktI0AxGsnD5jHia/qvfYeWWlbLOgDqjUOfzj
         loOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=ym7Po/ipIr5qsZP6Wss4YgBN/Fdm72GjN294jAaAbXM=;
        b=RwaD5GsH4hY39tevdWfOUTk2fg7daoUlLGncq0FgBc4d6f86dKFBnIuMtnMOQ2cPly
         kl2rY8rnn2AZLuFEmuGE7m7q1jlMiSG4xvryVh/HD36W4naSrN2bwZzfUJEgIomuDeYp
         aa4yNOowiOwLyHRojtVx8StQ3Rm7YCcFMgOIEgKBRAQqsX/4WHrTihoWhoADaUYOvTTa
         k65H+vxjseBRi8fe6WLrIztgdCCx+ijGK4q3nvu/0pTVIDj+fB2hFGDXiUShAZLpQ4Lc
         Lf/RcnaZbNcjTQWnl6e0KX9JdFyGuLUuzRjys3TMzMuC3ddOzLPHvMm4YBfMJCBjsDVH
         ywtA==
X-Gm-Message-State: APjAAAXe7/VvOmd9O3y47fupoKfx/u9z3Qa089LUybE1YOMfGN/YL4Yr
        /nPGVaC3hQFPYiJKA6QcqFw=
X-Google-Smtp-Source: APXvYqwOsqx/h8V4j7TZDE3vB8YZXnJjOfzNJPlCEl5sUI5/OhZG4vNUhrhz/+y7QMNteEibu8WPhA==
X-Received: by 2002:a17:902:aa07:: with SMTP id be7mr6106318plb.172.1570569393783;
        Tue, 08 Oct 2019 14:16:33 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id l24sm55274pff.151.2019.10.08.14.16.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 14:16:33 -0700 (PDT)
Subject: [next-queue PATCH 0/2] Address IRQ related crash seen due to
 io_perm_failure
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     alexander.h.duyck@linux.intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Date:   Tue, 08 Oct 2019 14:16:32 -0700
Message-ID: <20191008210639.4575.44144.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Dai had submitted a patch[1] to address a reported issue with e1000e
calling pci_disable_msi without first freeing the interrupts. Looking over
the issue it seems the problem was the fact that e1000e_down was being
called in e1000_io_error_detected without calling e1000_free_irq, and this
was resulting in e1000e_close skipping over the call to e1000e_down and
e1000_free_irq.

The use of the __E1000_DOWN flag for the close test seems to have come from
the runtime power management changes that were made some time ago. From
what I can tell in the close path we should be disabling runtime power
management via a call to pm_runtime_get_sync. As such we can remove the
test for the __E1000_DOWN bit. However in comparing this with other drivers
we do need to avoid freeing the IRQs more than once. So in order to address
that I have copied the approach taken in igb and taken it a bit further so
that we will always detach the interface and if the interface is up we will
bring it down and free the IRQs. In addition we are able to reuse some of
the power management code so I have taken the opportunity to merge those
bits.

[1]: https://lore.kernel.org/lkml/1570121672-12172-1-git-send-email-zdai@linux.vnet.ibm.com/

---

Alexander Duyck (2):
      e1000e: Use rtnl_lock to prevent race conditions between net and pci/pm
      e1000e: Drop unnecessary __E1000_DOWN bit twiddling


 drivers/net/ethernet/intel/e1000e/netdev.c |   47 +++++++++++++---------------
 1 file changed, 22 insertions(+), 25 deletions(-)

--
