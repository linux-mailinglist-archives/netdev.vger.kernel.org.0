Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801076C22FA
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjCTUi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjCTUim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:38:42 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832833755B;
        Mon, 20 Mar 2023 13:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJxzsI92qeVdCjzwtuzmeNXIX7PvdZ6skVQysCrjra+m4s0NxTLJEhMP5RUigzoKkV2wHsoNW9UXuA8uIGg6YopBR8k3lpRE7W7ItFqHkXVmdm4jpfcmG1lfUqGkvlUVjQd66NvGINcq45fwnuGk/umfD7QSzSFQfM4uWnZVC3pogRUlZAMbuj/icARnCTfZyPIS+KeY3hz01JnT+NSfdDW8+HtyF6TpER8ToIBm0BFk7EA8PgwY8Z50b1pM5JmJkA7pD7eOAa7rBCkZzsq8vlDS+EZl1CpomKusjFkaghbHvVyXlPvX/LIIEfx+OWT5kjWwB/Z7lpbykxamLrxQbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IgI6TvcD+ohO+dIhqH10EnYsbAlWjBAI1+KqVwHPpA4=;
 b=bRZMnRCrLU3d4wy43dPdIgYGvwebFLBPXvLT7iBXKaDrnUmhkF/h72hsli5ny2Q7k6N7/TPHqbkJXn5FCJMHYkgggFG6EiGZdLcun1afizZREhHRXw2YdpPyTkPqksPCjEOmlD9Vp9xgG/KQc+2N50iWVz6rYqUuZBz3+B+2YvLRKP+3n8ZoYBOcSvUQkw61oljDwzL2kgOVw2G3rgLOy5fL9SSgMUwb6tvNarjUOOvwG8layuKL9EGe5+8zFHkFccqu1Ev2o3BQmH19E1Fuo28HUBZcJNAsKsvrt4QE1fhdxgg5DWCqYNIEg1ueEaY3HVMySf3D3bKtG8/BbeearQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IgI6TvcD+ohO+dIhqH10EnYsbAlWjBAI1+KqVwHPpA4=;
 b=ge8HGRTmwkUhqHdFAqGLIBGhDt7TZbR4c2WwcENJCzYkaMD7ua4n9LMzNC+2FFkb4WSrCAtFgi2KTIpdKnoUXJ2sKSjusf8+x16fiRgifLyfzULNUZ4u0qUGKxk6qA5/oAm7WasaikWFMtyTnyy400jbxjkmeOHQh5DvBH5qzo0=
Received: from DM4PR21MB3680.namprd21.prod.outlook.com (2603:10b6:8:a1::17) by
 SA3PR21MB3932.namprd21.prod.outlook.com (2603:10b6:806:2f0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.1; Mon, 20 Mar
 2023 20:37:40 +0000
Received: from DM4PR21MB3680.namprd21.prod.outlook.com
 ([fe80::7490:33b7:44cd:8545]) by DM4PR21MB3680.namprd21.prod.outlook.com
 ([fe80::7490:33b7:44cd:8545%3]) with mapi id 15.20.6222.003; Mon, 20 Mar 2023
 20:37:40 +0000
From:   Siddharth Kawar <Siddharth.Kawar@microsoft.com>
To:     "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Dave Bauer <Dave.Bauer@microsoft.com>
Subject: [PATCH v2] SUNRPC: fix shutdown of NFS TCP client socket
Thread-Topic: [PATCH v2] SUNRPC: fix shutdown of NFS TCP client socket
Thread-Index: AQHZW2uCd5e2UcA4ekWBy1RsPlQxyA==
Date:   Mon, 20 Mar 2023 20:37:40 +0000
Message-ID: <DM4PR21MB3680BEC44A86AC7BB890A36AFC809@DM4PR21MB3680.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-20T20:37:31.288Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR21MB3680:EE_|SA3PR21MB3932:EE_
x-ms-office365-filtering-correlation-id: cbe449b1-c963-4f5d-2667-08db2982f303
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zy1J/c7P2uCxdsHgvZN8kiS9PiDHA1iCAlCiZ+rPuQH6kho41rYft7IwQ3GTaBpgQT2mKfJfYAq4pxunHgaD/eUUzOYYIe3aPSYE3xF0Dx99d9iKRg+KbqvYRZkM4xqKp7y7Xr6shvn0AFrx2gg7r74wlMYiHAXRt2AumP/GWsi8cCaIQvSZINlTYF/6hlxefpjQFvTaCMPzneGCA55Wjt1hXutZe/4wIivBbirJlJRDD5iSEZr+nwp5/PZ02s80eH88KYk9dVW1FTgL4eBs5vbecAXjPaXeX1Nf3Mkf6uYG7+oIb5qLBx+HQZz5VkYxXNHIZhKTXoJWedhrpy13PLY++n408n6dSSHmqFbIeHpiJxRbgkb9lgAKjZgFtlI6KL/5kGnMYmN2JNiBaeydePDQ4i2h8rqpt3wnDz6W1WCoas2uKNK3NTOpCHbWk9IYTcq231PrSTICXsvo9D7B9RnULVMey3jXx+uspj3DNpwMeO/kyvkgHYMjGFqfhk5O+voaBWp63xRTGnfnRZjy8Pu1VZ1KfDrYNTlkJLK/boEeYEmPwGaCvpiOya0Q31v3Fi2iO7/XYgTCj0qlkS//wLl2wp1pHkA86o3yFMHjiKWzoCPFF6vKiuu4PWfVprm9zYAlcP7WN2ckwP1CHaFiC7oge3mz9WUEd1oA9/FGaTmeJIMyXn124uBl+aWpiDNaIxSbHGFEBW2xmRklEgyVbTJ8Raq1Nh+XM66ISZlncvGyUEyoN5pQZUIc03I45Vnk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR21MB3680.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(451199018)(52536014)(8936002)(5660300002)(82950400001)(6506007)(9686003)(82960400001)(66556008)(107886003)(38100700002)(122000001)(83380400001)(186003)(316002)(86362001)(8676002)(91956017)(110136005)(76116006)(33656002)(66946007)(41300700001)(4326008)(55016003)(10290500003)(66476007)(7696005)(71200400001)(38070700005)(64756008)(478600001)(66446008)(8990500004)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?iGsrYs+vENIppFsEhe+Cd6B+eNxgJlndBUw/Qq8St/c5OHIlGvGa/Mfh6p?=
 =?iso-8859-1?Q?VZ+Zao/zkibroneMuU8F61Pp97bOORo+znZ47J63++QIa4x6VUKnrlnaFz?=
 =?iso-8859-1?Q?Z+Bf580sZrQYk+FIvdIrEhfUij9lkQLpe9wBYaKfEn7qygti2NtQcs9yr5?=
 =?iso-8859-1?Q?TqKAJVvyIS4PHNzTy1j4m4TRn3hPdvb+OMs4K6WYMhVvcIcLSB3w+Xxx/e?=
 =?iso-8859-1?Q?0W3V+QgQDPpApypp+9C5jlYk5gmP/RZHinTHE0YFvqemdEOdLBKrbC6jvh?=
 =?iso-8859-1?Q?txtmPBmYTC17t8qI/DBReTLUqMm/ZKI11ZkkiT8spTo043LfWtdJt2B9cQ?=
 =?iso-8859-1?Q?Fquhno61i4DKizRqevbIu7MAVjSTTsTs7DtT6SAazvBQkekArI828SYwBx?=
 =?iso-8859-1?Q?B0XKM06PaqwdqydBkbSYPJr0HRlXqcfl6VFuggvf8zeZTmcDfMQjicWRqd?=
 =?iso-8859-1?Q?b03UQtXS6gghQpokRT8V3nlU+T8ijly4Le7QEvAm7guJ88VB2q2KFsPoDl?=
 =?iso-8859-1?Q?2MkwX6fL81+OQipDZH6cRExtZ3PDBLy3HhoosoapVgk2MVSEIxh/FFoEsh?=
 =?iso-8859-1?Q?6Xf8a/Csn0VAzBMfaC4Kx4zVmS+Ffr2c+GkmwPcJSjLHZe9U1hXdY7OSyb?=
 =?iso-8859-1?Q?s5rlaGNrAJsRYIqLW2dLail6sZ8rRNc9lt9KW4vQbS3z2+VG9+Wy+BEL5m?=
 =?iso-8859-1?Q?MxkCkI/50LlX1RsumdFR4PkBROdP6fAyjLvVM91Ax/KbcCIfBxUNstaGkj?=
 =?iso-8859-1?Q?8HEI3oZV+O1yDJh1s+9aBsmyTYj+mtJzJiWT8qe+eHpMV9gNFArC/fQomC?=
 =?iso-8859-1?Q?FTh/nKRp6kOCrzMvtqEH+QykZp9wEd7PTAuODf9pTHykEWHosFe2hqDsYX?=
 =?iso-8859-1?Q?NKY//Qb4fMP8SCzC/wAwV17bdJoa+Ejff+gxUjA0WV5PIRXdxsGm+h+ymM?=
 =?iso-8859-1?Q?/sPmQF55TjKsEAHNYNcwxIsbrRVEvESi8oslOudsKBtXcPPphRNYgr2Fz7?=
 =?iso-8859-1?Q?N6WtY6dptleNFLeV8euUXKwcLP11MGe5ySNedRQ18I9122UQtwgKmCj9MU?=
 =?iso-8859-1?Q?vaTMbOqB4xrqLdArAoDAY4/duOn3cQFAM/B6qlH2kUeOhprv8JV1dE4Uz2?=
 =?iso-8859-1?Q?xB9yNNj0mVEkGNNWA+Ut14ILzcLlr0cSJUf3F3CWK1/o4WZiArknLJ5wS+?=
 =?iso-8859-1?Q?kPS+q16Xga/l4XF7YtezTbeFRZje2MAY2Erc2M9BilM/n5CzGZ9c2O76Z8?=
 =?iso-8859-1?Q?I5caapmBxIPEVEN4z6FrgpTSZfPIX7fq6bLLGmc6JLgu/qKdsslY45zY5q?=
 =?iso-8859-1?Q?iKOo0tgCfS5uWRWfGbXhHw08QmNh4bfS52DZyy+sCW38OulfkPO57NLvCU?=
 =?iso-8859-1?Q?5120qcAvUtGYxsSpCPd7BQffCtsE9EHiBfu7yHSsXTyzxq5MFBp8Bmq3bC?=
 =?iso-8859-1?Q?xFncitlcKmJX6rV/jHW2xhqBObiRshnr7G3MhAHS+/EPGyfZNOjx0BBZHE?=
 =?iso-8859-1?Q?vABSnaNt1HPotiJKKmQwybzWJanztPJdikgEzRQfR0ymxVTeJhYaJ64NlL?=
 =?iso-8859-1?Q?2NU564MJ2vYs2Pn7Pv0Lm0xYANpr2nD63NmHDcbXtoGNmUE9dxrXQGlZpr?=
 =?iso-8859-1?Q?Er+oEnK9ui1VM8IRzFnwJhILWtPr+bwzyNaB8+oMMBV5wmb/73agfp5U3C?=
 =?iso-8859-1?Q?i18YDgjsxSZghOPniYJEJhMoPhrWb6LIoJu8lZsg?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR21MB3680.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbe449b1-c963-4f5d-2667-08db2982f303
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 20:37:40.2031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: go47W7SELb+HqqxFWc54EKLIyLNFJwW4RNcR04kSpnRgyb6c9Sg1Vr52eq9id9F3EZXT+ZE7oyiXYD5T+7tpZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR21MB3932
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFS server Duplicate Request Cache (DRC) algorithms rely on NFS clients=0A=
reconnecting using the same local TCP port. Unique NFS operations are=0A=
identified by the per-TCP connection set of XIDs. This prevents file=0A=
corruption when non-idempotent NFS operations are retried.=0A=
=0A=
Currently, NFS client TCP connections are using different local TCP ports=
=0A=
when reconnecting to NFS servers.=0A=
=0A=
After an NFS server initiates shutdown of the TCP connection, the NFS=0A=
client's TCP socket is set to NULL after the socket state has reached=0A=
TCP_LAST_ACK(9). When reconnecting, the new socket attempts to reuse=0A=
the same local port but fails with EADDRNOTAVAIL (99). This forces the=0A=
socket to use a different local TCP port to reconnect to the remote NFS=0A=
server.=0A=
=0A=
State Transition and Events:=0A=
TCP_CLOSE_WAIT(8)=0A=
TCP_LAST_ACK(9)=0A=
connect(fail EADDRNOTAVAIL(99))=0A=
TCP_CLOSE(7)=0A=
bind on new port=0A=
connect success=0A=
=0A=
dmesg excerpts showing reconnect switching from TCP local port of 926 to=0A=
763 after commit 7c81e6a9d75b:=0A=
[13354.947854] NFS call  mkdir testW=0A=
...=0A=
[13405.654781] RPC:       xs_tcp_state_change client 00000000037d0f03...=0A=
[13405.654813] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1=0A=
[13405.654826] RPC:       xs_data_ready...=0A=
[13405.654892] RPC:       xs_tcp_state_change client 00000000037d0f03...=0A=
[13405.654895] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[13405.654899] RPC:       xs_tcp_state_change client 00000000037d0f03...=0A=
[13405.654900] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[13405.654950] RPC:       xs_connect scheduled xprt 00000000037d0f03=0A=
[13405.654975] RPC:       xs_bind 0.0.0.0:926: ok (0)=0A=
[13405.654980] RPC:       worker connecting xprt 00000000037d0f03 via tcp=
=0A=
			  to 10.101.6.228 (port 2049)=0A=
[13405.654991] RPC:       00000000037d0f03 connect status 99 connected 0=0A=
			  sock state 7=0A=
[13405.655001] RPC:       xs_tcp_state_change client 00000000037d0f03...=0A=
[13405.655002] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[13405.655024] RPC:       xs_connect scheduled xprt 00000000037d0f03=0A=
[13405.655038] RPC:       xs_bind 0.0.0.0:763: ok (0)=0A=
[13405.655041] RPC:       worker connecting xprt 00000000037d0f03 via tcp=
=0A=
			  to 10.101.6.228 (port 2049)=0A=
[13405.655065] RPC:       00000000037d0f03 connect status 115 connected 0=
=0A=
			  sock state 2=0A=
=0A=
State Transition and Events with patch applied:=0A=
TCP_CLOSE_WAIT(8)=0A=
TCP_LAST_ACK(9)=0A=
TCP_CLOSE(7)=0A=
connect(reuse of port succeeds)=0A=
=0A=
dmesg excerpts showing reconnect on same TCP local port of 936 with patch=
=0A=
applied:=0A=
[  257.139935] NFS: mkdir(0:59/560857152), testQ=0A=
[  257.139937] NFS call  mkdir testQ=0A=
...=0A=
[  307.822702] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1=0A=
[  307.822714] RPC:       xs_data_ready...=0A=
[  307.822817] RPC:       xs_tcp_state_change client 00000000ce702f14...=0A=
[  307.822821] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[  307.822825] RPC:       xs_tcp_state_change client 00000000ce702f14...=0A=
[  307.822826] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[  307.823606] RPC:       xs_tcp_state_change client 00000000ce702f14...=0A=
[  307.823609] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[  307.823629] RPC:       xs_tcp_state_change client 00000000ce702f14...=0A=
[  307.823632] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[  307.823676] RPC:       xs_connect scheduled xprt 00000000ce702f14=0A=
[  307.823704] RPC:       xs_bind 0.0.0.0:936: ok (0)=0A=
[  307.823709] RPC:       worker connecting xprt 00000000ce702f14 via tcp=
=0A=
			  to 10.101.1.30 (port 2049)=0A=
[  307.823748] RPC:       00000000ce702f14 connect status 115 connected 0=
=0A=
			  sock state 2=0A=
...=0A=
[  314.916193] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[  314.916251] RPC:       xs_connect scheduled xprt 00000000ce702f14=0A=
[  314.916282] RPC:       xs_bind 0.0.0.0:936: ok (0)=0A=
[  314.916292] RPC:       worker connecting xprt 00000000ce702f14 via tcp=
=0A=
			  to 10.101.1.30 (port 2049)=0A=
[  314.916342] RPC:       00000000ce702f14 connect status 115 connected 0=
=0A=
			  sock state 2=0A=
=0A=
Fixes: 7c81e6a9d75b ("SUNRPC: Tweak TCP socket shutdown in the RPC client")=
=0A=
Signed-off-by: Siddharth Rajendra Kawar <sikawar@microsoft.com>=0A=
---=0A=
Changes in v2:=0A=
- Fixed definition of TCP state 8 in commit message [Trond Myklebust]=0A=
- Removed redundant closing of socket [Trond Myklebust]=0A=
- Changed handling of TCP_LAST_ACK=0A=
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c=0A=
index d8ee06a9650a..7aeb15687aeb 100644=0A=
--- a/net/sunrpc/xprtsock.c=0A=
+++ b/net/sunrpc/xprtsock.c=0A=
@@ -2091,6 +2091,7 @@ static void xs_tcp_shutdown(struct rpc_xprt *xprt)=0A=
	switch (skst) {=0A=
	case TCP_FIN_WAIT1:=0A=
	case TCP_FIN_WAIT2:=0A=
+	case TCP_LAST_ACK:=0A=
		break;=0A=
	case TCP_ESTABLISHED:=0A=
	case TCP_CLOSE_WAIT:=
