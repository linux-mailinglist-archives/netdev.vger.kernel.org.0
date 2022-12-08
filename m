Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7186472DF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiLHP1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLHP1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:27:35 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2064.outbound.protection.outlook.com [40.107.105.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3456140F7
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:27:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDccsm381DY6QLVycT/rdcKSYI2fPApQL4E9Sd2rcAN9FaDCyiMFsYWRf5LrxmWAqxc2LrefhX0HNYTNslYzVFxZO/GfOWQN0uQS2CWYaORt58i7iNezU8FTJFwxkSr7WvhL+y0rdK5MejVzsJpBZN4QPiPttJYSfsfOr/COsgBNNCBju3FYgld0BzOSWjmaF0R/UOUv0bx69Egj5olc6XLNSBCc4TB2sa+zX8D7ZmJ7VrdOuprJAXEKbNt9jT8JiEIsA55MdbwBUFrlF9zwaKAyhpHrtlFJ7pozek86OEHgJPd65yzQbT8Ni85d7M9wVoxySTmXbhrfNKiulnmvaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HhTEfLHOkUv3WuwbmEwIES028Vmg5ICvv5v1ScHYFk=;
 b=YnVF5kNMyKgUiIJnvLjbd80Lw9psvbvKBclXSZNVef86ck06+2RgMwvpKLU3ARc06Wd6Dpi+Ed5ie4ElHafhhIlVczvGEakt2BZfLN68zgTksWzwnhvoSX6sCTk/fIvuH2X8uV67rgKbHbrCK+TrwyXOPwTZrdiVyM7EG3CAEhGnd9FRtFrJL6klL1FB183/2kwJesd1udKg5Luezf+d5E1GbvOKzXM0ddN8fmIQDbWGeLKhpqBcawF6MFrdJp6R+FEiRk4d1DVsl5vSHbVeSWseql17ygMa2iPZJ2QLP0e9IHeLPN+4JlV41sJDGwjnO7VbnuQzXc9bobPDn6kHfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5HhTEfLHOkUv3WuwbmEwIES028Vmg5ICvv5v1ScHYFk=;
 b=K9Ump5on6LA/SrpcDNLSEUe3b1LGAOvOfziZYLtmWF+G9cbDFV124pw1W5feIYg5DYqdVHplL556K77A1YD5Te2oIR/mF1BMq+Va5dh674Zw9yCznPP+wkdIg6ZpnuN4TOsExQIXDRxv0qbdl78XwQCy6fDlZrZyVZ4Rjqf5r+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8096.eurprd04.prod.outlook.com (2603:10a6:102:1c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Thu, 8 Dec
 2022 15:27:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:27:29 +0000
Date:   Thu, 8 Dec 2022 17:27:25 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@kapio-technology.com
Cc:     Saeed Mahameed <saeed@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: replace ATU violation
 prints with trace points
Message-ID: <20221208152725.g4scosm5klsn5fqf@skbuf>
References: <20221207233954.3619276-1-vladimir.oltean@nxp.com>
 <20221207233954.3619276-3-vladimir.oltean@nxp.com>
 <Y5EsWNfVQrl8Nb71@x130>
 <20221208144901.tgdhp73n7g5uh7qj@skbuf>
 <1bf9be8b0877a0536b73ceaa957f6234@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bf9be8b0877a0536b73ceaa957f6234@kapio-technology.com>
X-ClientProxiedBy: AM0PR02CA0113.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: 88e50e26-f29f-4da2-11fd-08dad930b7f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TcJwp8PVkrHNx+7r8RYfjc1PsIqT2OZ1gQkXOIoLiZMpOZz1UvEw2iRORw7Dh4TKPpSxt9YfQJ8jieynO9SGOLyCulYX0qaLtl++c51kRPZIk5NKlS6f0DX34Ej6LRaaJzmBzTsXxNHtZcV9j7K6d7Xfj4vBRaDqpRMmnnPAUHWHnb9WXVQ3UhnpbDYvCow+02UHV2vN4LFqKo9PEEqT/MzQ15KLOx/Ycrf/TP5pACe43JyQy9qIkouBqFtzebNSWSvuWtu0izxOnHhIWvDhrPqLgK5gy0E3U2AQF08AVqU1J1TrW2ErWEVwUWq/4vmlFTXgjmH2AirO7dwZrN83B0fTc2YgYmPvbhRkiMVYml3CAGSXalCU4AVSLv59+FI3pbLBT95C5fXfNEtKk1mFM7qObNGblS5WHov5uyWeeQntIxRQjmZsANKj4JvH+8ZqngGTCpCQMtElREI+cnmC1SClCs8V9z/bgjtLUA0EK1sb8YWsKZpAb+xtMyVEM68w0fFydTMDzJqcqTunkjPqmH7IUB0423+5jBdTNYUKWKksi9+q7ENdQAs/Ni+jIO3fal47CvrZjmp5p1iYQCirYduI/ihncfxae1kw//VUKP+mPN8K/pwocumGKdoE0U0AgqvLNJJvZI5Acj+E8ISCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199015)(6506007)(6486002)(86362001)(478600001)(316002)(9686003)(66556008)(4326008)(2906002)(4744005)(6666004)(54906003)(41300700001)(66476007)(8676002)(44832011)(66946007)(6916009)(1076003)(8936002)(33716001)(6512007)(83380400001)(38100700002)(186003)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MZSz8Hc+Swo/7HsBW9N4rLmE67kkAiL1nLvpLqla1oz04MDU177hYVm7Tawn?=
 =?us-ascii?Q?9VFXyDwGdubH3nq9kcejlkb+qeBoOz3X4Ng/sm7fOzU4y1jYHp2Z1gIJ8RJ8?=
 =?us-ascii?Q?AOGTfyyWavEJ7/zuJc2kfbGZcQxmOkRFeeb0KgGUGtiyd2IceSFT4jo8Wb0y?=
 =?us-ascii?Q?e13PtRK+9hk+B/HpZUDI1Eb2hqKwEc7btUA1NhgM/fcj5FyPzc5LGwVSjrfR?=
 =?us-ascii?Q?eRzEVKEH+wcS3P5hKjfh9LnPxy2zKJP39BIw0nBhGZ8BhjrQV/n4F8rNIq2R?=
 =?us-ascii?Q?05vlDUD21SoRzsJ0ecQMHyOY35czdvYGVV0FHbVISHon/6Xup5fEGeiH4dEX?=
 =?us-ascii?Q?bSSrGa3eWn40nuWlBkgHXQ6yjYk9ZbURLty6I7Mh+OLhWrsLMw4hpMn/ZlHq?=
 =?us-ascii?Q?6VQyAvK2yf7UnsP3M5XO8e6N7g9NlPkU9KnclJGSzBs7tEvykC2hfQtp+bzg?=
 =?us-ascii?Q?gzskWBbtj7uWvDcimcERJcZH/6GAgqyDg8b8ZLmwI7+u1i59ntori0ltzOFx?=
 =?us-ascii?Q?d1COZKIGvA7Xw4DQ89j8pZNWN3YvI+oM8NKpJS1AyDkOvvbZ0arXDx46tek2?=
 =?us-ascii?Q?hxCl/RTZyPGOAh2slf6dtQgW2pnCiin6C8Fh3wgslqJrjNUsSa/zwn53kjLz?=
 =?us-ascii?Q?+xobQbEKLw723hvgCreVyRTN+f908JAbPIcPjeNBVtML9Zkau4dBUbI6w+72?=
 =?us-ascii?Q?fpgq0mrJekoounCOuD5oP5P3uP7+a665bJYn0WWFZMvRqNIM94w0RRl8TnWj?=
 =?us-ascii?Q?bjvx4EkUfGtacuojxWgzX+nZ7aeEvqL1wpfphHx7SNsZNdt9Pdwqaaf3yRnR?=
 =?us-ascii?Q?N83r6drmRA+qB5sPC1cgtHZFMORSGNmacEaZr26JxBmRB9CI9KpGXoEFyJzc?=
 =?us-ascii?Q?6dDW1rk3BtImj6ctnzxpX5YN38czQNW77SEXPnhX9af8BmTc2/7Y91kocBsZ?=
 =?us-ascii?Q?iXpJE1JkAcMBGp/7VkqEMAsnnGMY5iObjJAA0cwwr2DlifI2QIbJMEGsi+AH?=
 =?us-ascii?Q?lFuqd5fJCPN/elosQJN4PeM3krYVKiy2zbhbYW1KI1CThJKtNIoLSMH8VY7c?=
 =?us-ascii?Q?nMQX+oqOy/Io0c4mtD3myeWoGo00WfXSuq9F3mfxuUkNcWSRHm+XMiO1JPW+?=
 =?us-ascii?Q?Cb5X+MUw+8TLEU7Y3Z6Uym3B7fUvIdPX/+49p+Tebyytk/eI1HGeXRLrtbQs?=
 =?us-ascii?Q?aj6kCIKzZ+Vj+ikbBJwjobII8crJejspdHStI9d5n7uyksGvCiCwd9HDXJIk?=
 =?us-ascii?Q?EkeuQF1bsC5ga9+u5ZMwFvWd6Mko6It2/pL1m+owgk3Ea+UtdI/axNRiwBZx?=
 =?us-ascii?Q?DQ8Fjxe/dtrDtIz5v2y2c+Ava1WE7341LCOIeoivtn3uE6Yy7y6uSmY/F7Pn?=
 =?us-ascii?Q?U4ofiDdv7EbWSMqQKm7Mrt8uo39jzmxHUc71SNRZ86XJrwC/3fJQQbuayTyl?=
 =?us-ascii?Q?h172m27AN+/y1MOghUVAYHs3Dwvayqy6BsdO9iWRevUgIiT6Gi9NjipR2la2?=
 =?us-ascii?Q?yZUaA3SwS+LmyT+DbW0LrStTNXVEfZdaAd3RhowGt+ZyHn/19gpPphF24xno?=
 =?us-ascii?Q?AWuVSA/AROLUhoj/b7hKu4eOjkQ6gHsr8mVMioo+Rj37frFf86xzJhsX3p89?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e50e26-f29f-4da2-11fd-08dad930b7f8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:27:29.6054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iupjz5Q2gUxmMuSqwhazGRmQHKcqwXcxsj4Eh1pz/PoZ6TtFFElQ+4b1ejK/Hh4McXo7yul4Jrmm4rOMBjbOcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8096
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 04:22:53PM +0100, netdev@kapio-technology.com wrote:
> The follow-up patch set to the MAB patch set I have, will make use of the age
> out violation.

Ok, so for v2 I can delete the debugging print, since it's currently
dead code, and you can add the counter and the trace point when the code
will be actually exercised, how does that sound?
