Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF69289699
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390777AbgJIUBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:01:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:56841 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391068AbgJITxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:53:18 -0400
IronPort-SDR: xpv5XVGglX7lj+7qJJlZ+vbN22t/65YqrUKJKGSzG50o73yR62og6P7EuYB2tcanRlsrrnGTQV
 S90HMVUYZhxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="229715314"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="229715314"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:16 -0700
IronPort-SDR: tpdf2AjeaRc5H+9J2CTgDjuzQWeL2r1NHpqYA6zEYh1sueM+cncDhIB0ZXYbhrsfqtXGL/LVMU
 w/znFNAZKmjw==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="518801571"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:15 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH RFC PKS/PMEM 41/58] drivers/target: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:50:16 -0700
Message-Id: <20201009195033.3208459-42-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls in this driver are localized to a single thread.  To
avoid the over head of global PKRS updates use the new kmap_thread()
call.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/target/target_core_iblock.c    | 4 ++--
 drivers/target/target_core_rd.c        | 4 ++--
 drivers/target/target_core_transport.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1c181d31f4c8..df7b1568edb3 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -415,7 +415,7 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 	unsigned char *buf, *not_zero;
 	int ret;
 
-	buf = kmap(sg_page(sg)) + sg->offset;
+	buf = kmap_thread(sg_page(sg)) + sg->offset;
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	/*
@@ -423,7 +423,7 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 	 * incoming WRITE_SAME payload does not contain zeros.
 	 */
 	not_zero = memchr_inv(buf, 0x00, cmd->data_length);
-	kunmap(sg_page(sg));
+	kunmap_thread(sg_page(sg));
 
 	if (not_zero)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 408bd975170b..dbbdd39c5bf9 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -159,9 +159,9 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 			sg_assign_page(&sg[j], pg);
 			sg[j].length = PAGE_SIZE;
 
-			p = kmap(pg);
+			p = kmap_thread(pg);
 			memset(p, init_payload, PAGE_SIZE);
-			kunmap(pg);
+			kunmap_thread(pg);
 		}
 
 		page_offset += sg_per_table;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ff26ab0a5f60..8d0bae5a92e5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1692,11 +1692,11 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 			unsigned char *buf = NULL;
 
 			if (sgl)
-				buf = kmap(sg_page(sgl)) + sgl->offset;
+				buf = kmap_thread(sg_page(sgl)) + sgl->offset;
 
 			if (buf) {
 				memset(buf, 0, sgl->length);
-				kunmap(sg_page(sgl));
+				kunmap_thread(sg_page(sgl));
 			}
 		}
 
-- 
2.28.0.rc0.12.gb6a658bd00c9

