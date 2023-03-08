Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96616B119B
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCHTDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCHTBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:01:46 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E746DBF3A5;
        Wed,  8 Mar 2023 11:01:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfRt4usrKRlkEjcb2oOGfC7gG3I0gEu6o574pNsrVyodMc0635V7JLrYTLxWXfDGoRUyXtaTj2H4d+EkpgRij96uKPz801oOe8sXYRIxxdyliDHR/6SYROt9LfFGOLrKITnZUojC0hb4rbvqvzV/t7sRk2FnZ+17BuT02XgG2je+iK7aF3c+5bR+5Od1LAU3wA4CXZTTaQ+SBh5/x/7kQHVTJ/CAVh+G5hKFKhtRl1arE+frR3oHc2tQA20mP+GDZ7+/6GpZ2aKbz4r/+axxOWDqrF/dY1HvIwZEgJxz5GLX/r2xPDVayl0c5qleQjy5/vxrhh44Gl85mU09FzIVXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uoYWamkrjZ84+4IieLlvpv/Ii5EwRGyYQVhBePB4JzU=;
 b=D1hTdg5uAHScSwulThW3M3lszkiTEGVSjbH02eelecSlWwGNcdXfcjqU2jwDr2QtXz+fr04N59yC2xlct11nCBhm9NhKJpAy57Tzd6RYE6IDLdZwOdwMrdkwEvcXPViBr3AM97dyFWpQc5Q03FcJevPoytfgpCHAstdChfRHqgPk9nf8VfIF41nwEQNEI3Hz7y5qP9aXhw1cMoRSCnFiEn+XTYR+rADzuD9iWmAALN2SUu8YcZkdyGeAp5OdBt5dkuZXG06RMnMig1+uQVDJcbkipzv0PcK2fsnoYzm4wC7HmC0uB/T1M+XF72L698eggworIIIf58+bp7tjRM5Afw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoYWamkrjZ84+4IieLlvpv/Ii5EwRGyYQVhBePB4JzU=;
 b=igiebuOh4BYuyaGjQLJGFmRBpGNDQlP951XPW7A9Qvj7jz7MM3CO2sImHcvjLOmNxDhqJIjInP6Am+J76sz0VeHJWXL7NZOL7AGCoL5CBWLUhf5Aw2mcYIgsukjXMf85Eblne9hALWl0g3FbN/A2frvbcW/N5ofwWpy+XL8Zta0=
Received: from DM4PR21MB3680.namprd21.prod.outlook.com (2603:10b6:8:a1::17) by
 DM6PR21MB1530.namprd21.prod.outlook.com (2603:10b6:5:256::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.17; Wed, 8 Mar 2023 19:01:41 +0000
Received: from DM4PR21MB3680.namprd21.prod.outlook.com
 ([fe80::7490:33b7:44cd:8545]) by DM4PR21MB3680.namprd21.prod.outlook.com
 ([fe80::7490:33b7:44cd:8545%3]) with mapi id 15.20.6178.016; Wed, 8 Mar 2023
 19:01:41 +0000
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
CC:     Dave Bauer <Dave.Bauer@microsoft.com>,
        Siddharth Kawar <Siddharth.Kawar@microsoft.com>
Subject: [PATCH] SUNRPC: fix shutdown of NFS TCP client socket
Thread-Topic: [PATCH] SUNRPC: fix shutdown of NFS TCP client socket
Thread-Index: AQHZUeAZAxku0qbuG0Kqc9IzASs6vg==
Date:   Wed, 8 Mar 2023 19:01:40 +0000
Message-ID: <DM4PR21MB368002F6F7A9A0EB8D7CFC87FCB49@DM4PR21MB3680.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-08T19:01:23.143Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR21MB3680:EE_|DM6PR21MB1530:EE_
x-ms-office365-filtering-correlation-id: 444adccf-63bf-449c-b071-08db20078d49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3rl4KzzZhwHbJVYpNzYHUaMEkMLm3dsxbfblaqQSBl4w04ZwcuOBw7QxelqSXCL8tPj9nsNbl99/QZBBO+LfUhm/h4/TKJmbJWWYXzIAwbqSZVYk1MW1LIvsF/SzENxfAAXxSwQsugZuaGh4QsfV0qpQPsfhUp9W2raRZ5uAArUS8oYWP1+N5AzIhw7sm2jK82FWvAxp0uasuMtfeRD2S4BRTDxjlnKfWeDGsdLPp8zK8FfcMj92pnWW4t68EtSYJjk2OvLCWcLNI0hPAGjgWJ1klagLbAWqaDqNsQyXh2h/wGWnRYlEppf+MIR8QwBFhg94aHDLNN7PqTkjQRhwy87ffspnST3MdQSPIlC6eXs3adeHrMxJ22bA6UTn6mLiGR1JvS+vbUfrr+qDCpKrEtFYCvGpjfwrMZYfnUu0KIHdBxkqRv3qSnyd83dSPKAj1LXZm2VNaIusXf1zYMfwym4uvUVShLETa1C6HOjRXIl0S1sdgOZUAEgrIQDSAGIRJWQ6MZaO8/IOO2RPx79J8FARoGlM+sRROpP8YrL6AagHBCXwFVFY+559cBiCnAerfwQb4vND9PQX4mQYOFwi1B/iUFLAEVQLrjudSCuWFyZo0JCE5wcLHZ/tfpvxez0fgZxsUYo43RU5FX96j94pAqqThKu/3/P9fl5DD6Wdb0cFXCFu34xxho183eIVbP+VVf4E/lDZWihgRYYilGFUvdnlehuooEOF5qE42hhRv80UZ5KdeSLiAPlmZsCqK4rE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR21MB3680.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(451199018)(33656002)(82950400001)(71200400001)(83380400001)(7696005)(186003)(107886003)(6506007)(478600001)(8936002)(4326008)(86362001)(41300700001)(64756008)(66476007)(52536014)(76116006)(2906002)(66946007)(66556008)(8676002)(8990500004)(5660300002)(66446008)(91956017)(10290500003)(82960400001)(38100700002)(316002)(122000001)(9686003)(110136005)(55016003)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?s5Axk7yaHA/4N3nLLnKsqh03sRiSQF+S0WqCssZGwzOgXGIMt4XYulsC+4?=
 =?iso-8859-1?Q?4YHUBqjK697L0SEEdVKSlXhmoEklqlApg4V7KqRzz9I6KPoYRXWqpOxUMf?=
 =?iso-8859-1?Q?AKnncDrCIeQnKi05ujOWNK6NxRncwG7rRAKlbeS0N9TjlO+SBzPR8WGuu1?=
 =?iso-8859-1?Q?cbIt54iUxgEohugJWLsrs8dfcfLMXRlSdC0VqElJbW+hQOQ2WYaL2R/+6y?=
 =?iso-8859-1?Q?yJygNZCbSUs6/I6L3FSk08jnfG/zxnofHJUV5UnM7IREuIKBLGFFB4P18a?=
 =?iso-8859-1?Q?yt6VAab9jrtqUF0tg2wkBB2diNuATcvOcovYUxUPI+a9puTyvjKuXLNwDT?=
 =?iso-8859-1?Q?z1c+klh12DcFrpaPexqCmuHKUTHo+L2J1z2nVgc4p5CvZ2pEWr8qbsus4D?=
 =?iso-8859-1?Q?5yBKt4k9nVKUh3uaJFf9plXUQkZJZpl1xj68zviPuROHYtKhsmL9Zsldl6?=
 =?iso-8859-1?Q?En0VmAbseMIu5BVWU23n1lpnc/Gac9VtAK9uQFsdai1Tc2AZl0EAFlw5SL?=
 =?iso-8859-1?Q?Enq9rFNZ63KyP31U4k4YvgE40DeGoUatbm1iCjGaCW3f2uLcqD0FgNgNMY?=
 =?iso-8859-1?Q?99G7VQ+m5Bz35fHoxA35+ITQf1vmm99JxKx1s3nV88PHWlL6oxOb4GXvMS?=
 =?iso-8859-1?Q?Ny9s1UG9MIsLQbJAywaDg8ZzzkvC9dci0qzpQBF0Wl64a6xer5fhMOGpd5?=
 =?iso-8859-1?Q?pcpEcrtTkttu3iQ8ftWwY417/rU8jp4qwG/IclbihZmC+MmpeaPDnhWIP/?=
 =?iso-8859-1?Q?Ykt7OFZM4fSNeBgpNZTmb3LwGymDYZ2gCX40SxAYd814kk1WXlKiIce9Fk?=
 =?iso-8859-1?Q?pnrKSzs6HZtoEmthce152xUPM++j6ay/0kNv7YW7Vv/lIj6XHd2MIcIGV8?=
 =?iso-8859-1?Q?QbljXdMj1w6/J5hRfEbLd8z2v2VU3S1LYe7+r4BQLeS0IBIwFpCnS1xRuh?=
 =?iso-8859-1?Q?KT7GLnv8WT33b99VDTRca+0ETtHCa3tIYYHw5ELoeoeuao7QbXoSPFi4ii?=
 =?iso-8859-1?Q?db7SPLKEcAKzkB4YTBcRyiE+pEFmYG1NddWRGa4HlcOM25rrDrmnqofdaS?=
 =?iso-8859-1?Q?YrpCVY1TvEH+lyhuxlVg3R8BMPwV519MiN5FWpspD9htXrVZOZj4M2oaTI?=
 =?iso-8859-1?Q?6GTmCz+nxC0f85ik85Ufog5UEDFzwHzIW6fM6/GVG0cDOITA6wRISeJmVv?=
 =?iso-8859-1?Q?siANR4L+5ZZ/Z8sLHsFNe5duIhuEhAQ44s0gHY+T8mvu5r8KWnSbMLVEJw?=
 =?iso-8859-1?Q?CwDuj7Ieu15ywiiuLRsHFjBU3ZJ/iKRcqRqplFsrAPvdWCRXMomU0aLGkt?=
 =?iso-8859-1?Q?zocRh1BdKfLAgRnFBI8egRL8qjH03+3/xnvpKzdom3G9F6cnyjx0INVCSl?=
 =?iso-8859-1?Q?YbgdmNKpHsKyu6UU63ukTv+TFZhUv3/wt3FTQFMO4gjqW51miNL5SmvP7+?=
 =?iso-8859-1?Q?ZcKn1Ow3kcrxWWACT5O0S9SfJo3modc1Pj2MIKmKfxwWazJkVKaWgU6m8t?=
 =?iso-8859-1?Q?XHpYjpO5DAXD7JUcT+YIEqZzi9Oo0XZH95DHVR9e1PaI/YTVIquNapsu+r?=
 =?iso-8859-1?Q?PndxpXG8IU45v2N7D78Bigwxldvl/I73IdJ/Y6mieh2oMHDEHh241HY4bT?=
 =?iso-8859-1?Q?Lm0HPGnbr54iovv/ZuRHifPSfbGXA3MVDnG3B2B1QXchj3DYgY4+EKSPwb?=
 =?iso-8859-1?Q?goDOQpzMCmYmV8V5Z7+Ve1oxJvTo1DMTFYqcEMKy?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR21MB3680.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 444adccf-63bf-449c-b071-08db20078d49
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 19:01:40.9865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IPf8uPHzoe4XTTLQu385ZP0CKROa9tNrL9dcoslXgEmwTFSrYfFnSYTa9/2RUQSavqmO7mwOQ62Gu1nB9bzvmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1530
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject: [PATCH] SUNRPC: fix shutdown of NFS TCP client socket=0A=
=0A=
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
TCP_CLOSING(8)=0A=
TCP_LAST_ACK(9)=0A=
connect(fail EADDRNOTAVAIL(99))=0A=
TCP_CLOSE(7)=0A=
bind on new port=0A=
connect success=0A=
=0A=
dmesg excerpts showing reconnect switching from local port of 688 to 1014:=
=0A=
[590701.200229] NFS: mkdir(0:61/560857152), testQ=0A=
[590701.200231] NFS call  mkdir testQ=0A=
[590701.200259] RPC:       xs_tcp_send_request(224) =3D 0=0A=
[590751.883111] RPC:       xs_tcp_state_change client 0000000051f4e000...=
=0A=
[590751.883146] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1=0A=
[590751.883160] RPC:       xs_data_ready...=0A=
[590751.883232] RPC:       xs_tcp_state_change client 0000000051f4e000...=
=0A=
[590751.883235] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[590751.883238] RPC:       xs_tcp_state_change client 0000000051f4e000...=
=0A=
[590751.883239] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[590751.883283] RPC:       xs_connect scheduled xprt 0000000051f4e000=0A=
[590751.883314] RPC:       xs_bind 0.0.0.0:688: ok (0)=0A=
[590751.883321] RPC:       worker connecting xprt 0000000051f4e000 via tcp=
=0A=
			   to 10.101.1.30 (port 2049)=0A=
[590751.883330] RPC:       0000000051f4e000 connect status 99 connected 0=
=0A=
			   sock state 7=0A=
[590751.883342] RPC:       xs_tcp_state_change client 0000000051f4e000...=
=0A=
[590751.883343] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=0A=
[590751.883356] RPC:       xs_connect scheduled xprt 0000000051f4e000=0A=
[590751.883383] RPC:       xs_bind 0.0.0.0:1014: ok (0)=0A=
[590751.883388] RPC:       worker connecting xprt 0000000051f4e000 via tcp=
=0A=
			   to 10.101.1.30 (port 2049)=0A=
[590751.883420] RPC:       0000000051f4e000 connect status 115 connected 0=
=0A=
			   sock state 2=0A=
...=0A=
=0A=
=0A=
State Transition and Events with patch applied:=0A=
TCP_CLOSING(8)=0A=
TCP_LAST_ACK(9)=0A=
TCP_CLOSE(7)=0A=
connect(reuse of port succeeds)=0A=
=0A=
dmesg excerpts showing reconnect on same port (936):=0A=
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
Fixes: 7c81e6a9d75b (SUNRPC: Tweak TCP socket shutdown in the RPC client)=
=0A=
Signed-off-by: Siddharth Rajendra Kawar <sikawar@microsoft.com>=0A=
---=0A=
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c=0A=
index d8ee06a9650a..e55e380bc10c 100644=0A=
--- a/net/sunrpc/xprtsock.c=0A=
+++ b/net/sunrpc/xprtsock.c=0A=
@@ -2094,6 +2094,7 @@ static void xs_tcp_shutdown(struct rpc_xprt *xprt)=0A=
		break;=0A=
	case TCP_ESTABLISHED:=0A=
	case TCP_CLOSE_WAIT:=0A=
+	case TCP_LAST_ACK:=0A=
		kernel_sock_shutdown(sock, SHUT_RDWR);=0A=
		trace_rpc_socket_shutdown(xprt, sock);=0A=
		break;=
