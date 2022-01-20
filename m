Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35C5494900
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 09:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbiATIBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 03:01:13 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:36042 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230116AbiATIBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 03:01:13 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20K4MNpO031217;
        Thu, 20 Jan 2022 08:01:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fkw4sbbkXyRHs5oajoq36RYzf05heJMQNT74xtxwz10=;
 b=LCpMoghjbYJrGaeZIzSTN6Ewn0JhHqbw5+dywyfZ5LMjI/HR11vHkH6gRPnc1SeihFkX
 ZI4hIUM52z9MCw8bPnCpdnVBQ7k7gZye/4ndf9hvXyn7zyIBmVL+jtzQReqierFLaBVJ
 gVWFNe6sMTVPSzwJX2UsDzjsRxSIQ66ZKSckBwhGhCErh8KPxurZBq4xtWZ0VkY8BiGd
 41MfdzM/Hmu2TvHyFFwz9jxZWwI+6rvdz2HOp493rGIKgcFzTsQSVfdCUxzogTX6VTwP
 J514UJbx3Su2h9sRZoqVAW6y2Il1U2wbJj4C/dFDn7rskChLd9m/ncD4R3Wgd3v9kbh0 kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc4vqmmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 08:01:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20K812uC092446;
        Thu, 20 Jan 2022 08:01:05 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by aserp3030.oracle.com with ESMTP id 3dpvj1r05r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 08:01:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnRWimvcdKXsJJtDf4teZpUZqn5VDcnX0Q9Hc25plARHp3HrSluvEnncJTa40eFxCqAnE96E+tEkPX8SplBS6Y/Bb/gufgwuW2gHAB2Fk3neR5xQAc+YOMRQS/9ExOJNn2+/6BSgLcXGEcXSczdVesdDSkzM3W/BP2Z+ZXdrsaVow/p8IUSXqxLHevU03WlZSUMjF+Z36GOCvh1UzbV+/QjSROLs1pUgaGYevoqjV7FGwmsANd9AbpCgvH9QCYJsfbWwjmFRW1VwaVtvBeqi8bgunTCHVV/+zTjZuvq+q6GUmyLGb3DbVju6WlxC4qtsQqDeQKFmCRLkhbmtT4VqNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkw4sbbkXyRHs5oajoq36RYzf05heJMQNT74xtxwz10=;
 b=Dw/aSj5x0DPq9ahoMau0IMVF6zXCqXeav76osYlgAtRG1BWrhlqGuaqr8j+/DEDhTe0caLhzNYyde3bOKaieLyGfnhWBs95aFWjH4j7q7qnbWzo0wRii/GdJjoQE2WqabFTKfsRFPA+iwIQYdwSTI2+7CPE9e/MKaMjDpiRJWq3LjFvLKF4x/rL2CdjKnyYSAbhULWbJkx8HFengHTpM1jhdIIfwWTmPPPGd6YCtX13wuESiOgCrol3IZnl276SO4DGD4t5b9LvqL42f/LO9MURxJmKKq6hUYS5yxWpBsLgAYBNzW1WlrvaP+BgB6KAmZsz8kYdzs9EvCJvL1JncIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkw4sbbkXyRHs5oajoq36RYzf05heJMQNT74xtxwz10=;
 b=jGVgelk/fw4D5g1vfAWD4VXwK22vVzXc5gfm1c160JzY8Wx/9kdMFe2RuR7K1meE6+g7TMAfXth/Hfjh8BzOScj5gpHyog4pBRPjzgEMpc5avHFHY/vc4nIybwR5TfZaHNX+r8YJcFFyJKWYsnVdGnFQQSSmJzqOvH9RExXSWEI=
Received: from PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7)
 by DM5PR10MB1867.namprd10.prod.outlook.com (2603:10b6:3:10b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 20 Jan
 2022 08:00:54 +0000
Received: from PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5]) by PH0PR10MB5515.namprd10.prod.outlook.com
 ([fe80::edcf:c580:da6f:4a5%6]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 08:00:54 +0000
From:   Praveen Kannoju <praveen.kannoju@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>
Subject: RE: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Topic: [PATCH RFC] rds: ib: Reduce the contention caused by the
 asynchronous workers to flush the mr pool
Thread-Index: AQHYDHpMX8JHvK1k8kSJh1x30qsksqxo/YyAgAAprgCAAAb9AIAAvOYAgABQL4CAADU3gIABHbSA
Date:   Thu, 20 Jan 2022 08:00:54 +0000
Message-ID: <PH0PR10MB55156B918F0D519B8A935C378C5A9@PH0PR10MB5515.namprd10.prod.outlook.com>
References: <1642517238-9912-1-git-send-email-praveen.kannoju@oracle.com>
 <53D98F26-FC52-4F3E-9700-ED0312756785@oracle.com>
 <20220118191754.GG8034@ziepe.ca>
 <CEFD48B4-3360-4040-B41A-49B8046D28E8@oracle.com> <Yee2tMJBd4kC8axv@unreal>
 <PH0PR10MB5515E99CA5DF423BDEBB038E8C599@PH0PR10MB5515.namprd10.prod.outlook.com>
 <Yegmm4ksXfWiOMME@unreal>
In-Reply-To: <Yegmm4ksXfWiOMME@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79f41473-8c29-4361-ea01-08d9dbeafc0d
x-ms-traffictypediagnostic: DM5PR10MB1867:EE_
x-microsoft-antispam-prvs: <DM5PR10MB1867B1865D0AE57AC0A6D8338C5A9@DM5PR10MB1867.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1wqZXvv+9z88ZGKE4joEA+USraR1wmoBu7KNYFcOGO+UZxuM1Oy9OUGlqnLlpcrwHred6a5nsUUI0H+JGwa3m4wztj8vR2bzewV1IvfKEdnPKK6MIsZZWSS61bjoQPbYdOrQLIbNNvuAhuukSeo4JQsPXQZbb+zFpT7FQXhCWfvQe6nK48FqypnYmAjeKgubG/rwtNsJise9swjfGu8Rpb/pg/OGcVz15XU/PBvpF+qAZVHWm/MrWu8TdgK/VNSomVKRTCY49+Su2nC+k1LBGX/rsdk/NxV3fQ1vSEsRyNWQw7ZFA5HBllf3DEgzjKpuhEp8MOb+qfJkzLdb1YIr2zfkydRvrwvvajtXsKNg9OEQx9e0QFvbROJJ6tWBtxy1heBj/nEcGaybb+kMXQlxpx4My5R9xyptdhswYzrOM9EH+XimZ66LvZwInOmKlrE/QRAe8xNhDQAbWC8r45wYrFIbzyTS/0eG/KUo6OH/ExvCv6nePLPaDv6bAYmbaiaJIkwCUqSjAvlK27i72BaDEt9kEqKR5ghXXR/rENVjJijMyESlrMiePWh8mZL7wSW0WGljmJav3/Vky525n2YWStzxR+BnZ7gx1RO2WpXEs9OTYp7Ue3Nj4Z0koOf/4X5Ki6yX2wQg/Et3J20XJ7n4ZJy8UpD++x+AjWMNOuJ6vJbsVEC/rgeVcCHUDE8yESZzqohq5V8+Y0fVhORGY+FOWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5515.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(4326008)(9686003)(107886003)(316002)(71200400001)(38100700002)(54906003)(86362001)(110136005)(5660300002)(76116006)(66556008)(66476007)(64756008)(66446008)(66946007)(7696005)(122000001)(6506007)(53546011)(38070700005)(44832011)(55016003)(2906002)(508600001)(33656002)(8936002)(8676002)(186003)(26005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0ZhUXdqN0VxOFMvb0ZNdTBNODVkc3lOOTdiUWhtRklBZW12Ry9rZC8rTWph?=
 =?utf-8?B?NEdNZGpySmJpc2hpTHdJTFdITVdIK3dLNlBGVmswNlFiMDhJMGJxK3hwbmg5?=
 =?utf-8?B?T2hlbDdOK2xHR1F5bi90TlJmYXdTdnBTLzBaZG5lMUtrZWlRcEJWdnIxcWl6?=
 =?utf-8?B?QS9PK09pNjFLMGZ5QXE3QnlBZkl1cW5pWVBVWE1tdXNyS09VeWRacFVESjA4?=
 =?utf-8?B?Nkhub0tacEVlVkxKQmljZEZtRE9tRENnb0VTbFI5clpneithWmdnRkk3ajdl?=
 =?utf-8?B?cUErWEpuYjB1bGUwV3lFQmZ4NGg3WFRjNmdPR3ByVkkwalQ4dW9ScVhlRWxt?=
 =?utf-8?B?alNscmNwRUdUK0Y1cEQ0ZmxnQXRoZGozMkwvdnpPelgrZjJ0aXNFVGNBZ041?=
 =?utf-8?B?bUk5MFhMM1R2MHQxRy9VL21IUXJtc2Y3VXBYbndxbmlKc1FUWXc0dFV5U2l4?=
 =?utf-8?B?WXJlVFpIN3R2aDJIdENOZDQyNFl3Y2Y0ZWIxbklEL2JpWWxtZnk1TzVzUlZv?=
 =?utf-8?B?dWNjS0lrUHdUSFR2L3BaVlBlU1VEYTBrbFNGVUhabi9YRzVjT0tZZE8vWDJU?=
 =?utf-8?B?dFRFOXkwRHllU2NWSjNsZTRuYkVBdHJtTjdOblNqV0ZmOFFyVzZzTE1UOWo0?=
 =?utf-8?B?eTRpMmZQNURpMzZFSGptQmgzaEVFMkswY3YwTTdWYUt5eERINU8wWHVoaU9I?=
 =?utf-8?B?UTR4UHFDWG5lS0pnNVVIYkxUaFcvU1N0RVhtMk5IWGRwV0pSQnRhSHBxUzVO?=
 =?utf-8?B?Vm85c2FUMDg1TmpyTS9GcGlsY1I2SDdjclFSTmVhYUdMSURmS01tUHFCZnk5?=
 =?utf-8?B?L0VqNnd5QllKemR3NmxYVFhsREVwYUlNTWZkWGdtOE1SMDdsMHA2aFU4aUlt?=
 =?utf-8?B?ZkhQNGFaTmVFTVliT2NlbEFYazNTWDRFUzFwbWFCVDV3MkJ3aDFHVklielFY?=
 =?utf-8?B?U0wrbFVHaXZGdjhMVE5TT0JJbFIvS3hPVk1hUW4wRlVXbW9nQVhQSXZQWi9Y?=
 =?utf-8?B?WDZpWTU1eHR1b3ZmL2dCdUR1bWRkQmxpK2loVUJ4RzNjN1RMSDlBbmcrWUtx?=
 =?utf-8?B?d29mYURjelVCS2RhNlprNUsvdThocUdjSk8xL3M5c1BuWjlKaVpoSEJWSlpC?=
 =?utf-8?B?K0FlUXZKM0V2OWwyQlpKMkNjQ2JtQ203SXFZMXJwbXQvQ0lvNjdadnp5YVZR?=
 =?utf-8?B?TVZJZmJOZFFpZndocm50S2g2MW9vUWNCQ3prTkNVV2hNTlJUNVV4Y3E1dXZW?=
 =?utf-8?B?c3VOU1VQLytMQWxXc2lUOCtyQ3U2TTZZQTZ6OHE0S2lSYnhuaUpzSkRmNG54?=
 =?utf-8?B?UlhnZ0VGcVp2dG5RaTJua3pRTzNmZXBDcDByNG95MFBpR1pXemZZajBUaUpk?=
 =?utf-8?B?QlZnRmVMcFhZZ25idGo3ZnRROFBrNkFVSXBVaHdOMGFsQmEwN1hpTENtZlhS?=
 =?utf-8?B?YTg1RVpWSWZPc2t1UjFWSGtlQnQwb0VsMEZEM3YvTmNNSS9zaEdDc2g2Y1Bo?=
 =?utf-8?B?UHl3NGFwWkN2VDNMVVZheFhZWVJJWVoxVlAxNTYvUUJ0VjBuTk1qRmZibHky?=
 =?utf-8?B?bkVQTnBDRWZzY3ZkRDRUdHVGQ3h6NWZndmVGSGhSQWxYVWJmTmNDemg5b2xp?=
 =?utf-8?B?U0R5d0hIL1pWVTZ6TlpGS3B1cXFjWXNQUEl4MnFFVTZ5RllsSC9FeUhSWDBu?=
 =?utf-8?B?UmMzdDQ5QmlJZC9jb2YwTkg4UGdzdFdyNElXdHdIRVFKOUhvYzc3KzRvUjNU?=
 =?utf-8?B?Y2d0cmh5TFNORy9WNW8yR1BOTytkL3BZSVpHVXRkNmJhelNTZUtiQlZXdkZ4?=
 =?utf-8?B?b1lDWmwrN2h1elhWejZVbHBQOVMzUTRoVm9qS2tHNkZUUVlteWUvZDB5WEVn?=
 =?utf-8?B?dVpzYmMvTzFVbmhvSEVaYUpZdFcxZ2pIeHVSeXdxcXNxeFNkVkNHSlNDZGE3?=
 =?utf-8?B?aXlVMCtodkxhZU9kSTRScEtGVDhHOHdZYnRpdExYbkxkNEJzTk9RMWwxS0Vu?=
 =?utf-8?B?Sy9udjVWeGErU2lQcWhjNWl3Qk9kcVlkTmpRK0NOWUROaVYyWWhleEFEMzlB?=
 =?utf-8?B?dzZUQmJBTnBZZ29sNm5rSnIyWkFzS25rWEtqUk5tcWJYQ1VZZy9qZ29XNzZv?=
 =?utf-8?B?dkVDa2N0RnRCTEVsMHRHMUlNVHg4VTlHUW9sSHNIWDh2MWZnaHo4Z3N1UWQx?=
 =?utf-8?B?K0ludzNyTEVQeFZjNkQwZHdGcWJZQmpzbEtQZE5DdTJ5UlVDQXBWZWwyN0p3?=
 =?utf-8?B?aGI2eVNXSmU3OVhYOG9jUHhiWHlBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5515.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f41473-8c29-4361-ea01-08d9dbeafc0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 08:00:54.6299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k2SptPdN3yXCsOCYbVHTvqMQvcwChEYMX95/6Q/LxIIoTz4c1LvvYbUjfj4eMmJWDqTQB2EYafjzhA81QihH7o7aW4uiSQ2YaQLw96Q5fBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1867
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201200041
X-Proofpoint-GUID: VHJkXmT6HOK-v1pkcVU4UOLVQmgWJzF3
X-Proofpoint-ORIG-GUID: VHJkXmT6HOK-v1pkcVU4UOLVQmgWJzF3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IExlb24gUm9tYW5vdnNreSBbbWFpbHRv
Omxlb25Aa2VybmVsLm9yZ10gDQpTZW50OiAxOSBKYW51YXJ5IDIwMjIgMDg6MjYgUE0NClRvOiBQ
cmF2ZWVuIEthbm5vanUgPHByYXZlZW4ua2Fubm9qdUBvcmFjbGUuY29tPg0KQ2M6IFNhbnRvc2gg
U2hpbGlta2FyIDxzYW50b3NoLnNoaWxpbWthckBvcmFjbGUuY29tPjsgSmFzb24gR3VudGhvcnBl
IDxqZ2dAemllcGUuY2E+OyBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pjsg
a3ViYUBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZnZXIu
a2VybmVsLm9yZzsgcmRzLWRldmVsQG9zcy5vcmFjbGUuY29tOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBSYW1hIE5pY2hhbmFtYXRsdSA8cmFtYS5uaWNoYW5hbWF0bHVAb3JhY2xlLmNv
bT47IFJhamVzaCBTaXZhcmFtYXN1YnJhbWFuaW9tIDxyYWplc2guc2l2YXJhbWFzdWJyYW1hbmlv
bUBvcmFjbGUuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSCBSRkNdIHJkczogaWI6IFJlZHVjZSB0
aGUgY29udGVudGlvbiBjYXVzZWQgYnkgdGhlIGFzeW5jaHJvbm91cyB3b3JrZXJzIHRvIGZsdXNo
IHRoZSBtciBwb29sDQoNCk9uIFdlZCwgSmFuIDE5LCAyMDIyIGF0IDExOjQ2OjE2QU0gKzAwMDAs
IFByYXZlZW4gS2Fubm9qdSB3cm90ZToNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
RnJvbTogTGVvbiBSb21hbm92c2t5IFttYWlsdG86bGVvbkBrZXJuZWwub3JnXQ0KPiBTZW50OiAx
OSBKYW51YXJ5IDIwMjIgMTI6MjkgUE0NCj4gVG86IFNhbnRvc2ggU2hpbGlta2FyIDxzYW50b3No
LnNoaWxpbWthckBvcmFjbGUuY29tPg0KPiBDYzogSmFzb24gR3VudGhvcnBlIDxqZ2dAemllcGUu
Y2E+OyBQcmF2ZWVuIEthbm5vanUgDQo+IDxwcmF2ZWVuLmthbm5vanVAb3JhY2xlLmNvbT47IERh
dmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyANCj4ga3ViYUBrZXJuZWwub3Jn
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZzsgDQo+
IHJkcy1kZXZlbEBvc3Mub3JhY2xlLmNvbTsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
UmFtYSANCj4gTmljaGFuYW1hdGx1IDxyYW1hLm5pY2hhbmFtYXRsdUBvcmFjbGUuY29tPjsgUmFq
ZXNoIA0KPiBTaXZhcmFtYXN1YnJhbWFuaW9tIDxyYWplc2guc2l2YXJhbWFzdWJyYW1hbmlvbUBv
cmFjbGUuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJGQ10gcmRzOiBpYjogUmVkdWNlIHRo
ZSBjb250ZW50aW9uIGNhdXNlZCBieSB0aGUgDQo+IGFzeW5jaHJvbm91cyB3b3JrZXJzIHRvIGZs
dXNoIHRoZSBtciBwb29sDQo+IA0KPiBPbiBUdWUsIEphbiAxOCwgMjAyMiBhdCAwNzo0Mjo1NFBN
ICswMDAwLCBTYW50b3NoIFNoaWxpbWthciB3cm90ZToNCj4gPiBPbiBKYW4gMTgsIDIwMjIsIGF0
IDExOjE3IEFNLCBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4gd3JvdGU6DQo+ID4gPiAN
Cj4gPiA+IE9uIFR1ZSwgSmFuIDE4LCAyMDIyIGF0IDA0OjQ4OjQzUE0gKzAwMDAsIFNhbnRvc2gg
U2hpbGlta2FyIHdyb3RlOg0KPiA+ID4+IA0KPiA+ID4+PiBPbiBKYW4gMTgsIDIwMjIsIGF0IDY6
NDcgQU0sIFByYXZlZW4gS2Fubm9qdSA8cHJhdmVlbi5rYW5ub2p1QG9yYWNsZS5jb20+IHdyb3Rl
Og0KPiA+ID4+PiANCj4gPiA+Pj4gVGhpcyBwYXRjaCBhaW1zIHRvIHJlZHVjZSB0aGUgbnVtYmVy
IG9mIGFzeW5jaHJvbm91cyB3b3JrZXJzIA0KPiA+ID4+PiBiZWluZyBzcGF3bmVkIHRvIGV4ZWN1
dGUgdGhlIGZ1bmN0aW9uICJyZHNfaWJfZmx1c2hfbXJfcG9vbCIgDQo+ID4gPj4+IGR1cmluZyB0
aGUgaGlnaCBJL08gc2l0dWF0aW9ucy4gU3luY2hyb25vdXMgY2FsbCBwYXRoJ3MgdG8gdGhpcyBm
dW5jdGlvbiAicmRzX2liX2ZsdXNoX21yX3Bvb2wiDQo+ID4gPj4+IHdpbGwgYmUgZXhlY3V0ZWQg
d2l0aG91dCBiZWluZyBkaXN0dXJiZWQuIEJ5IHJlZHVjaW5nIHRoZSBudW1iZXIgDQo+ID4gPj4+
IG9mIHByb2Nlc3NlcyBjb250ZW5kaW5nIHRvIGZsdXNoIHRoZSBtciBwb29sLCB0aGUgdG90YWwg
bnVtYmVyIA0KPiA+ID4+PiBvZiBEIHN0YXRlIHByb2Nlc3NlcyB3YWl0aW5nIHRvIGFjcXVpcmUg
dGhlIG11dGV4IGxvY2sgd2lsbCBiZSANCj4gPiA+Pj4gZ3JlYXRseSByZWR1Y2VkLCB3aGljaCBv
dGhlcndpc2Ugd2VyZSBjYXVzaW5nIERCIGluc3RhbmNlIGNyYXNoIA0KPiA+ID4+PiBhcyB0aGUg
Y29ycmVzcG9uZGluZyBwcm9jZXNzZXMgd2VyZSBub3QgcHJvZ3Jlc3Npbmcgd2hpbGUgd2FpdGlu
ZyB0byBhY3F1aXJlIHRoZSBtdXRleCBsb2NrLg0KPiA+ID4+PiANCj4gPiA+Pj4gU2lnbmVkLW9m
Zi1ieTogUHJhdmVlbiBLdW1hciBLYW5ub2p1IA0KPiA+ID4+PiA8cHJhdmVlbi5rYW5ub2p1QG9y
YWNsZS5jb20+IOKAlA0KPiA+ID4+PiANCj4gPiA+PiBb4oCmXQ0KPiA+ID4+IA0KPiA+ID4+PiBk
aWZmIC0tZ2l0IGEvbmV0L3Jkcy9pYl9yZG1hLmMgYi9uZXQvcmRzL2liX3JkbWEuYyBpbmRleA0K
PiA+ID4+PiA4ZjA3MGVlLi42YjY0MGI1IDEwMDY0NA0KPiA+ID4+PiArKysgYi9uZXQvcmRzL2li
X3JkbWEuYw0KPiA+ID4+PiBAQCAtMzkzLDYgKzM5Myw4IEBAIGludCByZHNfaWJfZmx1c2hfbXJf
cG9vbChzdHJ1Y3QgcmRzX2liX21yX3Bvb2wgKnBvb2wsDQo+ID4gPj4+IAkgKi8NCj4gPiA+Pj4g
CWRpcnR5X3RvX2NsZWFuID0gbGxpc3RfYXBwZW5kX3RvX2xpc3QoJnBvb2wtPmRyb3BfbGlzdCwg
JnVubWFwX2xpc3QpOw0KPiA+ID4+PiAJZGlydHlfdG9fY2xlYW4gKz0gbGxpc3RfYXBwZW5kX3Rv
X2xpc3QoJnBvb2wtPmZyZWVfbGlzdCwNCj4gPiA+Pj4gJnVubWFwX2xpc3QpOw0KPiA+ID4+PiAr
CVdSSVRFX09OQ0UocG9vbC0+Zmx1c2hfb25nb2luZywgdHJ1ZSk7DQo+ID4gPj4+ICsJc21wX3dt
YigpOw0KPiA+ID4+PiAJaWYgKGZyZWVfYWxsKSB7DQo+ID4gPj4+IAkJdW5zaWduZWQgbG9uZyBm
bGFnczsNCj4gPiA+Pj4gDQo+ID4gPj4+IEBAIC00MzAsNiArNDMyLDggQEAgaW50IHJkc19pYl9m
bHVzaF9tcl9wb29sKHN0cnVjdCByZHNfaWJfbXJfcG9vbCAqcG9vbCwNCj4gPiA+Pj4gCWF0b21p
Y19zdWIobmZyZWVkLCAmcG9vbC0+aXRlbV9jb3VudCk7DQo+ID4gPj4+IA0KPiA+ID4+PiBvdXQ6
DQo+ID4gPj4+ICsJV1JJVEVfT05DRShwb29sLT5mbHVzaF9vbmdvaW5nLCBmYWxzZSk7DQo+ID4g
Pj4+ICsJc21wX3dtYigpOw0KPiA+ID4+PiAJbXV0ZXhfdW5sb2NrKCZwb29sLT5mbHVzaF9sb2Nr
KTsNCj4gPiA+Pj4gCWlmICh3YWl0cXVldWVfYWN0aXZlKCZwb29sLT5mbHVzaF93YWl0KSkNCj4g
PiA+Pj4gCQl3YWtlX3VwKCZwb29sLT5mbHVzaF93YWl0KTsNCj4gPiA+Pj4gQEAgLTUwNyw4ICs1
MTEsMTcgQEAgdm9pZCByZHNfaWJfZnJlZV9tcih2b2lkICp0cmFuc19wcml2YXRlLCANCj4gPiA+
Pj4gaW50DQo+ID4gPj4+IGludmFsaWRhdGUpDQo+ID4gPj4+IA0KPiA+ID4+PiAJLyogSWYgd2Un
dmUgcGlubmVkIHRvbyBtYW55IHBhZ2VzLCByZXF1ZXN0IGEgZmx1c2ggKi8NCj4gPiA+Pj4gCWlm
IChhdG9taWNfcmVhZCgmcG9vbC0+ZnJlZV9waW5uZWQpID49IHBvb2wtPm1heF9mcmVlX3Bpbm5l
ZCB8fA0KPiA+ID4+PiAtCSAgICBhdG9taWNfcmVhZCgmcG9vbC0+ZGlydHlfY291bnQpID49IHBv
b2wtPm1heF9pdGVtcyAvIDUpDQo+ID4gPj4+IC0JCXF1ZXVlX2RlbGF5ZWRfd29yayhyZHNfaWJf
bXJfd3EsICZwb29sLT5mbHVzaF93b3JrZXIsIDEwKTsNCj4gPiA+Pj4gKwkgICAgYXRvbWljX3Jl
YWQoJnBvb2wtPmRpcnR5X2NvdW50KSA+PSBwb29sLT5tYXhfaXRlbXMgLyA1KSB7DQo+ID4gPj4+
ICsJCXNtcF9ybWIoKTsNCj4gPiA+PiBZb3Ugd29u4oCZdCBuZWVkIHRoZXNlIGV4cGxpY2l0IGJh
cnJpZXJzIHNpbmNlIGFib3ZlIGF0b21pYyBhbmQgDQo+ID4gPj4gd3JpdGUgb25jZSBhbHJlYWR5
IGlzc3VlIHRoZW0uDQo+ID4gPiANCj4gPiA+IE5vLCB0aGV5IGRvbid0LiBVc2Ugc21wX3N0b3Jl
X3JlbGVhc2UoKSBhbmQgc21wX2xvYWRfYWNxdWlyZSBpZiANCj4gPiA+IHlvdSB3YW50IHRvIGRv
IHNvbWV0aGluZyBsaWtlIHRoaXMsIGJ1dCBJIHN0aWxsIGNhbid0IHF1aXRlIGZpZ3VyZSANCj4g
PiA+IG91dCBpZiB0aGlzIHVzYWdlIG9mIHVubG9ja2VkIG1lbW9yeSBhY2Nlc3NlcyBtYWtlcyBh
bnkgc2Vuc2UgYXQgYWxsLg0KPiA+ID4gDQo+ID4gSW5kZWVkLCBJIHNlZSB0aGF0IG5vdywgdGhh
bmtzLiBZZWFoLCB0aGVzZSBtdWx0aSB2YXJpYWJsZSBjaGVja3MgDQo+ID4gY2FuIGluZGVlZCBi
ZSByYWN5IGJ1dCB0aGV5IGFyZSB1bmRlciBsb2NrIGF0IGxlYXN0IGZvciB0aGlzIGNvZGUgcGF0
aC4NCj4gPiBCdXQgdGhlcmUgYXJlIGZldyBob3QgcGF0aCBwbGFjZXMgd2hlcmUgc2luZ2xlIHZh
cmlhYmxlIHN0YXRlcyBhcmUgDQo+ID4gZXZhbHVhdGVkIGF0b21pY2FsbHkgaW5zdGVhZCBvZiBo
ZWF2eSBsb2NrLg0KPiANCj4gQXQgbGVhc3QgcG9vbC0+ZGlydHlfY291bnQgaXMgbm90IGxvY2tl
ZCBpbiByZHNfaWJfZnJlZV9tcigpIGF0IGFsbC4NCj4gDQo+IFRoYW5rcw0KPiANCj4gPiANCj4g
PiBSZWdhcmRzLA0KPiA+IFNhbnRvc2gNCj4gPiANCj4gDQo+IFRoYW5rIHlvdSBTYW50b3NoLCBM
ZW9uIGFuZCBKYXNvbiBmb3IgcmV2aWV3aW5nIHRoZSBQYXRjaC4NCj4gDQo+IDEuIExlb24sIHRo
ZSBib29sIHZhcmlhYmxlICJmbHVzaF9vbmdvaW5nICIgaW50cm9kdWNlZCB0aHJvdWdoIHRoZSBw
YXRjaCBoYXMgdG8gYmUgYWNjZXNzZWQgb25seSBhZnRlciBhY3F1aXJpbmcgdGhlIG11dGV4IGxv
Y2suIEhlbmNlIGl0IGlzIHdlbGwgcHJvdGVjdGVkLg0KDQpJIGRvbid0IHNlZSBhbnkgbG9jayBp
biByZHNfaWJfZnJlZV9tcigpIGZ1bmN0aW9uIHdoZXJlIHlvdXIgcGVyZm9ybSAiaWYgKCFSRUFE
X09OQ0UocG9vbC0+Zmx1c2hfb25nb2luZykpIHsgLi4uIi4NCg0KPiANCj4gMi4gQXMgdGhlIGNv
bW1pdCBtZXNzYWdlIGFscmVhZHkgY29udmV5cyB0aGUgcmVhc29uLCB0aGUgY2hlY2sgYmVpbmcg
bWFkZSBpbiB0aGUgZnVuY3Rpb24gInJkc19pYl9mcmVlX21yIiBpcyBvbmx5IHRvIGF2b2lkIHRo
ZSByZWR1bmRhbnQgYXN5bmNocm9ub3VzIHdvcmtlcnMgZnJvbSBiZWluZyBzcGF3bmVkLg0KPiAN
Cj4gMy4gVGhlIHN5bmNocm9ub3VzIGZsdXNoIHBhdGgncyB0aHJvdWdoIHRoZSBmdW5jdGlvbiAi
cmRzX2ZyZWVfbXIiIHdpdGggZWl0aGVyIGNvb2tpZT0wIG9yICJpbnZhbGlkYXRlIiBmbGFnIGJl
aW5nIHNldCwgaGF2ZSB0byBiZSBob25vdXJlZCBhcyBwZXIgdGhlIHNlbWFudGljcyBhbmQgaGVu
Y2UgdGhlc2UgcGF0aHMgaGF2ZSB0byBleGVjdXRlIHRoZSBmdW5jdGlvbiAicmRzX2liX2ZsdXNo
X21yX3Bvb2wiIHVuY29uZGl0aW9uYWxseS4NCj4gDQo+IDQuIEl0IGNvbXBsaWNhdGVzIHRoZSBw
YXRjaCB0byBpZGVudGlmeSwgd2hlcmUgZnJvbSB0aGUgZnVuY3Rpb24gInJkc19pYl9mbHVzaF9t
cl9wb29sIiwgaGFzIGJlZW4gY2FsbGVkLiBBbmQgaGVuY2UsIHRoaXMgcGF0Y2ggdXNlcyB0aGUg
c3RhdGUgb2YgdGhlIGJvb2wgdmFyaWFibGUgdG8gc3RvcCB0aGUgYXN5bmNocm9ub3VzIHdvcmtl
cnMuDQo+IA0KPiA1LiBXZSBrbmV3IHRoYXQgInF1ZXVlX2RlbGF5ZWRfd29yayIgd2lsbCBlbnN1
cmVzIG9ubHkgb25lIHdvcmsgaXMgcnVubmluZywgYnV0IGF2b2lkaW5nIHRoZXNlIGFzeW5jIHdv
cmtlcnMgZHVyaW5nIGhpZ2ggbG9hZCBzaXR1YXRpb25zLCBtYWRlIHdheSBmb3IgdGhlIGFsbG9j
YXRpb24gYW5kIHN5bmNocm9ub3VzIGNhbGxlcnMgd2hpY2ggd291bGQgb3RoZXJ3aXNlIGJlIHdh
aXRpbmcgbG9uZyBmb3IgdGhlIGZsdXNoIHRvIGhhcHBlbi4gR3JlYXQgcmVkdWN0aW9uIGluIHRo
ZSBudW1iZXIgb2YgY2FsbHMgdG8gdGhlIGZ1bmN0aW9uICJyZHNfaWJfZmx1c2hfbXJfcG9vbCIg
aGFzIGJlZW4gb2JzZXJ2ZWQgd2l0aCB0aGlzIHBhdGNoLiANCg0KU28gaWYgeW91IHVuZGVyc3Rh
bmQgdGhhdCB0aGVyZSBpcyBvbmx5IG9uZSB3b3JrIGluIHByb2dyZXNzLCB3aHkgZG8geW91IHNh
eSB3b3JrZXJTPw0KDQpUaGFua3MNCg0KPiANCj4gNi4gSmFzb24sIHRoZSBvbmx5IGZ1bmN0aW9u
ICJyZHNfaWJfZnJlZV9tciIgd2hpY2ggYWNjZXNzZXMgdGhlIGludHJvZHVjZWQgYm9vbCB2YXJp
YWJsZSAiZmx1c2hfb25nb2luZyIgdG8gc3Bhd24gYSBmbHVzaCB3b3JrZXIgZG9lcyBub3QgY3J1
Y2lhbGx5IGltcGFjdCB0aGUgYXZhaWxhYmlsaXR5IG9mIE1SJ3MsIGJlY2F1c2UgdGhlIGZsdXNo
IGhhcHBlbnMgZnJvbSBhbGxvY2F0aW9uIHBhdGggYXMgd2VsbCB3aGVuIG5lY2Vzc2FyeS4gICBI
ZW5jZSB0aGUgTG9hZC1zdG9yZSBvcmRlcmluZyBpcyBub3QgZXNzZW50aWFsbHkgbmVlZGVkIGhl
cmUsIGJlY2F1c2Ugb2Ygd2hpY2ggd2UgY2hvc2Ugc21wX3JtYigpIGFuZCBzbXBfd21iKCkgb3Zl
ciBzbXBfbG9hZF9hY3F1aXJlKCkgYW5kIHNtcF9zdG9yZV9yZWxlYXNlKCkuDQo+IA0KPiBSZWdh
cmRzLA0KPiBQcmF2ZWVuLg0KDQoNCkphc29uLA0KDQoJVGhlIHJlbGF4ZWQgb3JkZXJpbmcgcHJp
bWl0aXZlcyBzbXBfcm1iKCkgYW5kIHNtcF93bWIoKSBlbnN1cmUgdG8gcHJvdmlkZQ0KCWd1YXJh
bnRlZWQgYXRvbWljIG1lbW9yeSBvcGVyYXRpb25zIFJFQURfT05DRSBhbmQgV1JJVEVfT05DRSwg
dXNlZCBpbiB0aGUNCglmdW5jdGlvbnMgInJkc19pYl9mcmVlX21yIiBhbmQgInJkc19pYl9mbHVz
aF9tcl9wb29sIiBjb3JyZXNwb25kaW5nbHkuDQoNCglZZXMsIHRoZSBtZW1vcnkgYmFycmllciBw
cmltaXRpdmVzIHNtcF9sb2FkX2FjcXVpcmUoKWFuZCBzbXBfc3RvcmVfcmVsZWFzZSgpIA0KCWFy
ZSBldmVuIGJldHRlci4gQnV0LCBiZWNhdXNlIG9mIHRoZSBzaW1wbGljaXR5IG9mIHRoZSB1c2Ug
b2YgbWVtb3J5IGJhcnJpZXINCglpbiB0aGUgcGF0Y2gsIHNtcF9ybWIoKSBhbmQgc21wX3dtYigp
IGFyZSBjaG9zZW4uIA0KDQoJUGxlYXNlIGxldCBtZSBrbm93IGlmIHlvdSB3YW50IG1lIHRvIHN3
aXRjaCB0byBzbXBfbG9hZF9hY3F1aXJlKCkgYW5kDQoJc21wX3N0b3JlX3JlbGVhc2UoKS4NCg0K
TGVvbiwNCg0KCUF2b2lkaW5nIHRoZSBhc3luY2hyb25vdXMgd29ya2VyIGZyb20gYmVpbmcgc3Bh
d25lZCBkdXJpbmcgdGhlIGhpZ2ggbG9hZCBzaXR1YXRpb25zLA0KCW1ha2Ugd2F5IGZvciBib3Ro
IHN5bmNocm9ub3VzIGFuZCBhbGxvY2F0aW9uIHBhdGggdG8gZmx1c2ggdGhlIG1yIHBvb2wgYW5k
IGdyYWIgdGhlDQoJbXIgd2l0aG91dCB3YWl0aW5nLg0KDQoJUGxlYXNlIGxldCBtZSBrbm93IGlm
IHlvdSBzdGlsbCBoYXZlIGFueSBxdWVyaWVzIHdpdGggdGhpcyByZXNwZWN0IG9yIGFueSBtb2Rp
ZmljYXRpb25zDQoJYXJlIG5lZWRlZC4NCg0KUmVnYXJkcywNClByYXZlZW4uDQo=
