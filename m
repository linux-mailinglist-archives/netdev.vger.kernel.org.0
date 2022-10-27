Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5F360EE0D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 04:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbiJ0Co5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 22:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbiJ0Coz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 22:44:55 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195535AA1A;
        Wed, 26 Oct 2022 19:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fV35kpkDXwnQC4NXRWRtxKz/MS3eU7C1ONWvnKSUV3zyh+CvjMYlOQO7eNQ1jmKQGXuZY9J9T9mpck4R/HETss0yLqidpMT/a/bVHeIe0UAMJsJM1bpRtXgsLLcjE8+N3iyAhp0ggmlQDptmuIHDbQ8yLoZE8/jrWRwfBWyYjqENRy8brm6kRJmK1uV7meTw8ne4cOd13jsOyoAwr6LDbMIJB3wA5idbnDK0fiTVTW4ihUqlxxfQ49gUZrnGRHHfMMMrLPjUr1JoVCLuEXNBB0ioBmETKhQsaOXsllloEQmF7n/emapQhTZt3KPpJLZPPgk7vfUKFrgtQyXEJFyXGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTglUEfd/2mxFd6h4tY5fCQG7mkIUfnhA2eEMBOwcFQ=;
 b=UElpQkkAAhvNdjWozgVJyw55I1j338Mm+FgDaJ+/OwkbKARhQZw12U+mOcaubDZKXm4HGdlGUpINthTKc3p0Ldh2hrzKRYtpKhz2zsQ132fEBOEjC7/9zkwBfg0K+8v3eCxzwfb6SDkCFBYayG1/naCVR6hqLNcvQd/fsOEck5+mUZb1APPgoGFiG8HCYDuBZWy1/mLn/Zfhi4aAoES5TchumJVNDXeytetZ2I8TulZ0HAmVy+Nd9LOlGwa7Pf6TkDIwobaapR+LanQghaZB8KKB4brLWxaTqQGjQTnnqjci19F1ou6h+GlazUtlFUu+v/KcnbmJ+phD4g7CzOPtTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTglUEfd/2mxFd6h4tY5fCQG7mkIUfnhA2eEMBOwcFQ=;
 b=aaT0fBAZWjJIxJMZfgkCwow7hjz6pjKg8s+4E3d35KDuT8hLYolao4PbzJG9bfz+5r8tn63DSdBg8auEDMtmQriQhnDdWPz9x8tk2W6+RwbtxwFshYjuu81wWDASbBkVXC6jbkFQDqGkDjAkKsNh2twOSlrAenAPRg5AgOCtXbA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY8PR10MB6609.namprd10.prod.outlook.com
 (2603:10b6:930:57::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 02:44:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 02:44:51 +0000
Date:   Wed, 26 Oct 2022 19:44:46 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v1 net-next 3/7] dt-bindings: net: dsa: qca8k: utilize
 shared dsa.yaml
Message-ID: <Y1nwnhjhb06mg0F/@euler>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
 <20221025050355.3979380-4-colin.foster@in-advantage.com>
 <20221025212114.GA3322299-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025212114.GA3322299-robh@kernel.org>
X-ClientProxiedBy: SJ0PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CY8PR10MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e73aa49-c3f4-4764-e491-08dab7c53856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9SjewHRvd9yu9Y4iNL0ZZXMAjau0+vkL4Tri5krFb7w1aJX0dghIkA4TPV6vyRa2zs5fqxJOWPi5Rd4FxQAygmd7WstN4QrS9PeOCQSUDxzlixb8aFJV9Kgwm/SuNmO3mcaBX1U2RniQgcrMI4w1Y/L4OZBFi8mBhPDHWN2qA71AJjjR/4AmKPCV27ue+F2GpykfsoKi2cFXeDULZIAf3U0L2QgZYF3UJGrsSnO2arbL9dXJwwHjm6RPZgJ3BtL9pdXWarkK6fZI15OEEAPOGSNXhLXakwhi4fTBqYRuOzKhMn7Wc5V2v51LC/Hj1kYuSvYO8zCPNcF+mrrSPEqRyD8mp01Q2X+DpXav0WEcrAVg7qgSqxO4FSESW47eRWN+EjG/wc/JNWilEri16Ovmbo6NWNrGQBVlJwGpdAz2eDreIOM8NC6VFpV0fYRA4jS34LtmzJsfcb/8/FlKfR08R7Qc/HqVLOjm7NTqunYXjtvE1HwdZx9XKratH8+9fQqTq+85l64PkeU5+tgTNq3wWyH49B5NaVawZC6sm6Gqm/OHCV2pzoTx3XEJKUe+Xfy22FJ9gUm6J7BjEW276EQbaAvDG1QQ9d5ojSNBlIn6feh2JE6a6K4bdZRiZtaUK0f4Z/pN/PEVzo9trOfwZwn+27MMsGdryzDUC+Ai4Oxd/ZVBY0FhXsJ5YW5PrlJQKHIzbQi+Jt5rtdrm4LFGrHxy8OE7f6914ewMHZ8/G6LLbsUMMt9GeNCnY4fgGZydQWvqA+V50OOcrdOhy2mgIhYVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(346002)(376002)(366004)(39840400004)(451199015)(8676002)(4326008)(66476007)(66556008)(6506007)(6666004)(66946007)(186003)(6512007)(44832011)(2906002)(9686003)(26005)(7416002)(41300700001)(8936002)(478600001)(5660300002)(38100700002)(316002)(86362001)(6486002)(966005)(54906003)(6916009)(33716001)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?18Qax4U0NE+s0VmOiLzrRffrOPUjj4cZYm+bb9MAuTpj8TcjU5k7kaHDbiml?=
 =?us-ascii?Q?cFYpfW87SlxvgeeNeOwv1aRV5YqVt/8L3KEL3MUHYzIo4HhtbCe1pNuPfEaE?=
 =?us-ascii?Q?9d7o5FBXwNsNb/y2Vb4FzAxEnX4j5T/zGCha7avoGKsIBPtNRGQkBhQ727Rw?=
 =?us-ascii?Q?+5Pw25zDxN8aXK47Q9sfVIvMP8noegIM3FSFvhgaZrx5+Q5Fg1R/LILP42cC?=
 =?us-ascii?Q?mbdPD4fPKPz0CzktUlLorz5Qr89QrTLPcG8B0kkTWUPen7qcNB0pp5brhRmr?=
 =?us-ascii?Q?vgEoGGrSrr7rZSiuqOYxdEYtGqX92/iTZ+aiL4Q0BX8uqtYeZ+rsTJ84Nplv?=
 =?us-ascii?Q?l/MvZYZsxDSJL7tP+PJmXXOJ2hYiSqVjl5LQTCC1s+ulH5BWSjTy4RQCBVNg?=
 =?us-ascii?Q?/tXie1Ggr6SyKy4PZOwv0a7Inwth9KXh1VDON9oDjyWnFmwJuZY0oZmlWt2G?=
 =?us-ascii?Q?MjkWxard1KtFYM0TLsOfBySsny8z6XeNXv1LFD9NE8nyLicIFhCD8hunb0cq?=
 =?us-ascii?Q?AkjB7yEKg3e3UNq7jfIEE3WTK/afklNRAIedz05ujq70ieVs/m8e5Ui0caDT?=
 =?us-ascii?Q?lACgNpOubjS1lY+TB7/QgrWuA367q563VdfHuYiJFp3c3vWosBXRq4DLsV6z?=
 =?us-ascii?Q?gRXiq2hmTVNVGtXptwrM3WfylHtvTzUeq+kXClq7yHIP3kvrWMwhLYtNizC6?=
 =?us-ascii?Q?PiCF0aovYFbmjFAzouWEW74zOvvNpSf380aesNIQcbGVBh2nMw/a+A9UNtlE?=
 =?us-ascii?Q?1pD34St+M7r14OthqqR+HE8WJmaJeva9+JukKC9veVr13vCcDUeXun7FBeV0?=
 =?us-ascii?Q?R0gEdD7zhsILcShxLq/z+e/DtN2FbqhuYSTPyt08kFBcpuf4CHcpfXDnojHu?=
 =?us-ascii?Q?GE4g5dUJ+nLF/ZO2q0XnU9SXTx4DjJ1nh2VAPR6qXdO/rFHut/elfRMu2tkK?=
 =?us-ascii?Q?EtLVDhZuLBDCtPlhjisT+9OX/vc/2/IhKtOXQnU6dxJVnk1NTbU95OheDZCk?=
 =?us-ascii?Q?Gm1U5cmafYAqGkeORcxb78rvs+cblafWhHbYxHyQkdovZCZ2h9vU80+vOG8U?=
 =?us-ascii?Q?U9mqgA5BDa7g6TOrweKdJipixcVwVh5gl8KnNJkS0Eibimd+2OrqIXgEIBX/?=
 =?us-ascii?Q?QxuHQm+vhwZWtQPyA+ph6pOhRE9qqx1MCAXo+L4+ZOsOiK6rFGhFEgLyNWyD?=
 =?us-ascii?Q?YPUq9QTmzN8JdVQjA1MdA30b+4jAvLc9rB2Ni2VKjj9ERrsOalMrNEomg+Zl?=
 =?us-ascii?Q?NmbG+fCdUMhF3Pk4foyGyoTwaBMJVgBiYW3QLg/Rhj+ows5ITmC+l5I3hrtJ?=
 =?us-ascii?Q?Jcnm6g0GZ781ajmb0wT/9tsm9cBc8R0qbneJs+KqtUJVtCuj14gAI3epE5+O?=
 =?us-ascii?Q?0BfGtt9/aMiZxy3fh6YTLnFrNb/xNNm6yz0ttEEhf/XPe+wxwcIJtpBlp+5B?=
 =?us-ascii?Q?9319VoXLL2ca7zogtl/gCn7yNhMsaA/fUs7DXpGOU5s7w4K7IdliWtDEcB5Z?=
 =?us-ascii?Q?tM77S5uRer1wfFIStI6KwQqx8ZnpUq7pPYPN5rH0oVefD7p1IuYawT4VLEiu?=
 =?us-ascii?Q?VJYFEDFIp0cgjN+Fix94WiM1vuJ/eCCG5UBlBsdVSmi4/1KTUjzDmNIuck7a?=
 =?us-ascii?Q?gA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e73aa49-c3f4-4764-e491-08dab7c53856
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 02:44:51.1442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3oXzabisqZUq1Yc49WMctuVeqYayjRrb2XelgQt05l3J2yu2tnRmNzvu/D0gvRYRXTV5FnSmLPw9ucgrSlqhN0risrCyhUvTydaVnZ7t1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Tue, Oct 25, 2022 at 04:21:14PM -0500, Rob Herring wrote:
> On Mon, Oct 24, 2022 at 10:03:51PM -0700, Colin Foster wrote:
> > The dsa.yaml binding contains duplicated bindings for address and size
> > cells, as well as the reference to dsa-port.yaml. Instead of duplicating
> > this information, remove the reference to dsa-port.yaml and include the
> > full reference to dsa.yaml.
> 
> I don't think this works without further restructuring. Essentially, 
> 'unevaluatedProperties' on works on a single level. So every level has 
> to define all properties at that level either directly in 
> properties/patternProperties or within a $ref.
> 
> See how graph.yaml is structured and referenced for an example how this 
> has to work.

Thanks for pointing me to this. I didn't know about
https://github.com/devicetree-org/dt-schema until now, so I'll take a
look. I was primarily reading the schemas in net/dsa/* to try to get a
full understanding of the DT schema nuances, so these types of nudges
really help me.

And I see that Vladimir Oltean has responded to other parts of the
email, so I'll leave this as a simple "thanks" and keep that context
going forward.

