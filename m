Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DF34FBFE3
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347596AbiDKPLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347644AbiDKPLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:11:34 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30099.outbound.protection.outlook.com [40.107.3.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400A41FA76
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:09:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnydYLykIsyG6Uz0D1+DBer8r7RFfKH0k2pjarDdIKhT/utCLR6BMNmK0/Vkp85AuceSkmCtzV/JLShFWJShuFljsDD3Z6UjUgWRWho8CRRkPmz7xaTajOBZsEsG9TAkqYCKMsiSbxLOUtNCidnwXnku8TnxwYzBhnMLkzxTgOWi79pPs+bv+jLbIWAAxz0LeuivEacFcd/rmQmK8gIR96v0xR+dtwGdVPNiKuVpXGrGcA2jVf2JqzhtixmrQmEknLGLR7IQlhD+FsaZ11xzMogV5WJ/od5fMtrOXKDwEPg3LNHexgjF4r1ekGn6w4gMm3qAVxR4k8T128Sf85PL7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVnYf1jET61WnZ8p/npZ8lqAi6zv77TuyRIpkH+qs+4=;
 b=P3hH3KLoa1F+E7pnM0J7prBgPDpK/hmjdbnIVCznuGwlGIAqyxqQKgG90lNH7oeyT95AJwI6W3UxCxGf93gQ5L/kI16rYbWSCcfEtnH5CJcgl4rLc4uwuColQcB67xM4ymOBCiPPMfuu6JaJ+vewDZPOrQxBH4rz+G0DTy1272M/kF1fnsR6vwM7TZXT6sYrw2a52WzLXq301bAx8FgBhfv1g6WzNzACPPHWE8XkACgI9TXWmBfU+HH0gwO6v8XMMfh60elqnoj5bC2+JDbDshAAo9uSQSuQHrXE5gTaEAxsSD9SBbgBRbtQXXacPr0/czEQHdesOWQKDKeyFAN25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVnYf1jET61WnZ8p/npZ8lqAi6zv77TuyRIpkH+qs+4=;
 b=hBX7HaOL3Jm+A1xU5k7n5pvOBjgIy/k6lBp3Kq8dVqk88PerL1hN1kL75+aVs5wf8y70FUtb0/hxfwd/6yUWma3+mOJLYDDvDdnjwwwaTjAm+N+vg8i3EWyqJ7TLeP9kqFswChDDvqm/vZFNY+H80CmtR0HKntRg2UnlthbFt6Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by DB9P190MB1843.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:37e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 15:09:17 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::4d52:78cd:92cf:a98]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::4d52:78cd:92cf:a98%2]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 15:09:17 +0000
Date:   Mon, 11 Apr 2022 18:09:13 +0300
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net-next 5/5] net: marvell: prestera: Use dscp_t in
 struct prestera_kern_fib_cache
Message-ID: <YlREmXmw3W3JSP01@yorlov.ow.s>
References: <cover.1649445279.git.gnault@redhat.com>
 <d33d876900a6cc75a30ef0d5a3f00dc22f51673d.1649445279.git.gnault@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33d876900a6cc75a30ef0d5a3f00dc22f51673d.1649445279.git.gnault@redhat.com>
X-ClientProxiedBy: AS9PR0301CA0032.eurprd03.prod.outlook.com
 (2603:10a6:20b:469::30) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca89f4e7-9aae-4cbf-2556-08da1bcd3ef9
X-MS-TrafficTypeDiagnostic: DB9P190MB1843:EE_
X-Microsoft-Antispam-PRVS: <DB9P190MB1843D8B4CA50638F4A575C5A93EA9@DB9P190MB1843.EURP190.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/imwbBoxWImb7IUMeQRiSpzVbz4AMgJ8uU5RXBWUIro7Qi4VXj/aR6X9gzMJUBGpFzDk3KfBcO9c8IIW6By+o8BOcdMFhY+SdYKfskNU+tOknmzyPtdkGhlcWAhEdzKOpLojSr0E5lodmmqfO2P0CmRrDdVPtna1c2gODifHTwhENq3GSEg+8lreYI8H5EZ1Kxy5vU9jVf2opD3lckSBb9iSTHND9dlGYSL2PChBADNsI/9CEnd+Z9yzzwCT87dmZjPb5+ceqLqn+yVnrj1LghyQ7P0bcnyKN7tqLGbFhM+rZ663BDpRs4BGxL+WiyO0FT9TESoqzVv9HcUkHKuuBM89K2y+nahmTgYNbVW2sloUmOq+gC5PlqT3uOo4F7Efy9YFO6ggDTDXIFCmP8F8seKmIVAYkLqs1ZsuWvHfqiwplZd4u24YQtdpjVp2xe24bRG7OkWN7qM18yXbz89wAdeWfB/zulNSJp+Bc7X2pYNkSZWisTczUimjIDbhqVa2y9rBXoDItlI37+RgJQtW0+qWCLfaRlqMbFBHDMSQJ4v+QviUePda6SE4MXhRIe92OcM/AApyd9aOzdC+C8C/LWtY3vwqpIh5zIIduBRYpDdrfAebuwcNZJbKc/a5gzqL18Pn/G8hhCHzJ+EoWUKBRmOCQERbpW5q/dl7DkIsBH8pTJKDXP8fvgZOHw+o5ONSEmGzNnPmcn28in+QWIuIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(366004)(39830400003)(346002)(376002)(396003)(136003)(66556008)(66476007)(8676002)(66946007)(4326008)(8936002)(86362001)(54906003)(110136005)(316002)(38100700002)(38350700002)(6666004)(6506007)(6512007)(52116002)(66574015)(83380400001)(9686003)(6486002)(508600001)(44832011)(4744005)(2906002)(26005)(186003)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TIVyuz1ditbJon9ILkp58G2/o18wcVB2+32zcpblvKUyXK+TQNBJ0S+qShYE?=
 =?us-ascii?Q?vs1FgPaB1R5vitSdvHn8EFfm8g4SnBKR6rJPQSonQ55LC27lN1iCLWKNRCC5?=
 =?us-ascii?Q?XrVZMxEJ4z25K/fMZ0tgF5FhhdQdj5ZhH71+hu+NCQcC5IIAIu9h6LG3ulT0?=
 =?us-ascii?Q?kbv4gi5jT1pifojlXULnxo63Y6oITNAd+xt0YOvN+TLqqt10MDLC4tSeWQc1?=
 =?us-ascii?Q?PPdAqJJlHNz3L9eJA2XdNj+VCeq9nYlewVpXiFVrOsCHFbSwiR9Cdr661zP+?=
 =?us-ascii?Q?Cv49l+EbgcE1KwaLBhcbhl7/Tb4LGcm6K/lSK51D0jvH8YfVVEAbWmk5mEjO?=
 =?us-ascii?Q?gvKq8lgQzSj/rJx390jp0sJBHXkc1UPELrCkruQThjyW401ixDLJbNW3TlZJ?=
 =?us-ascii?Q?28EL8K7whz/JPlSHiTcwSHTcQ/26eof5rmZPfygaMeXlyBo9NR8Y+KYdNQNH?=
 =?us-ascii?Q?Y14RbD6oKhSqXRwQfY8O+49wn+eWDU3/APNeLy4r0b66/smBiRE148f7t6Jj?=
 =?us-ascii?Q?pnTqtzzV3+su/uMqaUhCldD61s3a2dcPe1lDeMJq4nNa4+koOYTPCPf2RCsZ?=
 =?us-ascii?Q?Lsn+NEJINdnwo0taCZlbClKajzRldDVpxJuiuWoWeNeo1NTOKtnis6RbquC5?=
 =?us-ascii?Q?kYM2H4mloeztbGmwK3aXt2s2SEAd+hzMpe8kKluJ/FClBMkEA5SIbqkGX2Yu?=
 =?us-ascii?Q?GPWztgxr8areolHajPQXZvXGKOQoxCy369pOBZYJCy+8U0rfKv+LnLXatdQi?=
 =?us-ascii?Q?duxKraRyO1KAonKHpZ3V4M2m1MzMrgMwnVwk+IhgxXaG3MLbSPC7j8eIlNG7?=
 =?us-ascii?Q?Yb03Q1asCraZa9oGVSxC6Qe85wGg0thF8O3uiGJkDawI+up4/f77EdPPQXSg?=
 =?us-ascii?Q?Wl1ehsR8832pTSiGEPyYtjqOgMDbPbaMTehK6BKVuIiekAWidIQfQGwze5GV?=
 =?us-ascii?Q?8JxmLR4F1+B6sgkQyjMJPsV5B06w84YBojAwubAUVyoEF5r+9T+ZEskm0N0M?=
 =?us-ascii?Q?8GP/fNYufemSdwNkmGVDc+Z26pag/L7GJO6nXXULKsW9k6N5+JUwGbotvynx?=
 =?us-ascii?Q?ZbaSa5LRY6fEXomIzueTHhfJ6QvLeqFsV15CiRFedC5GfSOE1iN5rAr+sd/0?=
 =?us-ascii?Q?g9JlDMEb3alEIfMfTx3OTKBC0N+JEMC/zljrWO/EjKLPZDy4fcey2mGtFhc4?=
 =?us-ascii?Q?DLeEAJ6dbietjjy3Ij/cRuqq+zz+7pWPujpvg7eLciNUeeqv0U1QbE/ClW8Y?=
 =?us-ascii?Q?bkY/1xUNmjAOkB7A+37U92glzO6kig3RQr6UVyShuWajxabstTcgM7oylmEc?=
 =?us-ascii?Q?HPiY7xzBPiM97xg5vw4k2VVw56RyntLlcS9XkeLZqVKZJ4eD61zmuwyeYiQ9?=
 =?us-ascii?Q?5tylG5cXxp3X+YU7LcNtdRAKVDIqFpoM2dz310l6Khqy8qPtIbFTJFbwFeQD?=
 =?us-ascii?Q?iuCuBr0sIQel72sFyo+U+egOtnnwzbvjkfz+o2VPKaSzLbJZs3nNZ224T2zs?=
 =?us-ascii?Q?hEyobtE3497/p/pNn/OVF4U7sI+j1Uv7jKw9CnIMJFHBayIEu+8IlidspRoF?=
 =?us-ascii?Q?7h4KVEkAHkeaIypE/tKx5Ozn1h7SJbNfuUy06AFfLMrwnSfTaDq2EQj2Tu1m?=
 =?us-ascii?Q?zzL4981o18WaENjHNcO+O7v39t18ezajG21VZnfD8Nb3hl6E9vXyIxj+qsy7?=
 =?us-ascii?Q?tfcQQH9XSJBZVzF5NeQ8T+gcDudYF4vVrmbJ4eRfQm6n8ZCdL86c8MBkVzU+?=
 =?us-ascii?Q?Vt6ZwmluBFxW1fnMIcES5ftAeEXyUDw=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ca89f4e7-9aae-4cbf-2556-08da1bcd3ef9
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 15:09:16.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3khe23ZZHouNu53m0bEEYYSH0yt0FtY9PrK8Qnhwl20NUbeKuoRUggyaTGye4akZi7Y27BgM0i2Xmmfs1Dj9VbZxgwiHjVxg/uTYqczl28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1843
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 10:08:50PM +0200, Guillaume Nault wrote:
> Use the new dscp_t type to replace the kern_tos field of struct
> prestera_kern_fib_cache. This ensures ECN bits are ignored and makes it
> compatible with the dscp fields of struct fib_entry_notifier_info and
> struct fib_rt_info.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_router.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Reviewed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

