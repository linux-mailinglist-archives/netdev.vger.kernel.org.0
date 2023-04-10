Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85DD6DC7B0
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjDJONg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjDJONf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:13:35 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2103.outbound.protection.outlook.com [40.107.237.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FDF6A72;
        Mon, 10 Apr 2023 07:13:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0EKJqqSY/d/tFojcVVqIeBhhqArzgqQFwKLCm5Ac6/r7oaItzhSFsPxJmJ8rr066p5xBClHczOrh5ioWlkefha5HidEXXmlQZB2mooSYKP9RF8H9oJ38qC+3c2u+OrJXZD6QnsxFwxIM1/ZlZ5YSOd8S+7fzVogruwWvO4ZspG/JEkVp6wD4U8VMHePXE6aWX8s8cDmKsRSup8B4WsVG3q41Jv00nIIy2JaJQ5nicpB4IvNy2YjXUAcyXOf9Z9JorJ9NiGKe9p2vsf+r8JINJSUcTdoExyGhXjqOanH2u4SfroGKRoA0FfA8m/kquW5jZMzMHYjVnrcxrT0o/o9Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmfdLidm0/nrlfK0nxbDZEJwC3S3tjicBpsu7E8BDdo=;
 b=V8NIBa4LsyLQhf/TfSGSUcaP1unXSHgMkiuhbBkQ19lbvNy4tewbU81DEdEZP7pbiOsrVbs+VY0Crk3h+kB3rPmE30zE7sajJfjs/VCa4KadarFp26gxmdAUnqIv9hntRJTAEdHU8AbfhzY3DdghoUnj0dRw6r4v9HmQoGpHVe9ithbOcyhHVww1h4myqL8hNRcEZOMbrNh1imzaKoyL/eA9QQwHsP7oRlxAx+SY7JTcxk1ZW1RzkMIVW0jfzHS8uUhrGPUvkYdMnFRhr6aRsEfdXTawwRzRGfcgqnRzDssj4g+oNYuiByoB9JdZkAxHHMCqQdr8WznhDcYRKG76IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmfdLidm0/nrlfK0nxbDZEJwC3S3tjicBpsu7E8BDdo=;
 b=hDe/2S10JvvVN/zcNpqGvgIXHPwevKHRvbRfHcUmX78n2CUmjVsPKZE2cEHBzwZEd0J6GWZJgD+ewcwtlwzEMzjiqnjHFwiqnH6AdgAAmR31O1HE23gsCM2HFeWcsyPNwN9aqAuQX5jRXtw2ebS/OThbjuOaTclMAYFWwpSXPxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5221.namprd13.prod.outlook.com (2603:10b6:8:f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.36; Mon, 10 Apr 2023 14:13:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 14:13:21 +0000
Date:   Mon, 10 Apr 2023 16:13:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net
Subject: Re: [PATCH net-next 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Message-ID: <ZDQZeSe5OaFlNKso@corigine.com>
References: <20230410100939.331833-1-yoong.siang.song@intel.com>
 <20230410100939.331833-4-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410100939.331833-4-yoong.siang.song@intel.com>
X-ClientProxiedBy: AS4PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5221:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5c147e-6a57-4913-758c-08db39cdbd76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1d19VGzlKgSvqxIH5GMEwmkZR1UlFaaa1fdgQDB39wleX01ksnXxqx5gll7aTOg3d3+E9aoBuAeL0If6ULvmY/8FauduUUFhngq2PDGdFJMy5svP4eXQ24cO1DwzJ8y6H5QmEY/Mr0BWoDlxOHpjSqs4oOvCSa+TbISxztwlUbiurZXccj1WrLzdtHXPDyHC9OeUq4cnE3oeeyhUGqxkYAh92HBkTLbZdVXYvywVUvoUjZrbQLDlp8kKSAVQnW+COp8ti9s5V7/9TqnyTyBwATKd3LZ/RSKJugwzbIdySA14PX6A8WHEd44hwtR00bkD9kEh/h65t24WT7R9IX5pJaRelq/AZMtUWKNr7u/OduBelOZ7sMtNYSxswSEzX519kZf82+Y9Nes/ZvUJq0ZPUlrEy02FxrCCUK6TH2pkuV12s4xcgqUm+IGhXhBumf6KC+qA9L/ZLRMbCS+GTA8KkneSGznsFvllCT8L74rLPl/h2nCaACj9Rbg5Aa2uLA7wm7zPX6/nG4+rUAsGlFNv0yA2U60Ho/jtUIS+oGKZniU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(396003)(136003)(376002)(346002)(451199021)(36756003)(86362001)(2906002)(2616005)(6486002)(6666004)(83380400001)(186003)(6506007)(6512007)(966005)(478600001)(66476007)(6916009)(4326008)(66556008)(66946007)(7416002)(41300700001)(8936002)(8676002)(38100700002)(54906003)(316002)(5660300002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xJRnTfKZ7BOPkU4S4XOU4oOV4YTsq6nCmxyIAwQVBPwkUy4u+AMvlP7HNbjp?=
 =?us-ascii?Q?/k7amDg9z5Lb/ZNfkVANCJkRo+C7BRdLXKVmH1Xv5XsoC0J2VkXaGxXWHmRh?=
 =?us-ascii?Q?/QlEJ2ghY1SaEsr2jT0ArnmKSMWaxtNP29aJ4LU5InhIn0hFpG6YQNsZn391?=
 =?us-ascii?Q?SO8VxEpBoEvAgJSx8lp/mLzFGpKXSHlsEzCt7fb0ENr5GlFWR6NpZOml+gUW?=
 =?us-ascii?Q?nUP9AUm3aUV0J2JKvErctklo2jmT0C/Wg3n7Og+bipoXT0R6oKGOmSVYqiCL?=
 =?us-ascii?Q?gIlt911cAc72bIYFyYIsoY8eBX5dlPQ34RjV7SXl0Ykhwgo1esz9yvFrJ1VZ?=
 =?us-ascii?Q?kYDlywnmmbqI0nM9o2EFILgvFnkHGylpaAL2+f2mba6YUYBgX9fzRtboJmcs?=
 =?us-ascii?Q?jmeHZ1kDt3cU7ernhufS8GOo6vDvVRrMwW7WFzT2M8VgAAgXrKkU0xv5EOEZ?=
 =?us-ascii?Q?QISOGR46mt6ek3jHo43+gExtmU9KN1aR5vVgT2HghrAGcYNUe97IdEhKAPYu?=
 =?us-ascii?Q?mNlr+amNKVftgASWNuZjtr5vhZEQwIE1LvINB2T/f1QhcEQSwhjj28ccNLGZ?=
 =?us-ascii?Q?45EqsNCB7WlPUUS0B5swlWdWrnIOG41jpzxtn8wBohsK7Htme3hQG6YB6avk?=
 =?us-ascii?Q?bc+95ezxYm6SNRIgi7taUadVPZKFiM3rPVj13Gmqr/gM+JDd8K8lOTmMjwe6?=
 =?us-ascii?Q?xvFBwtgdtZwSuWwVeLP+b0GTLsg/5g36ERlJJhlTpq2bJS8oo1oQPc+QpXq6?=
 =?us-ascii?Q?4Hqpk1B9odeGHs2VRJkoYI6XVXL97E6uCtrxT/+JnEVN+kuBrwHCWcZ9Yz8e?=
 =?us-ascii?Q?pQxMnK6x1PscuaLlAf0ViKWwLm2jFhNW99wPwglUrMzH4/XLnbhSWoz0T2+p?=
 =?us-ascii?Q?0IT7gvBVnw2v5eL1BvmeJ+6zuKchfflxrxKzEIsAWSU2+8qe3UmQVThR5cAJ?=
 =?us-ascii?Q?2GxW1eSZuCwNrrN96rRVaw+SD74hCuBmqNKHp8iO61mdZvUJtb5rqDSFVWQT?=
 =?us-ascii?Q?TPDYOsH0LFSPPKEUGEHYUrH6oU9rOG0k4SnivduhwniUFhq5n/s0/2ddsGtj?=
 =?us-ascii?Q?7xq8q1eL+wCQEajOgAPZk7GYo+7QYKoVq05CxWt+RAjBIctEUN/zTjZeINwo?=
 =?us-ascii?Q?VNr/mz5L6OVgrpDbnNCtxzVCKkncCSY6CdH6ha2biXBNlGBQILNr6JHpFzJA?=
 =?us-ascii?Q?vm+jLwKg+3csFQgjC8Ou16R8pRpXRQqSKN+aYzMxuucRn7MIl/lyeymy/k46?=
 =?us-ascii?Q?DOMUm7ZmB7JyOgUBroUtcR2w2ySjFc1ryuTRaupveU/HQfqjo1JzfQjnHkHE?=
 =?us-ascii?Q?q+lJ4T3NFY3Wdys5DA0Y4c+vwZSXWrUSuYjBTpn7TnNgBxV/NxzYVeLkLFi6?=
 =?us-ascii?Q?luebG+oDNyI572xQnNYlwlQLQjfhzMRpBRpitaeVf/UQNCdmIgBEgufQhlrh?=
 =?us-ascii?Q?kfOxwDCslSZG0g39g53pNmChbUVIja1i0lZUH3G5vJUWcFrVgMM6fVAVelC3?=
 =?us-ascii?Q?gSFf3WpIY8DavwdxzVxrgTMQzr4N82TIeHH5hMhwsBgIbfY7zVxt/YCPWiZF?=
 =?us-ascii?Q?SUbde6jtfUS6cSNS9Bc8WpakPdXUNgWEuocbT0FXbIn+QTowDKBl/Z+SLFvB?=
 =?us-ascii?Q?PIaD/eSjkIkuQ48ZY9QThTsGjSgsAT1GxPgXMtqya7Ct3ldhBmDS7XxN06MU?=
 =?us-ascii?Q?GUxwug=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5c147e-6a57-4913-758c-08db39cdbd76
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 14:13:21.7920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKzvJzoTSgyJPdxw1Dz7TwggdzrlkOCKvYjbc/VQf1oF+wdkpGX1uhgso2oH5tQ/HyytWlqkyG51M5w3lg99vS5oWV8sqJEDDEjmHrJBIIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5221
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 06:09:38PM +0800, Song Yoong Siang wrote:
> Add receive hardware timestamp metadata support via kfunc to XDP receive
> packets.
> 
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>

...

> @@ -7071,6 +7073,22 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
>  	}
>  }
>  
> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
> +{
> +	const struct stmmac_xdp_buff *ctx = (void *)_ctx;
> +
> +	if (ctx->rx_hwts) {
> +		*timestamp = ctx->rx_hwts;
> +		return 0;
> +	}
> +
> +	return -ENODATA;
> +}
> +
> +const struct xdp_metadata_ops stmmac_xdp_metadata_ops = {
> +	.xmo_rx_timestamp		= stmmac_xdp_rx_timestamp,
> +};

sparse seems to think this should be static.

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:7082:31: warning: symbol 'stmmac_xdp_metadata_ops' was not declared. Should it be static?

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230410100939.331833-4-yoong.siang.song@intel.com/

> +
>  /**
>   * stmmac_dvr_probe
>   * @device: device pointer
