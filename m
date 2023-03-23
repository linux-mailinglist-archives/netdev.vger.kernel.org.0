Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C446C6EC3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjCWRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjCWRZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:25:17 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4392B630;
        Thu, 23 Mar 2023 10:25:16 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NGev5T019934;
        Thu, 23 Mar 2023 10:25:03 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pg9urcu5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:25:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbtvVyvF9GPNXtfbo43VWITwDxcLS4aRA0pSC0p0bG2p/tWItdZGBx8zUASgaIME0U3DmGOny1gPl3TpGqF1zyqYXx/Ud7DW+toGDNbqXaLZWCzLP3s5h1mrqyiQyo21gGr1/DZdkcwj6CgpgQ6cpnvTeKy8WsPheYmNfodfthgHaTHWSCaVOtJHV/Hi0LIACJethsFKfjepQ3nNHpN0cXqy6L2OTd7RhgPn32kV5EySclYtzdowrRDqRGZVKMhbiyj9ilt6IkgOZldx1wnYwwKsGmhdUprRLdOgvawKc40AhHf3Ub9nsIibs8E/3Z6+kWUuecXBZuD5WxQVoVIndA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKae3fgYXK6SdJoucykmdPsLAcfqYBwnSQbwdEc36Ko=;
 b=bP8OW0DA7ffHhBi9o767zJt8ItBsDqUW71ZuDJIV/uHMYZEw8NAzotzBHFVLrpncz2HWfpi/HpSCxJVUj3dvXDA4WAJl9/86lqsaDnEtKsyxRuQD6RaCGJjpTl9xtOlbYal81sTsJLB3N3wQUwPLV5DL0kr9cWkfSp5tTs1PBzFzzyQ9XfQU+0a/dqvhivrqc6NV288SHvHVZfJrcYpt52hWF1sP5R65gALGYcXI54a0WwaIS+zX95Wb5CBk0hDXZEy3OUWQxcv+zlc0K6TQF0PxiUgowY2kfWI0HnfMGdWcmVMQmLoC7kc8RfKz1x1D2CLsQZZRCyT0IKSq2Sm90A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKae3fgYXK6SdJoucykmdPsLAcfqYBwnSQbwdEc36Ko=;
 b=hGLW+s5k3V7I7vzEYIm+37VaSF9q71OMCya/daGXGiT7J7/g8MOGdQ7nQTpr/GI0LYvqdtSAf6j5jpXwK9VL2w7HZ9XwBBEyNhBYLzrB+Y84v2Ud/qKACdIgVBz81sFG1XUIxA8wADm91BFP/tt8xDbcMbDQKbeqKc1lJAGtV8E=
Received: from MN2PR18MB2430.namprd18.prod.outlook.com (2603:10b6:208:109::23)
 by SN7PR18MB3871.namprd18.prod.outlook.com (2603:10b6:806:104::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 17:24:56 +0000
Received: from MN2PR18MB2430.namprd18.prod.outlook.com
 ([fe80::f5bd:9166:1a02:cbe7]) by MN2PR18MB2430.namprd18.prod.outlook.com
 ([fe80::f5bd:9166:1a02:cbe7%6]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 17:24:56 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [EXT] Re: [PATCH net-next v4 6/8] octeon_ep: support asynchronous
 notifications
Thread-Topic: [EXT] Re: [PATCH net-next v4 6/8] octeon_ep: support
 asynchronous notifications
Thread-Index: AQHZXJ+MKKx7Fkul+EmXkxNMFkCqc68ILhwAgABwmhA=
Date:   Thu, 23 Mar 2023 17:24:55 +0000
Message-ID: <MN2PR18MB2430BA163B1FC69EEB39EE75CC879@MN2PR18MB2430.namprd18.prod.outlook.com>
References: <20230322091958.13103-1-vburru@marvell.com>
 <20230322091958.13103-7-vburru@marvell.com> <20230323103900.GC36557@unreal>
In-Reply-To: <20230323103900.GC36557@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctOWQ4MGRhN2UtYzk5Zi0xMWVkLTgzNzctZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XDlkODBkYTgwLWM5OWYtMTFlZC04Mzc3LWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMzI1OSIgdD0iMTMzMjQwNjU4OTA4MDI0?=
 =?us-ascii?Q?OTUwIiBoPSJBSSt4WHd3R2Y5NCs0OFk5Qlgvb3NrSFlUbGs9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUIy?=
 =?us-ascii?Q?RU5wZnJGM1pBUmd5THVlTHV0a2NHREl1NTR1NjJSd05BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTFGSDNhQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQURnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR18MB2430:EE_|SN7PR18MB3871:EE_
x-ms-office365-filtering-correlation-id: 23b4b455-acc1-4296-6f44-08db2bc38579
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aVx04/GJgofiVSI8IxQqRHWQzQAVHnrYUR+0suGxej1aVPBl/xSc3wMTDfPLEBg5ImJwjEj1Y8PDVoNHs2N9goLcUDw/hoQJnBKoAlisYpUpkTBA09lpSbNztMewwzkWdzWhnsmk0MBK0VyXjtpm44kkNrZ7fXjr5/EpgL36TxF7nPAYiV98kWRSJidtb0QEpBcxkPDOfXpYqfokKSaWKTP5xntCpq4rddRGEjwdgGFBfg4SPD6+sZaql0QpaonGU0snxUe5Xe8Un9RrAH6h2izst9MThaVzw43Ehqm1CBzNogsR11ta4WiA7mlHZyzprVIR+doAWANEs9Xl3mT8ZDdtQ0NYRMcD0lCd6c0G7ytVnNL8dFjLF6T0dx5MvlFaYdQ9Af8oYIeXMbDLuozqy/i4HncMu7KwevcQ4XIrN8IVOV3DJsmOjQNiFroeEAuuIPhlHs2Mo1T67moBNLHseoA+AlNQOdGawtbCUhO97qDTrr10DXwGO54BPx0A5wwBTOAwIjM9gqlAJdYveVG47WE9L/0sAkFXJjSsLNR1w8TVIhFtfEm8RPNZRY2C/jew9/HJJVySn9I4LnneFwrzpapjHH57nFGdWvhmDsEXUixuwy2ui1o/buj3tr30wf2HwxkmFlDMHYXELgjKB3ETG1vdyp3tgFW7DN5LGxhecVoVI2gNSl+lc5bqJt25NVb2Oq55jJTRixO5kd0WblkVmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2430.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199018)(41300700001)(66476007)(5660300002)(52536014)(4326008)(66556008)(8676002)(2906002)(15650500001)(7696005)(66446008)(38070700005)(33656002)(86362001)(6916009)(38100700002)(122000001)(64756008)(71200400001)(26005)(966005)(478600001)(76116006)(19627235002)(316002)(8936002)(66946007)(55016003)(54906003)(83380400001)(6506007)(186003)(9686003)(53546011)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/P4h0kpgzEiOH67D1Wzr72OY7otxC4wncSHbTLbMn9jOVWTmsa0f2A2euuKC?=
 =?us-ascii?Q?9w1+j9ujXmKkZhr/Ng15bvPtlpToU6gMLzBcuCbbUWsD9a3pE+SGlj/duSzY?=
 =?us-ascii?Q?hDTj0lU5HFtX6SgopfQ9VE3nah+RejUOt1L5C76kar7uk0IG8p8QjV971TJV?=
 =?us-ascii?Q?glWSPwXyfy+X/M32ak9r6gEEd+t86jD1uuepzYBVBDHTb8oxNyYQJydKd2ns?=
 =?us-ascii?Q?ZQgnkcmA//YNHlTJgzzF4GcDjunGBm8PgqSLMzLeE+G1MZgoCyCWuIYW07D8?=
 =?us-ascii?Q?8ypl+9zQF/kcgnxENWxCISd+t92YPCMuNi6vXoHkIUqbZSETSPKAoKmpcCV1?=
 =?us-ascii?Q?ic3sTzskirZOhDA7cdzhWivvxmFDbBnujsvHuFjUZUWFd0AfFrh/otptHhu8?=
 =?us-ascii?Q?B+Xid2wagMDJ6835e6e1vEPfAc8pnChADsjvqoBN1S6nrGQczDWZfoxxn7M8?=
 =?us-ascii?Q?S0Cf74gi8dAzTteEF+6jhIKphBQBNJxHTcErlZsOKlRrKisVa4Fk4ZL3k0bq?=
 =?us-ascii?Q?yKOw7qlkYwfaF7L8SXktDYH6h69cFI31dp8p6bCPL3R1PpW4ley6tQojVrEs?=
 =?us-ascii?Q?01C7Nug9PrYqkw0GmDdZOzOUo3P5QME3Jo7Ubu8S+qAojTM4ix1Hb70U+8sg?=
 =?us-ascii?Q?kmXgsPHkCZOrdkJudGxbj9aJRQfVI50dkGUQRZx4qqmT68a1aN+vo5dnl28q?=
 =?us-ascii?Q?ACT6DqnOBbJlQlYT4lw0g/GTF20qb/2VR5SVLhXEnEtMPSt8HlxFB/f6rcQO?=
 =?us-ascii?Q?sqUpwuxyGHubBCggMQlFsY6y9J9W3Wwu9G0DHX16baSEfSMLo9nSgB3HII0D?=
 =?us-ascii?Q?Ixs6WeBBa/cpgFDubPOQhk+hLWxYybCvoC0YuvSDA7I9sTFLXadNqNSic/Uj?=
 =?us-ascii?Q?BgCY7Vhyd6mxAU8SdbuNJ4AIaKfSlmQkDtxrnvJzSdCpN1T8r5wFoWqtlrPH?=
 =?us-ascii?Q?8Wr7A78fptaEj0NilhU9WwoIxHoH2B5M/d75u/14vMGRCgxHUSdNmXhkI2KM?=
 =?us-ascii?Q?AMe0HmUKMddx6M1SQvOl3JrFP8dG8UyjHrlu7wAupuardto/ixAc1qt5jypu?=
 =?us-ascii?Q?h1kUvnvLQ6qs5bkIy/Tn2eHsP7HOjSF1r5LJaxs4srfgkjdwsdbENNSk+ml6?=
 =?us-ascii?Q?NGSP7oz/ot3H7nzJepu9zJNW2Eur0D4bq4uNUZfaGWNL+lveiUHvWliBGZvY?=
 =?us-ascii?Q?hkBI3uKOwJlpJHtHbiY8yuVkTbOyNbuVgyR2MJzUNUCfgnzqAGyibw2vBrZ0?=
 =?us-ascii?Q?CWutleB0YSOVEB/QUJOIoFtl3K58PqpKQB5uaKNDX3KY6eXbiTsso122UTDF?=
 =?us-ascii?Q?hy+fpagURRztSVsaHKLlJ/SMNQ8sGpK78+kb2HKt26UMZKq3PHxKnCq+bqGS?=
 =?us-ascii?Q?TR6TtccJ1zT8sM59U04dH5qwO4VVe5Jmnoyo4/tHBzhBhzWFuUJM87xwkrN9?=
 =?us-ascii?Q?pAxNTiuTj2gt20VlWwLrTUJA+5l+YWeAjN6fvpL077hX/y7v5nrLfDSRwKAb?=
 =?us-ascii?Q?KJkUgJ2TwpZw6smddC36pwfOxc+3Vo2aGWyFuMd4N4dD223JtWAY8kXOf++w?=
 =?us-ascii?Q?mMg0e3mujbzn2UDtf5innG9YJfnHx5MUtcsdRppl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB2430.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b4b455-acc1-4296-6f44-08db2bc38579
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 17:24:56.0689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /B8S0yfkqtLVX3RfBsc3ORS2Msj7vox4xc/HevAY/4x1WzL2XszP3io6nSp9lVYUm5LyFJnz3tnHY8FrwlWHEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB3871
X-Proofpoint-GUID: hH_ubE3rtTN6mXiXHjChtbdQCTKWk8Lh
X-Proofpoint-ORIG-GUID: hH_ubE3rtTN6mXiXHjChtbdQCTKWk8Lh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-23_02,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, March 23, 2023 3:39 AM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Abhijit Ayareka=
r
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>
> Subject: [EXT] Re: [PATCH net-next v4 6/8] octeon_ep: support
> asynchronous notifications
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, Mar 22, 2023 at 02:19:55AM -0700, Veerasenareddy Burru wrote:
> > Add asynchronous notification support to the control mailbox.
> >
> > Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> > Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> > ---
> > v3 -> v4:
> >  * 0005-xxx.patch in v3 is 0006-xxx.patch in v4.
> >  * addressed review comments
> >    https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_all_Y-2B0J94sowllCe5Gs-
> 40boxer_&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DXkP_75lnbPIeeucsP
> X36ZgjiMqEKttwZfwNyWMCLjT0&m=3D5CnsD-
> SX6ZoW98szwM0k4IXgNC3wY0EwCQHxDKGyNIRUJxdaNe3zorLcOhc9iU6d&s
> =3Dk73McQSsjbjj87VbCCB8EFFtGWtksMIGhn15RK12XF8&e=3D
> >    - fixed rct violation.
> >    - process_mbox_notify() now returns void.
> >
> > v2 -> v3:
> >  * no change
> >
> > v1 -> v2:
> >  * no change
> >
> >  .../marvell/octeon_ep/octep_ctrl_net.c        | 29 +++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > index cef4bc3b1ec0..465eef2824e3 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> > @@ -271,6 +271,33 @@ static void process_mbox_resp(struct
> octep_device *oct,
> >  	}
> >  }
> >
> > +static int process_mbox_notify(struct octep_device *oct,
> > +			       struct octep_ctrl_mbox_msg *msg) {
> > +	struct net_device *netdev =3D oct->netdev;
> > +	struct octep_ctrl_net_f2h_req *req;
> > +
> > +	req =3D (struct octep_ctrl_net_f2h_req *)msg->sg_list[0].msg;
> > +	switch (req->hdr.s.cmd) {
> > +	case OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS:
> > +		if (netif_running(netdev)) {
> > +			if (req->link.state) {
> > +				dev_info(&oct->pdev->dev,
> "netif_carrier_on\n");
> > +				netif_carrier_on(netdev);
> > +			} else {
> > +				dev_info(&oct->pdev->dev,
> "netif_carrier_off\n");
> > +				netif_carrier_off(netdev);
> > +			}
>=20
> Shouldn't netdev changes be protected by some lock?
> Is is safe to get event from FW and process it as is?
>=20
> Thanks

Thanks for the kind feedback.
I do not see netif_carrier_on/off require any protection. I referred few ot=
her drivers and do not see such protection used for carrier on/off.
Please suggest if I am missing something here.

