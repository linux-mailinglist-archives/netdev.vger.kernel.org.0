Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D31106534
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfKVFvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:51:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbfKVFvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F05192070A;
        Fri, 22 Nov 2019 05:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401909;
        bh=M40l9of/5w28DtT7o9OfgX+vth97LDYxOA329hDtE/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rkQ++TFMXvT8iUUBigEzLP+NTt1gQIVvGGl1U15YtzKqduMeScHNXFEITn+ytFGh
         lltUWGH6RAFsBRpXvlIQLokcf+folzcBPXqQb5xpATQJrXAdKWqbgx0m/p8NJPhezi
         3qNsmEU5LJXvKm2mGs+69l/ocnId3woOx37uylRs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sasha Levin <sashal@kernel.org>,
        ceph-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 140/219] libceph: drop last_piece logic from write_partial_message_data()
Date:   Fri, 22 Nov 2019 00:47:52 -0500
Message-Id: <20191122054911.1750-133-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 1f6b821aef78e3d79e8d598ae59fc7e23fb6c563 ]

last_piece is for the last piece in the current data item, not in the
entire data payload of the message.  This is harmful for messages with
multiple data items.  On top of that, we don't need to signal the end
of a data payload either because it is always followed by a footer.

We used to signal "more" unconditionally, until commit fe38a2b67bc6
("libceph: start defining message data cursor").  Part of a large
series, it introduced cursor->last_piece and also mistakenly inverted
the hint by passing last_piece for "more".  This was corrected with
commit c2cfa1940097 ("libceph: Fix ceph_tcp_sendpage()'s more boolean
usage").

As it is, last_piece is not helping at all: because Nagle algorithm is
disabled, for a simple message with two 512-byte data items we end up
emitting three packets: front + first data item, second data item and
footer.  Go back to the original pre-fe38a2b67bc6 behavior -- a single
packet in most cases.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/messenger.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index f7d7f32ac673c..6514816947fbe 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1612,7 +1612,6 @@ static int write_partial_message_data(struct ceph_connection *con)
 		struct page *page;
 		size_t page_offset;
 		size_t length;
-		bool last_piece;
 		int ret;
 
 		if (!cursor->resid) {
@@ -1620,10 +1619,9 @@ static int write_partial_message_data(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &page_offset, &length,
-					  &last_piece);
-		ret = ceph_tcp_sendpage(con->sock, page, page_offset,
-					length, !last_piece);
+		page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
+		ret = ceph_tcp_sendpage(con->sock, page, page_offset, length,
+					true);
 		if (ret <= 0) {
 			if (do_datacrc)
 				msg->footer.data_crc = cpu_to_le32(crc);
-- 
2.20.1

