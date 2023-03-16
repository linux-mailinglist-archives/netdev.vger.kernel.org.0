Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A47E6BD87A
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 20:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCPTBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 15:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCPTBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 15:01:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2092.outbound.protection.outlook.com [40.107.220.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3040BE20F5;
        Thu, 16 Mar 2023 12:01:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRw+czN7cM0SIE+6BfScYoIL7tpdgsdI/nzERlmeiriaqxuCRPS55fi9NRemIu7170XlZtwCRe9KIgmorc+HGfpD+FGOmgzfiAAaSEiZ3ybhIO6MnpWKg52KeMkU0Iin5uh8F1+9niMRQuisdhKEo6Emu9opW3bm2LGDGSTgLYxSdClhry+T5q1iarvHnXtkwstT8YcWzAX2tl3+Kg7YfVeyREJq+NHgC71uTg6FMp7176FroItPPsHZCAnEiBHfsCFuZzKJu4CXmfXJFsKaMC4GwjPkAonJ42qJOXw5ZZRX+6pNwM4ulTtKL+mh9Y035bghW8zba8zp6nzSsmlJVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJbgkBUix2Y2muCgPqJ/F0pYOeQTQiSvVVOwTkKp+j8=;
 b=Y3D2KqfTWUKJbzMEqN1SFUpcLNtIkWHU2RPhtXfh44m5jlYZ+CFkl2fcjco2JoFlvGX26RQaQN7/EkZzEYaHHsCUHrHUeIft21zbBRook5i88ucysWrOeMoOooGhD0ambUnhKGYAGAF7tRRFpOuta9/hcsISt3y4jNK4u7Y0CP9YIYJamPkDvAa7WtX8HWI3AvQcQqLDwrTeUzG2JPfoY8Crb/GGiSFAH+wLqqBu1UQg6FPs60TIZ4h7Qx4RvIv3zEl+Vp5OGVuZGSUh83l9k8oOlc3byP8uH5uMLMk1gEwftlFZLzUY3zzfmlJ0OL4jzI8CMxLNEXiT26StR9cZpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJbgkBUix2Y2muCgPqJ/F0pYOeQTQiSvVVOwTkKp+j8=;
 b=Oij8hzoYJjBL/6jCVEm3OyP+OUz/Gh+3Yx4V0rkmEZezdck+gS7/ooMlG2HCfW2AHkDKUQ2+lPbyEd39VcDgSo7AU2yhdZFZssVg9xCHi7P2nG2YwV5nX04qHLygHqtblUddBocss0UFu8tZDqk+vOkro8IKE2k9MtRS+i59Qsw=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by MW4PR13MB5410.namprd13.prod.outlook.com (2603:10b6:303:180::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 19:01:35 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::d23a:123:3111:e459]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::d23a:123:3111:e459%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 19:01:35 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     David Howells <dhowells@redhat.com>
CC:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jeffrey Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Anna Schumaker <anna@kernel.org>,
        Charles Edward Lever <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Topic: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Index: AQHZWBvarYtr7Kf76ku/+p4ZPGQrUa79lXMAgAAB/4CAABBbgIAADCQAgAAPPwA=
Date:   Thu, 16 Mar 2023 19:01:35 +0000
Message-ID: <9C741BDB-31B0-460C-8FE7-F1C9B49002D5@hammerspace.com>
References: <8F8B62FD-0F16-4383-BB34-97E850DAA7AF@hammerspace.com>
 <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
 <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-28-dhowells@redhat.com>
 <754534.1678983891@warthog.procyon.org.uk>
 <809995.1678990010@warthog.procyon.org.uk>
In-Reply-To: <809995.1678990010@warthog.procyon.org.uk>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR13MB5084:EE_|MW4PR13MB5410:EE_
x-ms-office365-filtering-correlation-id: 7fe19cf9-46f2-46b0-91b9-08db2650dd0d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GoGJEdVoP6BM14+qbDpP0eI8b3WVeN8IxqBMvxsIC8erum0y/1PAqYteSLI7WZOJ0O9zXYaPva2UI9Qc2aQZiRsKlVjccNqN/cByjP9ZPSiSLEmPMcs3IbrMHjBa3Z9FQNWw+qjzbPSvym0tPKyvfoOUygVhlF4FQvs2mYLyss408lJXczzvg5HwRpsXD7ZhmzNJNMTNdD58tt6XeymjS/QIIYf/ZD/bxHzpWl0DpXhA4WPmgSL3LDYf0pECuG0irsxqrvoKMoa59HjEyGz3rlmoE2G0S6lskCiLRS8He/3qUAyfOe71safvJwyN8PJnuSQXqx5y1HsJ73WTK4EW+o07lnN7TIbY5NdqTHg4WpsuPiukhFgXhqExOOJ3Qsr+KdTxxsqebPVyROv9iOw9VbzUFhgdHOORUT4avEKLPPen9gqrX1DgYtn4yufy1rnlnZo8g1NRRy+gW8p2/tHzj35RsQMksAWCpep0QkosvH8M/QIbL8htlDu1BnLwvA6OqCoR3nl6gdLCQGrFJndMaB28GeFth4KCwHGeHF2MIHxsspH3u7+Zc+cbi+7zeW9BItdeHtrqF+Da7zUfpATdcgkzWEit2U1m4v7B2XQYG/64Y30hBz4tJ9kuzU5wFwCRizT4A4TM7dYCjvoVVklFWxwBs+Md8OhCHqSpGkA8pOJV3p3h8Y9TYKxZNi6ixedxhE7J05Do+xCQMcbWkWO/kDpl0US4sKpU1PMVJcyNhik=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(396003)(136003)(39850400004)(451199018)(316002)(478600001)(38100700002)(122000001)(76116006)(36756003)(66476007)(71200400001)(64756008)(66946007)(8676002)(66446008)(66556008)(4326008)(6916009)(53546011)(8936002)(6512007)(186003)(6506007)(5660300002)(86362001)(7416002)(54906003)(38070700005)(83380400001)(6486002)(41300700001)(2616005)(2906002)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QnwhHwuM6Y58ycuAVxw8g7mebdsTMBZiU2cWVFc9Ma3j9585knofXGpAjhUS?=
 =?us-ascii?Q?ysUKiVnQPY9JRuwyezAN8ZoqybUPuBMsaHJDRfjDvVU3C+ctf6NKeiSHr1T0?=
 =?us-ascii?Q?/ZtagyDn7jrKZHSFJ792c80ndRVvd1K3ny7muMYg8yeXsN0plahuarGZmux5?=
 =?us-ascii?Q?cflv86z4z800851pvfTfc4xnkJWaYWocUK7s0BYAzicYENjX9czCPqex2XXd?=
 =?us-ascii?Q?0Ya3DRFdD7ODhW1upbWtEOMsXp0+D52xO3nu9BYO8zlQCg+AbCi3KdgIpfMA?=
 =?us-ascii?Q?n6I4KXuWi2KMUJthv244E6r7EwC5o30bar0/ktrcHvc2WvwiC/ZxypeC+J4h?=
 =?us-ascii?Q?hdw3oqiI4ZKsbVCO3Cm3zTceExe1p10kKaAK1PSDjSMQwCK2gq5olazugae3?=
 =?us-ascii?Q?mQbF9GYFKR+D/0vfyMY6LXH3iD7EVJAJFbGIBYpdcHaBAm1P9JCpep97Spf/?=
 =?us-ascii?Q?SrtX00EAS9vqakM2NJujCJoG7aBc7oBjFB4HbOXSksrTswlwfcNH82Hezysn?=
 =?us-ascii?Q?NDvHK0bQ7Tq4O+xFdP60TKXbkJ23Q9XMKM8TrJOmRaUN/tFZzVfbJNsHANJz?=
 =?us-ascii?Q?/ofVDdcmtz8zTRlKVCVvm5NeATop312b2abR5kmLVWng7PJ0wEl/ls2MkTFP?=
 =?us-ascii?Q?Eo9R9rHGHqDQWos0JbmIRMDUOXpyU6V1Rj77NuLQhaJhMZlwD/7Dtpox1NbG?=
 =?us-ascii?Q?mhd99+tD2GhFTFZei6TzOLYGqDXzM0Y5EeOsK5pwxbyrB7HfzivvwbvhHxkU?=
 =?us-ascii?Q?+mvnFwH/n7FfKeZ+g41K+Yatv+vHnjKWJt+nZ9mx1BdDbeimu12BVTGZTYcR?=
 =?us-ascii?Q?MkGq2kOI47gUhjafdqFcL6n81SBZtK3HUpx0zoPRcRR28JrV7h6JeK7LPldP?=
 =?us-ascii?Q?mO9orqwmWuHKbfVqVJB+oqhtDCQiCAPHe2AdyfT8BfQGpKKtzNM5OjEZno0l?=
 =?us-ascii?Q?bUdNg4lmj5qUSrI+lPsiqfjab4NnrrCjyoP5msQX2H9L/N2djJNhoAr79PXp?=
 =?us-ascii?Q?KlPv5UfAOHAz3nkyL8aqhFhv0imD/Dix8YysbHqoqtaP3+q7FPuDW/VVlNz4?=
 =?us-ascii?Q?2du/B4UHNISPjS/SYjbuXLKy0QggLjSMMf5ji5D1LcrojRbactiXOIZp4LC2?=
 =?us-ascii?Q?xTcRWqmIl3QahXiJGGNAoQDIItA+wzxmktbkCN3v36GcfsnE5zO5H+uDxxsT?=
 =?us-ascii?Q?zJb66d1BdVU5i7q4Fr27a0gsQYG3D9ptWaTGmOi6ICGmVXiA4LmjY1JpZcfe?=
 =?us-ascii?Q?pDwyW7vDQIfYiHbwnp8HiN8lDNaLwZH3/HEmcT1gCEQH2A9Juwb4NpWZw4Q5?=
 =?us-ascii?Q?ddKpMhd6KN6Cpk42TfK6NysMtZq5aWrnejoPR9LgqRaws4g45lRg7kGkdtk/?=
 =?us-ascii?Q?piyYGXr/K6t27IqUl7zGb6U/VMUWXN5CVp79UacNFY4Z2TXPTUorhy4Me/rR?=
 =?us-ascii?Q?ehW8dj/XhITyldAGoriO5ol33A3qvTiMmInTz2iNejqIaX336AXu0LpJIzt1?=
 =?us-ascii?Q?bIqST+8cHzL90wnF2mvGznDWBBWpC9jUrPEQsDdx4eEyvhZknwcgsjK9MRDX?=
 =?us-ascii?Q?Aw5VLJeP5TMxm2P3N/8gf6rXgIb4Ksw8bW7z95D02nP4dPHHyMujW2Lfe0NQ?=
 =?us-ascii?Q?JLXkn/rjOlLsfvYozI3LpE1sKNMS34zzBwuStaDQm5lrHlLfMr8zruXv9ks4?=
 =?us-ascii?Q?sWboDQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62428EC330CCF346865612A43F1E98D4@namprd13.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe19cf9-46f2-46b0-91b9-08db2650dd0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 19:01:35.0325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TncB0RjoJc8QitQl6CkfFU2oBmKUFoe/C/rDKYwjfnmweOEi4RTrkoz+96t/U3LdqjAQ5sCJMfRaGbadPchppQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5410
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 16, 2023, at 14:06, David Howells <dhowells@redhat.com> wrote:
>=20
> Trond Myklebust <trondmy@hammerspace.com> wrote:
>=20
>> 1) This is code that is common to the client and the server. Why are we
>> adding unused 3 bvec slots to every client RPC call?
>=20
> Fair point, but I'm trying to avoid making four+ sendmsg calls in nfsd ra=
ther
> than one.

Add an enum iter_type for ITER_ITER ? :-)

Otherwise, please just split these functions into one for knfsd and a separ=
ate one for the client.

>=20
>> 2) It obfuscates the existence of these bvec slots.
>=20
> True, it'd be nice to find a better way to do it.  Question is, can the c=
lient
> make use of MSG_SPLICE_PAGES also?

The requirement for O_DIRECT support means we get the stable write issues w=
ith added extra spicy sauce.

>=20
>> 3) knfsd may use splice_direct_to_actor() in order to avoid copying the =
page
>> cache data into private buffers (it just takes a reference to the
>> pages). Using MSG_SPLICE_PAGES will presumably require it to protect tho=
se
>> pages against further writes while the socket is referencing them.
>=20
> Upstream sunrpc is using sendpage with TCP.  It already has that issue.
> MSG_SPLICE_PAGES is a way of doing sendpage through sendmsg.

Fair enough. I do seem to remember a schism with the knfsd developers over =
that issue.

_________________________________
Trond Myklebust
Linux NFS client maintainer, Hammerspace
trond.myklebust@hammerspace.com

