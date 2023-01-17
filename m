Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33159670E8A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjARAXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjARAXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:23:24 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37FC20051;
        Tue, 17 Jan 2023 15:38:38 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 30HNVQFq000493;
        Tue, 17 Jan 2023 15:38:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=4w/GkxQvfLk9wemty5HEIws5CyUUK48DXGz0lwllvTY=;
 b=EhovtKpf6c3HK1eRyha01Uw7BvLBFWBNgecxmP0JW1ht4sjUlQFFfESy7iDy4jlQ4mZ4
 TsH4sltlWBfduWY2ePiB0/LjRlJNzIS4ihHYD/4TZQYcHM1r1xMOS5V9BB3klS+owHzu
 3epmKhzH4fp0xZrhqSVFwcuVJWTVQU9E3uw0z/EgAujyJvP6zew0/uNoeHAP+h3cVDR2
 RljO3qI/q+2A0SZXiPdee/sBM/xgclxfZ2s1DG2jWmyxY2unk58bdg5acTCcq6iEj3P5
 V/Kj5SwP0ejRMnMaVjSwxFgjinWd99thufh1xbqh2TcT1kqeAyDy4aPyB9Dxy8Sm0zMc NQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by m0001303.ppops.net (PPS) with ESMTPS id 3n5w8gke2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Jan 2023 15:38:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1mwe0lDpWSuc4YcgcjvRsqWN0cwNsT7MhD/7Mf8wVa/7RZ4q6PKGP2CQxMWhxqtMA0QAkm2/O2PmQ40bWIrkEiI9bgqJpb6gEHv32fskQ5L1h+8zDUf3NNHbCwJ+t0D63Lk32e6KJoN2/N/0pX0dnmWchXXinGiBWTb7W0AeGOEJJdhzSZmzop7lu9SVT+SnWoHkb83rXjDAkk90W9bE+fevWk9tYuEqVncIPbXWVUXYLvRbrrsuTZkGCl52qr7dX+eecJUd44m3MjF97irrYJLJ8OpZDtG+OT3HYYzhBBaOHDwn/YENlL9D74Gu8hqnMUZ8Dv1OJNXXesMJVstlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4w/GkxQvfLk9wemty5HEIws5CyUUK48DXGz0lwllvTY=;
 b=QdFp79/+UvAnO8qo08hqXPCWPAC2g2AnsIfASisox714bilUqxBc1TyUl1IHiKmVjvxYWJwlvMjdWL/rnSYuXWC8Q7nLfzZx/GAdqPMg1Y7OAVzJ97oHqikbhe2VihfbnM6qt9MgdQMTbfuIljRWlhjEPVvifGVBOV/ZTP+rYAu9C8T4NHDxoge5qA1/+XZ8nEv9U+ik9zUdeDd0NebAmllA1mF1gFfaRC6Vmc8MnPaafufWwL8Ad0FVo0z7YQVQUIviD2dYXwXlyqCLkgRshtGFW7DW+D3VCjxLY9F/f+Hy9broRJ45Y0inAtqoE6yIPtTVBO89nsJ1h6ktZWG+Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by PH0PR15MB5144.namprd15.prod.outlook.com (2603:10b6:510:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:38:04 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::caad:141c:b287:f301]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::caad:141c:b287:f301%5]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:38:04 +0000
Message-ID: <51afcd71-8c19-8033-e21a-313b58f196ec@meta.com>
Date:   Tue, 17 Jan 2023 15:37:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC v2 bpf-next 3/7] xsk: add usage of XDP features flags
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
References: <cover.1673710866.git.lorenzo@kernel.org>
 <36956338853442e6d546687678a93470a164ff17.1673710867.git.lorenzo@kernel.org>
 <5e20044c-6057-e5c7-624b-a1373c30fc12@meta.com> <Y8cwaVPDG/CN/JsU@lore-desk>
Content-Language: en-US
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <Y8cwaVPDG/CN/JsU@lore-desk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0172.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::27) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1501MB2055:EE_|PH0PR15MB5144:EE_
X-MS-Office365-Filtering-Correlation-Id: f49fba30-e9c3-46ba-e735-08daf8e3dfcf
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cUOhBvihiP3T24eZRnQVU7LVE77bdI1+1nkkbu+gU4QMnK6CGze99GDU668G566m4yr+FGjIMA/dacU/fUFdAkUtw27ftLa19XN+aIwZMUvdoruROHIb64WPK5C36ESUSdScpQ1+IsplOMmVQXsl+DPoD0qroOXQvxjEh1fSceSeXijD9wfb5cfkLMjrTWpEbowNExMmEm8H5gqbyRKJZZxi/ytfqbpKlHPCv93SmtjRvV1xtYXq828Iba2a/qftTrCmQLxradnYLePLHl4TuxCnaz4cj8UL8sdhkKs/zVv/LhQKI25cCeqCOM2XZxFmlDrNlot00ev7nh9Af6u4rxJ5UzicTBKWLhiVcbyDoLGgBg3nUwfUMDvwnGi0+oiFOIa6VWY0boxaVKUqAH4rHTnZhwJGR2kZAk0OLQ/yKhhemSLW+QpPPI7O5yhbyf77VsJQEANlRPSggr5LlaMx1oHbCJ6ly4F5HUZBtjv2D8teoI6kNo8aj+sDpDj7n2XwMzr16qovQNjIOItE2h1wAoMBzDRvhH3B8TGGSsHWoOi/605AWlTnu848REaLsoTAfb7OGyE5UXOD5b8fupVSBo8P5IOSGsV2WteOv4jHep+d6WqfKcLgqYfNfV6gIVdQUEo/MQyArWNiz60NK7UugxsKGVuUweLS3Oz89axuzsdE6OkWHbt2faomJIqwMG1SkROSlIGAjvZV8M1UdBtRpYTeknsxmOmWmpu61vGSCiM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199015)(36756003)(31696002)(478600001)(6486002)(6512007)(6506007)(6666004)(2906002)(53546011)(316002)(7416002)(41300700001)(5660300002)(7406005)(6916009)(66556008)(8936002)(8676002)(66946007)(66476007)(4326008)(2616005)(186003)(38100700002)(86362001)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1c0dVZEcHVJQWluRFhJOXZycmNTSGlXOXl2di83djd4bS8xZVlJV0FGamhl?=
 =?utf-8?B?UHAwTzBlZ2ZUL0sweE9IUHJISFJXTnpDVWpkYmk3MUtJRDBuT2FnRkoyUnJj?=
 =?utf-8?B?eTlBeElBV3hOYzlDU21CTU0wRkJlRitXN2Y2cXViMkkwNmkwVEUzaXp4d1F0?=
 =?utf-8?B?T2ZkNXJ1UVZTMDFYSzZnaFVPTXI5WThGNk90Y253N2dUUXVBcUk4bUIyVFpC?=
 =?utf-8?B?VXV4cWxyaStZdjNCaFBQdmVyQWFWZVlKdkdGQ09weVZWWW5ab0RGd0pqMGJY?=
 =?utf-8?B?YkVwYnloNURsT3FrN3JLVEhwcHExS0I3K2JWaWRLL2R1LzlFcVc2V09HNlVT?=
 =?utf-8?B?NFgvYVBublpGTE5EQjlmL3A2K3dPSXhvYlpOalhrZTcyc29aaXlML0dOQVZq?=
 =?utf-8?B?NWtZK250ZGpyRDY1UlB1dTFvUmJKczZHc0tLblB4Slg3MVlmb2JRdGVwZUEz?=
 =?utf-8?B?TE1MZTdYV2ZXdWRtZFgrbmRyWktYQnlJZmJIdGY0MTlPQTFCTFFMNnFZWjI3?=
 =?utf-8?B?Vm5WeWVERElrUEJaK3pMVTZEbWRPMlg5MStYeE9BeXVuamtqRGtBS1Fhelho?=
 =?utf-8?B?eFpQSGpOOExpNjEwOXZreTZiUEw0SUZaSUs3bkxhTTBFL0xCcFQvKzRNVVo0?=
 =?utf-8?B?NE0yYnpZcitTVFozc2JCTWlsVGlXdElmYkc2b0FLRjZLdFBZLzJEbHoyZmhJ?=
 =?utf-8?B?dkZsSllKSjRwUGpNVFhJOUN2TWMvcHdqU2dTNEpUek00bXE5M0dTdWFnNE53?=
 =?utf-8?B?R3VqZ1VGMDlDRkNSRWpHZGIxZFFHMTlTQUJyNlUxeFZvVDY0QVp2b3dMT214?=
 =?utf-8?B?MmxBN2NxL3pDdW44T3ljK3JnMDdwNGFFNkpBOEJUOWVyOTZmMVNKbUNHY3Vw?=
 =?utf-8?B?MFMva1pSTENMWlhiakNodlE3RXRSNzI4aWFJVG1rbGNkOFdEb2VaOFZzRXZ5?=
 =?utf-8?B?NWhRRXJxcEdFRFNQcFpyWmJoSkxWYXVZUUtjdmdkdytMaUtaaThBNWg5ZWNI?=
 =?utf-8?B?aDZMbE55eDViY1RKSmJ3RWtNbDJqWkRmWmdhcmowTmRYNTRHdVZWdVpIRzRK?=
 =?utf-8?B?REs1VGpiWnFrRU5JdHhDVnF3VmZiY2NhSDVKNE1KSktrUGd0cDVuYWhucUJ0?=
 =?utf-8?B?bWVQaEpMRFZNdUU1THE3NGgwV1ZwN2JQNTZ4dGJLRkozWWdJNWxpZGJFaUZj?=
 =?utf-8?B?Lzkvcm5ORmpSbk5TbXFqS1N4U05Cb2Z6djVNS1ZSUThIcHRkZ1hzb0ZPdHVD?=
 =?utf-8?B?eDg1dHNRbVZJQ1F3VHlVL2UxTUJDbytYNzN4TTNNMEwvUjBKeldlMnN5amRH?=
 =?utf-8?B?a1gyOFNXcTVFTlNnRExSU1puc1R3Y2pBMkVpV2V3QmFJK0g4OWJ6L1ExTTZG?=
 =?utf-8?B?eEF3QzdOTWRmR3hYZFEvMnd5RlFIOFpYNjFJSWRETy9ZMHdTd3dveFhKeXgy?=
 =?utf-8?B?WmVpR1ViREN4Qk16em9BTmkvYWpIQTF3aXlSY3Z3NXY1TjZEaml3eU45dEhM?=
 =?utf-8?B?MUdadFFZNmVDeXZOLzZvZ1VEVDMvck5iaWhXNW1BSTdqUERteFpPMHl2WHJM?=
 =?utf-8?B?QVNlUTk3cjFGOFJCWEJhUVJBQXNhUmloeERwWGxrek5aWU9DaUpZSStKWVo5?=
 =?utf-8?B?Sk1KYm9QQnFFMkpqWEdhVXdCeGtPZmhkdUJ4ZlJRWGdjemJwQTZJWkpSZXlT?=
 =?utf-8?B?RnBBU3F0dEJXbmx5WEZrclc5aVBTVjZKYlAvc0RCUk9IOTV0dXd3R2U0OUZT?=
 =?utf-8?B?RGcrSUVVdllIcnZOUUVVZ2o3aTEvZFoxM2I2aUlaL1kxR3BvSUtwVDFtZHJF?=
 =?utf-8?B?ZU5yQzkrU3ZWUk5QSmI2SHNVQU5KWFJtVlU2T1ZBaTFpdzdpN0JJQ1pHaTds?=
 =?utf-8?B?WHlXRVFVYXg4U3BYRStwaDVTMXpVUkRacVN5cE45Nm5VZGIxV1pTMXEwYXlJ?=
 =?utf-8?B?SHhFWWxaTlRZM1BxaTdXbkJVS0tDeHg2RXN6TEZJNTRHYTdtUkY2U3ZzZWd3?=
 =?utf-8?B?QUlKVzRpbUE5RGVWamZHUlI4YmNvU05yOVhrdlp2anU5QmE3RTYwVUhhOHhk?=
 =?utf-8?B?VytmM2tlUGVoUjRjR2I2LzcwQzNyQ1EycVgyQXdiUU5yT0h5NVhHdFZ4S2RP?=
 =?utf-8?B?ODM2Z0pWbmhyck5vUUVFMER2cE51cGpTSE9GVjlQR3Iwa1VScG1SS0NqM1da?=
 =?utf-8?B?T2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f49fba30-e9c3-46ba-e735-08daf8e3dfcf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:38:04.2866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4wOaAkZl4AIP5s+/RDbjx8okuzegMDABc1ZLW4gpUrKlpH35K+swrDAobsZwmal
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5144
X-Proofpoint-GUID: yvMITUXXXGCGcUL02ypXKIkkLpwTEiT5
X-Proofpoint-ORIG-GUID: yvMITUXXXGCGcUL02ypXKIkkLpwTEiT5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_10,2023-01-17_01,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/23 3:34 PM, Lorenzo Bianconi wrote:
>>
>>
>> On 1/14/23 7:54 AM, Lorenzo Bianconi wrote:
>>> From: Marek Majtyka <alardam@gmail.com>
>>>
>>> Change necessary condition check for XSK from ndo functions to
>>> xdp features flags.
>>>
>>> Signed-off-by: Marek Majtyka <alardam@gmail.com>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>>>    net/xdp/xsk_buff_pool.c | 3 +--
>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
>>> index ed6c71826d31..2e6fa082142a 100644
>>> --- a/net/xdp/xsk_buff_pool.c
>>> +++ b/net/xdp/xsk_buff_pool.c
>>> @@ -178,8 +178,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>>>    		/* For copy-mode, we are done. */
>>>    		return 0;
>>> -	if (!netdev->netdev_ops->ndo_bpf ||
>>> -	    !netdev->netdev_ops->ndo_xsk_wakeup) {
>>> +	if ((netdev->xdp_features & NETDEV_XDP_ACT_ZC) != NETDEV_XDP_ACT_ZC) {
>>
>> Maybe:
>> 	if (!(netdev->xdp_features & NETDEV_XDP_ACT_ZC))
> 
> I would say it not equivalent since:
> 
> NETDEV_XDP_ACT_ZC = 0x5f
> 
> and we want the device supports all the ZC requested features. Agree?

I missed the fact that NETDEV_XDP_ACT_ZC is not a BIT(...).
So your implementation is correct, sorry for the noise.

> 
> Regards,
> Lorenzo
> 
>> ?
>>
>>>    		err = -EOPNOTSUPP;
>>>    		goto err_unreg_pool;
>>>    	}
