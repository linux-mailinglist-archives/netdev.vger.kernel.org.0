Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4A0432B8B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 03:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhJSBod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 21:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhJSBob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 21:44:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41B2C61260;
        Tue, 19 Oct 2021 01:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634607738;
        bh=D7YEQastTxFQdKRaYpytIqKQ/4otb+9xuoq/+a0xTe8=;
        h=From:To:Cc:Subject:Date:From;
        b=Q1vHyVjPA1YYlW/kk/Au08uMtZBfDh7TNX69DFvVdRf1xD0GS1vp3Oi9sy5fivxYj
         r5JrbeMLvihQ+uygHe8teqas18pTG0utLYcc+I7xgnlb2Wf4VO3WcpyONxS8N7Tbf4
         XDC1P44EmhjMkN0GAcpQLAa0G1cF/3FRCqh8sAvvKab+E3DbeQnVOW52mEKr7Vfj+1
         THhKyJTKesrfOEpOb9vZ/UmaqqgYfHC4xLwJmWhsdu2ssEvO9eoFBSjhCGdn7s16Dg
         IEYfImJoHV/Z8swOgD7zG9LOVN69KhavBUJtNXTCCWUlMzJ9BBMV3TItaED+Dab/Fz
         O+wHEroE2revA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] ice: Fix clang -Wimplicit-fallthrough in ice_pull_qvec_from_rc()
Date:   Mon, 18 Oct 2021 18:42:03 -0700
Message-Id: <20211019014203.1926130-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.1.637.gf443b226ca
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/intel/ice/ice_lib.c:1906:2: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
        default:
        ^
drivers/net/ethernet/intel/ice/ice_lib.c:1906:2: note: insert 'break;' to avoid fall-through
        default:
        ^
        break;
1 error generated.

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1482
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index f981e77f72ad..03443c060507 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1903,6 +1903,7 @@ static struct ice_q_vector *ice_pull_qvec_from_rc(struct ice_ring_container *rc)
 	case ICE_TX_CONTAINER:
 		if (rc->tx_ring)
 			return rc->tx_ring->q_vector;
+		break;
 	default:
 		break;
 	}

base-commit: 939a6567f976efb8b3e6d601ce35eb56b17babd0
-- 
2.33.1.637.gf443b226ca

