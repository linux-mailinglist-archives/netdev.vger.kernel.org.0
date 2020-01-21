Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77ECA1434A4
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 01:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgAUAFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 19:05:50 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:55219 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAUAFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 19:05:49 -0500
Received: from kiste.fritz.box ([88.130.61.11]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MxmBc-1jpXcT0Tcs-00zFdE; Tue, 21 Jan 2020 01:05:07 +0100
From:   Hans Wippel <ndev@hwipl.net>
To:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net-next] net/smc: allow unprivileged users to read pnet table
Date:   Tue, 21 Jan 2020 01:04:46 +0100
Message-Id: <20200121000446.339681-1-ndev@hwipl.net>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gfd3XISGSqXcNgZHsPK9Pp2/eqxU1kDnmYzvUYAmrIN6x+qXIFD
 gylk1xh19JiuFsERQsAQLGcsdBg6kRLWHgplLedghnAtSOB3H14G3iArnovAy/h3y1ByQbp
 h6lqN/tyXhQXfDRSpzzLeYiVsKrNSaEM3AGyGIdcR2t2REmkNkoQz0rdzZuvWcsMkGp98uj
 HTnthnXJ1ekaODQNH9hIw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ROMrHL4N5JE=:QW3BUuZajnhUjEjVmdm3Z6
 MIe+XhxJFp9/YdmMj2lakwZCq0cXXOOb1+b+ipjLSECnCpPkR6zNxyVY6z8r4+hafT+7SfVE/
 4HgvVO0PP+rdn2Khsy6xg3b5M8SX9/FgejAoPbRBOqQMXeVcpBu1e5pPXZn7c7MI1rWpgRzQp
 L/fcConqYx7Im1lUfng+IwS2IO8L37vEad90/Z9BuM2NDZCajpl0c/NuWQUfYYRwn6z4hdHLQ
 T/auE1o3/NIZRKeX26N0Iga5GF57kTz4HlFVOId7+QJSkzx+H+BdhPP1oAebrfPbsHfSmY5J4
 6wag/BX7PSl4IW/U15qgs63i+VeiY6+QEeX0hpGVrhhKQPK+2fFAe0j2ZvVSIG6C4HFWWY5nM
 6j+MPjvaCvBOs14WhDa2c7yXpP28Wz+75T/wHAwcPPDb2cXG7lJtInzQtpGywH2vypmD0ahP9
 jvsmueI4RBDObTe263aMwn8TozgrSe8DixsuB3gWr5zTslNseORjtHkkgga2dfUTzYSerfRdU
 SIPk9sJuwpRSQRPI9Xz/YlE6cYXs2KoFP1oU3c2weoV1F/xBW8SfC0WAPwMpUZ/quoll1AaWA
 moAzadRMS3d7FpsCXtmOa8lJfBSDlJY/iWhYxmdiQ3IA1eAhg5SBMAwH4tRWznoPg0UZB5EoL
 lbjS5ctFlGVUuBaqAorzL/+o/hatC4lAJOTj4cRMPIJydsy397vHLEhb6L+RGNaIPGrurfJGq
 4Z177OOrCebU5hvzCYN0BMpHaLCqSzig7Mf8zxxU3d9MAuUw+Mk3JvqyHxxcQz2WjqMgnCJyc
 ZipG3lMJXuRdClfjBtoPGCoDZ+QLzRht/dAii2/Ay307swoYxw2xygQ9RZbApOUtK7qDsYSio
 5ZKXQ5Hr4wmV+581BU6g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current flags of the SMC_PNET_GET command only allow privileged
users to retrieve entries from the pnet table via netlink. The content
of the pnet table may be useful for all users though, e.g., for
debugging smc connection problems.

This patch removes the GENL_ADMIN_PERM flag so that unprivileged users
can read the pnet table.

Signed-off-by: Hans Wippel <ndev@hwipl.net>
---
 net/smc/smc_pnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 82dedf052d86..2a5ed47c3e08 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -611,7 +611,7 @@ static const struct genl_ops smc_pnet_ops[] = {
 	{
 		.cmd = SMC_PNETID_GET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-		.flags = GENL_ADMIN_PERM,
+		/* can be retrieved by unprivileged users */
 		.doit = smc_pnet_get,
 		.dumpit = smc_pnet_dump,
 		.start = smc_pnet_dump_start
-- 
2.25.0

