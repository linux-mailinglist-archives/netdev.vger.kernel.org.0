Return-Path: <netdev+bounces-719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D367A6F9502
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 01:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ADCA28119D
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 23:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9169610967;
	Sat,  6 May 2023 23:29:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809CE10964
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 23:29:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEB2468C
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683415796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VPtwiHRcbAtbIWptlNsxTdMycjSDQHYcwJb296c1nk0=;
	b=MD3GQg6muZcjO4cOx8zHvE8kO0jPK+VlBYEdwfokLlKOK3NfZnWvsW47GBUFkEaGJgCO6U
	qD3xfTGD/pmYkkiU6p9wu/U1HsnTSA398lHfjWR6YB7lZ+GGJ0ZzkJVngVvIuBnSBLpf+m
	Kb5EYnXygHB5LR1JPK654ck5MdtCUg8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-MQrfL2ArNjiUACkwMXTBEg-1; Sat, 06 May 2023 19:29:53 -0400
X-MC-Unique: MQrfL2ArNjiUACkwMXTBEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F14B129ABA00;
	Sat,  6 May 2023 23:29:52 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.2.16.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66FCD440BC;
	Sat,  6 May 2023 23:29:52 +0000 (UTC)
From: Chris Leech <cleech@redhat.com>
To: Lee Duncan <lduncan@suse.com>,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	netdev@vger.kernel.org
Cc: Chris Leech <cleech@redhat.com>
Subject: [PATCH v2 00/11] Make iscsid-kernel communications namespace-aware
Date: Sat,  6 May 2023 16:29:19 -0700
Message-Id: <20230506232930.195451-1-cleech@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This set of patches modifies the kernel iSCSI initiator communications
so that they are namespace-aware. The goal is to allow multiple iSCSI
daemon (iscsid) to run at once as long as they are in separate
namespaces, and so that iscsid can run in containers.

Container runtime environments seem to want to containerize their own
components, and there have been complaints about the need to run iscsid
from the host network namespace. There are still priviledged
capabilities needed for iscsid, but these changes address the namespace
issue.

I've tested with iscsi_tcp and iser over rxe with an unmodified iscsid
running in a podman container.

Note that with iscsi_tcp, the connected socket will keep the network
namespace alive after container exit. The namespace will exit once the
connection terminates, and I'd recommend running with a iSCSI
noop_out_timeout set to error out the connection after the routing has
been removed.

v2: Changes from Lee's last RFC posting
- Minor changes to patches 2 & 3 to not break iSER

- Large changes in patch 6, merging in patches posted to the previous
  discussion. Use of current when setting the netns on an iscsi_tcp
  session has been removed, instead an unbound (from a host) session
  creation with an explicit netns interface has been added. Similar
  changes for iSER endpoints have been added, and iSER support for
  non-default network namespaces was enabled.

- The addition of patches 10 & 11 from the previous discussions to force
  removal of sessions on namespace exit.

Chris Leech, Lee Duncan (11):
  iscsi: create per-net iscsi netlink kernel sockets
  iscsi: associate endpoints with a host
  iscsi: sysfs filtering by network namespace
  iscsi: make all iSCSI netlink multicast namespace aware
  iscsi: check net namespace for all iscsi lookup
  iscsi: set netns for tcp and iser hosts
  iscsi: convert flashnode devices from bus to class
  iscsi: rename iscsi_bus_flash_* to iscsi_flash_*
  iscsi: filter flashnode sysfs by net namespace
  iscsi: make session and connection lists per-net
  iscsi: force destroy sesions when a network namespace exits

 drivers/infiniband/ulp/iser/iscsi_iser.c |  61 +-
 drivers/scsi/be2iscsi/be_iscsi.c         |   6 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |   6 +-
 drivers/scsi/cxgbi/libcxgbi.c            |   6 +-
 drivers/scsi/iscsi_tcp.c                 |  15 +-
 drivers/scsi/libiscsi.c                  |  16 +
 drivers/scsi/qedi/qedi_iscsi.c           |   6 +-
 drivers/scsi/qla4xxx/ql4_os.c            |  64 +-
 drivers/scsi/scsi_transport_iscsi.c      | 790 ++++++++++++++++-------
 include/scsi/libiscsi.h                  |   4 +
 include/scsi/scsi_transport_iscsi.h      |  75 ++-
 11 files changed, 725 insertions(+), 324 deletions(-)

-- 
2.39.2


