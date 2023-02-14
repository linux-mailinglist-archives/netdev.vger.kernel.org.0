Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BEE696CE8
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjBNS3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjBNS3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:29:13 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A1C2E0DC
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 10:29:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WYRN8eCoYgQF0GizrZYmi5EsPM58uzjvdoOYU/4fEjHq0xacX9PMb+XUPDEbiIUrOli+OD3M5IKgMLO+P4HZ31n4lSuAHynv+4uiq4l4cg/AxxUcQ5BJeA+n5GexRA/hfuk76vgcFH3eNLaQAEk38QEAQcTpto8sK3WyDgXZmimVunL+ddZAUt73v7/vWpsKLW5u9GVdPYEClPtkeOxP+2DbbTGg9T8r4LZ2Cxp8j7hxe0Mn27Cyx6EcoQ7DWZt6o4CkYp8Na3KH/vx+ZlkrOoItWwbCzfzAYna5OAtz8u9Jex0ap6VnkHeOBIDi54AiJR38RyrC2pHvNbIbRMRCrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oH1jy1JG+9gOgdqY2WLNE4Am3xjtjn4OryrKuMwBGiA=;
 b=b0ra5T9PKrpAOQxpU+bSmXO1P43FY7JO5rXzKdt79tz+i+3PobJi97maZK9Lqufpf+fxWGChR1Nwhx2vye+vKhS49RGFj9rCbn+t6d0dpKwW+Ut4ecWILRCos3lLFjpW1uPTfvcboRXGey2cAVVagSIzzu32ILsHstXKL8TaKdQFq9XJeA2QFID5lDn0hHtM8TcaU029lJWjWLrYjarG4vK7EuBJ1zBGku6YJRJhrphqyyCwgOcjnuq4vQLvsmdfUPxcwchbkJBqgr4Vxsqsw6MeoTozv1LHicJyfzK9+T+L5QLi/H6UOd12UizxglEfv5+cPnCyXYHd7N6xTD7n9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oH1jy1JG+9gOgdqY2WLNE4Am3xjtjn4OryrKuMwBGiA=;
 b=mqQLTZWXIPlYGdzS7qsZPb+hjllnkr9sZrcTNEsoJYu2v18BUC6YFo7WS1Bj2zb34zwiogdFJfFOzkaniVpnGIU2fUBKM46J4OmXoQ0S/QsCEXcEzvfV5NjTg8WdF93B3Cp1RdaUTyPtUqE2qVCqXDpUdCn1QnlshbdXkBjiwwc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM6PR12MB4186.namprd12.prod.outlook.com (2603:10b6:5:21b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26; Tue, 14 Feb 2023 18:29:10 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%6]) with mapi id 15.20.6086.022; Tue, 14 Feb 2023
 18:29:10 +0000
Message-ID: <8db21c13-b1d7-ad8b-08ce-590e1f06743f@amd.com>
Date:   Tue, 14 Feb 2023 10:29:07 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] netlink-specs: add rx-push to ethtool family
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
References: <20230214043246.230518-1-kuba@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230214043246.230518-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0179.namprd05.prod.outlook.com
 (2603:10b6:a03:339::34) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM6PR12MB4186:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c5217c0-444b-4861-1541-08db0eb95d68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3m4wcoMi1SayUnoUaskOc3p71416pG9ZoqA/gV4eorwi8aghmOwQMleDtWXteZgevfkiY3u1IEJtIxp2xQdrTFm5qA/5j/HkIpqkV0fsMC1VQfWbqeBydswanzohq1Dw9Rw6HDHKcUXEKGBTj6MMKkP72Fu0sfqSjKe7vlKdgolwVBy+cehMh782clCoyZc8tHOGNHtni8XB4UrOgn5J1pkNFB1vqQPtEmgaDMGGj/51/uSKyAlwPZU/1QEC/2/wm+Vh1tEujbxxSlB/YM+A8BzeU2YAE0M4wvUzJniWVP7d8R7d1VsrXoqGuvOwRmv9zMEFaRld4HHNGOFKBFy78v3CO4HNzVTqdnDHkJOcyGYR+E7oTWx/yxO401l/uZ5u+V43m3bI8JaDiF3vHbsS7JSkVeQEbRG8FpS7Hzm4FDl6iJuAY1AMl54njT3aWETB4zd/n8svTKqUFRjermc8H5MVLkUCIwwru5jY+VwM0oZYBzD6P+gHlsdo8AIndvcN9d+xohrXHOTJF+IiTIYaxLZFCNdkQcPmCIQsJNy7vEkqpiVbwsFnrfhVKHfGeWVo6DpvofJ2HJLrfvIjggw0xObA3ZB5N+qjxTulYW7GZw6YYAAF+hrUe2zq0sq/G6TtT249xPzwMCr6VOvd6CsF3HIEWviowtRYobBb0Ey6WxMtv70GqsZrSHlzipSEhALupJhdHhybzAps9rwaw9V5BL/8qEs9fQL3ewfUbeWNhbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(451199018)(38100700002)(31696002)(36756003)(86362001)(2616005)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(6486002)(478600001)(6666004)(6506007)(53546011)(31686004)(26005)(186003)(6512007)(2906002)(5660300002)(8936002)(44832011)(41300700001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clBHRXNQdUtEUnNHVGNQdXlxYlkxbm0zZEkxYTFKdTM5bk5ZQmNiV2RFWldM?=
 =?utf-8?B?eDhUVXh5NVBFUUVCanphZ05KaTRhcTA1cTQ0N1NpNFl1bTNpVnpicEFhSTFt?=
 =?utf-8?B?TDRiMmdNUVIzV1VpTWpWdDNhcU9xV2ZqOE1DRmwvb0lUVXcwQnpaMFhpMGE3?=
 =?utf-8?B?Z0ZsdjVzcmpDa1owYmJTZXd0VG9JMFdiR2NEWldWOGVkWDh5dnRqMlJuU25h?=
 =?utf-8?B?bHREelJKbDdvM3J0VWVndVpWS2pld1MxUE5VemxoS0xMOEthMlFWTXJvSE5C?=
 =?utf-8?B?VDBjcms1S3hWWFo5NUNoNjNIRzEyK1NpZjlEVytLejVpT0U2bkZOb3Z6RlR1?=
 =?utf-8?B?cExWbHlKWVRPM2RYNTB3MmtQbmJ6WkE4RDkrL0hZeTVOY0w2UVhlVDdsMWZp?=
 =?utf-8?B?aXNQTFVKNm04dWJWOGtNQ2RYajJjQ1hYRGE2TnB1YXVDR2xkdGVEWnFCRm5w?=
 =?utf-8?B?WjFMZXpaTG1WWEZQSzJRRmR4V0h1bzhLVzBwUGpYSC8xT0l3Zzc1Q2MvdDVs?=
 =?utf-8?B?VUZ4OUczU3UxT1ErZXZOK3dHWXNTZGZ2WTdIOVk3dC9URDZCWGFIcDVPU0FZ?=
 =?utf-8?B?TG1XaTBuVjBqTXh2OHJRYTBVR2xZWjNKVDZkQnpiQ2xVRjh3YTBNN25ndzAz?=
 =?utf-8?B?SFZZTmprZHRzMWpEMmVVdkkySWdwWUF2VUVpWTJXWUpCdytQVW5CWVN4Unpi?=
 =?utf-8?B?REpRNENOSktOa28wZzdnUzFSa2dSQTJjYXFWYU1pLzdmZGI3SEoyU2s4OGU4?=
 =?utf-8?B?cFBkbTVybWg2VlNEdVNJbHlMV1N2Qmw5QlNpcjlTZ285TmRyejlxdVEvcSt2?=
 =?utf-8?B?cWtuT1ZTREYxUzh5TFNCcmpKRmVkNkpsdnl6Tzd2ZHdKaldFbWpXYmxtTCtu?=
 =?utf-8?B?VUJrRXRuYndtL0doSXI4c1NIclc3VGVzYkwrRUcvTHMwTHBSSldhUzZzUG5P?=
 =?utf-8?B?T2R1Qmtqc1pYL0luN3JKL0tvdEptM3JpWUlXdkI0OFRYaitaZ25KUElkZW1h?=
 =?utf-8?B?cVFqaFBIblpIejVGcTNFSkQvVExldE1zbTd2WmcrTFF6RjVSZW1SeURMRjA0?=
 =?utf-8?B?Q0dTZFRlWG55OVBLVm5ZOXZqM2tBM0tydmdLTWd3U0Exb1ZCUUFEdHA0dEVj?=
 =?utf-8?B?U1djZ3ZwN0pJWGlHakJFZ1ZxMzYveDVmZ05VZlQ3QWQ4dFcrN3U2emJoWG5D?=
 =?utf-8?B?MVRoSDNabGszMm9jVDNYOXpoL213ZG92VUp3OTVFUEpTaVRrNlpmTHptclAr?=
 =?utf-8?B?VjBDeW1SNmRYeG5qK0xLS29ZbjRTbFpVUndKV0MrREtVMy9WQkJ2WDlvK3l1?=
 =?utf-8?B?N1BKdWRoZDVqcmhTUFI4RmpJcmJva3BkWTZsTjdjVHB1WFFKOGltam83WEpE?=
 =?utf-8?B?VHdYTTAvNUxoZXJCYURjenFFWWFuOTdFdTk0NWNSdnM3Mjg3WWdiUG1iUXAr?=
 =?utf-8?B?MGRqbDVVay94UGxodW1pM01uOU1mQTdsZWRyWld4TnB5NnZzb0Y1VnUwZktC?=
 =?utf-8?B?SDE0aUZNSmtyd1dUa25Fem1uK0dSeFVMc1JMKzRaUDllK2tQNnM4alNrWU9W?=
 =?utf-8?B?MjAxaXRiZmt1bjRRdmM0SkdZUFNHR0ljL2JBem5OVTk1QzRYZWVwa0h1d29F?=
 =?utf-8?B?SHI2YmdEQmRWL3FzTjlPMVRNNWJZMmcxejg0VTZLbzNlVld0clRaTVppdUh2?=
 =?utf-8?B?dWRIc3JaUG5lSm1mTDBiL3FnVHViOTVaZm02aWZpV1RYNS9qYmN4TE5PSDdn?=
 =?utf-8?B?KzRxTzlpM2xxNFNMV0tDc282NStiUE4yVUIvakpOTndFbEVzVU9iaE54OGc5?=
 =?utf-8?B?dFBMSmcrMGlUUnZkQTFBSHMzWDcxNFVaMWd1Kzhsa21yWHVrWlpkajlhUlU3?=
 =?utf-8?B?NElJNjJZcHVqL0VtcnA0QStRT0JhSm9BV1Fpc056MFpnbjVWbDNrdGhEV3py?=
 =?utf-8?B?VTY5R3htUGhCN3RPUDNUT0lRaEt6c1FYVUpoMFdPWHZKSW81clByQnVJQkQ3?=
 =?utf-8?B?dGRoUUlxUGVKd2cxcG5kVVdTclZ5eTVZRng5K0V4aEJOaE5Ob0VjVWVOSlJV?=
 =?utf-8?B?WFU0RXpvZDNISEY2ZG1TSXBEbzIxTTRxNU5uV3VqNGZwYXlPdys2QVJMejZ4?=
 =?utf-8?Q?6xvtrq+0NpoIn3giNLNEPQFgk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c5217c0-444b-4861-1541-08db0eb95d68
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 18:29:10.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8s8GDqQ/w4AIente4et/95SRtPXsSuUvhl9kVa4rGUoETZ/s8BWf0MZvjCTOfJZDOh9OJevqUxsbBAzs1p/Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4186
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/23 8:32 PM, Jakub Kicinski wrote:
> Commit 5b4e9a7a71ab ("net: ethtool: extend ringparam set/get APIs for rx_push")
> added a new attr for configuring rx-push, right after tx-push.
> Add it to the spec, the ring param operation is covered by
> the otherwise sparse ethtool spec.

Thanks for catching that
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>

> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Cc: Shannon Nelson <shannon.nelson@amd.com>
> ---
>   Documentation/netlink/specs/ethtool.yaml | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
> index 82f4e6f8ddd3..08b776908d15 100644
> --- a/Documentation/netlink/specs/ethtool.yaml
> +++ b/Documentation/netlink/specs/ethtool.yaml
> @@ -171,6 +171,9 @@ doc: Partial family for Ethtool Netlink.
>         -
>           name: tx-push
>           type: u8
> +      -
> +        name: rx-push
> +        type: u8
> 
>     -
>       name: mm-stat
> @@ -320,6 +323,7 @@ doc: Partial family for Ethtool Netlink.
>               - tcp-data-split
>               - cqe-size
>               - tx-push
> +            - rx-push
>         dump: *ring-get-op
>       -
>         name: rings-set
> @@ -339,6 +343,7 @@ doc: Partial family for Ethtool Netlink.
>               - tcp-data-split
>               - cqe-size
>               - tx-push
> +            - rx-push
>       -
>         name: rings-ntf
>         doc: Notification for change in ring params.
> --
> 2.39.1
> 
