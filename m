Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44ABF64A7C4
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbiLLS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiLLS50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:57:26 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2116.outbound.protection.outlook.com [40.107.100.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9289918373;
        Mon, 12 Dec 2022 10:55:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JF03oAgqbPsFIh3XdNsIs+xry5eVaxAiYCcAn2NpkCn1GnLqxP5qfSs49nfM7ygqNX4rFlaWFpWr62Qi641k6xhwOyPgK94kiNWXjwwxcBZS43d3Fspc/TdliKF0LJ/wOsNOBTkQ3tMr8NG5QWJhCfohijADdOnJtsipcbHMuE+EPPUMAHoBCZHmEtn8KYEdCAmykOW1vDPN1JuwP0pmhg/CY8axnJTE7XLfedPPaIhdsqC30ia4zn8n/zeGhn/H5PoSobDAc3Cnu2NXi03fV4unrA3tkl6gEH/vDTapnZiPaGZBkDE7xtX1cXe5c27s+OBV8nxeFZeoTpL8bc1J8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZhMryNmxeDHVe8n1hme5DbdVMuQZyycekSDzUuyi7w=;
 b=BTcMYNNsjr7IrM0SDIq6CTWqYP4KGuClBPFrliKt1L8FYr4h5wdkdv9mVNFyGCRLaLBIrw7N0M4vjEORjyhcS4KDlkJtf3k4sNxyt7U9iWOwUrjYnSTH2mTJKRUqq7OPRHlj6oaX5kY7BoJdXlRl3XfOl1TW7/WdEO+Bq4Ra/aE6RYQgfYvQWFQXMtvhzvEiNT4npG0oJl8ZgmziPrbBgpPi6zE3/I8lbSBT9dnWWHt3vYrXgxBLg4hQtb9EcmmAcEDhff3cewp7qsD1y3RXpL6Gu7TwzLQMn4gH3ja2MCVeEmhMJglthOLuu9IRDP8jwZZ6T34nvamyx8voXSELMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZhMryNmxeDHVe8n1hme5DbdVMuQZyycekSDzUuyi7w=;
 b=fosjG043L0L/woGYSanDVnDLQT6DbHY9Mt+ba25x11jj5CE/RBukYdUudSzwDxcRXFof4bId0PcsLBScMyUH3zJUrXQ0KIYB+MXXBtzPaIAXE8Mq/FYhQqOqWtMLxTJc1tSkAigfnpUm7lX99Lrbja//OqYX9INMkcxaAbkvDlg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4721.namprd10.prod.outlook.com
 (2603:10b6:303:9b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:55:26 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:55:26 +0000
Date:   Mon, 12 Dec 2022 10:55:19 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Rob Herring <robh@kernel.org>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 04/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <Y5d5F9IODF4xhcps@COLIN-DESKTOP1.localdomain>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
 <20221210033033.662553-5-colin.foster@in-advantage.com>
 <1df417b5-a924-33d4-a302-eb526f7124b4@arinc9.com>
 <Y5TJw+zcEDf2ItZ5@euler>
 <c1e40b58-4459-2929-64f3-3e20f36f6947@arinc9.com>
 <20221212165147.GA1092706-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221212165147.GA1092706-robh@kernel.org>
X-ClientProxiedBy: MW4PR03CA0263.namprd03.prod.outlook.com
 (2603:10b6:303:b4::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CO1PR10MB4721:EE_
X-MS-Office365-Filtering-Correlation-Id: bc624099-0634-48ff-904b-08dadc726e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bu/rSAtcBBwE1O0YIjenvw0iQX+ZzFY2MFZxVo6T2EX0n9mNWfUd+X0jYI2F2LVnd957V3qBGbie5NEG81ncqNHp2MRxtxse6rOMOce+sWb4g4p3mG/vDVH0IzGCxMWrNFLMN4aBxmFU5z9e+iwFiC1LOUaXL2JDF1KqeGOGu8LG4k1PGHCPHFaIbv/dn7zulBnSD+N3VLEwNUHUlCXMPeqzFuk56yFrEmhLYRI+eBZP8wibWsy4Ww0auYUG2aFYjA5rWMaGy9HusKp/qgwOORtor/jmCbh5ESMwNlbm0uzENekKWEyf0gepm1EpG2wOhI2AxfuhRRGkzbSNNk/jM43Ta+2mCWrT6mCJacFdcRBx4kMcR8G7zsFtwhNcjjSxBVP05hvBN9edLog2+J8sHnyZ+xP7URotHTZ0OOuQNNkdWCrn01QFLcnIyPR0VQm5wvD8iw+o+vtxnni26xg3WYm/KENp+pBXasL5OHjdWZnebjZqVnEWrntbKeZwmmXySdiRHSOO2ihqhTQFf+Crcw8sJU8zFRxuszF7auN0t5artJcMxIvr0cNwA/V4w0ca10lDTh/8ELbs/b2yPPZeZlrVGadtKwVeIHbye6S6Suow9C4qY4X99jxaGoQKr1mJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(396003)(346002)(136003)(366004)(376002)(451199015)(6486002)(478600001)(6506007)(6666004)(2906002)(66574015)(53546011)(86362001)(44832011)(8936002)(26005)(7406005)(9686003)(186003)(38100700002)(6512007)(7416002)(4326008)(83380400001)(5660300002)(54906003)(41300700001)(8676002)(66946007)(66556008)(66476007)(6916009)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3c4OHh0WHlibmQrakJnMVExTElESzVHOHVuNjRPcDRKNUhtTndYRDlIVzlM?=
 =?utf-8?B?ZWo5UVVrUTFsZU1KMWlPSUJ4S2NPL0ZhVnBjT3BpZ0tORkZiVTVxU2o1d3cw?=
 =?utf-8?B?ZmhHQnY1Y1NyK1pvRFU3WElyTmJNdlpreTlFdENVZUYzenE4OHR0WUtEUUF2?=
 =?utf-8?B?aldiY3JTWVRzeWtFanZVMkgxbDg4QlZMdlN2RGJmTXV5Q01XN3JrV3NUaUd0?=
 =?utf-8?B?bWR6WHQ3Wk53V1FiWmI5WG1zV0tUSGFVUE5JdmJVdmZFU3VUUmYyeG92c1dK?=
 =?utf-8?B?eWo5QUE2aVBzUG81TmJrdVc0dTZ2ZzAvcktTMHpHUUdjdGVqMUhpSkhSZlFH?=
 =?utf-8?B?MWJraHI4ekcxL1BmMG9mZjJOeEhzc3ZMd0xRTFhtTnpLSTE3T3BENlhIWjZK?=
 =?utf-8?B?bmJhNE85Ny9xTnNoUlJyTisvYm9TeE00WENjQXF4VzdYY2lXZHFUWG4wMml1?=
 =?utf-8?B?anRGS05RbHQyV0xiM1N6TVZIc1V6UkhIVTU5eUtoOWM5ZHBkSVZHYjczR01N?=
 =?utf-8?B?ODlnM2MwS0s3ZnNzYjhvM25yb2t4UkRLNGdabzBQN0FmOWRsUWMxSm81U1Zu?=
 =?utf-8?B?cHNhNmp4UU8yREF0YUJIV2cxVGpmNUZzZWhqSkNZVG5YYnlaaE1BN0IzQm1k?=
 =?utf-8?B?S3RGTURidmRJdVFuZTJQMDlxU09qckZMSWd3SHVBTllWRHpyNTlFR1J5OFRa?=
 =?utf-8?B?UHlhZStza3N0V0p6ZDBxZU1QYjFscCtobVBzakpXclhXNW5tbENLNGxqUytP?=
 =?utf-8?B?VjBsTEcyMzNwem9KbXFjUE9RdXVjNlhocFJTSGtQMjc5SHVZaFJZTldEMHl1?=
 =?utf-8?B?ek9OQ3EwREVyb00weFBJY3FobTJJSUxxMEFXY3lXMjdTc2pOSTZRK3pIRnZV?=
 =?utf-8?B?Qm16aUQ4SlBwbE5ZZStaSUwrYzU4STZPWG5wUnhxbkMwb3lheWphVnFmRnRY?=
 =?utf-8?B?YjRwZVcwb0dneklqK1hmTWh0YmhFcVhwTkVFMkEyZWIwS3p2MzdXRGljNzBU?=
 =?utf-8?B?dGY4dmVFSXJuYnN2eFp0S05heTA3ajF2cVVPK0ZSeWt0MnNDbG9IOUNDcEpO?=
 =?utf-8?B?dXJzRDFlSFptbkxIZzYySjNwSEdzbTdrL09GZERuSExNZldqeThudTVwWUNC?=
 =?utf-8?B?VmpDNGgvTEcwWlo2UTlUd0k0SW80N2VJZitNaHVCV0tCa2dCYkFYNG9uVUlK?=
 =?utf-8?B?UllVMk1oUk9qOHd5ZDlCT29Ia01lb25GRzVFZnFkUk9OZG5rejUwZHZITThT?=
 =?utf-8?B?U01RbFkra1BnV2NDSGFlR01FVUxnUElmWGsvRkFoS0ZBYmo0ZFhKa3RiUmNv?=
 =?utf-8?B?K0ltVktjalJXR2VrUHUvcGl0d2VhK3g0dlFTQjhUam9CU1ByVFVqdXRvQmZk?=
 =?utf-8?B?b0s2ME52YkNMRXRvb0JkS0FDWUtFT1hIRC8rb2JnSGdCeDlFK1ZkK3BuSTY4?=
 =?utf-8?B?YjN3czRQOTlkMTlNU1BLNDg1a0pzbGNxOFpSUDUvbnhFcGhDWnJkVUh5S0ZR?=
 =?utf-8?B?VFllV2dpV0cxeXFiUVFrUmNrUlRuR1hnVzFRTWZqTi9qSms2dFhPV0lJbFhL?=
 =?utf-8?B?cmxxSGdWbDgvWm44alZaOTdTQ0trZCtHTDF4OHZpVWkwZVRzdys2TlpqamZQ?=
 =?utf-8?B?K01VSFNvNGFLQ2VBZTNCdC9ueUV6V1YrbVF1cHBvdW12ZnNqR0NDMGNJemht?=
 =?utf-8?B?VFN3N2VWc2hwN3pzaHQycHJwNVpIcXJoc3JlQjJGNkgwODh6eG5yUnQ5c1E0?=
 =?utf-8?B?Q2tDNUhnb1hZWWlXL1VxYmw1SGwwU0JIWjFNS3RnY3FEQlFWQ1hnbWJabUU0?=
 =?utf-8?B?UHg4alN5ZUlYKzVXbGhCczM2ZXErd3luS3Uvb1RzWHd3ejliZ2M4UUhZbzdU?=
 =?utf-8?B?N3BTcWVXNmluMjVzTzgybG5ZY3BFSnBUVTAvOTEvWFJpcGpOWHA2TkxBQlRa?=
 =?utf-8?B?QkRwa3BNZzZYa3JQeWduM2JkdTFHS1h1QUE2OU8zSlRxL01PTEFUT3p0M0JX?=
 =?utf-8?B?a0FpWWE0OFUzYmdZWDRaS0crNlpXVFVYU3k3SWFjcElodk1MUStIRk5vcThB?=
 =?utf-8?B?TXJqYWFBekkzTTJqTURRamIwbVJXdjRGbkt2NFllcXIzTVR2dUFJK1pqQUpX?=
 =?utf-8?B?ZUg0TGhJQXR3c1p3ajRZOWdoWDN4N3BlWEZySFlFMjczVldxU0w5OCtnT3pM?=
 =?utf-8?B?OHc9PQ==?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc624099-0634-48ff-904b-08dadc726e56
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:55:26.5489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8aWIGJbVklu1ClrQTIhBlbCkLUJFcuN2gZxhdRSydxPAme7GGCZGHv3LVXOci8Gk4AsUUMAimulR6LNXAkb0MxrMgQ7nd2WrF0fZU/paqXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4721
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob, Arınç,

On Mon, Dec 12, 2022 at 10:51:47AM -0600, Rob Herring wrote:
> On Mon, Dec 12, 2022 at 12:28:06PM +0300, Arınç ÜNAL wrote:
> > On 10.12.2022 21:02, Colin Foster wrote:
> > > Hi Arınç,
> > > On Sat, Dec 10, 2022 at 07:24:42PM +0300, Arınç ÜNAL wrote:
> > > > On 10.12.2022 06:30, Colin Foster wrote:
> > > --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> > > +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yam
> > > @@ -156,8 +156,7 @@ patternProperties:
> > > 
> > >       patternProperties:
> > >         "^(ethernet-)?port@[0-9]+$":
> > > -        type: object
> > > -
> > > +        $ref: dsa-port.yaml#
> > >           properties:
> > >             reg:
> > >               description:
> > > @@ -165,7 +164,6 @@ patternProperties:
> > >                 for user ports.
> > > 
> > >           allOf:
> > > -          - $ref: dsa-port.yaml#
> > >             - if:
> > >                 required: [ ethernet ]
> > >               then:
> > > 
> > > 
> > > 
> > > This one has me [still] scratching my head...
> > 
> > Right there with you. In addition to this, having or deleting type object
> > on/from "^(ethernet-)?ports$" and "^(ethernet-)?port@[0-9]+$" on dsa.yaml
> > doesn't cause any warnings (checked with make dt_binding_check
> > DT_SCHEMA_FILES=net/dsa) which makes me question why it's there in the first
> > place.
> 
> 
> That check probably doesn't consider an ref being under an 'allOf'. 
> Perhaps what is missing in understanding is every schema at the 
> top-level has an implicit 'type: object'. But nothing is ever implicit 
> in json-schema which will silently ignore keywords which don't make 
> sense for an instance type. Instead of a bunch of boilerplate, the 
> processed schema has 'type' added in lots of cases such as this one.
> 
> Rob

What do you suggest on this set? I think this is the only outstanding
issue, and Jakub brought up the possibility of applying end of today
(maybe 5-6 hours from now in the US).

It seems like there's an issue with the dt_bindings_check that causes
the "allOf: $ref" to throw a warning when it shouldn't. So removing the
"type: object" was supposed to be correct, but throws warnings.

It seems like keeping this patch as-is and updating it when the check
gets fixed might be an acceptable path, but I'd understand if you
disagree and prefer a resubmission.
