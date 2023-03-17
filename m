Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688126BECF3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbjCQPa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjCQPao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:30:44 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2075.outbound.protection.outlook.com [40.107.22.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116C7960B8;
        Fri, 17 Mar 2023 08:30:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJmB149RyyH6cfy9hiD7Fk1CTJsBg7e7Ls2UUyosndwnMavAyT0n7uuulTsDLzY+RwqsEhXr++PTKfYOU2GzDlq6jWomQtQrzm5bezjI6q4iJeIyN0eFIaI9hi1ayr/Azvel+Wh7uKPsujolZxR9NlPIPlWDnu+WsxM/qXAeIkBfrs1E2p3HjW+tDaYqIKokNHONG4SG/uHyvc8ilLjZCidTLKaS8B4lpf7S0pMrHbuS3pRhB83ceXWO4kwb+C/Cv48nJ0MA+aw+uK/8+xRdanfcvQwHJKdkVIoRv9pM87v+xmUC8XINGJ3CFd6WEANj71ZZW/A+b1dUFYtS8mR45w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKxBAIAtye6Sn8CZn4sdJ8W8l1FblWaOMbOsicMBQAU=;
 b=lEEdynwsmWUJ9zcK1cWQmeUtrhV4KKet70sOkmIBq8xNYcnoUtJFZ7xZJSRLXhVWC+k7gDPgQLzmcnl0rO2qBhhEbslUlO5sM2m+eXUx9IeDkAXLiEi2Aq4e3taihcqRNDvcvO2m+w+P4dy9ALMH6aHlmBeYJDv5og4nFJGCGLkIyRTa1+AstU+0W7bkY7G4fyyBdJl8mheyTQVo4SfrSgZF3LjS1JP2grnYpFGbJFFg7NH6qu/98ai71GAHEmo67eOi0VED5jkRv3vfC2Nd3I8GWybulU8CIV28GlgaB7/TQEmvt2er9NLONBRUFOidBwGidNusjkqARMEtpmL0eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKxBAIAtye6Sn8CZn4sdJ8W8l1FblWaOMbOsicMBQAU=;
 b=Gra9Hj+5RdBCVmNLvST+MCDyLBqyweQrMucgPScp08MBmgdoibcmCJgU96ZBLiNGSnHwQcnjGsf+qJY+xKNum0ddcBig4mYiu9S9Ji/Bo54FLOtrMQ4nFSzJh2KpjfO8akf8xfIYbOFSkV9YbqNsrZQRoq6N5zO+8ocENsSprVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by AS8PR04MB8450.eurprd04.prod.outlook.com (2603:10a6:20b:346::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 15:30:21 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6178.031; Fri, 17 Mar 2023
 15:30:21 +0000
Date:   Fri, 17 Mar 2023 17:30:17 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: dsa: mv88e6xxx: don't dispose of
 Global2 IRQ mappings from mdiobus code
Message-ID: <20230317153017.o3c74r6w2uoh73xi@skbuf>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-2-klaus.kudielka@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315163846.3114-2-klaus.kudielka@gmail.com>
X-ClientProxiedBy: VI1PR0401CA0023.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::33) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|AS8PR04MB8450:EE_
X-MS-Office365-Filtering-Correlation-Id: bc1fd28a-db86-4883-f34d-08db26fc856a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WzHywLG2CGtTonaDAxKgJdcRbzo1Mgj1xTTWHLrKrhmml9mrpQPa9hSwu3zRkzJYuqJxj5QhXfHPR7lhSyeP9yLTpKl6v0O8C0dj3RJYDZDLm2sQWkQue+5zaJA/1PZ7ZZ886sbc1ZADW+5plaMIWhI5LJiuQpkXPGzFKF5mVbjybKnSpYvCurVE5II7AF+4rQipUFY2vCyJf+MghjRNrfBmqZf3aMwTHNzlnFqUQfWwLK2/J5giERjFpH7qmRyzkaFNGmE7VHPr+VzJx0V5A6qc/EFKv47iWj5u+Glp6QMhGo+vVhClftdOMY/Du6V74CZe9z/XYTME6MpbUf7hH8qsy25gYEyHOC++zhH+RAUSnqGvKgpFkOsn9qK1Tmdqwr0stjdZbXsInW6yuUWkx7Vdqcyxhimnq4LA+PxMfXUwh1uPIuR3P+25PfHaYIGDiDdXDAfFlgFG5WRcEsNFLNmLg5zIiYeWAmN1HCBpdomYlcliRhmN9InvShRA4BeXizzdteLoBymnwaiQuXMyjh7yUErDvQeqEIk/rmlpvc08BsRxRlRBk/IfBV2rK/Ein8ywi1eJI7xf+Zn2xHCvPlsMCcTblFyi+w0OUKR5cLAXHzkRc8WrBL2kF/H2il6XrX1vKw6gupBS5on/+FA20g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199018)(186003)(9686003)(316002)(54906003)(38100700002)(478600001)(5660300002)(44832011)(4744005)(66556008)(8676002)(6916009)(41300700001)(26005)(7416002)(66946007)(4326008)(2906002)(8936002)(6506007)(6512007)(1076003)(6666004)(66476007)(6486002)(33716001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f1njQo28lMJAJEAkdK4KiQH9gGAQpOwwh8XYlhWw0WZYYIV1tHeLWACCJF4h?=
 =?us-ascii?Q?PbM9fE/zK8myBHv5BR1lOW7MC70mE8F3hxoQL1Hm8lLpkiwQIzg0MsMygWOF?=
 =?us-ascii?Q?LhPaSd28eVRE6qan8fojMzTZy+Inp5F0L5FKqwNedniZ8fbn6aXclMWGfxkY?=
 =?us-ascii?Q?ViWCP8t07TgzHv4UQKS9i921nMVPz94dTeF0OsN77Nh2/PfNLobLY5YRRcMz?=
 =?us-ascii?Q?oUF/QJOQKxdAYQfE/xPw5q2tK5RQsFUA2C1+9Q0xwIozDoMCFQzwg9mhu8aa?=
 =?us-ascii?Q?x4F4kG82pImr4Wt5Wc8os6Xh0ByACDS9QdntX8QZnSnQLoW4roWypEtsVe2W?=
 =?us-ascii?Q?hKhg490/L25IyVe1YwVOKaNpYESCPgdib16vV9rSyS1UioRN9v3eIiiC1AH1?=
 =?us-ascii?Q?6zHqjQYJjxGnPhwhLriuL3giak4n++g/HaI7J7hiACXSsT2Y4gUzd2Jt2v+0?=
 =?us-ascii?Q?D/YMvDKU3FMSiCEFv5Sx/Acw6XDLsnyyG+lcsFW9EkBoiYFAbdlAiBWvVQPa?=
 =?us-ascii?Q?h5PX0M0E+gwM3acIbO5ILABDJAtNS15ef7lPMjFEoNDkT5ESWFUbpLM/Ey2z?=
 =?us-ascii?Q?MiwO3RCKHf3MzALpOh9FXDT0yYgUxYRvTCaWmTuw7csRHvjJNktx2qvQwIrU?=
 =?us-ascii?Q?HhfhyhXSlqM4DLPFjZG2y54gHhdH7IJ8qvr0QxZGJu099j0Md9dqjIqKee00?=
 =?us-ascii?Q?wrWGQA6eSszhCYX5HUhmkqO3LMKk/AFl1NZV8ZaZMoCXWZ4BP0hQLwbylisA?=
 =?us-ascii?Q?FeoP4BG7UqaqnIcr42ZA5h3FzPoX8TLK2toxXKokb1QBchmYxyT3vzs1eMek?=
 =?us-ascii?Q?VzHwRG8LmCZgAiGVEUiJvLr4BlXvGrpbMS1pGqSKuGVFdyvtGYua3XqErMks?=
 =?us-ascii?Q?qVS7s59vGUIEAkXH8chwgTM7bhijZ3fSyLkzEHwRlOIq7wpnNSNWy5nbgHYH?=
 =?us-ascii?Q?+KLawDRMfTIJ8T8nwP0MUCtlvG/X1o5bwOCeba4KBH3b5MPgFWb+kqXL6CIh?=
 =?us-ascii?Q?VphKQ8uHNOMpsswpZbz0anaQd3wFvg+27YGSc0IjN+YtrIZLd/jlVwsmLr7g?=
 =?us-ascii?Q?lHm5o9brMLvqNIohBpJ2U6lHIgwckokICtz+OF8wfKdDi2xsmySt6tVWXBRX?=
 =?us-ascii?Q?hEhqTs2XR2bhWX6MnEU+RAm49hSUZUn7DFnfxvbnEmHgvkkUUTpza87FVy7Y?=
 =?us-ascii?Q?HvRFv0+Qj4vPpmKDvSW2GhWPAgGTS0Tm+CNJ8Hg/RUFITv+R+wzwT8DWWt8c?=
 =?us-ascii?Q?yC3piBf+cQ6k++nK16HZgwRIrn2qD8M2RHEWJTvGxwGyAgAo2iB1JEP0vfB+?=
 =?us-ascii?Q?Cxs+0TMMKk4qDMIKRr4NqHaqFi9zHjfhgDCkQRo8k8ShXdavvK2xzWL3I4uW?=
 =?us-ascii?Q?ypnE0UFsLebLQXQOjwhSXWggB2yYExPlsrI+wiv7LShf83IcNgA5QeFrrX2P?=
 =?us-ascii?Q?D+29g7JE2y0R3sqxLJik/RWPQD1UhWP3UvxV9yRp7IJ6oL1i9p9jdr5uCwNT?=
 =?us-ascii?Q?olURXo8EYVVgf6RPkxwe7+NZC2oY0MjaipTkBVcJEAZ1YA7kXFiC0LQhvfX7?=
 =?us-ascii?Q?syVCqx0DYZ0ywfq/PEmWL4aja2Whm9IUfHzv4//XixvylZWlCdOuLdUoY3Fn?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1fd28a-db86-4883-f34d-08db26fc856a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 15:30:21.7081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldvVgO4ui5i7ZDj4hIW0Le9vdtYm9Afpby/notjRKQGebxPLcnP0zAovyQiJkK6kwL524Bcqqf+CvBTK9AuaMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8450
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 05:38:43PM +0100, Klaus Kudielka wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Simply put, this change prepares the driver to handle the movement of
> mv88e6xxx_mdios_register() to mv88e6xxx_setup() for cross-chip DSA trees.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

No point in adding my Reviewed-by tag, since I wrote this patch...
