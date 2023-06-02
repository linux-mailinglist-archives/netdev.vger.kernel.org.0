Return-Path: <netdev+bounces-7590-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC4E720BD1
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:19:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15F8E1C2122C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD36DC155;
	Fri,  2 Jun 2023 22:18:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09B7C13B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:18:59 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17F21BB;
	Fri,  2 Jun 2023 15:18:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iu2Q7b1iwgpmHasCqziMmbzqMApvL/vcegeDc/EY9G9sR5tUl2Ai5K6rTreMYBn2CtiApOoIyp+gpAKsn9CDaRw6THCNKp/oixbwd3ivHuAABy/amgx82jZPYOPbS3V1WKdwr3MW+3QGvw6/14om3QkiprItxFNhY37+T9DdP1ilMIdk5qCwn02fRl+G5eZfdYxsgM1pTJG66CIxtCDbo0ncSWTfC1jjVkjfAb2QgKtT+Dr0TzGYJp9fcFWMufyKGXCtTfqlB1Ihlo33VbpPrbHFU4MWA3Mgf55YQ0ZFr/MWgdMWddcRlwgBJlrNyGpzv5NvLjU50dVwhGyeWoWOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RZFIjZc8ESeQcba93MOLgPyQcxHfwi7AquoxqtOe38s=;
 b=K4CFsj3NXF1fbBpxrlMMmVPdRR52OOlcU7iOVepn+xNfTA0Xm5ttiE/soh7ImX9glzmk2p0RxmSbK2h8WIQaWG46RfsQGG1Tw58wYIheepZ2bgr/TTCg9h5ePGDZzI5u/pqjmFokZqHodvJth+C1VsLPCua/3q4GTULTJz6pfJ5TKMoRN01pQfceaVPCpe19vriw9tYNrjrDd9GYwyN8rJQphUcvaAWJ6Vnu+tGrS+XplwxFMQJiBUy9kg/DUYWBH814AubSSU7XwnYGKwEW0HuC+I4yjnt5wnoHbFAQ8v4PhEdm9oBdsIXyuWBg9Mod3ilt0rcEDQMIHr31t83IFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN0PR01MB6896.prod.exchangelabs.com (2603:10b6:408:16b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.28; Fri, 2 Jun 2023 22:18:55 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 22:18:55 +0000
Message-ID: <783511ce-8950-c52c-2351-eef8841c67da@talpey.com>
Date: Fri, 2 Jun 2023 18:18:52 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Content-Language: en-US
To: Chuck Lever <cel@kernel.org>, jgg@nvidia.com
Cc: Chuck Lever <chuck.lever@oracle.com>, linux-rdma@vger.kernel.org,
 BMT@zurich.ibm.com, netdev@vger.kernel.org
References: <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0073.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::18) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BN0PR01MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 008c83a0-f055-4076-ae96-08db63b75a88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2H9czzlagyT2fkIHl+sevMMnWKR6gbeG1ZedUVEp0pIEg+C/A6Ki28s86dVXmnr/KUYDTApc9cI3wo1bTghZe+jkJ9l5tOYhft0q+5vOCfiDwsLf9dwq+q/g29JUbAlENsEtpGfqd0QSwKWLMs4CIBFJpL01eEUZSjIyxF0ofx3Z9Pc1tzCBHufN6Y0JEUzeGtSCWd2XlMI7GHvWfLXoRu0Uasm6dx5U0CJHoek3ZjL6lTaK5d++MsANzDfrvzynRm3ZWubwuL8vzJGQjkSWZ9VFv1Mzz/iQZhyQGpxBZkAJEGyTEIhZuvQTEfKWvtjlnIRVedM7YQpo+nQrTlc9o18h3k0XErJ9qzXDc6RI+1UGNQPZQRt99GoR4DP/n8QBfB99zriO32vrUCPsQmt0IWn7GJIrCjP4oIz0xQ5JwMaAxJ1AN3VyIOdvG+IdGZTerzQIY3lgv9nTcYzD/ioKftP1FaycbmSxrkmZhu5qHOGAFmBhWJL2rn3e3u1TWlGfM/TrNn8KaYx9DpN8wJAJsdO/Try99u8+Yaj8Wigh2j3BdEIMWnSNPVD4APEM4EH/s4VtEjzHopzg+Kf8MiNAfmSKI2ZeZRZhhG/Ac0jejoqXrrKRKTbsZiB3SSWPvckg+ExCNxmRjdhVp+T1GEO0+w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39830400003)(346002)(136003)(451199021)(53546011)(2616005)(36756003)(6512007)(6506007)(26005)(186003)(2906002)(4326008)(66476007)(66946007)(66556008)(31696002)(478600001)(8936002)(8676002)(316002)(5660300002)(38350700002)(38100700002)(31686004)(41300700001)(6486002)(52116002)(83380400001)(86362001)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUhFazFQUmI0REFybkVOcmV6NVNBbjAvQmxlbUNpN0RHYUUxUmJXc1pIVjNz?=
 =?utf-8?B?dU1XQzViYXh2ZlZRZEEvSDZtZHRkRkhodUNxbElEZms1bDVFS0RQWnZyYnNN?=
 =?utf-8?B?R3pCTFRWQWQxWTdiZmFNZlhSN0dsYlZrSW1QaE9BVGdiVUVTUkV0UWV6YUVC?=
 =?utf-8?B?L0FiQzQzQmk4TE1ieDVDQ3U5b0FLZWRvbmtqY3ZZVDFHeEF1cHFML2FsWDQw?=
 =?utf-8?B?Q2FjYys4ZnVOaktyOE1ZTmkzeWZRK0dYR2V0eGhYWjg3T0crQldCT1B4eTdk?=
 =?utf-8?B?T212eDREUnFuNStBdnk1K0lxclh5bUNVVVIwMGo2NjY3OUo4RjNBalFJQTZZ?=
 =?utf-8?B?QTBKK1NwbE50VWZrU1RlcytMYkgwYXJnbjNoeEdvay9UV2tQRFhzV1hEQzU4?=
 =?utf-8?B?L1BSUW5TYWxsYjlnR2d6TDVYQXAvMFl0M2tJNmdDOGY1S1ZRZHVpVGRMUTVK?=
 =?utf-8?B?ZGpLWmNVU0t2WUloNWltMlB2SDdSU3VLaWQxQkZDRFg1V3NJZER2cDVSZmx1?=
 =?utf-8?B?djl4RzJLWForcS9vMG9aN3JHSVNhNS9VNEJqODh4eitVRzJKRU0rZ2p2dnBD?=
 =?utf-8?B?c3JCTTI2OHZFSUNncy9BZkl3cGR0VGdXYkdjWEp3Y2ZBc0w0L2VUZVpJZU95?=
 =?utf-8?B?Y1A3clVpdzc2cnB3amRuZXRKOFJzVU5UbGM2MERXNFhHdHJhV0ZjazZPUVNH?=
 =?utf-8?B?a0lDTjQ2d2tCdlhZLzhXemRMZWQ4WmJzeWd1dXlKb0lkVi94bGRFbFJHZ3NO?=
 =?utf-8?B?RTU0ODRML3YrSFZBM3dsbEpjNWF5YzhQaEZNaHF0ZEk4c1BJQUdxY0dlWHVx?=
 =?utf-8?B?TW1PamQ2NG41QlhUVlkzUkhmNjdRSXp3TWNFVUpmdXRPdmFpU1huZkF5eHJk?=
 =?utf-8?B?UWc3NWJFNWdzNWFjVFBNTHAwM1hHbEZjUzhSTFU2N3F2YXRJODdoaiswd1BU?=
 =?utf-8?B?eTdpNUZKZ3dvMjJuMy9nWXRNbzdLMjRWbDE3U0xTSmtSMGhTaTU0cmUrVXFp?=
 =?utf-8?B?b1FDSXJzM2tDWWdzZEhWbWJWTHBrUlFPRnA4d21XNTZkV0E2ZStIQlVoWlNZ?=
 =?utf-8?B?Q3ZYbXdPTzRXWEtsN3R3dkR5RWhhYzE3WWo4NGp5ZHMwQ0dGY3hxdno1d01a?=
 =?utf-8?B?VlJTaFdiVW96RDBFbEl2YmN4RWMzMTYwcjVuYjc2TFN2SGtlUGp0Vmh0ZVRk?=
 =?utf-8?B?bERxN3NRZ0xLeXV4azMzc0JlWGIvc2xnUW1PNlNDRUVvZ1lhMzhjWklYRDZ2?=
 =?utf-8?B?Szhxclhkek1taXhxQVFRRCs5cEVCSklBQUZVMnJrRUNwYkJOUDlzUkY1Q1dl?=
 =?utf-8?B?emc3UnBxMnEzelFEUEYyTFErVnJLR1pyZmdNbUFnV3RLb244R2xQTkV1MEN1?=
 =?utf-8?B?V3Z0SWo2T2JMOFRUOHp2U2JIOXM1c1FTd0JPbmxlZUJLT0hseGRwR3gzV3M5?=
 =?utf-8?B?MGZDemhqVXhqanhyNjlnSTlsNndNanlwa3RLQVBDR3NnalJKY29XRFVEYlZ4?=
 =?utf-8?B?TEZ4NFUxa3hJUU5HMUdaQ2hUVmp6My9sWkFubDdXOWFMTlNZRUdnQWpDbGVw?=
 =?utf-8?B?VHVqYzZNMEloejdiRUpHR0RBbWpjVDhudWhHSmJxbUp5RG9OTFZuZW1oMFlF?=
 =?utf-8?B?M3czWGRkcnlVc2YrU0pBazVqb0RwSDdNcWwxclVnQ3JwQjNrV0N1WDMvbnk5?=
 =?utf-8?B?Tm1EK3pLOHRXRUROZWQwdE0vWG5JUmZMZDVWUGxaMnMyZXhZWmg2U2MwRkVt?=
 =?utf-8?B?V1JWYVhCaFU4NVduM2FLaXRiaStTOFZSNmVNU1lpbFVxRSt6WlkxNDZvNkxR?=
 =?utf-8?B?TGkxNm1pQzBSRDlhK0tLZUJ0TnZYYzZJYUdadlh0SmVKdE1waFhFRExUUVNl?=
 =?utf-8?B?UEVhVW9LdFNmck9pYmhhTVhpaUFmMU9TN1kxTnNPbXBIcnkxOHNUY3NjcmRP?=
 =?utf-8?B?VWpGZTVQWTZneWpFQklmNytFSjJtS1Q2K1lMQnJPWjN3enlzTHhlejFKOUdK?=
 =?utf-8?B?cWdiT3ljT3Z6dEQyMW82OUM3cldqZGNRMGQ4SDBpTFp0R2hWR3hmbG1GTEpI?=
 =?utf-8?B?ME15bEZNcm1GM2VNNlo0YmZUWTBJcVlBaUNQYmtIWUx3bERXb2N5TitVY3ll?=
 =?utf-8?Q?p149UtE+H/TPoOFR3wrUOcWdR?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008c83a0-f055-4076-ae96-08db63b75a88
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 22:18:55.4418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rkkLGdEmRnW+2Sku7IeMdtxYZhWDq7cPXb5az2nAaWYRuaD9flOyXwaJXLGEm9J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6896
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/2/2023 3:24 PM, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> We would like to enable the use of siw on top of a VPN that is
> constructed and managed via a tun device. That hasn't worked up
> until now because ARPHRD_NONE devices (such as tun devices) have
> no GID for the RDMA/core to look up.
> 
> But it turns out that the egress device has already been picked for
> us. addr_handler() just has to do the right thing with it.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>   drivers/infiniband/core/cma.c |    4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 56e568fcd32b..3351dc5afa17 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -704,11 +704,15 @@ cma_validate_port(struct ib_device *device, u32 port,
>   		ndev = dev_get_by_index(dev_addr->net, bound_if_index);
>   		if (!ndev)
>   			return ERR_PTR(-ENODEV);
> +	} else if (dev_type == ARPHRD_NONE) {
> +		sgid_attr = rdma_get_gid_attr(device, port, 0);
> +		goto out;
>   	} else {
>   		gid_type = IB_GID_TYPE_IB;
>   	}
>   
>   	sgid_attr = rdma_find_gid_by_port(device, gid, gid_type, port, ndev);
> +out:
>   	dev_put(ndev);
>   	return sgid_attr;
>   }

I like it, but doesn't this test in siw_main.c also need to change?

static struct siw_device *siw_device_create(struct net_device *netdev)
{
...
-->	if (netdev->type != ARPHRD_LOOPBACK && netdev->type != ARPHRD_NONE) {
		addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
				    netdev->dev_addr);
	} else {
		/*
		 * This device does not have a HW address,
		 * but connection mangagement lib expects gid != 0
		 */
		size_t len = min_t(size_t, strlen(base_dev->name), 6);
		char addr[6] = { };

		memcpy(addr, base_dev->name, len);
		addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
				    addr);
	}


Tom.

