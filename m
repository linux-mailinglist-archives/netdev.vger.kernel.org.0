Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D25390CC7
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 01:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEYXLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhEYXLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:11:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D31260698;
        Tue, 25 May 2021 23:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621984185;
        bh=1IkQtMPV3pvDAz3GCbMK1VEmISi6kSMEwWFVrA8jUo0=;
        h=Date:From:To:Cc:Subject:From;
        b=RB5aUqSs5y5a0IPYATmM/7VYF11+WRr09WqC3gEYEA2Q4zJMK8R+YWGQA/PPfP7RB
         BSJoBgpus6zhTXr3FmYv/nKIH6vUISzRTYbKkAoSIB2m0VVxBi56dZjLJKXJToHg3O
         EKRL90ryK6eCVEyGBBRWK/iPZ2sXjmYsY+dzMfLXnQZ3eLqLHCwZH1c02tadRCALZB
         Oq39UvA77qtT48sggJE3dtXCeHmrPyVBeF0/qLTB6FIabYbB+8XdaXPuG1nEQBLnWZ
         J4TAiAbbA74rCsBZ3WcQS7eO/Qe2cVxvxI88gUJezW3qQoiCpf/O/PYq97VS7Ns+Tm
         DMS1we9IflxIA==
Date:   Tue, 25 May 2021 18:10:41 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] iavf: Replace one-element array in struct
 virtchnl_tc_info
Message-ID: <20210525231041.GA175914@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having a
dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in struct
virtchnl_tc_info instead of one-element array, and use the flex_array_size()
helper.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 +-
 include/linux/avf/virtchnl.h                    | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 123a737f6955..cf2ac577a96f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1021,7 +1021,7 @@ void iavf_enable_channels(struct iavf_adapter *adapter)
 		return;
 	}
 
-	len = struct_size(vti, list, adapter->num_tc - 1);
+	len = struct_size(vti, list, adapter->num_tc);
 	vti = kzalloc(len, GFP_KERNEL);
 	if (!vti)
 		return;
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index cda0c98ca978..b554913804bd 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -529,10 +529,10 @@ VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_channel_info);
 struct virtchnl_tc_info {
 	u32	num_tc;
 	u32	pad;
-	struct	virtchnl_channel_info list[1];
+	struct	virtchnl_channel_info list[];
 };
 
-VIRTCHNL_CHECK_STRUCT_LEN(24, virtchnl_tc_info);
+VIRTCHNL_CHECK_STRUCT_LEN(8, virtchnl_tc_info);
 
 /* VIRTCHNL_ADD_CLOUD_FILTER
  * VIRTCHNL_DEL_CLOUD_FILTER
@@ -1106,8 +1106,7 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 		if (msglen >= valid_len) {
 			struct virtchnl_tc_info *vti =
 				(struct virtchnl_tc_info *)msg;
-			valid_len += (vti->num_tc - 1) *
-				     sizeof(struct virtchnl_channel_info);
+			valid_len += flex_array_size(vti, list, vti->num_tc);
 			if (vti->num_tc == 0)
 				err_msg_format = true;
 		}
-- 
2.27.0

