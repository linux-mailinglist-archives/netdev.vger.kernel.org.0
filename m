Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBA95F4B93
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 00:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJDWB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 18:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiJDWB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 18:01:26 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00059.outbound.protection.outlook.com [40.107.0.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C03F5A168;
        Tue,  4 Oct 2022 15:01:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUapRVjaqrqixRVNCTO/JfH+P6RuLkYDfvyYZoXLvAPe84Nau3gSHE2i1WnvRtkosjGm5pkciqUmbROWpDQ4QX/2Q8YV6EKewTAzQn+hcBBIrDbzGFZJoF1kResODKGLmMF6NNkN6ULyDWTVyyT5Ln1Unh278heBzg54t4pGhvg+7A2wazC9KGHmLJu2WGXQQPQ4BHEajCYJK5anSHpgr2nAsZxKdHDQluCBqSMFxLvBvPkSP/2yoBQ5VRnT5wAm4FylsNHaYh6kuJHTSMhlQxnNfJ+wMrLQWYM7LPvE7OHh5VJH/c3z6myf80dMBR5d+nKLw6qq/+u5sZ7NAhuIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nX2G1Qyvwu2mGidPFvtMKiT7PjLQXdS+wiuHTdY5Cr4=;
 b=VaxK1zLlN4TMebuHUgZfsjaOaAIpPVioZWicZya+gQYlBhr6TgWHhPHa7lo/CnkDLQj3t09K+vNyXHlOc86YulGaKS5xrdYy++I0bAyoMuK+lc6EcVTkW/oLue0ENOcpNQhWXEGJW/g061QIs5PFpFRvCvLfmhUwnR5n6Un6oetKsSFI2R8Rtq1FID0pmii0eBJCQ7RA81o7OOSbMScbcVxuu/rTSyw+VsI+jDiOFdCkg7aFuIxPg4wxaeOAsePUCiVZ82//FdD+DrLZv70uw+e5lOgB5V+GqviAhEfQkB8a+FGK+l4NxuBsabow5nTcqTFmvlIbfu18buBTaOo3ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nX2G1Qyvwu2mGidPFvtMKiT7PjLQXdS+wiuHTdY5Cr4=;
 b=XHcfpy8PHjAlpy7y24Ik7sPvMHg9VbkgZJeedmirmG9VWkMJpJpTm2nZxInNrVjB3dAwUJLoaaMBwP2n2CzEdcRHn+zdpdkitfuOdiYS3/YrpJM1KvNOBI3171ZrA5I7bLlM+y4ycfvrPESk+/SV1dHqPjGimF2X7Rgtp1DIZP4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9638.eurprd04.prod.outlook.com (2603:10a6:102:273::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Tue, 4 Oct
 2022 22:01:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 22:01:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: [PATCH net] Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"
Date:   Wed,  5 Oct 2022 01:01:00 +0300
Message-Id: <20221004220100.1650558-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB9638:EE_
X-MS-Office365-Filtering-Correlation-Id: 445c5de5-c20e-4a82-aa91-08daa653f49b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFDCUb4MfBcmkEl/cqe36RBTALMexKa4LIhE/u0sARx8ykmRpPdye/xIFc/hanlXFsNnhQciivTp8NbuSHAdpa2AcFWJfZzlIOS49uLp64q0QlMC4qO+yZyufsHmYPqT2sIEr/0JBikGOjAL9FGLlbyZNf/1IfxV26J+bHVPzS3LFQzHi8ftxAifWIcNuG+7FWRK7dNVe/eIR38qwgF9bMIFGuBbAlS3ABTJpITubK4GuxEXE8vqUY1Hn4dKyXBm8eiYXw11F/9AnzVl+85COidl9bEK1SQEQ18FmYo//2RKiIBKCi/dxvsDlhuVYh7r7WccKU2Tvpw+r0QzEe/DuR57kz8ll0E43KmIblovAPxhQM/qHz+nkUjMs3xaYWiBvF3WZUEoOsH+yzNgxNvGFHNDJTh9HUOxibGC7AyL89lAmWEXAPrYNjZE6xak3es5JvA9Jnt+/bbwTYqhOBdIOPRjkZ2PzTeCusem9E1HwQ/lb7B4S57vRWZBOwEPJ2iXVtk90tVUvMZf2AnCBc909DnC+M7bzlKXy71ba+NO+OlKYT108hKLbV4iyLolzH3ekEtVuOUrpwPzuf9N9Ol5ANBt7Kk95iqG3bpEWYUYlPl925lFM+HinRaa3CDtKPCdy0fBcFjsDUUPxVJn5TxmhGM3sCYAHuqU07uoj+zUEpBnjT1DfDzRsrb8Cv3Az1rxmwidX6JUYO+d/sVWUvqC6xQY0I4egdq1mU7kN8ES/UMx2GLNgOaxKocyTi0roreyx9567XsVVBoCplOy2ixOaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(26005)(52116002)(6506007)(6666004)(38100700002)(38350700002)(6512007)(2616005)(1076003)(478600001)(186003)(54906003)(2906002)(5660300002)(41300700001)(86362001)(7416002)(4326008)(316002)(44832011)(8936002)(6916009)(6486002)(66946007)(36756003)(8676002)(66476007)(66556008)(66899015)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dwpLGUPnIvXxPWls9RDD6jczk4Xfpozb69F4whYZbau270cjrjvX2HL2V3rS?=
 =?us-ascii?Q?sDkM6b2xoJu5buonsWB2YWzwTueuEXXlqGGstQb8dEcY+s+DkM1Zux7n1dNG?=
 =?us-ascii?Q?7QpUzoxwScFMJdwk/edQR+8hulwOGjMMGocasINJR2PesJmZz8hfmHi9Njnh?=
 =?us-ascii?Q?WKzpruIfaIjrsju82g3XJ3W8OtxLKSS2JvAH5O2fV2+sxfxydrZu0l0ulW83?=
 =?us-ascii?Q?z59d/Lw9Skfy1FIh3ojyAPJsOzETx4jqFOGM/iaCAedaC26vpsY26Ma7JqUl?=
 =?us-ascii?Q?QImESRWC1wXMJPJenIDoAcK5MSCGQ/qFEbSlNOqiBDnmLqnp15DfkAdU0rSJ?=
 =?us-ascii?Q?6issja3WOctfqXk9m6uePQWvuXiS7W98VD75gow3RTUuvEr7XvwHz3X6IGNn?=
 =?us-ascii?Q?avAiX2zVRdROmUIbSFNpfwdNwAQf1m0T7MoiVE1lmX9OTifggOXxQLxCx8L9?=
 =?us-ascii?Q?p3SzF6G9g9ojdrY0TnAkvZRz4qN4YOlY71FGdmQyhbnG041rqkhTp3BD2AR2?=
 =?us-ascii?Q?rgOTn/9bmFmVPCZQmJjaoiPTf4nPDlZlTkSI+9MWCPzCQ7vIg12fbnpFAa9m?=
 =?us-ascii?Q?bbl60k6DtWxMdgzIKIeF33tkE7nYBlioYFabD3xJV13U4vgv83AK29Dd3ele?=
 =?us-ascii?Q?fLlLIXobRF2nwn5mzcjxKwo7qWSCR+WD1VCCDp+I6mtATUCZ9SeF2lDI8NP/?=
 =?us-ascii?Q?7+eX96WqgGOzhZDeT9+yZdr1cpo04DTujPP+jiQ/PRhNrbPCDTH5feljzUEX?=
 =?us-ascii?Q?QCmJ8b7QD/0pm/3mv6id7IiqtCdzdRezDiOjuKdXjzwIF6t6w/KI3QvnrgOm?=
 =?us-ascii?Q?U/xqWY2hPQm2aHROtIFc2VhB4kY2HH+Xb5PxphC3TRGKW7SFWFnRT5Jnca8w?=
 =?us-ascii?Q?jnmAAREwxRRP3qBxAJtq74hR1We9QWwux8+jltLXPH5fKQBJXzvgR5oTHAkh?=
 =?us-ascii?Q?G8ZeJY+nhphQ13zq2CkPAXDWB7C0aUlMIrmjs/N6UX6yZ+C8VlfNMExHktyR?=
 =?us-ascii?Q?lw2N3I0PsG5gOUVn/5/E3MwMMWlDQI3ALTcWtD6gD8KJoB+kgc8sZUotCpYh?=
 =?us-ascii?Q?t8a4zU9ABCZ+wqkhSkmJUFhyf7eiBI2tjzzL5kyueWpG/jeyVS/uA0UnHWI7?=
 =?us-ascii?Q?4v+mtwEtcvBMKxTHZ1PCnnj+pGjVF4qjSZywMUad5sEHYScW5Fpz6RWakGRq?=
 =?us-ascii?Q?p9SD/l1I8PTRoC7OAvcBXm3pHTS/jufmz3cGHz4o/K9fRH9MENPL+4rE8O2E?=
 =?us-ascii?Q?LESVE1duBlAfYLc83fdadqsxG86K1mImetxe7k7Bwp06DSultkLs6swRq00m?=
 =?us-ascii?Q?f2nmSHFKgciYBLh92ip8ZcQRNH+E0bZ/imsXrAiOvBThNuOSBfOFMGUMHHRX?=
 =?us-ascii?Q?i7VIlq9P76NATMYD5EOEzrKRu5J10HnEVb8DQezS7bjdaNRODGNy+/NgV3J9?=
 =?us-ascii?Q?280dHOyU6XGoQZ7WUfBf3q4lO+3Vq+PnuLHWfv6swlS/lXTIVYjSlgPOuXxp?=
 =?us-ascii?Q?L3Ntl1JKyr/lWul4J62R1Sc3A9sclGtX/SFbmFxp6x2FXXQ/F5DJfgyi+4Yy?=
 =?us-ascii?Q?vlyVs7MXrzJhKdvrfLq27lHqiAA/dq/r5FDEZR13Y8CerEcxzDPeKbZOaY3v?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445c5de5-c20e-4a82-aa91-08daa653f49b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 22:01:14.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jj/MUjXzT/6US0MS8iqVFfStvkXG7QNvihusFyL1NldwApJvmVeftpgcdLZVSCRSz3eAwPa1Crx9IItl4gD3aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9638
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio_attach() has this logic at the end, which should have been
removed with the blamed patch (which is now being reverted):

	/* access to the child qdiscs is not needed in offload mode */
	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
		kfree(q->qdiscs);
		q->qdiscs = NULL;
	}

because otherwise, we make use of q->qdiscs[] even after this array was
deallocated, namely in taprio_leaf(). Therefore, whenever one would try
to attach a valid child qdisc to a fully offloaded taprio root, one
would immediately dereference a NULL pointer.

$ tc qdisc replace dev eno0 handle 8001: parent root taprio \
	num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	max-sdu 0 0 0 0 0 200 0 0 \
	base-time 200 \
	sched-entry S 80 20000 \
	sched-entry S a0 20000 \
	sched-entry S 5f 60000 \
	flags 2
$ max_frame_size=1500
$ data_rate_kbps=20000
$ port_transmit_rate_kbps=1000000
$ idleslope=$data_rate_kbps
$ sendslope=$(($idleslope - $port_transmit_rate_kbps))
$ locredit=$(($max_frame_size * $sendslope / $port_transmit_rate_kbps))
$ hicredit=$(($max_frame_size * $idleslope / $port_transmit_rate_kbps))
$ tc qdisc replace dev eno0 parent 8001:7 cbs \
	idleslope $idleslope \
	sendslope $sendslope \
	hicredit $hicredit \
	locredit $locredit \
	offload 0

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000030
pc : taprio_leaf+0x28/0x40
lr : qdisc_leaf+0x3c/0x60
Call trace:
 taprio_leaf+0x28/0x40
 tc_modify_qdisc+0xf0/0x72c
 rtnetlink_rcv_msg+0x12c/0x390
 netlink_rcv_skb+0x5c/0x130
 rtnetlink_rcv+0x1c/0x2c

The solution is not as obvious as the problem. The code which deallocates
q->qdiscs[] is in fact copied and pasted from mqprio, which also
deallocates the array in mqprio_attach() and never uses it afterwards.

Therefore, the identical cleanup logic of priv->qdiscs[] that
mqprio_destroy() has is deceptive because it will never take place at
qdisc_destroy() time, but just at raw ops->destroy() time (otherwise
said, priv->qdiscs[] do not last for the entire lifetime of the mqprio
root), but rather, this is just the twisted way in which the Qdisc API
understands error path cleanup should be done (Qdisc_ops :: destroy() is
called even when Qdisc_ops :: init() never succeeded).

Side note, in fact this is also what the comment in mqprio_init() says:

	/* pre-allocate qdisc, attachment can't fail */

Or reworded, mqprio's priv->qdiscs[] scheme is only meant to serve as
data passing between Qdisc_ops :: init() and Qdisc_ops :: attach().

[ this comment was also copied and pasted into the initial taprio
  commit, even though taprio_attach() came way later ]

The problem is that taprio also makes extensive use of the q->qdiscs[]
array in the software fast path (taprio_enqueue() and taprio_dequeue()),
but it does not keep a reference of its own on q->qdiscs[i] (you'd think
that since it creates these Qdiscs, it holds the reference, but nope,
this is not completely true).

To understand the difference between taprio_destroy() and mqprio_destroy()
one must look before commit 13511704f8d7 ("net: taprio offload: enforce
qdisc to netdev queue mapping"), because that just muddied the waters.

In the "original" taprio design, taprio always attached itself (the root
Qdisc) to all netdev TX queues, so that dev_qdisc_enqueue() would go
through taprio_enqueue().

It also called qdisc_refcount_inc() on itself for as many times as there
were netdev TX queues, in order to counter-balance what tc_get_qdisc()
does when destroying a Qdisc (simplified for brevity below):

	if (n->nlmsg_type == RTM_DELQDISC)
		err = qdisc_graft(dev, parent=NULL, new=NULL, q, extack);

qdisc_graft(where "new" is NULL so this deletes the Qdisc):

	for (i = 0; i < num_q; i++) {
		struct netdev_queue *dev_queue;

		dev_queue = netdev_get_tx_queue(dev, i);

		old = dev_graft_qdisc(dev_queue, new);
		if (new && i > 0)
			qdisc_refcount_inc(new);

		qdisc_put(old);
		~~~~~~~~~~~~~~
		this decrements taprio's refcount once for each TX queue
	}

	notify_and_destroy(net, skb, n, classid,
			   rtnl_dereference(dev->qdisc), new);
			   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			   and this finally decrements it to zero,
			   making qdisc_put() call qdisc_destroy()

The q->qdiscs[] created using qdisc_create_dflt() (or their
replacements, if taprio_graft() was ever to get called) were then
privately freed by taprio_destroy().

This is still what is happening after commit 13511704f8d7 ("net: taprio
offload: enforce qdisc to netdev queue mapping"), but only for software
mode.

In full offload mode, the per-txq "qdisc_put(old)" calls from
qdisc_graft() now deallocate the child Qdiscs rather than decrement
taprio's refcount. So when notify_and_destroy(taprio) finally calls
taprio_destroy(), the difference is that the child Qdiscs were already
deallocated.

And this is exactly why the taprio_attach() comment "access to the child
qdiscs is not needed in offload mode" is deceptive too. Not only the
q->qdiscs[] array is not needed, but it is also necessary to get rid of
it as soon as possible, because otherwise, we will also call qdisc_put()
on the child Qdiscs in qdisc_destroy() -> taprio_destroy(), and this
will cause a nasty use-after-free/refcount-saturate/whatever.

In short, the problem is that since the blamed commit, taprio_leaf()
needs q->qdiscs[] to not be freed by taprio_attach(), while qdisc_destroy()
-> taprio_destroy() does need q->qdiscs[] to be freed by taprio_attach()
for full offload. Fixing one problem triggers the other.

All of this can be solved by making taprio keep its q->qdiscs[i] with a
refcount elevated at 2 (in offloaded mode where they are attached to the
netdev TX queues), both in taprio_attach() and in taprio_graft(). The
generic qdisc_graft() would just decrement the child qdiscs' refcounts
to 1, and taprio_destroy() would give them the final coup de grace.

However the rabbit hole of changes is getting quite deep, and the
complexity increases. The blamed commit was supposed to be a bug fix in
the first place, and the bug it addressed is not so significant so as to
justify further rework in stable trees. So I'd rather just revert it.
I don't know enough about multi-queue Qdisc design to make a proper
judgement right now regarding what is/isn't idiomatic use of Qdisc
concepts in taprio. I will try to study the problem more and come with a
different solution in net-next.

Fixes: 1461d212ab27 ("net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs")
Reported-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Reported-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 435d866fcfa0..570389f6cdd7 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -2043,14 +2043,12 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	unsigned int ntx = cl - 1;
+	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
 
-	if (ntx >= dev->num_tx_queues)
+	if (!dev_queue)
 		return NULL;
 
-	return q->qdiscs[ntx];
+	return dev_queue->qdisc_sleeping;
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
-- 
2.34.1

