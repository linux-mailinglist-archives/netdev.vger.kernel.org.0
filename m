Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C5268EE0D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjBHLhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBHLhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:37:06 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050E8457E1
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:37:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BACdsmDxkv/t8pege+HifFOQkduMJO+y+DYg9iDWhdz/zOSDP9NQMa4bRKGGgEfk9aYxAnsBxF5CQxv0Tf3gjP6IqfctwZn+Rm6Es2pWq/hmEUDYgBeSlZlI/DbLRAW+qXB+CnN1cEVBd9Rm6/ssxOnH8l1OmeF20zZHazGmhfucssyB8ODF9lcGo/mn+6WXFfee8DyjKwLtsUjksKBAxW1tUADe9Y4XeH7hXzangr1Giuj78PaNoQX0U0FhifAq4NJ8JKxGRhgXf7d132lmgu20GoNb44zK8ry2FW1vbP2zbbqKUAZS+RiXWNqEm2DwsqHMepo48MHA9kkAI1/P2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zoOvGJzIMu4ui5BOImDlMJ0gszBq5I0aI8jAWyetlTA=;
 b=Beh3V1qZx+6SEPkSUpKebIKsKQyOPfoviW6nDDQuGPMDC6OG6QcYuh5z8EGZL3EguByBYjcuT7GX5+9M5D97pxqDB2bBpNKicvGBRAzKhttHXYevPLGOEp2yDQfJCXUwKvL5HMq2pjnAGw2hadA3I7US7kryPsx08kQ9pVRG0TqtNyf8BGz/NE5Seca5jc7m3INFf6ziHa1Axi6HgN7SYkznbA8q0HO/to7E3EksSJQQ/Zrb11eBZWwWNhmVWjcenXznZ4cTFr8TKJRhHIz7n2FJg+PPTfrUWbJ/5ikTE7RvqseWDe/se4ij/NjFbJAkosFlPkkuw8coQs0buAcRYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoOvGJzIMu4ui5BOImDlMJ0gszBq5I0aI8jAWyetlTA=;
 b=CXoJVy9tDGvsBfMl/b8I02BAgQa5bL6tp6T5A5wFgs7qY9Kehk7U4YcRzFOj+PPMqDsvFB1EEexP1pQHt24HvwANa9OA7xaSmg4+JFCZTVd7xRWJr6If8qp0Qw92KNnsSl0j1doRyxPfiQ0A16d7y0LG0RG4MuQ9yBk3NP6dAZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6157.namprd13.prod.outlook.com (2603:10b6:806:350::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 11:37:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 11:37:00 +0000
Date:   Wed, 8 Feb 2023 12:36:53 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OJVW8f/vL9redb@corigine.com>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
 <Y+OFspnA69XxCnpI@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+OFspnA69XxCnpI@unreal>
X-ClientProxiedBy: AM0PR02CA0029.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: 7968c212-2cbb-4dc0-ec3f-08db09c8cac7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7pNfga6BOqR5OWcX0lzao071DIStfezbtTbzKepSJ1JZYop3excrEIhIv/2OCQ+Duw8QizN7f/wCqMx/u19quLS4cEIh9E/8Ji0jsEL5TFvhAE0ZqeDmEkK3ETcz4K5jFqR9ZoZbh5Vqdmsb/V5hjG8Rhy7Dr7YrpoMD6RoyQEtdEv0iFeQloLMc+PXrXXZiHER0dtsz78gzN7piMDYyrg6nmryL5o0sIu4Q9MOy7EwTBOdyhQI6FZkUbyCG9HC0+34P0DGDEU2Fu4gWoLtT9oC3vxbUVtcdeV/7ZhSCn08G71wJVfaAGJgC7BtlqYrEgqOgU1r9zTaugk76Pj3qG6ib3QRicimGPZYvJI8BNsNrEhlvtu12L3vc4gKp1FntQWBaTHGj0JzaOuz+MFy9YraOz2k03wL1E2+7AgKD42s2WExMGaKwMF4jCBUgEs9mXlty5p8vCu2yGIbIbbWlyDvD2wHDF/xOrpsOm5nlLuFe6h4z51bdxf+tJbDZznmV4swemnnwGSGTtXDOKo/LaEea4kiBtqQ6Tc1LJDjq+xRYDlu1Iyp2nIAmh6r4GZDhhqWqdGL6t37aiDNIkuGFkNmHOszngehE1qiRuBe+aWUZgsKYLiOBqYuJ+WleYm+iYaNs5sxhTPK2L49Bv02smA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(376002)(346002)(136003)(451199018)(38100700002)(6506007)(41300700001)(6512007)(186003)(8936002)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(2616005)(5660300002)(44832011)(36756003)(7416002)(316002)(86362001)(54906003)(107886003)(6666004)(478600001)(6486002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sAh0O7QByi+LJo/wo3V7h9bdAAQWi9GzauCuc5FfdfCGSRGusxtJ+X8M3/NZ?=
 =?us-ascii?Q?y47woIWWT11iKp+MWVtC1Ctl9Jl8LrldH/BBaeK8BvglUbxKgw1DyPxbO8/E?=
 =?us-ascii?Q?8Y31bvX00fvUmBgaYfc0egVo68DSGDqfnIBnGxX2g3qir3uvVohvxRmTVHwg?=
 =?us-ascii?Q?q4uuiwgcjo/YUuDxOTb5ixzKmhMwBsw3zu9vdJ2BSuLRB0SFVoWbSscbSq6A?=
 =?us-ascii?Q?ZjMui5e5Tsh1+WaeHBs0sB8UYLSWyAO1dY2cvZWXc/uRvw6N0PgCAy5VpjOF?=
 =?us-ascii?Q?0vwJMO5CRte+u9h64YYFRYX/OpJGhJoNqkC6sLFazWCmTnNnSZwFwcVmf/GA?=
 =?us-ascii?Q?916CJA2CJilvFKg7H0MTO8DAGXdMc1H/w6AaFXEIPpJ0KjAJTqTuIAhdk1RW?=
 =?us-ascii?Q?Tkk3G+jKQOs37XRxpnWdK9HVIdB39eSKuny+ZPxx5w8Cfl2AeWWrtEJs8ulj?=
 =?us-ascii?Q?kg3miDM+HRmNxPdAIf1p2zUS1w7cSu9ChZSKLbF19C7kfMrqgaBC7YwCuH8j?=
 =?us-ascii?Q?GmuHyky7MxYzFk9hdyzzoAEQAfzaQ2kARRlCTSWmUPwg/qTyUwyHj/xjiWMW?=
 =?us-ascii?Q?Wve2TLqiyFkGYpMP3eN2ZohC8a6kMsfy7vN2YFVTC+teQoeYg1sNSSqyc6aS?=
 =?us-ascii?Q?9RE1fgKsVzeQgCwjmEHTr/PPWqIo5oCXTrV6TvHi7FctkgLxzAfLyAj/3fsO?=
 =?us-ascii?Q?+uJq7ZHliCjrrKAFuBpsoH3GKtifmwRcqhdUWlwNYLekjWLIv2Q7q6cuWEPR?=
 =?us-ascii?Q?h1IOCrT3RQSS74QMPGVhqZFgybOTcWBOrSb4c/tT7d7hQUwqviEAYFWxEmZl?=
 =?us-ascii?Q?+y4pVNxkzIZPkrlxLsQu1OyX0XGr4y1cPfUuTzhAMTvj/8J3il/ccyD1qELB?=
 =?us-ascii?Q?zg+tZWpcw3s9HKoI8qe27BLEeaWtqCFsp1bsSHDBqdEvUtliTYf4NNi0xTp0?=
 =?us-ascii?Q?Mr5vQV/eTzwvd0j9sNCixL80qoFxnEL1DYik+ybhNdaNeEMThPcwD7/spMMu?=
 =?us-ascii?Q?NRnwA+Y+KoSELfc77ddYsSKYsJXPt/zC9gnBOwUJbDIu8DGOMfr0tdkEBCxe?=
 =?us-ascii?Q?2HVl8zYJWPHJkdGKRB/OGV1JZacoXHGRehiX/18Q8hspsyBZlSyvy6jZReYe?=
 =?us-ascii?Q?fes9WtZi2P46QmDeM1RhP38zPVpMhO+uOqyRs6q7vD5cFj2Pg75BB3x4AH48?=
 =?us-ascii?Q?ct/V/Dxgxko5MDmTdb0zKv9Wy8mvMlCsGTfld2tkw5DvE3+igHlpOs7KNzJx?=
 =?us-ascii?Q?VOONtuPDvLAnNYT832xPeStUzMzw5pik+AImQwrGTyAHbD3zZagPg54tCHsw?=
 =?us-ascii?Q?mUDyWFAee1vJ8EkfUYCqdjt6ketbMU27/DDdNBZXk7l4Cr0V9/sIXJ25gwLi?=
 =?us-ascii?Q?+K9Zy7XN7PMYprnorPoJhr37ciVpz2GM2jhnpeHUCwx1idaRfOERCe+yjtLU?=
 =?us-ascii?Q?MQbcGPaDUGH304SbZTw8vcQax4dtfwmf8LyBCYClDE+d/rQfENcjqNTNr9p8?=
 =?us-ascii?Q?5iPIsNM6wn6lxbN+2wRejztfqti29zw80fyUoEOCyjD0JwWZ3jjXCyUsse0D?=
 =?us-ascii?Q?dSGoSF2bW+37a6urlkKj+nBcqGkN8rrV4Afk5Chidsg7EKdI5GP6+t7tB+iG?=
 =?us-ascii?Q?QX97/M7f2J7qvWBnGgHcW+16EKPaX6E94l8yg4ZDjBXF87OoYf2aDsiJll55?=
 =?us-ascii?Q?TRjd3A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7968c212-2cbb-4dc0-ec3f-08db09c8cac7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 11:37:00.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ShtvVFnrHYC6e7otqm27JSpxCs/6WYStroWyRt517WHH4u4bQFhKR8CUkklPJjMbWtb63oRKQtCBHdJVvz2G4UmL8OVNprq6HFlMHEni18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6157
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 01:21:22PM +0200, Leon Romanovsky wrote:
> On Mon, Feb 06, 2023 at 06:42:27PM -0800, Jakub Kicinski wrote:
> > On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
> > > +VF assignment setup
> > > +---------------------------
> > > +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
> > > +different ports.
> > 
> > Please make sure you run make htmldocs when changing docs,
> > this will warn.
> > 
> > > +- Get count of VFs assigned to physical port::
> > > +
> > > +    $ devlink port show pci/0000:82:00.0/0
> > > +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
> > 
> > Physical port has VFs? My knee jerk reaction is that allocating
> > resources via devlink is fine but this seems to lean a bit into
> > forwarding. How do other vendors do it? What's the mapping of VFs
> > to ports?
> 
> I don't understand the meaning of VFs here. If we are talking about PCI
> VFs, other vendors follow PCI spec "9.3.3.3.1 VF Enable" section, which
> talks about having one bit to enable all VFs at once. All these VFs will
> have separate netdevs.

Yes, that is the case here too (before and after).

What we are talking about is the association of VFs to physical ports
(in the case where a NIC has more than one physical port).
