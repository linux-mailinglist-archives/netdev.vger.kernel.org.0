Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96426E61EF
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjDRM2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjDRM2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:28:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2109.outbound.protection.outlook.com [40.107.220.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F489B756;
        Tue, 18 Apr 2023 05:28:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H84wiwjdN/6nl7km4WNR4X73M5n4W/OTAOcM/Ur8HJxaqp6gugYlQSxCy5aj2VKcYMTQKHr+Wv6Nf4gBVvoNt6y7Ocaz4UuCESDPxIyZFFtr/ol9S8K+HJApTdRl2Zl2o/Rx4yIRb1KrZAeLjCKls8hxb2K711MFCb4RjwYjWKXBROYLYCdom8WXIK15gaWjnA74Pd8jy3zOIFJjE5NYnxpJGfKWG0SW1Ux8nnDXVoez47vsZH1dLgWnaK9+hqeP+uund+yggYgi7ptLDT8AF4EmDEtUCxlK86P187uYYU/Vh6xuQWnY6rsqle8l7b6A0zJxchtfjpRTk5bWzHFl0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZgtnV55JphA6SQYJV7JajVkqxHQ6M/94kHmUPIMBIc=;
 b=n7zdDjnxv9RRneF0zNfPJbr7X0mmxsvrPQU7PIu+lEpXn2+Wv2fOJbivsqZ9dko9dW1+ari7Iz6TdQxL9dBW2QasZVR4osG9+Tq613szJvzzwNSnmlGaujxMnMli7q/2r9049HfgTQxrDarz0Jm4A5Gn1LJRqNTglFGujK+KWSIkiNuJHS0WtsE1p5nVfh0H+xfcES37H8rO8fTpyCe4vGIsu8n7jYTMfFfiG8WK3rZTgnxE/Zks+H38ofb6JmOCgTktBpcVcrJ6WESnMfmot+N/D+DB449M1WVBEmBP/2LWbGqF4RFRAWxsr5REjVdYux2xUoYT360awpM9FMgDlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZgtnV55JphA6SQYJV7JajVkqxHQ6M/94kHmUPIMBIc=;
 b=TSEbAyDOee7C3vG5Mp0ReNOaaMGQYoya0Xod2jJlPk8Mr8exQT1iL0v4BG4S/Qkvp1q7aJqjGuvx7nvvS89VUcInSq4+6vGyjJgKvkA7/xYpET7bjr5zv8XfJeikpX7H86BeiOS1kkJjeUS3J7aVpuZayYCerAB34R0uEmF550g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5790.namprd13.prod.outlook.com (2603:10b6:806:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 12:27:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 12:27:29 +0000
Date:   Tue, 18 Apr 2023 14:27:20 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <error27@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] crypto: api - Add crypto_tfm_get
Message-ID: <ZD6MqMyjjdSgUDVq@corigine.com>
References: <ZDefxOq6Ax0JeTRH@gondor.apana.org.au>
 <E1pmqNT-00FNV9-CK@formenos.hmeau.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pmqNT-00FNV9-CK@formenos.hmeau.com>
X-ClientProxiedBy: AS4P189CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 13b306d4-f310-4907-ee5b-08db40084674
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yMPyE3exuHSkWWIBlan4PnsaWJYnY6We0FJuPuG3RroBce86a0mJHOAcZH2tnPzyQ9AmiTL4s3rtmB8RjjJ4tAUPLGpQirBTS9hCxMTsqh1rE74bmiUAs0dVc5IHc2tfR+voGCf+Nn+Q/GqZWnF5LMoPfUkvFWD7WWw8vcirslIX5zTWQRpNq8Sqwg7uIbrpW6WGIBCnkAFEEuBsY89lIVnxnVfIogRhOSwKJhoq8r2qn+3vqEiQ4XjUuora5QJ/i++9uQbhtbpaP30tNMK9lIGT7vY4sfCe/H2TqV0JDM33FHDzwvNg3X8CPUeKV0pdcTYZPA17SknpWtCnLi5ip/dgVXpyD6WoYOfFUoz1E3WC0GbaMRo9qASReQDfsLkTGedquWQ5QO2PZM//hMEBvx5PfuMVNZw8gDbL4qk53qIRVWCiT7uD/KTcqB5xvqvOH8FJJI8qRBZNBcUWJT/ABoIzaRmrSMTB1A+q0OenMiFeJRS7I46BwJIoCq9+NoDMwogXsTa74INGgn/TsYRmpad9pxoqCOkUoViiPdghAycTAp3Te0tTEApg1aqlDcK37o6osN4JH1c6eSxajnOODjaYztf4eAQT+P6vET7Mbf0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39840400004)(376002)(451199021)(7416002)(5660300002)(44832011)(86362001)(2616005)(6512007)(186003)(6506007)(38100700002)(8676002)(8936002)(478600001)(54906003)(6486002)(6666004)(316002)(41300700001)(36756003)(66476007)(66556008)(4326008)(6916009)(66946007)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nsY7M6ItKplNTmJkwytNepn6v1oKhGsZI4tF5bmKCUOBL81pY+UWgkswAUYt?=
 =?us-ascii?Q?By5NTMz6i9pE0kKpqlvUu5wT8N5sUy087HYlyzD/YCZZfyN97rhDGBv3r8/g?=
 =?us-ascii?Q?zw9muE5QOX6nfffkSeGJCv3fIZGt8ZOlLuLPFCjLrc56Ya6d52hVrsOHn5RJ?=
 =?us-ascii?Q?2GOeaO6cDNZKMBx3f/qyTNw84Z1Rtc+oe3HkmO/KUxFtsrNl0kN44/iIRwMH?=
 =?us-ascii?Q?XrKEG5mHJVpfD87ilpCF47UK2rYheQTe/hzxlRGact15Nrr2LITmyHbPJHnZ?=
 =?us-ascii?Q?LAXcSCVnzcg4lYmRoJ4P7yPPdYveiqvj7+oPOHckg1Zr2W8gkANlCseyYgaH?=
 =?us-ascii?Q?VxDMLCyH4sLLzWi7fII9Hi4yYFKcXZ+WX/LKgE+r5ZrketPaCScEhvla+v8z?=
 =?us-ascii?Q?4QS0wAmBMl9t8RgxtvdS9F6IJf+DDkO9PeSlNmuRJ/nEs57Ql60RBODT09wc?=
 =?us-ascii?Q?DKfhm2JHpC7MX9RYZpJdRH2Vsw5kTXY5BipprVU4K1K7oD+Q9+NzRljqSp8C?=
 =?us-ascii?Q?tcDNbddnRnHuZ0C/uE79b34Xzc2TyaoFsTJsMPdrYR0FZvwfqoTDy5YfxCPk?=
 =?us-ascii?Q?Eld0XK2O2CQTJd3H7Nszld9xo+/E8xyHxzds7k77AXRGQXB+T5a0yj524lpS?=
 =?us-ascii?Q?9EVCZeRBCbURzQMHh7pkWdLryNSjw3al74gHgs1XGW5nR5MWxPYuphP6zdMV?=
 =?us-ascii?Q?gCeWTZjFuJS2tp3+mPxVgfAHPzRvfERyzwJyntubWIpZa6mnUJYKwriN9l+A?=
 =?us-ascii?Q?nZA7q58xIKFl+nu7FnzFOQTDwa8Pv0VRGU08HBSD2WH2YbWq+YmdxkWBf45N?=
 =?us-ascii?Q?3TduUKiEKn28Eyg7xZAHzQUge3gHmjhlwgGnUZ2k/+kHGrZfDWpaUZDgyz6T?=
 =?us-ascii?Q?qFweGdbtbx4j9OkdgOZov/PUU6NyY3lU0qz7Ft57xyaTSml0HNsBNIkSYPjg?=
 =?us-ascii?Q?PJZUTApLBniNIjveIiUwHBn9vzn9nba9Eq1J5d53pCV4RaFjlCDeW9lwNPH8?=
 =?us-ascii?Q?9H52XUYiSGKDtDsNeHEMwykKsa0SyleSqHvpbc3LAjehf6yJg00TfNp6yEZC?=
 =?us-ascii?Q?KQe0zlHDdKwNPTcnxwxPS3TK7qXWtqarrTFdJivKnm1xqaIlK+qvVYWiXJ5a?=
 =?us-ascii?Q?kaGqM+dBq+P7QDeGqZiQQuUonWfEDkphaeAHgHzYrS7Vg46Q58iB3atH47Nf?=
 =?us-ascii?Q?cBP9+z1+yvZ4g0YA6YKXVD2HvPEse4EdANOZ8izC999pph+WUor5+EZqI7GO?=
 =?us-ascii?Q?e/u9azJhWx6SyO3hcZv5Hi4aBozzp+zxVFDB+EqUP++SGfmhuqr2y4tOrtr4?=
 =?us-ascii?Q?26EmtDqM33tVHkc1lFBbARgPKvnTymgY8PMp/+ijg7eCe9lVMGCQWkuZ9kLB?=
 =?us-ascii?Q?wWYKMxCgdsuDo2My3cNLWURuPXehWPMJFMB+Z6za9nucUTdGRTIuqhFF/xfm?=
 =?us-ascii?Q?2APD/e32Zmg6OIUwnOX4QwZ+uKOuYJmGqkNP69mJw18Cj0FHZkmHEI1LkqcV?=
 =?us-ascii?Q?jOoq1n9tAkx+4bv96AoZ7sv/erd85P2NmAyWp5Am6jRDVdgzi8PCSd8741Z1?=
 =?us-ascii?Q?n6Rv6IhLF7KeB3Z4daQUQ9i6BPP8spUv7mZw80AlrOCO2fwp562sbXdBrMhC?=
 =?us-ascii?Q?VJCZ9RD5rtw0GJkG5Fj/wXX1kBoHqN0QcnU/l728LTJY0ysJmpeRipGo1//9?=
 =?us-ascii?Q?R5iz1A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b306d4-f310-4907-ee5b-08db40084674
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 12:27:29.0998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJ7KQkaI+AxguHO5QPqS5yuQR0IdB4qt2hicid+FM1hJrCkmTUaVV8oETHlwQaWOJXBRJWggwDqzOdYr1NwQfy4rgpJYxVB9mRxnCk9PdHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5790
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 02:24:15PM +0800, Herbert Xu wrote:
> Add a crypto_tfm_get interface to allow tfm objects to be shared.
> They can still be freed in the usual way.
> 
> This should only be done with tfm objects with no keys.  You must
> also not modify the tfm flags in any way once it becomes shared.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

