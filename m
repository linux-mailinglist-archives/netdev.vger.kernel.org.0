Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8707F3B719A
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 13:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhF2Lxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 07:53:52 -0400
Received: from mail-sn1anam02on2061.outbound.protection.outlook.com ([40.107.96.61]:59213
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232556AbhF2Lxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 07:53:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkHdBcpBEGZ3Q/j18Org2Bs5EJhOziSdMpT7qtrcpWrzTNWhDpP6NCplBit6y4hI0VfEqz15ZXgq4sXdFXcXneJDE+EiVzDTXWFMHQMtEpd1TeYnlbi/B8+0X2NPuUWHLooB6DjUs11c44UKmsliaD4CP+MzwlMAI4/oLa0tEn+HQ3O5JAszFaElXHsoo2YdbtSyHtFoxmBRr2VKcSSSPaNyxCJYhwslwa0L5bPeG1i1NgpPLrhoPGxx5zrvGCIbpCYtmj1d4PW56HBOomBn5NTOCfhjkigbt23uM2grkb6H6xnWyVPtjO3MaOmfjNx8/8c5URm2VaJIJuRLbqadXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXZg98ju7HQjWoQWQl5CLaxim0gpCLZO0CmN6jiRMu0=;
 b=YB95X5vbYki9LWXq2RecUue3Kf33mP/IaCwRO8fpiG2naFA/D9TnXbRmEMbjxOGcHIxEWG43G30geAR8dSg2soRcgOVT2+0t/50Xd8hZqmTzWl19Mh/vDfhxU1i1PUmZ9coJTsGbJ2hmho6BpFc3zLVfKikEGjvNynii6wMkbHcy7ouXa3JnGJCxWwjCX2d7khqBersytNKqz0UMD3pJOpWY1ikktRTLInrcVHmCAZ8oH7thIf/rGj4Mq3DL6kERmWUGH9nqFX5aZ3g+GMCxmhAq5tIDfgDfOn+T0ghkVFdajb8u8Vj0tbsme7i6ttyD2cEmQzNt62DbptyQi6dx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXZg98ju7HQjWoQWQl5CLaxim0gpCLZO0CmN6jiRMu0=;
 b=EoCBqxa7Pvvn/79QGOQe4K0QdFqoZRmaSW8GV6NV86FFv/tfanS69E9G8hrD2FF5+XKt5CQ3533kkoC4jwdR4rrQTvh+WIYVQfB19G/pjKEiHq/369ZaklE5bLpDfVAF6AfDUzvhl0PeDkOntiTrfm9yjfjnyn5JTR9352FrMerQu9pJ/qQAzBpeAqy00vSI82mJ6JAlhsE438nnRbvj2iYijSffmflwcSquJtuFPcl/oExc6dynKI4Fq99cWjNhjy8wh92p8Nksrp8OhjkMbDq6z4pqp/tjuXpps1yizL9mgJuATnwbiyxPsZ/ebR/yPj+vIYiKhPBbTjW8qct/tw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5118.namprd12.prod.outlook.com (2603:10b6:5:391::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Tue, 29 Jun
 2021 11:51:22 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3%3]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 11:51:22 +0000
Subject: Re: [PATCH v4 net-next 01/14] net: bridge: switchdev: send FDB
 notifications for host addresses
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
 <20210628220011.1910096-2-olteanv@gmail.com>
 <984a649e-38fb-9962-e7dd-3cd441a83ec9@nvidia.com>
 <20210629113557.eu5it6lfsnnaioej@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <d0777778-2f30-591b-a78d-54546ca17df2@nvidia.com>
Date:   Tue, 29 Jun 2021 14:51:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210629113557.eu5it6lfsnnaioej@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::10) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.74] (213.179.129.39) by ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20 via Frontend Transport; Tue, 29 Jun 2021 11:51:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4eb70001-ef71-400d-e566-08d93af43779
X-MS-TrafficTypeDiagnostic: DM4PR12MB5118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB511862E54D62C37A906871B9DF029@DM4PR12MB5118.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7AmQhsNYjx6T1W3G0PxNZqv8sZp945/Q5unVvzcKd+KKKpmVNKqkucRClfUXus5HgbbZhvjU9cRCDKJsC3sLPe/N0Eu/Q48Hu/DpuDJCZ3lPVwclGeMNQcouoTijgnP0AiKncyNYX1/lW0Otgzo2lhRRytSqbQ67tzINY3mLtNdjk8O1FiEzwwRzu0mVlNpvBHJhLfl839YDQ+vJd9VzGWn8ZW99fwodOWOoHXhcZ7mGYXmdLV4p290eOYDt8Kj7oUybcd5ZvaW71EIX7uR0g560oA3DJGdVFJ8Efm29EOTKMJHUPLAkedr/G8HxUbIXeHf9e2XoTJQxFYGl9BBV/7hCR/qXA+e3YG/6r4WemI0GAKkdysjQ+5DFjWfWlHPTn/XHX74tWsu0YMWNN/cYAYR87Xififjpx3IhKzy9HsBbhZb9liY/pS2AOCzEQJ0Sj1vLKJMeJU4b3VIIzuF7BYw8GVxzvqULgiycJZHuFaiK/8syvLKer+JjpxbIsvSAU5DN/ap71f2y3FMdeRllfn6ijPWIz1+i+px7E9PuZgJpmTncJmM0JnTOKKPfrEKszMUbxYeXWjdAPg/YGB8ByXGWiT+g3uYDPJyZaQpd3ta/LGE176uCXtLhCC7QG5dXSfIXl4d26QWBKjL6j/MpXXS88phkTwODSUVmVcke6WmjJooILndIEXFND9b7wGaDuFZNE4jsvVU2Eee38F7PEXrLn7ufO6kbFcHz5VMzHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(31696002)(8936002)(86362001)(66556008)(36756003)(15650500001)(38100700002)(66476007)(8676002)(66946007)(31686004)(83380400001)(5660300002)(53546011)(16526019)(2616005)(956004)(54906003)(6486002)(2906002)(478600001)(186003)(6666004)(6916009)(26005)(4326008)(316002)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWdmcjJZZ2h4M2ZTK25jM2piWDRHbHU5Y1pFZXhnU2tLellpNzBkbUlJdE4w?=
 =?utf-8?B?eHJlb2lZbVVac0pJdkNFYjlhb3hjWUg2Mmttb3hLeFArWXVqeG01WTVEaWtM?=
 =?utf-8?B?WC95aW5GNVQwOWhpRmozOXRlMDFkOWMvMmF6a0Ztelc2WlRRUEYyRWFSRU0x?=
 =?utf-8?B?ZWRWTjI1SGMyaW43K0d4bjZrOUNsUXpCcDJVMnFmOC9vNjR6WUgyNHkzMTMz?=
 =?utf-8?B?RnNydGpkbnpmTXVqb2Z4dmwwNXF3VGJVU3gxdGNIUkl4S3hDcEg2dC96N2FY?=
 =?utf-8?B?OHFDak1oWFdWSUJQMVhCbkpEQm5iQ1p4R0Vqd09Cc1FFWGxSRnRMMUgxaGZq?=
 =?utf-8?B?OXFYS3c4emFaS0REdmVRamxXWm5URWtvWXBCdW5MUHJQdTRuZjgyODhaVVVv?=
 =?utf-8?B?a3A1Nk0yUm11NkR4ZFRsS21XYVNGUHZ0ZWxFZU9mLytOSzIxZTNoV3BGdmdu?=
 =?utf-8?B?enk5bHA4SnNSUmdSalQrME5mV2xLV3dvTm9BMWxzemtsR1R5cmtkTGtFRkhz?=
 =?utf-8?B?ZGhVUlVLMmFuRmcwT3FxOStjdHNOcDVXVDZDZjA1OHB0cVEzY1VFWk1RVVZX?=
 =?utf-8?B?OU9iZFVXRlpUMHM1VnpSSEpZQ0dWUUJ0MkhGRXlqWXk0YXZ5RVRueXhGSDFG?=
 =?utf-8?B?d3U0SzdGRStVOXhOSmxqR05RbExqMkdnVE01UjNHY3ZDenJoU2VqSHJRYVZy?=
 =?utf-8?B?K1ZXbDZUQy93emY1dE1QVGY5TEVndDdzYll5b2UvcVBVUVF4Z1hSVkFuL2hP?=
 =?utf-8?B?bEw1RGZoVnhwblpRcmJYM2V3N2xEdFh0UlVzN3dyZk4wS08xN253Y2JrV1hw?=
 =?utf-8?B?UG04b1NCZDl0R0haRS8rR093Z3ljalFrRHBTTzczbzVaSzI0WHFDa1VoNnRw?=
 =?utf-8?B?ektvdGNhZnF2b1FXRUtEYjUyS1ZsMXZUOE1vZXNPL1hHaHdJamRha3RSMTIr?=
 =?utf-8?B?TllKbzROVU4yTW1MZlVJT0hCbXY5akh6eUU2Vm8wY3BWc0tCbnJ0a0M2eVZv?=
 =?utf-8?B?TDVRSHRpcXhuekhYejk1TFpvQy9FOC9ldnFLQWhweVhpVGtYSkxKMnMrSnRr?=
 =?utf-8?B?dytWQkhVdGpGSHF2YWxVdHZGQkQrcU1YeGxmQmlLSmVQS3diLzhQS0dRbWJB?=
 =?utf-8?B?bVNtSFJvM1ZQTmNjb0JTcHFlckhWa1hGM25xazZQSkc2RFRHZVVMdWpDSU43?=
 =?utf-8?B?MnQ5TklIenVmbENYeWdkMFVGQkMxbkErTEttTXBuOXBZanhrYnFoVVcwMnZx?=
 =?utf-8?B?OCs0bVJqem1uandCakpOek12d1FaK2pFdk1PS053MSs0UitWRVF0ZFhpVGpS?=
 =?utf-8?B?akNmOW84TmVqb3BmaGtRQitFMFVrVzVqOVdwQ250NzJ2RW1JWkNwUWlqZnlo?=
 =?utf-8?B?dlZjRlFwRUZPa0RidTdNa3ozN1lVVUZ5MUk2a0Q1UXVuWCtteE1zQkpDWGR2?=
 =?utf-8?B?eGNHRmpGR281U2djd3B3SGw2RVQ0UDlCd3pCUm1Dd2k3OXUvMS83d0twWjhD?=
 =?utf-8?B?dG1IUFVsZFZyc2QrMzl3aktYa2RQdXcwL3lwdzlXNEdyMW9OVVhEcHg5NHVU?=
 =?utf-8?B?ZGh5b2hHZHJNcXRLb3FGb2dPa0VSSUhUZElQSzJyQ1ovemF1T1JFdG9NdUs1?=
 =?utf-8?B?cUowbWk3dGpyOWNyR0UyVEl0MkFnL0N1ZzRUM1ROVDlWTlNjQmNydDQ3SG4v?=
 =?utf-8?B?Z2dSTEgwYjRtRFNheVFWY0xlMms3UHVSbXZCV0dFWjZJaGxROUNVZGh0QTZJ?=
 =?utf-8?Q?RnrtaSDFOKOClaNfQ4n00n+NL2yDPE0h6ohFGZ3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eb70001-ef71-400d-e566-08d93af43779
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 11:51:22.8295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjLeNNnABg0sYXhj1Sqt/TXq+6Df9T3BA3672Qm+AUutUKE6J7JR4MYtrMC6e0gvXWjZ62jNw15K/sMkb+TK9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/06/2021 14:35, Vladimir Oltean wrote:
> On Tue, Jun 29, 2021 at 01:40:20PM +0300, Nikolay Aleksandrov wrote:
>>> @@ -117,18 +118,16 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
>>>  		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
>>>  		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
>>>  	};
>>> -
>>> -	if (!fdb->dst)
>>> -		return;
>>> +	struct net_device *dev = fdb->dst ? fdb->dst->dev : br->dev;
>>
>> you should use READ_ONCE() for fdb->dst here to make sure it's read only once,
>> to be fair the old code had the same issue :)
> 
> Thanks for the comment. I still have budget for one patch until I hit
> the 15 limit, so I guess I'll do that separately before this one.
> Just trying to make sure I get it right. You want me to annotate
> fdb_create(), br_fdb_update(), fdb_add_entry() and
> br_fdb_external_learn_add() with WRITE_ONCE() too, right?
> Can I resend right away or did you notice other issues in the other
> patches?
> 

That would be best, yes. The rest of the changes look good to me.

Thanks,
 Nik

