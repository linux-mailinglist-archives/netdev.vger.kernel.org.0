Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057486C8711
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 21:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjCXUvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 16:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbjCXUvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 16:51:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1E619C5D
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 13:51:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bttDQ89P2/so2nPvHPZBk5HbVHVQkN9mioqb/bigm+2AIK8s8UjZIGPZ4JHYqUIxXxNYumdNsH9EIQ0L1wBIXvzA+dWsHWQr3wIWtKIdHj08ZzTpdP3h+9xsegYdK0BfaAwY2qbGlPP9pMZa1LFZENFsvcdlBuRIcvZ75ztp2Tf25eRCpJ4h673tEoTZsSz7NU8vDBmZ9Mx4e1tvvtAq3qGN8J2pRXldDLvfyLIjoUhLZwerCGmfgKAlj60qJsbr7/X6cBYQyKoLBEmTgG0ILUme+qoDH6NBmFs/L2MZomLtQHRWLJJVXPXjt3VZa99j/tUguDTgMIuzVcpkSK7FMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j2ddUBl3kx2sm6c0VOBV5ZCi+HbUlubqNKWwXj2MrFs=;
 b=nC/m1BwZ84wKKyDdHbynNsG/FkG1lxmiI98TdD9gtSGAXdv61ROh3YeTyxe1l1fBY6cV/ZYfTmx4D7t3nrLyGwxoubvorAr3K3NjwMtRozVoPCd9nCV4fZ6LUR7vCh+D0AKcjKUkVVY39T/3EL33CNxM5CbZs53QG+xpRIOAJw8urBXrR9uF/a1yk8A2RcdrB9xjAAXwpa1GOb5iSuemsONJRVL+X1qC/hBkt8W+KBFfPl1FE3z+vE0p6fALc09gRYf+u9tUE+CdzO90LO2ekqKx5YKRHmnt9dglwSD6FIQzK1HpEuBKPY+XOBV9UfVZkB2PbSeN2K1qYPXAwWZDqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2ddUBl3kx2sm6c0VOBV5ZCi+HbUlubqNKWwXj2MrFs=;
 b=XVtEm/L/QHxfvmqGJozDfEiT4hAJHWHudMWU5ADzFWgxUmocpbtz5UlCSmfT0b6ldMGH+M/O8XGUN3eXvkJP/Kk735G2k8S7jVUvSBpf8LanmOE2/KfhyQRqK5kV5G2eizJo8qrnf1SBJE7ZgzYw2NXsiCJ8lH+chXNbOQHltg4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6253.namprd13.prod.outlook.com (2603:10b6:806:2ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.39; Fri, 24 Mar
 2023 20:51:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.040; Fri, 24 Mar 2023
 20:51:12 +0000
Date:   Fri, 24 Mar 2023 21:51:05 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/3] net: sfp: constify sfp-bus internal fwnode
 uses
Message-ID: <ZB4NORTp76TfuslH@corigine.com>
References: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
 <E1pfdeG-00EQ6Q-0f@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pfdeG-00EQ6Q-0f@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4P251CA0018.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cdb5f26-ec5d-4130-d950-08db2ca980a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1kaJvU9JGZuMRoiYApET8Nl1tPJ1X964RC7R8p2NzMYyehJlIb7YT0XfQkyj61QlnukYTMSs0Up9yBzobqDV6noZDqk0n2V/1rph3Svuf/H0Afxr8TfrTx8FgHXpMF6h39TTjP/u61SSKymMFxfO00Urd1pBZ9xZnwnVF/F4GVJuqTdxVgHU4SbPZFTYYSg3Jg/YmiV8JshTL5HxHCcXcUdXhOyAMv23M5Jw7KK/ovb27RDb6qU+Z6/l5ZA3kSFGdM4aVCdbKcNfggxnroEKRI+CYL86hT1GqFGWpPFwGMw3qXxsVV+GXFOAT7PDajVRqkstoPj5p7wfjNJZgBYaTUuQX9JEHwtc32TLKmaW3drMlKwB24/KTWO8ZS3bsi4fMQ5tu5YoqXjoRRVaJnAHJ/3/OsS3+Y/irrJjCZqBB+GRbL7VMrmWLH0LR+fJ0W/FmBjH80pRmNzwHQ3Hnn8KbHlIJD6pnNg5HndCihnMVBlrUkshCSpHDKBlbEzlgwRGFAQtZhzT1knRe2RkRhtufqhEydTi84Jpfh1IglqHdJ6vAgJyRHNqrnGDuzBvU2JgB5YRm+EcV6yiSmGnd3m4MsVqLXmgR0yV6xUrx0NKdk0apleS4JqBIwRot+LJUyUJhcl+vf8HjZoWaFiAXpnqFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(366004)(136003)(396003)(346002)(451199021)(478600001)(66946007)(6486002)(558084003)(6666004)(4326008)(8676002)(44832011)(66476007)(54906003)(316002)(86362001)(36756003)(66556008)(2906002)(2616005)(38100700002)(6512007)(6506007)(186003)(5660300002)(41300700001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sHS4uJ9VN6SYiL046iDl38AebTfjAdcNccvIcrgReAMS6hS+bwKolGlMyRNx?=
 =?us-ascii?Q?i4HolKkom4wBVkp2wV7WmsrsXPpfpOc1XutiTDUTnbXB7SZes/gcZJsllzE/?=
 =?us-ascii?Q?OmzgFTBYAtbf/5Ik0MzQ8sb20anCkO9EK2qQhQojGHbXRBONRQaTXh17nEv/?=
 =?us-ascii?Q?AhDLR80yRNSETTHuv6RHKtbW+0Is07InUrUNcpNTeumvy7RSWRey3E0NGixG?=
 =?us-ascii?Q?SGYtZU5h0bhZFTsty5U+Fw0kH0aobGnGSyv3ErrZd4/ruM/Nv/TJby6K4qSz?=
 =?us-ascii?Q?xI3LLpbNlVrk9Q49nXb7PoceuvM9r3NFpCpYoG3KXdZAuUhZJiChfkUlgp6F?=
 =?us-ascii?Q?gCA8iCJ0+aiPrHEZKNm+5ePsl59x6vkeWaIdLvPBAl7YeI6FxARju3/vJ36Q?=
 =?us-ascii?Q?GRNXj5kGgl4MO5Lt00rhF6da1wQ6JabRS376TVdycS/ZRLUlmO3ixKT9ux0l?=
 =?us-ascii?Q?D4ngQYB9bC/ZrRspftdwFpp+RQ3Dsc/Nq8U0n/9GIut5PZtZdoJM6+C1mQMF?=
 =?us-ascii?Q?uIeUvEHskpqPjRKZ6vNHaoShK3Pv96WuBx5xJeA3c43QvH+mnclPjioqXZFp?=
 =?us-ascii?Q?dbJesXhhTZVzCVKSgNXVjUMre05KMs8EMdSKGujiQz37gWFVzkkzQx3OIr7O?=
 =?us-ascii?Q?fMiX+SQohdkj2HeGLHLsDMxhvjEKqYJbUtJo+EUiTcdYM2F0cypDo8NngN5K?=
 =?us-ascii?Q?t0bdJMOaM73DDLjwS89+XQgKuFVSl6tkxt5JVRvtCtDRZV6p6gFq6EJPD4W1?=
 =?us-ascii?Q?SoZHSxmIhc8QN9/fQmMUtJR/i+mOkcv+m0Nb+JGKp7/Dx23u0JXn/gvNfs4Y?=
 =?us-ascii?Q?xPvAFSJYfQXDSwTA29Ada1b3y2zPCEBd5hj9nM1YEPk75fAJLoHCTAN5VH8q?=
 =?us-ascii?Q?41H8QFa8NCXL4uqqoP2ClibUybXIA9iTFewsZIDh7tNo40TK5ew+fsFcEJ7K?=
 =?us-ascii?Q?+jDXErfWZWRfrYHVfrH8SJs4Hyl9dHojAFkU5g/wQCecNwdG8HS2tPBuA0XT?=
 =?us-ascii?Q?jAEGrrcZ9CG2QOozT6mh7ZoIDm2SiRJmkiZAXyahUjufY4WL2y35xTJyxq32?=
 =?us-ascii?Q?RxbLHMB4BsSUsH16VoN5pN6noI3up7Oa9LrwHeQOYlGGqaFTNxTsHHJ5TyUq?=
 =?us-ascii?Q?h3XaE+ltd4rYAUc47FBIQfrlKo3jfHlaUrOnXdg+gDcZI8syvUHDnWNeMJZY?=
 =?us-ascii?Q?H9UL/MqsrZpw1sqC/+WT8mQh/x/MXMUV3+AAbr4XZ/CUqMLWGaBTf8AGbAni?=
 =?us-ascii?Q?fbt2596ZY+T/dxnzvbY0qzfVvnsXazd02RDzdQmKzcRNO/oqxzEl7INxDTms?=
 =?us-ascii?Q?kAraJ1xNMeWt0pJqHqoTjTsb06yi0q1NKNofTTeujBT6J+TiKRBCDg6nElfY?=
 =?us-ascii?Q?NbhYegbOeDZfSelFykNSkiQFNzkpO7CaPK2TA8jiV4MK+ddFpJQ2z016AG/V?=
 =?us-ascii?Q?rLrWEDbxL2fqUqwAsWP3ayDYKv/EgYORioZTNd3zH4+jsbmuj8Y0mTjlosNM?=
 =?us-ascii?Q?fAareSrew60c844/T/TtlP0fGM23b5FjRhDcq3LXVAuFtEwXydd8ROk5erls?=
 =?us-ascii?Q?g7sFOejRkZuurtqaHWUSTAHTxI8PQYGz7nPYSB23oQFkuxPT3RSAgvl3dbDF?=
 =?us-ascii?Q?k9SmF8gFt0RsT1cFrOq131U1ceQ8qNFu0NXmQ6STd9ijivqaEDIQ/9/5fW26?=
 =?us-ascii?Q?AHEfLw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cdb5f26-ec5d-4130-d950-08db2ca980a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 20:51:12.4210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SgVcg4o8KGuz0QhTWNHSLOX8T0gopS5yJHNi2JMAxpX2Mo+4k2UeYcoa7Li35t0na71w9nxsst00txTluE0kAApUZvwwgiRcXDRgfLXYGW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6253
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 09:23:48AM +0000, Russell King (Oracle) wrote:
> Constify sfp-bus internal fwnode uses, since we do not modify the
> fwnode structures.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

