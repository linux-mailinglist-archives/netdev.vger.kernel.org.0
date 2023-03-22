Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206196C5405
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjCVSrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjCVSrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:47:13 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2138.outbound.protection.outlook.com [40.107.96.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E2666D0B;
        Wed, 22 Mar 2023 11:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSDgzX4NzxnlGi271+e+MMDwSHksalpRAqrcLw/D6FMzrF0WPpLl1lZVxSJRibXJiaC6bp3Sp45U6EPOha4Ckgx/tt/gGpsgxTXLFJm3+KrdtsXrVVtgnqYnNLiAJDzco7llqaxT18OF9cR/Y9dgd8sIbIbPEVxp5ibZxqTSOGd3Vi7Sfnv14HJmE9X1yCGcydHTHTyN1MPf2yAs/fBJyf6QsZIoUv7U7wqaLbunUkyGm279Hyjypn2gULqJzbDsJHhyyksb+gcv0/uuq/GBoDxXv2yBef08efJosTGSilStPsLKXrCcAo8/wEJesVbsm3kapSywOcZRe9CrrvaLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YG5744UtzRrKKq7Zaqa79DMygwSS8PQEHsQz4/qpuaU=;
 b=MReR/pr9lZ0cQEZrt2NAckTfVqbOJ24xcidX8IX+4dm+YQQiPj/EaTIxY+Q5faG1iUKG/p6OpcvwiSR63si+sy8JU0ULoyfrFxj8CLvgcPgWwR1mZ8xOdmvdfHY07peihSCcjhu/cr+MyCvNBx61b3eyIT9wJ4LxGdaiZoWsqpzpf8YKakydDN3FDtZ8FAfdkBJBaEfsVPEKBqAFjhsCdE1L71OKbzP7d1lG+f/zpQr5KhJDgYwnwhJD74w3WR2LqWzK9oEhUnImNen8M2E62LvWmt+IMPIGNZ8U8A2g/geQ8+C9HSg75BbnJt0EHwVupDYjyL9zLfQeGlWG4DrGdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YG5744UtzRrKKq7Zaqa79DMygwSS8PQEHsQz4/qpuaU=;
 b=R6/4xZmHJc/owLVivs9fbVG2stCJnaeRlULZDytvy5VHXdFepL5XXqB59Ou5UHzfseilsy7rlBKq5nUucw1NP4xRK8Epwo3kVsk+I2gsRHBjku1JGYbY2R/sgwjgWvDERmf1CQ8rvPsbbZOug+pU7BOMj0MMeBcWFxhEWg4cHXs=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by BLAPR13MB4610.namprd13.prod.outlook.com (2603:10b6:208:306::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:47:10 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::d23a:123:3111:e459]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::d23a:123:3111:e459%5]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 18:47:09 +0000
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
Subject: Re: [RFC PATCH] iov_iter: Add an iterator-of-iterators
Thread-Topic: [RFC PATCH] iov_iter: Add an iterator-of-iterators
Thread-Index: AQHZXOpZqMZ5cQQWc0+LGrWKGRAzsa8HI4mA
Date:   Wed, 22 Mar 2023 18:47:09 +0000
Message-ID: <438D8115-68AE-47C6-B942-485814B77416@hammerspace.com>
References: <9C741BDB-31B0-460C-8FE7-F1C9B49002D5@hammerspace.com>
 <8F8B62FD-0F16-4383-BB34-97E850DAA7AF@hammerspace.com>
 <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
 <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-28-dhowells@redhat.com>
 <754534.1678983891@warthog.procyon.org.uk>
 <809995.1678990010@warthog.procyon.org.uk>
 <3416400.1679508945@warthog.procyon.org.uk>
In-Reply-To: <3416400.1679508945@warthog.procyon.org.uk>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR13MB5084:EE_|BLAPR13MB4610:EE_
x-ms-office365-filtering-correlation-id: 11d82513-ee7a-4745-bc40-08db2b05d7c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ikQ3z6x9W4SbcJTg0VK7md25jVfOqWtNnrm/nb3Xn6vWaGlCLz396fQ8PkyAt89Ag0DKZ0r8j6JIuGSNbEmt5o6g2vZSyn0LRlzqJOgJEc2cIy47vEIRejSAg2dqtdWi1QYo5H4Q5Fb9e9MBNJ9oZBd6DztqQ2XCcoUqzF+TYlAPFMhFAvHFKWLwEU5N3IGdIn2IDaSkL3M5dr75UOujR6h1OwuGZk4kwDPok5mbZGyRjy6n8VWZ3ZOAYN4xu3hhc6vXaMM2fPx+HZIG5mocP1MswhEI/JIblQzaA8Lko1iw7lq9WEfeb/NO9ugYrn7/Uwd47+/aSL0CqgYoVWczjRG6iacZMwYp1ekRoEa/hs81lOlZ7dTugBV6/NyOp5J4mBrIaQhG/vPgtpTH2rFwwUI5iqqLSQ4Rj9TmpbAHTDXEotobIm+JOgzTXT/9vzuc/runF2xDGBm4xJS72tIqSoWN1N1pxKiL8pk26xP0J8U4qQDk8NxRLS7Cde7NiOwrm7WnES/SwYFW7ZM9dipGG5UQkWrnDltlcoowe4Rcry7WqkM4S7R17UL/7RuetY0m23MHJMOuF18FMbLvWe1gKiJqYtjcA++onT9MWXf2+g84fWSis5KzUwLy+m1tI/M7qllme4DzrARJvkYrc5bdWDhVCVqlhQ1/iiqmihLrdoE5TCHjMBGpeK4sp65QMvmnNzlDiwFsDMXQVk8CmU7M965XLZ3luaKVFqKOaO/ytpFKM9AHj7DBfUATDhscsfjDRXaUi/us9re/6Ol0Xtr2Vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(346002)(39840400004)(366004)(451199018)(38100700002)(71200400001)(66946007)(4744005)(8676002)(66476007)(64756008)(33656002)(316002)(54906003)(36756003)(4326008)(66556008)(76116006)(8936002)(6916009)(41300700001)(66446008)(5660300002)(7416002)(2906002)(478600001)(122000001)(86362001)(2616005)(6506007)(186003)(38070700005)(53546011)(6512007)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Sau/7v9a5tbEX8S0+rcuqXIX/sQ8juZT9lmC6M4F85apXD3OVVC7oxdCXdX2?=
 =?us-ascii?Q?S90tC9DCCLcROA7dmc/fd3mI+yx7+y5BuwkQpy+Jtf4j5KdhiqvOYwcgZegn?=
 =?us-ascii?Q?A3e+PSWovI5QOMmyOQEUQxIF8jkryXstdx89l/IEaXDrSxLxNisIa2aA6TNR?=
 =?us-ascii?Q?7sbFcrWDMdpFJPK2NBBBgBG8mL5CSI/us0Ujre18UWaDkw4RExjjR+1cD8NW?=
 =?us-ascii?Q?hVPwHIaN+qJktLJ4/APffvMBpj57HQXqetGvR0S4ql6lnLYbOk/AaxkdwkIW?=
 =?us-ascii?Q?Kofw9cBuCfuptEXk5Lpa/y6LyvGUT1LC+VtCg5HD5dzpuFle3EDt0yUBs9gp?=
 =?us-ascii?Q?PoL2XZ+IcSd1qc/2fwLgjqWnokYa2Hog8X91Tq5nrucZmoOobf5lPkHHXEoV?=
 =?us-ascii?Q?ZpZn2SAlrZRjXlMNI5nxvGrREHjT27bqn0jlQUc3eB7XUOOQZsSHW5OOmBSV?=
 =?us-ascii?Q?h0JIEkB7MmfaqCFXIo0ul81/Jp5+Iuw/yp/xrQhKnnJBymgT0g6A4Gyfj+eN?=
 =?us-ascii?Q?5STa8zywTPp67QPbpa3lJ75nl9J+LtDRpXaegoXTGxGWW+/EdB5HBQEUrKe9?=
 =?us-ascii?Q?FzEuFL0nDW18X6yAak5Wz9vkS8u1wQX1jz5btu33q95qweVKXoqn6xrgZJCG?=
 =?us-ascii?Q?yvRmOEsUS27zTS/vArmXYDaVUze2cxjlVcO1b0LaAgp0SlVKRhkaRc5Oka2G?=
 =?us-ascii?Q?SwW2qXJumvbLRqHJTsJT1Gh7kzdm4ILnw4zZK4zHW6y55Wr4AJA0h4AjzzKJ?=
 =?us-ascii?Q?nMeZSAf9/j5sl9CZrDQeDXVsfadwUECl2TU5UyGw+0Nf8TuZCAbbDfDx8/kT?=
 =?us-ascii?Q?QvaAASpclDNY3Fwj28wzIrrNrddhs4eK/rJ26J5TMaWgJFC0YsjyezK4rSKr?=
 =?us-ascii?Q?Bv39iXH8Cd/Ixp5T+Dti1a+aBBeu+nSO8DyFH6XFCYch0QAT418w0Z81eojz?=
 =?us-ascii?Q?7w0bS+I+MJD3rY9jxWcEMtojA4FITkN+XkmB14Th17ieD+ppL9betUNEAMgB?=
 =?us-ascii?Q?jYfNFEvhq7slGXhy48T8WvYVQAFpkLPt2HnkxdmYQLCAHu6HCLzXiWf5zN9M?=
 =?us-ascii?Q?uXPMP4uHFYExY2RyA4t0f7Qr1ifXk0Uslb2Waz5BuAStEfXyrya92ydnqaYq?=
 =?us-ascii?Q?/SmS+YsiQwKkZ7qPO2es9r4ozYCvIafzZtUD5gOsuQeYKJ/g1hmWbfjFL7V+?=
 =?us-ascii?Q?GJbAdV+/Ox5yUmYE415E4GcfP3G3YsKyo2j0bBXUIcPVBtXNcAr1xusjqBN3?=
 =?us-ascii?Q?jiR989JVnJlNl60EdIbU+V8U9UoMb76bgvaXoEXDRcHOPLtRa7qliaQ/OJ4s?=
 =?us-ascii?Q?EdFwTJHAQbPagepWMRdbjoMKK+j6F9axDX2izqaNTovtotdDxr6iGIPCpfdj?=
 =?us-ascii?Q?iZ7oOVu3y+CfVi5EazWwPhpFi4HKgP7OdGYKkgR9ONf7YWF0ee1vTSpnQJGW?=
 =?us-ascii?Q?WreFSDnEUXJPuWeBSc4BmvNtaruM+KX34oKkuSTRjr3YEVZKPMe4K3VPQziE?=
 =?us-ascii?Q?/scAV6gYNuhIsCi7mCz9sTFzS6qFNVc9sS1icERua8nnPYwxvDccp01BbjjN?=
 =?us-ascii?Q?9nKB4ITzWoMB0FwUWx26Lbn0jOK3VjGvBjwqfJig4c2MCKqlX1D2qSnIGE2W?=
 =?us-ascii?Q?XkoerbcCLK/9R+BqLufqiJY3fYRvWVbhsoFYphLGccKUTf/wzOGOzfsJxmja?=
 =?us-ascii?Q?M3e8xQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6379EBE9A8BDA54E97A1E7F53F97313E@namprd13.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d82513-ee7a-4745-bc40-08db2b05d7c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 18:47:09.8054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xuioWdasXjJngL5UsVGhGvMgrDY6c5UNkN8xJd2f0LJXqZ/uoJ35m55ax0O4xCVGxUvz7I2LYhEQGVR63qL9jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4610
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 22, 2023, at 14:15, David Howells <dhowells@redhat.com> wrote:
>=20
> Trond Myklebust <trondmy@hammerspace.com> wrote:
>=20
>> Add an enum iter_type for ITER_ITER ? :-)
>=20
> Well, you asked for it...  It's actually fairly straightforward once
> ITER_PIPE is removed.
>=20
> ---
> iov_iter: Add an iterator-of-iterators
>=20
> Provide an I/O iterator that takes an array of iterators and iterates ove=
r
> them in turn.  Then make the sunrpc service code (and thus nfsd) use it.
>=20
> In this particular instance, the svc_tcp_sendmsg() sets up an array of
> three iterators: once for the marker+header, one for the body and one
> optional one for the tail, then sets msg_iter to be an
> iterator-of-iterators across them.

Cool! This is something that can be used on the receive side as well, so ve=
ry useful. I can imagine it might also open up a few more use cases for ITE=
R_XARRAY.

Thanks!
  Trond

_________________________________
Trond Myklebust
Linux NFS client maintainer, Hammerspace
trond.myklebust@hammerspace.com

