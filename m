Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E511CD60F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 12:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgEKKLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 06:11:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728341AbgEKKLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 06:11:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589191912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=8dqwlRs0MIbbYYZ5cTiHH12yPXOUWNjjWHMIX42DRKA=;
        b=cwlZ+Ifw6MBmt+FAw1LUQpacznpsSltr+VZONPUZhD0iYRUu9kOFG72N4rEeGDn22UvfaR
        TRUeOLLNnMxef57BZVshptldOXbMubwlD7rnNXccpJJSHIOoVC3OwerGWBhkea3jmUderU
        TEAAran2UvYxR3TYmmv3RTdueMtAENg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-KlaGx_rWNrqlmmbUse4NNA-1; Mon, 11 May 2020 06:11:48 -0400
X-MC-Unique: KlaGx_rWNrqlmmbUse4NNA-1
Received: by mail-pj1-f71.google.com with SMTP id v71so17193979pjb.6
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 03:11:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8dqwlRs0MIbbYYZ5cTiHH12yPXOUWNjjWHMIX42DRKA=;
        b=O1KzbVsYvoAD7I+MbNL9ekwScFcklrii8abRCaFBQvBcM/0/f4OagGT36P8VrqQYVA
         EBy+vt4yLsLUXUKiWt0QF6xfdJxB8GdP7MxUoLUFon7isDoUwkcHm888cwYzJ4wYDcjX
         2iMicY1DfczzOBzHGl9CuIWmn73H6BsRLDhC4VbO5Py9vR/T6Yn+9wG5aYhY5HVyMH58
         TmcdtFlk3AM4lMAZMU2dlNMk3ZNe/f59lCRnNiDBwHKEfpGU4munaUwuDXo7s4vTA6SH
         rDBSJ0pQjV7x5qABQDE1jMq6Y0MVAjlDTQDFayBjBaMWcU+CvbsvHSQXkUwE4MJsSiCa
         Y7rQ==
X-Gm-Message-State: AGi0PubH8GjewUeRUjtUC6fWC9RxR28z7u4Ng0I++vrG8hHk0tSicd7u
        o8mcHjjfjtio8XvqkITP8zRdM0gQ+sKJuTRn0X57b2IY6iDnVoMOfbwjWHcsGZNYT9gx/gcDKsX
        7Lv3HxKTunzgj2YFm
X-Received: by 2002:a17:90a:2344:: with SMTP id f62mr19416888pje.152.1589191907145;
        Mon, 11 May 2020 03:11:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypI6U2PBXvp5NefRkcNxi8d5R6lAoUyguWTMssi1lnpWsenTGf54ZPP0B9tvxz5rBp8n9A2vjg==
X-Received: by 2002:a17:90a:2344:: with SMTP id f62mr19416853pje.152.1589191906709;
        Mon, 11 May 2020 03:11:46 -0700 (PDT)
Received: from localhost ([223.235.87.110])
        by smtp.gmail.com with ESMTPSA id h13sm7567956pgm.69.2020.05.11.03.11.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 03:11:46 -0700 (PDT)
From:   Bhupesh Sharma <bhsharma@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bhsharma@redhat.com, bhupesh.linux@gmail.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        manishc@marvell.com, davem@davemloft.net, irusskikh@marvell.com
Subject: [PATCH v2 0/2] net: Optimize the qed* allocations inside kdump kernel
Date:   Mon, 11 May 2020 15:41:40 +0530
Message-Id: <1589191902-958-1-git-send-email-bhsharma@redhat.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v1:
----------------
- v1 can be seen here: http://lists.infradead.org/pipermail/kexec/2020-May/024935.html
- Addressed review comments received on v1:
  * Removed unnecessary paranthesis.
  * Used a different macro for minimum RX/TX ring count value in kdump
    kernel.

Since kdump kernel(s) run under severe memory constraint with the
basic idea being to save the crashdump vmcore reliably when the primary
kernel panics/hangs, large memory allocations done by a network driver
can cause the crashkernel to panic with OOM.

The qed* drivers take up approximately 214MB memory when run in the
kdump kernel with the default configuration settings presently used in
the driver. With an usual crashkernel size of 512M, this allocation
is equal to almost half of the total crashkernel size allocated.

See some logs obtained via memstrack tool (see [1]) below:
 dracut-pre-pivot[676]: ======== Report format module_summary: ========
 dracut-pre-pivot[676]: Module qed using 149.6MB (2394 pages), peak allocation 149.6MB (2394 pages)
 dracut-pre-pivot[676]: Module qede using 65.3MB (1045 pages), peak allocation 65.3MB (1045 pages)

This patchset tries to reduce the overall memory allocation profile of
the qed* driver when they run in the kdump kernel. With these
optimization we can see a saving of approx 85M in the kdump kernel:
 dracut-pre-pivot[671]: ======== Report format module_summary: ========
 dracut-pre-pivot[671]: Module qed using 124.6MB (1993 pages), peak allocation 124.7MB (1995 pages)
 <..snip..>
 dracut-pre-pivot[671]: Module qede using 4.6MB (73 pages), peak allocation 4.6MB (74 pages)

And the kdump kernel can save vmcore successfully via both ssh and nfs
interfaces.

This patchset contains two patches:
[PATCH 1/2] - Reduces the default TX and RX ring count in kdump kernel.
[PATCH 2/2] - Disables qed SRIOV feature in kdump kernel (as it is
              normally not a supported kdump target for saving
	      vmcore).

[1]. Memstrack tool: https://github.com/ryncsn/memstrack

Bhupesh Sharma (2):
  net: qed*: Reduce RX and TX default ring count when running inside
    kdump kernel
  net: qed: Disable SRIOV functionality inside kdump kernel

 drivers/net/ethernet/qlogic/qed/qed_sriov.h  | 10 +++++++---
 drivers/net/ethernet/qlogic/qede/qede.h      |  2 ++
 drivers/net/ethernet/qlogic/qede/qede_main.c | 13 ++++++++++---
 3 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.7.4

