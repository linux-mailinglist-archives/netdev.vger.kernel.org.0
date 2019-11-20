Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED9910421B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKTR3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:29:53 -0500
Received: from mout.gmx.net ([212.227.15.18]:45519 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbfKTR3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 12:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1574270981;
        bh=jVS7gVQIokrKcLPwvqZO5xvInjlDm7oWeVNjcNqyUF0=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=JBLlXJ/0FFXA8CT/nV15GkYCsXJCXjA+xl/Ez/oE9aNurUVdUHDBmu5+VfybpD5+v
         DyPUYOX/HZxHaDFNXjdhkkkAgKRSwsB784zbVQ2vJ8/ZoL6fd0RNVALts7Ate7zzHK
         WStslrsFjmqCqPSxjNbmpOTGtixZAG1DNoMbixGQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([37.4.249.139]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MoO2E-1i4xYK3uC8-00opek; Wed, 20 Nov 2019 18:29:41 +0100
From:   Stefan Wahren <wahrenst@gmx.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Heimpold <michael.heimpold@in-tech.com>,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH net 1/2] net: qca_spi: fix receive buffer size check
Date:   Wed, 20 Nov 2019 18:29:12 +0100
Message-Id: <1574270953-4119-2-git-send-email-wahrenst@gmx.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574270953-4119-1-git-send-email-wahrenst@gmx.net>
References: <1574270953-4119-1-git-send-email-wahrenst@gmx.net>
X-Provags-ID: V03:K1:xLFyq5AII8o10igpIA6D5ZiKuMPTbv0eJZqZw1upXYc3aAZpw7D
 KSShgnPkJl9QgJinp4NwRNJIKqDXVfJ+urrgk6Ay4Pl2H7wFjSs3AMsUFhHSVFQw0CKnS0l
 9B5Qlshbw0hI4HnK9cw1UKJs18q446TfDAP0Eed27/jf+meOlavi6NJXXSU4hal6uqFLIBa
 9FRjCUTaHdfU5moekUpcg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HeVcddz4VSM=:OeA2GFPrpj7A8rB/XkEho4
 NATbF8cizbCw1U8gRtDSl6TiLN2t33iunzTMZe6ZE5p3Fa4SIcy+wcxQvHDjYzAXXQinUEDa2
 /4/0ecD/0kGA5N0a9DtT1JElV2Rf6zWuGwi520O7Qbh1sNSAtO2L/NqprTlSlI//TPkRSXFG0
 g4nxZyPUJoFuH67wrzVvVTxrsr/b2j3qOl/vp+KMd0sZrNCiAu+hB+fos80/6vvBgR8tNl+1K
 W4utiZs4Iga+1q99LrFY+RmNi56lxZqFY3mHh0vXI1lscqa5fHoTso/RqkV7ynCYos8IUXcFt
 f923M4HOjve5ivKW32Olnk8Zb/nv/jLKp0o4ovi0HsaZd0Sa0KKtZnqbxwJlkWdfolz2It5US
 OyASzQpKBrSn9evtzVj2AfB2J0e0QBDwgaL8RwFYbPLwjM+ZB3Yo2NnfRswzfYBIkobPdvsUG
 b08/Oozqof1+mWsqS6Croar+M0QTyX2Uo2IjMfWoK/aEJq2ye57P7CfW2H5sGQ85sS/xo/CHM
 CjMO8tSJxW4Xme0Tuf04b5TmNDoxCn+39aGIinnjI+G69ZRtMxq7NRHmnjfAFgIcVmPPe+HVQ
 PAS1WxjyEGEZoTJJD4pmkwdUeDsUfoT8A/qC7mZ9fQwER9Jo1aNFU+f3LgC7mge7KLAXup2a+
 69vh6dfXpJuPJskLMAplAQPgVvlIxtYknQCZ4TAo51+DkzjVDfiB8qUP422HdRErdkdYPrJN1
 1awE37Q9GXw87U5drGx7Y60EcjguAuz086agqotUH0K+r3pAh/2nqiDen5+heUskobcPw5kWy
 Gug44i0hjWVr6fa8wJ0+VZ9vncf3orhri09po1AhJH9VkUNHRr7A0NTTilJWjNc3GMQ0pNxvS
 Aj5PjmY4L0blS3OKXPQbAjPWkjlPQcS75IeTYr4TYrxu/lwE1YfQ56gDp+m9J6ZUTEnQF8xNX
 BvEaMhZexjXUAIZ0WGj8p9JMeLRQHbFOil/ZRjMHog7Nt0zGR/BieKuFnObZTsYCVSzT+3ylw
 1KHpbI0z1a5Mr/mX1HWOPW5efWEy6zziQOMfF829lyrEMr+hTAq83u1Qm/jpiWpMa2jIPSOba
 t9csByoEk8zksjJefat0QWaZOJjhQPhgMaHThANpykhuj4QtUhGTmdikW0qnVvIfp/buPOAzs
 fuuz1T4UxpvrfYDNPyjSAycIKduva8vwk2ZUDYpADY/AM/S7f198fTkwqIx/TK6yJp1FtAzkx
 TOtMCyO9oLTRqBvCa5aNAXZmcggxcsY5l7LYcVw==
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Heimpold <michael.heimpold@in-tech.com>

When receiving many or larger packets, e.g. when doing a file download,
it was observed that the read buffer size register reports up to 4 bytes
more than the current define allows in the check.
If this is the case, then no data transfer is initiated to receive the
packets (and thus to empty the buffer) which results in a stall of the
interface.

These 4 bytes are a hardware generated frame length which is prepended
to the actual frame, thus we have to respect it during our check.

Fixes: 026b907d58c4 ("net: qca_spi: Add available buffer space verificatio=
n")
Signed-off-by: Michael Heimpold <michael.heimpold@in-tech.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
=2D--
 drivers/net/ethernet/qualcomm/qca_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/etherne=
t/qualcomm/qca_spi.c
index 5ecf61d..351f24f 100644
=2D-- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -363,7 +363,7 @@ qcaspi_receive(struct qcaspi *qca)
 	netdev_dbg(net_dev, "qcaspi_receive: SPI_REG_RDBUF_BYTE_AVA: Value: %08x=
\n",
 		   available);

-	if (available > QCASPI_HW_BUF_LEN) {
+	if (available > QCASPI_HW_BUF_LEN + QCASPI_HW_PKT_LEN) {
 		/* This could only happen by interferences on the SPI line.
 		 * So retry later ...
 		 */
=2D-
2.7.4

