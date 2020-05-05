Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6B1C60B1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgEETE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:04:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728268AbgEETE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:04:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588705497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=gcXMyD41pZbNM1SUCbRbLelE1XAUtFal40kiUaUajmk=;
        b=OUO+6rKTX4aDTObY4uUcGOcxNqLVUTExG5OznU+ntRPkSJvqayed7eurnOf7/Eg9pzIueQ
        VsFgn1zNgS6NqHk9lTIzmLyA8az77DLIfRAPS3SeFDWtJd8tFaC1gq4aHjJ9JNGurrML2t
        2/xsOiCkRekvtsrSP4qLpKrgLrOoqMo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-qavofE29MpKK2zS0fh9Wug-1; Tue, 05 May 2020 15:04:53 -0400
X-MC-Unique: qavofE29MpKK2zS0fh9Wug-1
Received: by mail-pl1-f198.google.com with SMTP id 18so2704592pll.3
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 12:04:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gcXMyD41pZbNM1SUCbRbLelE1XAUtFal40kiUaUajmk=;
        b=ovC4xISWwY36FJWqpEOgfRGuwLEpuEoy0A5CsBPEa9xuFJ0e3fC2ZHt3qYUff2L9Z8
         MM0mOGhbpEQmyz+08ChNEy3NwBxge05I6I/VvCCn58bn8K7zfvGmJO+waVHnDWSeH/90
         cWHth9sBEYIzi7nb4OvXIncVHFMFGsF/7cGEmtxRkxR7bDjPM+Za4yGPL1ccbrgvtWf+
         70gPtWQL5vStGeLTqyM5u/Wy8SfTke/1CZ0LOyX+H9w7dACRPZRts9PSQC7tka2lz4qd
         qHBsjVQujUf4NMQjki3irPQQs45uQsbaKIIE6ZKoBas9z3PFAJ4WBGxORNW30Pf6iG0E
         cbvA==
X-Gm-Message-State: AGi0PuZm+OYMTd/LAcDgoePPvbr5+c9CQxo7bYpzTBB592knzxq2FchH
        CqoQfi6H2uzd6e/zh2ruzyw6ook7n3YtnaHQQfav5mnDEpcIiOmTvFwZZynLlp856SzVD3EZahv
        Vco8WUd82eFOSWivN
X-Received: by 2002:a63:6e8a:: with SMTP id j132mr3534779pgc.301.1588705492036;
        Tue, 05 May 2020 12:04:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypKBraGUIDcFG9XSdThqRw+1cdaikZ4rNFXMH+U0+iXdoy+oY/wIGdJj6n4cm/tV5WzKDyO/OA==
X-Received: by 2002:a63:6e8a:: with SMTP id j132mr3534746pgc.301.1588705491674;
        Tue, 05 May 2020 12:04:51 -0700 (PDT)
Received: from localhost ([122.177.124.216])
        by smtp.gmail.com with ESMTPSA id o30sm2032230pgn.12.2020.05.05.12.04.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 12:04:50 -0700 (PDT)
From:   Bhupesh Sharma <bhsharma@redhat.com>
To:     netdev@vger.kernel.org
Cc:     bhsharma@redhat.com, bhupesh.linux@gmail.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        manishc@marvell.com, davem@davemloft.net
Subject: [PATCH 0/2] net: Optimize the qed* allocations inside kdump kernel
Date:   Wed,  6 May 2020 00:34:39 +0530
Message-Id: <1588705481-18385-1-git-send-email-bhsharma@redhat.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

-
Bhupesh Sharma (2):
  net: qed*: Reduce RX and TX default ring count when running inside
    kdump kernel
  net: qed: Disable SRIOV functionality inside kdump kernel

 drivers/net/ethernet/qlogic/qed/qed_sriov.h  | 10 +++++++---
 drivers/net/ethernet/qlogic/qede/qede.h      |  5 +++--
 drivers/net/ethernet/qlogic/qede/qede_main.c |  2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

-- 
2.7.4

