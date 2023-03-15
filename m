Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B8C6BBD51
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 20:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjCOTef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 15:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbjCOTee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 15:34:34 -0400
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021019.outbound.protection.outlook.com [52.101.62.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DE97D55E;
        Wed, 15 Mar 2023 12:34:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWGUyeoQYZlZfmaNN5R1fMaVNHNaRC3J59j2ioO7BawIBT/5KcxwfiulMADkkDcumKAA5YQ5ZmlMjXH1+tFcCpYN8U2yPdskrjnJRqvs+UGxgsNoI7FaReNcVrL+eSLo/Sh9GPIv0f4mPNDO0qdGzBc20pMoAr/UBiX8GTPi1tKS8EGhC4jJGV9VAraQs8YB0azJKtL0G6M56e/g3jx3INhOfpVW+YYrMJ99D2iuGobUpcvHalQt9903s1RSpvNGiS9MfLecRmw38nwWM40Ab5xiEwwmg4xRnVptKH2rACF474qniDhVWBAm+z9n/dfM+ZDCxUOc+O99Qb++7T6oYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXJr4v8i11xPofhuH89AOiesTX0e7iti7nSI5Sre//c=;
 b=Sn5ciirL3DQS1M/g3DeT1FdIFPAwoxm4iUzPf29ByNn35xbp4U89xbo6gpZBvvCw1TzjrtCf3cdrhX3eTLmiMfpnuSSJtvOhKUUzrleMGw23w46slE++lpR/sseb5cVidCkdKloOIZARaoqFe9m1p64XgdtzFLmBj+ukmv+DzNxaeYraltNvGeIcxtTaoEwbr96oTlY43KDo84NKoA1E2zgFplJb0FO9kdJX4noe5CdVTYmIY4LtLaYUSCEAbmQ7EBxAxtXiSpOqm6MGObmDAmGfskeTsEKLwSaS5wQ9Py3sBVA1y3M0kAnf5FvXCerwd5AvrVEwSdH2AfSR17QfnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXJr4v8i11xPofhuH89AOiesTX0e7iti7nSI5Sre//c=;
 b=TQNTSs6NLPiT8fB7FeMvX+OAPgY3o//rjh7wHIE/ZlZY72G5w9/pGpd2Eig6Mw+w5GAwa53Tjp/6+7wHtrtVbMqaslB5MuB8u1YLCdCiveR1YKdHJp61JirwXCbAi2tXaUbpTG9m5O+X7ktimECg2uIgyQTgVbMDS0rz4NvCWpE=
Received: from DM4PR21MB3680.namprd21.prod.outlook.com (2603:10b6:8:a1::17) by
 PH0PR21MB1975.namprd21.prod.outlook.com (2603:10b6:510:1c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.7; Wed, 15 Mar 2023 19:34:28 +0000
Received: from DM4PR21MB3680.namprd21.prod.outlook.com
 ([fe80::7490:33b7:44cd:8545]) by DM4PR21MB3680.namprd21.prod.outlook.com
 ([fe80::7490:33b7:44cd:8545%3]) with mapi id 15.20.6222.003; Wed, 15 Mar 2023
 19:34:28 +0000
From:   Siddharth Kawar <Siddharth.Kawar@microsoft.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
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
Thread-Index: AQHZUeAZAxku0qbuG0Kqc9IzASs6vq76sreAgAGTmNc=
Date:   Wed, 15 Mar 2023 19:34:28 +0000
Message-ID: <DM4PR21MB36804314FB58E68800C7FF38FCBF9@DM4PR21MB3680.namprd21.prod.outlook.com>
References: <DM4PR21MB368002F6F7A9A0EB8D7CFC87FCB49@DM4PR21MB3680.namprd21.prod.outlook.com>
 <116C9B6B-8990-4D85-8D9C-97764F9AA089@hammerspace.com>
In-Reply-To: <116C9B6B-8990-4D85-8D9C-97764F9AA089@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-03-15T19:34:14.498Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR21MB3680:EE_|PH0PR21MB1975:EE_
x-ms-office365-filtering-correlation-id: b32863f2-9694-43e2-8ad0-08db258c4ae7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YXszF1Ss5k42Fp/+dD2y2Mf0O6Bxy7APSElELXpJzdhTVSMi5K/CHI0RC9oWMqrsAf02HrT23xo/UoyWtpYwHnmns3XiDYe6NA+rMvzlbhSGOgKSDfex+KX7eZ3l4/BCdj+XJnTtW6R5FOEWKm3bWzucX/jJvHCnc9blzCtWR8jKA4kcM/UhICTNPaku6MRpQ+ZR5KOa8biCTuQP27+4v+Eod+dS+i3aDwGmd/fsRGzEPr9a+yjOQ4Vi23F3VanbGmN0lNUKDJZuUSyYV5DSKO5Ko5LTGhMADvTSJpFrcfzLjQqHD52gJvScr3UGl5tRTZktFkDTrnIVJs8UZgfNWKLDsypkh2ox2AwNblWnNWPLekCbW2DB2HjTyqLTwwE6GWFZ0CQPsyWKKgDO+mHpjek7wEuLXASKmrXmj3wos702U3SyiWtnhCgvWAx2uQUXZ6JVPOidg/R3Fhkc/NKmmvDCTgaZ9o+8S3oVgBNcBfayrxvNbXv9jbog6af8jCYB9FDyknL+6UkOr3Tt5RexG3OPlDoaTNxlybWihQeZQsPNb/eEg2pNtcNqwnAgCUMmn6BR7FfOvsU6iwtLay8cxvw/C2hj5GgmwDbogSwUWZ0mD+p4nxAI4GSHVuDsFeQ9HanCl5v5V47q3tuRsDLd9Niwe1Uu0CR44wv7HbyPu4usoETuTwwYD73VIfewPxs5pb2Tpa4ZqHqOWRQ9JMisdRmS06IYlGbPsONL5izAVFw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR21MB3680.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199018)(186003)(9686003)(53546011)(6506007)(33656002)(107886003)(966005)(7696005)(71200400001)(76116006)(66556008)(66946007)(91956017)(66476007)(66446008)(64756008)(478600001)(38070700005)(10290500003)(83380400001)(316002)(54906003)(55016003)(86362001)(5660300002)(6916009)(8676002)(41300700001)(8990500004)(4326008)(52536014)(8936002)(122000001)(82960400001)(2906002)(82950400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?RFLpESh002Lw0yUUyq+bphlx21rJqIAn3LQThMdj3POwPdtDOcIDOdSauC?=
 =?iso-8859-1?Q?lytuvvEajqMZ4VQqgHu2srxitWHI0BIjsCjdG43ZO+MQbQ2L5Ib9I9NUuk?=
 =?iso-8859-1?Q?La0EAHtRa1/18xNl6YjrGZUegauUdS713xU+R+ecqvLw5SggHz34TXamdo?=
 =?iso-8859-1?Q?7F3UTSNZ7MKISOqGk1pi8lZYnTFlss2afTU5jn7LZm5qlv4ScHMTbfIxNj?=
 =?iso-8859-1?Q?sn0RxxHYS/XxtfxF7fijj7ze4pfCww7AG4ZYeeYOOc2Y2h93/cbQ7ou+2o?=
 =?iso-8859-1?Q?ylh/b0T0mv5/0m0mPmVEIx8CydGteX18cq+tsBSNsigDDWsab5so/c/W4F?=
 =?iso-8859-1?Q?AjHiQ4JsFKvR7/fdcSYmjd0eBRxzOf76qCRSuYy+Kp88k9K0LjDitcJoRc?=
 =?iso-8859-1?Q?/capmuTlKymYh955+FN+xwChqcN8lQPltMH/HLFm8hsdNO9XmOEzf0bOt3?=
 =?iso-8859-1?Q?srKjq7xDablgm4evzjJIlpyVNitYxACd0kcjj7GI/XY5wvtTuJniFKQFrH?=
 =?iso-8859-1?Q?fzRCr5ka4zu6jzMzyTL7D6NObjyLwaXbKlULjyeEvOzBojsSOnrcbsJFHT?=
 =?iso-8859-1?Q?lardez8N7PkUU+FBZNRZr6cA9r9bDDxERL8QE7YwFNzKc+y9Z1UzR5GV3a?=
 =?iso-8859-1?Q?01mJQeQeOhr1429N1VHtyLcnC4h07kUSo38MZtk7rjUuBwD0F+uUB2WT60?=
 =?iso-8859-1?Q?5dNf0wd0rWfSkoZggrCp7VmX2ZeZOFTpkWeXpVM3Mp1OEcCs0j7J9LyO56?=
 =?iso-8859-1?Q?4iUJLDZBkpsoVxA27mszr61fBuog9g178qQcqUURcz80q9JJnRVejQ54tQ?=
 =?iso-8859-1?Q?EzrDcKprbR58npf2W5Cay7anGAKQkZnPVwliaXbv4MHyUsJeZ5CZfRhWON?=
 =?iso-8859-1?Q?JrEoJyu5nSLC7eGMUE3hw4gv/GxXWuf6xM8p3o8hIgPL7pe7Aa597wXTa2?=
 =?iso-8859-1?Q?PZFlruGMvhlyCUFr3gZBuSpfVHfcM963R5KM/6Y/Fz6P5wPTbP0hAq+VdV?=
 =?iso-8859-1?Q?RyY3qP2eHUu1kQp0yxp35Xiwpx5HSyT8sLlpI0hZJu/H29qpLN8LiPn3mM?=
 =?iso-8859-1?Q?UwjEAPPT3dtXvUFtRUE0Ke0zQVfSXJltjQUEGRHfrgKKtWB80x7oapcSAT?=
 =?iso-8859-1?Q?UxQ9wVD6LgekgCjV2o5KDwmVoIMju7F7yEsAB2WDIT9kfRQTsJHP5LcfIR?=
 =?iso-8859-1?Q?ZCmq5+wXYA9mThDlPR8aRI0aFgxW8Ow5DJasWASJPvEmrG0dnlOuj0gHt+?=
 =?iso-8859-1?Q?xFJw8+7T49nlCLrcwdFqKLFyVOB8kPCRcHuDkDZpii8FNiLdHfn5epshNf?=
 =?iso-8859-1?Q?irlxbVNO0ttGT7oAD/KkTAIlbB0VdhYgWAgDvHZ63+AsMGK3eDjB4V6nRZ?=
 =?iso-8859-1?Q?tLklVQLNk64X7FTY6UPu18Y7RLBA4+QyF0Cdg588Ui/PIDXqE3JbHLnsnA?=
 =?iso-8859-1?Q?aAOFCo+aaTxgenEeTM7gfbLZfq107xMO6ZwDOdkJNaUp3LFctgjKJVS71k?=
 =?iso-8859-1?Q?mOJ14jA1a4Z6DZQRFbNuJCT8iv8yfwxeKT11ESVjUQ40TIryszZcxtvDUF?=
 =?iso-8859-1?Q?oCfdIpFGtpiEFVtuculMMrcefOChI6VOluvINZtj4eJMwl+SD0j8GAHgCL?=
 =?iso-8859-1?Q?U5B11bB7mDi9nGWg37aQmk2YG2OjP+AAHb8L485x175sTbywL/zqpOBryU?=
 =?iso-8859-1?Q?JViiLn6sWa8v36mWxWlIvtiuSwr3adTXMn5+Jr6V?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR21MB3680.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32863f2-9694-43e2-8ad0-08db258c4ae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 19:34:28.5125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+X3B6UPwYAVUdPc3jgW6waw1Iy0Usme65Cr9JVQMvgsa4XOvYaDRrpcc3cIRxKNxjMBvWVYGMxD+op+eQDnLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1975
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [Some people who received this message don't often get email from trondmy=
@hammerspace.com. Learn why this is important at https://aka.ms/LearnAboutS=
enderIdentification ]=0A=
> =0A=
> > On Mar 8, 2023, at 14:01, Siddharth Kawar <Siddharth.Kawar@microsoft.co=
m> wrote:=0A=
> >=0A=
> > [You don't often get email from siddharth.kawar@microsoft.com. Learn wh=
y this is important at https://aka.ms/LearnAboutSenderIdentification ]=0A=
> >=0A=
> > Subject: [PATCH] SUNRPC: fix shutdown of NFS TCP client socket=0A=
> >=0A=
> > NFS server Duplicate Request Cache (DRC) algorithms rely on NFS clients=
=0A=
> > reconnecting using the same local TCP port. Unique NFS operations are=
=0A=
> > identified by the per-TCP connection set of XIDs. This prevents file=0A=
> > corruption when non-idempotent NFS operations are retried.=0A=
> >=0A=
> > Currently, NFS client TCP connections are using different local TCP por=
ts=0A=
> > when reconnecting to NFS servers.=0A=
> >=0A=
> > After an NFS server initiates shutdown of the TCP connection, the NFS=
=0A=
> > client's TCP socket is set to NULL after the socket state has reached=
=0A=
> > TCP_LAST_ACK(9). When reconnecting, the new socket attempts to reuse=0A=
> > the same local port but fails with EADDRNOTAVAIL (99). This forces the=
=0A=
> > socket to use a different local TCP port to reconnect to the remote NFS=
=0A=
> > server.=0A=
> >=0A=
> > State Transition and Events:=0A=
> > TCP_CLOSING(8)=0A=
> =0A=
> No: TCP state =3D=3D 8 is TCP_CLOSE_WAIT=0A=
=0A=
You are right.  Will fix in v2.=0A=
=0A=
> =0A=
> > TCP_LAST_ACK(9)=0A=
> > connect(fail EADDRNOTAVAIL(99))=0A=
> > TCP_CLOSE(7)=0A=
> > bind on new port=0A=
> > connect success=0A=
> >=0A=
> > dmesg excerpts showing reconnect switching from local port of 688 to 10=
14:=0A=
> > [590701.200229] NFS: mkdir(0:61/560857152), testQ=0A=
> > [590701.200231] NFS call  mkdir testQ=0A=
> > [590701.200259] RPC:       xs_tcp_send_request(224) =3D 0=0A=
> > [590751.883111] RPC:       xs_tcp_state_change client 0000000051f4e000.=
..=0A=
> > [590751.883146] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1=
=0A=
> > [590751.883160] RPC:       xs_data_ready...=0A=
> > [590751.883232] RPC:       xs_tcp_state_change client 0000000051f4e000.=
..=0A=
> > [590751.883235] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=
=0A=
> > [590751.883238] RPC:       xs_tcp_state_change client 0000000051f4e000.=
..=0A=
> > [590751.883239] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=
=0A=
> > [590751.883283] RPC:       xs_connect scheduled xprt 0000000051f4e000=
=0A=
> > [590751.883314] RPC:       xs_bind 0.0.0.0:688: ok (0)=0A=
> > [590751.883321] RPC:       worker connecting xprt 0000000051f4e000 via =
tcp=0A=
> >                           to 10.101.1.30 (port 2049)=0A=
> > [590751.883330] RPC:       0000000051f4e000 connect status 99 connected=
 0=0A=
> >                           sock state 7=0A=
> > [590751.883342] RPC:       xs_tcp_state_change client 0000000051f4e000.=
..=0A=
> > [590751.883343] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=
=0A=
> > [590751.883356] RPC:       xs_connect scheduled xprt 0000000051f4e000=
=0A=
> > [590751.883383] RPC:       xs_bind 0.0.0.0:1014: ok (0)=0A=
> > [590751.883388] RPC:       worker connecting xprt 0000000051f4e000 via =
tcp=0A=
> >                           to 10.101.1.30 (port 2049)=0A=
> > [590751.883420] RPC:       0000000051f4e000 connect status 115 connecte=
d 0=0A=
> >                           sock state 2=0A=
> > ...=0A=
> >=0A=
> >=0A=
> > State Transition and Events with patch applied:=0A=
> > TCP_CLOSING(8)=0A=
> > TCP_LAST_ACK(9)=0A=
> > TCP_CLOSE(7)=0A=
> > connect(reuse of port succeeds)=0A=
> >=0A=
> > dmesg excerpts showing reconnect on same port (936):=0A=
> > [  257.139935] NFS: mkdir(0:59/560857152), testQ=0A=
> > [  257.139937] NFS call  mkdir testQ=0A=
> > ...=0A=
> > [  307.822702] RPC:       state 8 conn 1 dead 0 zapped 1 sk_shutdown 1=
=0A=
> > [  307.822714] RPC:       xs_data_ready...=0A=
> > [  307.822817] RPC:       xs_tcp_state_change client 00000000ce702f14..=
.=0A=
> > [  307.822821] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=
=0A=
> > [  307.822825] RPC:       xs_tcp_state_change client 00000000ce702f14..=
.=0A=
> > [  307.822826] RPC:       state 9 conn 0 dead 0 zapped 1 sk_shutdown 3=
=0A=
> > [  307.823606] RPC:       xs_tcp_state_change client 00000000ce702f14..=
.=0A=
> > [  307.823609] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=
=0A=
> > [  307.823629] RPC:       xs_tcp_state_change client 00000000ce702f14..=
.=0A=
> > [  307.823632] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=
=0A=
> > [  307.823676] RPC:       xs_connect scheduled xprt 00000000ce702f14=0A=
> > [  307.823704] RPC:       xs_bind 0.0.0.0:936: ok (0)=0A=
> > [  307.823709] RPC:       worker connecting xprt 00000000ce702f14 via t=
cp=0A=
> >                          to 10.101.1.30 (port 2049)=0A=
> > [  307.823748] RPC:       00000000ce702f14 connect status 115 connected=
 0=0A=
> >                          sock state 2=0A=
> > ...=0A=
> > [  314.916193] RPC:       state 7 conn 0 dead 0 zapped 1 sk_shutdown 3=
=0A=
> > [  314.916251] RPC:       xs_connect scheduled xprt 00000000ce702f14=0A=
> > [  314.916282] RPC:       xs_bind 0.0.0.0:936: ok (0)=0A=
> > [  314.916292] RPC:       worker connecting xprt 00000000ce702f14 via t=
cp=0A=
> >                          to 10.101.1.30 (port 2049)=0A=
> > [  314.916342] RPC:       00000000ce702f14 connect status 115 connected=
 0=0A=
> >                          sock state 2=0A=
> >=0A=
> > Fixes: 7c81e6a9d75b (SUNRPC: Tweak TCP socket shutdown in the RPC clien=
t)=0A=
> > Signed-off-by: Siddharth Rajendra Kawar <sikawar@microsoft.com>=0A=
> > ---=0A=
> > diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c=0A=
> > index d8ee06a9650a..e55e380bc10c 100644=0A=
> > --- a/net/sunrpc/xprtsock.c=0A=
> > +++ b/net/sunrpc/xprtsock.c=0A=
> > @@ -2094,6 +2094,7 @@ static void xs_tcp_shutdown(struct rpc_xprt *xprt=
)=0A=
> >                break;=0A=
> >        case TCP_ESTABLISHED:=0A=
> >        case TCP_CLOSE_WAIT:=0A=
> > +       case TCP_LAST_ACK:=0A=
> >                kernel_sock_shutdown(sock, SHUT_RDWR);=0A=
> >                trace_rpc_socket_shutdown(xprt, sock);=0A=
> >                break;=0A=
> =0A=
> The only way to transition from TCP_CLOSE_WAIT to TCP_LAST_ACK is by clos=
ing the socket ( see https://nam06.safelinks.protection.outlook.com/?url=3D=
https%3A%2F%2Fwww.ibm.com%2Fdocs%2Fen%2Fzos%2F2.1.0%3Ftopic%3DSSLTBW_2.1.0%=
2Fcom.ibm.zos.v2r1.halu101%2Fconstatus.html&data=3D05%7C01%7CSiddharth.Kawa=
r%40microsoft.com%7C96b3c75820714bd3753208db24c266f8%7C72f988bf86f141af91ab=
2d7cd011db47%7C1%7C0%7C638144189616407625%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiM=
C4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&s=
data=3DuuXzgjaPk7YpnY6nO0NgNBPeq5HaA5%2BNLyrNFe%2BcjE8%3D&reserved=3D0 ), s=
o closing it while in TCP_LAST_ACK is redundant.=0A=
=0A=
You are right. The TCP_LAST_ACK state should not cause the socket to be=0A=
closed again. Instead, as in the case of TCP_FIN_WAIT1 and TCP_FIN_WAIT2,=
=0A=
the TCP_LAST_ACK state should not be calling xs_reset_transport. Will fix=
=0A=
in v2.=0A=
=0A=
> =0A=
> =0A=
> _________________________________=0A=
> Trond Myklebust=0A=
> Linux NFS client maintainer, Hammerspace=0A=
> trond.myklebust@hammerspace.com=
