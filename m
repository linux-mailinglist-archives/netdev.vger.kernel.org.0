Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6DAB127799
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfLTIzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:55:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:34861 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbfLTIzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:55:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 00:55:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="218434371"
Received: from unknown (HELO localhost.localdomain) ([10.190.210.212])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2019 00:55:12 -0800
Received: from localhost.localdomain (localhost [127.0.0.1])
        by localhost.localdomain (8.15.2/8.15.2/Debian-10) with ESMTPS id xBK8tYhk005032
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 14:25:34 +0530
Received: (from root@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id xBK8tWEc005029;
        Fri, 20 Dec 2019 14:25:32 +0530
From:   Jay Jayatheerthan <jay.jayatheerthan@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        Jay Jayatheerthan <jay.jayatheerthan@intel.com>
Subject: [PATCH bpf-next 0/6] Enhancements to xdpsock application
Date:   Fri, 20 Dec 2019 14:25:24 +0530
Message-Id: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches enhances xdpsock application with command line
parameters to set transmit packet size and fill pattern among other options.
The application has also been enhanced to use Linux Ethernet/IP/UDP header
structs and calculate IP and UDP checksums.

I have measured the performance of the xdpsock application before and after
this patch set and have not been able to detect any difference.

Packet Size:
------------
There is a new option '-s' or '--tx-pkt-size' to specify the transmit packet
size. It ranges from 47 to 4096 bytes. Default packet size is 64 bytes
which is same as before.

Fill Pattern:
-------------
The transmit UDP payload fill pattern is specified using '-P' or
'--tx-pkt-pattern'option. It is an unsigned 32 bit field and defaulted
to 0x12345678.

Packet Count:
-------------
The number of packets to send is specified using '-C' or '--tx-pkt-count'
option. If it is not specified, the application sends packets forever.

Batch Size:
-----------
The batch size for transmit, receive and l2fwd features of the application is
specified using '-b' or '--batch-size' options. Default value when this option
is not provided is 64 (same as before).

Duration:
---------
The application supports '-d' or '--duration' option to specify number of
seconds to run. This is used in tx, rx and l2fwd features. If this option is
not provided, the application runs for ever.

This patchset has been applied against commit 99cacdc6f661f50f
("Merge branch 'replace-cg_bpf-prog'")

Jay Jayatheerthan (6):
  samples/bpf: xdpsock: Add duration option to specify how long to run
  samples/bpf: xdpsock: Use common code to handle signal and main exit
  samples/bpf: xdpsock: Add option to specify batch size
  samples/bpf: xdpsock: Add option to specify number of packets to send
  samples/bpf: xdpsock: Add option to specify tx packet size
  samples/bpf: xdpsock: Add option to specify transmit fill pattern

 samples/bpf/xdpsock_user.c | 426 +++++++++++++++++++++++++++++++++----
 1 file changed, 387 insertions(+), 39 deletions(-)

-- 
2.17.1

