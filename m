Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1360557C6A8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiGUIn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGUInz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:43:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F7725E6;
        Thu, 21 Jul 2022 01:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tye+PmZe3D9rRh4LL4TMAQkImPY3FGDiurXVMmNDo6ulYyFXriHbFRp27f2Fk7lb2avjxVaHa1OY08vJ79wRy+ejRbtXjCEYAIcOcyavT7JeYzEFdEOKSsTVJFlqt+I+zEDnqMR5bgN6MSXgP275Q/KelKSPEIKeQFT25WiKWGdVfLQpljE5didPTexsV8pUcYWSUshllHEjH+B85WdQ2WZA7fgxZQsy5hLHti+1kGh0/sjonbGjfGMejhWrX8rG7nn0zF59SN+DB7V4IFg20i38sD1Tzf58DngwZQfX3FTAQQzKJg+c4lkMFxRImf1dOLIHSo4CJe720VAOAp2wWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9z12CyAqLmPIu60/eG85EQVDFoB3C905mAa8Q1MH8R4=;
 b=AmZtlHvOc0SELBXaGXsFuwGQ2T2x1993Ua6hLOIo7yUebN5p9Oif+5dbrbwzabo00tn1m5zlTv9X86nBGLR1/DUZlm0lFfU6LUeW2+GKz3KH95AOs44LCob59AtSPy1PRBOG++gKfm/o+Nvjv3p6AL7T1EY8u0Rq72OHp7g7E1qoOhSM+DMYpcwgbWGmlkEzLf01iHK+SSgR43mx7PIbfVORF+vE56xDQp7Y6A8Te9K09ZvWruJfD5mcurH0EhDeyhL4yiJqRUaoHJsbsQtyOLNUG1BuhWLOz0q/Jbs7Wl1nLT4lJztwqZ1x0lNJyDz7g/kiGk9rNA3ZzAckYGdwGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9z12CyAqLmPIu60/eG85EQVDFoB3C905mAa8Q1MH8R4=;
 b=J1leOhtx669H/PhgdHzU2ndeL3XcnsmUNRQNN0TRU419JtHgIVpqq1OYM2/33jbiWNp/fmrtfPRL+RAJBzob/7BlUTckl2BsPY0DOtDA56tEY8UjNq+NEIYa0TpycvKsne5n8jfxoaJTjQEx9KuYM5GzsU/3giKmE3YaPxMPt8byu4ergYjYDTMs4OQ8vaB3M6YQ+RPa19IB96+ttJOeoZkk8tu6SQtbd4t8ve78/K06yltqi7AV6HHCGKlGZ/s/fxoVJYwe7iuXd4cBPZiv1vTANNY9xV1bPMfh2v3XM1AM31QPKuqTvj/3w4p959MjkzNVJ0wi3SKf8UFAz6d1nA==
Received: from MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34)
 by DM6PR12MB2666.namprd12.prod.outlook.com (2603:10b6:5:4d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Thu, 21 Jul
 2022 08:43:52 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::c3) by MW3PR05CA0029.outlook.office365.com
 (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.16 via Frontend
 Transport; Thu, 21 Jul 2022 08:43:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Thu, 21 Jul 2022 08:43:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 21 Jul
 2022 08:43:52 +0000
Received: from [172.27.14.243] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 21 Jul
 2022 01:43:48 -0700
Message-ID: <87757a16-60ad-1228-36d3-8eb640fde392@nvidia.com>
Date:   Thu, 21 Jul 2022 11:43:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V2 vfio 01/11] net/mlx5: Introduce ifc bits for page
 tracker
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-2-yishaih@nvidia.com>
 <BN9PR11MB527622A46E2C50C13E7AD4708C919@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB527622A46E2C50C13E7AD4708C919@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63aa2509-95f3-4115-5c36-08da6af523a5
X-MS-TrafficTypeDiagnostic: DM6PR12MB2666:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ior/EMqkJcddjmAltM+LpqlWTYe9iCB18dJtarmi8wls51LjWsSEryfL472irpIzd7hEkOyPEi/w7wKE3ovq9U42imu6bNdFojrmyzQ7k/5rOnnZLLOBJm8r6ZmCapkD8IX680lVW5dHjbbE2PEX9mk15mN3/uTT+ZeAdPyZXHzKacguxBS/5tNz1b413uwBh+FtnDplKoEK/3NKlLWhIg2eGXQIL7u8E/26X65qU4ngz/leHj4pkfizIFkkoMLAARZ3ZXidRG2SvdS+HX/pF7OMF04aF24OE9EIt97bAi9BMcrfNsHAUxU1hyxml1/fgOOChWYbcHb6S+Fb4uxSvP9ZhCxlLE+eZVuHfOmauofvT9Dhad7g7NbxRhg/Fbn3rvbE+7EQtRVQ48TFeUzR0kAwDBSCwuNyHLNyeWll54JbmTgCSm3p+bHhLjDD2UTzciMdcMQm0P8M8j03oIQ95Ou1HOi6bxiWvoPYGRhZ6aj6BRIV/qF7yQixD2ePSeBIAWuozOvxDYpH5Z/AvFalkMWte0u9tH8jba0lVBjbOy3jfL9xUuMm4megEEnYM2prgLTfGtwK9ssrdL/utlatc2aK2uXcclVgfzm+3M1cRd6p4WFWh1Hy6ZTSEG5DB0dA95QrqaMfUBcZ0jLnBYVz1mInTqByLWHsAjGN9j4+vw/d2ZoJH8Havke+fYCgmPbN2YvnpzK9c6uvpLrONrCt8IAfsZBfXfozpiWVgFwOVAlCFIcRhK59EdgdW4njN83Uq4fuibnkEqjH8cYQ2kPyb6xJImBPa3pxG7y5tNi1D9Wn6dCyKGTMqSQs68zt7KI4fgFh0uD9nL/AyFW9dUeKh7FfcxQ3aZbjTCs6OF8QhPe+i1zMzDJCwzD5uTYSEi3g
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(346002)(136003)(36840700001)(40470700004)(46966006)(4326008)(356005)(8676002)(110136005)(70206006)(426003)(40480700001)(26005)(186003)(82740400003)(16526019)(2616005)(8936002)(336012)(4744005)(31686004)(5660300002)(81166007)(47076005)(36860700001)(478600001)(86362001)(31696002)(6636002)(83380400001)(16576012)(2906002)(70586007)(41300700001)(54906003)(82310400005)(316002)(53546011)(40460700003)(36756003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 08:43:52.2980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63aa2509-95f3-4115-5c36-08da6af523a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2666
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/07/2022 11:28, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Thursday, July 14, 2022 4:13 PM
>> @@ -1711,7 +1712,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>>   	u8         max_geneve_tlv_options[0x8];
>>   	u8         reserved_at_568[0x3];
>>   	u8         max_geneve_tlv_option_data_len[0x5];
>> -	u8         reserved_at_570[0x10];
>> +	u8         reserved_at_570[0x9];
>> +	u8         adv_virtualization[0x1];
>> +	u8         reserved_at_57a[0x6];
>>
>>   	u8	   reserved_at_580[0xb];
> any reason why the two consecutive reserved fields cannot
> be merged into one?

This follows our convention in this file that each 32 bits are separated 
into a block to ease tracking.

Yishai

>
> 	u8	resered_at_57a[0x11];


