Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFCBD4475
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 17:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfJKPes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 11:34:48 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45699 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfJKPes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 11:34:48 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so14406617qtj.12
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 08:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=ku8mWhse7myNTSgXVtERvtlltFxzJS4viFwKBsP2Kto=;
        b=Cf3OVwn2GB9W+6JglhZoy9ftTzFsDTWIdhXgdup7BnPpRIyhP3OrWMkPzuoTjNJXAz
         F1cwiqlbmuEEUmjfbVK4Mtiappiy5JXta5lo5rO7STGevmKQEFGFKu3tCM4bs+KE+22A
         3rEBtX/jn0KTJ2H+NAb3qREQkEA9Ifpz61tvxufBcThzKg/O/W3T1YmVwqPoFeppd7f+
         V6FcqdlbKQzk/a2cNPTZwCll1EjRRvgHgpz+JnBMuZ/Mhl18Gvx4UNlAgZs2vC5Xy+Ud
         dC55fC+nJRpXpO3s7MBr+3rHb+DAivTtepUa8k7ML0YXdSpUdvonmMfjQ6hJEfiDjM+E
         erdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=ku8mWhse7myNTSgXVtERvtlltFxzJS4viFwKBsP2Kto=;
        b=CZGarVe31JfIWmRwEi9qhNZ+3WMJcg+tx79ZihuXObXEHgrhVuU6yLEs3VKDYWccGj
         40QbrQ+b6dVD46WHEesJqOl5Q/8olMyigoOg90wYjjD8NFiYOJC14H08br12Zd42BrqY
         NhDWrHT8gElCdH7z2GN6MILqTXjm6uJvuuNs0g+A8kdNPGwhPEWAJfoCvX8S/yQlnlPr
         t4gNP9wJqtNnG3l2Ai8XJ5Gzsxg6seLcTmHK+U1f1EiH7vPRCWYrN1KJJKQBV0hIAZ6V
         8nM5AqmADdv88PcsZwv4CteyJqCdqTvBWDopqGwkvjrH47LGO5xVdh32Caeh0Oz6Fucl
         Um1w==
X-Gm-Message-State: APjAAAVlMgxr/KroIC2lyqtvqx6YBNrHqY6sSz/TWhiikeit8Tx2NjZb
        MoBffxqbWHKwvnLKL6axwHc=
X-Google-Smtp-Source: APXvYqzEzjydg6QBuYj8zOq8a8Ah58ATsyNuijjtyXfebaBjZuavmVFZ5peOiGgYTxQurgIDAPuwiw==
X-Received: by 2002:ac8:4915:: with SMTP id e21mr17846920qtq.69.1570808087106;
        Fri, 11 Oct 2019 08:34:47 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id z72sm4964437qka.115.2019.10.11.08.34.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 08:34:46 -0700 (PDT)
Subject: [next-queue PATCH v2 0/2] Address IRQ related crash seen due to
 io_perm_failure
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     alexander.h.duyck@linux.intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, zdai@us.ibm.com, zdai@linux.vnet.ibm.com
Date:   Fri, 11 Oct 2019 08:34:44 -0700
Message-ID: <20191011153219.22313.60179.stgit@localhost.localdomain>
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

v2: Move e1000e_pm_thaw out of CONFIG_PM region to fix build issue on Sparc64

---

Alexander Duyck (2):
      e1000e: Use rtnl_lock to prevent race conditions between net and pci/pm
      e1000e: Drop unnecessary __E1000_DOWN bit twiddling


 drivers/net/ethernet/intel/e1000e/netdev.c |   75 +++++++++++++---------------
 1 file changed, 36 insertions(+), 39 deletions(-)

--
