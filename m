Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4132759CCFD
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbiHWALy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238942AbiHWALi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:11:38 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD2C5721D;
        Mon, 22 Aug 2022 17:11:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jw6tO82L/fjld0uXi3BvbyqdbUkiVIf5Vwpxcl20n6hVpZ69lcMCRIrvuVik8/1bZUclD9sMyAQfNvqGuEEHIr+Cxs9jvSSLq3Uv69L8NwAuMwExHh2Tg+eqeqsjKSm8MGU/1Ti+NVunm3c0Eitj78m1cqO3pj2rkIheUvHmbMvanX6DqzwrlcTjGumXBB7Oa6Xtlwbocz4OGgy4Gig+k5PFRGDCncFXwMjfc7T+5KefbBTxrXC296Fwvrar8xI3mkMaiK6Cr2K3cL4PaCT7ATVuF/8ooI+iG0GVobEOjot2E2/PjlWGLlVjXHk6UbRo4FA1A3U6TQnns8PP8BO0iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2d5Je96j8ZM8qDeI6GKKuMoaTi0HoRSzPkUWBd+i/D8=;
 b=S6v1ECjnQizyNnqeg60reIjOPm7w4fzuq8oR/AklykIsqYtHgRDx/z1kMoOQJh1p/0/MH5N4MMsuO7HBUngRVzy3usd5tOB+xc5fDCt/nej9wCLpt22FpBR0qmUcTYekue4ldM8pzHbedOxROUL3VsFcxZe4wDzXGJO3p00TpNxqErSgzDimmUgLM9e+qOwdaPwhMwITkLgoQmnGr/2Ie2aO6ddz5ZXfaxQh1rrInZJkc73YbMM1NujN2TuIHTSh2FNvj0Ab+DFFsUIepca9CTli02S56w5I+yb9R44STS9Mo+Rg6XKDEPRhGzGn3NqX6x6pDlAaZR84/Hnfbh8Oew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2d5Je96j8ZM8qDeI6GKKuMoaTi0HoRSzPkUWBd+i/D8=;
 b=UJWlDG6aZDVhhVWxzAS7tHaCKBrKVYv5Aca12G15ZRsUaS97IA46DoUN9e8KSVGOX92FcleClgprBZeq9ZJaMiq1yZCj5dVVW9YEN4oKS4UTcuo/wTmISl+sM8o6sf0tOaRnP1/LbMEGN/li18DcVMwHQ1rugXx+E3xj+mpTEUc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:31 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:31 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v3 4/9] net: marvell: prestera: add delayed wq and flush wq on deinit
Date:   Tue, 23 Aug 2022 03:10:42 +0300
Message-Id: <20220823001047.24784-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86168221-5f1b-464b-a2cf-08da849c07e5
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O//MOcosyiEvhcrXvsOHMvJI5UuxeGiul3zT2JcEHg6/QSD0a2Kqu0/UVshxR/+eoWxHL/I1nWzqJYjUOI/wNZc0E8kSEuLCCOdiuP7tJHVpDYGXA/cLtXbaiK3VpXOjA66IwBdSOCIau9UDMJQy7SZJUyqXSDzEytsfwuQYj6spiPE2AoSCcWvvjBWXjnKIkKzH1W+rkpte03x8s974wyNaZwIE7+lTVFrC+0I7TjuG3jA6kKXo1y818Zpcz0z+8Z+ZdRuaTlintPoFFmRGhoMpN5N58BVndepPoVjCoWx/4QviZMe/5hjjeXoC1PY8WjQKsvUoVjdE5YFOeoC4oHi2ZjE3meBJ/sde+MjnbWj8W6wWQgYd9vjT7XsylRQktzI++m9up8YDxPzI1L5HlXLsAkxZszCIkbI6vwYcTuZrNTiehCLzsMPxthI6SAlnfkXSSFZcnsuqrRolgwc4EfYj5kE5E/nPaIWh851h6qL8giObXIsqPyzDlXoi1NZlmPay/HdEWvzt9sdd5I3duncCSThXXBEr/WYUa3BDcnyThRwnqwiCyw7UThdebzEJNe/cL8Fys+8YvKYTOTOAzcvmm8sZjoi0TWMxWUcda/QyhVGzd75nxqPKlOnoT4vedzSlUv5ifX5lAPFmmBdD7D/vWzbrGo3A7/z/Tc3Xtj80JzZcl9FUofgwo5GO7ow2p0E9HFBFu92t+qtUL5tyNWfQHlXjFGob1WMs4h6z6NckuOjjcZ6WyM2a6M3xnLxC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(2906002)(8936002)(7416002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OgoVpPYOgah33lNhWbIaDkRanmNBhp3HbSYZlQeZEf6ZA3k1Fcyquqya3rUz?=
 =?us-ascii?Q?L8bmcIECDIsUik+PgmMgU4JIEWwaoHXNSTS7eItbwLwY+C91YotXxkhllfXh?=
 =?us-ascii?Q?qYqJaaUmLmDzpROkGQNCRVZ6SkhClTmFPku+Ix3HTpmYcIXzrAnuqgz4xtaC?=
 =?us-ascii?Q?NuNLJrkUXjqEfYfTGKPZv5Fw31y+zWleVX8WRzsu8d6hc2rOijmdwTHQxvsF?=
 =?us-ascii?Q?QOK4XMLO/cMhLqkSqPgJjMEvKD6FqktYI/c3sD9zY/gg900Z0YlC61q5OvVl?=
 =?us-ascii?Q?vlinpiZKhE5j06h+Hxei8F8EVsBZAb3K8uWjor1IZyVcKJcu3Nprv4E8zkAE?=
 =?us-ascii?Q?D6YIj5JMWJWT9oHgP5BlPm+rptQxQA68Dul8NF9c5lj43RlPkcg6C7tQMAjR?=
 =?us-ascii?Q?TwhNMya9I6tImbOzkjbsCbIxSDmVm0GOLr5TnOYWsulg5veNy3ncXMXH0yt2?=
 =?us-ascii?Q?40/nZg77kyq2D1co+TBR6Gk/8D3KcALNu4AW4Pib68ajesPnTuAKkcix+ThW?=
 =?us-ascii?Q?vzJ6sXK/ZBP3ZdZMuNebfFCHKX81DRXvF9T/GPsQemXqR5kWgaPPhzVBSSi1?=
 =?us-ascii?Q?dsT4H8WMgnoAS9WCAcSKbNRuoM8+L10AS9xS9FucU+IggCsuhzarj+wSi/HJ?=
 =?us-ascii?Q?h5/5VT2i0Cpz/9ihou05/d2UUgNepdBNMzBRwtM9SIUYNkSa/YZiQf2+CHl5?=
 =?us-ascii?Q?1JQHHmbToNIh5Q/bxKtNikO2G41QnUTiPkZG/xv8NVBIk9C5rG/EQLxLSmpF?=
 =?us-ascii?Q?REndh1kji1RlHy5stv6E0qUvXfsbBRQ/ARbj+Vhqr2uzZ6KvLb4w/jd8jC4C?=
 =?us-ascii?Q?ul7nGLUWKPhT6anfyzI0I9DOOLMRzSqNWQ6XMVOZG/h2S7eIXmkHiFgXVUqT?=
 =?us-ascii?Q?h2K73hPE83p97j8lXHw8cfsCcWleBj4ezMsz42jRIoLE4jyuielpHtgQovRP?=
 =?us-ascii?Q?w8KxMlJBazYyarkq2O+kEYeD+MQUhw4CpjEs9wq+WbJn1uqiIH+hNyDso9ku?=
 =?us-ascii?Q?cfhN/0YprRzbU6UYKpRJ7SIh3NPnxhsRoE9Zmu9+TZASHsQnGghAyzbatnTx?=
 =?us-ascii?Q?mWn7sUV9WQTxJ/nAEjfbyR+HKCQsop3S+rOIZOe1cSALv6TbkopxRz3jSIAT?=
 =?us-ascii?Q?BOIO77+4dnR5DObaqp+0w2D4rfXH3JR+ELQsJgR9bqDprgn/DEUW1QMEcEsL?=
 =?us-ascii?Q?vBqhCsmACD94pGRRtMQe7N+V+pD8EeX9sQxTiqNz3IwLq+DQSjafxhz2HED3?=
 =?us-ascii?Q?0Bn3bcsPkmfHY3I3nB9S6PtqoosRfrV2/5A7kSQqkzi5LzdFIaNYWbbDaAy6?=
 =?us-ascii?Q?bEneOpGsRlu56DcR56NgTRPv03MfGErwoswxjAXIao62GfqUL3dWg1C2VDdr?=
 =?us-ascii?Q?NyTweb93KKOEAXVOJuIoMPMl/60nK5VLDkFrJxsxvKi485RXHBV6w60aJT94?=
 =?us-ascii?Q?OtGCcMeiw2NgSMSKivSou0O5lSQ/NKkqRN41VlQFfBf5NXs9waQzkOdGNUNi?=
 =?us-ascii?Q?rybByMv4LDWGp7TBdGViFOxrAh9M0kC11eSPOys6n01IdOXYyMO6uMshpPHb?=
 =?us-ascii?Q?XdNVf5UXGcjpGWh1GfuQTDPJNDEOeie3Hs9YjGDmOnNpUECBMqkLOlbI3Sim?=
 =?us-ascii?Q?bw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 86168221-5f1b-464b-a2cf-08da849c07e5
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:31.0007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiUDLFozJyv3e190/j1VNf/gbMUvSKSrCXck0ZH3V9TskHmHXRSKk1dlt8CAIk/lFK3foLd14+57Q2izjSRqS4YgBXBUJQeNWpyvvtp2fVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flushing workqueues ensures, that no more pending works, related to just
unregistered or deinitialized notifiers. After that we can free memory.

Delayed wq will be used for neighbours in next patches.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera.h      |  2 ++
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 11 +++++++++++
 .../net/ethernet/marvell/prestera/prestera_router.c   |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 2994e0a6e5ec..a3a112f5c09e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -357,6 +357,8 @@ int prestera_port_cfg_mac_write(struct prestera_port *port,
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
 void prestera_queue_work(struct work_struct *work);
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay);
+void prestera_queue_drain(void);
 
 int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
 int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index ea5bd5069826..ad50b9618535 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -35,6 +35,17 @@ void prestera_queue_work(struct work_struct *work)
 	queue_work(prestera_owq, work);
 }
 
+void prestera_queue_delayed_work(struct delayed_work *work, unsigned long delay)
+{
+	queue_delayed_work(prestera_wq, work, delay);
+}
+
+void prestera_queue_drain(void)
+{
+	drain_workqueue(prestera_wq);
+	drain_workqueue(prestera_owq);
+}
+
 int prestera_port_learning_set(struct prestera_port *port, bool learn)
 {
 	return prestera_hw_port_learning_set(port, learn);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 41955c7f8323..db327ab4a072 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -643,6 +643,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 	unregister_fib_notifier(&init_net, &sw->router->fib_nb);
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	prestera_queue_drain();
 
 	prestera_k_arb_abort(sw);
 
-- 
2.17.1

