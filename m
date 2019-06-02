Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0AD63227C
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 09:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfFBHhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 03:37:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44590 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbfFBHhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 03:37:17 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x526tGPD000704;
        Sat, 1 Jun 2019 23:55:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=t1UEgtOdIKVV7QsCecB3UWhVnBuh3mNUrJzdqFOyB78=;
 b=Q/elmrp0z1zoAGKV73Bi/Sgtw1TFiY8By0xnv2znJp0BWQiHKUrqaGC/69qVqkOJ87+G
 3JsDuwK91E3t5jQymQJTmN1hKJZ9nJS1IGpXFw9qvftTN6OI7pvKNn+gRCRAShu8lrzT
 YbAlwsr0yBa4NRGMmKNqSSwIPMxHQFgyI+I= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sunhka2en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 01 Jun 2019 23:55:50 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 1 Jun 2019 23:55:49 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 1 Jun 2019 23:55:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1UEgtOdIKVV7QsCecB3UWhVnBuh3mNUrJzdqFOyB78=;
 b=azOBssvpWYR+NOei5QVHDmrmVccuLgXItOGJKBLq+OSbg4C6gA18dT0IqxARISiHma39t7uJNLfx6aujzIIiTJ5VLh3NDrwEt8n84pFJUkM+y+wMTYpItX1D8BKkgIUFUx9T/0RNADKE4R+77X8c+fLdshb8QO5miNE5A/TmoCs=
Received: from DM5PR15MB1163.namprd15.prod.outlook.com (10.173.215.141) by
 DM5PR15MB1852.namprd15.prod.outlook.com (10.174.247.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.21; Sun, 2 Jun 2019 06:55:47 +0000
Received: from DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661]) by DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661%4]) with mapi id 15.20.1943.018; Sun, 2 Jun 2019
 06:55:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [PATCH v3 bpf-next 2/2] libbpf: remove qidconf and better support
 external bpf programs.
Thread-Topic: [PATCH v3 bpf-next 2/2] libbpf: remove qidconf and better
 support external bpf programs.
Thread-Index: AQHVF+KsuNMMv38RaEuJ4ZgVEhrKwqaHbV6AgABXYgCAACviAA==
Date:   Sun, 2 Jun 2019 06:55:47 +0000
Message-ID: <B800A2C5-A9F1-4B7D-A3C1-D3722C9916F9@fb.com>
References: <20190531185705.2629959-1-jonathan.lemon@gmail.com>
 <20190531185705.2629959-3-jonathan.lemon@gmail.com>
 <02CA9EF5-1380-4FE0-9479-C619C1792C2E@fb.com>
 <A2F3C0B9-FFA2-4EB3-8A20-A0D5D89A8C63@gmail.com>
In-Reply-To: <A2F3C0B9-FFA2-4EB3-8A20-A0D5D89A8C63@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::91be]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34786afd-57d0-45e1-28cd-08d6e7275742
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1852;
x-ms-traffictypediagnostic: DM5PR15MB1852:
x-microsoft-antispam-prvs: <DM5PR15MB1852F4F1AF1DBBD5AFC976C6B31B0@DM5PR15MB1852.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 005671E15D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(136003)(346002)(376002)(396003)(51914003)(199004)(189003)(99286004)(82746002)(83716004)(7736002)(25786009)(6436002)(305945005)(81166006)(81156014)(71190400001)(71200400001)(6486002)(6116002)(50226002)(14454004)(4326008)(86362001)(229853002)(6512007)(5660300002)(478600001)(2906002)(8676002)(57306001)(91956017)(53936002)(73956011)(476003)(2616005)(66446008)(64756008)(446003)(68736007)(11346002)(6916009)(14444005)(76176011)(316002)(36756003)(76116006)(256004)(66556008)(66476007)(66946007)(186003)(46003)(6506007)(486006)(33656002)(53546011)(54906003)(102836004)(8936002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1852;H:DM5PR15MB1163.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jg7NbvRLFNIvcvox2DueGqC5xriPbgxJbhzp0nYxTPllUnk6C2zJnyOtc6FNuIf4nLdUu6tq5ACd7XdwbYtIoUx8pRW5eonyRcj3Md4NBn2ATaeg8UvW2/KGX2X8KXoOaBBJE/xIgZUsn0+t6yxW0dG4JP+zdyjHrZXJVX1udCvdNDQGbMfZCVFZRx1twI+O6FG0vwjd425O91/t5Gwg05ei/kBKb1R+qs5s+u3V5fqlo1r8anHFa2xp92ZAwf8KU/KM619XbyHjocFFE9zIhXnX9sZDjvA0ZF/cMxejdrgcJIVdX6MQbD23CJH5JdxPJsJ9A8v/SVGmfD20qzvoLgcY2sjS/Cb4J+IlRCalHsrK52ByMNX65SNjwLr7KpNxJUy3WnUYtfozM8VWLJOjpwdCwCR/iDHJqOUNFTM44aE=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F60F10EB4E69E544B05666FBB538B1F2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 34786afd-57d0-45e1-28cd-08d6e7275742
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2019 06:55:47.0846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1852
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-02_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906020052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 1, 2019, at 9:18 PM, Jonathan Lemon <jonathan.lemon@gmail.com> wro=
te:
>=20
>=20
>=20
> On 1 Jun 2019, at 16:05, Song Liu wrote:
>=20
>>> On May 31, 2019, at 11:57 AM, Jonathan Lemon <jonathan.lemon@gmail.com>=
 wrote:
>>>=20
>>> Use the recent change to XSKMAP bpf_map_lookup_elem() to test if
>>> there is a xsk present in the map instead of duplicating the work
>>> with qidconf.
>>>=20
>>> Fix things so callers using XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD
>>> bypass any internal bpf maps, so xsk_socket__{create|delete} works
>>> properly.
>>>=20
>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>> ---
>>> tools/lib/bpf/xsk.c | 79 +++++++++------------------------------------
>>> 1 file changed, 16 insertions(+), 63 deletions(-)
>>>=20
>>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>>> index 38667b62f1fe..7ce7494b5b50 100644
>>> --- a/tools/lib/bpf/xsk.c
>>> +++ b/tools/lib/bpf/xsk.c
>>> @@ -60,10 +60,8 @@ struct xsk_socket {
>>> 	struct xsk_umem *umem;
>>> 	struct xsk_socket_config config;
>>> 	int fd;
>>> -	int xsks_map;
>>> 	int ifindex;
>>> 	int prog_fd;
>>> -	int qidconf_map_fd;
>>> 	int xsks_map_fd;
>>> 	__u32 queue_id;
>>> 	char ifname[IFNAMSIZ];
>>> @@ -265,15 +263,11 @@ static int xsk_load_xdp_prog(struct xsk_socket *x=
sk)
>>> 	/* This is the C-program:
>>> 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>>> 	 * {
>>> -	 *     int *qidconf, index =3D ctx->rx_queue_index;
>>> +	 *     int index =3D ctx->rx_queue_index;
>>> 	 *
>>> 	 *     // A set entry here means that the correspnding queue_id
>>> 	 *     // has an active AF_XDP socket bound to it.
>>> -	 *     qidconf =3D bpf_map_lookup_elem(&qidconf_map, &index);
>>> -	 *     if (!qidconf)
>>> -	 *         return XDP_ABORTED;
>>> -	 *
>>> -	 *     if (*qidconf)
>>> +	 *     if (bpf_map_lookup_elem(&xsks_map, &index))
>>> 	 *         return bpf_redirect_map(&xsks_map, index, 0);
>>> 	 *
>>> 	 *     return XDP_PASS;
>>> @@ -286,15 +280,10 @@ static int xsk_load_xdp_prog(struct xsk_socket *x=
sk)
>>> 		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
>>> 		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
>>> 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
>>> -		BPF_LD_MAP_FD(BPF_REG_1, xsk->qidconf_map_fd),
>>> +		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
>>> 		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
>>> 		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
>>> -		BPF_MOV32_IMM(BPF_REG_0, 0),
>>> -		/* if r1 =3D=3D 0 goto +8 */
>>> -		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 8),
>>> 		BPF_MOV32_IMM(BPF_REG_0, 2),
>>> -		/* r1 =3D *(u32 *)(r1 + 0) */
>>> -		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
>>> 		/* if r1 =3D=3D 0 goto +5 */
>>> 		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
>>> 		/* r2 =3D *(u32 *)(r10 - 4) */
>>> @@ -366,18 +355,11 @@ static int xsk_create_bpf_maps(struct xsk_socket =
*xsk)
>>> 	if (max_queues < 0)
>>> 		return max_queues;
>>>=20
>>> -	fd =3D bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "qidconf_map",
>>> +	fd =3D bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
>>> 				 sizeof(int), sizeof(int), max_queues, 0);
>>> 	if (fd < 0)
>>> 		return fd;
>>> -	xsk->qidconf_map_fd =3D fd;
>>>=20
>>> -	fd =3D bpf_create_map_name(BPF_MAP_TYPE_XSKMAP, "xsks_map",
>>> -				 sizeof(int), sizeof(int), max_queues, 0);
>>> -	if (fd < 0) {
>>> -		close(xsk->qidconf_map_fd);
>>> -		return fd;
>>> -	}
>>> 	xsk->xsks_map_fd =3D fd;
>>>=20
>>> 	return 0;
>>> @@ -385,10 +367,8 @@ static int xsk_create_bpf_maps(struct xsk_socket *=
xsk)
>>>=20
>>> static void xsk_delete_bpf_maps(struct xsk_socket *xsk)
>>> {
>>> -	close(xsk->qidconf_map_fd);
>>> +	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
>>> 	close(xsk->xsks_map_fd);
>>> -	xsk->qidconf_map_fd =3D -1;
>>> -	xsk->xsks_map_fd =3D -1;
>>> }
>>>=20
>>> static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
>>> @@ -417,10 +397,9 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *=
xsk)
>>> 	if (err)
>>> 		goto out_map_ids;
>>>=20
>>> -	for (i =3D 0; i < prog_info.nr_map_ids; i++) {
>>> -		if (xsk->qidconf_map_fd !=3D -1 && xsk->xsks_map_fd !=3D -1)
>>> -			break;
>>> +	xsk->xsks_map_fd =3D -1;
>>>=20
>>> +	for (i =3D 0; i < prog_info.nr_map_ids; i++) {
>>> 		fd =3D bpf_map_get_fd_by_id(map_ids[i]);
>>> 		if (fd < 0)
>>> 			continue;
>>> @@ -431,11 +410,6 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *=
xsk)
>>> 			continue;
>>> 		}
>>>=20
>>> -		if (!strcmp(map_info.name, "qidconf_map")) {
>>> -			xsk->qidconf_map_fd =3D fd;
>>> -			continue;
>>> -		}
>>> -
>>> 		if (!strcmp(map_info.name, "xsks_map")) {
>>> 			xsk->xsks_map_fd =3D fd;
>>> 			continue;
>>> @@ -445,40 +419,18 @@ static int xsk_lookup_bpf_maps(struct xsk_socket =
*xsk)
>>> 	}
>>>=20
>>> 	err =3D 0;
>>> -	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
>>> +	if (xsk->xsks_map_fd =3D=3D -1)
>>> 		err =3D -ENOENT;
>>> -		xsk_delete_bpf_maps(xsk);
>>> -	}
>>>=20
>>> out_map_ids:
>>> 	free(map_ids);
>>> 	return err;
>>> }
>>>=20
>>> -static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
>>> -{
>>> -	int qid =3D false;
>>> -
>>> -	bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
>>> -	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
>>> -}
>>> -
>>> static int xsk_set_bpf_maps(struct xsk_socket *xsk)
>>> {
>>> -	int qid =3D true, fd =3D xsk->fd, err;
>>> -
>>> -	err =3D bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid=
, 0);
>>> -	if (err)
>>> -		goto out;
>>> -
>>> -	err =3D bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id, &fd, 0)=
;
>>> -	if (err)
>>> -		goto out;
>>> -
>>> -	return 0;
>>> -out:
>>> -	xsk_clear_bpf_maps(xsk);
>>> -	return err;
>>> +	return bpf_map_update_elem(xsk->xsks_map_fd, &xsk->queue_id,
>>> +				   &xsk->fd, 0);
>>> }
>>>=20
>>> static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>>> @@ -514,6 +466,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xs=
k)
>>>=20
>>> out_load:
>>> 	close(xsk->prog_fd);
>>> +	xsk->prog_fd =3D -1;
>>=20
>> I found xsk->prog_fd confusing. Why do we need to set it here?
>=20
> I suppose this one isn't strictly required - I set it as a guard out of h=
abit.
> xsk is (currently) immediately freed by the caller, so it can be removed.
>=20
>=20
> The main logic is:
>=20
>        xsk->prog_fd =3D -1;
>        if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LO=
AD)) {
>                err =3D xsk_setup_xdp_prog(xsk);
>=20
> The user may pass INHIBIT_PROG_LOAD, which bypasses setting up the xdp pr=
ogram
> (and any maps associated with the program), allowing installation of a cu=
stom
> program.  The cleanup behavior is then gated on prog_fd being -1,
>=20
>>=20
>> I think we don't need to call xsk_delete_bpf_maps() in out_load path?
>=20
> Hmm, there's two out_load paths, but only one needs the delete maps call.=
  Let
> me redo the error handling so it's a bit more explicit.
>=20
>=20
>>=20
>>> out_maps:
>>> 	xsk_delete_bpf_maps(xsk);
>>> 	return err;
>>> @@ -643,9 +596,7 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr,=
 const char *ifname,
>>> 		goto out_mmap_tx;
>>> 	}
>>>=20
>>> -	xsk->qidconf_map_fd =3D -1;
>>> -	xsk->xsks_map_fd =3D -1;
>>> -
>>> +	xsk->prog_fd =3D -1;
>>> 	if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD))=
 {
>>> 		err =3D xsk_setup_xdp_prog(xsk);
>>> 		if (err)
>>> @@ -708,8 +659,10 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>>> 	if (!xsk)
>>> 		return;
>>>=20
>>> -	xsk_clear_bpf_maps(xsk);
>>> -	xsk_delete_bpf_maps(xsk);
>>> +	if (xsk->prog_fd !=3D -1) {
>>> +		xsk_delete_bpf_maps(xsk);
>>> +		close(xsk->prog_fd);
>>=20
>> Here, we use prog_fd !=3D -1 to gate xsk_delete_bpf_maps(), which is
>> confusing. I looked at the code for quite sometime, but still cannot
>> confirm it is correct.
>=20
> See above reasoning - with INHIBIT_PROG_LOAD, there is no library-provide=
d
> program or maps, so cleanup actions are skipped.
> --=20
> Jonathan

Thanks for the explanation.=20

Acked-by: Song Liu <songliubraving@fb.com>



