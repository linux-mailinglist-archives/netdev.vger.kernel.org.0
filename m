Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A569F6AC0AE
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbjCFNUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjCFNUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:20:40 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2117.outbound.protection.outlook.com [40.107.244.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9443C2DE6F;
        Mon,  6 Mar 2023 05:20:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9XFMj+5dD/sqeWN2MJzJyZCMCswvwa+WjmdJXCiEuzmrt8WWQggCqBko0dgRCSgX6Fr4xhAeafU5Uj0OyNVt/024K/EyJ79qYoJU4vBUN5KZH0EAY3wd22DFh59mUvJcSwFiGzOiRj79A0DUMsNtfyywchoox2F4aAAKv3m4WJb4cXHLpYEWwrsytsfJ2XcUEsK64fJu3RTrnXj9qivj0BaagZRIXlmoL1swcC22vehuT/QzjUcTQKPxAj3XxR0K2E2SrZKEM0zVj8StIDtjUS/8LqzsRW3JcLWwVah2svqEbGCrzTREgfwGcEt4OfPbDJCbbb/XmQ4z+GFOi/HYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYEPEXyuA55Pe8adU0yiO63sOONiOk52KDmP25gj1KI=;
 b=Z9Aa4ByNNFZ4OTMfd23tn0JgTgcra7OGzJtm3lSnULFPBpTfhrrIAZGyAmdbf4Pr4omLO9Qstg7IB5n2f+U6m5fyxNmAgfBtvJs7RB1Si8BvQeFLnRof44edhGWrd1TZ+ypV3CTesTMOtrXaKKhUezI7nev9VaUFtcLvhPIX3Y8kPvq1MjuPmm5MBe/w4XJtDgIzot9RWCvZyqrZr4iJuxxx4qIC5kmBmQHiuYslS9x6Zl1musXr2yPbMN7ya6N5WXsxn4ygainv9SjD3le4G19FYFEd9+Vz3pUvpX/o3PL5wzLsQ4obPj/DlooIpEzB/59HsCGxUOhZllWGyMRWCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYEPEXyuA55Pe8adU0yiO63sOONiOk52KDmP25gj1KI=;
 b=DnOKoO6LJOytZz6yhSYbLAolO4zAgNVwDxF89eal+kV3xPdopk9YSFuYl+k/MMa1YbEc220bbTjlGwVZtOLtTPUUV93thGQuXiBTPprIVJPhVWfiOUZaD19OJIwx+lIsKvx6cZSdWF+cbheXa8oDN+8S/lgjUYSqEkciRf1eRgg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5529.namprd13.prod.outlook.com (2603:10b6:303:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Mon, 6 Mar
 2023 13:20:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 13:20:17 +0000
Date:   Mon, 6 Mar 2023 14:20:10 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        hawk@kernel.org, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, lorenzo.bianconi@redhat.com
Subject: Re: [RFC net-next] ethtool: provide XDP information with
 XDP_FEATURES_GET
Message-ID: <ZAXoik8Y4OboNRAT@corigine.com>
References: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
X-ClientProxiedBy: AM8P190CA0013.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5529:EE_
X-MS-Office365-Filtering-Correlation-Id: c7faf46c-b543-47ff-a3af-08db1e458702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbAMDwnNHiFymRe/RvDlt6vLJ9BO7QqTbpk/jGRx1RTUMlEhWBGduT+sP+UQj2eLnh39WSm0yHQVA3h4axwIlVgTurXJJKftsUWmo96WWWd6MO2ryoRLwu8nBqJOrlBShM1IrY7mzMoOdJ5gmbdZp1x+R6CUWtEw5nkVGLQOtTtDgEoxja4WZAr2wb4+QwLMzdiK0U7qtkJYJZ+X4iTPZ/8l33q9HCWeZyVynhCOqYmc8nWajzEShGSV1+5UdxoC5FJFmoR5W9cNS05GqLWVkivhb3w8vGvBRtMNoU2UZCT9Z+f1nXFUtIujomy1Px74CpZir6YUflUw8MkENB1pK3uF+bO5RkYfPSZV9/D0BqQX6vRK6Nw7xviPfH2CxzKiZ2rJuM0+HN9bLRMGYWYvP8guCAN7F7GGcpoyZMLntT7kl/wFVj3Gn5Cyg570CsmpAL9edZM05YOQyI/lp3llTPwCO6ZHxmO6TMvvxp2Gc2Uk8SjfxISSVSs1Pd3oq2hnRwMbvSn7ckaanamPjhKPrhMe0Glpl02EPq80N5UjFXdfjSusNCvScPpk9A7W7k5+bi6sOUCcjJd4TzCTr81j2+9e5QNUDq4nKcY+FUC5AQP1lc5OcZNDy948JSoAKftu9QmQV1QaH9a8KCP+BklKRDzsKcu6WGf/loaWqq4/Euf2RP0FN4r+dfzvAKtxyqN3bUokB4d+N2m/80911O9hn6iJemGyiUTO5CMGq2aiYAE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(136003)(366004)(39840400004)(451199018)(44832011)(6512007)(478600001)(6506007)(2616005)(316002)(186003)(6666004)(6486002)(8676002)(4326008)(6916009)(36756003)(8936002)(41300700001)(5660300002)(86362001)(7416002)(38100700002)(2906002)(66946007)(66476007)(83380400001)(66556008)(134885004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9qVNRkAJinbk/YaRDx6Jk+4lQwDdoEc8KrginxTV+/NqxiN5LjsN1TabsgTb?=
 =?us-ascii?Q?mU+5hVjt6QenJ5i7h29IM6UtsnskCyRBL9gc5RySebzXBV6KTtQwu3ta5da5?=
 =?us-ascii?Q?EP6gEvNIDNJHTPyEq8WR7k2ALbMZfMPKGTQ/Th99bfXwo0pCDAKBlvTWFxaV?=
 =?us-ascii?Q?x1IB1US6z/3Rtnkxjddm1Lo6vGAf76rgilrGuwanhVUWoKdiQ+C+xu2DnC+h?=
 =?us-ascii?Q?+kUTfs54JwKtZ3la0cVLCkodB4YorwH9Z1DI+In6DHD9QDyQBAov51DRnZBu?=
 =?us-ascii?Q?7OT3m6JN1IfCB37NHW0NulMoPzic+P6E2Hmt9jEveSp3MM+hV8g+VGe8FbV8?=
 =?us-ascii?Q?X0O45H8g+nD5kETz89UOoNNoyYe7Kp4VToz3LoZy0kKbiqvfQEHoWgrAd+9J?=
 =?us-ascii?Q?bPr48T9MptElXDgnJWHAzWDVsX8TXHmTVD8f53xLYy9bOlqJe2mS+f41MdUo?=
 =?us-ascii?Q?3dJ8sAEB34t4w88M0XZP34WVYT33nOkKDARF9WkwPoJKprX4fsAnXZadEIh0?=
 =?us-ascii?Q?H0j1oSweAu6/wZNvNsgS0YZ6I+KtHg7C7ICv11PwanLGYyMSt0bbaaeQaoWD?=
 =?us-ascii?Q?+0Lnvl1jfKwla7dE/IbDH2EvoDoNvnRFtu64YMdzRsVqkugukxLRNmB2PJy+?=
 =?us-ascii?Q?Vz+XyibsGSxRNRTJga2Cjni9+rJJwwBWWqH81Po+UMLdgjTFq6zhfooWDcC8?=
 =?us-ascii?Q?ecy3vE2umsuY83im6TTZMgmMlfvTQks/wX21FKoGJgBC9jt6MB9T5szEiUCp?=
 =?us-ascii?Q?vkYW3aHNfW7f4uei2MSKjenhAXY1Lht9JLAwd+f7OWEk2yfp8fdnqTGD3jVo?=
 =?us-ascii?Q?lOoVcWw78qpOl5Cb6fHovJD8m/j/9U7hZXo5eZMG2nKYiCCqhVZYTNcxeAs2?=
 =?us-ascii?Q?mWMMrva7XrBfbBfjHqpr5TgMJl0qhlvtXmzqGfBycM8Q0GRgi8JoWsg8mN6V?=
 =?us-ascii?Q?xaJRGSEfWKNIbDxJamD9IQCo4AosiK54qWYUahTIWbJss1gUTpEnsyyBbwcD?=
 =?us-ascii?Q?Gf328BOQd1/RWZVnfX+eaii+ZiypNpsYFgXfuaqqLCb0H7FXgCD35csIXkz5?=
 =?us-ascii?Q?wa3kAzBtdA61dIjNrKcIicoBZ91wcYHz5QSFyoaGsoddwDgmNBFaVer+wfNL?=
 =?us-ascii?Q?3NLkdtlupYRoa0VD1XT84aZh6ZPijWv62BiWNMwKA6qsqcunjkbirJoUU02R?=
 =?us-ascii?Q?bLbcgvLjmFD6qkoTXnCbOnMFxI+3emqgiReiel6IRDRIyOyqbPCbCQqYpFGv?=
 =?us-ascii?Q?4BUyuQmCXnNw5VQKQ1Vt+aaxWox6o51Y7UPLel2HagaD4mkmOejhFL2nrSgZ?=
 =?us-ascii?Q?dkFopR/tVGwWCrqec9pEBFG9AtG3chuQpEK8iZ+rAwEjCBiB4aVDv/Yo24U8?=
 =?us-ascii?Q?06DTgWekZ+l82j6azhRvZEpVD2pH01Oq/EgiFtIZ3hvasHOTZRISL1t7DuCQ?=
 =?us-ascii?Q?d9XRuduLBdAhyFOHhDVFr5RA/qIEUIdGsENGeJ2QbWte8KN5I+5OZ1Fya8uV?=
 =?us-ascii?Q?PYqr72gXdSkg1EGlVZE4fQTa9ZCFTPj7WhvA5cxrtg9c0Aa2aiRYaJyfnvkD?=
 =?us-ascii?Q?UDkAI0fZh63/Y7vDQySIqy1Y5zlosKczJvNE4HV9Q0gbL0r6lGzR06BajQeg?=
 =?us-ascii?Q?N5tmMDNDOcjBDsW/U60lKNGBRP+MEVxMGBUsKyN0ggshatFYzEuwmfIYvNuF?=
 =?us-ascii?Q?26scHA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7faf46c-b543-47ff-a3af-08db1e458702
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 13:20:17.1761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLlFPy+4ZGbqyE95j5LwGv1aN4fohd9FdQz3AWTyNqgMqtrWzzmDmecFwNdjI5G2cZPvaOJyK8Q0AMdkTqeIFR800xxs4IOHi8cgya5/0dU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5529
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 11:26:10AM +0100, Lorenzo Bianconi wrote:
> Implement XDP_FEATURES_GET request to get network device information
> about supported xdp functionalities through ethtool.
> 
> Tested-by: Matteo Croce <teknoraver@meta.com>
> Co-developed-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

...

> @@ -1429,6 +1431,18 @@ struct ethtool_sfeatures {
>  	struct ethtool_set_features_block features[];
>  };
>  
> +/**
> + * struct ethtool_xdp_gfeatures - command to get supported XDP features
> + * @cmd: command number = %ETHTOOL_XDP_GFEATURES
> + * size: array size of the features[] array

nit: 'size' -> '@size'

> + * @features: XDP feature masks
> + */
> +struct ethtool_xdp_gfeatures {
> +	__u32	cmd;
> +	__u32	size;
> +	__u32	features[];
> +};
> +
>  /**
>   * struct ethtool_ts_info - holds a device's timestamping and PHC association
>   * @cmd: command number = %ETHTOOL_GET_TS_INFO

...

> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 5fb19050991e..2be672c601ad 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -465,6 +465,17 @@ const char udp_tunnel_type_names[][ETH_GSTRING_LEN] = {
>  static_assert(ARRAY_SIZE(udp_tunnel_type_names) ==
>  	      __ETHTOOL_UDP_TUNNEL_TYPE_CNT);
>  
> +const char xdp_features_strings[][ETH_GSTRING_LEN] = {
> +	[NETDEV_XDP_ACT_BIT_BASIC_BIT] =	"xdp-basic",
> +	[NETDEV_XDP_ACT_BIT_REDIRECT_BIT] =	"xdp-redirect",
> +	[NETDEV_XDP_ACT_BIT_NDO_XMIT_BIT] =	"xdp-ndo-xmit",
> +	[NETDEV_XDP_ACT_BIT_XSK_ZEROCOPY_BIT] =	"xdp-xsk-zerocopy",
> +	[NETDEV_XDP_ACT_BIT_HW_OFFLOAD_BIT] =	"xdp-hw-offload",
> +	[NETDEV_XDP_ACT_BIT_RX_SG_BIT] =	"xdp-rx-sg",
> +	[NETDEV_XDP_ACT_BIT_NDO_XMIT_SG_BIT] =	"xdp-ndo-xmit-sg",
> +};

nit: blank line here

> +static_assert(ARRAY_SIZE(xdp_features_strings) == __NETDEV_XDP_ACT_BIT_MAX);
> +
>  /* return false if legacy contained non-0 deprecated fields
>   * maxtxpkt/maxrxpkt. rest of ksettings always updated
>   */

...
