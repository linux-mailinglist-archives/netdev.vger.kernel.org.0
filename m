Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA9D4D3628
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiCIQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiCIQnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:43:49 -0500
X-Greylist: delayed 355 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 08:38:15 PST
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6103F5F4C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646843172;
    s=strato-dkim-0002; d=fpond.eu;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=cIaGDUEDcJVH2jVl1EofY5w/7KR7hnb4iLd0uJ8GbQ8=;
    b=NYPKTRfWNIJZKbH5UkuHVexpuT9AuLWwho55mZdMF5jlcMVva+nyEl1Hh+olJwre0r
    ejiqX6xWpLcp9WUSQSEUJF8WMSXxm13G+zZoA3NpCn2k4gZJdaqoleomx8SGS33pw1IS
    W1AC2nWFbH31eOxL9sMnCHUQHVgnCAvWWnVKljEwEC/LqV/MCKeRNLnm/uiuTb2aaR7e
    hrmDOqSNd8ouullMZ3OCvtESGCZ+r4hdutsLxfon491godsmkh/O7Cwe5gQs8tBvmKv0
    qN7JX+9i8LVwLFV31NcjVwNxc9paF+Gt+D1fieBUB+BE5P/yYi5oZsnozwcCVwzRb61C
    gjSg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR82Fcd2Ywjw=="
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.40.1 DYNA|AUTH)
    with ESMTPSA id 646b0ey29GQCJWA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 9 Mar 2022 17:26:12 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com, horms@verge.net.au,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v4 0/4] can: rcar_canfd: Add support for V3U flavor
Date:   Wed,  9 Mar 2022 17:26:05 +0100
Message-Id: <20220309162609.3726306-1-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This adds CANFD support for V3U (R8A779A0) SoCs. The V3U's IP supports up
to eight channels and has some other minor differences to the Gen3 variety:

- changes to some register offsets and layouts
- absence of "classic CAN" registers, both modes are handled through the
  CANFD register set

This patch set tries to accommodate these changes in a minimally intrusive
way.

This revision tries to address the remaining style issues raised by
reviewers. Thanks to Vincent, Marc and Simon for their reviews and
suggestions.

It has been successfully tested remotely on a V3U Falcon board, but only
with channels 0 and 1. We were not able to get higher channels to work in
both directions yet. It is not currently clear if this is an issue with the
driver, the board or the silicon, but the BSP vendor driver only works with
channels 0 and 1 as well, so my bet is on one of the latter. For this
reason, this series only enables known-working channels 0 and 1 on Falcon.

CU
Uli


Changes since v3:
- reformatted large macros for better readability
- made gpriv parameter explicit in all macros that use it
- other minor style adjustments

Changes since v2:
- dropped upstreamed clock patch
- replaced bracket/ternary maze with inline functions
- improved indentation to better reflect the logic
- removed redundant CAN mode check
- replaced strcpy() with initializer
- minor refactoring
- add Reviewed-Bys

Changes since v1:
- clk: added missing CANFD module clock
- driver: fixed tests for RZ/G2L so they won't break V3U
- driver: simplified two macros
- DT: enabled devices 0 and 1 on Falcon board
- DT: changed assigned-clock-rates to 80000000
- DT: added interrupt names


Ulrich Hecht (4):
  can: rcar_canfd: Add support for r8a779a0 SoC
  arm64: dts: renesas: r8a779a0: Add CANFD device node
  arm64: dts: renesas: r8a779a0-falcon: enable CANFD 0 and 1
  dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support

 .../bindings/net/can/renesas,rcar-canfd.yaml  |   2 +
 .../boot/dts/renesas/r8a779a0-falcon.dts      |  24 ++
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi     |  56 +++
 drivers/net/can/rcar/rcar_canfd.c             | 353 +++++++++++-------
 4 files changed, 299 insertions(+), 136 deletions(-)

-- 
2.30.2

