Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4514E6D42A6
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjDCKzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjDCKzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:55:06 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2042.outbound.protection.outlook.com [40.107.13.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62751165E;
        Mon,  3 Apr 2023 03:54:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aomT5OV+S8U0E4XncwOu73XmF7OveSI9gGMhLbPU0q5m1f7GFYjt5h5HMvVn5GJIKiv4oji8i91eON2cXg7k0HWWnTdhZrYuu6L60XdITz4CSU7W0JCfNBUxq6Z99q50L6XkOusfhVZWNa5O2x7P8IrqK6oUX70aIAU/dagofm86ufGzlxt6v+5Fs0XdknbJKiExon+kdc/WCHW9JJfxVWxXut25IQBRVN+rgdtvAmIslE/QrJZoFrwD4cMpa/lo7XGxu9j57zrwW9aY/H4S/cUIpEeLBjhJz2kbNRLguMaK0G1Q4v3bHMIhx1f3j5V48mQAgXnEcz0KaReyXIlBMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e24ulK+X71GFsPtakFTkib3sF6bciWqm0JovDDKdb48=;
 b=CyHnBcb8obPyiSE9osFycqRZaHAJh/oEKu06LCsP89q06yGiSl/9ACUx7Q+VLEpRoiYyYNxBdNwphZaF/LaWWWieTt2stSOIThZtZ+WGn4M9jk4isOclvWNyntJpOm5J5rLGsMSG/Z/PJUVa8ARV9slP2TG6y13bqzhl+jiuk4bkAUZZncUEH0++lCxZfUFilF9K+5K44yHfbW8XeIYWzJYGIKZvIWi9DxYjDBTBiQwRHLw1jshV3Egb+1Idrb5KmzDcnp1YkuhBeMYSW2AaPZlwjZoHiLDmun76EeS/DPgtEVHIKHVkLpHhgp2lbLqvBHnDGwVSm9+OgU40FI8Kew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e24ulK+X71GFsPtakFTkib3sF6bciWqm0JovDDKdb48=;
 b=MLVxyZrh0lcOmSHP8DkEdEbpbdPvPQv9OtJBV1xq0rBVFYZyMriccbDn5ArC0ej4NW6fmSLY0LDXt5OiKpMOrhN8azr6aytCjM8m4WQcOSj/M9Lsk5kOTSOFUuFE8tqkVmZV4x0SFL2sj6hqb+AXY932USmOXUcN2bueY0TGznc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB8PR04MB6860.eurprd04.prod.outlook.com (2603:10a6:10:112::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 10:54:47 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:54:46 +0000
Date:   Mon, 3 Apr 2023 13:54:42 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/9] Add tc-mqprio and tc-taprio support for
 preemptible traffic classes
Message-ID: <20230403105442.fssx7kd7swrul53n@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: FR2P281CA0099.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::9) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB8PR04MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 0573cc3b-7c0e-401f-19b7-08db3431d6f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+uPhIIVp8iAERMTCHx5EaCdDqvIR7fGmwUgyvB1a16yyfRgRbE0PNN77l5Ns0THc4asSZXGRQSWv2/jWunn19pqqBDGgeiLOqq828qu+AiwBMIln6kFTcn3072p+T8Z6cW3nBKT0UTRACTxr7dfHe5IeuSKGYtDdrHObzTCRtZ0VJ/j5XgUhJ/1FNqlHRuLgD9Xgp6UiwHnRFUdb34R4axUOpAyRUAos9TT2GBnLEmeFP52cNuc5fUcXv3uLmevJw1eY4+MclaQBnanGjUisQEpU6ZD8ebLliG2V1fW2HoguPPAzYGKBgYMvoLQs/rANhGCKEprZLceNJIGn+8l9DC97Zipdo/9mVh5IZHfokNsPVvh5mrNngjYJ95VZhkIjD+RTcTiMHyMBMkRmW5PZFliFaJnuOb4Wm3i2zq6eu+6osMYFRNFiB+LJtsUc1fIXcNujC8uemyam2SwJS2faIiiMNf3mPGcxaUssPzrmNlQuCX3lciH/YQZQK3KJ/xYETPHXWuF7mE2J3OdxXsMwpHtsxYUq8S2fP8quUSIkCU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199021)(8676002)(66476007)(6916009)(4326008)(66556008)(66946007)(478600001)(316002)(54906003)(8936002)(4744005)(44832011)(7416002)(41300700001)(38100700002)(5660300002)(186003)(966005)(6486002)(6666004)(26005)(6506007)(9686003)(6512007)(1076003)(86362001)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZL8GpBnqK04bNUPMGyJb8SJ115b8i9qXH5LG4nRb/p9Ss0Y07ik9FP0XiT7/?=
 =?us-ascii?Q?ErafsTEzdhkMKNhvw+e53+0Rf/s8R8gdQ3K9OOG8ZVxRvraYzlPT8rjllzng?=
 =?us-ascii?Q?5wQpx/5vx0j+TwxDxPsM2dZAFMxEOZBmh9LrlhBy7Wakw7fEUp/eDBcAXBYp?=
 =?us-ascii?Q?oukHxFNK0z8YOh6g0iMwvtaP7z0aXvTf/NnXw56BE3Tkz8HZIRbc00+vmRaR?=
 =?us-ascii?Q?ozNi15Yy7Gq8cQOjubM7vvfczVUttmWz9QNk3TcDLZrEJF9fN6nN9kkXazey?=
 =?us-ascii?Q?YpF8G/ZfQhmUsSS3US1pKhZ+kI0zdm8PMGnnLCUF5nLP6M4dOHysEa0cPWEU?=
 =?us-ascii?Q?G6eP0MCeRuZMgINK3mpkOb7n0SNe6HmjIZW52DwJGFD38ozc1qxB+RcCZsHx?=
 =?us-ascii?Q?G3EiyJVkFeyVJVmWKlmIqB3u9++e1rD+verv3Bg5g+lfnep7klQWwj1p72tq?=
 =?us-ascii?Q?IBvh1KfE3JkiNe/X4eonwhXT0JtRfTXEJmp5SuaACBHw2K453eNu8zLnMun+?=
 =?us-ascii?Q?txr5v2mKCPdUS/fs7bTaLs96s0ueTHkppqxYe2DPYO8vIgJx+EZf7XuZGmbC?=
 =?us-ascii?Q?9v4lJs22kM6ZVe14OHSpjk3cyonlqCQBhXEUuvq31q/vnixedTw85GNR7/1E?=
 =?us-ascii?Q?tumeQfwqQOn42IlmEfU7gY9epR9k4f9h8WGrnZrh/V0OZDPh2qlaJyKEh47J?=
 =?us-ascii?Q?HNo4f67wiM3Ibb0SHcRQXmvbZX9OsTxPnFGmuBEOCjMtjr/jkwgFUrYNGOmo?=
 =?us-ascii?Q?3Zh9/+nEOC4o22dl/p535NHs6zfI267Bfu4fd4oeBljy+RzWJwjR9ylw1+eC?=
 =?us-ascii?Q?OUc7v8BZpVygluHOLx5Wx2BjOo07qBHEjVtyO+CkfI2ogYwqGRClulIoKJqX?=
 =?us-ascii?Q?pgvuGzncyzBsY+qD5zg+k66/g/Kic3kPQ7+flf2a9P0GUdE629vVaz68bUzk?=
 =?us-ascii?Q?psKBQt1jPOJLjrBykU9/H3Xw+znCTEdM5DV6hsnz6HDhEeOQrBtiQRVD//MU?=
 =?us-ascii?Q?qiCiJPTF118xw4LEfe1jCqdAzExvv38vA6xg9o4LKv4i7qtMo3uXOYkQtJ7v?=
 =?us-ascii?Q?dsvx2nxBpcladMtYU24VwujBb7yPBK23FpDXCatc6vko4KpLQssKGXCXWWlM?=
 =?us-ascii?Q?d0yLh/ivUcRRl5I4iQjvap7Sb0Q8QwKalNf0b2AsAZcdHyaCStf4WqYksEaA?=
 =?us-ascii?Q?uiwjOsELLlDjMfDPXphW0u8X1QCv2QD3HGsSH6ah4qxlT4iMfTvb0RqgbobS?=
 =?us-ascii?Q?YIMv5agbNbvS9Qq6v4kp2E+OYfuhc+YZa4hj/ncAD/9vuKZWouVSixUaSH2I?=
 =?us-ascii?Q?wPHoTs3awjRrRnpf2vyp+PO0dmtCSth4blNxGZLVJ1QcL6ZJIlbNQYWv5h5K?=
 =?us-ascii?Q?Ifax/1ypPDKGD3yl8z+619QNAgibyYHT1ImdX+CZUq2iDeQi59baouNypx1D?=
 =?us-ascii?Q?ostOdrb1pC/mqfA7t511vCAHLL3YajJ9R2bpsLuZnFMFvddBMpjwSUt5oyZ9?=
 =?us-ascii?Q?hzqhZZXeyImWjrNTZaAzWJxph0QWaMZ18akQhRMfn5t3ayvsx0XbhsC3C/A2?=
 =?us-ascii?Q?rQga6ziBVeeurhzEvyjvNvDtGqZ1GOTkMtpz34oWsN8IZZawlzk8toE5IKbb?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0573cc3b-7c0e-401f-19b7-08db3431d6f4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:54:46.9058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1r1DqxZQphhJi6PdjLPj2a9LiCVnRtIr75s4XzxB0jAaKsIXJWuRY/UDmSd6UgHFgkEPlBSOC8OHR9Dd+40x2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6860
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 01:34:31PM +0300, Vladimir Oltean wrote:
> This series proposes that we use the Qdisc layer, through separate
> (albeit very similar) UAPI in mqprio and taprio, and that both these
> Qdiscs pass the information down to the offloading device driver through
> the common mqprio offload structure (which taprio also passes).

For those interested, the iproute2 companion patch set is available here:
https://patchwork.kernel.org/project/netdevbpf/cover/20230403105245.2902376-1-vladimir.oltean@nxp.com/
