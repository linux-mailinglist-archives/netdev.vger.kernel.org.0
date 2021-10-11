Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249CB4286F3
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhJKGpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhJKGpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 02:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E227060C41;
        Mon, 11 Oct 2021 06:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633934580;
        bh=8XqgNnSi1DT5I1+mNKRtuFuL+X9shKCQ0IBVFhwHhVE=;
        h=Date:From:To:Cc:Subject:From;
        b=TIG0lQkrDuwkqh2Q4f0b+KlJsljdZWuw6S6rkyFCMkfJuLP/X9h08t2PgM8RnwTG/
         gpwgLRFTRwrqtxT970+UyTDEgH/7incZHRxMS/uaa9QAh89Gdm6NqxuyGcL8YAhS9a
         6hD4nsO8TmphjrMsmKpmDlhrJx5J3RCDw9ZER0hk=
Date:   Mon, 11 Oct 2021 08:42:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org,
        Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        gregkh@linuxfoundation.org
Subject: [PATCH] sctp: account stream padding length for reconf chunk
Message-ID: <YWPc8Stn3iBBNh80@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Developer-Signature: v=1; a=openpgp-sha256; l=1434;
 i=gregkh@linuxfoundation.org; h=from:subject;
 bh=fWL+345goEDajSmeEAJ0ZaRVm0tKbjyM/lwIQgQ+9w0=;
 b=owGbwMvMwCRo6H6F97bub03G02pJDInJt40z8qIN137eW7ul4bupvEihyymTyrWt7jM3njkVdz7n
 hiBDRywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAEzk9imGBRP3sxuyHLa4kFO24uTcte
 Xe2eo77BnmKSf2vzpX8VLQTU3Y4CyXsViBeNAiAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp;
 fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>

"stream_len" is not always multiple of 4. Account padding length
which can be added in sctp_addto_chunk() for reconf chunk.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-sctp@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: cc16f00f6529 ("sctp: add support for generating stream reconf ssn reset request chunk")
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index b8fa8f1a7277..f7a1072a2a2a 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3694,8 +3694,8 @@ struct sctp_chunk *sctp_make_strreset_req(
 	struct sctp_chunk *retval;
 	__u16 outlen, inlen;
 
-	outlen = (sizeof(outreq) + stream_len) * out;
-	inlen = (sizeof(inreq) + stream_len) * in;
+	outlen = (sizeof(outreq) + SCTP_PAD4(stream_len)) * out;
+	inlen = (sizeof(inreq) + SCTP_PAD4(stream_len)) * in;
 
 	retval = sctp_make_reconf(asoc, outlen + inlen);
 	if (!retval)
-- 
2.33.0

