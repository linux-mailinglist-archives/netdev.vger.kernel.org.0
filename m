Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348BF6D87E2
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbjDEULI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbjDEULG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:11:06 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1a::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957A37AB3
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 13:10:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PG3CkeiTKaCsjTvHvDdRiHDXshya30aKe4unJT1MEAQUOG0+f5m7Vy9mUmlUkGfiYceUdvN6N9YlUkUG3BtxfBG45wMvH1Wv81hd4r7s5UmEN8DeTUQzAhUoiuTPdZA9lf2/0v/LG0DuC+oGf5ed0Y7eIG0IvEO4+DtiMp31S2cVjIqFm6lVX5+6kRM1Ad9kekvXTjK4J/oqaX0/7HjNF8CAROAtzCeAKAUusES5uSqONU5cWj2J982x86vW4hKKYm9KTiwxVXPWIcHh4uKM4fMNkzGipEgXRkf2c+RQeyMhsAyBl3YWudlRIGNh9QWQRws6bIZrjOjxdPcvYBmGTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9gbtRlArnWpeBjlyNigHxk1uWn066oTKR7WDclhbxYc=;
 b=Nclsk1CExhfJpoaxIwQm7c4Bj/bk+q9EIrIo7Ro8RAH+0gy3T1302RbR+HGBw03zeoQniFIofGm4qWVanwtF5595E626l8HcQJTG4acLdxao121GhxQfQej5nN/u+P9bN0ARE0a+y6xAB6syA8bttLckZehtPz4jSlOUSGJZFQ4IAVmqSr5gXVwZcB7FnjW5gmI4tGSeTFBxd3Zl82121Mmcf0lMSR3/KwzqninFTjIkTqT8vq5LxCX4aGBe2++KTm6sY26koi6Qxa+QapDKIHqI6okkvJevm43bTrmyAag6wQxrj6MhMPKnh3aCs6VqKGx50xm8VPo1wHo0kch2zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gbtRlArnWpeBjlyNigHxk1uWn066oTKR7WDclhbxYc=;
 b=SlLA5AK5zX+NIv9ZzWenH0AKxkzianSj9RiR3koMtKq75KX/9EAOk5Cz+fAGVWYJcoeZqYJ+oUHjTXmXP9aeAf0SC7anA4pVW7RBdQY0dwbvdFwj8mZpKmeyBCCICUbLsY+HilRKIAm7/Ob1FG6S/Fg3KCTmB6jm5+s0six+XrY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB8664.eurprd04.prod.outlook.com (2603:10a6:10:2df::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 20:08:55 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 20:08:55 +0000
Date:   Wed, 5 Apr 2023 23:08:52 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <20230405200852.k7cfnjv442mxoscm@skbuf>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
 <ZC3Ue5i/zjZkvMGy@corigine.com>
 <20230405200705.565jqcen5wd3zo4a@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405200705.565jqcen5wd3zo4a@skbuf>
X-ClientProxiedBy: VI1PR09CA0078.eurprd09.prod.outlook.com
 (2603:10a6:802:29::22) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB8664:EE_
X-MS-Office365-Filtering-Correlation-Id: 24f34a2f-f5ab-4ea9-4027-08db3611955c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iKhEm9TeGSsPDSmcWMgKpQUTZsWhpP4XQDpjBRUII/GoMv8kXU8wxGj/pqLgFSBrT0mKlzhScdliz16gIUETdQLdwb28JGtTdqTXN9goPmcYSzmKlqNEoTdoF8BU4RSsKdm3hkyzJOdZOuWcCsSaabMlGWCQGyADF9AEkqm6tb7sORTrmMsi/+CAlLmuVvfNuxdXoFoVmle5ncLaIC5+Sf2R4XFC4BUw7FrNJSw+fklpblZ3HqQ77P59pmytdoQbh6UcthctyEQgT5XYWi880aw5zdkET6TYHGEOoVEWBnvsBUQax0eD5JTylH/DwRSgMU1is907deF0n+rINdDbg+fSRcOp0Fja10WsL3rUwPgjC+XMswF7+JBFwtsXOxoFpqyNpp3Vr4Om7uRNVkHOz5GoSXPw+ongPWIt1G5VPRwdUASiyNMnDVWSAUoE5kWuxwrpkX0kKpk7+W29+n6izv0tX5/MQ3zclJlFZIw7W1bQ5I4jUlVd31Iu9k7Z6QoUB6HAdRfLxwy/pv8O0t7fgM0Clnfuwpda8SIBdE88qgf4ay887crTtK4cXzRIhsBT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199021)(41300700001)(4744005)(38100700002)(44832011)(2906002)(5660300002)(8936002)(33716001)(86362001)(478600001)(316002)(54906003)(26005)(6666004)(6486002)(1076003)(6506007)(6512007)(4326008)(6916009)(9686003)(8676002)(186003)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aYKu/7+HQu06QD88JsZz6NPhjMpaOWJxk8MPwkVpDu21h72CX2pWQIP86nz9?=
 =?us-ascii?Q?xnTA2P8NloeJi3T2XIP64v44NOfFkB3EYJGOwFsaGchHIuRnQiM49SSPsZEU?=
 =?us-ascii?Q?0TFwRQ3jFvfSzjwYkEKALaptVcESDce5N6fbpA7XSpWZBYXauEzrVo0bayz2?=
 =?us-ascii?Q?kt0r75hnGUZYgj8r3hSMThWjg81iYT6Q5Klbx9ad0jRp0soS9VNUbB6zwZMi?=
 =?us-ascii?Q?Mo/5MlOsXeY18Fnke0RgWoEAzMW7lC2qZIJLzjuWfPTnskYc72FV6VzdQJXH?=
 =?us-ascii?Q?+gqGUuqVOIc+2e0v//ckwScYMJi3adnmOAgraTrMVDpPO+JO1+OYoVWX3yPK?=
 =?us-ascii?Q?v3Z6P3Wa9jw6jlN9JLR0E2z3e/yBfcHQn4nus/NYtjlU7dVfdQDb9Uip+7gr?=
 =?us-ascii?Q?xjGHGKhiTGLheYKD4gjwNDIByeGXS9znYu1xNoLaXvAl67jCTEvrxe0m+6aX?=
 =?us-ascii?Q?6MxcL6DBeaO6+0J20G3K14viDdJxFMjj4Zca1t+YNled0PFJPcMc2Uqpn3lz?=
 =?us-ascii?Q?25rncj53OZTQeASLO30FkqHJes1u1t2gub0wmqwvv3mgDAtf+VfyL2rAnND/?=
 =?us-ascii?Q?csdMA4aPnxVBoqZnGNVJCM//QKFnYcQYaOWLFmi9Nk9eGUQgzGh3ACBmtkKc?=
 =?us-ascii?Q?YBgHwiDKHxcB5mp7GMLRruM8o7UaFc6ph+WdfbQBj2kHuqRuxK+beBwLjfaj?=
 =?us-ascii?Q?xHLkXWlC7AekDenPLZKmggzY4If7kiTjN9rYpVYnAFO90VpUoNZME4of4xyV?=
 =?us-ascii?Q?hIoilDOZtI0D1sOvYVpQgjoOt/du4k4Cg32hq/NffUYGuNI+Q1S5XfW5wMQ/?=
 =?us-ascii?Q?tjYD+z8a3qP+Y3E/IH9y637wVNIThUvfLOPmHfXUuM9f3qvaFALtDW9HQndG?=
 =?us-ascii?Q?7fToNUoHHBAaJ8fejKnzDCu/ruiMMUYxcb4hfDen8tBLM/eoluzwPBupjjt5?=
 =?us-ascii?Q?5GShvlLWRaIzk4Lh/riHaUT0fhJf86JHF/cQaXBcHakeLAxyvLaSUeJrJ3DG?=
 =?us-ascii?Q?UsUhH2fK2TJiAwsyGzEK9M01q1y6KKYUjB3TANUY9Cd32CLw4q2BO5Z4g1ZI?=
 =?us-ascii?Q?/HjzVLMyG7sfEFfngWAeksp5rGgntQmZEYydQW1eog+YpKViYFW7BeJIuUAO?=
 =?us-ascii?Q?UrDqHd5vhUV1uRb+LB3wWlNhWwaAFdZhqy/3dLRspsnTRNY2rSpDsjPwUGyo?=
 =?us-ascii?Q?YzJK9XETzDjWnfO1pUA6kn3xlnYVuMT8kxoYQ+aR+zzGqyezUI77JBuoQF1G?=
 =?us-ascii?Q?OenDFRuxSASlW5vcgit3vjrvtazhGwejt0Tt51M29VDOm+gpwPuiNmkQU/fv?=
 =?us-ascii?Q?+wajIMOueg5na6sC2ZEqo3S9OTBGiRTL8m/j8TPE7sJhwYgUir+39cqVY3DC?=
 =?us-ascii?Q?2R44pHCCIoLbXePIqGqYVh62dsOCvA/HDEUWAyFD5gK9HM45IBT3XDPj5qRM?=
 =?us-ascii?Q?cKnsuyluSHaG/S7jM5d0AVC38NpOJX/jO6mC8Z2KophXxTemPMt8OS5LHTip?=
 =?us-ascii?Q?30BgAtxj4KH432+YjpjMtYAxBgdGRsg54hM9kGDd7a98Cm5Y2zqfXIeSqouW?=
 =?us-ascii?Q?UfMvfqYI4jeHCjz0uDGJEvJXsazj6Hc+pgOkplAr15ybdoMYfu0LzHIPn4w+?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f34a2f-f5ab-4ea9-4027-08db3611955c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 20:08:55.2477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yko8idWdGyC0pgmgXHFc+7/mCq8DGPC3c9/EubyKii/wBEtsQvLc7KDO0ytrZcHlnziyesAA39Ujfqvx8+HbCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8664
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 11:07:05PM +0300, Vladimir Oltean wrote:
> On Wed, Apr 05, 2023 at 10:05:15PM +0200, Simon Horman wrote:
> > nit: clang-16 tells me that err is uninitialised here if dsa_stubs is false.
> > nit: clang-16 tell me that extack is now unused in this function.
> 
> Thanks, all good points. Thank clang-16 on my behalf!

Perhaps I shouldn't have left it there. I'll start looking into setting
up a toolchain with that for my own builds.
