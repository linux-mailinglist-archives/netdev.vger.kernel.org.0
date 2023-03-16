Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017176BD561
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCPQSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjCPQSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:18:42 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2113.outbound.protection.outlook.com [40.107.102.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B900D5149;
        Thu, 16 Mar 2023 09:18:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBm+sdf0hlkVMcCv8SxBN1fQWGqh8vjhSuqM4Wt4Yt5SS2gQwdoriOOZ0k2Vy+V6xNZ9YI+qvP3qIjKNZJOH53gFGWt24sTUyY12IbBbEujZczIhXKlwZVZaB27363R7A4ynljO5993AxmJB62CalRtbo/NReB/2qZUGvunvNpJMV702IQHdAGavAnnyMuHmsN1qQx20tvZrwEYL3UenPFJKG/R9hdNqUGVy2vZU20q4f89OJBm+Nel7Zx5T4WRIPU9J4UYAaehpNoxXMgCleIv7NvTQjsGeBn7urWrRCz9fm6+8LgysAJjK77bQBjB4uMgniM4WtRW58blQ9iUlBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGwUUNnxLD0kMpp4Z7BtmsgQGiUVAECTJnBHNlGdVno=;
 b=Noxtjo2p+wHCwY/SLfJYl2sssTtpT2DZYCWSe0nX7AeJTXcZ7tBqoh5uorF3mSjMHBkudc6FyhxEIDzrPj25jJVq2Y3lQWCiLd+uqjLb4tZ4t0XtdVHOP3SmJbvugSdM58nXmf9tWrDN0EP7/gorF+hZ2iTmMGm+Q6GRSGBqGZojLBA2CT9jYlJTdjU37Spix5K0IaKXqXQAMwHczu5YVHmP7rlw6gw0amLEXr4/f/+ZIFJv4MElu0cQMw5gsU2zbuoQshSJ002Nb7fQdfv3TZNDFDmj7D5945Cg3Ld7DCpvzYi1KaNYO4yJHHI2Z+kMbWxwOLqQdeJ12d/km81drg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGwUUNnxLD0kMpp4Z7BtmsgQGiUVAECTJnBHNlGdVno=;
 b=Eavt3d0Nymv3iYf8j4oDl2rhomwrzXjwcly3TAqxPZoXvYcZ/nOFHQGtF7IxJlBrXeZ0m5XT4T1/Am72zTz8k0A8qY29w0svx6HXeMAeXJVU6STlMikmlmUfERNXp4HiJnIcxPTSnaRPgNeViK5se/XB9YVAtrAnQ5WrPk6fj8U=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by DM6PR13MB4462.namprd13.prod.outlook.com (2603:10b6:5:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 16:17:53 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::d23a:123:3111:e459]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::d23a:123:3111:e459%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:17:53 +0000
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
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Charles Edward Lever <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Topic: [RFC PATCH 27/28] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Index: AQHZWBvarYtr7Kf76ku/+p4ZPGQrUa79lXMA
Date:   Thu, 16 Mar 2023 16:17:52 +0000
Message-ID: <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
References: <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-28-dhowells@redhat.com>
In-Reply-To: <20230316152618.711970-28-dhowells@redhat.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR13MB5084:EE_|DM6PR13MB4462:EE_
x-ms-office365-filtering-correlation-id: dfe0e1cf-fece-45b8-e54c-08db2639fe7f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i4i4dVZficWuaeK5xDLVohq95/Og+ztcmH+Fx0LjBpLX1KbVeYcaHSknDM5Ar1XgYEShTU/+OGQpAnZDhIXjTjtYQwo5Ya1YDLur0zlnm+3Wmd0zQm9K0AAxDJ2Kd9teFb1lhLVsGO0JbxbXtBm0eAcVsd0DV+eXbs/2RAqnt5JxOsaXlNqzXYtdTLOH4MT1V0jhRuvEexHpBpjE92o5AqHUuvH9+2nwB371hIJuZCmNrMEDJv34UbiGpSTN/ElEkj8Ru65HUbgyrHij2KEFhPrbqz7c1/ZH0CLLcvdmQtH5QhubVdjcpl5mFCY+MNsrsHMiQOaKHHKBkjg3UOKHvET3X6N3mwJG7CluQTqehf48arBUEkJcDGpQud0P2c7cmMNvfDEw1vbE0oosa4ZbDVFkV39v7psAA6K8y9Zu6j6Aeqhv3dzHmmSAjLIiNbTrkq40wFLxHKo96lA3ehlBhymykOKeg5vYdEVI60cXO1clj7uKKers0HwlrPlaZDa79sFBj+2LvX8HZEAQSFFQVP5rYGra3C/FO+hOAkHLOmk97dow9/JjB8woxpicOl6OpcUQoNP3jOVi3fUXQZz9Zl26YTG8ytL+r7GivXFpTM9HdzVzjhwlxm2yTJZ/7+jYUgRklBeSm002+JJkD8qFekbgUUWX5+DR/URJ/v6nol36WIvvA8ULgt3fwvcB9EYQGZWSzYPqsMe9Dyi6A9h/v2Sup+/FY7EWPWxxkAd8spg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199018)(6512007)(2616005)(53546011)(6506007)(6486002)(316002)(71200400001)(54906003)(186003)(6916009)(478600001)(76116006)(66946007)(66476007)(64756008)(8676002)(4326008)(66556008)(66446008)(83380400001)(5660300002)(7416002)(41300700001)(8936002)(2906002)(38100700002)(122000001)(38070700005)(86362001)(33656002)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tedsX186PCtiaiJ7Xh4A21LR67/rJcXbc64S/VrdWiY0qFzGXA1JTjrClntq?=
 =?us-ascii?Q?dON06NFiW4eSHYsm8SERUI2d1glGzKpM7DgaHXDCFX2h4OKSTTp2Bv/Kbn/W?=
 =?us-ascii?Q?R1ilhhXqUnvZTF60ZOhf1rb6u9JpBkQ1a6FIyIieW2CO2V3whUYWYB80KziE?=
 =?us-ascii?Q?E+VsCNunagKApDnp4tU0ZnDkzHB58IsPnG7DmjCAzin/djrPAB0sWS/i5QxD?=
 =?us-ascii?Q?vuSe8h0s3/Xwaz8yOff8H/RKtSGhEEa3QrwL55XPlbUam0OUmzFOHwEKZa09?=
 =?us-ascii?Q?qSBxMAggsX7B7tKXIlCGFUGm9vr6FZlA8u8XnQNvYECyQpPnW5xdYla1NTNQ?=
 =?us-ascii?Q?ok/RWhg6fl28OBhBmRIWKO2yLaZ3ItD7ia/vIwctNNd+sqjZUY00GUce/Tg2?=
 =?us-ascii?Q?BORqgYlId08XEM9IvOBXWWk2IQoOcRvlDwF3KuruwDJIISkPj3g2FbP9xHGP?=
 =?us-ascii?Q?d1KrRTLHNZavsVnSf4ytL+C98ZzBAljgu5hIJ3qdl3m3zdvr7rSUBf6yZU0L?=
 =?us-ascii?Q?Ij8M+kglIPBXVDoljUnYzO0B3wP5/i+7RjFFBiUBd3a8r0vZuVdVaNzly4MO?=
 =?us-ascii?Q?3APgnwNfsbfs1dX3QvvCOtVrmjyYtYTA4AhodIV+QhkB4SIZOlMlGZvmToc/?=
 =?us-ascii?Q?mPe4nC0UIXGTDhrUbAO7NJGGkZ7nTfD5zz+VwtwMBpCSr4RA27M+HjhUAHZ8?=
 =?us-ascii?Q?jzy4F8G1qKL16T4kuoDIery2K/lmIT32Nj74+9ualSo35Ky61yoIdtgGu4ys?=
 =?us-ascii?Q?Zwa3Nwk6m1jq+13sK7Je2StBXnlO/DL/BWgedqzE0sPhkTi4Kz7skk5h0YZa?=
 =?us-ascii?Q?GtHc3civL2TsL9TBD4voqFbpRhBHKG3Sd19Dwt6yPk13X3nXmp6G/L+YpwJ8?=
 =?us-ascii?Q?79X4IrMKpraNA1S3CVI4JJdYIOjVPj0RtEYhByWrw1eIilE1oWfFJU24hUcS?=
 =?us-ascii?Q?Eq7kMIoP9aiV5LtniX+Y33qvW/nN8MRVYSNroklLRWamAm3bC1FZ9/2tr0Fj?=
 =?us-ascii?Q?E3pFbJCkwlie9Bxq857Uv3CETNi69zEsegPZVuvWnMN5YyuS3zvovXRIiWOd?=
 =?us-ascii?Q?cMjNm9f+xYyYBvGbT1d5RVBEST9zR6Y7yMChbQeS5805vnElrltHXuKNQ+VI?=
 =?us-ascii?Q?86WpvNtp5O95SIo5gJBdNF8bwIedNZCSNLp9dni3p54RDESNl0bcKePU8LeT?=
 =?us-ascii?Q?WxpgY807at3JgAUNKGQAdbP5Edbjjzh5RgHrlNotY6aJ6hmwcuu2s8xU8+Mj?=
 =?us-ascii?Q?xUeP3p+0FU6O8ZG1PqNSglU3YxBysGBf2DKzT9hd1pmLGM79xPm68AWHCl9f?=
 =?us-ascii?Q?DdgibIW47vCy1aoxo1m3yFXu8qNxtqWAKZgLrZHJw2ag/gzIu0bmnntNs/2W?=
 =?us-ascii?Q?cmo9BxYVjO/uOQnSE1qpi9X32g9w1o5HIWo4luGiiq4UHWdU+/wATqn7H3BV?=
 =?us-ascii?Q?UkDvj9katifPgvRLIi7URnHGjuMbVdhNcRwgfVbHfbVU/ll/6HoSk7Begj73?=
 =?us-ascii?Q?DU+qDZt0jGi19UVEaIOrwApafe7V7DhaW2jxm3xB+y4oAxu7xDpQVxaGGQkQ?=
 =?us-ascii?Q?kcuHgYMNUZvFSBVTk9GwrR83IAhkmy5JCFsy9IwC+F+4wfQBPJDMC3w+Cu4D?=
 =?us-ascii?Q?q61tk17ncBVjKuAW8mbq5MfHyOwNbNgARSQHllwiBw4ldKOCGHyw9bDGnXUg?=
 =?us-ascii?Q?/tMVww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5044B28D329F5E4880366674D36245FC@namprd13.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe0e1cf-fece-45b8-e54c-08db2639fe7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 16:17:52.7531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0P21MtEEBcnGgdwh141J+MtCZBaQEbkZ0tF0X9X5nrWXLxt8HtQcOhWe8ZoryDucMzHPLbfNZ/OoP5DoNpqzSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 16, 2023, at 11:26, David Howells <dhowells@redhat.com> wrote:
>=20
> When transmitting data, call down into TCP using a single sendmsg with
> MSG_SPLICE_PAGES to indicate that content should be spliced rather than
> performing several sendmsg and sendpage calls to transmit header, data
> pages and trailer.
>=20
> To make this work, the data is assembled in a bio_vec array and attached =
to
> a BVEC-type iterator.  The bio_vec array has two extra slots before the
> first for headers and one after the last for a trailer.  The headers and
> trailer are copied into memory acquired from zcopy_alloc() which just
> breaks a page up into small pieces that can be freed with put_page().
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> cc: Anna Schumaker <anna@kernel.org>
> cc: Chuck Lever <chuck.lever@oracle.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-nfs@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
> net/sunrpc/svcsock.c | 70 ++++++++++++--------------------------------
> net/sunrpc/xdr.c     | 24 ++++++++++++---
> 2 files changed, 38 insertions(+), 56 deletions(-)
>=20
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 03a4f5615086..1fa41ddbc40e 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -36,6 +36,7 @@
> #include <linux/skbuff.h>
> #include <linux/file.h>
> #include <linux/freezer.h>
> +#include <linux/zcopy_alloc.h>
> #include <net/sock.h>
> #include <net/checksum.h>
> #include <net/ip.h>
> @@ -1060,16 +1061,8 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp=
)
> return 0; /* record not complete */
> }
>=20
> -static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec=
,
> -      int flags)
> -{
> - return kernel_sendpage(sock, virt_to_page(vec->iov_base),
> -       offset_in_page(vec->iov_base),
> -       vec->iov_len, flags);
> -}
> -
> /*
> - * kernel_sendpage() is used exclusively to reduce the number of
> + * MSG_SPLICE_PAGES is used exclusively to reduce the number of
>  * copy operations in this path. Therefore the caller must ensure
>  * that the pages backing @xdr are unchanging.
>  *
> @@ -1081,65 +1074,38 @@ static int svc_tcp_sendmsg(struct socket *sock, s=
truct xdr_buf *xdr,
> {
> const struct kvec *head =3D xdr->head;
> const struct kvec *tail =3D xdr->tail;
> - struct kvec rm =3D {
> - .iov_base =3D &marker,
> - .iov_len =3D sizeof(marker),
> - };
> struct msghdr msg =3D {
> - .msg_flags =3D 0,
> + .msg_flags =3D MSG_SPLICE_PAGES,
> };
> - int ret;
> + int ret, n =3D xdr_buf_pagecount(xdr), size;
>=20
> *sentp =3D 0;
> ret =3D xdr_alloc_bvec(xdr, GFP_KERNEL);
> if (ret < 0)
> return ret;
>=20
> - ret =3D kernel_sendmsg(sock, &msg, &rm, 1, rm.iov_len);
> + ret =3D zcopy_memdup(sizeof(marker), &marker, &xdr->bvec[-2], GFP_KERNE=
L);
> if (ret < 0)
> return ret;
> - *sentp +=3D ret;
> - if (ret !=3D rm.iov_len)
> - return -EAGAIN;
>=20
> - ret =3D svc_tcp_send_kvec(sock, head, 0);
> + ret =3D zcopy_memdup(head->iov_len, head->iov_base, &xdr->bvec[-1], GFP=
_KERNEL);
> if (ret < 0)
> return ret;
> - *sentp +=3D ret;
> - if (ret !=3D head->iov_len)
> - goto out;
>=20
> - if (xdr->page_len) {
> - unsigned int offset, len, remaining;
> - struct bio_vec *bvec;
> -
> - bvec =3D xdr->bvec + (xdr->page_base >> PAGE_SHIFT);
> - offset =3D offset_in_page(xdr->page_base);
> - remaining =3D xdr->page_len;
> - while (remaining > 0) {
> - len =3D min(remaining, bvec->bv_len - offset);
> - ret =3D kernel_sendpage(sock, bvec->bv_page,
> -      bvec->bv_offset + offset,
> -      len, 0);
> - if (ret < 0)
> - return ret;
> - *sentp +=3D ret;
> - if (ret !=3D len)
> - goto out;
> - remaining -=3D len;
> - offset =3D 0;
> - bvec++;
> - }
> - }
> + ret =3D zcopy_memdup(tail->iov_len, tail->iov_base, &xdr->bvec[n], GFP_=
KERNEL);
> + if (ret < 0)
> + return ret;
>=20
> - if (tail->iov_len) {
> - ret =3D svc_tcp_send_kvec(sock, tail, 0);
> - if (ret < 0)
> - return ret;
> - *sentp +=3D ret;
> - }
> + size =3D sizeof(marker) + head->iov_len + xdr->page_len + tail->iov_len=
;
> + iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec - 2, n + 3, size);
>=20
> -out:
> + ret =3D sock_sendmsg(sock, &msg);
> + if (ret < 0)
> + return ret;
> + if (ret > 0)
> + *sentp =3D ret;
> + if (ret !=3D size)
> + return -EAGAIN;
> return 0;
> }
>=20
> diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
> index 36835b2f5446..6dff0b4f17b8 100644
> --- a/net/sunrpc/xdr.c
> +++ b/net/sunrpc/xdr.c
> @@ -145,14 +145,19 @@ xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
> {
> size_t i, n =3D xdr_buf_pagecount(buf);
>=20
> - if (n !=3D 0 && buf->bvec =3D=3D NULL) {
> - buf->bvec =3D kmalloc_array(n, sizeof(buf->bvec[0]), gfp);
> + if (buf->bvec =3D=3D NULL) {
> + /* Allow for two headers and a trailer to be attached */
> + buf->bvec =3D kmalloc_array(n + 3, sizeof(buf->bvec[0]), gfp);
> if (!buf->bvec)
> return -ENOMEM;
> + buf->bvec +=3D 2;
> + buf->bvec[-2].bv_page =3D NULL;
> + buf->bvec[-1].bv_page =3D NULL;

NACK.

> for (i =3D 0; i < n; i++) {
> bvec_set_page(&buf->bvec[i], buf->pages[i], PAGE_SIZE,
>      0);
> }
> + buf->bvec[n].bv_page =3D NULL;
> }
> return 0;
> }
> @@ -160,8 +165,19 @@ xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
> void
> xdr_free_bvec(struct xdr_buf *buf)
> {
> - kfree(buf->bvec);
> - buf->bvec =3D NULL;
> + if (buf->bvec) {
> + size_t n =3D xdr_buf_pagecount(buf);
> +
> + if (buf->bvec[-2].bv_page)
> + put_page(buf->bvec[-2].bv_page);
> + if (buf->bvec[-1].bv_page)
> + put_page(buf->bvec[-1].bv_page);
> + if (buf->bvec[n].bv_page)
> + put_page(buf->bvec[n].bv_page);
> + buf->bvec -=3D 2;
> + kfree(buf->bvec);
> + buf->bvec =3D NULL;
> + }
> }
>=20
> /**
>=20

