Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431786DE1D3
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjDKRDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjDKRCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:02:49 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2040.outbound.protection.outlook.com [40.107.7.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB8719B6;
        Tue, 11 Apr 2023 10:02:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R95zs/9R3Uv231Y8jSvWzQvldFfixSXINRhtHC4BNip4S8AsG1Zka0J4EuVijiyqNEvjZHMoO4c0VFd7Mkk99qcogRoc+sb2JkprpgzuPyOWfhdSd+UQRNLafpoSCc7CeyAaacUxK1Zf1h8AAsV6YV9hVfu4UxzFllCN8aGdbfe6UR2PbJqnn/Jr3ATywqw5Fs/+ApNmRHaub6LWPgZau7Jcq5rfddp1cKO4fYz+LH0TPpa2vYG9fxJW/vXlIRmeTbUMB/oEM51g9vs2cDHg/fBlm/rmegYDJLarEwTl5r8S0PiQem4LwSt3rvdVVoqYlOQG/GfJw8txeBF0BVEy0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WeVh9Fz6DEcvgGcgRmiTbQM02P3tVGx++29B47Q4m4o=;
 b=YDK3o+st3yiOn3V3DbrM8OVJvfpkdGQHBQS5VNB+g+bjHA0jl0xqAKROmAhUN8hGQ1K/+oG3zyOHjYo7jWmATkQDefgABdjFG8jHrGCAeqluEGS3fzcJCQmWrhMUdMMICVNw6tO9+G/7wmt+juTEBE126xGk1+u215rCJWdXA+rY5tnoLHguifkqCNNzRFlgIhb+RoJ9RtWfuJUx+DI/xxn1mRdzPZQvG62PXnRG2uxmov9a6kE9H/7DHPKX8yCo9lKqek4U8Xn8CafSNGiLdNrTEC1J5Z7lefNhjZgJ7nyJpWmTe+MVq+dfwyezUk8rPMMOGZFcKktoURoMNAlMhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WeVh9Fz6DEcvgGcgRmiTbQM02P3tVGx++29B47Q4m4o=;
 b=c7lfCobCj9LarhHNRB2t0HPLNErdqG2Pttq/7VtYIvOXP74iWIf7NjwdpjF64Bj+uOi26vCfoT4kkhdw64W6t/0+Pvjf98QBchkVUMPgN1HQdtucbVafsDrHdRMEV3qI+NdgFEp7RnnN9HfCtM1u1caduUGmycB7YFZFErrVqxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by AM9PR04MB8827.eurprd04.prod.outlook.com (2603:10a6:20b:40a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 17:01:57 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::f4e8:2508:291f:260f]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::f4e8:2508:291f:260f%5]) with mapi id 15.20.6277.034; Tue, 11 Apr 2023
 17:01:57 +0000
Date:   Tue, 11 Apr 2023 20:01:51 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
Message-ID: <20230411170151.ii7onipewbd27uw6@skbuf>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
 <20230403103440.2895683-7-vladimir.oltean@nxp.com>
 <20230405181234.35dbd2f9@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405181234.35dbd2f9@kernel.org>
X-ClientProxiedBy: VI1PR0502CA0010.eurprd05.prod.outlook.com
 (2603:10a6:803:1::23) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|AM9PR04MB8827:EE_
X-MS-Office365-Filtering-Correlation-Id: 204d7a5a-a589-4012-58cd-08db3aae751f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRWTl1fH1nQJKNgwBE/EGO10hIzmU4HJqFprcwM/CbXNhipPHI8Rf0+JPkLv00mB09qOK/F0nAaprmiC15OBnfejO7bS29FqF0wO7pHbhsOHDSgGki67bIBo6YgA0uZIZcbrSgpVf8FVtxXRj+UVQqSoZAnPNpoU9aw8qCk8VtOUCXXo6pMZjQ6mEDoIHeCiLBq2W9LyBtcbVFswhb6k7+/n7dPSkw32+QeJB7nRvx2RFpzfWL9v1wyrB87CT8bQ9BA542LGw1Z+ooXOziXSbovfdnSAOlhE66briAzSQxFshucqGcEVo+HAQXVZmUcKdHTl1R+S2sg5kk9Mcnn7EPHIxY303JObpf251bWXPxrIxgKEXwuu8jsUTdaA+eN76M5pnOcVGEHelWAO6X75WAqhAsXf3nOUpokFviC7H6pTRA5QtIT2EcHL6MBkVv+Z1+eUy940ZEb3X1E/M43Bpcl13caFa18mGGR4xGlytYY3cKuVMoDjWXCMQKmH4NKPmp/XLeG56EXdjjHlEdPIT0MB3vCPFiADstqyU/iiHNPLBeodLZU9buj46sq4JpgDzLTjov/54FO4mPClSZgDtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199021)(478600001)(1076003)(26005)(316002)(9686003)(6506007)(186003)(44832011)(54906003)(2906002)(966005)(5660300002)(33716001)(4326008)(66946007)(7416002)(8676002)(6666004)(6916009)(66476007)(6486002)(41300700001)(8936002)(66556008)(83380400001)(86362001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4x5cFa8Fl17aSB0XS9hQCdQrh/C0tYyFFRll5/Fb6+nFSlItZ5Qxli5X3YoR?=
 =?us-ascii?Q?ipr7gNT5Sy0pUtbNTlIcnOi0s9bCeIjH0Kk77I59JZ7znBVcqBnSLuylhxK7?=
 =?us-ascii?Q?Ykk6g8yFy9Iwp5ZtOGl2lsE/bjzQHvc+imU2mFISmRqemwagtfZdE7IhFtB0?=
 =?us-ascii?Q?S/XNLmaoCQ5/0mAED6nUdNekgr2YSAM3qPHX96oI8JbFOlmi2kdyu+ACxgZb?=
 =?us-ascii?Q?SfRupxcWTHKfIKOGWYxLoj6knx6OV9soGV2yUs8dyDsb8kzBzuqM8eYHoHBh?=
 =?us-ascii?Q?BBqA6YeDCKx3U5dTqnqKirxWbd2sB0Ga6aZnmt8WEhmJ5K/8KE8cjD6CW+xN?=
 =?us-ascii?Q?UGhGK9/V86RB8Jz2thQm/yqRu57bLOFTyPfOYaLY8dVSy0VyxKgRAVlzGL7c?=
 =?us-ascii?Q?Hmoi/jgb5QuJV94Y/9VoLnVeH8oZsRWDHILfaSDBid6J6sI5FNRL+WWscyzn?=
 =?us-ascii?Q?RU8AzRxpqpx0w4SmRB2Kh/wDxN4YhbE48HWoFuAYPCsfP09VYfEAWOWb3O1d?=
 =?us-ascii?Q?sy2ZkUOF5Tm2SQr0bBGVu8LjJQ5mafOMafmYmbYupTJoXTtun8nk5wr/5yqy?=
 =?us-ascii?Q?5Ds6duAmsT+oeUu3byMwJbihdKHBjvsVoYL45lgratxA70W3It3o6TxP9YKV?=
 =?us-ascii?Q?g/6fw+fecPmDgOGwRHMD7GcEWhK8Eos/tfW5loNkryOfhBgP+RcUnKvOgh+x?=
 =?us-ascii?Q?HETtJX3WNZpww3HcSWRuF4TRxcPTMfeAEx2qFPov7keK28W0ywd2N8lq7l6q?=
 =?us-ascii?Q?4+9hd8wN81/uTm1sj9fruqvAgjszQCc4bIQbD7lXxDfnq75TqV0ZrNYI+5/8?=
 =?us-ascii?Q?nItqSfNbJn5PikqrQllXxE+7Pb+uWkkXjC5ErRcAUrF87eeoh+nRVEuOboca?=
 =?us-ascii?Q?Zshy+MXN2TYcopANwhADR5L3iNAH6fwNg7FT5jG7lroIXemd/iPvDBn/6d3f?=
 =?us-ascii?Q?QhcIukVl9+p5xjphqu/XLPAAgWTw47uAp/TU7yQ2gcI9PsD9bzkpBJK9Y0nA?=
 =?us-ascii?Q?wtY6XX5ESeLsXkyI1wDK4fBEo56gGauniW3vSo6JPWuiu3llfRtEOjZ/joqB?=
 =?us-ascii?Q?TAmmC0JX1fQCoAdVE6HVTQ8lCeZKWZS3mG4eA6/gwWMFvkrY6STXz2f3vJHd?=
 =?us-ascii?Q?pK6tUp36/bx3uS5L6pg6Ma++F1HQnqwvuHTtDo0LC4FDCL/8T88o7LGhd3dx?=
 =?us-ascii?Q?fGHS2fL98XQ7p0GAJaWJ3VkodDaWczYRDJ8mId5psPFNUZLakaAU7eOPBy4y?=
 =?us-ascii?Q?E/J5ZK9QVaNnlfIYMGlgJLTkuuE/42MkjvmgvcX9ANb+8D0PJxX1hwHUexIi?=
 =?us-ascii?Q?kBMBxEAJzCq86/7xpctRCLzhpw4kkySxAtUvU1Un1zL01TuCZGM9MEEITc2R?=
 =?us-ascii?Q?rAkFSKq7brAG4cpYeJ0TsbyBK93WWagM6cN4ocDAlF4YZa+FVZVNMKQ5NeEI?=
 =?us-ascii?Q?7r79D5lMRFAxg9c5x9bLlXTQHBYmOaEzIh2+LnfVPQitWwIQLgSVTd8KxbRx?=
 =?us-ascii?Q?P0r243g48Mce8eWXEehYmr2hnyde7HY4dopEe9yE+1srqxEkJ93II/zjCrq6?=
 =?us-ascii?Q?YHq2o5UmMRVZcTkblKttfFNDyuE8CBU+t1KK91JMKjLPfVYMR/lB2OPCCXlo?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204d7a5a-a589-4012-58cd-08db3aae751f
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 17:01:56.9076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8mbDJDN0jkybuKySQF6LMW8ADj75ZHx7qtAnYNw99wMwDV1AKsIqeFVEq9/BZ1hA4S4xlm31CSr6jAGgjrxJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8827
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 06:12:34PM -0700, Jakub Kicinski wrote:
> On Mon,  3 Apr 2023 13:34:37 +0300 Vladimir Oltean wrote:
> > +static int mqprio_parse_tc_entry(u32 fp[TC_QOPT_MAX_QUEUE],
> > +				 struct nlattr *opt,
> > +				 unsigned long *seen_tcs,
> > +				 struct netlink_ext_ack *extack)
> > +{
> > +	struct nlattr *tb[TCA_MQPRIO_TC_ENTRY_MAX + 1] = { };
> 
> nit: no need to clear it nla_parse*() zeros the memory

ok.

> > +	int err, tc;
> > +
> > +	err = nla_parse_nested(tb, TCA_MQPRIO_TC_ENTRY_MAX, opt,
> > +			       mqprio_tc_entry_policy, extack);
> > +	if (err < 0)
> > +		return err;
> > +
> > +	if (!tb[TCA_MQPRIO_TC_ENTRY_INDEX]) {
> > +		NL_SET_ERR_MSG(extack, "TC entry index missing");
> 
> Are you not using NL_REQ_ATTR_CHECK() because iproute can't actually
> parse the result? :(

I could use it though.. let's assume that iproute2 is "reference code"
and gets the nlattr structure right. Thus, the NLMSGERR_ATTR_MISS_NEST
would be of more interest for custom user programs.

Speaking of which, is there any reference example of how to use
NLMSGERR_ATTR_MISS_NEST? My search came up empty handed:
https://github.com/search?p=1&q=NLMSGERR_ATTR_MISS_NEST&type=Code

I usually steal from hostap's error_handler(), but it looks like it
hasn't gotten that advanced yet as to re-parse the netlink message to
understand the reason why it got rejected.

> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	tc = nla_get_u32(tb[TCA_MQPRIO_TC_ENTRY_INDEX]);
> > +	if (*seen_tcs & BIT(tc)) {
> > +		NL_SET_ERR_MSG(extack, "Duplicate tc entry");
> 
> set attr in extack?

ok

> minor heads up - I'll take the trivial cleanup patch from Pedro
> so make sure you rebase:
> https://lore.kernel.org/all/20230404203449.1627033-1-pctammela@mojatatu.com/

ok
