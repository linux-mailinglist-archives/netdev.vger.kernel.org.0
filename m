Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E01C51ED91
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 14:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbiEHNCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbiEHNAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:00:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B34E000;
        Sun,  8 May 2022 05:56:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1T8z+bzE9FRviWQ42r46aHPMXNyYi9vmyTrEWEKoYYk2PyjA7VNVUxBHmRUAXsuQiv015eTpNGtncJXwCwzNMVyftH6zSERcWS+Ivaj/qVu85FPJL6ojPWBzL47rU3mkzvdrf0ofJ+KFXgsG5NLQB6pFgdRAqGANtHAmRnkV34oCrsxBHXevvgkxW7GvhF6t9tLMS420wvPEasyEaB9semca81kJw3MfszIz8YRXZQKabSCJUxP5tHXunjXU0pDqnkPBUDvdPoiFsmlHSElwK5iqqPGAo2i1OB8JmFPD4hklCDSiUeTgnIXJThi77CfG++mOQw0WSR69kz44YkhuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBaJrLznBlMSr6Fi262QxR4X7PpfekxB6ke3GfKf4uA=;
 b=Bn8mCbLRl2eIlMLku/P9KZTxanWVWBKludqoTVDqjjNNTyzpSfDfxc3R1Z1mOwYjQtuurJ3GPKKSjZG4hJtaq2gBck6sfctS1iZZuw1pMREObYQH6qYF1cVRUUdxOdxnfZX2ww2qhMWbwTxeO/qVUfBYR8wIybUnNeYRxlUiv71cxwj0H5DGVjY8ZlK0BzlfLYLln714YxSM06HhHmpCWQ4MU+WcdcBduAlXmYLi1qZ59jdCVafos/lHRPo/ueVM0Sb9Xw6vNDDeZf72yCCpD0IGAstwLkQw7ac4jJnMfLBKtK2golvK3E5qROpaxy+cAoTIbLTplyx/bD8sSBeUdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBaJrLznBlMSr6Fi262QxR4X7PpfekxB6ke3GfKf4uA=;
 b=eCn3Q0FvtvOJBJoxpGytqJN1GMwjK+Bxx2k1n26Kbo3e04hww/35s1l9BBhaqblol8Z3utX9uy1nhilQBKjYmUZPcizSzS2VNdt3MWUjb9lDW4PBwgvqX7J5y8rq3Brk3Pxndo18HZm6U0OrA11Zc/uAXEfeppA3pTNiaycgdgmFaOebinFshW1PL1MAZYS85W7PwLg3NStwQLMdwM0pdElpOZFtaQ7KVmP29QT9wIffQXhNcEQu0W6adVaWkM/A4Kh735JL+OAhlhVyH6Kzkz56sCl8rEcV+tWRKx0vpbXGboy1q4q06DlsayzTJQCkKYj/hnbd03z2pigwu6sTQA==
Received: from MW4PR03CA0137.namprd03.prod.outlook.com (2603:10b6:303:8c::22)
 by PH7PR12MB5952.namprd12.prod.outlook.com (2603:10b6:510:1db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Sun, 8 May
 2022 12:56:47 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::f0) by MW4PR03CA0137.outlook.office365.com
 (2603:10b6:303:8c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Sun, 8 May 2022 12:56:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 12:56:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 12:56:46 +0000
Received: from [172.27.15.27] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 05:56:43 -0700
Message-ID: <f66e171d-2969-ee69-25e4-4645b567f996@nvidia.com>
Date:   Sun, 8 May 2022 15:56:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH mlx5-next 1/5] vfio/mlx5: Reorganize the VF is migratable
 code
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
 <20220427093120.161402-2-yishaih@nvidia.com>
 <20220504141304.7c511e57.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220504141304.7c511e57.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5611ad79-609f-4c6c-71ea-08da30f235d9
X-MS-TrafficTypeDiagnostic: PH7PR12MB5952:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB59522DB30189BFA19232F2B1C3C79@PH7PR12MB5952.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fohVK7py5wU4FmtRejZP0fAOOVgbZY2wQ6scGoDlCwklJM85iwJgJSX76suTxc1rBq9SyBTEGj0lxakGjsb/CI3nxk8Jhi5Ayx/WWfXkDHpqeZOCRTyv0jzP0ieOreIfNYtbDegrnAF4Q7c9Ircw3oCog8IePHrdWC9ejeeH21pzH2RSPS+cNo3oqJhTiUkWSLhhU+JH4ut0CWAHnrN5BM+UwU5wizZruq17pJkFNAlc1iJPWF7DW8gez9adA1tM1vYZIOSlq4SYcXBwqrSz5x8Pqhi2mCrswR75NTo3N4uFDIaMtwBcjGahsW78ZV3WqpZM+uD0PwMlDnivXRvrOvrPXKg6xo4GuTQgPQYjXXihcKJAl9o8QfY/73n0U5crbCnKLC7wD553O6zYrp+bdmPUsvW4mi4uLR5oAhAAf4itUsxT0QFwCVZgcdE0oD2/PewZHenE2zUY2OdE7r8ubr8Qp687berlXrP3zxgS8i7Gpxq7PWRUHgCuVqvnPki3FZG8fNCUr2N8q5ZXwROwsZc9d0ubUNo0512tOVLUwlNShIKm7pAASyXXUlsj4mO7eVJxVIJiKS4NSlKed+UULSEBnzpEJ24ut5MSBBRQ3ZqXh9beCjEpFNHHk7WwmzzeRiZV6D2TcYG2uHWnRU6lKQwdkH5McDC9FyxrU1jf9D/hkrYHFf0z5YbseN/Zz/KdpBZEhZL7Pj3OvTSyQIA8Fpxvr3hM4pWCwWRqKcYNl6rIjgpjA++GHLNyCTqtROmg
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36756003)(31696002)(86362001)(186003)(2616005)(16526019)(83380400001)(47076005)(426003)(8936002)(336012)(356005)(2906002)(81166007)(5660300002)(36860700001)(70586007)(70206006)(508600001)(8676002)(4326008)(40460700003)(31686004)(16576012)(6916009)(54906003)(316002)(53546011)(26005)(82310400005)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 12:56:46.8758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5611ad79-609f-4c6c-71ea-08da30f235d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5952
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/05/2022 23:13, Alex Williamson wrote:
> On Wed, 27 Apr 2022 12:31:16 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> Reorganize the VF is migratable code to be in a separate function, next
>> patches from the series may use this.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c  | 18 ++++++++++++++++++
>>   drivers/vfio/pci/mlx5/cmd.h  |  1 +
>>   drivers/vfio/pci/mlx5/main.c | 22 +++++++---------------
>>   3 files changed, 26 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index 5c9f9218cc1d..d608b8167f58 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -71,6 +71,24 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>>   	return ret;
>>   }
>>   
>> +bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev)
>> +{
>> +	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
>> +	bool migratable = false;
>> +
>> +	if (!mdev)
>> +		return false;
>> +
>> +	if (!MLX5_CAP_GEN(mdev, migration))
>> +		goto end;
>> +
>> +	migratable = true;
>> +
>> +end:
>> +	mlx5_vf_put_core_dev(mdev);
>> +	return migratable;
>> +}
> This goto seems unnecessary, couldn't it instead be written:
>
> {
> 	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
> 	boot migratable = true;
>
> 	if (!mdev)
> 		return false;
>
> 	if (!MLX5_CAP_GEN(mdev, migration))
> 		migratable = false;
>
> 	mlx5_vf_put_core_mdev(mdev);
> 	return migratable;
> }
>
> Thanks,
> Alex


V1 will handle that as part of some refactoring and combing this patch 
and patch #3 based on your notes there.

Thanks.

>
>> +
>>   int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
>>   {
>>   	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
>> diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
>> index 1392a11a9cc0..2da6a1c0ec5c 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.h
>> +++ b/drivers/vfio/pci/mlx5/cmd.h
>> @@ -29,6 +29,7 @@ int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
>>   int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
>>   					  size_t *state_size);
>>   int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
>> +bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev);
>>   int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>>   			       struct mlx5_vf_migration_file *migf);
>>   int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
>> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
>> index bbec5d288fee..2578f61eaeae 100644
>> --- a/drivers/vfio/pci/mlx5/main.c
>> +++ b/drivers/vfio/pci/mlx5/main.c
>> @@ -597,21 +597,13 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
>>   		return -ENOMEM;
>>   	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
>>   
>> -	if (pdev->is_virtfn) {
>> -		struct mlx5_core_dev *mdev =
>> -			mlx5_vf_get_core_dev(pdev);
>> -
>> -		if (mdev) {
>> -			if (MLX5_CAP_GEN(mdev, migration)) {
>> -				mvdev->migrate_cap = 1;
>> -				mvdev->core_device.vdev.migration_flags =
>> -					VFIO_MIGRATION_STOP_COPY |
>> -					VFIO_MIGRATION_P2P;
>> -				mutex_init(&mvdev->state_mutex);
>> -				spin_lock_init(&mvdev->reset_lock);
>> -			}
>> -			mlx5_vf_put_core_dev(mdev);
>> -		}
>> +	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(pdev)) {
>> +		mvdev->migrate_cap = 1;
>> +		mvdev->core_device.vdev.migration_flags =
>> +			VFIO_MIGRATION_STOP_COPY |
>> +			VFIO_MIGRATION_P2P;
>> +		mutex_init(&mvdev->state_mutex);
>> +		spin_lock_init(&mvdev->reset_lock);
>>   	}
>>   
>>   	ret = vfio_pci_core_register_device(&mvdev->core_device);


