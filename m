Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF32041C7E8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345070AbhI2PNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:13:04 -0400
Received: from smtp1.axis.com ([195.60.68.17]:8923 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344991AbhI2PND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1632928283;
  x=1664464283;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=chXe7LowbepFp9WcjiVKhwfFPB4CO+NsYBHetH4uz4g=;
  b=b/5+vH33d24lwVt3EJz/6DVYEm5jFTCCdb6K+X7aEupA45a+QDIf7QRU
   OUUq2TvgeH9tMJhkgqk9HtkLaSK8qalwjTEl1osTd552KLJ0i658uvN9o
   0LdsN5i9TDF+aRDGGQRSdUuzeki0nsSSvxftm8fEing9tbQfLXKzB1+BB
   RQoR4XY/eMXw9uUTs9EJZZsAebQW2FBUDpyK5lL9wdaTvlkK9jWyYCo18
   aH2zU5EwXrxrQflG+KWEOXvsKcHhCdCgiQZa231l/c5pjdIqiLk2lNlYb
   dSIEfj/wYSdvwMExmGsM7gt60+m+k9MsvOkzUUujttu/27udHCp7VFkPd
   g==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kernel@axis.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [RFC PATCH 00/10] Support kernel buffers in vhost
Date:   Wed, 29 Sep 2021 17:11:09 +0200
Message-ID: <20210929151119.14778-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost currently expects that the virtqueues and the queued buffers are
accessible from a userspace process' address space.  However, when using vhost
to communicate between two Linux systems running on two physical CPUs in an AMP
configuration (on a single SoC or via something like PCIe), it is undesirable
from a security perspective to make the entire kernel memory of the other Linux
system accessible from userspace.

To remedy this, this series adds support to vhost for placing the virtqueues
and queued buffers in kernel memory.  Since userspace should not be allowed to
control the placement and attributes of these virtqueues, a mechanism to do
this from kernel space is added.  A vDPA-based test driver is added which uses
this support to allow virtio-net and vhost-net to communicate with each other
on the same system without exposing kernel memory to userspace via /dev/mem or
similar.

This vDPA-based test driver is intended to be used as the basis for the
implementation of driver which will allow Linux-Linux communication between
physical CPUs on SoCs using virtio and vhost, for instance by using information
from the device tree to indicate the location of shared memory, and the mailbox
API to trigger interrupts between the CPUs.

This patchset is also available at:

 https://github.com/vwax/linux/tree/vhost/rfc

Vincent Whitchurch (10):
  vhost: scsi: use copy_to_iter()
  vhost: push virtqueue area pointers into a user struct
  vhost: add iov wrapper
  vhost: add support for kernel buffers
  vhost: extract common code for file_operations handling
  vhost: extract ioctl locking to common code
  vhost: add support for kernel control
  vhost: net: add support for kernel control
  vdpa: add test driver for kernel buffers in vhost
  selftests: add vhost_kernel tests

 drivers/vdpa/Kconfig                          |   8 +
 drivers/vdpa/Makefile                         |   1 +
 drivers/vdpa/vhost_kernel_test/Makefile       |   2 +
 .../vhost_kernel_test/vhost_kernel_test.c     | 575 ++++++++++++++++++
 drivers/vhost/Kconfig                         |   6 +
 drivers/vhost/Makefile                        |   3 +
 drivers/vhost/common.c                        | 340 +++++++++++
 drivers/vhost/net.c                           | 212 ++++---
 drivers/vhost/scsi.c                          |  50 +-
 drivers/vhost/test.c                          |   2 +-
 drivers/vhost/vdpa.c                          |   6 +-
 drivers/vhost/vhost.c                         | 437 ++++++++++---
 drivers/vhost/vhost.h                         | 109 +++-
 drivers/vhost/vsock.c                         |  95 +--
 include/linux/vhost.h                         |  23 +
 tools/testing/selftests/Makefile              |   1 +
 .../vhost_kernel/vhost_kernel_test.c          | 287 +++++++++
 .../vhost_kernel/vhost_kernel_test.sh         | 125 ++++
 18 files changed, 2020 insertions(+), 262 deletions(-)
 create mode 100644 drivers/vdpa/vhost_kernel_test/Makefile
 create mode 100644 drivers/vdpa/vhost_kernel_test/vhost_kernel_test.c
 create mode 100644 drivers/vhost/common.c
 create mode 100644 include/linux/vhost.h
 create mode 100644 tools/testing/selftests/vhost_kernel/vhost_kernel_test.c
 create mode 100755 tools/testing/selftests/vhost_kernel/vhost_kernel_test.sh

-- 
2.28.0

