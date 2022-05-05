Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768DF51C50D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381904AbiEEQ0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381906AbiEEQ0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:26:14 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F415C640
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:22:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXHYNP8e0qwAng8c71DOkK8gRANR2Ql38uLDrW2j+nafR3dH2m7ilcS76DOuWs7LUepAtCAf6m7X2MB9N+5tv1VnU8SL50+6Hsp7WU7gIk630BL0Nj9oye4myvICT7w6y2Aa1fsJWH5Pn39gdV/m30dpo9K8vPizevkImTuzMyyowr9TQISkbmLeo0owvH/dX3HSxCG+DWKW8QbFEQQPJ5uCc5DVXLiBSTQA+gg5zFBgeXyunRFKBGaWCxQwYMRHsj4q/PyvYRSziPvffNC2c/+RbUUHdns/JlEKTcDDEKs5niQiEjHncVaply2rBhxMdWSjphO080QoRqbNiHmdJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtIXE9uGT1rx0dWH8gjZzbCzJY9MqrgjHZbNSYizQKk=;
 b=QzJbx6xOuco+9ujyHvtJruvFqyOKMRjy9XERfqPFV7zPCGpm0ECv7l9ODabso4fN8x5k1o5rxiU31aaQVA7koFZ5k7PK7F7g9zsnlfIfrcw7lh4osgIzrxxhutzQYGjx9y8T4weuIYWZnvEBneWPz+R7/T5HmPcGwzW0Sp+sA10Ap2YMD8SMTBLnfpCPpE7sXbtaAIAUcIJJvWRRRa4q49Rdp5LsImBYX7Z6Qi46Be+DzLODGWAw1wzVrJ0By6X6pcPPj2JwNklg6B7Ede02om3il8zOKzRWzpZ0v5UpU68YNoHqTJU/Y23DM1LyJ1NYR1esBBbAkEPFclCu1WInIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtIXE9uGT1rx0dWH8gjZzbCzJY9MqrgjHZbNSYizQKk=;
 b=E9nVDBXZHze8UqKZEXdSxetxrdYbVc3uUywfrQygHaTWnmp8YaR7bsPvFlF9F5jc673ctOvU2TJxIKnjXRKKdF8/OBRPCVPsL08eFNM8/+Tj+R5kYJlUnkoWSt25itoyDVcCW9P5PGOuhrmsH/HdbOi78zYYxktYlkTTwMCatug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5522.eurprd04.prod.outlook.com (2603:10a6:208:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 16:22:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 16:22:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 3/4] net: dsa: felix: perform MDB migration based on ocelot->multicast list
Date:   Thu,  5 May 2022 19:22:12 +0300
Message-Id: <20220505162213.307684-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505162213.307684-1-vladimir.oltean@nxp.com>
References: <20220505162213.307684-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0021.eurprd03.prod.outlook.com
 (2603:10a6:208:14::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30da6618-a71c-480a-6ef8-08da2eb374b2
X-MS-TrafficTypeDiagnostic: AM0PR04MB5522:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB552240AA88022795E1D5A612E0C29@AM0PR04MB5522.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CbgEOM/m2Hd+iqdEM0zTAfMRlev0QSX0sfoBlronthoV5Q7mc0MKnEdDMAaByuOqoT7NDrcXqNkeu9kmXMETCU7INsyELBCdJRb0w/lkMeMruO6bUtqx0pzyHDphMMNRAqEUVL5i6JBRyR6nb1NIAj11QirD5olRKKYDV1zZuB3ZBoSJhwqxRaWd6kBxDcg5qk42Pk7QhOPWfZGpiAwcbZ63Rd0NOfn3fT0N5wuuxhIJVlPZldTF66Ekdz28e+DNQ/nItQdicg21m5E1dxtDpjjHsV92f222m3ygOuDHyRZECdLX8gF6huj+FJ4BlruGEucQlAaiXu8DmHDWrPC5oDS2EPvze/2rN/zLBnLKOTxb0QWvkxgryvBCCg7q7AEhTaHHcec+awYjzfvOgn12dSx5OzbB1o6ArjCc+4Ea2lZFt5TF0lLjj6/PuYKAskPvfL823p6JMxxW6uYCAvMpoRukUUuMaNDCTy9QWBePogb8Vl/89W050n2IaZf3ECwjNZEHp/YL2EtjjIdt1draBxPqTT7sfiuVYQVLy1IMXlpR86lf9UyEzcUt1QwS6/6cXU+QMK0sXPcXoj9rJQcJB9WY1LFXYPwN9y28wG+S3I878demxkbpIIm5ZG02kquImsEvZIid2xLTetVKmNazHT6zI01+wl25+1RaFZPjkM85Yp8fXHCc/ij5DNCbsEGv8hoqcYiPTEQj3gwTWNz2gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(5660300002)(7416002)(508600001)(8936002)(6506007)(6916009)(2616005)(52116002)(54906003)(186003)(6666004)(6512007)(26005)(36756003)(6486002)(44832011)(83380400001)(66946007)(4326008)(8676002)(66476007)(86362001)(66556008)(1076003)(2906002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ffLMiyi0PMbyeRK3jetZ3e1+XQor+Rtc0QE/mKbbC0FghIRYkb55h1SpZL27?=
 =?us-ascii?Q?vLdBJAsxEbS0HmpRZ4Ey6VMBuqzdQCvPfDao1STgGASDlF70QdAtm5QUSBXZ?=
 =?us-ascii?Q?ogSS140rYxSF+CSj7DwzhPlggohhuIig//BKCMUSq1ni/rgAxivmRfYF5ibi?=
 =?us-ascii?Q?Z4Z8Bhj6VcDM3XjTb139JJ5Yc3x5Kghm5J3ZjodarGs45guYaYcfqA9CiGeX?=
 =?us-ascii?Q?5Cgiux02+9dtiRi32S5pCuFEFwDjyggR0IX68zItKJpFCKaWfB6trXn0xABQ?=
 =?us-ascii?Q?e7UyRfcgkIZeCxJ/fUt/dAsDN83Fn9wI5kdK91f4TQiuz+9/aWH6c0J/3uMN?=
 =?us-ascii?Q?GvGjiPYmeDznaM2xuWRyrjnVHrMzL6xBm3dkFY/C8EAbPoeyJQMFH6c/96QJ?=
 =?us-ascii?Q?lcMLBXdaR7HDdouifElykj31IwTXo/bfGA2b7fky5Y8jTfH0A/9NLABFT23u?=
 =?us-ascii?Q?zTQOK7IffBpJW4tC+S9cTCUy8Mdmk4mE3CHynQlcoaSprM+cGQvCd7RmgrFY?=
 =?us-ascii?Q?IUMigZ3Cqem2vd2P/NbzTzUi0OWm2ACCk1r4tqic8MyxNwk/jcmN/P2xZlMt?=
 =?us-ascii?Q?rcUSS9Xc6T6bF1SVNoC1hr9uWPJ3ri9jILVufbKS42iKP7KncQLcuyNYd6Fn?=
 =?us-ascii?Q?gBSKlKW+j/5h5JGPKIZ2Ix3Qu5KQadmCM8oEmjvuM6CNygDBr906fUxNmpAI?=
 =?us-ascii?Q?WBx2/Htwj+zPeQp9E3hPJcEFSPgnJkQSN0ES6Iq8Arir6tZRC1RmrEUhIPv8?=
 =?us-ascii?Q?oPonkQKZ/6bEa7T5ia3vEfomrYeEGWrelheylk70WkMQtIQY/+85/10iZmL5?=
 =?us-ascii?Q?4tuN4BCD7jsBGiJecsMHjNtmRiHv0FCrnmo3ZvNxeWgXNzUPKBbQ3738I3Bz?=
 =?us-ascii?Q?b4FVbxzgNy7ap4m28m+wja90kmkqsjh8FeKTseoah53sA+7TUtWr30LqWqqJ?=
 =?us-ascii?Q?1BSuhsSmj1guPnvgKLSDgs6WGvs3haUO23h7MJoFBQrmMsVGQiw6Cw2j7CWD?=
 =?us-ascii?Q?JSFvVoM5jg3uTXUtDSz2HiPZ8vkInqyuR24X7oN0IxPGdDqQ+BfieGRaStAo?=
 =?us-ascii?Q?MzjCD7qF7dJDazSy/1KdBWavha+9uG/b5xeZ5mFKBpXEhbD9+SnwyUb1daQG?=
 =?us-ascii?Q?JhQdCkS4M7f8khpMKu3icHAof4UCVN2hym1PLqXNeM6DQWUfHzvTX6T2eDft?=
 =?us-ascii?Q?BN2dksWAgTjUy1WGb105K53F+6RYSB3k8OnIDuj01ShNH+P6yzcx8hM2LZd+?=
 =?us-ascii?Q?8kG9oyYaCFU3fWybRqBO1DepTH9eKyJazsO6EzjRQEWKS4nlL03ilRGfFJVi?=
 =?us-ascii?Q?verky7XKtEmUCJ0lphWd53ZvVEOhMV/gpnX3FVpd/WwMR8kpO0smVMG0Q15t?=
 =?us-ascii?Q?N0tCgjyR5gSEo1B6pnhKQOCsSJTZoKVlLggb1USc/KHklkbpzx3wh0GnUEqj?=
 =?us-ascii?Q?WdHZrxjOQKQurDjFsKGR2YVEghtLRQ5vViMiy8G3bSPXGLHEIYVcEjqzYJP0?=
 =?us-ascii?Q?6yaCwm4D7uYWDlBOziFw0H0xx9VWODUeIH03FRo3QzoqOeJ7/QAmN4EtKM4Q?=
 =?us-ascii?Q?/FXN/jZoMoIE/TV7c8WYmgnO2HmKIBOJqEcCyT0DoPnFJPWUc8irnZBD9L8K?=
 =?us-ascii?Q?jpOehfw8iSyYAWeCjrTeKSpJ/GEssN1SURadXbB8VkIrHFO22qZ47bYMMjwe?=
 =?us-ascii?Q?JXBRTjizYrnuRMw2WhvlCrnfNwXdZEL3rQhdg2oflmbmsuI1/3aJWkB+5dbB?=
 =?us-ascii?Q?4Vksr+pXcUgu747SowRSzKx0meYdfq0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30da6618-a71c-480a-6ef8-08da2eb374b2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 16:22:32.2127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PqsayCMpuJlGpXQSHxOtGRxSDniuvts/ceNuDKMFvY4qnmC0GdwhpIpgHR6U0h0G5//I1R6acuYbK4gQfg/XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5522
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The felix driver is the only user of dsa_port_walk_mdbs(), and there
isn't even a good reason for it, considering that the host MDB entries
are already saved by the ocelot switch lib in the ocelot->multicast list.

Rewrite the multicast entry migration procedure around the
ocelot->multicast list so we can delete dsa_port_walk_mdbs().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 51 +++----------------------
 drivers/net/ethernet/mscc/ocelot.c | 61 ++++++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h          |  3 ++
 3 files changed, 69 insertions(+), 46 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4331714a45c5..e30fdde8d189 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -42,27 +42,6 @@ static struct net_device *felix_classify_db(struct dsa_db db)
 	}
 }
 
-static int felix_migrate_mdbs_to_npi_port(struct dsa_switch *ds, int port,
-					  const unsigned char *addr, u16 vid,
-					  struct dsa_db db)
-{
-	struct net_device *bridge_dev = felix_classify_db(db);
-	struct switchdev_obj_port_mdb mdb;
-	struct ocelot *ocelot = ds->priv;
-	int cpu = ocelot->num_phys_ports;
-	int err;
-
-	memset(&mdb, 0, sizeof(mdb));
-	ether_addr_copy(mdb.addr, addr);
-	mdb.vid = vid;
-
-	err = ocelot_port_mdb_del(ocelot, port, &mdb, bridge_dev);
-	if (err)
-		return err;
-
-	return ocelot_port_mdb_add(ocelot, cpu, &mdb, bridge_dev);
-}
-
 static void felix_migrate_pgid_bit(struct dsa_switch *ds, int from, int to,
 				   int pgid)
 {
@@ -100,28 +79,6 @@ felix_migrate_flood_to_tag_8021q_port(struct dsa_switch *ds, int port)
 	felix_migrate_pgid_bit(ds, ocelot->num_phys_ports, port, PGID_BC);
 }
 
-static int
-felix_migrate_mdbs_to_tag_8021q_port(struct dsa_switch *ds, int port,
-				     const unsigned char *addr, u16 vid,
-				     struct dsa_db db)
-{
-	struct net_device *bridge_dev = felix_classify_db(db);
-	struct switchdev_obj_port_mdb mdb;
-	struct ocelot *ocelot = ds->priv;
-	int cpu = ocelot->num_phys_ports;
-	int err;
-
-	memset(&mdb, 0, sizeof(mdb));
-	ether_addr_copy(mdb.addr, addr);
-	mdb.vid = vid;
-
-	err = ocelot_port_mdb_del(ocelot, cpu, &mdb, bridge_dev);
-	if (err)
-		return err;
-
-	return ocelot_port_mdb_add(ocelot, port, &mdb, bridge_dev);
-}
-
 /* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
  * the tagger can perform RX source port identification.
  */
@@ -455,7 +412,8 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 	if (err)
 		return err;
 
-	err = dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_tag_8021q_port);
+	err = ocelot_migrate_mdbs(ocelot, BIT(ocelot->num_phys_ports),
+				  BIT(cpu));
 	if (err)
 		goto out_tag_8021q_unregister;
 
@@ -478,7 +436,7 @@ static int felix_setup_tag_8021q(struct dsa_switch *ds, int cpu)
 
 out_migrate_flood:
 	felix_migrate_flood_to_npi_port(ds, cpu);
-	dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
+	ocelot_migrate_mdbs(ocelot, BIT(cpu), BIT(ocelot->num_phys_ports));
 out_tag_8021q_unregister:
 	dsa_tag_8021q_unregister(ds);
 	return err;
@@ -558,7 +516,8 @@ static int felix_setup_tag_npi(struct dsa_switch *ds, int cpu)
 	struct ocelot *ocelot = ds->priv;
 	int err;
 
-	err = dsa_port_walk_mdbs(ds, cpu, felix_migrate_mdbs_to_npi_port);
+	err = ocelot_migrate_mdbs(ocelot, BIT(cpu),
+				  BIT(ocelot->num_phys_ports));
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 880dee767d96..5f81938c58a9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2605,6 +2605,67 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 	}
 }
 
+static int ocelot_migrate_mc(struct ocelot *ocelot, struct ocelot_multicast *mc,
+			     unsigned long from_mask, unsigned long to_mask)
+{
+	unsigned char addr[ETH_ALEN];
+	struct ocelot_pgid *pgid;
+	u16 vid = mc->vid;
+
+	dev_dbg(ocelot->dev,
+		"Migrating multicast %pM vid %d from port mask 0x%lx to 0x%lx\n",
+		mc->addr, mc->vid, from_mask, to_mask);
+
+	/* First clean up the current port mask from hardware, because
+	 * we'll be modifying it.
+	 */
+	ocelot_pgid_free(ocelot, mc->pgid);
+	ocelot_encode_ports_to_mdb(addr, mc);
+	ocelot_mact_forget(ocelot, addr, vid);
+
+	mc->ports &= ~from_mask;
+	mc->ports |= to_mask;
+
+	pgid = ocelot_mdb_get_pgid(ocelot, mc);
+	if (IS_ERR(pgid)) {
+		dev_err(ocelot->dev,
+			"Cannot allocate PGID for mdb %pM vid %d\n",
+			mc->addr, mc->vid);
+		devm_kfree(ocelot->dev, mc);
+		return PTR_ERR(pgid);
+	}
+	mc->pgid = pgid;
+
+	ocelot_encode_ports_to_mdb(addr, mc);
+
+	if (mc->entry_type != ENTRYTYPE_MACv4 &&
+	    mc->entry_type != ENTRYTYPE_MACv6)
+		ocelot_write_rix(ocelot, pgid->ports, ANA_PGID_PGID,
+				 pgid->index);
+
+	return ocelot_mact_learn(ocelot, pgid->index, addr, vid,
+				 mc->entry_type);
+}
+
+int ocelot_migrate_mdbs(struct ocelot *ocelot, unsigned long from_mask,
+			unsigned long to_mask)
+{
+	struct ocelot_multicast *mc;
+	int err;
+
+	list_for_each_entry(mc, &ocelot->multicast, list) {
+		if (!(mc->ports & from_mask))
+			continue;
+
+		err = ocelot_migrate_mc(ocelot, mc, from_mask, to_mask);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ocelot_migrate_mdbs);
+
 /* Documentation for PORTID_VAL says:
  *     Logical port number for front port. If port is not a member of a LLAG,
  *     then PORTID must be set to the physical port number.
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 8d8d46778f7e..e88bcfe4b2cd 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -998,6 +998,9 @@ int ocelot_mact_learn_streamdata(struct ocelot *ocelot, int dst_idx,
 				 enum macaccess_entry_type type,
 				 int sfid, int ssid);
 
+int ocelot_migrate_mdbs(struct ocelot *ocelot, unsigned long from_mask,
+			unsigned long to_mask);
+
 int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
 			    struct ocelot_policer *pol);
 int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix);
-- 
2.25.1

