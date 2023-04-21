Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82726EA6C7
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjDUJTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjDUJTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:19:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2109.outbound.protection.outlook.com [40.107.102.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCF96181
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:18:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGvX6M3MiQ1u99i5T53sIUcIbz8/7+u5FAwfRknXrnFSNlOFLSVvNccbqnaPOWcOlD7oSvq4F7o+4U+D/CUKoO65e98/1oSOtyNa5hcYZFA3R/fwwDpwC/5n9r/rOFIbdHqdg7RUCC83E/cIxRgTaW8/muygw9VEdEyXd6Q7rq6fJnk7IitoNq7FBoccD3truoUGpQUmH0cD8jKn9Ulo33hfluRZngoVkCpnl4mKzRAsxdB0UMEvueQQbeFieefO/9lamR6YwQ0uftq/nbZ9f6D8EwI9zqXtieb5EtwQY7EUhVMrNHHXt/3MfIAd0tb4uQS4hE+tp6kh0bWgzZSWEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unuITHDu/VsYLHvpp2LRPAFvltyC1J6k7RC3e5CqlxE=;
 b=mI2FaCpud1OsjJOt/jXhQO0pF+NALjbZfT2tIWANbX1EgyR3io2yCNdJioC2kgLKsKO4R9/rTL8yJfsEVdv1zomXbh1dBbkt+8YXkVlG08uV3V0VblGC/wuPBFyQ7hfacsAArTECbC+GgwKU9Q11xcpUjHmZXkMDw3O6TfB/OWUG5F+fr87gcizNkaRNbyozE5/c1INrbGTAhXTjv0KuSWGnX9w/UxT3UhCzORe5TGOyAcoSgw9Z2cDGapWVOsz0qM1nZkC0NX0eXyThF4M/5o5enaU+iIcQ4XAhURtORPxv68WJHx4eg0AazlcR3htBJBbaAugbFujpmDrsb73c2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unuITHDu/VsYLHvpp2LRPAFvltyC1J6k7RC3e5CqlxE=;
 b=i1hR0qUPmPwM3nqxwYNHwIqk/TNJP+BTLovBeH3H8+LMZ2877F5i2mHdMKLDocFCs1wbdrytH8TdcHFq5E8Fp0OF9mNTAAM8aWKlkxZmmPvN1R6szeKo/cavhhTo/wmcp+Abm8vdx3Boxp4EmCljfAMUSkhFT0oYKSfjYt5Q464=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5594.namprd13.prod.outlook.com (2603:10b6:510:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 09:18:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 09:18:55 +0000
Date:   Fri, 21 Apr 2023 11:18:50 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2 v3 1/2] iplink: use the same token NETNSNAME
 everywhere
Message-ID: <ZEJU+gf5+vpo4cdi@corigine.com>
References: <20230421074720.31004-1-nicolas.dichtel@6wind.com>
 <20230421074720.31004-2-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421074720.31004-2-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: AM9P250CA0007.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d97d1b-522f-496f-c05c-08db42496e35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2gRyiaXpEVj5H5GJZA0Wej5rItuwESxEKq8ChPjASGXaGUFPc015nhdsTFwlD839QTBW2emhlOSw0PQ3n0Mu3y+hYKLjhLDkokq9lJEz3b9npA+OVrOb+QQy6kMWMZK2ImOPcxuK58e7ZS5WiimTMtMGQabTXyJ45jSwNldTdRetxBaBFBBfknU+GIO15jW43LA5u3cUFOqbAhSW1BMz4T8SvB+drCF2ASOUzP97mbiTM9q8ZPgFZLsvjcij/ASFTS5pSaXdDMaR7JytSkD7bh6I6V6pjeaLw7T7g5Uo7WhbqipzYK4I4TutCuJ8xGo6powv9ZbIVYXb7wWkYlho0iMNO5TnR3k4pw973FXhSW1/L2vA4nyL0GbEDblJzKbJmH50y/tTZiVObT7k+jVcmU7YThPY85FeM0/rvmCQn7IY2E+sjzanu+VTrXYZUcefDcTE4rMS3EVefl6TUKJ8c1Ri70bkOiNVyXrIMFFQcyepweV0vzf/lpPAuK61Wv4peT9MJfkYjYdpGYizf3EQ2CUQJ7dellIs90TTLkU8ztaxF0pBhmqifYzhxq3yrij0r+LUWX/4Vhdgal/ZIEdF0tmFyR3S1R/bjJ4EwA/Z2Gw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39840400004)(346002)(136003)(451199021)(316002)(2616005)(6506007)(6512007)(186003)(6666004)(478600001)(6916009)(66946007)(66476007)(66556008)(8676002)(41300700001)(38100700002)(6486002)(4326008)(44832011)(5660300002)(2906002)(8936002)(558084003)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fug8NXptX0qW74YlvE1CLf+1Lce2JuLvNv2OG/uym6Vk5wGzpqWr0+Lh5VCF?=
 =?us-ascii?Q?fAHsmjsDEdabxO6cYVi11pmoH+7CZJ5TEHIwjSD1nY/74iOxDZbDTxglzqUx?=
 =?us-ascii?Q?ACoPqHTWkeu2cCLJHVrWUSDRViSXxx3Nnq+EJalM2NrSeSWihuMLAh8+y03i?=
 =?us-ascii?Q?qWZcxiy6gK9TbqvA0dQ0wfjKWde96mspfd9DkfmuN/0ESu/QTD8ncCcGesNb?=
 =?us-ascii?Q?eOjV7GwUuyLg1DKxE9h+wnY7fh+T/jxWhqz2LZIyYZh6DJJfKnG00GG1y89X?=
 =?us-ascii?Q?jN7DSjIJYYW+FBZA+cXfC/12erv6FVQRb28tA5I7HMELxrgGvrQ7/JDboYBf?=
 =?us-ascii?Q?5cxz6a4X0CDtXc8lSbZQgq0+kFRgti71dGqLIljAWKB2hkHbQI6rmcXCxA41?=
 =?us-ascii?Q?g3KyyqqMin1KulcAN4mFOLV9OfpgqBEmP8OEEhuBLjbpsw4x1a3wGOS1U69x?=
 =?us-ascii?Q?lL098d5wzekYdtLXyCSf8/Q56PkgU86udxbF8579TMIX7IzvYBBf4gEQ3Iek?=
 =?us-ascii?Q?GtY6Lcn1MImYfFqZ7EjAN2lx+dc1IZ//LTyAwU4UpmOVyjuAMn2M9+uRa9sw?=
 =?us-ascii?Q?I/yhYlmEMEMQ2n9+xKgUd/MhXPUGzujF/Uzthm2jBtnqlLc6SxAs8Nf/cRjx?=
 =?us-ascii?Q?XNMt9Ef+ACduojmPjNXJPtumuL2t/+DemNTqElFbuY1K8vazl+mjCug4agEU?=
 =?us-ascii?Q?MGCYnJKouKxAQ4P0EYUsHEYt5rjBzsQIsshuYLQ1s9LvdC+EoUgusIoe96iZ?=
 =?us-ascii?Q?CFNz/vHVInv2Jhv3KjsD9pRWuJo5u+PJxDOeI0uNqsMw9HDIZBUBzF+GWDBk?=
 =?us-ascii?Q?R8mcQvOdGVfMmSj0bq/DfDJGWX8BCXpTuTZBgl92ST2zY+xoakSJPPiniYMO?=
 =?us-ascii?Q?epWpDtGuSAjDXktOT+RRAx2v4kxqUkVh+OJ/lPKzHcLvgxSdOooiwb3b51Xr?=
 =?us-ascii?Q?WCOC8b9WxNGNQWmfmQmo0KSlDDGxb4pnGYfOUJQNWhV99//EA8D9DuAKi7vO?=
 =?us-ascii?Q?4KSMJX7MHdQRAfk30+Q803sRSy8yVGy+djKYRbz+qR19Pbrqt7w3maH4oacn?=
 =?us-ascii?Q?8ZT8urLRjI5Fu+71NVahdmbNATuKuNwGIopnrKNZwDouDfOZTr544kpF6NDn?=
 =?us-ascii?Q?kC5mR8UZgjIQCBgYjdvUiYO7VPKIgurBrN68YATgSF8Ng2dj8TOJrO2cipBO?=
 =?us-ascii?Q?6XKEN1x/5hN65tKag4x0MzTwkBzNlVDh600oLJ9gRgLVGalHN9+0fvp/SqrN?=
 =?us-ascii?Q?ZmGnWA6QiWbXHeBkrQLT4MiyN0RqnhfUhKBnnjtor2PykIL5MMTxbUzbFF86?=
 =?us-ascii?Q?ulllIJVFiNEnZZqRgGYCQp9ExzrKthlTZFExRaASLeuCZznUnXo0ar6NjsPD?=
 =?us-ascii?Q?3E3uUWHrFU4uN1g6jy6LcCWlWfzCeAt5W1npnEnMeCiGNqqNUvwAdR7iWswW?=
 =?us-ascii?Q?Atw80fZ33vb48MlwUWBwdsN4NdDdHPen4Cb5j460KE+gkfNGah0PnjDMDQTe?=
 =?us-ascii?Q?xMBxjPY8UaNM8eCgTRkwBguH+LG0+gBu/7dFUTd1iX/8Us9RKN8NMEEX6kZF?=
 =?us-ascii?Q?5cc4lanQcMB8xw5snwt4V6Q8RcrZsoTP5ehGTROWLrxiZwvpTOPHj9JEvgRb?=
 =?us-ascii?Q?OFJYxz/sxN4ggVu7X/PdToOhev4PX2/h9zN6euWsi3U5OnMmi+yrtUbRTFFm?=
 =?us-ascii?Q?JpKgQg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d97d1b-522f-496f-c05c-08db42496e35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:18:55.3688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zRbFZrRhrTUxkR5ZfLAwRu9k34hUnTuOX3Zlytr0I8tSKTrAy5is+rbV5eNBw8oP7U37h2U9rqr+92XtSN+J3jazMjcp9d9wfxJ3WJUZfGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5594
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 09:47:19AM +0200, Nicolas Dichtel wrote:
> Use NETNSNAME everywhere to ensure consistency between man pages and help
> of the 'ip' command.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

