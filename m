Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84C148B21E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349966AbiAKQ2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:28:39 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.170]:41247 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343701AbiAKQ2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:28:38 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 11:28:37 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1641918155;
    s=strato-dkim-0002; d=fpond.eu;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=PbqiuTr1T9ZHDxmjmX8wVg3i4weX4mGMaS9RhEoZqWM=;
    b=JhvK5283qsrM7o/9WaJCKNQtaqUf12RzjGlvVd3aEOMCWdot9pMc3PZBGF7Y/XZDdd
    GRJjfEKCkv+uDJqcUtRP854a/aIHDaox2cLoLERal1VgArsfLJ4trCHC20s9xVLmloAP
    GeDl8xnQZCfoHBoUs2T8wGfX79icjmjUPrf4Yaw7U1QF+bzLKBguJbRcmFm8quflQEJf
    ixnyvhsZkP+WN6KE26qD3NrM+Di/uvApauMhO9pC8LZW62s87gi7UM+k+CLOFjdd6kyd
    cJXN+haRC7Qz/fuFQ6jRKxjIFMwc6ZwLM1KTXc3VgSYtre9l6+ro2Mf7MaOQfocJrJxA
    jOBQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73dmm4I5W0/AvA67Ot4fvR8nxYa0aI"
X-RZG-CLASS-ID: mo00
Received: from gummo.fritz.box
    by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
    with ESMTPSA id a48ca5y0BGMYHKq
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Jan 2022 17:22:34 +0100 (CET)
From:   Ulrich Hecht <uli+renesas@fpond.eu>
To:     linux-renesas-soc@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, prabhakar.mahadev-lad.rj@bp.renesas.com,
        biju.das.jz@bp.renesas.com, wsa@kernel.org,
        yoshihiro.shimoda.uh@renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, kuba@kernel.org, mailhol.vincent@wanadoo.fr,
        socketcan@hartkopp.net, geert@linux-m68k.org,
        kieran.bingham@ideasonboard.com,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v2 0/5] can: rcar_canfd: Add support for V3U flavor
Date:   Tue, 11 Jan 2022 17:22:26 +0100
Message-Id: <20220111162231.10390-1-uli+renesas@fpond.eu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This adds CANFD support for V3U (R8A779A0) SoCs. The V3U's IP supports up to
eight channels and has some other minor differences to the Gen3 variety:

- changes to some register offsets and layouts
- absence of "classic CAN" registers, both modes are handled through the
  CANFD register set

This patch set tries to accommodate these changes in a minimally intrusive
way.

This revision attempts to address issues raised by reviewers to the extent
possible, adds board enablement, a missing clock and some minor fixes. See
below for details.

It has been sucessfully tested remotely on a V3U Falcon board, but only with
channels 0 and 1. We were not able to get higher channels to work in both
directions yet. It is not currently clear if this is an issue with the
driver, the board or the silicon, but the BSP vendor driver only works with
channels 0 and 1 as well, so my bet is on one of the latter. For this
reason, this series only enables known-working channels 0 and 1 on Falcon.

CU
Uli


Changes since v1:
- clk: added missing CANFD module clock
- driver: fixed tests for RZ/G2L so they won't break V3U
- driver: simplified two macros
- DT: enabled devices 0 and 1 on Falcon board
- DT: changed assigned-clock-rates to 80000000
- DT: added interrupt names


Ulrich Hecht (5):
  clk: renesas: r8a779a0: add CANFD module clock
  can: rcar_canfd: Add support for r8a779a0 SoC
  arm64: dts: renesas: r8a779a0: Add CANFD device node
  arm64: dts: renesas: r8a779a0-falcon: enable CANFD 0 and 1
  dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support

 .../bindings/net/can/renesas,rcar-canfd.yaml  |   2 +
 .../boot/dts/renesas/r8a779a0-falcon.dts      |  24 ++
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi     |  56 +++++
 drivers/clk/renesas/r8a779a0-cpg-mssr.c       |   1 +
 drivers/net/can/rcar/rcar_canfd.c             | 231 ++++++++++++------
 5 files changed, 236 insertions(+), 78 deletions(-)

-- 
2.20.1

