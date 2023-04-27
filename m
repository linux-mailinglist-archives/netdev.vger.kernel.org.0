Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A1F6F021A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 09:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbjD0Hs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 03:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242701AbjD0HsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 03:48:18 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6511FF9;
        Thu, 27 Apr 2023 00:48:17 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R78Y85006833;
        Thu, 27 Apr 2023 00:14:25 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q7apa2c66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 00:14:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kaV+CijzvrGXffMdKpVJu2PeFdgzvA0ht5g5a95Qv24cKMKjFQZj4cvjX6ZRZrCE8/aj3Zq5vNXwTXspuap/uUC7vsQj4vbzGXd85kC1hdGn+MfQ6QwcimD73adYjsE7zldKHE2EbJbFrjp5aHMleqy5hwRD3LzPpELyB8r+PgBSVKNFh2pdJa7W8Ez80GLPsBHTR/aOYuZPrnVV3zG23gpSv7wPlVh4XNmtSEUevpU0z+GZMAAIaCLCS2zGbvw/ru5VLrzu44NRxUZhOlpTX+RSGiu85b+oG9YvgjzcX5Qb1fXdjaLb+Y9ygTuyd5LpCmEcDQ6/bf7nChRAo7xsqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqhOkp56kY2GNVLMdsMMHDWiOUQUFTJO5tPKV1p5N64=;
 b=GN2wHeRXfSRy+BHh9fWAFYbkvyQfo2HyZ9lyJvMiFeLAhW+9h5VJYxWrhHpW0KH34GgucU/55ACuASe/atVCNrgd44RG8QjnMgiYZLN+/NfZO3/71dT4738jppbbtrmBORFox+frzKUskP8yeCmC1waPk5rK75ky+eofaMXA7dycz7hX+WuKH6mdFf7aKZKhyCaM+huWTGleG1fjNZOunHVYUofdc+M01CMIZAbaAqwhuwrPzd1uhERz5Q1tb6d+SF3lIJ1mWoYlA0l6HVApbkm56AtV6A6i/WeTRLCLHO4huOR0Z0Sqiq4t3AiqLciK1ZuJI5dG7LWYgy/r0prCgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqhOkp56kY2GNVLMdsMMHDWiOUQUFTJO5tPKV1p5N64=;
 b=RyZEpFNmMUjMiWEAY462DyxAdEkna8zSSBth9ql1CAmjrQWiFYcz5m49ZFAbTiiIUXUW9YaIycwURaBtrhqczd5J9ouv5VKZr/XZhwlj7VBR6C6g/yvmQ18VYIDY7fdp04EzOHlHQTMGLrahFeiFSUekf6OKEQnibaVdBVcJqFs=
Received: from BY3PR18MB4707.namprd18.prod.outlook.com (2603:10b6:a03:3ca::23)
 by MN2PR18MB3605.namprd18.prod.outlook.com (2603:10b6:208:268::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Thu, 27 Apr
 2023 07:14:20 +0000
Received: from BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353]) by BY3PR18MB4707.namprd18.prod.outlook.com
 ([fe80::e907:e8ce:db04:b353%4]) with mapi id 15.20.6340.021; Thu, 27 Apr 2023
 07:14:20 +0000
From:   Sai Krishna Gajula <saikrishnag@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net PATCH v4 10/10] octeontx2-pf: Disable packet I/O for
 graceful exit
Thread-Topic: [net PATCH v4 10/10] octeontx2-pf: Disable packet I/O for
 graceful exit
Thread-Index: AQHZeNfiI+FROnMtV0yeyz9Ad45/9w==
Date:   Thu, 27 Apr 2023 07:14:20 +0000
Message-ID: <BY3PR18MB470730CFAADC80CE5BF6A7BFA06A9@BY3PR18MB4707.namprd18.prod.outlook.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
 <20230426074345.750135-11-saikrishnag@marvell.com>
 <ZEj3jK639HNVN/ks@corigine.com>
In-Reply-To: <ZEj3jK639HNVN/ks@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcc2Fpa3Jpc2hu?=
 =?us-ascii?Q?YWdcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?us-ascii?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy0xZWM5MzcyMi1lNGNiLTExZWQtYWQxYy0x?=
 =?us-ascii?Q?Y2MxMGM0MGQ5ZTRcYW1lLXRlc3RcMWVjOTM3MjMtZTRjYi0xMWVkLWFkMWMt?=
 =?us-ascii?Q?MWNjMTBjNDBkOWU0Ym9keS50eHQiIHN6PSIzOTkxIiB0PSIxMzMyNzA1MzI1?=
 =?us-ascii?Q?ODExNjUzMjQiIGg9ImdDM0p5TGl1aXJJVS9WMmtnRHM3UWtScVU2Yz0iIGlk?=
 =?us-ascii?Q?PSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUJR?=
 =?us-ascii?Q?SkFBQU1DWWZoMTNqWkFiVVd1YVdZcnVoRnRSYTVwWml1NkVVT0FBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFIQUFBQUNrQ0FBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFFQUFRQUJBQUFBYWk1eElBQUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFH?=
 =?us-ascii?Q?UUFaQUJ5QUdVQWN3QnpBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01BZFFCekFIUUFid0J0QUY4?=
 =?us-ascii?Q?QWNBQmxBSElBY3dCdkFHNEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFB?=
 =?us-ascii?Q?Q0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFYd0J3QUdnQWJ3QnVBR1VB?=
 =?us-ascii?Q?YmdCMUFHMEFZZ0JsQUhJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJq?=
 =?us-ascii?Q?QUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QVpBQmhBSE1BYUFCZkFIWUFN?=
 =?us-ascii?Q?QUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-rorf: true
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdB?=
 =?us-ascii?Q?QUFHTUFkUUJ6QUhRQWJ3QnRBRjhBY3dCekFHNEFYd0JyQUdVQWVRQjNBRzhB?=
 =?us-ascii?Q?Y2dCa0FITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWXdCMUFITUFkQUJ2?=
 =?us-ascii?Q?QUcwQVh3QnpBSE1BYmdCZkFHNEFid0JrQUdVQWJBQnBBRzBBYVFCMEFHVUFj?=
 =?us-ascii?Q?Z0JmQUhZQU1BQXlBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFB?=
 =?us-ascii?Q?QUFBQUFBSUFBQUFBQUo0QUFBQmpBSFVBY3dCMEFHOEFiUUJmQUhNQWN3QnVB?=
 =?us-ascii?Q?RjhBY3dCd0FHRUFZd0JsQUY4QWRnQXdBRElBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFu?=
 =?us-ascii?Q?Z0FBQUdRQWJBQndBRjhBY3dCckFIa0FjQUJsQUY4QVl3Qm9BR0VBZEFCZkFH?=
 =?us-ascii?Q?MEFaUUJ6QUhNQVlRQm5BR1VBWHdCMkFEQUFNZ0FBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFaQUJzQUhBQVh3?=
 =?us-ascii?Q?QnpBR3dBWVFCakFHc0FYd0JqQUdnQVlRQjBBRjhBYlFCbEFITUFjd0JoQUdj?=
 =?us-ascii?Q?QVpRQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCa0FHd0Fj?=
 =?us-ascii?Q?QUJmQUhRQVpRQmhBRzBBY3dCZkFHOEFiZ0JsQUdRQWNnQnBBSFlBWlFCZkFH?=
 =?us-ascii?Q?WUFhUUJzQUdVQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR1VBYlFCaEFHa0FiQUJmQUdFQVpB?=
 =?us-ascii?Q?QmtBSElBWlFCekFITUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBRXdBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQWJRQmhBSElBZGdCbEFHd0FiQUJmQUhBQWNnQnZBR29BWlFC?=
 =?us-ascii?Q?akFIUUFYd0JqQUc4QVpBQmxBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFKNEFBQUJ0QUdF?=
 =?us-ascii?Q?QWNnQjJBR1VBYkFCc0FGOEFjQUJ5QUc4QWFnQmxBR01BZEFCZkFHTUFid0Jr?=
 =?us-ascii?Q?QUdVQWN3QmZBR1FBYVFCakFIUUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFHMEFZUUJ5QUhZQVpRQnNBR3dB?=
 =?us-ascii?Q?WHdCMEFHVUFjZ0J0QUdrQWJnQjFBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQVFBQUFBQUFBQUFD?=
 =?us-ascii?Q?QUFBQUFBQT0iLz48L21ldGE+?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4707:EE_|MN2PR18MB3605:EE_
x-ms-office365-filtering-correlation-id: b67a8cbd-adeb-4c5e-380e-08db46ef0528
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3KVeid0m+JCq3DLPoSNhr/eSv4+p0gjh2t1MbYFrHhNEiPto7PNqxJd4Kr6egyeRtsSD4DJgkxRjPr80UjoVSOSXBNkXZAb6vW+cSwv9YZ1gUyEHJ+UNd9ulfFqs1IkCIN9UbiGwe/QvK+ZMi9AD1XWT8YwtyUAXyVuIazCtMdBT8WZCP+EdvJswYpMZ+MOt/X+YxILGUSM1cUTQ0LhEIYcIsfNRHFQ1UTuKGRWG84I9RWg8thd3ZmUfgULCbXwTR/4/wQFdcLBQfWdTpsdT0TlA0s69jDl8HivrYCyEfIWCtp6PuzBxX3ojKaZZjSoi5bTUx4lYeub4mo89Z60IMSSRQwck0QsuxIGjXhaMGjB3xUB3zdslwkVwEv76EeyZUEX89HilyEy9X5Hwz0gf8dpVstp0vWrTIJ2yivEdjiA3gLc8Ogn0YuIDcDMRWiT+sev3ng9iEUBH8wCPbPa6D1mBAjHPc8Jvb21u2TC0iZpI6uBi2ddBtn+AO3sU3JPkwyR9b8/9J9muXYppSCV/XDxjB5RuqkTuZ2CY9aO1Ct5gu358iNx9o2SzeKhLw0dL+3iKgA76syth/UouWEuqIzTzBKR+8mHoLJW76w9I6NWaVgw4LspgSHnC0mPK3n4O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4707.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199021)(2906002)(86362001)(83380400001)(6506007)(9686003)(186003)(66556008)(26005)(107886003)(478600001)(76116006)(66476007)(66946007)(66446008)(71200400001)(64756008)(33656002)(7696005)(54906003)(38100700002)(55016003)(122000001)(53546011)(8936002)(41300700001)(316002)(6916009)(4326008)(8676002)(38070700005)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6Qd3AWp1uSYB/YlJK8AGYSESL7xkLTJbCQ5kdWw99pFFlQuc5P7Fs71J/j9Q?=
 =?us-ascii?Q?CRPp6M+XgCMeIfGwgauD9YgRafGNmVLNHmvlDXjzTmC/+ERua8nD3tLMfLG6?=
 =?us-ascii?Q?UwbcpKhjkeFXdtSsfCTAWGbUKJa26qv0u9K0pVzv14FmIv4NsS5qBT20FhGY?=
 =?us-ascii?Q?bA3dLWePOfDMka0TYZWL+2ffO+HTGIru0l3nE8lVnPhOs7n654Qbrc443xyW?=
 =?us-ascii?Q?+Z1ADBKcce3LmD8ob72VPOjFRsrcP9pufv0UuPw+wkCpTqaxDVYznJ6J/Xr6?=
 =?us-ascii?Q?lPIhFEgOzyqppqLqp3jUWMK8C9GvwABC5YrwOJ6+I2qSsGdCp5SJBhFuASHY?=
 =?us-ascii?Q?64ijDFhc0BWNeVgqsvlzyJVkZNfivtS0PJiYdLNzpuhdrXA3IKkq61hj/Mhx?=
 =?us-ascii?Q?FniS68gfb++K+hNpXhNdT4eT0+QhcuV8CRVlEbFimI0lRCS8SBP+RAcn78OH?=
 =?us-ascii?Q?10flVA2CT+MV23oAjnaVaR0Ag2eD8IL4uAiach+sryLJdCgE6keNEQIlmHO5?=
 =?us-ascii?Q?ruMzWXZpU3oDcVzbegyhMbOo5uyuJYuUrpJyWj9iBohVq1vCIPoNcvLoli4L?=
 =?us-ascii?Q?Gs7Eomwp83zljPSer6HKpcMbAjeHqeK4/9DIpM89ijhHs40/MFMQNPKWmCrP?=
 =?us-ascii?Q?2MTv3WnHoM5C9da0qHjFqt6w8fZPyr3k2TgUESnp+f4yjFDXjO9rzlW1sDOK?=
 =?us-ascii?Q?LwiTutS7EsCnKZ65Xuy1fWpjhQW6g0QhjbGbsYpGix+R4/Om4kcsaZyRkrVB?=
 =?us-ascii?Q?U22nAQDjBXZwor/Hb6+BICpjnlWbOO7qLKtIohvyKoOUHNoc6ym+tISYD8a5?=
 =?us-ascii?Q?0P3tpGY3ZH1XnDZamS/Y9Yy0tX5z4ZkgGlCyvpuL9I+3RivVmT0grMRwrxg1?=
 =?us-ascii?Q?3nGcRNWFLtouI7dQRPGUHZjoirLGUSipyyNqdfIpZ7gRXA6H74vz80WXNFY2?=
 =?us-ascii?Q?bn5cvclHgCh9cGT4vvAHYcmIfKMRbw1o/Vrt4gMiKvl2jF0ujUwRssyDEotR?=
 =?us-ascii?Q?xk6y1ZHIG7mDyWX4x/TivUdOlXIqFStzaq33poTPZpl8DJVpSdXKqmqSGSmW?=
 =?us-ascii?Q?VQeb9oVBmdSgB5uCpEprAHGo93mZdYJw/7iSSqUgc3PGkFML2D3ITLcIpLI9?=
 =?us-ascii?Q?OOR2FW+ECb45NHvUieOg1haQ4j1jg5GzVuaznwm7WkHZRxXjjp4G715LW8tR?=
 =?us-ascii?Q?J0JexXtg0UvOGcT9F9UH5bLtwzXcrKN6rbwvsEOPPQsDQvgBtmTQGTIVxiS2?=
 =?us-ascii?Q?BYPps1mGnRUKAAf1r/S2Yw+EvC6P9K2qzom2kjGvrSHGTy4HGPybe3gYukvV?=
 =?us-ascii?Q?bOs3uFmCuz+FK1SmUKftDzyGfcMiAGLJc2tVh/euQNLiHfw4h7dqCie1M1eY?=
 =?us-ascii?Q?GMHjohoc4A5Jo+LKS3sT+dIDy8K5twxYBT55Wz/0GVq93G9CFhYU/sOGfwXz?=
 =?us-ascii?Q?XxrD6Z+jxWMo4RWS/anzER/bXhr0Me+4tSRXJYkICFdfVbUpEbhIdytUVGEZ?=
 =?us-ascii?Q?aj33kWIFPXojPC6WwRDvWFmijCG7MbIm/zCahQRFrjtMXNKj/2g563eB+fHI?=
 =?us-ascii?Q?rjIVTg0c+M1AzuO50PSPOHABxKFphRHCm6NspGRR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4707.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b67a8cbd-adeb-4c5e-380e-08db46ef0528
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2023 07:14:20.0101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H27W0gvXOV//byzI5afZjA7T4UXpGO/JyfDontLrGy9dpLZALEsB2fQNZV//8PSx6dpDZyDeSdNRML3+ZQv2tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3605
X-Proofpoint-ORIG-GUID: XY07OmvjyUq0AOoDm7el-nA3_2n6v8T7
X-Proofpoint-GUID: XY07OmvjyUq0AOoDm7el-nA3_2n6v8T7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_05,2023-04-26_03,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Wednesday, April 26, 2023 3:36 PM
> To: Sai Krishna Gajula <saikrishnag@marvell.com>
> Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; leon@kernel.org; Sunil Kovvuri Goutham
> <sgoutham@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>;
> Linu Cherian <lcherian@marvell.com>; Jerin Jacob Kollanukkaran
> <jerinj@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>;
> Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
> Subject: Re: [net PATCH v4 10/10] octeontx2-pf: Disable packet I/O for
> graceful exit
>=20
> On Wed, Apr 26, 2023 at 01:13:45PM +0530, Sai Krishna wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > At the stage of enabling packet I/O in otx2_open, If mailbox timeout
> > occurs then interface ends up in down state where as hardware packet
> > I/O is enabled. Hence disable packet I/O also before bailing out.
> >
> > As per earlier implementation, when the VF device probe fails due to
> > error in MSIX vector allocation, the LF resources, NIX and NPA LF were
> > not detached. This patch fixes in releasing these resources, when ever
> > this MSIX vector allocation/VF probe fails.
>=20
> It seems to me that the issue in the 2nd paragraph / hunk is different to=
 that
> in the first. And thus it seems to be appropriate for it to be in a separ=
ate
> patch, possibly with.
>=20
> Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")

We will separate this VF patch and send it in V5 patch series or as a separ=
ate patch.

>=20
> > Fixes: 1ea0166da050 ("octeontx2-pf: Fix the device state on error")
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 11 ++++++++++-
> > drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c |  2 +-
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > index 179433d0a54a..52a57d2493dc 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> > @@ -1835,13 +1835,22 @@ int otx2_open(struct net_device *netdev)
> >  		otx2_dmacflt_reinstall_flows(pf);
> >
> >  	err =3D otx2_rxtx_enable(pf, true);
> > -	if (err)
> > +	/* If a mbox communication error happens at this point then
> interface
> > +	 * will end up in a state such that it is in down state but hardware
> > +	 * mcam entries are enabled to receive the packets. Hence disable
> the
> > +	 * packet I/O.
> > +	 */
> > +	if (err =3D=3D EIO)
> > +		goto err_disable_rxtx;
> > +	else if (err)
> >  		goto err_tx_stop_queues;
> >
> >  	otx2_do_set_rx_mode(pf);
> >
> >  	return 0;
> >
> > +err_disable_rxtx:
> > +	otx2_rxtx_enable(pf, false);
> >  err_tx_stop_queues:
> >  	netif_tx_stop_all_queues(netdev);
> >  	netif_carrier_off(netdev);
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > index ab126f8706c7..53366dbfbf27 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> > @@ -621,7 +621,7 @@ static int otx2vf_probe(struct pci_dev *pdev,
> > const struct pci_device_id *id)
> >
> >  	err =3D otx2vf_realloc_msix_vectors(vf);
> >  	if (err)
> > -		goto err_mbox_destroy;
> > +		goto err_detach_rsrc;
> >
> >  	err =3D otx2_set_real_num_queues(netdev, qcount, qcount);
> >  	if (err)
> > --
> > 2.25.1
> >
