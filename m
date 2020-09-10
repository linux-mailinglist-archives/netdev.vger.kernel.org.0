Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075792645BF
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 14:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgIJMLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 08:11:20 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11486 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbgIJMKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 08:10:07 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5a17140001>; Thu, 10 Sep 2020 05:07:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 10 Sep 2020 05:10:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 10 Sep 2020 05:10:04 -0700
Received: from localhost.localdomain (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Sep
 2020 12:10:01 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net] net: DCB: Validate DCB_ATTR_DCB_BUFFER argument
Date:   Thu, 10 Sep 2020 14:09:05 +0200
Message-ID: <e086a3597a33e16bcc57b97f81dcb2aa3ce48e31.1599739681.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599739668; bh=m/pAd3rmzduR18wiaHF7XB11moFGkoGFHdd945zwaVY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=BZ3+79IRXqCtfu+RZaAVfh2/aT00eXoszaJc079MUdEnzjpQ1kQPB1Rni6nwmcvjK
         p9KR8HvdCXtfn/76M1ckTV50OCMzp0UBZY6Jtuf6mZYVeR5BysjWRSv9Z4VMWvLN1/
         XdZXIaxqAG6do7MfkQgs+6uLCgKioO0uA1HgCybARiSbPRK241y+KYGI4kp1gk9p8m
         rtf7/x5n0/pLg28TsU89PsqagqwaQoP/U2hzqAFkEUwT1t+t3amwlz1Cw5CmMD4v04
         1eunSaR48tipTEWKKWuvgxu8LzuZOLdVdpvMNttCgZaPk+s7WhAUsX3sUj8warue/V
         7ZWZSkzHfhvVw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameter passed via DCB_ATTR_DCB_BUFFER is a struct dcbnl_buffer. The
field prio2buffer is an array of IEEE_8021Q_MAX_PRIORITIES bytes, where
each value is a number of a buffer to direct that priority's traffic to.
That value is however never validated to lie within the bounds set by
DCBX_MAX_BUFFERS. The only driver that currently implements the callback is
mlx5 (maintainers CCd), and that does not do any validation either, in
particual allowing incorrect configuration if the prio2buffer value does
not fit into 4 bits.

Instead of offloading the need to validate the buffer index to drivers, do
it right there in core, and bounce the request if the value is too large.

CC: Parav Pandit <parav@nvidia.com>
CC: Saeed Mahameed <saeedm@nvidia.com>
Fixes: e549f6f9c098 ("net/dcb: Add dcbnl buffer attribute")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/dcb/dcbnl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 84dde5a2066e..16014ad19406 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1426,6 +1426,7 @@ static int dcbnl_ieee_set(struct net_device *netdev, =
struct nlmsghdr *nlh,
 {
 	const struct dcbnl_rtnl_ops *ops =3D netdev->dcbnl_ops;
 	struct nlattr *ieee[DCB_ATTR_IEEE_MAX + 1];
+	int prio;
 	int err;
=20
 	if (!ops)
@@ -1475,6 +1476,13 @@ static int dcbnl_ieee_set(struct net_device *netdev,=
 struct nlmsghdr *nlh,
 		struct dcbnl_buffer *buffer =3D
 			nla_data(ieee[DCB_ATTR_DCB_BUFFER]);
=20
+		for (prio =3D 0; prio < ARRAY_SIZE(buffer->prio2buffer); prio++) {
+			if (buffer->prio2buffer[prio] >=3D DCBX_MAX_BUFFERS) {
+				err =3D -EINVAL;
+				goto err;
+			}
+		}
+
 		err =3D ops->dcbnl_setbuffer(netdev, buffer);
 		if (err)
 			goto err;
--=20
2.20.1

