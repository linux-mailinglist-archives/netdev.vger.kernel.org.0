Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BA86B7B62
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjCMPBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjCMPBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:01:41 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2128.outbound.protection.outlook.com [40.107.237.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98766D339;
        Mon, 13 Mar 2023 08:01:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHM9FEG3l6SmrbO7LnL0Q0Umd8x2uXS4GYML3WGDZ4ElBd263kajCwPGgMyzPxmTfk+EP5eh7kZdN5bXDpmENblp6EI2RHDLC07VpFFEtGcYgXkGnW7roR7RiutpPKqq4Br77af+p0NcYAcRbNLSaRTqoFOz8UFvh7EX4aXCGAKkgevuD29HfiAqWfIqbmhwZb6UvFnRHrhX8ZC+AWUd07nDcFXUvn1BJfuAIKD095TTJkxSencG07yp5g2mAnb7dSB9oP4+amQz9lTarz9lujcwOhY0D2w7K6jDnzWWhNVrmeyj9RqwfcooYV1NttaewApQujBf4I2IHDlkHekuAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JS4BIBFoPj2EGOX7tLbb28jrjP+zGBl1ANWAf3MtL/I=;
 b=i6JMGRirf1+qpuRVxqKaAqQb5yEnPXVaTsOMN9Mk7V1v2twBZsPtYmTRQe4CVi1pEC/mh1/9oP8bw+gTdgfgfYh37Xs0imemOGZAA5QvfEL/P4ffphMT7xBNlxUp1i5Mr0J8qktyG5nZQI1+wzyRM2hF9JdzobsWg5WfusEk2xloqm/8OvTTRHMVPcirvY7tWdzpGXf9ob6VghWDyVR3n0Lc2LmeZJ2G+0u8Ngcw/S39uB+CCWolDG+rg1f2BlwAmOpeTqPZsBLj7lxZwMxGkEOk4LE/rw8S+Np1MnjWRrP7z1228/cB+sq9208eIWYoEEBgTeaqUFQG6c1zBFI7TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JS4BIBFoPj2EGOX7tLbb28jrjP+zGBl1ANWAf3MtL/I=;
 b=ooez4cxk5fMtSTFUlrkiFikDG3ZUB2nKm8XsCAnSqqG87ejBPuSS2hV5dTqjLyN8wR/6m3QOrEC63Ppbl9tW261lZ+IvjQ7Y7WScAAhcSlKIUBkflx3twQB+pkEZz/saFeonQ/a3GtHAoVWGi0GEnL8umCDZsuzziuFoXewRLNI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3908.namprd13.prod.outlook.com (2603:10b6:5:2a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 15:00:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 15:00:51 +0000
Date:   Mon, 13 Mar 2023 16:00:41 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/13] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
Message-ID: <ZA86mThUeARDfnN/@corigine.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
 <20230311215616.jdh6qy6uuwwt5re7@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311215616.jdh6qy6uuwwt5re7@skbuf>
X-ClientProxiedBy: AS4P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3908:EE_
X-MS-Office365-Filtering-Correlation-Id: e260b754-eac2-42cb-10c4-08db23d3bc35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZSM6C7F/u6688sO/QCfxYI2uojoBberZY9up21jvU9LNRnWEf+LKjASl6+37hs5clNPhdnAKbpRgrqQvH8zAOXMJcWiSrRDhy2m3h2XViRYI4v6uJ8jME+xbCBNR3nAJDFEjIdWlBrMBppxox5fMTvrvWYO/MqkPXoH2QVDcyg1U1M+Ue3T7F7DDgP0H82nLMY89R06juIvM4q7+e4RA/NPhOK3H8o5W0IzgQuDEdrgBy5owwPyjLKeYvthXneL1ZZ5L0zRSHQj8QgH7eD8zGrkUGh9mZbKJstJj2QVfbx5EMsc4t6zOGPNvP39aFMrWRe6ps+Vkr0bazjH5WDIDpbSKzWLOuSkMuGf5p1BuGQ2ubzXUl0ATmUxvIZdIhXFufKyBBxPY/fwdiPoZ1jVzqSgKBRYZ4pswktOKp+lP3I7Mw7ZX62tXmxMVt5dNk3Rp37/uoFKQ4RzgfE15C8CIcnHFq4Hv3Opmgz7ppkr/A5Uj6VEGKjLDKNi4/tl1KuasppLhPKb7iiW19F593Z8Ya0DLR6cWE9lPisrytQky7+NW8wC/d8sSxrLIj2dAa5qVkha7fxikbQTdxws1VhZvFaT+rkRn1jElKuLdzRdx0zdnoqnb9j+Nb8yWFNE/oyDXbAT7Ieb7e5UEEh2poKC+XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39840400004)(346002)(366004)(136003)(451199018)(54906003)(41300700001)(478600001)(8936002)(8676002)(66556008)(66476007)(66946007)(4326008)(6916009)(86362001)(36756003)(38100700002)(6506007)(186003)(6666004)(6512007)(7416002)(44832011)(5660300002)(4744005)(2906002)(316002)(6486002)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LBAmU27zQ12px9H95+f9dY67JmR+ayzdWJ6HVLZrkfadaNqwtTwhWMm7ji0t?=
 =?us-ascii?Q?SJDKCjMwl8HRogc35G5Df87KaI4wkOTF7GiGqZkoBJAEbxJDdoieV3jA9a46?=
 =?us-ascii?Q?MiLpG838oIrvQVpuCcZJILn53hct/ZUFU3t+2qiE3UnZ0l5exRp6OMywZT5U?=
 =?us-ascii?Q?2dy1V767XvCpaxP+eqHvoH2b5JW0P+xB0VPal+8lXbAhgTyuDIXQ82k6NqVj?=
 =?us-ascii?Q?sbF7QrvT/4ATYv1oWSH4dediivgeYAw5xxN6Wm3fN0WKALBbz2jbCxudIfek?=
 =?us-ascii?Q?IdFWX8URj2VxcKFe62EVVo18LWEsWwIi19DtPiKesKTRNbvIKDHn3ZqgYT9j?=
 =?us-ascii?Q?Wi6fXTEqkwoQRa+zTz3q7ph3+FYKhD1SrpOa3QBTIwizfj7JEA8D7kltJKBp?=
 =?us-ascii?Q?ETdea5jmLmmGCmk9XlWV0GfARhuuhQZaxCv8wY+M/5g+Q5tFLjqID176MDmd?=
 =?us-ascii?Q?dQ+N3P/f7srRzadFjDNiCyoqYUy/6Ok7yaYMtR296v/zvYZJmPZNFAXTqvQU?=
 =?us-ascii?Q?Ewc6haZ8QTfjadNH/b8Py7HZHEb32EqkeqXll72e4jgtu9qkfOUL9AcmwmWb?=
 =?us-ascii?Q?l0nZgNdSahHmxNwIf5bqUXYhyh4Sx4vIxA1ruYV0rYmTPSTNmbBo7CJ+VFxl?=
 =?us-ascii?Q?dACd/9chnHtg/+OxryD1Zfp2ilWQRroNNcVcGRJqStQ7PHKlZH9A6B3OR2pv?=
 =?us-ascii?Q?jmFld9MTTs3E97X1SrEciTsyaBbYlS9ehD6J/hnz5vukhfy6nU5bCoHaPwYw?=
 =?us-ascii?Q?lvhgpksOotC+QmkUTFadisOI2UtlooD2JVXWIlVcpMECErauSzrq0MI0kPeC?=
 =?us-ascii?Q?ThLZfFXskTyz/IMRPKWetyh21XjxEs6cn1IWM3phs3ilZr/6ZwzhZmzNkq2t?=
 =?us-ascii?Q?g0NAXhcVC1Y3blO+4whV7981ku/y8VdBmblqLAVDr0LFZureDund3FKUPjB/?=
 =?us-ascii?Q?utQIsw+LEDxcKD1RGjUKrs398JF1UHBZR0IrQ3DkHhfmkDrTztf8knjJitAY?=
 =?us-ascii?Q?sqUaQu/pKXBDj3VLDMKSLMSbuAHRfsxkBaDDTK26p7dd1HwfFdktVtQ/kANJ?=
 =?us-ascii?Q?HhZXwqf5LXRzSeykEC7qdxkrqXRkldR1U6aRktZuIqJgH6qgC/RQGhaHOYMK?=
 =?us-ascii?Q?6kAcmTNYd7byfVUfspuzQmw3snAwocIv4NMPtVAUy5fjAiss4gHcdWYwPRs0?=
 =?us-ascii?Q?n5YmOlmuNqrhVePHS/Eu8Mdkxg0KnUpyxgyNOW8Tm6FBAl6ihyvC1L12CBD4?=
 =?us-ascii?Q?/3Ug/hgMknOn1xKDzK3bA0ZioWoaWaSHZ/FSkyzVbEzOPtVbqEcf73RRnKsa?=
 =?us-ascii?Q?Xu6cIJpbC4fD0Xz4u1h3WZgXx/kLLaHJTLOPNbAAREnF2r2sapIgMN1ZcROq?=
 =?us-ascii?Q?3+aJkGPLde/xNv0puWiaxi7+2dm4u8fb1ShB8x2tRdebZL1SAa2L/snf3JXJ?=
 =?us-ascii?Q?dMq5V7MSFo05cQBOP7X6omMCfZGPmV9jcG+EN/G6dusU9AMnLFb07YNwzFxZ?=
 =?us-ascii?Q?wdj0gZEuF2BNwlSwJT02iIXV7fjQhICMu4N2QKYvVR2CPB0d2X+zLLQM8bQe?=
 =?us-ascii?Q?yxr9sxDEtq6XOZ/BOqlwUIakXGWQ8VNfbysy3Or1MvT8CDQVBDJNU5urWWK8?=
 =?us-ascii?Q?UnUuoHp1n41J/RbCWpu1o/vKwFGETFbTIalWhRsStX3bpgrrlUhUIKDkZdJX?=
 =?us-ascii?Q?jS4QJg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e260b754-eac2-42cb-10c4-08db23d3bc35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 15:00:51.0097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhEC8hOldTx9/rmuN26SwQn5RH38FkCNt6hafYy0PJPUtpCdRiYF3iQtLASqeYojYPTx5ZqARA9oUbHOllvkOqioToT5N2NGSX3yma5Y18U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3908
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 11:56:16PM +0200, Vladimir Oltean wrote:
> On Mon, Feb 20, 2023 at 02:23:30PM +0200, Vladimir Oltean wrote:
> > This series proposes that we use the Qdisc layer, through separate
> > (albeit very similar) UAPI in mqprio and taprio, and that both these
> > Qdiscs pass the information down to the offloading device driver through
> > the common mqprio offload structure (which taprio also passes).
> 
> Are there any comments before I resend this? So far I have no changes
> planned for v4.

FWIIW, I am now reviewing v3 - I missed that only the first patch was
was applied when the message from patch bot arrived. So far I
am up to patch 08/13 and nothing stands out so far. And I can just as
easily review v4.
