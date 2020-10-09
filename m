Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33492895FF
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390387AbgJIT7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:59:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:40581 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391084AbgJITxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:53:24 -0400
IronPort-SDR: u2C4+hGb35+mtK+ndhIxjBMDcky7nNybvSNM6b4gqHKiqPmi0zpuRfougNCgV6H0aeq0l38fWM
 RPrL1Si+UaTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="162068110"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="162068110"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:23 -0700
IronPort-SDR: 1WKybDcesSB1sLOn62ClPw5Oz5roBPmtIQsa1XcymP/Rm5On5MJ4hIzRHLHnwze0O/9dY0G7BT
 oI/HBaoknNhQ==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="355863255"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:21 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sascha Sommer <saschasommer@freenet.de>, x86@kernel.org,
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
Subject: [PATCH RFC PKS/PMEM 43/58] drivers/mmc: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:50:18 -0700
Message-Id: <20201009195033.3208459-44-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls are localized to a single thread.  To avoid the over
head of global PKRS updates use the new kmap_thread() call.

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Sascha Sommer <saschasommer@freenet.de>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/mmc/host/mmc_spi.c    | 4 ++--
 drivers/mmc/host/sdricoh_cs.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 18a850f37ddc..ab28e7103b8d 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -918,7 +918,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 		}
 
 		/* allow pio too; we don't allow highmem */
-		kmap_addr = kmap(sg_page(sg));
+		kmap_addr = kmap_thread(sg_page(sg));
 		if (direction == DMA_TO_DEVICE)
 			t->tx_buf = kmap_addr + sg->offset;
 		else
@@ -950,7 +950,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 		/* discard mappings */
 		if (direction == DMA_FROM_DEVICE)
 			flush_kernel_dcache_page(sg_page(sg));
-		kunmap(sg_page(sg));
+		kunmap_thread(sg_page(sg));
 		if (dma_dev)
 			dma_unmap_page(dma_dev, dma_addr, PAGE_SIZE, dir);
 
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index 76a8cd3a186f..7806bc69c4f1 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -312,11 +312,11 @@ static void sdricoh_request(struct mmc_host *mmc, struct mmc_request *mrq)
 			int result;
 			page = sg_page(data->sg);
 
-			buf = kmap(page) + data->sg->offset + (len * i);
+			buf = kmap_thread(page) + data->sg->offset + (len * i);
 			result =
 				sdricoh_blockio(host,
 					data->flags & MMC_DATA_READ, buf, len);
-			kunmap(page);
+			kunmap_thread(page);
 			flush_dcache_page(page);
 			if (result) {
 				dev_err(dev, "sdricoh_request: cmd %i "
-- 
2.28.0.rc0.12.gb6a658bd00c9

