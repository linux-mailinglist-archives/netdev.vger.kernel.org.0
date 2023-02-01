Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7C6869E9
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbjBAPTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjBAPSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:18:48 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F93A6C124
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:18:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOqA5AvMs9Q9uxxCej8Sl315UufBw0eqlfWCod60pVae6+3Etbi8cUMArEgmBPKnxIUb0ULEdFLjfLH4j11DYsNt1ULoN9FEa/7yagcx0+LHh3aPEApDBEOEjxxDprMf4ldwDJUb7mljnlElMqE3pdfmA0OhjoRvsSwHs1tb4Xz+QhbS0MzcTWy9rTL9mZC2Zf5NsG+D9TuSH9oupJ8cRXcF3HCgeDCsKJCn7QGdXC2BLcLC9Q2sHz7xlbxCH2k21Wwyb4Tj88dNS1z0WIQLSfvCUPqP7crTpHkxpHzuvN1aynyW1IQbWLuPCmairNEaJzeoSse3fprt8AJq7KBAMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1yd0oBKT6lgZTv+MZdX1GHArWbgokhAifRcxvLBwls=;
 b=jXGw3wiIldHCIfIIjhca9b9YEx+IjSN8HtRYy82v67hjoLQ59xrZv4i32lZTWRSEtiRvqgeyuociYAw7CncIj/nXwemDhVlDSIMMohriWCwQAlreeCF4uO/2NoS34k4edAVSBPVtxGEvQOlpmvq8byEUYIQgu7pXZJLXmDYeZajItktQN379qEKtX+LuVclVmsUxgjKFJh7rY9FWdS6Po/4E9UzHg/Tb8eY+hZ4c/+aX++EdhvYFNjnznbYAVRO/FLkhLDF4ptUnCFPjf43GHME1owF8OEVZSRXVBcb/D57yJqueCcvF+VcFAn1Hx5U5qvImSLYUBmyMAswtDyLFPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1yd0oBKT6lgZTv+MZdX1GHArWbgokhAifRcxvLBwls=;
 b=cHPvPg7tOKmhtKA6ySl3B7tRleK0S9APbInc7wwkOQdkR9TFar7F2kbItJiAiG9Rk663GuwYvsUon8GmJmySACBJSOU54/hT6PD0HgfVm0t6bjxUcRTwINdvtK1AEJs40gqOvw0VmvVV8kl2K8mKpSrnr+h/YUtjK832af57sfU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4514.namprd13.prod.outlook.com (2603:10b6:208:1c3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Wed, 1 Feb
 2023 15:17:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 15:17:49 +0000
Date:   Wed, 1 Feb 2023 16:17:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH v4 net-next 15/15] net/sched: taprio: only calculate gate
 mask per TXQ for igc, stmmac and tsnep
Message-ID: <Y9qCl3TMGRmd5YXv@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-16-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-16-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P250CA0015.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4514:EE_
X-MS-Office365-Filtering-Correlation-Id: b7a16168-50cb-431d-f954-08db04677b1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUZBktGG+5z1kzMS8ZofwwmWgFdgNqYgrw9bx5SiywI2yyshdRNeLEpYYu9rWguLRaGoPhUyO8lmQkJW9CI0lLqq5k+4T0FvW6FZsPvKh9Q8DVEehGxC/l5htq4w9pTG19U1gzQ3SB091NNStVTOOnRu05EFzr575jww8+V6cM2gUh2KzntANt3JQhuKrbqNrTCRCQf4QMC9JzJnxy2OzbT3vRcy6fvHWwf7MSWXmJmLPLHG/73YqJ2K6YIrfPNFWgpvWAmG0qUWUYagnq5Gf8yXYfgdE7I+S/vBZhcIrx4HiX3m8uKUQQCxhfZAih6Icez1OObEGFGbeUKqbY/Jwfk2Qo+Q4IFxGXALdGGemII/Q7CGwo2F8uM6jgpzKX6/FRForJmzdqRTBOK5JkLeYfdXYeOjuLkKFQxV48HS9U+8tN5PlytJyuP6sp54/z1hkvQCmrDPavmP0JYKJ482uKT3gQRDL6gnKEl6OaFHPG4iFPfSw0AWMQKWq4JV8mdf/gUckurX5EFVkjm7t5O0WG03tGLFLQVrRSG0LOFTr72y2t4edaUpZk9V6DHq3VdiEwmGthrk9/4ZFR185Jf2t5usdKX0eln95GeF8MQUaXobcXLZ7slGTrv7hhj0oLpvYMe1ZKU5XLKXtw3nO8Wjxp/TZi/Sr0P/MWnxb5Y2//M1OFw98mF8sYxvUMQnV2OT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(366004)(396003)(136003)(376002)(346002)(451199018)(7416002)(2616005)(316002)(54906003)(5660300002)(4326008)(41300700001)(2906002)(8676002)(8936002)(66476007)(66556008)(478600001)(6486002)(66946007)(6512007)(6916009)(6666004)(6506007)(186003)(83380400001)(38100700002)(44832011)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BdBJ2LdmfYWYztOs0hr08p+GKmJJ9iLWqyyQG5d1qg4FcYmpYb2aA4hG/1Gk?=
 =?us-ascii?Q?j3dIy7LjoUBNO4dI7dYeJwxYLugIaDC31T5iGQeDhvJKe405rQIqqhu/Emww?=
 =?us-ascii?Q?7OW/kcHOVOM25q9Owb2AbB3tTSpI8rvnxAK9Z3IrWq39EQTWFqhgYGQL1u+l?=
 =?us-ascii?Q?nqGBH6JMz7S5KACx/DaIykMrfJO5O1ASuO/O2NODpBBp83HWosBCrhTi7J5P?=
 =?us-ascii?Q?jnytbPzJ3qkkbUUpKCYk+fldIYI31xiYjG12cX0Sm7xC/W+os50FRAblSEam?=
 =?us-ascii?Q?7dbo8l1WFVDJYLfTz4lqemMVZNXWUoU6hp3rB92ZIshm3MQC9J5xeBlYiugs?=
 =?us-ascii?Q?0LAOoX7cpiqvFzLvt42gi3Z+m6MhpaOulcvRJu6oOCuU/s5vABwEnRy66xwj?=
 =?us-ascii?Q?YGd2enc3FMKdCTo7iETK/+UzaCK8pjSI/rQVZH4qHv+rmOZLsBDGJdYUSAHZ?=
 =?us-ascii?Q?t82AhmMPmxp1iutEbJig9ZvzjvtvzOI1rGihJfUt3CeXCKxkWkohBm4FnvL4?=
 =?us-ascii?Q?+Y27zHrT9KI325LpS8bkicUTLL0NxsLZBfXUbmKPrNDFDDXXLYLKj6TIj+Xx?=
 =?us-ascii?Q?mjS5Km60buaH/bt628edUQ4rpQDy8IXKtabaKxMWkqPFli36CpJZwJOj248z?=
 =?us-ascii?Q?26D1NhqD8TeK8oEpjx2H3NnpR/EH25yzBSmA9cgJHbeOHYfjCVq0qDrlza/z?=
 =?us-ascii?Q?0WwObJt57D9ZwHRyn7uVVNApQA2jxWBOtV8vC+T1yebC56P7kACQ3g8DNYdr?=
 =?us-ascii?Q?7j3PB80mMsr7jAnaD/lBgVxP8FehkxOdlQhXEmZIrgIKlDib9+5FkisbtCS/?=
 =?us-ascii?Q?L0WDt1t35WsBQrlcsPgAUsyJWjkPyIVz5lNVArRI70WgHGifUYGFbpO3ateh?=
 =?us-ascii?Q?LYhpWyUWcYkgoD6JLgNWlboOTiiEu88ESp8EV0+GIWLCYuWi03Z8QnA0b9HU?=
 =?us-ascii?Q?IaIcPi5MtOQyxpbvH8tiInohdbymyR0b6ymMfdIxmGIlIVe5ZifV4qg7AOzh?=
 =?us-ascii?Q?vp17lwRvKGcTGqFHtgVMX0aCT+pebCdOObaZTonYH7cmPR9C6HGITzn3Iiwh?=
 =?us-ascii?Q?SGeUTBKrZE/1+rMhHfB+gsOoPDUsvBGq1lSeOXB9ea3llIXjl0uicj0CgFSM?=
 =?us-ascii?Q?nEL3ljnytARCWM74BJnJKay7/PoOpcwUixJSp+07Ahzrv0z+VkDXEfUhyRFo?=
 =?us-ascii?Q?rMwf3jtcSn0pIE2MEIxDM4U98iUJdGqjf/tE2+aqVJ0DtmkqXdsMXCh7jKaM?=
 =?us-ascii?Q?kojWsY883+ZIsBdncXcMkiqsUEEDhJ/HdtQEOClYb5VM1XrtW4d7zKA1ZIH+?=
 =?us-ascii?Q?fZvHgKlL3ujsnR92U/11vjuQUdN7Awp5m18iIgbULyn2o9n81DRTbqbcxT9o?=
 =?us-ascii?Q?HGTS5pZ8Y2ptovy2fppgFYVI78Isvo8SpNNQUpXVuH64KO1VRDVQWH4+FE44?=
 =?us-ascii?Q?5Y+pLuwv4L6ph/sUuJJ3YqcEbOf2UKV3UmiypQaR9ZVMeGhp5riGteX+26rJ?=
 =?us-ascii?Q?wqa7iVR/MM1FjvcnaYvaS6E0K3vPe0Xu463ZktST6TcLF07HXUP8TjBUuQOp?=
 =?us-ascii?Q?URwh2Mi33A4lEg65BDD36zrA2QHj/P8wDB3Hajpywguuz9jnZE9FSee/EHKU?=
 =?us-ascii?Q?aIWoWnNAyafp5lMdGXF3ReK029gESUjJPQaEBNsUTGP9eFTGumGcSc0NOyDy?=
 =?us-ascii?Q?DYIj+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a16168-50cb-431d-f954-08db04677b1a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 15:17:49.8283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmUlhm8tEgqgCNAP0OhBiJOTxfBJYgaU1IlK9zkBqOeNjEANtMxdiyVwAJ+ZSIxi07yz9us+TpwYKm6wLLDOV/M4jGY5Z3AstzMn/vPsB4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4514
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:45PM +0200, Vladimir Oltean wrote:
> There are 2 classes of in-tree drivers currently:
> 
> - those who act upon struct tc_taprio_sched_entry :: gate_mask as if it
>   holds a bit mask of TXQs
> 
> - those who act upon the gate_mask as if it holds a bit mask of TCs
> 
> When it comes to the standard, IEEE 802.1Q-2018 does say this in the
> second paragraph of section 8.6.8.4 Enhancements for scheduled traffic:
> 
> | A gate control list associated with each Port contains an ordered list
> | of gate operations. Each gate operation changes the transmission gate
> | state for the gate associated with each of the Port's traffic class
> | queues and allows associated control operations to be scheduled.
> 
> In typically obtuse language, it refers to a "traffic class queue"
> rather than a "traffic class" or a "queue". But careful reading of
> 802.1Q clarifies that "traffic class" and "queue" are in fact
> synonymous (see 8.6.6 Queuing frames):
> 
> | A queue in this context is not necessarily a single FIFO data structure.
> | A queue is a record of all frames of a given traffic class awaiting
> | transmission on a given Bridge Port. The structure of this record is not
> | specified.
> 
> i.o.w. their definition of "queue" isn't the Linux TX queue.
> 
> The gate_mask really is input into taprio via its UAPI as a mask of
> traffic classes, but taprio_sched_to_offload() converts it into a TXQ
> mask.
> 
> The breakdown of drivers which handle TC_SETUP_QDISC_TAPRIO is:
> 
> - hellcreek, felix, sja1105: these are DSA switches, it's not even very
>   clear what TXQs correspond to, other than purely software constructs.
>   Only the mqprio configuration with 8 TCs and 1 TXQ per TC makes sense.
>   So it's fine to convert these to a gate mask per TC.
> 
> - enetc: I have the hardware and can confirm that the gate mask is per
>   TC, and affects all TXQs (BD rings) configured for that priority.
> 
> - igc: in igc_save_qbv_schedule(), the gate_mask is clearly interpreted
>   to be per-TXQ.
> 
> - tsnep: Gerhard Engleder clarifies that even though this hardware
>   supports at most 1 TXQ per TC, the TXQ indices may be different from
>   the TC values themselves, and it is the TXQ indices that matter to
>   this hardware. So keep it per-TXQ as well.
> 
> - stmmac: I have a GMAC datasheet, and in the EST section it does
>   specify that the gate events are per TXQ rather than per TC.
> 
> - lan966x: again, this is a switch, and while not a DSA one, the way in
>   which it implements lan966x_mqprio_add() - by only allowing num_tc ==
>   NUM_PRIO_QUEUES (8) - makes it clear to me that TXQs are a purely
>   software construct here as well. They seem to map 1:1 with TCs.
> 
> - am65_cpsw: from looking at am65_cpsw_est_set_sched_cmds(), I get the
>   impression that the fetch_allow variable is treated like a prio_mask.
>   I haven't studied this driver's interpretation of the prio_tc_map, but
>   that definitely sounds closer to a per-TC gate mask rather than a
>   per-TXQ one.
> 
> Based on this breakdown, we have 6 drivers with a gate mask per TC and
> 3 with a gate mask per TXQ. So let's make the gate mask per TXQ the
> opt-in and the gate mask per TC the default.
> 
> Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
> query the device driver before calling the proper ndo_setup_tc(), and
> figure out if it expects one or the other format.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Cc: Siddharth Vadapalli <s-vadapalli@ti.com>
> Cc: Roger Quadros <rogerq@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
> Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

