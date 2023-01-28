Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA9567F374
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbjA1BHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjA1BHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:07:54 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2089.outbound.protection.outlook.com [40.107.8.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B4F166E2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:07:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irBbu6sLKpG5QVspTIAe6CzzMRkLJa2p0MQqQz9937Sc2JwtpKtJ3nTehh7idG4YJExqmuuEayH9tdFcG4GFK80EyAoiwyI/MuwY+5YfzitN2Si8KK5od8Zy7hzlWvdxUUceqFFW6+2GP1lEl64sRaApBUDZoKuisfEnHuhXCyrRKpeVGqIql3Eph71sBD91+oyzls7yX0cuJz/flM8gAdIG8h+/u2JHUB2oGwRarzky0Sx6mHvSCnWixVFfAa04u5lyj/Cq4zHEn2kD2otQRZpA0n2DPcPHnxO+5Qmt4lk+PJK+ldVaSuzYJMgF944VSer4jVsCw08SNfGPCqgVKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lB282ZF35dPtzl8rAnikqfgG5chhRfPXBps0KsedEf8=;
 b=fKODh0e7hpv2rr8KwKH7u+fyu8v1ygDzae/nXAb+pwMv7sjPHiYAAlSDsBUNqyhfdR8NAVREHRyMGDpbFyoYm2ULe2hbeCQF3fUlXLgKosfFf5O0p4xQrbcKLT3NkuULul6/nYp4vILxrtTupuKccglwDgN9XKD3K6dp4QmDUSBkECOOW9CVq1z/lW+DaglWRmhI/b+89XiRresLN5bUe+EjR8iIYEDRaxValD7gv/VtIgrsNaEriuDzezLBR0TKCX+PD++hBUEzLvT0ppR+PnQLkAbtYtK8PChBVBw7rY4QagT0LJl2wwCD1pTS6kuqdzQPMlI9Or+RhwmGIWjJiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB282ZF35dPtzl8rAnikqfgG5chhRfPXBps0KsedEf8=;
 b=KetovmR3x06Exg/vQXe8/wOulaCXWZ7/AdiHpTDvp5/BF7L3yQjFXfbBGy1R4m/Oran4xZHNLbH6ud4iSZidyxdWwWZ5HO74BOY2hamvZZybqmw6IM8qVcCa/H3QhaPbM8rzS+CLt0FoZrVY+4iKaxpU+4vdS5sIyLy5hBpS/NE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 00/15] taprio fixprovements
Date:   Sat, 28 Jan 2023 03:07:04 +0200
Message-Id: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: e59005ca-6555-4d60-cdbb-08db00cc12b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PWHPzer4J63uq0ZrAQRfNx291SeiYvVH9uSoiC2nzaRnSrQFhtKVLcqkiXFWgF/nVpgD3rUg/zDkzcuCEvDytn3xZZ9lhUheLFP64TDdixr+MD8BB3Nowkl9NZ7gV/0Kz0zizlfECUB40bPkUZ+3ad9+mYQjqTbck0hVr0mVdQZEPq6yCzAJ1DF26XjMWXg/6Yf29LMY15NoYlAO9Aq+Z/yebcse3zn0c51C+irUolQHc6ystdQsToWhd6LQjoiDXl6s1vYzASjNUrcrYYa/XSQY8nNXlHYf1eHnR2mvLQfTxYsFwwJn6idvy5UqVaMIB4SthVeadv6b71mNF9scOMZUrQ7e0oGAh6WoM1nuefT1vtcFAs/MDsHAMUh0GLAgfDWqhNwHzTw1w+ObRlIZDtSR+zq5vtLylmn5GlQUu5LEjfj0DEYIqpqP0lUx6Kpyrm2JwJ/nnP/GwBOYm5GnUxgDssj9fmngB9jhLQhtLxWjcGXLSspnqKOjH+JG1uylgmxaQQocqRRhcFwkxBrg8gJWk7G55Ku2pRfjf8pEMdc7/qutvJzCjnsLJx+1J/0Wsj+YBuQXzjPIJb1E4nnErZXWVzOibDwOnWwmcTr3d3tvzIm+HgDZvKmGOdF6n8j+UjwUFPo3zPAjuoqH6Jy3GKg0xYyOsJd0eyLy0QhI/AiosOdlADV+ry2zTm+0rXT8QsGl2YRdlUeApZ2sYh4SAa8e8g81FFgk/7MMPGdFNQg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(966005)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8+upFFGfQd8vqWgBCwQPt/RMbmw0MUEwrAk6fMLjBfv2C7aGht1B8P3BRzrB?=
 =?us-ascii?Q?ogRsRFbgXZGCodYWfDa32G8nNeuKhA+fKnm4G0dVb+/xIsO+2BbAeFsetmZ1?=
 =?us-ascii?Q?SdS0fHj4jPxlCkcR/X8kFvi+2QPg5qxOex8v2VNcdBFlbL0xeDLoATU05cqU?=
 =?us-ascii?Q?4wYM6XE9KNqywOkAsNSrOoYvxA8C4GJkaKhAHyKkPcrpnpZfNKHYysH4OLTJ?=
 =?us-ascii?Q?dn8V1itZGqW2mWXA1/m9I5AAdRfwYvVqFuYlxefmoJgQ/Sa44KdeGBjUYWsC?=
 =?us-ascii?Q?IsqLYBe+EaL+jWjjq/9y6DEdyYER3yhirKFfaiSbIbyuf5u9NKzw30eSHwaJ?=
 =?us-ascii?Q?BTuGM8LeUt9czgHH/YgKsTmEPTQMexJR6fnbhJkexq86JsG3GZYGr8I38UHf?=
 =?us-ascii?Q?8efayyjEsnOriZHuqwkk8jKBdRI3NwRYwoenbnwLd9hMbbPrCrzmsYKRpG6k?=
 =?us-ascii?Q?nAvWgXz5uRlJZtJo8TrSrkPx/2uyOkiLNoUozZxLQJyf2dHoBGtllPn3pzu5?=
 =?us-ascii?Q?nCTVsVna04PU5LRjcqXe5emBAQhy2D1YKz2H3Rf+hBYwo63s+Lu80rvdx3G6?=
 =?us-ascii?Q?Tpaiq5d0LYZfeG5jzWtAaKWog2CaSsF60k0Q0qsx4q9BJmFUs6i325e7RN3L?=
 =?us-ascii?Q?8OV4JI/MMokyzeMnNeFQPzgY3L2h3xmGPxObmNPqL2sNikLtxUmzUjS5y7Yw?=
 =?us-ascii?Q?YgfJZifDFPueqexmwjgaCglW+1CUfkS+Rs+irA0MZ0sxHGFYsTwcl7OYb+Pj?=
 =?us-ascii?Q?GjNoTIG7gTPWfjOgGIzRdRWaS+cHZUNKS5soaTiNA/eOG2QDIh9vdncXHpIU?=
 =?us-ascii?Q?q7i5SJUWykKwSQQtuoTRnprjMrs8nc/osrXQOqJuItY//cFTfaKuTuwGDR8o?=
 =?us-ascii?Q?XZuF9f98ywMozeM8GGT0EZkGweWHZDagtNCoVZfXhjKP9a3zMWV5y4vvPW7r?=
 =?us-ascii?Q?uiBZflt7IrA0VZPX53ho2SjDDfMoi3rZjeoxIzx9bPy3nYryl4xgw29ma9jh?=
 =?us-ascii?Q?X87XIuzLr4Yto2i/lbMTh6R7pzDOKwGny6ANKggtyYnRlysI0TUBXr/slIub?=
 =?us-ascii?Q?milJaU3hYd7bR9Bff9+i9b57pferv7qc9BWzV8CoawqcHVvMPR41iLN77TOG?=
 =?us-ascii?Q?L6Olhm30bkZ0WhBkmSzXZBNojP9Jz7GD0u7j58duvU6qURmgqgSDI01osn7n?=
 =?us-ascii?Q?7wxVs8bUUWXItnOKkfMV1b1Up9GC9zHrYJEt7zIvbhXc5se3l7FVS7fjcJWC?=
 =?us-ascii?Q?y6j1eoNTw0b5vP73sJtcfyNegBIOjI+57daHOoorWHtzIMCfRGTDFedPP5h3?=
 =?us-ascii?Q?sR8Hcay1sVehdEwJuiHEDJAb7zaoxL9Afetp1bU8q80Ec/j8hQJZJKehHh8s?=
 =?us-ascii?Q?ux2ggnzM9vopqBeM8zAS2ENY8e7aipK7CBXqzxQoyqQ1N5ZzlaND2F3WXcyi?=
 =?us-ascii?Q?sW9VgfK0CeLy0sKVe1MWDvkCbfyC7e4TY8ZGhp9CcuCKQnDhMdmWAoYXIZQE?=
 =?us-ascii?Q?0xfq5e72JBdWGmP86U27oD2vkfzRfKCs5mmV/SKZfTubaSsdy5owasu2My9X?=
 =?us-ascii?Q?/BUVzO1oq/gaBTvDfFtkFaJ9S4otSvIDILla+2KafwK37lEzqt1sOJic7Anz?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e59005ca-6555-4d60-cdbb-08db00cc12b7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:49.2296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9i7j4sx74PMd4erSdXtwaMB7mdy5J9mYYbLWM9CCSf0NXXv+nYn1tEnzN5CNnYOQqdLYWkTvlju2II0kgrN/Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I started to pull on a small thread and the whole thing unraveled :(

While trying to ignite a more serious discussion about how the i225/i226
hardware prioritization model seems to have affected the generic taprio
software implementation (patch 05/15), I noticed 2 things:
- taprio_peek() is dead code (patch 01/15)
- taprio has a ridiculously low iperf3 performance when all gates are
  open and it behave as a work-conserving qdisc. Patches 06/15 -> 09/15
  and 13/15 -> 15/15 collectively work to address some of that.

I had to put a hard stop for today (and at the patch limit of 15), but
now that taprio calculates the durations of contiguously open TC gates,
part 2 would be the communication of this information to offloading
drivers via ndo_setup_tc(), and the deletion of duplicated logic from
vsc9959_tas_guard_bands_update(). But that's for another day - I'm not
quite sure how that's going to work out. The gate durations change at
each link speed change, and this might mean that reoffloading is
necessary.

Another huge issue I'm seeing at small intervals with software
scheduling is simply the amount of RCU stalls. I can't get Kurt's
schedule from commit 497cc00224cf ("taprio: Handle short intervals
and large packets") to work reliably on my system even without these
patches. Eventually the system dies unless I increase the entry
intervals from the posted 500 us - my CPUs just don't do much of
anything else. Maybe someone has any idea what to do.

Almost forgot to mention, this patch set only applies on top of another
one:
https://patchwork.kernel.org/project/netdevbpf/cover/20230127001516.592984-1-vladimir.oltean@nxp.com/

Vladimir Oltean (15):
  net/sched: taprio: delete peek() implementation
  net/sched: taprio: continue with other TXQs if one dequeue() failed
  net/sched: taprio: refactor one skb dequeue from TXQ to separate
    function
  net/sched: taprio: avoid calling child->ops->dequeue(child) twice
  net/sched: taprio: give higher priority to higher TCs in software
    dequeue mode
  net/sched: taprio: calculate tc gate durations
  net/sched: taprio: rename close_time to end_time
  net/sched: taprio: calculate budgets per traffic class
  net/sched: taprio: calculate guard band against actual TC gate close
    time
  net/sched: make stab available before ops->init() call
  net/sched: taprio: warn about missing size table
  net/sched: keep the max_frm_len information inside struct
    sched_gate_list
  net/sched: taprio: automatically calculate queueMaxSDU based on TC
    gate durations
  net/sched: taprio: split segmentation logic from qdisc_enqueue()
  net/sched: taprio: don't segment unnecessarily

 net/sched/sch_api.c    |  29 +--
 net/sched/sch_taprio.c | 548 ++++++++++++++++++++++++++++-------------
 2 files changed, 383 insertions(+), 194 deletions(-)

-- 
2.34.1

