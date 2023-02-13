Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4AE693DAB
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 05:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBME6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 23:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBME6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 23:58:05 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942559EE3;
        Sun, 12 Feb 2023 20:57:29 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D4tufW018628;
        Sun, 12 Feb 2023 20:56:02 -0800
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3np98ukb1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 20:56:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCdlGXj9FK5VZIwlLPl0XLInqc6Mk0x3vkDadkp7/bB8+f9GMOdqFm2cY9OAb3WIqwUrV740eaKTL6ZHXXmEosPFFD7wcWbltBQWiitX19NOr/VZflevUDo0R1aaZ1CnrtFb4jvyh70HNCwB94T0MZZw7xw4nYSSfcPMkHZwoYeh8/M0hjfmSyx5FiEBlqR7WESgid/OXzBNGnTXGqYMYq86eEtHZ8NRb1v9RRRRChssFdQZD6DsMjSOnOhXamKRE2Ca8A23UggUT/nHSo07w0IHJ6fTrwLwj79Qvnppv2Z3LEVlHfOplFDpjsgYtG9KhrATTgMRck31MRBsSUbozA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSSWrCpjL8absfbXuxtvXPJMoLcyXpvezek7Yksxiuw=;
 b=VNgNk1m1JFpg9rwma1Y7tOQxqPcRBhxGybNRVGHtoAGRU8H6swy4xPqNn/7zJqbCJ6ySa2zJdcy20UhuKkVf38dyAGcm41UKtWF5bSD3egmj/5bq3QJtuA+b/BC3GmyEAcNz1MrIEkK6c15d6FwQ+rVIMRSHILF4Jn4tPWGQ/Hq3KVjR+15aaNa/oRRCI+nFHscwDXCWXlHybjweyw33DvTKB9QK5+NwbQt8wjyc06hG5qVrQklBgx2GnIWUjCDCluTEOTIvEutOJ+fIa3WaRX7N9Dv6sSa2nbxzCoHl+9jFva82uqHQCLOtVlfAcQh6XIPaicvJQMuEeTfDtCrt8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSSWrCpjL8absfbXuxtvXPJMoLcyXpvezek7Yksxiuw=;
 b=eCUOPAWkG2FJCscvcWLou3aN2//iSr1olz+TUT/y2XhcOHRbdssmeI45ULMiZxf6Eqywe/eLh3P9pJZOXkiIkQ0uP9O0nRY2CNuppPvrsL36YQZuxLEt86M/PxliNqrBlkAIkoRvcC4U2hJO0ckDWI/rI0yVO8c3SJlFBKb1SzY=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by BN9PR18MB4251.namprd18.prod.outlook.com (2603:10b6:408:11c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 04:55:59 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::79e4:b76:b1f0:3378]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::79e4:b76:b1f0:3378%5]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 04:55:59 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     Deepak R Varma <drv@mailo.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: RE: [EXT] [PATCH] octeontx2-pf: Remove repeating variable in test
Thread-Topic: [EXT] [PATCH] octeontx2-pf: Remove repeating variable in test
Thread-Index: AQHZPf2qf7v3ktzAH0q8m08yQt4iKq7MUObQ
Date:   Mon, 13 Feb 2023 04:55:59 +0000
Message-ID: <CO1PR18MB4666B621D0C32A4BF32D4654A1DD9@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <Y+djy4R7Z/e5noRX@ubun2204.myguest.virtualbox.org>
In-Reply-To: <Y+djy4R7Z/e5noRX@ubun2204.myguest.virtualbox.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2JoYXR0YVxh?=
 =?us-ascii?Q?cHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJh?=
 =?us-ascii?Q?MjllMzViXG1zZ3NcbXNnLWIyZDIyYmE5LWFiNWEtMTFlZC05YzU1LWJjZjE3?=
 =?us-ascii?Q?MTIxOGI3YVxhbWUtdGVzdFxiMmQyMmJhYS1hYjVhLTExZWQtOWM1NS1iY2Yx?=
 =?us-ascii?Q?NzEyMThiN2Fib2R5LnR4dCIgc3o9IjIyNDkiIHQ9IjEzMzIwNzM3NzU2ODYz?=
 =?us-ascii?Q?NDA5NiIgaD0iL0NUUW05T045S1ZSZEpnTXFmcDgyRGtUWk9ZPSIgaWQ9IiIg?=
 =?us-ascii?Q?Ymw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSFlJQUFE?=
 =?us-ascii?Q?d2xIQjFaei9aQWJXd3djVXBDaGdsdGJEQnhTa0tHQ1VOQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUhBQUFBQUdDQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQVFBQkFBQUExRkgzYUFBQUFBQUFBQUFBQUFBQUFKNEFBQUJoQUdRQVpB?=
 =?us-ascii?Q?QnlBR1VBY3dCekFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY0FC?=
 =?us-ascii?Q?bEFISUFjd0J2QUc0QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFB?=
 =?us-ascii?Q?QUFBQ2VBQUFBWXdCMUFITUFkQUJ2QUcwQVh3QndBR2dBYndCdUFHVUFiZ0Ix?=
 =?us-ascii?Q?QUcwQVlnQmxBSElBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVB?=
 =?us-ascii?Q?Y3dCMEFHOEFiUUJmQUhNQWN3QnVBRjhBWkFCaEFITUFhQUJmQUhZQU1BQXlB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdN?=
 =?us-ascii?Q?QWRRQnpBSFFBYndCdEFGOEFjd0J6QUc0QVh3QnJBR1VBZVFCM0FHOEFjZ0Jr?=
 =?us-ascii?Q?QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBB?=
 =?us-ascii?Q?WHdCekFITUFiZ0JmQUc0QWJ3QmtBR1VBYkFCcEFHMEFhUUIwQUdVQWNnQmZB?=
 =?us-ascii?Q?SFlBTUFBeUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFB?=
 =?us-ascii?Q?QUFJQUFBQUFBSjRBQUFCakFIVUFjd0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFj?=
 =?us-ascii?Q?d0J3QUdFQVl3QmxBRjhBZGdBd0FESUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFB?=
 =?us-ascii?Q?R1FBYkFCd0FGOEFjd0JyQUhrQWNBQmxBRjhBWXdCb0FHRUFkQUJmQUcwQVpR?=
 =?us-ascii?Q?QnpBSE1BWVFCbkFHVUFYd0IyQURBQU1nQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVpBQnNBSEFBWHdCekFH?=
 =?us-ascii?Q?d0FZUUJqQUdzQVh3QmpBR2dBWVFCMEFGOEFiUUJsQUhNQWN3QmhBR2NBWlFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJrQUd3QWNBQmZB?=
 =?us-ascii?Q?SFFBWlFCaEFHMEFjd0JmQUc4QWJnQmxBR1FBY2dCcEFIWUFaUUJmQUdZQWFR?=
 =?us-ascii?Q?QnNBR1VBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFB?=
 =?us-ascii?Q?QUFBQUFBQUFnQUFBQUFBbmdBQUFHVUFiUUJoQUdrQWJBQmZBR0VBWkFCa0FI?=
 =?us-ascii?Q?SUFaUUJ6QUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFEd0FBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFB?=
 =?us-ascii?Q?Q2VBQUFBYlFCaEFISUFkZ0JsQUd3QWJBQmZBSEFBY2dCdkFHb0FaUUJqQUhR?=
 =?us-ascii?Q?QVh3QmpBRzhBWkFCbEFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQnRBR0VBY2dC?=
 =?us-ascii?Q?MkFHVUFiQUJzQUY4QWRBQmxBSElBYlFCcEFHNEFkUUJ6QUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUEiLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR18MB4666:EE_|BN9PR18MB4251:EE_
x-ms-office365-filtering-correlation-id: 65d2b27a-322f-4bfc-1e75-08db0d7e9970
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VTutl+ImG3w1Whv/8ZZct8roeFiZEB3tajI2AE2qeLNkMEHs2VZ2e0sPh9yXnqBhBWoyIRUKDvrbaf3FT8ZBtipkU4Xo9fdknnUbXh+V8zOQiEfeWX7SPLjtfNGRf+f57BU5msgkS71N9CS7cTeEGJUNaZIegUozLC+bT9xiZti2c5x4nUVV4Xf810BYVY12DVTMSYjeuPfTtOfrkgDBVI5vfE6yHM1v/DRX9didteW4LzOI3TI2DQH/YViuQd7q5SE6wKYEY9NvCsLN22wVkw0YoKfpKMoRR6jJQGK0N0gXE64kUfot7IeHQT8wT1p9pBsooz7D6lhW6ACxaSCL9sum6V2MuxBQbTeZcHKSB3MEHy9YZjmMqiekWpR9qBTX7OLkc2uZLoIEmcH/6HZU1PtCmoIqvaWYu+BCfx6kf9hJWK+d1pSa9TuVpi1dRrDdcM2AcO1LgWsKo+uZKv9Sd8Vd6KIq2lyTeRMeNgWxO7Z6FVyjp504+5Ta9V5TyXbchaQp0AjIOkli3wO/SldqcK/sYGi42wlA8hcosJukCoInxlBw4i3xIm1HXylvEzAkOCybCkbCNL6f7HocQwWeEkbEsGv1deUNuFQ/fmTjseL3JRy8MmK+Tf0mB07I/fib3usbPrfGUnNoQPiUsfCTgKmCbabFowq1ru9GgHjhj3mtemSM+ZIEU0u3T+9S7f4z4NHKb6OKL/S9YvZRmtOG0DMTNh5JcC3iDFZheBTWr0w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199018)(26005)(186003)(9686003)(478600001)(7696005)(66946007)(64756008)(8676002)(66556008)(66476007)(66446008)(4326008)(76116006)(53546011)(71200400001)(6506007)(54906003)(110136005)(83380400001)(316002)(921005)(41300700001)(52536014)(8936002)(5660300002)(2906002)(122000001)(38100700002)(86362001)(38070700005)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1obfIwcdDHHCJgnviocgZB4D8dbfuH85QYBIGExJGWtLobCQ9mTAXra/kb/q?=
 =?us-ascii?Q?vopBOQZE6xKUoElu9kInGD1Jqro1mDvJJZz2axZhDGnFFyCCoj8QI4+It7JJ?=
 =?us-ascii?Q?oNGdWlX8BLsFpO1y/3Ip8c0qEOEShyxrpOCtUp8Sg6KdLp+KvM8eZVFkFeem?=
 =?us-ascii?Q?AIcUK4FoUm0XvVvPuY8YykXwkHCkFi2d53CnUXmuuw+cLMnGgc+fvyuOxvIU?=
 =?us-ascii?Q?Gl6GpRODvut+xkmGsqBi7xJkghFXBnPUo6Q0rCFA1nwLEUsr8YcYrATuSueU?=
 =?us-ascii?Q?N57WxHO9kzOzZc8WXJvUimpd40n/YES9c88shp3+yZI2zaBbeuvQLaqHilsv?=
 =?us-ascii?Q?+1NTffyBHsI7wjHXOOQgtYItrdOwtqiBbwXgvzvr1WQfLKXh6LKKLKAQtFMI?=
 =?us-ascii?Q?fmYqFoahHvkmINRBJAAg54OKHcJUmexl/F0zb3HxTuDuYtRyvx3xlS5EtwLi?=
 =?us-ascii?Q?omUOVLp595iQnxHdshfuxnJ0IKJ36aonfZmqRJ4uvIiNTu6pcL6kHoS3Cqge?=
 =?us-ascii?Q?Im7tuxFs6MlufnB/6y6lLnUrMgUuGMQcTrJQqEYU2cHGQBlA5bXxeT89UGbX?=
 =?us-ascii?Q?No47t8Wb5MLUR0Gj59s2qAymKnCb79mI9e5JRs52fQaAhKXMq1CflhoGqvgT?=
 =?us-ascii?Q?4aLWNpsUWumgUpsYMcx0rPAHb5oWrd3sHoVjlQofyIPB/3HnKimSSKoSn4TG?=
 =?us-ascii?Q?g2zYqwRpZ3cANdPJtVBLEuMu125IwEbGBxh+CoL1S1yA2BDqlGcAS5vz9w4Z?=
 =?us-ascii?Q?csfH8IvQNj5XpZL9QRNrx1rDl/vefmTzkzqKPZTLAfRajOWfZjs6pCLMtfQz?=
 =?us-ascii?Q?e3v+95oSBVWRV7+lnSD8YHxUKkmWU7rCrxfqnNcxWB+usd7M5L5JYXUgUYNm?=
 =?us-ascii?Q?NDrnpYjkR0Ns+0C5UiCOL5+bAHY1+z4qM775KasA/e8zjlQwh64cS9NPm/Hj?=
 =?us-ascii?Q?ROuX+ri1a+ISHXzPZOyz89B2RgyRkJNKtuI9A7BdsUFfEMkgSvCJN1czPLIX?=
 =?us-ascii?Q?R8F6T4txWzsgDwH+g4b2S0LCXpsPzqRveXSYcS++yK/Zqk+L10NtHrS9PbGQ?=
 =?us-ascii?Q?QQVYDg7Jw2HMY3DUv+MbHa7mmOHm452iR8GNDbJ4F8VinLHgUudzsCIDvLKH?=
 =?us-ascii?Q?DXr5JEl4ohxayvXv3Qv0nwrJ0YNyyEM0e1c0HyHW78UV/fqIADAK9mbXC/U/?=
 =?us-ascii?Q?9/BuVTwPv2iM2kiAfxQoKwvkwPf/XRrbYBkeMizD5T6RAX5GSlDciVHW9n5Y?=
 =?us-ascii?Q?3EBLW3mDzkdDh5QGebGPErYF5fB3arpDBik31vBUKnfNM5kaeIYMBXX2ndWx?=
 =?us-ascii?Q?k+tTVaQWzc3mbvbNhd9kJB/8v82n60SdxFOfNVR64vaaDPWrQ9ug82RoN4Rf?=
 =?us-ascii?Q?zocoa2H/8kB4D2nHsHm/w9R+pLEh0HsRgsRsu653/H8RKcpH1bGkvHhfDgd+?=
 =?us-ascii?Q?p9iUiiJGrnXX3VG4XkFKsY9FbdhY30xWM0vAZumvxibwgaexeOTGsazgJHeW?=
 =?us-ascii?Q?nQ61ljsH4T2KGitOmB8jt0uv6LaSApURcuMhjPdnbvsDKlp6mPD7ldPZfNi9?=
 =?us-ascii?Q?bMffc9UCpW/Dm5GCzBxErXquln+X89Oswx4wmW8B?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d2b27a-322f-4bfc-1e75-08db0d7e9970
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 04:55:59.4046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X8kYn7TS9/scZRp7rhyaOn59sWBAdFgKxYkrBtSXYbf0WB59J20IsqRycFLGa3tX7xn4cU7nVbQFpeEs3Q145g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR18MB4251
X-Proofpoint-GUID: bEVH4PG38Q6npXOqJvqNsba01QEK_CRU
X-Proofpoint-ORIG-GUID: bEVH4PG38Q6npXOqJvqNsba01QEK_CRU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_02,2023-02-09_03,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> -----Original Message-----
> From: Deepak R Varma <drv@mailo.com>
> Sent: Saturday, February 11, 2023 3:16 PM
> To: Sunil Kovvuri Goutham <sgoutham@marvell.com>; Geethasowjanya Akula
> <gakula@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>;
> Hariprasad Kelam <hkelam@marvell.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: Saurabh Singh Sengar <ssengar@microsoft.com>; Praveen Kumar
> <kumarpraveen@linux.microsoft.com>; Deepak R Varma <drv@mailo.com>
> Subject: [EXT] [PATCH] octeontx2-pf: Remove repeating variable in test
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> No need to & a variable with itself. Remove extra variable from the expre=
ssion.
> Change allows to realign code and improve readability.
> Issue identified using doublebitand.cocci Coccinelle semantic patch.
>=20
> Signed-off-by: Deepak R Varma <drv@mailo.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> index 684cb8ec9f21..66a27ee5ca56 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> @@ -792,8 +792,7 @@ static int otx2_prepare_ipv6_flow(struct
> ethtool_rx_flow_spec *fsp,
>  		}
>=20
>  		/* NPC profile doesn't extract AH/ESP header fields */
> -		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
> -		    (ah_esp_mask->tclass & ah_esp_mask->tclass))
> +		if ((ah_esp_mask->spi & ah_esp_hdr->spi) || ah_esp_mask-
> >tclass)

It is a typo. Below is the correct one:
                           if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
		   (ah_esp_mask->tclass & ah_esp_hdr->tclass))

Thanks,
Sundeep

>  			return -EOPNOTSUPP;
>=20
>  		if (flow_type =3D=3D AH_V6_FLOW)
> --
> 2.34.1
>=20
>=20

