Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF576C6CEE
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCWQIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCWQIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:08:22 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FF71EFEB;
        Thu, 23 Mar 2023 09:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WUYFbygYjoKbOWzeE2u+AhGFCbhr7mFyZC8dMvz42FdbjYgLtXTYOt7wNT/E3a2Cbre32qyTragKqcmtF6s63nYSVC9vyiszK6VTsk9t90z4TlKBfSUN+s1DNQbTEfotbqxyv7ZQa0I1u9js4MM4NWAuPzDHUn1UFxSEgy+iZQtTu0y++JizcyFaAmVEIgo2q3rOD3Ch42q9ImlgbbxZpu4zqxsvpM2HCYxO1w58YlI98GU8I7B9tjxbb4ARf1wQrR5h/JYl1LCbzKyBPHtD6QOK4uLBaQoQal0/5NOs0+muqYBJwdXKCBNnMuNVwJs3/bthBD0+n8iGHzQOE7ZJ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oiz8pa9BKYrnl6JhgkDaM9I+9V11dkEeYxfJH/19Fzs=;
 b=AucwVO+uPTeanfR92LIBJ6hFbVoiUSJ4bDvXZ4LJC6hLMwcgaXTx/x6vNBlXzJc6crBGMkUmQeAFYrR4eyJcf8KV0axV5QqWbQcJur0/dltRvwfE2wubcoTFnUyEusJ2xQHZq7QZywvlCyN+Znhb25bJn1QLU6NauXVnKRSJByrc4UVN7yqg+Q1QdPXX0aULf+dBugz/RN3UgXJYVmmkNdXD3547RDmM5hf2175PqS//yiuKUKNG3yr4y98pzaObxxIVnBzdl0N/hRPF4m6oexYJRd+896xhg+zDttd8SMVOSnGcAO4TV2qLS6dFdJpZiTPBYW8E4jTNafdRAzyewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oiz8pa9BKYrnl6JhgkDaM9I+9V11dkEeYxfJH/19Fzs=;
 b=ANHS+Rqfnt0wqh44rtePxBbIyfip+5FN2I4mgu+qr2LsCNBFBkM+xE0+FYiy5EiFUJTSUOVIYNHchNShSfb31K+8aN7zpNWfQeSWRTid7vRv7vVrTguq9jOUE3Mh0C2iGUm7/O+1p9wdx+7hYlHdiTbEdxeIY9N4ZziXctT/qf8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4795.namprd13.prod.outlook.com (2603:10b6:510:92::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:08:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:08:16 +0000
Date:   Thu, 23 Mar 2023 17:08:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/9] net: vlan: don't adjust MAC header in
 __vlan_insert_inner_tag() unless set
Message-ID: <ZBx5ac4cfv/tmJ2C@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-2-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR02CA0089.eurprd02.prod.outlook.com
 (2603:10a6:208:154::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4795:EE_
X-MS-Office365-Filtering-Correlation-Id: ccbc005c-7eb7-4be9-b5c9-08db2bb8cfd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /rIjYbq4ER9bVida3rabPcXYmlmCoNnw0acqIg1O1kJBiKETinQWTAE7JRsXHeVnAQPLSOIHxxo9t7QGI9Acisn4QZCKYMUn417tnJrHQdDX9tKO8yx0Q8opS3OZe9nS9A65LtTuO/Sk4emkBW0IfHDNnwlAcKUTGXWqoxEGWRgMqIM40ICWFMN/9NGNFTRIlJv4N1RYxdMyB2pMDAm7Z7dCxBWIoGh0BXwqJKJzXdw56+8RRh7mPkJnTYffTM5NRawc5nifgrwJtCyE/VhXDJWgXr1zgfc2l4uHLSCHIJL/AVurk9ZW4u4u44k2Q+e0BLOiUtEG8xMaEzadBZk2liwkzh6wHo/YG4mlzSZr17gHig9A+ucdZCaYWd4wjO1Sy2+Hcx3Y9N3B1KVrHGghR/GMGZJ32jsmTts2aVFpfFdr2odJlqHLl1w84o28rDOPqOpYopLCBjSn4eTv9vl1zjipL0fNOuBoqUTKvZKX051dMvPgBz5EytpAI79a1LESyroKovT5iS0hjLDBh8af7DxY5HqTXOvwJ9K8v0DVv5lT9uPmSj0m5niTZMBvztgGWf6Gjhw0Qh+GHXRZrHLK8s5KB4KxcD8fqowehpr5YsHOSpya64z7gOwCw70BrWEJqdd+iJcrBiSSbKoiJ6n8Lg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(366004)(396003)(39840400004)(376002)(451199018)(83380400001)(478600001)(2616005)(186003)(6486002)(6666004)(66476007)(6916009)(4326008)(66556008)(8676002)(316002)(54906003)(66946007)(6506007)(6512007)(41300700001)(8936002)(5660300002)(2906002)(44832011)(4744005)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KYPfURrQeLNzY10bqz1bcKmDRqdyCXBC/psrQQGhIF0xYyyzw6dk/6xXY1KP?=
 =?us-ascii?Q?Ha2cTdqobKLsqDmOujSPXzoRX1yGeCN7qylTND4pg3oRCFPdJ3xaUuo6r9x8?=
 =?us-ascii?Q?GRwqtvhapZqnOZjKqpbfoT1f16+76xnJphoXfPAf5SIy49AYWco+zpJmK8XK?=
 =?us-ascii?Q?0fuE7GI4h9SKz669E6h8+XSUln7Hsk9mAyj+W4xNygFUrYPul8G4th/UA6xi?=
 =?us-ascii?Q?bl1LRtojP5INh28ut+vYjRTc4Tz6KcX64OMPcsE3Vh2tMCerY7ZrevFAoF/4?=
 =?us-ascii?Q?wrA8dwcW9vKIfmsz1ClGO2xSHv6kJNlHGHkQYFDiK+qi1taQBIpiWXj8xxf+?=
 =?us-ascii?Q?f3I56FevTPW491RVRAVGDqUjCZI2wRHE1aMLcOQsUER98tGESIO4dD/Cu0gN?=
 =?us-ascii?Q?d+y1DBYuE9vZ3DTxF9PzQHd4weUxSGyDlkjm70AH8aTaKw0Yr9CPTOUgLsPk?=
 =?us-ascii?Q?50U3XztLhfqhAnAFYFgcmkPhZ+/SCRYkvPsAdpHsqUFqrwFDZEDNAWJnwgF8?=
 =?us-ascii?Q?PmZX/HKWEB+kC6+o/COa8GMgJfcdUrMqK9lkZcckAI0fJoWqsEc/z+lip+g1?=
 =?us-ascii?Q?TanLLv6ej7pqOkmXQi6aw8M8g9Va/fvsbTkHfTXyBTt9b10gD/zQtoojzFUO?=
 =?us-ascii?Q?OrmGpTotbKigMSJQ+Y8LTqn/AUluNIHR4O6cY2OyLfV6lCcSrY3xmVaUN81t?=
 =?us-ascii?Q?Zh8rTykYnpBAVdhTYCsVQxJCNBpynil3iiRuIpSgC/9iLqs9RfidIM1FetZC?=
 =?us-ascii?Q?Hs/7m7J23waznw4T0dFQrUENTIEPEfuXzZOi6hCBy8/pJd/UwoI8sw2nKQwO?=
 =?us-ascii?Q?6NYWsRwqto8pyhFe6TOy1SPcjYgfjKij58CRLXj7KqLl3/XbRrSAWBDzALpW?=
 =?us-ascii?Q?hWv4aO4FX8CeOI8urGc9b+noMFeuAUf+YowRL+MBPC3I8lKPhPiygRii1W9v?=
 =?us-ascii?Q?m5cU2YeVuPa9CIpa5ETkUmZbin4ovDE5viixsygZh3894tCCOTNLs08LUmb0?=
 =?us-ascii?Q?ExJSyornkFn3WIGgwizU5n9nMUByURfrQPKIbvxdK9pzqKgIi4khzbmmKHeV?=
 =?us-ascii?Q?eVecWhknMeqxQOZByBiF7ev1xWUVt8vt6kILevm3o/mtoq+lbehuvXJD9EPw?=
 =?us-ascii?Q?r+Vg1oMpptV1oXA5u2yNRf0IrA8Sph6OTAVQPp9VgwfbNEUGxyL/+ZUp9A+l?=
 =?us-ascii?Q?TFumcnla8F99hMq1JSqOIooFpA6+zjrUt06WB2N2I1kJ+nHLGBLyexGbnadC?=
 =?us-ascii?Q?lddt/lNkt/MfBJrbDSxYU7fn+JYhJ3+6ogC2ApF++wSI5bzkIY68+uyl4HvO?=
 =?us-ascii?Q?/ltL47+2VUOFe/WziTfptP+Xm29Z3ZPfpW1Czb5PBtyEHUtZhBEYs34j272T?=
 =?us-ascii?Q?RNNcys7R7A7qHhVpLEavfYWYd9tCuvUkgRd4xztc+BITeeVx4R1pqzDIuugg?=
 =?us-ascii?Q?cKDPIHRVrLV0jDNgwYDT2tRV5AGxVf/taNVah/GZ4y32WuapQ++DTAcH7VTQ?=
 =?us-ascii?Q?CT+u0E+AxAAsj83CWatnZpB9ZU8vJlrlaFVG6fq6hIwuT8Lor8Kqvt7B6e0n?=
 =?us-ascii?Q?TaLQU1YnKE4azx4b+RQtTaXPef41aEm0VqrKMWdEtJgWXE7HBDZrr6nqvOLZ?=
 =?us-ascii?Q?jz+6wZyWd7IDGmO5eEBT/gOcpVGdqP5WUWX7CV5eOsg+WMT+/cwUih+DYZRx?=
 =?us-ascii?Q?jnZq+Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbc005c-7eb7-4be9-b5c9-08db2bb8cfd9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:08:16.6528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: erQuoGw4TC5Wmu3Go2h+mW6Y8SPlyXGxKQwt8OdiwCTFYPLxluP9HapGZC7AHcxYeMK1JcZesjInC/wJSSBT0xPlrv26PZv+zFg/rNDP0LY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4795
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:15AM +0200, Vladimir Oltean wrote:
> This is a preparatory change for the deletion of skb_reset_mac_header(skb)
> from __dev_queue_xmit(). After that deletion, skb_mac_header(skb) will
> no longer be set in TX paths, from which __vlan_insert_inner_tag() can
> still be called (perhaps indirectly).
> 
> If we don't make this change, then an unset MAC header (equal to ~0U)
> will become set after the adjustment with VLAN_HLEN.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

