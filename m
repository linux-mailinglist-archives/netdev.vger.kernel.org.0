Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F1E6C4FA7
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjCVPqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjCVPqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:46:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2091.outbound.protection.outlook.com [40.107.93.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335D02311F
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4uGw3/qqBUPkfXKAhYjRCF9ai9GbzqIccomSQzXh3S3ni6Zo5lwks2oYCcB1tuvaAg73vVeqDLlpLwf+1cMKEveF0hr5e+Y63HKNYz2ptGNc6f4vR0YhkcprpA68p49YvviZikQlRLE/ijMQJ27TCriwe8uzPyOaKtomIhgGS1O3DXZWbPQ1g+D7UJlghahKaWHInWVvNO5va1sU8OMfKUnVrMmWTCIfPd18ebraeIQFzMC3kyTXuS0RcE4UKOvvqm7laq+cx3pTb5oMz7F588ll09h6fYYTGGtLrUixcIlknT+3JrjY6YHbOmvhyL7pc20QEIS5NdPKBmbsqfFVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=undMkXmkA2Em4kIrCso8Gj4mTx8cBWgCNbn2lN+Sv5o=;
 b=JlHq433Fdv/qJQ7UFWQAkSjW5YLfBNgfQoEBm2zKzI75sMKNQpgQENPcW48kKVt3LW6PhoHrfEIchsa53xZOGm9HwiB5rVB4WKHhGrbTULwx6+8NJ7REUCOeGOFcfFMMEN9/lYB77S0jCPuDx0X8cRVoyYOdVJ+CgqLmZjDIIargc5vbCawUMFr5ief00bFBMADCr79xSYJmF3fX4ufTLGMZAXxegarNuCrLiieN9AZ5K8tqvM6dGbyMcX3ZHRxLmNn9oQ5RVruB26dMYDcMco3iVtho44ozT+4vNihqwe9H86SIw7YJQl8AnPoDdouZFP+8nvwgwhPelC7uZAnr9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=undMkXmkA2Em4kIrCso8Gj4mTx8cBWgCNbn2lN+Sv5o=;
 b=pOju/LGmzh4TaZTGZSygoP69IHaxJFFZV8x5vadLHrmKZ5Sf3hWXgFUxxBE0+/XcI45jYPO695QYOxDabJ2TWTeKUCLukYD0G99k4p8zVQDScldLd1AApjw6AScpA2Rcmp/FSgMKPmD9yPpypJqcu8NQPGNzbAuLpvHK5+ygW1s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5247.namprd13.prod.outlook.com (2603:10b6:408:15a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 15:46:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 15:46:45 +0000
Date:   Wed, 22 Mar 2023 16:46:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/3] net: dpaa2-mac: use Autoneg bit rather than
 an_enabled
Message-ID: <ZBsi3krgT73j6iNq@corigine.com>
References: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
 <E1peeNo-00DmhJ-2x@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1peeNo-00DmhJ-2x@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR03CA0091.eurprd03.prod.outlook.com
 (2603:10a6:208:69::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5247:EE_
X-MS-Office365-Filtering-Correlation-Id: da5928c4-886e-4848-df6b-08db2aeca41a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhujIPVuo8uMxKARdRBdT1TGNa35jgDyTHgKt+ncm/RKOXquqboQQEIESP3yybLTlVoTd7rFudM4taBBYzk6Zj5tWmpnvbQ95SK0R/Gs49BV9ceMb6sVJXwX29Ne3JP855WlgrqJISuWOuFqaijTAfAyacXDWFVpxRuLA+NB6SF5eIVfQChR9rXKENaJPfAKqfDqX/1KjXy1UFtgU5C+7F2mTny7Akw0FClep6Ll3KRrNCnrqLqx/kNsJvsqlOeeIrIlJ5373rBYKImG2XvMctyuIlRDscVnWxCcqBG5qkeqDmm5+PSh/N3tTL2MVl07mPMtQbO0E0c3dCdd9Zy275Knl9f2in4W5Ol/qySHH/sIorwPpn7cpFWisshTKEU7FuntrZ16EbWX6kyXDVFYGfzFcZSoUgSvlzicM2bzGePYOEYep0i3/Os9EbOhsfVDv7AUrk87ZzCb5y8rnS0P8Aps7DbmPhCGRKtcGtf8jHwZg8K18pETF+NautmC0lt+5Jei35I3DlbyHm+54g4c57SgGt7N3MhmxQ115h5jx1nWwcjaJACb7y/18zzzm6mTTHqWFRGZckHyNQGTZUD23vrv/bv0Wi4h3SUp8wI2RHqXSyhwoVaOizQCRTqk6YLP9mWUU8TEaBrEnG4/rMTANA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(136003)(376002)(346002)(39840400004)(451199018)(66556008)(6512007)(2616005)(6506007)(186003)(6486002)(4326008)(8676002)(316002)(6666004)(66476007)(478600001)(54906003)(66946007)(4744005)(44832011)(8936002)(5660300002)(7416002)(2906002)(41300700001)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PaFsFNwuy0b65uxK7qjvO50agtfNMzMLjS5fzwXBko1uCUIS/OcPjwuh7HxR?=
 =?us-ascii?Q?4/TzRQoR0+YnYC+HWVk//FkeX1Ud4emfR5PpD5zVUu7IYAW88A3dLPbyJ/K7?=
 =?us-ascii?Q?XlZo6pUBP2GDyi6hg1GUEkeEJUlx6n9+pz9X/rQPdlpMcMyIkeLzgeQER71M?=
 =?us-ascii?Q?3vBC4BTImZRoNeriBDbC9EjUC+jkPOA9DF3ih2ldJcYGgqLdTIsQCvb8bDCm?=
 =?us-ascii?Q?bhgrY0VheF3nIQVd9WYNQJXrloqYxElgUaAtDi6EKEG8oSYANyOixzpuUZSg?=
 =?us-ascii?Q?WfKhTd3YsDPq++eOXCxjx1zCjH6Sj72ad4STj/n4mTdkVCiGe90zRF+6XVBT?=
 =?us-ascii?Q?XSFdag9HKpE09dhM35AIWhkp7h03RcqGoy7uheqljxZCwntXtyhJFde5H7j1?=
 =?us-ascii?Q?BfFUXo4w88qYsqFbvgjVoCBmGsqiIlL23D83HRagICVtZSFWE4ulPTUBiW68?=
 =?us-ascii?Q?9CRr4fVvm2LByPG3ndkJKn+MaQeSb4ZIjizyUZ/SFypCERJi8Giw6qWCWcMw?=
 =?us-ascii?Q?Is9pB997kxMZZAngeueWPpyIEvuP36rpMJOj10cNeFOVQ6uAOIAm03WiH+fB?=
 =?us-ascii?Q?TUr2fELUPw9k8czA7AFp6qh55LV4Jroz5v5ZJlvDBepahiibiST1LsPMBueV?=
 =?us-ascii?Q?SvaXfbNIT/OclucebBX3d3l1whXD4g2xDM9C8AX63kvDOjSRsRF84MwrCUN9?=
 =?us-ascii?Q?SEYOH4rK6SNBUQuca2QFM0+bv3C+IoFopLM6rY6H1MgY0/hx5ref1V/ihOKy?=
 =?us-ascii?Q?WBLNuKYO2Iobi4P9FV6A9mS5yI4/UZxSDZ6UshnPSpRPfM+oiNL7f6T+m5kP?=
 =?us-ascii?Q?aIyM3tC34gEDdj1HWhIulct46ZohVqd3Dx3nW/7UfDkKebl683d4XmNa2vi/?=
 =?us-ascii?Q?VdWnfM4fw1PboGoKQdOgo9PwbEX4eIEqYMxPFQAdLoEj0P4rqJGDv3+OGsHC?=
 =?us-ascii?Q?f93LyB2bcG0Z6DVeV8nLR8i5twD+3bdP0CnjhirQkobIutS81XvznlcMecTB?=
 =?us-ascii?Q?ArEll48rRRzA2yUFhvkDWhCMJWeUnHEOe1vRHAtzIpEYEnkBUH/VZ0zjUmNo?=
 =?us-ascii?Q?8M+Aw+jTk63XHo9kD5vntJSupzAqwO5QwN+EckS1ST/+Y2k3eslRJfYu0sjL?=
 =?us-ascii?Q?2IXr8QYmvf9rNE/UnfeSXbRO6OeqpDdbOCTfkVAuVm2vkAXkWMLi4OKx8/o+?=
 =?us-ascii?Q?0kjuw9aWe7vlCFvA0JVqUSWHYU5Nc3Ac83uM8Z1ZoBgrqweOOhx94G01o2Nl?=
 =?us-ascii?Q?xx9hhADR/7BAZW+K00bHYIptp1rFesX7VcIBrVMmQ/KVyCgk4rYVwhEBTdo5?=
 =?us-ascii?Q?+fBrZ7Ppx6liYPB1BLACtPnzEmIOy/cFd5yullXPAfS3W0iSWGqSgyGMtTfD?=
 =?us-ascii?Q?MwEzu4xcKYY5kQU5cVNWioDSeYfcfNcX4WQowfb+5FpJuQYfC8nSjlMPO5VC?=
 =?us-ascii?Q?cMLk5ZAeHNc0QvdtN78w9BAQXHWnMCUqpx26HONsYqHspke/3alCX14eEdO/?=
 =?us-ascii?Q?Yd6w0LmPIjrbuib+nYm83PTpcdHQ7Jpp198bAAxJFD/B5WggERznpOxh4q4x?=
 =?us-ascii?Q?IkoZtVQh27A3HK8iXMmqdS8GS1IhJbPA/0akYyaoRbpIO7YO+lOVVI3sL4cD?=
 =?us-ascii?Q?RcPXOE5sXpcpwj/9whHC8eJfcF/3a5NhLfOKvulQ31rFdpg3dgA3zz3BWmbk?=
 =?us-ascii?Q?n8LX6g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da5928c4-886e-4848-df6b-08db2aeca41a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 15:46:45.8961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/odGeGLMy+hytyUR34jo2e/g6Akn7tUlLdn26/Onw6YOi6dKEadk1iOkmn/5pKWOd12LHO4dhYYlOkH6f9ZYCAEFE7IHjfXwaiOUFaiUcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5247
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 03:58:44PM +0000, Russell King (Oracle) wrote:
> The Autoneg bit in the advertising bitmap and state->an_enabled are
> always identical. Thus, we will be removing state->an_enabled.
> 
> Use the Autoneg bit in the advertising bitmap to indicate whether
> autonegotiation should be used, rather than using the an_enabled
> member which will be going away. This means we use the same condition
> as phylink_mii_c22_pcs_config().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

