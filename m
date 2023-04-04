Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1429D6D67A8
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbjDDPkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbjDDPke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 11:40:34 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2114.outbound.protection.outlook.com [40.107.95.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE8249CE;
        Tue,  4 Apr 2023 08:40:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1P71eym2KbeF0xwA0LoJ0VqncwEOYjbWGCwsFfu6NBSkg3/zcguQn7srKNoXQSS0LDiiNkUqpX4zia/EawSzUTqLh5Y62sskhQxbSneyq/xfXJgCJ6SdqRdfS4HGIDS5l0b6x2iTp9xe8stpsX6ky3G8U8whCtKMqGdAO7nRIJGWxsrJGoVX/jEYG3ZOrkgEor0GQE58ftuMmCeFtw/ZjtSqXhGfCkHy97wi1TSllJCbSgPIxCfcSL8Ck3d9HB/UDkM8HwMIWAm8pvF7N2q6i+4U4g1f06EEWZxnZW9pWzOG7QTLCTbe3MHYYioMMlwjaHnHEqIc5g8PY/4USngrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+iYG5JGcCfrwJn4oQcQYOyWV+2XFg3gTllTRKeci5k=;
 b=PzuU82sJajvKAV2yfG1CFYdi3Y7mnc4lFBAcB+pYcqZrvvtsFw0aD1/R9Cl3cIbOqratH9x53dg7Jg/xt+QJ2tWA35tmWKaeEp4js/EBlrqJ2pLrZSuCKoc5HFjuyjemIc8WiSa4QL6FMF/trzDsjRI+WH1pWjZimuanxUXQ9wCw9lDvsmFSVvQT1TSYspUUopvGLyWMRTLcr1Uj24OP9KzE2AEfa4+O3r84Vjzb+h9f7WA+CJVCSDe0gaFch3m1vlKuOKdBN2G0NbzTUkBVP4mgp4k9CuaFedcuHPrqo1Bk83lb/h4BBnIQG6RqUOwansfg8hP/NZvxiJu2OdPuOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+iYG5JGcCfrwJn4oQcQYOyWV+2XFg3gTllTRKeci5k=;
 b=loFHiILloeNz/Dphb831CgXH/8KTgUDxhh3gKPxEiQXqzH2y1BRpiHEtAxpl2tTgzfaf+Bgdjxg/xO/PC7ppLJWK9mrlze0suIpzIVlY8DD5Z/61QGIqvhs47qZ1ObThu4anBGgGiXzV0wgrA181XOlNDxNJ3je499f6bNnToGk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4925.namprd13.prod.outlook.com (2603:10b6:806:1a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Tue, 4 Apr
 2023 15:40:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 15:40:17 +0000
Date:   Tue, 4 Apr 2023 17:40:11 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Chenyuan Mi <michenyuan@huawei.com>
Cc:     isdn@linux-pingi.de, marcel@holtmann.org, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] bluetooth: unregister correct BTPROTO for
 CMTP
Message-ID: <ZCxE2zHwezg5DyjX@corigine.com>
References: <20230404015258.1345774-1-michenyuan@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404015258.1345774-1-michenyuan@huawei.com>
X-ClientProxiedBy: AM4PR0302CA0001.eurprd03.prod.outlook.com
 (2603:10a6:205:2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4925:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fb5b1ef-9e48-42a9-e217-08db3522e432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0TSeayrsyRE92tWc1zcbGFiRoL2jLToD2B1LGbC98LxOBPHwMWzYy401VidyV4PZUOV0DzFZQeNz7R1skwEcegZBAe7HxJi0XxVG+Vwhnr4QlMUqRSaotBhQ3wSrQgBND7lDf5AjNEsrQVekFV7V9ncDzspWW7VMCu3X2mmyyHGy177meLo8yYFCynVSaGewWc3f1Mbb8tZoomv1zLRNB47uycx780lSW8mdKraUw4IkHMecxT1QxapPNUpdA3F7HT+YPTy04oUfSYvmGqGHuISKPUVZExGc9KAH6E3fuhP7lJPqrHusup/xFdMu19rcVirM+DIlXFSvnRqJDGkD7mq4w7SSXY0bUmwMJappFYOemqzt8+x+Kgv6k3QSvMLXzBtplpXKgJPlLtuq4GKpk2E8TPnrp5qFJDYoSfHmz6XHmLcsYC2avpi9vIXYfbjp7ApyWgNi/MwQiX76H3pTNv13LtGxb97/wD8u0AcvhirHWpAHFN+LTEGREAwdVE09fUTBjEWHlN3hKdQ8O0vsaxMKktkgKLfCSKTueHz7ctpw+j2ZymA5SJAoMhktPbK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(376002)(39830400003)(451199021)(6666004)(86362001)(36756003)(38100700002)(7416002)(44832011)(5660300002)(8936002)(41300700001)(66946007)(66476007)(8676002)(6916009)(66556008)(4326008)(478600001)(6486002)(83380400001)(6506007)(2906002)(6512007)(186003)(2616005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lWneGFUz9Rp+PexIqmvSGI9vAHkUIzqQl3zxl64lugsLeRpvDn1h2IvcXPE8?=
 =?us-ascii?Q?Vaxbno3lYvbztTdhJClf8DdWRfLb4N7tzjLsGdlve5Ufdyxs/MZOquL91hA7?=
 =?us-ascii?Q?0l9CDdyxNEuENMH58ytlpHzhSX7suVUjfVgIjp4924lq0IFflXY97sG5LWrD?=
 =?us-ascii?Q?qUidfBHpWYoDModcz2Xw0HcY+GKcM1lCR/ultuxBX5jycaDLco4WBAx7gBy0?=
 =?us-ascii?Q?KCn9lfB5o1kWPdE1z3PXCUk0C50cB5yRSbDWCm50N2MNf7V+n6DyLcg8VtoC?=
 =?us-ascii?Q?ejhdIejYL1TXRa7wq5boqy4R47MJZyF7woOZTycmsX0dQ7peHrikhbsXB4X+?=
 =?us-ascii?Q?kkwCrknC16eU7JoVVj3mRKUm/2QrG7ebHAAUYBISfwDQBAqpI6phMUQt9JZm?=
 =?us-ascii?Q?EncOEqxkyWOV3roykEseCGUPWo4rB4sX59Z8ggRWZlNywMfsmKi8yXLZZDOz?=
 =?us-ascii?Q?mIHHq6ML4eWvPIred0mFQgwA/Fm7pih3GQwUGbke/7oUKoWgFD0yV9CEDCc0?=
 =?us-ascii?Q?XnzOtJAOTcHMwjzaP23HG8qBsWHUxifO/7MQ1HB1z7OhbNELuyLmjssCs/69?=
 =?us-ascii?Q?SPhXN0seSPeF+zuLCV5A33TfhUbTbKjPYdZbGBNTLwGNN+PkypYQOz+NETkK?=
 =?us-ascii?Q?OJ4uLGMK6oUOD7Vb4Bppsw/r/nDDzL+cgktqD1Nn7xmzSoMlp3RduvlnC296?=
 =?us-ascii?Q?dVuA4PHteDerdPvH091cvsxFN+91MOy/cA9GScOyI6w4CwFBsvwT61u+O+G3?=
 =?us-ascii?Q?KgBAljymgXweUIn6e91v8pIET5bH44PMd5QY9A+ZhGh5kFaYiX8WB19+QGHi?=
 =?us-ascii?Q?7cjzcHOyf2dTXmGYQiSAfAq/xq7mtRh6VgL1BHWbRCpUqqC9px5al3jloYxX?=
 =?us-ascii?Q?f0iIPlua4LZRv+jZ1xzgxKdnjPGpqrlbL14IdrQ+avIpr9NrJ4mzP5hWPYXb?=
 =?us-ascii?Q?BiKRX8Q2jtLbIQK3ZJPvzrIe1NDYnkaNIcR7PE/JaEcUM4uaQ03HFXxeY7ig?=
 =?us-ascii?Q?h2Dq6nvOzC4+tI9swVfKf047I92rI9zN66I2jMzgOyKlb2l3MrUimePZXg9P?=
 =?us-ascii?Q?cSUNUWjdI+1MQKXedy3EXj2kjEbzgj/pABVFf3zCps5Szt2UzJd5ehEs0LBK?=
 =?us-ascii?Q?/ETaQyBMqFad4Kj1jiUtOJsTBrk03YEx6Gdo/VCVD5UCqWvFdC6+Pt4jvZUj?=
 =?us-ascii?Q?aUsPfCzIsiplrGJQYi05OO/bwBlGIWVY6rD0DcHfeuCkrMPTbnG0cerhVlas?=
 =?us-ascii?Q?BlCwOCPFUTdnyGlNZ3yswQx2kI8x3bVYi4EBemWMKw1gRtT3OY1KKKTR/4Ay?=
 =?us-ascii?Q?KNUASVcOG3PisFJk9uVRcBMGafHciMGVL0SClD4qyutdYoCRP0FDRC9cJm66?=
 =?us-ascii?Q?sYJOy+3LxX2QWJac0p+AN0ArCY89J0f5k37cN3eElQdI2KeIg+x2WsHUMhbe?=
 =?us-ascii?Q?XB4ZS2yhKxUAmhnjT98+YqwDKMGr/jCf0rwLZWw4VE9V6TfrpZG569XJD2Ot?=
 =?us-ascii?Q?/o0jZ3sizKipFYqYp+Yy6iseJx+VDTfAmrB+kr1vKC6LC238MACCMwNMnQM8?=
 =?us-ascii?Q?flI/AFWBzlyBfOkIiIxeEuOUd0TLYGB2TkRjjEKg6xPyYPY58UmNXsfPHMbh?=
 =?us-ascii?Q?FdDlcgh5z8iXlSn6Z5NVtXc0Jpl3QPjgGSOojIjo2OApab8ZD9qC8bmeWgAk?=
 =?us-ascii?Q?8QgvzQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb5b1ef-9e48-42a9-e217-08db3522e432
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 15:40:17.8710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Xkf1+IV7LGl45YQBHLqbZAZgf5bNrPI0F/DfGdGTOpXAq4RxT6aF99l6WIst/LqWCQPNqqVYtOiRnDl5oofOdLWVG2pXypMKRKUR/flJ/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4925
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 09:52:58AM +0800, Chenyuan Mi wrote:
> On error unregister BTPROTO_CMTP to match the registration earlier in 
> the same code-path. Without this change BTPROTO_HIDP is incorrectly 
> unregistered.
> 
> This bug does not appear to cause serious security problem.
> 
> The function 'bt_sock_unregister' takes its parameter as an index and 
> NULLs the corresponding element of 'bt_proto' which is an array of 
> pointers. When 'bt_proto' dereferences each element, it would check 
> whether the element is empty or not. Therefore, the problem of null 
> pointer deference does not occur.
> 
> Found by inspection.
> 
> Fixes: 8c8de589cedd ("Bluetooth: Added /proc/net/cmtp via bt_procfs_init()")
> Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/bluetooth/cmtp/sock.c | 2 +-
>  1 files changed, 1 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
> index 96d49d9fae96..cf4370055ce2 100644
> --- a/net/bluetooth/cmtp/sock.c
> +++ b/net/bluetooth/cmtp/sock.c
> @@ -250,7 +250,7 @@ int cmtp_init_sockets(void)
>  	err = bt_procfs_init(&init_net, "cmtp", &cmtp_sk_list, NULL);
>  	if (err < 0) {
>  		BT_ERR("Failed to create CMTP proc file");
> -		bt_sock_unregister(BTPROTO_HIDP);
> +		bt_sock_unregister(BTPROTO_CMTP);
>  		goto error;
>  	}
>  
> -- 
> 2.25.1
> 
