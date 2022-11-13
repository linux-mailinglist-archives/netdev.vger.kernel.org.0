Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E7762727F
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 21:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbiKMUeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 15:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiKMUd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 15:33:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706BBB87D;
        Sun, 13 Nov 2022 12:33:58 -0800 (PST)
Message-ID: <20221113201935.776707081@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668371635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=7MxnopjDUQ1bdcA7I42+FS4FruEBgUMrTam7b1hHOfY=;
        b=GD7AYqNO+9zs89yvH9A3kuIe3BFCbmfyUX9bM5DxoGC2/9W9NdipMWcwOhTl9Pifdc0yCX
        EDhvw2y+NoWqtlUiYz9FJqPR9CQny0Z12KgZ1d5E+TGqMmHlGz7MsPwC8U14oZBCtfjm6E
        REU/mFYEcZcwcS0BNroWm8KMYTtPidN5lfjTpV++dxwqsHCUccIX2hT1SqgjPzktYZ+lG4
        iELCXsN4rAiDDZdNSxbOCmhU6ODxCoqh5FpA0V3jZkg/TqabJcXckbAakEpN9zUH++JIo7
        t5Thzi4kcs9WVGg3Y1kptNIVVOv3RRInTTR/1b4TKFM82gG7b4uRm+PuDFV7Hw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668371635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=7MxnopjDUQ1bdcA7I42+FS4FruEBgUMrTam7b1hHOfY=;
        b=TOAACLZw9M5uSJ1ngz5jOUvHAmnmW+licTR7ipmgh8VxLfj/M9NIf4LtBb5fWxUDQ+jAKO
        PNfZNRVVBs7etJCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Marc Zyngier <maz@kernel.org>, Lee Jones <lee@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-ide@vger.kernel.org, James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        oss-drivers@corigine.com, Roy Pledge <Roy.Pledge@nxp.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev
Subject: [patch 00/10] genirq/msi: Treewide cleanup of pointless linux/msi.h includes
Date:   Sun, 13 Nov 2022 21:33:54 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on per device MSI domains I noticed that quite some files
include linux/msi.h just because.

The top level comment in the header file clearly says:

  Regular device drivers have no business with any of these functions....

and actually none of the drivers needs anything from msi.h.

The series is not depending on anything so the individual patches can be
picked up by the relevant maintainers. I'll mop up the leftovers close to
the merge window.

Thanks,

	tglx
