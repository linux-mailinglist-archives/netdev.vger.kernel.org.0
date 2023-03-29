Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFAB6CD860
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjC2LYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjC2LYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:24:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B22340C1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20819B82212
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67010C433D2;
        Wed, 29 Mar 2023 11:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680089047;
        bh=J2Xlu7RZtJcOHCXbS8sMD8tTm5zUkpV2GepLfGz+P9E=;
        h=From:To:Cc:Subject:Date:From;
        b=Hje0O+gcIcryERV/gSoE4FQ2OyCjVqKzDGnjmFqh7mi5JaTQ8wxA40AehiKrVmTE8
         CSBGrTYTOXJsB1/1VADAo/I8oBtuYTjF13Yer6YA1dvB1hfwFSHtN9gj3fRtq1YxI1
         d6/2wN9CkOMZAFOJajv7/h9NFTVyZwjmyYHheaKjX+GuUbw1cjDAa+Llh+nR5YT8vr
         JSIpA8rhwPZ16iiZr+dOWQO15LkZuS0x/tmmVS5xPVz5oWgT/wrhGM4ENj+UG9RtMp
         IiScY/Duh5msP7LaO/Xf1CvR2c1xXkTk2MWvtULWSBNA1JelLLGq4T8gwts/AKGhIK
         1EEFFz7jn3RJw==
From:   Simon Horman <horms@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] octeontx2-af: update type of prof fields in nix_aw_enq_req
Date:   Wed, 29 Mar 2023 13:23:56 +0200
Message-Id: <20230329112356.458072-1-horms@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update type of prof and prof_mask fields in nix_as_enq_req
from u64 to struct nix_bandprof_s, which is 128 bits wide.

This is to address warnings with compiling with gcc-12 W=1
regarding string fortification.

Although the union of which these fields are a member is 128bits
wide, and thus writing a 128bit entity is safe, the compiler flags
a problem as the field being written is only 64 bits wide.

  CC [M]  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.o
scripts/Makefile.build:252: ./drivers/net/ethernet/marvell/octeontx2/nic/Makefile: otx2_dcbnl.o is added to multiple modules: rvu_nicpf rvu_nicvf
  CC [M]  drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.o
  CC [M]  drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.o
  CC [M]  drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.o
  CC [M]  drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.o
In file included from ./include/linux/string.h:254,
                 from ./include/linux/bitmap.h:11,
                 from ./include/linux/cpumask.h:12,
                 from ./arch/x86/include/asm/paravirt.h:17,
                 from ./arch/x86/include/asm/cpuid.h:62,
                 from ./arch/x86/include/asm/processor.h:19,
                 from ./arch/x86/include/asm/timex.h:5,
                 from ./include/linux/timex.h:67,
                 from ./include/linux/time32.h:13,
                 from ./include/linux/time.h:60,
                 from ./include/linux/stat.h:19,
                 from ./include/linux/module.h:13,
                 from drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:8:
In function 'fortify_memcpy_chk',
    inlined from 'rvu_nix_blk_aq_enq_inst' at drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:969:4:
./include/linux/fortify-string.h:529:25: error: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
  529 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'fortify_memcpy_chk',
    inlined from 'rvu_nix_blk_aq_enq_inst' at drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:984:4:
./include/linux/fortify-string.h:529:25: error: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Werror=attribute-warning]
  529 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Compile tested only!

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 5727d67e0259..8fb5cae7285b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -936,7 +936,7 @@ struct nix_aq_enq_req {
 		struct nix_cq_ctx_s cq;
 		struct nix_rsse_s   rss;
 		struct nix_rx_mce_s mce;
-		u64 prof;
+		struct nix_bandprof_s prof;
 	};
 	union {
 		struct nix_rq_ctx_s rq_mask;
@@ -944,7 +944,7 @@ struct nix_aq_enq_req {
 		struct nix_cq_ctx_s cq_mask;
 		struct nix_rsse_s   rss_mask;
 		struct nix_rx_mce_s mce_mask;
-		u64 prof_mask;
+		struct nix_bandprof_s prof_mask;
 	};
 };
 
-- 
2.30.2

