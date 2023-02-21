Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160A269D7D5
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjBUBBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBUBBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:01:05 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFDD21A0E;
        Mon, 20 Feb 2023 17:00:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfZvDbtD+dieyCYZJ3HefHiNP68uhr/g2woK+9P6tD4IJHBzmbzqaRZp2iJ96cSR4bKMeJ7y+mbz7sbdp3PSic1j+Vfh4+MmlNuj1K6LLsneNAk2wi+i1XooFpf1+VuRI01aCZY4tpaRVXZcmAgNHcU0hNCSpyf/USPXFbW54FsxlRcDe2+RElHSe6Jy+AWE92/1cUSkdduxCIJz+eGgABHY7vj33sfUOdhXD3JQjwIITNsfnDAErJaH1Cx/opk4dKjBVrj0tAQaobs6QZ3Q+QlVknUmJJ4mhOupN/3ZYqKcuyXI+I6JNlGosJh2lakpwCqBqh84T4lRnjMWRzRzvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uxxOvQ4XCgBmkzOJ5HS4yhvn8Btd5+2FKT72e6iNyM=;
 b=n86Ml/jMiVw9gbyrrfmas3zA/et0zHhTNf7Ql7lwmOIX/Q8wHeILZwy2sBjquvnGae6ZDjDX8WxVJvcmjm1MVs9fmP9FSKKVNNcAiDlrs7p1ojLwIrIb5rpVA9Lfv+KV83b/vtSSGzjpO8EmjfYoe00BbZyazFqJ7sRWV7WDDbeS5lO9qEWxRktjrtudiJd2SygQv3X7AOjk5bjytAIrH6eyHEMXe9sz3aCI6YcWwaihshYw+fL4D7eQ+dzWhHTO6wQH3rgvL3Bd5TBCkl8lUY8tP1x+2GuMnwPWETWTC8vrnT/OOEwqEmMUmtnvCdkfi3SDtRLVMMpIA1si3Pe1+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uxxOvQ4XCgBmkzOJ5HS4yhvn8Btd5+2FKT72e6iNyM=;
 b=mrWUqZ2iMr5Kl/a3tWGE7qdOTWguVmYrMNRULFXez5u8WsizOBEQC/bSdt1dIn64qgeLqzFqbgSq+hxlidTFz3UFzqko/cOv4Btq98LYddkNMmNvutzoRtioia2iJ7a47oRW+WqehT7iY2P9QtI3B/XYXToUdsICfCripxj0x9U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9461.eurprd04.prod.outlook.com (2603:10a6:102:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Tue, 21 Feb
 2023 01:00:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 01:00:46 +0000
Date:   Tue, 21 Feb 2023 03:00:41 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/13] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
Message-ID: <20230221010041.aaw2kme22nlicb4l@skbuf>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
 <20230220165502.0aee6575@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220165502.0aee6575@kernel.org>
X-ClientProxiedBy: BE1P281CA0056.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB9461:EE_
X-MS-Office365-Filtering-Correlation-Id: 2edd4a42-37db-4c7a-7ba3-08db13a71085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ruc0kb+cGdwjOl5TO3PACprTsQ10CIumZi2tCDtfVt5rQngP9lXVNvykiF0TrI4kHfbLf5WrjvcnuilrN5g54GfyRFl6IymHMMsYHOKV71Eqh6VSfBY09jKdrC+J1U/vyhIKOS2Q37suYskRaARc7Ieyo/nvvol3IqpTWTLveHxNyqGnZNRJKVGYDZGGNLMz8swJMQZbDRj9UUBcxCGUSjkcqrndSTV0WTtMG94VtHiYmo1lAKRZvkLDiiSpC+Ds3HRAkt39/G58YxaxztEnAmGWCea2cW9RUihkWp1Q8eygTT5sRmdo1UGYrx3Ud1VV++qPIQhOlIMSXXTR22AJWCvAOuqL3gAyH6TGBNefAOhmSAWo70NQG7xXhjnY6lPGjT99VbGBaZPqZXDVi2zsgC/O+765vfbL/yiwQxOjEMlyfXaIzy7YSv+vtF8l3KPtPlvcPUarHApM9wC3IBwcFpPezDiplUEc2NWVakV1mU8GV0aX382er/xOV6joS08QYnGggvQdlXDmVN4Um2bGvbJDymstmBOEWs3Tn5zalzRlplpyeT5iGaAVKzmpNGtXdyXtv0Lg9bpo161MQw3yXizrVTJvpMVsuxPObqm5/1j+DpLaYOeDF42NdZrtZRM5od3fqt7nvnz0ARXAqYDYlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199018)(86362001)(44832011)(41300700001)(33716001)(7416002)(5660300002)(4744005)(2906002)(8936002)(38100700002)(83380400001)(478600001)(8676002)(66946007)(66476007)(6916009)(66556008)(54906003)(6486002)(186003)(9686003)(26005)(4326008)(316002)(6506007)(6666004)(6512007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cnEYwH/wvbOsv/8II17mw3r9o9EVZHi2zTAaC0SwO5G7LwSoBPV4QRByE+ms?=
 =?us-ascii?Q?Vy+UlBrFdpbr9xQszCBrvqYfacftRwi5Egd7mWkaKLqC90QZEVCwbaV0kvsX?=
 =?us-ascii?Q?9iQoleugDNEVvXSOCYuuX9/3u3CT+UCr0UbVEMW00TmNWn12ir8Vwx6yGEvB?=
 =?us-ascii?Q?e5SC8e93/XczF1BvdZWOlVvmBMsX2yTUdaAuTTfrZJVsQRio1sqC1TajZQxA?=
 =?us-ascii?Q?u7ZyQ97oK5TZVb3pKIBIu0rVmEUh9Thqg8fKOeuNXWKTx3oMkYsekARUHLAZ?=
 =?us-ascii?Q?y8QoueBLivSXt4SFDyAiK4Oe1NovHrgqzc0wNHSOrFX4zAD2q7ctSVYDsbec?=
 =?us-ascii?Q?69aRzpz73Zmjikt3C3qmMY9w5W0mQf5L6W7AJMFSc4beBqoX38cEA5D12Mdc?=
 =?us-ascii?Q?vcGQU3FzFPdOIbCTQc3+iHmXUiq9ciKWeSh/IDBLctwJGs4ObB5WOpksAgzc?=
 =?us-ascii?Q?A5qln/ujAxZHxuF1Y7H5V0l7LxQxZpCeb7HBX4oyrPR7tcrK50ZeRzygozou?=
 =?us-ascii?Q?qmW7g1BJCeQClSEmcZeSwcZ5LEA/jRQEh3pk2JnTcL7pjBqWg/j6vwyoCnfU?=
 =?us-ascii?Q?QGL3XR0PKC8Jza6FpHC6v8rgbbHrPV68C/yrsR0afZTlM02U6dSI+CyI8aSY?=
 =?us-ascii?Q?c57YfKvsDMRKSvfBRP0ypTjRK/qEd4GtX7/lgn2rk/B/6rkHG3BTMHDKfL3v?=
 =?us-ascii?Q?W0bGN2knHRlvo5+pgAdFSSTKlkK9gKrgAWbvPeu3F/7Xh2DUkc0m5xdVvl+j?=
 =?us-ascii?Q?NoJM8JNhnhPC8DAey0Qk9Hqyk+lRsMuFUlwaXEu/YKjT44cf7iqIswjfYwGH?=
 =?us-ascii?Q?uzy2NvACagpe+byi6rw33s15bZe5gVc/6ccqv1HzKNOA0x1jp3e+S4MOLIU4?=
 =?us-ascii?Q?GEzOSb1z9twKNFHYw6FtnChMkYbSxP0tNYAr7v5SN3csg7DO8jVTnADpvN0O?=
 =?us-ascii?Q?1rtTWuhbIwvfN4eSC5KMee7bkjJG054Q91Tu3b/xGm/vWEVn64l+fMdRY7qI?=
 =?us-ascii?Q?wa+mBZu/a9bQb+03ri9rGxVhvRC7XNoRFMPl0gbaXgGJMrvy0fF2IsEu6abQ?=
 =?us-ascii?Q?ePZUfwXNmoLqUgRPtooVbvWh7oJgwzhNTGeW+aMLTYIWCp9WD6h469Kcv3UC?=
 =?us-ascii?Q?72HVsSP+hT1DKND13k2Ckfrz6WA9+llAyDN9UYJZ7NEJr/ZgTjmaHIk7A8cS?=
 =?us-ascii?Q?sv3orOOZ44xHKnEysE1nGgL1hKmS6EGDIJgZzQOQA0ThfgHB3gZ0ONg201lT?=
 =?us-ascii?Q?6Lrwqiufff81y2c3TMpCyrMmFDcJ1dBc7u9M1IrlY0fBNYh6dHgBbl5fxqPp?=
 =?us-ascii?Q?gsX7SiAtiJgS2Ss2XMJtmYLmmsHG0C0i+4kHUQOxP/G708h5hbE7g6a0Mwzo?=
 =?us-ascii?Q?ph4C73rnlDqmEKJg63W0dViX4YOFNwo7zLAqyzgmpW4LY3DQScHZp0E8UO/I?=
 =?us-ascii?Q?4cJa2LqKAohJG7VWS4txJgw0GJLlZr+KQX1i8dLb42Bd9OGyiGYh1jKVA3mq?=
 =?us-ascii?Q?RPvASNFDH/VoAr87PK7Lhplk3Eoomm8lH6xv32IxMJV2xXpWqmi14rgwjF0z?=
 =?us-ascii?Q?pgjX7lSv8JGenYNfa84lp9ElLopvSbHJTNHs4iwm3ba6Y5+hv6qTx+/rsY9N?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2edd4a42-37db-4c7a-7ba3-08db13a71085
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 01:00:46.3831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KV+0Grqf4i4yYGcpSxF8/IkxB8ziq7uzWb5NM9RlMnbirRxj6F+0Xjwy49e4SYMbKLTX3XQfiExtlEKED+FYNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9461
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 04:55:02PM -0800, Jakub Kicinski wrote:
> On Mon, 20 Feb 2023 14:23:30 +0200 Vladimir Oltean wrote:
> > Some patches should have maybe belonged to separate series, leaving here
> > only patches 07/13 - 13/13, for ease of review. That may be true,
> > however due to a perceived lack of time to wait for the prerequisite
> > cleanup to be merged, here they are all together.
> 
> net-next is already closed, sorry :(

Can you take patch 1, or would I have to resend that separately to "net"
after $n days?
