Return-Path: <netdev+bounces-2048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 376C8700170
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C69A1C210EE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 07:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386647473;
	Fri, 12 May 2023 07:27:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A73263C6
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 07:27:02 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE0E19B0;
	Fri, 12 May 2023 00:26:58 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 1B81340003;
	Fri, 12 May 2023 07:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1683876417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oEnODPyFGcP/98xY49JmKLD+frQAOe+Ua5W3+HOLQLQ=;
	b=m6gFKaEHm1gVTszqMqAGMMfZN3yRUHOpAh1hQEHsdB5m61b16ygbttCWWg3w1lWIXRJGwa
	rPRXhg905ag7bSjoN90HshoBzx+9KKZ8iHOkXChKU5PCPCQ1XpdOMzMyS5MNcwZ5ExQ+oy
	1xqYN3rGEk2clswVN79UKMkic+Pllt6xDmpIqSdKWMXcgh5s929kowQaZ0f/BFeXP8tN2l
	ecQDUrwA9nKce3lJM3FBYr+rw/bQd8d2X0ifTjBhf1SZyKNhIzmooVMfr7ZIrNJnDKWQs2
	N0hAkS1NSOvEuz7NumvoJuNkKQbBgR4qCNKNioaf+iEvI9ZPMlek+vZkuKA/0Q==
From: alexis.lothore@bootlin.com
To: andrew@lunn.ch,
	f.fainelli@gmail.com,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: linux-renesas-soc@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	herve.codina@bootlin.com,
	miquel.raynal@bootlin.com,
	milan.stevanovic@se.com,
	jimmy.lalande@se.com,
	pascal.eberhard@se.com
Subject: [PATCH net v3 0/3] net: dsa: rzn1-a5psw: fix STP states handling
Date: Fri, 12 May 2023 09:27:09 +0200
Message-Id: <20230512072712.82694-1-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

This small series fixes STP support and while adding a new function to
enable/disable learning, use that to disable learning on standalone ports
at switch setup as reported by Vladimir Oltean.

This series was initially submitted on net-next by Clement Leger, but some
career evolutions has made him hand me over those topics.
Also, this new revision is submitted on net instead of net-next for V1
based on Vladimir Oltean's suggestion

Changes since v2:
- fix commit split by moving A5PSW_MGMT_CFG_ENABLE in relevant commit
- fix reverse christmas tree ordering in a5psw_port_stp_state_set

Changes since v1:
- fix typos in commit messages and doc
- re-split STP states handling commit
- add Fixes: tag and new Signed-off-by
- submit series as fix on net instead of net-next
- split learning and blocking setting functions
- remove unused define A5PSW_PORT_ENA_TX_SHIFT
- add boolean for tx/rx enabled for clarity

Alexis Lothoré (1):
  net: dsa: rzn1-a5psw: fix STP states handling

Clément Léger (2):
  net: dsa: rzn1-a5psw: enable management frames for CPU port
  net: dsa: rzn1-a5psw: disable learning for standalone ports

 drivers/net/dsa/rzn1_a5psw.c | 83 ++++++++++++++++++++++++++++--------
 drivers/net/dsa/rzn1_a5psw.h |  3 +-
 2 files changed, 67 insertions(+), 19 deletions(-)

-- 
2.40.1


