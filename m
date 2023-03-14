Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5BC6B9FC1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 20:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCNT3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 15:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCNT3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 15:29:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2139.outbound.protection.outlook.com [40.107.223.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C371D325;
        Tue, 14 Mar 2023 12:29:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJ4RneXrFgjSft3dTYczMeh9EymOeilMAADfzcnWT5ancjm1+PrarJSMLGbpJOAydAUFW8HtiMBcoCI5p4cDWIjQbMZ8yTw4eL+BZuViCwLPHeDTAc4xZZpk53HH5CKhlol7Mw8ATkjrPdj1jkJ6KRLIyCivZeeQhpQ4g0YP86oRsjipFJp6A+WoBjgpC3bHeee6E6UF9qqS8x/3z9mCbO/xUcu53YBiunQHeeOoBdvn5Fy5RrtGgOzyzGQ2o38oREh8RmzqXQ/iRQsM482kSNBD80ZN2Zj/d6RMI+F61ycsTrwMvGTmz9AmJ1a/dHzBTMKZHZgq705I/taYBDa5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GSb4Gl/VSK4yKRYFSrs8pXuSBMWN9VmhfaedPuiE5u4=;
 b=OsHbGXjvWEfX4wdw7IsZHLnM8DImKm1EvCxaGs1Qa4HokV3os7WHddbcPKhEeYSQtyVTcZnG4IlgLiES0H5v8CVL44Y8MfzF5D2Dkt+UdxAiAk3mgjnBHht/zvcYH0flF7nLtUJ99P2erVf7KEzAniNqXLaQnvctV7nuJQ1nXHtMVpVbrY+/CtD/FxDg4+2q2d7fxhmti9rtXIhHTpcEzdRnVMAIXUj7p+4ycTDtDLM/UmzB8ONRbiMaWNJDNKoNSZopMXyb7EhM8dz56hbGTMH1n9s37KbW5bsvCNPuiH4lCeyvWZWHbySsGleTAFTKxfNzKg3sDHkLb0ca7cTq/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GSb4Gl/VSK4yKRYFSrs8pXuSBMWN9VmhfaedPuiE5u4=;
 b=KdW0ZmVPmYWW/qmxyzCBIrAosvUivzB00n9L+ol1WSy0wb+VU9Km11945exyM/KcSO0kj0HPIbwubbkjBDCgPEFdEK6uV6Lm1FnwDRcqaHmVa2GKvohmw5Hwtb387QhlMGHw72i/wKEMHhEF0GiV8jgOKxzw/hlNCCpFrQSkcDE=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by SJ0PR13MB5676.namprd13.prod.outlook.com (2603:10b6:a03:403::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 19:29:14 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::d23a:123:3111:e459]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::d23a:123:3111:e459%6]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 19:29:13 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     Siddharth Kawar <Siddharth.Kawar@microsoft.com>
CC:     Anna Schumaker <anna.schumaker@netapp.com>,
        Bruce Fields <bfields@fieldses.org>,
        Charles Edward Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Bauer <Dave.Bauer@microsoft.com>
Subject: Re: [PATCH] SUNRPC: fix shutdown of NFS TCP client socket
Thread-Topic: [PATCH] SUNRPC: fix shutdown of NFS TCP client socket
Thread-Index: AQHZUeAZAxku0qbuG0Kqc9IzASs6vq76sreA
Date:   Tue, 14 Mar 2023 19:29:13 +0000
Message-ID: <116C9B6B-8990-4D85-8D9C-97764F9AA089@hammerspace.com>
References: <DM4PR21MB368002F6F7A9A0EB8D7CFC87FCB49@DM4PR21MB3680.namprd21.prod.outlook.com>
In-Reply-To: <DM4PR21MB368002F6F7A9A0EB8D7CFC87FCB49@DM4PR21MB3680.namprd21.prod.outlook.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR13MB5084:EE_|SJ0PR13MB5676:EE_
x-ms-office365-filtering-correlation-id: 5fb5d24a-f0a2-45df-39e5-08db24c264f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KZAHYYt7qA8yR04+Ft2bzlVJ73+QLoWt+rDmklX6j01CEiKB3P9FnT7OesqgM7eDPZ33QAbF4fl6Bkn40Asl5dmModMa4tiwg3uzL4oPfygrahdEeQS8FUuNAdm2vsMOW7Pb9AXKrn9PveFbtSlc182EuG+0m4QtLiROMqXQ9CSC6hEiaYX5d4U3ZwZpkVbhLpPIt0f1nPxdkLMfFkiB9WHHhk7H0YJI+zvbnh+p8J0njDFpGaLyEc947KHguZA6hR+w+KyNPNpGbitwXrpyc0aM0+9dme4uVTvo9Uk0aPDOqDrHIX/aNRtTzY+ZyJxQ8DNPhkapoUKrB0Xd/BLuqjvhfk7t/hbDeqxGVHq0QRb5G1owazhKRX/MYdY2RMbntzOl/+an86h8Jzku3McXdZzSp+1tI0MrMe+h4eaKAAkyBhJDpSRvisFS4+omJhnXq15dr9XefNBefeWtUxpzk0alzI03S5xgXln+jgrOeR/NhgQWUpTumy8iOv88HoQFYZ12otQxJUAkU7JibxvDjdZqif+Bf8mdjgkXRfL4dcCz1l1UNLsHqfoCo73/l5kJO4H1CooJCaI+8g5H1jo5ilbMhW+74it3pDhehdtYgkVognpr4zi//J1EPlU3UzrY+AMu+3Q/rYJ2efVaIuM8sj5cn9p8LfodXeHS5J/s5js+2ZlQ8YzZ2y5hhLysxTf8r6PKmMUClKg8DfQHlrcifara9vXLerInHQM/N5JiYlT5545hJbEEgBcNNFmGbGH5YLobwAG10c1jaG6POZPinQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39840400004)(346002)(396003)(376002)(136003)(451199018)(2906002)(122000001)(83380400001)(7416002)(5660300002)(36756003)(8936002)(66476007)(66446008)(64756008)(41300700001)(6916009)(66946007)(76116006)(8676002)(4326008)(38100700002)(33656002)(86362001)(54906003)(316002)(38070700005)(478600001)(66556008)(186003)(45080400002)(53546011)(2616005)(26005)(6512007)(71200400001)(966005)(6506007)(6486002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kTxIKhe1mbUSrxsCCEM7/4yuqALspcBsBi+enpg8mCqN4EVD5Hlsbb0e8W3k?=
 =?us-ascii?Q?/L/V9gFBmYfQIjr9uBpsehYy/Jll5jOz5fTUygF9wm3ZWAvDATIAjgiVnIj8?=
 =?us-ascii?Q?50cqmwSUcNYQ1wLr+a7697f5aaEHqoF2e1vnGXGN3mB6vIZgjAOBEGEteXUW?=
 =?us-ascii?Q?Dgm/euf0ut2h0RFR3PZRnScQ/XWaZlq5VkCK82AabfzFwrAjlqF9PQbAjADH?=
 =?us-ascii?Q?OXhZtYKl88wt21Be5+lrQGGDTauWkYHB47a+CZX/s8eh6dDELAfP1fFnJrVJ?=
 =?us-ascii?Q?Lk2fDr9yc7ipON7lzDFLVBsYuEjA43r6GcOGRn0v2PG1vKm6syr9irdKdwbB?=
 =?us-ascii?Q?L2HMK93H08fiE9ACygWXHzyHgNfWl0zTK+vhIhi2omd1mg/FebMAHmf3V/fx?=
 =?us-ascii?Q?QkWqI8UeyMPJlCX4H3/KBvMwxMDZ+UarKGVfdZPc7bE5ICr8cjifulCuKWFu?=
 =?us-ascii?Q?BIlDgw2fott9dOablZRArWPSl2ILmFtblk/oVkz+5IYMsV/Y9aFhNIZQDdgV?=
 =?us-ascii?Q?PHH+bwmWgKWc3hYSZrAyCJLi9UG3K6nUUNA0vpxhSnDROHB/BTzxmHkJXN15?=
 =?us-ascii?Q?2K6VDpnjS5aVAdc9YuuD+abxBWclnUN2SlH8Qsd193kD9zGzyMPFlfH1vHkl?=
 =?us-ascii?Q?G4f5eUyJTey911gKXHK6Yrf45/AdZteTaJ8+kS+mYfvfwu3cK+zfpmOpuLea?=
 =?us-ascii?Q?/Wr76vzeZXVpON/6N6ZhUI/1KyGoncD9e0PWVlzemeM4Li8AaJayw5z0tUVS?=
 =?us-ascii?Q?FTrYqh4aikf5CzwciqjxsiBQ3uNsxNSkmvC2XY0DD2ajQ+2QN/aVUCj7qmxV?=
 =?us-ascii?Q?yRqKm0MBNK09ivCGUPYYSLU6Wo9SB0sCj3DM6ZW6hBSbGu7z9qRavD6Zgk/N?=
 =?us-ascii?Q?XLQVbm+PePKIUJQe7vi4C2uljbo4c0Lg7w7zUT5MAPHyfhjFZFRDvFz5dun6?=
 =?us-ascii?Q?lKaXoBg7Ug6l3BHkTz83rAncGMvp6MaWtkgwj/ZfgTW7biYg6DJeQC9bwqJ7?=
 =?us-ascii?Q?hP26QTA0kYnzPGTxu/pZI2v+jxnANgfzE5c1SdSWyNx65L8OCrAcbllUQJ76?=
 =?us-ascii?Q?39UUIt11ieJJ1/sBfweBrV0ovAEePpbtdPCJQNq7kDO7R+xaf2KftBVHkTcX?=
 =?us-ascii?Q?SfGR7OpewZWxtPYF3RyMKC0szVfc5Zdj5b+YS5g284Cz+S7dzPnE4uUDh7i0?=
 =?us-ascii?Q?QR9eBZfkmP4FhIzodblJm2ExI2xN1BMq/8nXdfjOrSC2PcohYAmMnAxdycv5?=
 =?us-ascii?Q?ArGTAqtW59iXVU1BAbzP1U/7ezY1VZuj+yS9mBqaLLud50+eZu3wXHESnPNn?=
 =?us-ascii?Q?WEITiJoLJ2SvVT4Llmm0GYuwrlDmTumZHnIZGMZDW8jdS2EdLgXi+a7HMk4W?=
 =?us-ascii?Q?xJqDtH5hqgav0szhIOMYYIIYCrNquv9YASPT1rSL5Utq4gCABf727G3XejiS?=
 =?us-ascii?Q?bBeLFAWcMzQKqfkB6f7kVKSBPEU5hrllobMD1TPLW5gFp1OkyeUFHMGewrl/?=
 =?us-ascii?Q?ToFq4CM0we43Qjt/LgL5hftpqC+zxuPXGiIDUisIhjSLGg2FkdTOJrve2AxJ?=
 =?us-ascii?Q?+5r2K5yNeHBtLA5ujR4eEckGetzT3QvaJ9aav25P1hUE8ZTyjPkOdpD7dwlW?=
 =?us-ascii?Q?GA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <52C97299E578D34AA92F118700D9D650@namprd13.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb5d24a-f0a2-45df-39e5-08db24c264f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 19:29:13.8465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skJr/aYCl3CQAp5ZTSRi1d17UOjON83iRec2ydnRLHhATwuKqE4Z4c+kh5SRvv9YXCXtHetJkHqVFmVXtMgkaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5676
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 8, 2023, at 14:01, Siddharth Kawar <Siddharth.Kawar@microsoft.com>=
 wrote:
>=20
> [You don't often get email from siddharth.kawar@microsoft.com. Learn why =
this is important at https://aka.ms/LearnAboutSenderIdentification ]
>=20
> Subject: [PATCH] SUNRPC: fix shutdown of NFS TCP client socket
>=20
> NFS server Duplicate Request Cache (DRC) algorithms rely on NFS clients
> reconnecting using the same local TCP port. Unique NFS operations are
> identified by the per-TCP connection set of XIDs. This prevents file
> corruption when non-idempotent NFS operations are retried.
>=20
> Currently, NFS client TCP connections are using different local TCP ports
> when reconnecting to NFS servers.
>=20
> After an NFS server initiates shutdown of the TCP connection, the NFS
> client's TCP socket is set to NULL after the socket state has reached
> TCP_LAST_ACK(9). When reconnecting, the new socket attempts to reuse
> the same local port but fails with EADDRNOTAVAIL (99). This forces the
> socket to use a different local TCP port to reconnect to the remote NFS
> server.
>=20
> State Transition and Events:
> TCP_CLOSING(8)

No: TCP state =3D=3D 8 is TCP_CLOSE_WAIT

> TCP_LAST_ACK(9)
> connect(fail EADDRNOTAVAIL(99))
> TCP_CLOSE(7)
> bind on new port
> connect success
>=20
> dmesg excerpts showing reconnect switching from local port of 688 to 1014=
:
> [590701.200229] NFS: mkdir(0:61/560857152), testQ
> [590701.200231] NFS call  mkdir testQ
> [590701.200259] RPC:       xs_tcp_send_request(224) =3D 0
> [590751.883111] RPC:       xs_tcp_state_change client 0000000051f4e000...
> [590751.883146] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1
> [590751.883160] RPC:       xs_data_ready...
> [590751.883232] RPC:       xs_tcp_state_change client 0000000051f4e000...
> [590751.883235] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3
> [590751.883238] RPC:       xs_tcp_state_change client 0000000051f4e000...
> [590751.883239] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3
> [590751.883283] RPC:       xs_connect scheduled xprt 0000000051f4e000
> [590751.883314] RPC:       xs_bind 0.0.0.0:688: ok (0)
> [590751.883321] RPC:       worker connecting xprt 0000000051f4e000 via tc=
p
>                           to 10.101.1.30 (port 2049)
> [590751.883330] RPC:       0000000051f4e000 connect status 99 connected 0
>                           sock state 7
> [590751.883342] RPC:       xs_tcp_state_change client 0000000051f4e000...
> [590751.883343] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3
> [590751.883356] RPC:       xs_connect scheduled xprt 0000000051f4e000
> [590751.883383] RPC:       xs_bind 0.0.0.0:1014: ok (0)
> [590751.883388] RPC:       worker connecting xprt 0000000051f4e000 via tc=
p
>                           to 10.101.1.30 (port 2049)
> [590751.883420] RPC:       0000000051f4e000 connect status 115 connected =
0
>                           sock state 2
> ...
>=20
>=20
> State Transition and Events with patch applied:
> TCP_CLOSING(8)
> TCP_LAST_ACK(9)
> TCP_CLOSE(7)
> connect(reuse of port succeeds)
>=20
> dmesg excerpts showing reconnect on same port (936):
> [  257.139935] NFS: mkdir(0:59/560857152), testQ
> [  257.139937] NFS call  mkdir testQ
> ...
> [  307.822702] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1
> [  307.822714] RPC:       xs_data_ready...
> [  307.822817] RPC:       xs_tcp_state_change client 00000000ce702f14...
> [  307.822821] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3
> [  307.822825] RPC:       xs_tcp_state_change client 00000000ce702f14...
> [  307.822826] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3
> [  307.823606] RPC:       xs_tcp_state_change client 00000000ce702f14...
> [  307.823609] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3
> [  307.823629] RPC:       xs_tcp_state_change client 00000000ce702f14...
> [  307.823632] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3
> [  307.823676] RPC:       xs_connect scheduled xprt 00000000ce702f14
> [  307.823704] RPC:       xs_bind 0.0.0.0:936: ok (0)
> [  307.823709] RPC:       worker connecting xprt 00000000ce702f14 via tcp
>                          to 10.101.1.30 (port 2049)
> [  307.823748] RPC:       00000000ce702f14 connect status 115 connected 0
>                          sock state 2
> ...
> [  314.916193] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3
> [  314.916251] RPC:       xs_connect scheduled xprt 00000000ce702f14
> [  314.916282] RPC:       xs_bind 0.0.0.0:936: ok (0)
> [  314.916292] RPC:       worker connecting xprt 00000000ce702f14 via tcp
>                          to 10.101.1.30 (port 2049)
> [  314.916342] RPC:       00000000ce702f14 connect status 115 connected 0
>                          sock state 2
>=20
> Fixes: 7c81e6a9d75b (SUNRPC: Tweak TCP socket shutdown in the RPC client)
> Signed-off-by: Siddharth Rajendra Kawar <sikawar@microsoft.com>
> ---
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index d8ee06a9650a..e55e380bc10c 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -2094,6 +2094,7 @@ static void xs_tcp_shutdown(struct rpc_xprt *xprt)
>                break;
>        case TCP_ESTABLISHED:
>        case TCP_CLOSE_WAIT:
> +       case TCP_LAST_ACK:
>                kernel_sock_shutdown(sock, SHUT_RDWR);
>                trace_rpc_socket_shutdown(xprt, sock);
>                break;

The only way to transition from TCP_CLOSE_WAIT to TCP_LAST_ACK is by closin=
g the socket ( see https://www.ibm.com/docs/en/zos/2.1.0?topic=3DSSLTBW_2.1=
.0/com.ibm.zos.v2r1.halu101/constatus.html ), so closing it while in TCP_LA=
ST_ACK is redundant.


_________________________________
Trond Myklebust
Linux NFS client maintainer, Hammerspace
trond.myklebust@hammerspace.com

