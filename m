Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384A0686DDC
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjBASZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjBASZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:25:09 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C8B7F6A4
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:25:06 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 311INgS6648784
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 18:23:43 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 311INaIB943472
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 19:23:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1675275817; bh=s4K1xGJV0XdXmmrYpx1babEqIgkFPBu2QhDaQJVAc4E=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=eemcd2kptDBwwV+pbimZXLHvrb6Db8x/V9Nt8fbE3l5K6cyAf67lDGWPd4DhE6Qa+
         VeGu1jN9ha95BShzRpPpDlahMJMGaEQ3++u94WdrRv4BPUaohu5XSd2lqcdGXNbfFW
         a3l4s1oP16WV6f7Z//teQsSgefCExtZL/+XRxN+g=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 311INWCl943459;
        Wed, 1 Feb 2023 19:23:32 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v5 net 0/3] fixes for mtk_eth_soc
Date:   Wed,  1 Feb 2023 19:23:28 +0100
Message-Id: <20230201182331.943411-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v4:
 - use same field order for kernel-doc and code in patch 1
 - cc'ing full maintainer list from get_maintainer.pl

Changes since v3:
 - fill hole in struct mtk_pcs with new interface field
 - improved patch 2 commit message
 - added fixes tags
 - updated review tags
 
Changes since v2:
 - use "true" for boolean
 - fix SoB typo
 - updated tags

Changes since v1:
 - only power down on changes, fix from Russel
 - dropped bogus uncondional in-band patch
 - added pcs poll patch from Alexander
 - updated tags


Fix mtk_eth_soc sgmii configuration.

This has been tested on a MT7986 with a Maxlinear GPY211C phy
permanently attached to the second SoC mac.


Alexander Couzens (2):
  net: mediatek: sgmii: ensure the SGMII PHY is powered down on
    configuration
  mtk_sgmii: enable PCS polling to allow SFP work

Bjørn Mork (1):
  net: mediatek: sgmii: fix duplex configuration

 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  4 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 46 ++++++++++++++-------
 2 files changed, 35 insertions(+), 15 deletions(-)

-- 
2.30.2

