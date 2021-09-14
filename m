Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082DB40A8AC
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 09:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhINHyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 03:54:07 -0400
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:20352
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229379AbhINHyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 03:54:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENC0GDke7ME6UmdaaghSGspiFfJdGqKebfKVrcffwj2Bjs4M2KsGadq9tbxnqGzTp4rscRPuElLvvjxs6Z8EOzHAvjIq15pME29Sytj8yWbxKfUoVGB6WxzcLQPGyTAy6fSwipdVhRYXzMOmHSS8UpYfh4U0rEN4NnJh6j7I5HGzbiJAQxkQRC36xt21zPNyzxwM4WOatQ7PlHLxetA7SDm0/cA+unP2eSKgEE0iZA5gPKzIFAxxzD4XCeT05KsCH51mtmpRW4jox1pa2UR2VUlzNeEuPUKIDw4KePujM2VfVoQPgiapR2/Fp85RLtxJ7YMeFyn0/6KFLQ4w8X9mpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ipaM8br1shJVWz70QSY9/GqUT7F384bBqjChtuToGhw=;
 b=ZaV1lptpTFDVP3tZZivY1TN3PAhJEjjB9o6Phfdz31yOBCt0XC/jy60hKF5Iawz3Z5yzBsvGkH9JyuieW386uazhFsKznaKIGFx1PLOzi/SQiDDO/QQbigrITXqAsea7LZ0NLE3KHrUuTV1k90ssdw7wOwSnAr08IjR7EDdYv36nvxbWtNHcLjsJV/Bt6sd/XiC8KXu4Fu/8aEAyZE79Lmj/H0HzKncrd0uVOF76sUzmfxdO+bDssU2HJwW8uidhKLuW36Im3CD88w1V6eQpacV028AMpkZnKHz+ECSiT+osH98ukyUrtIq13+jL5QqHfowegmPhZBO9dkb02gzsVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipaM8br1shJVWz70QSY9/GqUT7F384bBqjChtuToGhw=;
 b=GB7SkVxdGFUMrR6QNNFoQat1xwq8PAa8eM0eZQQSaYRn/iqORLTSs0Gg5RZGg2orDH70jBjTRK2cLhv0adOlKq87fknOAVdJaCScB25KdHiYXVDpVqAU8jFFs//tSgMN6DQmGzNcuOwr3AT6WBKsEVTDaeEtWSKv3FIN+YsqLz7izEeu5QLMS5r+WLK6f/T1TAtBoEd5u1GvPgbrshCNN7HlyXjNl5+tZ8wP59YBdWeH3IhbdZqBpPbXVUt9jrWrjg37cZ9JCbXGEUK/ZoIMMFRra9NfCyfqp0B+O52Mzhu9A1FYkNgUdxv3PZbJI36OkvTuAxoY7G6gyAVTP3eC/g==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5461.namprd12.prod.outlook.com (2603:10b6:8:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 07:52:48 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c%9]) with mapi id 15.20.4523.014; Tue, 14 Sep 2021
 07:52:48 +0000
Subject: Re: [PATCH net-next] net: core: fix the order in dev_put() and
 rtnl_lock()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210914030150.5838-1-yajun.deng@linux.dev>
 <903c5bed-5958-8888-b55d-9c175664b2a1@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <10890d5f-4486-0fee-0d8e-3c1c92f78937@nvidia.com>
Date:   Tue, 14 Sep 2021 10:52:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <903c5bed-5958-8888-b55d-9c175664b2a1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0128.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::7) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.42] (213.179.129.39) by ZR0P278CA0128.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Tue, 14 Sep 2021 07:52:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3230dad-ad29-441c-957b-08d97754a502
X-MS-TrafficTypeDiagnostic: DM8PR12MB5461:
X-Microsoft-Antispam-PRVS: <DM8PR12MB546125A3FCB2A943660B9DB4DFDA9@DM8PR12MB5461.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DNuXzOas75XjkvQhM1E8fWAWsZB4rvq3QkBidJqVN0LEd7AWoC8BV63t7U12yyC7hI1Ur0vyPTqwZetff8LLX99s5RHyey8aURdo2Wpuu1bun6ApuPUDtJxYIrkwej1NzrmOIO3SP45Minz1h7C41kWdfFi571FHmfIyUX+ESvOZ6zTpHU+PxMBUdgCtVDrqJ4hFeBsmNDQDZhHPQd7VZXyCAie/iyMaqzy7mGo2n90b5t/UXcmAej3xL8mltsci3aW/oMy4Oz5jiILOsqIRnhFsFL6YWaXxZpna2FBoO2czSu5BaiOw9PO5+OPlJtsl3whQQOqq6khy6207kpik4IfL3MaE4RK8vRnQPAL3/dWqrNI3uN/eNgx2gqtiV8b54k39WTxTs1MmOXzjTOK9O7yNqx6okgIsy59a03/1KY1Mef99PpXRSqS9QhVdMC5M08fW03QscwcdSA4dSrtmB40Z1GaadHVG2//jM6nQmabM5enfsmXRHk82cacXH8jeIMZ3+2mPbn/0Zobj1OY2sc1FoAj7BVSg9BOH76xfshRIKPc4mSW4TVSNkjlqNgY28IzfqYZYW6UQh5P9Bf2XTZ1Nj10rQ0xmANhWrSr0/vO6y6akdM6NLYDUh5PP6qzBnupJA9ljWTbgh0/3OLUW4aUDKgU1TTyi+uwzKX1baA4lOlG7zZHhOp2RF/aqqvK3sSjXk7JY/Jx3YogywV2Znu4L/tovjGhSWoD9gYESyDo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(53546011)(6486002)(4744005)(36756003)(316002)(86362001)(26005)(31696002)(66476007)(2616005)(6666004)(186003)(66946007)(8936002)(66556008)(5660300002)(508600001)(8676002)(31686004)(4326008)(16576012)(2906002)(110136005)(38100700002)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTJmanhSZ3J6VWpXd2NGaEJMSGNjdmVJN1kxVXNNM2pTYnRJNjRlaEpQRVFC?=
 =?utf-8?B?RFZ2NlNaaTBQWGFubVNBS0JvTjRyNklwbE1GbFdHVlVHYWZJd0hMK2hUdDUw?=
 =?utf-8?B?NDYxYUNuOERQR1FaN3BSK01FblRSakpzc0REaXBnb1YvU0w5VUlseGlqK1NO?=
 =?utf-8?B?R1RNRG9LMkQvRVpDTUxLYUtRRHhZNVBKQ3dQRDRERVlrUG9BdWxRZEFUb01S?=
 =?utf-8?B?Rkp0cFlGNFNQTUE2VkhocUFyR3pub3JjcWlTN2NXNXVrbGhab2FENnZ0Q2dY?=
 =?utf-8?B?NWcyZ2ZrR2RUbXRTZXFsT0VVZnJqcHF0NDkra01FYW5NOEh3UnMyMXlGMG1K?=
 =?utf-8?B?OGtETkRiYk9XK3Y3b0Z0Qmo4VUhuaDZDckNvaU5Wclh2WmxiV1RFNVp0YjZV?=
 =?utf-8?B?Ykd1b2dtaTNBWGhjSjZOQkRya1RtbGdNLzFvaXp4REVLcElIeVRLNjRBSUNx?=
 =?utf-8?B?RGNzdTNPWFB3bTgvWGpVR2hVYUFkRGY4ZUoxWkhRWWpmZ0pNdXYrTkFaZWJ2?=
 =?utf-8?B?cm9tWHNGTEN6WVFHdkVlblZ1SW9UbXRteWpsUFhsWTUxcEVGckNtY2o3U3RT?=
 =?utf-8?B?WDlLcG5odFRsSDl4aVpqMm1qSWt5ejdtaFdxVWlUUnVUVWtkb2M0OXo3cStW?=
 =?utf-8?B?OGlyOXhxd0lLdXoxNEF4UU9KWklQdDRHcWU0aElxTGwyc2VrVi9FVnMwcVNn?=
 =?utf-8?B?Wm5GU1BJN25GVjhpZkZ5OElid0o2eU1xd2xlb2FNbW01Um5wT1plNmxTWGVM?=
 =?utf-8?B?Nks1SjZudFhEZ002Qm1QcG5scm1BR2JnMG5WSWlnS3dsMjEzdU9uTEdldkZ4?=
 =?utf-8?B?UUlielBpWStPVytWNUJlT09mNnJZTnBMZUpFaGNNS2Z5azMxS2wwbHRkdTdG?=
 =?utf-8?B?YXYzY1JwR0RVTERndWlwWGtCbzFlM2RiUE04K3FBRkkxUTFaeng1ekZaWkdQ?=
 =?utf-8?B?NGFMQnQ3ZFZzM2lTKzFXN1VSMWdYZjMwVXQ2TmtiajlBT0tyNEJqNmxLWUdr?=
 =?utf-8?B?WGdoYURTaGlTdFZ6enNkc0pDNXpXRlVSNEdYZTkxNklIU1F6b0o0eERGQ3RP?=
 =?utf-8?B?R3Q1SXBGWDljODhVU0w4dzN1VFZ3NmNFMmIyejVVanJlUFgrdmhhMncrK2gz?=
 =?utf-8?B?SzNZVHJLNnVLYzhPVG9tbXlsa1BXTDhVUWFMdGhkWEdpR2lDRjZXRkFPVEM4?=
 =?utf-8?B?bmZqNzRmSHZoczBsa3pia2JHZUk5YkFmMzRGYmRRTXRPdGFhSHB6ZnY2TW50?=
 =?utf-8?B?OEJ3dVR3QXBrbVlIUGZyNjNoNnNiQ3k3K093SFlONnRISUVGNklnSVg3WWFP?=
 =?utf-8?B?RVAwbCtkWDhDRGZVb3ZZYjhDM3lrZk81NXlrZDU4ZEUwdXlTRlhQZEdsN3ZY?=
 =?utf-8?B?Q3M4cXFveGhRU3cyZlQxWXlXVlFmejg1U0VCYjBtZ1pEcUZBWnFNS3hYWEV5?=
 =?utf-8?B?NkQwblNRcnZXK2xTOE8rakN5NDhaVDhvYVR6dG41US9EcmVXdktPdW5OQXFQ?=
 =?utf-8?B?N3J3U1pvYlFkckhjMWJtMHdsK1J2cDhLZUJhTFA4RlorR2M2T0F6VERNL2tw?=
 =?utf-8?B?disybWpDWDYzSnYzZ1JmWVA3Q05LSEE4cFZtK3U2d2ZGSUJYNTdMZmFnUHR3?=
 =?utf-8?B?ek9YSzNCUVFZcFhHOURDVGY4MUxZZHo2MG1oWXFaWE9ZRXFQNFNDWk9RV1A3?=
 =?utf-8?B?RTBRR1pMeWF1VUdyVmZJdlE0YTRiajdad1NuM0RZOHRZSVNZQUNNYjBTdk05?=
 =?utf-8?Q?PhDJODxpouK87g5Zzli2PiDCHaMoZO7zRc65+hl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3230dad-ad29-441c-957b-08d97754a502
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 07:52:48.1806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvP6CedixJuIO6uRC8FIswSVMhU9X/PwKQlXhI/g5uXGZoaFLIvxtXPg78hAFSevM9CrLBnfnLLlox31w+BCEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5461
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/09/2021 08:18, Eric Dumazet wrote:
> 
> 
> On 9/13/21 8:01 PM, Yajun Deng wrote:
>> The dev_put() should be after rtnl_lock() in case for race.
>>
>> Fixes: 893b19587534 ("net: bridge: fix ioctl locking")
>> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
>> ---
>>  net/core/dev_ioctl.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
>> index 0e87237fd871..9796fa35fe88 100644
>> --- a/net/core/dev_ioctl.c
>> +++ b/net/core/dev_ioctl.c
>> @@ -384,8 +384,8 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>>  		dev_hold(dev);
>>  		rtnl_unlock();
>>  		err = br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
>> -		dev_put(dev);
>>  		rtnl_lock();
>> +		dev_put(dev);
>>  		return err;
>>  
>>  	case SIOCSHWTSTAMP:
>>
> 
> What race exactly are you trying to avoid ?
> 
> This patch does not look needed to me.
> 

+1 

There isn't a race there
