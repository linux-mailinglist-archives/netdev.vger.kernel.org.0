Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28272B1EF0
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgKMPlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:41:03 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:56924 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgKMPlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 10:41:03 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5faea90c0001>; Fri, 13 Nov 2020 23:41:00 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 13 Nov
 2020 15:41:00 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 13 Nov 2020 15:41:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njkpAC2gWHreyOqo3TEFMJUXlxl24/es4V58j01TUyTuOD+1nIscUvHdw4ZaJUcm8IRtg6evVnACuWWLQmuZRVUnqRHddjPOefekLY4wOkeQ/oa1MhbY7QjfH60hwEioOlZip2j94ehgxFoY+1cbltjWyjHmeXXUi0RpG5KCRX9xDg72TUyG5PYFvyeZY9ld1P4OKLq/FFnczVhHvTXVm4evZ/c80E7WdTOXlzOg0zjcQoNuUDC1f4y1dKIAlp0Inki1jEBFFMEvg6hJcFsQAg0Qx9Ixq180nK42VPYP6Qa3XAA6emKnYUOTpzO50rE9duKTpZlyF6SqNC//6nVtdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+KuIIXFqnWGvlPOMA5X0xoMQhOhPfXNUQe9VV3xe3c=;
 b=Tui4I8zSarprLp8vVIDdtvd72U6f/LsNx1RRaBd4kp8itiCtAWFGJ904XHptW7kj0ZN/yjcf0GDGOrg9xRuqyle4OcUdGos0uMMC1MMY9TzjxgmjqmEkntsr/8VOEGBS16ueVzPlal+359+HAXRixf8PBI7+3I+LB9r1hz1g3pCtMguO1EHEmpOHG6aeVDv5vLwfxurHkyWBGnC37lQvc1g23AsDfUn0pE+Woa6yw6YHlXbd/5irc/P+Pll219su22c/ovbQd7s9rMBfRsytVao5licZfAW3gT8Mmafe4S86Rqe4NBK8yNr7UuTOMlMNKIkJGppiC+MV2SvyWq8fQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: azazel.net; dkim=none (message not signed)
 header.d=none;azazel.net; dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3174.namprd12.prod.outlook.com (2603:10b6:a03:133::16)
 by BYAPR12MB2935.namprd12.prod.outlook.com (2603:10b6:a03:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Fri, 13 Nov
 2020 15:40:58 +0000
Received: from BYAPR12MB3174.namprd12.prod.outlook.com
 ([fe80::c40f:9c12:affa:8621]) by BYAPR12MB3174.namprd12.prod.outlook.com
 ([fe80::c40f:9c12:affa:8621%6]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 15:40:58 +0000
Subject: Re: [PATCH net-next,v3 5/9] bridge: resolve forwarding path for
 bridge devices
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <jeremy@azazel.net>
References: <20201111193737.1793-1-pablo@netfilter.org>
 <20201111193737.1793-6-pablo@netfilter.org>
 <4670e6a2-1a80-0edc-d464-52baf95cf78c@nvidia.com>
Message-ID: <d20f122a-8dfd-2da9-ddf3-7516184de26d@nvidia.com>
Date:   Fri, 13 Nov 2020 17:40:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <4670e6a2-1a80-0edc-d464-52baf95cf78c@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::10) To BYAPR12MB3174.namprd12.prod.outlook.com
 (2603:10b6:a03:133::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.187] (213.179.129.39) by ZR0P278CA0095.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 15:40:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b15c509f-da88-4c6f-f573-08d887ea83f4
X-MS-TrafficTypeDiagnostic: BYAPR12MB2935:
X-Microsoft-Antispam-PRVS: <BYAPR12MB29355B52CA0B8E9AAA0C7737DFE60@BYAPR12MB2935.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSab1JpvGVVBJe6Y5GUSsXVJT12m+r/TeKS366BgmmbjcgICxoR8/DH5Op+9oA6z/523+FDZzx4daXGGEbEgMLXbnmpdIaskmUT9ZBgqgPaVyhKyGsqpqzox92gNNd+UQxMfK/eRqNi7xrs/k3cRievIDuE5AWGFO5fArDK4KMPWPiMQbiMpSAyRK3ag4vNMst2dtTxvoDbTuQlAWKUO+QJow1xM6rn2iFEo/YFLDKP1qpcxbE8AJBl0QtLSG1EKaoZ89efOL+Q/znRkOvG94jhT4KlmiyD+WVrElx0BmlbZivS8wpsp+MbFz4w3/RRD/AFEUGXcZfAvFwTIQ7PUHxBu1aVnSNBbD8BiFmBuqY1NoM1DVXjYLOH3tqSEFg8L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3174.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(186003)(66556008)(66476007)(478600001)(316002)(31686004)(86362001)(16576012)(5660300002)(2616005)(8676002)(53546011)(26005)(36756003)(8936002)(956004)(66946007)(4326008)(16526019)(6666004)(83380400001)(31696002)(6486002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P8n/9mEzUJ8IGMhTDlxhV0uVsMm3syFSJwYK9JEtfDmuRELBbSh5eFASg0I/vOIeW5S3xRNT0hT2SYKHeH5gjO76nv/JEVO2D21Oh2C4fe1z6yVW9eYxuUs+kbaGNH4mQTMg4b3pegdqePxXjn4aUbniucG7olsdC+tkjz2C6giKAk03LoYhTwvRZz1N8ghVuDJKJPYhfAD/i4viJWYCoJIjzJjJYr1wWLtz1dhFpUgNKWgyid3IB8kfk6EdjSujxvCt1zArNE8RiBwCV6HeADkdVgA/p2EAmi6AXLNSbk3PxHm6KZMTGtHep7emYDm45slmkMPgshZ7I1z9g1rZltUlkyYoGIbGXsvu6khqRDfgrm8/Nq/9ywaW+cJJBxPo5fv0PU70MdwYQtpkOQc2AoffX+yjokJDKoDy5DGshP3qCw48odyG6K8/rch/cIFQTyze2vE5QR9C6QlZ3scNDs9cHs+NgIgVb3fPBQq66LX3oFvkjRhaoeRX7TvRovQg7Z6rZyx/9n+5yEpnKqg076e9twf7dCDF3ohCvTV0szJ3bX1br7loMIRyx8sgUJpT2m50rtvYzL2AuL4QvOLgliNOrXIiIOr2jnvYbu2EqAE+JUq8xW/J+n9jOEygRDbTQHX4cZCZULiB0LRcPPwegA==
X-MS-Exchange-CrossTenant-Network-Message-Id: b15c509f-da88-4c6f-f573-08d887ea83f4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3174.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 15:40:58.1899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pUYdujn+cIzuDEHCtwyWy+fu4LxFSN0zfwptM5137p9gaOpQN48eodu5dh8DUn0bXnSRcT+Cn5J6XsB9Fb8MAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2935
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605282060; bh=u+KuIIXFqnWGvlPOMA5X0xoMQhOhPfXNUQe9VV3xe3c=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:From:To:CC:References:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=sDGvo9pOZ/GEnKqEQAHrzU8Y5pxzcQ73TXSKmMNkjZe8+BRbZv2zhXLMbgQYFYTBh
         DK2grM//ACTZC9ch6HupWZD32QJNgRfY8+InSh48sp2xjEk+BtkG41UPRu3SM4C/5i
         WOs8deKAZyYKsdEEvo+q5+Gct00gGIjzHaMh7CWCx51L02gHD8/k2e/9yxlGKF+zEV
         RNCqv7DciXbqMwJXaz/rv//JFZfznL/4uBKZEdceVmz/O5tIAgu+FSmF25A1MHcnZw
         HCNLtgqWvjK+OEqO4KP2F6YkG5gSRBIyHZKlqIcOX5dlYIs1zOWqJ6CmpnKgdPVZeS
         MPkBEvgowCsOQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/2020 02:53, Nikolay Aleksandrov wrote:
> On 11/11/2020 21:37, Pablo Neira Ayuso wrote:
>> Add .ndo_fill_forward_path for bridge devices.
>>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> ---
>>  include/linux/netdevice.h |  1 +
>>  net/bridge/br_device.c    | 24 ++++++++++++++++++++++++
>>  2 files changed, 25 insertions(+)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index ca8525a1a797..d26de9a3d382 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -836,6 +836,7 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
>>  enum net_device_path_type {
>>  	DEV_PATH_ETHERNET = 0,
>>  	DEV_PATH_VLAN,
>> +	DEV_PATH_BRIDGE,
>>  };
>>  
>>  struct net_device_path {
>> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
>> index 387403931a63..4c3a5334abe0 100644
>> --- a/net/bridge/br_device.c
>> +++ b/net/bridge/br_device.c
>> @@ -391,6 +391,29 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
>>  	return br_del_if(br, slave_dev);
>>  }
>>  
>> +static int br_fill_forward_path(struct net_device_path_ctx *ctx,
>> +				struct net_device_path *path)
>> +{
>> +	struct net_bridge_fdb_entry *f;
>> +	struct net_bridge_port *dst;
>> +	struct net_bridge *br;
>> +
>> +	if (netif_is_bridge_port(ctx->dev))
>> +		return -1;
>> +
>> +	br = netdev_priv(ctx->dev);
>> +	f = br_fdb_find_rcu(br, ctx->daddr, 0);
>> +	if (!f || !f->dst)
>> +		return -1;
>> +
>> +	dst = READ_ONCE(f->dst);
> 
> While this is ok, I meant that you have to test the ptr after. In theory between
> the !f->dst test above and now it could've become null, so to make it future-proof
> please test the null dst after deref, after the READ_ONCE(). I realize currently
> there are still problems after the change but we'll fix them.
> 

On a second read this sounds too vague. :) I meant that there are still similar issues in
the bridge code today which I'll take care of. For this patch what I suggested should be enough.

Thanks,
 Nik

>> +	path->type = DEV_PATH_BRIDGE;
>> +	path->dev = dst->br->dev;
>> +	ctx->dev = dst->dev;
>> +
>> +	return 0;
>> +}
>> +
>>  static const struct ethtool_ops br_ethtool_ops = {
>>  	.get_drvinfo		 = br_getinfo,
>>  	.get_link		 = ethtool_op_get_link,
>> @@ -425,6 +448,7 @@ static const struct net_device_ops br_netdev_ops = {
>>  	.ndo_bridge_setlink	 = br_setlink,
>>  	.ndo_bridge_dellink	 = br_dellink,
>>  	.ndo_features_check	 = passthru_features_check,
>> +	.ndo_fill_forward_path	 = br_fill_forward_path,
>>  };
>>  
>>  static struct device_type br_type = {
>>
> 

