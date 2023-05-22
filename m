Return-Path: <netdev+bounces-4429-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B2570CC22
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 23:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65A8F281099
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 21:18:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57859174DB;
	Mon, 22 May 2023 21:18:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40367171C7
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 21:18:21 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF89C1
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:18:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-2533a03388dso4443062a91.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 14:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684790296; x=1687382296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PsW8Q2liStsmZdvN68xAF3uLNyidHc0UTDsP6e2y3CY=;
        b=XtVM4fceQ2WTRsXQVqipxpj82OmIhwfe91wVzjsRsMF214NQa2zp2n8jemzyFlDXx3
         qwW2V9xd9y9qeJuGmFxrJWvO9HzHE6HYWsd++iJKFo9n4VgFp23kL/rEwiQrq7POJKw3
         hg2S0ykKPQ0XLhABp8oTeoWTFq5JNMu88a8ko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684790296; x=1687382296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PsW8Q2liStsmZdvN68xAF3uLNyidHc0UTDsP6e2y3CY=;
        b=lKOKR14iYi6YhE+lF8yliYpakMY0JzZf7CDB2yDW3fUTBkycw1JXuKNnaY7poWxOHv
         BIGQGjU7SOh2sj120Xult+Gr833PH4m4MMMsUEJeO00Ka/h+yOtjUb346diSWDWwhLfC
         95pYubICvF1MPJN35rSDbLhNTqFgimG5lpvF/aftO+ndgHxKn64F5jZn2EVN/A4X8orY
         wY2vDBI+SxRe814mWl8mJByUeLK/2lY3NNWaS4txxA7JFMKIuG5fyax5F/MhuYCe9BPK
         tFETXfiGTvLfv9Z5pirOZC8HTjLDXmjU+cU77iZp8qG1rVy2UnoDDEGOxI5X/jFmr368
         T+Pg==
X-Gm-Message-State: AC+VfDy9cRhy8oFqhLsrZwvyI/S4qEuySJaf4PboSQxxqFRGPqQg0qWn
	zew15ge6sbYFyl9IZqviummLbQ==
X-Google-Smtp-Source: ACHHUZ7ZU/RbORCU/HZO2fy5Ltrpw+SjATaF3j8rBThT82bo+JocL6DhwNXbJwdvQJkfUGn+lIHv5g==
X-Received: by 2002:a17:90b:4a11:b0:255:874d:8262 with SMTP id kk17-20020a17090b4a1100b00255874d8262mr2147200pjb.21.1684790296424;
        Mon, 22 May 2023 14:18:16 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id bx6-20020a17090af48600b00247164c1947sm103448pjb.0.2023.05.22.14.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 14:18:15 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Kees Cook <keescook@chromium.org>,
	Christoph Hellwig <hch@infradead.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	James Smart <james.smart@broadcom.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Don Brace <don.brace@microchip.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Guo Xuenan <guoxuenan@huawei.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Daniel Latypov <dlatypov@google.com>,
	kernel test robot <lkp@intel.com>,
	intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	storagedev@microchip.com,
	linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Tales Aparecida <tales.aparecida@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] overflow: Add struct_size_t() helper
Date: Mon, 22 May 2023 14:18:13 -0700
Message-Id: <20230522211810.never.421-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12483; h=from:subject:message-id; bh=v+6XTxXiM621e+VoZudA3c6CeLAoGEAgXAOWKrvuVh0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBka9wV3rjRN4WgpA0zFOARq58kOdsC6aXUkBzBVAt2 0v0w94KJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZGvcFQAKCRCJcvTf3G3AJgvyEA CDL1SoQvYyChPTjPkWKQVlWMuWGPVXX+0imVGWb6/BhuJ0p/ihvzXgCoFSqgkTtbGAejKQ8q55/b4X KTibtzSbodnAOYIp3m42XHiUglzCiVIGrtzLA150A3ZMyejHlYCkOwpiYfvjp0JitMP71iBoac952h L6WA/9nxcwYtu9A06kjPoRR+QDJJ7xNhMeOJ2RG5fGPha3h8TYo63Iv42YEt0hmVaXStA93qG/eJn1 cH0Qx62w8NeICh4uUPfiztrdzAaZiNW4ZvGYZLcwxpU4NSJrZOhK5iLjm9EhVZJnAOvWlQN93c+RGy LZArD8SwlVLkTeyQCOREAX0S2u0BxbooSg/Hnye7mBE6/ImiQVhb3JXwjMv/Aq4WHrwbbjcEUOsTg4 lgLIx1cv0D+KJPWSu93oybn2yfHUil05v8Okw7s+8BSyZ1+KhOfiBPeE434qzOAcXpSv6MdwuVs9lD 85I0Vha4TxayJnfqGLBLi35ly5wpQS/W1pAbsXfdIclhKR1ewJXsw8gqY5m2zRLtGFQC0HFvDcOT9M 9szgADZLsWpSDztMsjfZQ07tBJK4fDwHcvfDYWZzmBo3PlM5E4kiR2EbbuhTUBhYDZi+WGg7E6MGnh EomdYho8VLxaFapIrETQotiJQL8PEFVn60gCKpBJUrsX5ElPh6ctMIPYcQKA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

While struct_size() is normally used in situations where the structure
type already has a pointer instance, there are places where no variable
is available. In the past, this has been worked around by using a typed
NULL first argument, but this is a bit ugly. Add a helper to do this,
and replace the handful of instances of the code pattern with it.

Instances were found with this Coccinelle script:

@struct_size_t@
identifier STRUCT, MEMBER;
expression COUNT;
@@

-       struct_size((struct STRUCT *)\(0\|NULL\),
+       struct_size_t(struct STRUCT,
                MEMBER, COUNT)

Suggested-by: Christoph Hellwig <hch@infradead.org>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Don Brace <don.brace@microchip.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Cc: linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
Cc: megaraidlinux.pdl@broadcom.com
Cc: storagedev@microchip.com
Cc: linux-xfs@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
Unless there are objections, I'll just take this via my tree...
---
 drivers/net/ethernet/intel/ice/ice_ddp.h  |  9 ++++-----
 drivers/nvme/host/fc.c                    |  8 ++++----
 drivers/scsi/hptiop.c                     |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c | 12 ++++++------
 drivers/scsi/megaraid/megaraid_sas_fp.c   |  6 +++---
 drivers/scsi/smartpqi/smartpqi_init.c     |  2 +-
 fs/xfs/libxfs/xfs_btree.h                 |  2 +-
 fs/xfs/scrub/btree.h                      |  2 +-
 include/linux/overflow.h                  | 18 +++++++++++++++++-
 lib/overflow_kunit.c                      |  2 +-
 10 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ddp.h b/drivers/net/ethernet/intel/ice/ice_ddp.h
index 37eadb3d27a8..41acfe26df1c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ddp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ddp.h
@@ -185,7 +185,7 @@ struct ice_buf_hdr {
 
 #define ICE_MAX_ENTRIES_IN_BUF(hd_sz, ent_sz)                                 \
 	((ICE_PKG_BUF_SIZE -                                                  \
-	  struct_size((struct ice_buf_hdr *)0, section_entry, 1) - (hd_sz)) / \
+	  struct_size_t(struct ice_buf_hdr,  section_entry, 1) - (hd_sz)) / \
 	 (ent_sz))
 
 /* ice package section IDs */
@@ -297,7 +297,7 @@ struct ice_label_section {
 };
 
 #define ICE_MAX_LABELS_IN_BUF                                             \
-	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_label_section *)0, \
+	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_label_section,  \
 					   label, 1) -                    \
 				       sizeof(struct ice_label),          \
 			       sizeof(struct ice_label))
@@ -352,7 +352,7 @@ struct ice_boost_tcam_section {
 };
 
 #define ICE_MAX_BST_TCAMS_IN_BUF                                               \
-	ICE_MAX_ENTRIES_IN_BUF(struct_size((struct ice_boost_tcam_section *)0, \
+	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_boost_tcam_section,  \
 					   tcam, 1) -                          \
 				       sizeof(struct ice_boost_tcam_entry),    \
 			       sizeof(struct ice_boost_tcam_entry))
@@ -372,8 +372,7 @@ struct ice_marker_ptype_tcam_section {
 };
 
 #define ICE_MAX_MARKER_PTYPE_TCAMS_IN_BUF                                    \
-	ICE_MAX_ENTRIES_IN_BUF(                                              \
-		struct_size((struct ice_marker_ptype_tcam_section *)0, tcam, \
+	ICE_MAX_ENTRIES_IN_BUF(struct_size_t(struct ice_marker_ptype_tcam_section,  tcam, \
 			    1) -                                             \
 			sizeof(struct ice_marker_ptype_tcam_entry),          \
 		sizeof(struct ice_marker_ptype_tcam_entry))
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 2ed75923507d..691f2df574ce 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2917,8 +2917,8 @@ nvme_fc_create_io_queues(struct nvme_fc_ctrl *ctrl)
 
 	ret = nvme_alloc_io_tag_set(&ctrl->ctrl, &ctrl->tag_set,
 			&nvme_fc_mq_ops, 1,
-			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
-				    ctrl->lport->ops->fcprqst_priv_sz));
+			struct_size_t(struct nvme_fcp_op_w_sgl, priv,
+				      ctrl->lport->ops->fcprqst_priv_sz));
 	if (ret)
 		return ret;
 
@@ -3536,8 +3536,8 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	ret = nvme_alloc_admin_tag_set(&ctrl->ctrl, &ctrl->admin_tag_set,
 			&nvme_fc_admin_mq_ops,
-			struct_size((struct nvme_fcp_op_w_sgl *)NULL, priv,
-				    ctrl->lport->ops->fcprqst_priv_sz));
+			struct_size_t(struct nvme_fcp_op_w_sgl, priv,
+				      ctrl->lport->ops->fcprqst_priv_sz));
 	if (ret)
 		goto fail_ctrl;
 
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 06ccb51bf6a9..f5334ccbf2ca 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1394,8 +1394,8 @@ static int hptiop_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
 	host->cmd_per_lun = le32_to_cpu(iop_config.max_requests);
 	host->max_cmd_len = 16;
 
-	req_size = struct_size((struct hpt_iop_request_scsi_command *)0,
-			       sg_list, hba->max_sg_descriptors);
+	req_size = struct_size_t(struct hpt_iop_request_scsi_command,
+				 sg_list, hba->max_sg_descriptors);
 	if ((req_size & 0x1f) != 0)
 		req_size = (req_size + 0x1f) & ~0x1f;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 317c944c68e3..050eed8e2684 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5153,8 +5153,8 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		fusion->max_map_sz = ventura_map_sz;
 	} else {
 		fusion->old_map_sz =
-			struct_size((struct MR_FW_RAID_MAP *)0, ldSpanMap,
-				    instance->fw_supported_vd_count);
+			struct_size_t(struct MR_FW_RAID_MAP, ldSpanMap,
+				      instance->fw_supported_vd_count);
 		fusion->new_map_sz =  sizeof(struct MR_FW_RAID_MAP_EXT);
 
 		fusion->max_map_sz =
@@ -5789,8 +5789,8 @@ megasas_setup_jbod_map(struct megasas_instance *instance)
 	struct fusion_context *fusion = instance->ctrl_context;
 	size_t pd_seq_map_sz;
 
-	pd_seq_map_sz = struct_size((struct MR_PD_CFG_SEQ_NUM_SYNC *)0, seq,
-				    MAX_PHYSICAL_DEVICES);
+	pd_seq_map_sz = struct_size_t(struct MR_PD_CFG_SEQ_NUM_SYNC, seq,
+				      MAX_PHYSICAL_DEVICES);
 
 	instance->use_seqnum_jbod_fp =
 		instance->support_seqnum_jbod_fp;
@@ -8033,8 +8033,8 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	if (instance->adapter_type != MFI_SERIES) {
 		megasas_release_fusion(instance);
 		pd_seq_map_sz =
-			struct_size((struct MR_PD_CFG_SEQ_NUM_SYNC *)0,
-				    seq, MAX_PHYSICAL_DEVICES);
+			struct_size_t(struct MR_PD_CFG_SEQ_NUM_SYNC,
+				      seq, MAX_PHYSICAL_DEVICES);
 		for (i = 0; i < 2 ; i++) {
 			if (fusion->ld_map[i])
 				dma_free_coherent(&instance->pdev->dev,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 4463a538102a..b8b388a4e28f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -326,9 +326,9 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 	else if (instance->supportmax256vd)
 		expected_size = sizeof(struct MR_FW_RAID_MAP_EXT);
 	else
-		expected_size = struct_size((struct MR_FW_RAID_MAP *)0,
-					    ldSpanMap,
-					    le16_to_cpu(pDrvRaidMap->ldCount));
+		expected_size = struct_size_t(struct MR_FW_RAID_MAP,
+					      ldSpanMap,
+					      le16_to_cpu(pDrvRaidMap->ldCount));
 
 	if (le32_to_cpu(pDrvRaidMap->totalSize) != expected_size) {
 		dev_dbg(&instance->pdev->dev, "megasas: map info structure size 0x%x",
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 03de97cd72c2..f4e0aa262164 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5015,7 +5015,7 @@ static int pqi_create_queues(struct pqi_ctrl_info *ctrl_info)
 }
 
 #define PQI_REPORT_EVENT_CONFIG_BUFFER_LENGTH	\
-	struct_size((struct pqi_event_config *)0, descriptors, PQI_MAX_EVENT_DESCRIPTORS)
+	struct_size_t(struct pqi_event_config,  descriptors, PQI_MAX_EVENT_DESCRIPTORS)
 
 static int pqi_configure_events(struct pqi_ctrl_info *ctrl_info,
 	bool enable_events)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index a2aa36b23e25..4d68a58be160 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -301,7 +301,7 @@ struct xfs_btree_cur
 static inline size_t
 xfs_btree_cur_sizeof(unsigned int nlevels)
 {
-	return struct_size((struct xfs_btree_cur *)NULL, bc_levels, nlevels);
+	return struct_size_t(struct xfs_btree_cur, bc_levels, nlevels);
 }
 
 /* cursor flags */
diff --git a/fs/xfs/scrub/btree.h b/fs/xfs/scrub/btree.h
index 9d7b9ee8bef4..c32b5fad6174 100644
--- a/fs/xfs/scrub/btree.h
+++ b/fs/xfs/scrub/btree.h
@@ -60,7 +60,7 @@ struct xchk_btree {
 static inline size_t
 xchk_btree_sizeof(unsigned int nlevels)
 {
-	return struct_size((struct xchk_btree *)NULL, lastkey, nlevels - 1);
+	return struct_size_t(struct xchk_btree, lastkey, nlevels - 1);
 }
 
 int xchk_btree(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 0e33b5cbdb9f..f9b60313eaea 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -283,7 +283,7 @@ static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
  * @member: Name of the array member.
  * @count: Number of elements in the array.
  *
- * Calculates size of memory needed for structure @p followed by an
+ * Calculates size of memory needed for structure of @p followed by an
  * array of @count number of @member elements.
  *
  * Return: number of bytes needed or SIZE_MAX on overflow.
@@ -293,4 +293,20 @@ static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
 		sizeof(*(p)) + flex_array_size(p, member, count),	\
 		size_add(sizeof(*(p)), flex_array_size(p, member, count)))
 
+/**
+ * struct_size_t() - Calculate size of structure with trailing flexible array
+ * @type: structure type name.
+ * @member: Name of the array member.
+ * @count: Number of elements in the array.
+ *
+ * Calculates size of memory needed for structure @type followed by an
+ * array of @count number of @member elements. Prefer using struct_size()
+ * when possible instead, to keep calculations associated with a specific
+ * instance variable of type @type.
+ *
+ * Return: number of bytes needed or SIZE_MAX on overflow.
+ */
+#define struct_size_t(type, member, count)					\
+	struct_size((type *)NULL, member, count)
+
 #endif /* __LINUX_OVERFLOW_H */
diff --git a/lib/overflow_kunit.c b/lib/overflow_kunit.c
index dcd3ba102db6..34db0b3aa502 100644
--- a/lib/overflow_kunit.c
+++ b/lib/overflow_kunit.c
@@ -649,7 +649,7 @@ struct __test_flex_array {
 static void overflow_size_helpers_test(struct kunit *test)
 {
 	/* Make sure struct_size() can be used in a constant expression. */
-	u8 ce_array[struct_size((struct __test_flex_array *)0, data, 55)];
+	u8 ce_array[struct_size_t(struct __test_flex_array, data, 55)];
 	struct __test_flex_array *obj;
 	int count = 0;
 	int var;
-- 
2.34.1


