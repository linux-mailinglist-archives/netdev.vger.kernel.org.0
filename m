Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0296C8F438
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732879AbfHOTKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:50 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:17437
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732845AbfHOTKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iG2ZjQ3wVo/bHENW7CqAm1TIXB2TtafcCdCZvwyQLYdnUKZujFvfRS9+/yQZ/yBB/+I+cOxxVNCtyBf5c/5f71a+sAveNIK6XZOwdjMht7ZCBt2jfBGNaBRXOf8nbcBhsdkgXhNbDwj2ElOUmwQrcHVcdbsBJTnBBiN5smcc9GPcmH12QZkbi2HLorXCWa0W4Ua33mgbFEJuESxnnZeQ5QYaT9Fh7C2If/25MGt5A+fNJPLSSFIIrwEuQdMQ2X0YHQpX9OvfXUx+cbT/+pT73b/bKVg7A42bmErcN8fDWxE/NgSSxpgR/f31/DTx69nJXmKQO18bvFmtpExvRk5GYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JZWagE7R8mHGYn9kaOVH7+lu12M0JL4q2/36HRn08o=;
 b=HhZtOIrNiS4aHjqJiBYU7+1fC2ygA4wIHzt4NvtEMKkeirTEau3bsva8tj+b/zoIRixe1UzeCszmfu2n1ddQsxI8QxmBYb16cbJpVLExiel0iUbokuy3J1yEuKiIQiUV/ZUfZ/JBgnBn3xEPfLCukyiHq+VtfnASx06bggMUjZsdgsyDtDOdTMt9wy2n9x6ScWdOXkhyXZG+IhaqQWW9tchFGkG4y6bnXZ8AtB7j7JbYNmWrNqjI7I6jS/lEKwZHkmkgOpadQk6iP2HHTqVSh0Evm0vax9ZUwetWW0elm1HxDdrgO6+DYCmrrLTYEJtVlgre0z0pf14sc/5dpS+bZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JZWagE7R8mHGYn9kaOVH7+lu12M0JL4q2/36HRn08o=;
 b=OZx+L3K5JzYaVhWbVMRjkUBdNS0wS/sqs1RP1epg+JA3Kc8GQANz0QguA2tKakOmzRpWUTOP7D16hHbCM1vKcNyV4//+pjtCdsgAsij6r5f2wK3AzNuZD7SFvVsfzorf7WmjVn57jlWO4zYxvKmLapodShWfOYxALHzbUl+gYeM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:15 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/16] net/mlx5e: Fix deallocation of non-fully init encap
 entries
Thread-Topic: [net-next 15/16] net/mlx5e: Fix deallocation of non-fully init
 encap entries
Thread-Index: AQHVU50RIQKoFOVokECjUQC7C2igFA==
Date:   Thu, 15 Aug 2019 19:10:15 +0000
Message-ID: <20190815190911.12050-16-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ac32a52-c08c-4bf0-dd61-08d721b4344f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB244092F7E0D456363DF407ACBEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(5024004)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(45080400002)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ji1/cQs/xMUarMcs/C0f817EgK4hyhH0CrnPJ8OVfRq27cmfHCZA/P6espLeFHnTiMkeyvuXSGSO7tYJ1ILb9M2LsTnNL6c0idhu88KWIM7MOAwot/WsbJ8fpvgRJIvo/VBciNTTgQbIW4vxF/AGo/Qobr6o6V+2j8Osj1ztfZKgCYFYKn5P51gWEf2nD5fkKD3aQNpTnHuaADhbJSfRRG5+uC9KerHq0g3KlFEUHsoi+XSdHHT4EGJryvoplBVYnAtALMkQ7WKbtC1ISRHwQegRN6RqsO3/EnEgoZJsEEfNoL9qBqIzL750+zA/4LGdngPX/uxanuV+Sld1kappiv9oiBALLzeGtCKbcqbNoaKqZedqEfwUlsSk1eHFOUVdTstvD4LiUzDL1rsX5mH7n9EsvsJv3UomTdIsmFkD4+0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac32a52-c08c-4bf0-dd61-08d721b4344f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:15.4332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jIlwO9+R32hOKTzTaYztTEuQUUeKbqE3NfX32J/l6x6B5tn0BwWnlBuSyBF0yA6JjgVAz7otTlCNWGV+/wRhyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Recent rtnl lock dependency refactoring changed encap entry attach code to
insert encap entry to hash table before it was fully initialized in order
to allow concurrent tc users to wait on completion for encap entry to
finish initialization. That change required all the users of encap entry to
obtain reference to it first and for caller that creates encap to put
reference to it on error, instead of freeing the entry memory directly.
However, releasing reference to such encap entry that wasn't fully
initialized causes NULL pointer dereference in
mlx5e_rep_encap_entry_detach() which expects e->out_dev to be set and encap
to be attached to nhe:

[ 1092.454517] BUG: unable to handle page fault for address: 00000000000420=
e8
[ 1092.454571] #PF: supervisor read access in kernel mode
[ 1092.454602] #PF: error_code(0x0000) - not-present page
[ 1092.454632] PGD 800000083032c067 P4D 800000083032c067 PUD 84107d067 PMD =
0
[ 1092.454673] Oops: 0000 [#1] SMP PTI
[ 1092.454697] CPU: 20 PID: 22393 Comm: tc Not tainted 5.3.0-rc3+ #589
[ 1092.454733] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0=
b 03/30/2017
[ 1092.454806] RIP: 0010:mlx5e_rep_encap_entry_detach+0x1c/0x630 [mlx5_core=
]
[ 1092.454845] Code: be f4 ff ff ff e9 11 ff ff ff 0f 1f 40 00 0f 1f 44 00 =
00 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 48 89 f3 48 83 ec 30 <48=
> 8b 87 28 16 04 00 48 89 f7 48 05 d0 03 00 00 48 89
 45 c8 e8 cb
[ 1092.454942] RSP: 0018:ffffb6f08421f5a0 EFLAGS: 00010286
[ 1092.454974] RAX: 0000000000000000 RBX: ffff8ab668644e00 RCX: ffffb6f0842=
1f56c
[ 1092.455013] RDX: ffff8ab668644e40 RSI: ffff8ab668644e00 RDI: 00000000000=
00ac0
[ 1092.455053] RBP: ffffb6f08421f5f8 R08: 0000000000000001 R09: 00000000000=
00000
[ 1092.455092] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00ac0
[ 1092.455131] R13: 00000000ffffff9b R14: ffff8ab63f200ac0 R15: ffff8ab6686=
44e40
[ 1092.455171] FS:  00007fa195bdc480(0000) GS:ffff8ab66fa00000(0000) knlGS:=
0000000000000000
[ 1092.455216] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1092.455249] CR2: 00000000000420e8 CR3: 0000000867522001 CR4: 00000000001=
606e0
[ 1092.455288] Call Trace:
[ 1092.455315]  ? __mutex_unlock_slowpath+0x4d/0x2a0
[ 1092.455365]  mlx5e_encap_dealloc.isra.0+0x31/0x60 [mlx5_core]
[ 1092.455424]  mlx5e_tc_add_fdb_flow+0x596/0x750 [mlx5_core]
[ 1092.455484]  __mlx5e_add_fdb_flow+0x152/0x210 [mlx5_core]
[ 1092.455534]  mlx5e_configure_flower+0x4d5/0xe30 [mlx5_core]
[ 1092.455574]  tc_setup_cb_call+0x67/0xb0
[ 1092.455601]  fl_hw_replace_filter+0x142/0x300 [cls_flower]
[ 1092.455639]  fl_change+0xd24/0x1bdb [cls_flower]
[ 1092.455675]  tc_new_tfilter+0x3e0/0x970
[ 1092.455709]  ? tc_del_tfilter+0x720/0x720
[ 1092.455735]  rtnetlink_rcv_msg+0x389/0x4b0
[ 1092.455763]  ? netlink_deliver_tap+0x95/0x400
[ 1092.455791]  ? rtnl_dellink+0x2d0/0x2d0
[ 1092.455817]  netlink_rcv_skb+0x49/0x110
[ 1092.455844]  netlink_unicast+0x171/0x200
[ 1092.455872]  netlink_sendmsg+0x224/0x3f0
[ 1092.455901]  sock_sendmsg+0x5e/0x60
[ 1092.455924]  ___sys_sendmsg+0x2ae/0x330
[ 1092.455950]  ? task_work_add+0x43/0x50
[ 1092.455976]  ? fput_many+0x45/0x80
[ 1092.456004]  ? __lock_acquire+0x248/0x18e0
[ 1092.456033]  ? find_held_lock+0x2b/0x80
[ 1092.456058]  ? task_work_run+0x7b/0xd0
[ 1092.456085]  __sys_sendmsg+0x59/0xa0
[ 1092.457013]  do_syscall_64+0x5c/0xb0
[ 1092.457924]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1092.458842] RIP: 0033:0x7fa195da27b8
[ 1092.459918] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 =
f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83
 ec 28 89 54
[ 1092.462634] RSP: 002b:00007fff94409298 EFLAGS: 00000246 ORIG_RAX: 000000=
000000002e
[ 1092.464011] RAX: ffffffffffffffda RBX: 000000005d515b0e RCX: 00007fa195d=
a27b8
[ 1092.465391] RDX: 0000000000000000 RSI: 00007fff94409300 RDI: 00000000000=
00003
[ 1092.466761] RBP: 0000000000000000 R08: 0000000000000001 R09: 00000000000=
00006
[ 1092.468121] R10: 0000000000404ec2 R11: 0000000000000246 R12: 00000000000=
00001
[ 1092.469456] R13: 0000000000480640 R14: 0000000000000016 R15: 00000000000=
00001
[ 1092.470766] Modules linked in: act_mirred act_tunnel_key cls_flower dumm=
y vxlan ip6_udp_tunnel udp_tunnel sch_ingress nfsv3 nfs_acl nfs lockd grace=
 fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm
iw_cm ib_cm mlx5_ib ib_uverbs ib_core intel_rapl_msr intel_rapl_common sb_e=
dac x86_pkg_temp_thermal intel_powerclamp coretemp mlx5_core kvm_intel kvm =
irqbypass crct10dif_pclmul mei_me crc32_pclmul crc32
c_intel igb iTCO_wdt ghash_clmulni_intel ses mlxfw intel_cstate iTCO_vendor=
_support ptp intel_uncore lpc_ich pps_core mei i2c_i801 joydev intel_rapl_p=
erf ioatdma enclosure ipmi_ssif pcspkr dca wmi ipmi_
si ipmi_devintf ipmi_msghandler acpi_pad acpi_power_meter ast i2c_algo_bit =
drm_vram_helper ttm drm_kms_helper drm mpt3sas raid_class scsi_transport_sa=
s
[ 1092.479618] CR2: 00000000000420e8
[ 1092.481214] ---[ end trace ce2e0f4d9a67f604 ]---

To fix the issue, set e->compl_result to positive value after encap was
initialized successfully. Check e->compl_result value in
mlx5e_encap_dealloc() and only detach and dealloc encap if the value is
positive.

Fixes: d589e785baf5 ("net/mlx5e: Allow concurrent creation of encap entries=
")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 5be3da621499..2a4de37fd210 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1481,10 +1481,13 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_=
neigh_hash_entry *nhe)
 static void mlx5e_encap_dealloc(struct mlx5e_priv *priv, struct mlx5e_enca=
p_entry *e)
 {
 	WARN_ON(!list_empty(&e->flows));
-	mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
=20
-	if (e->flags & MLX5_ENCAP_ENTRY_VALID)
-		mlx5_packet_reformat_dealloc(priv->mdev, e->encap_id);
+	if (e->compl_result > 0) {
+		mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
+
+		if (e->flags & MLX5_ENCAP_ENTRY_VALID)
+			mlx5_packet_reformat_dealloc(priv->mdev, e->encap_id);
+	}
=20
 	kfree(e->encap_header);
 	kfree(e);
@@ -2910,7 +2913,7 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv=
,
=20
 		/* Protect against concurrent neigh update. */
 		mutex_lock(&esw->offloads.encap_tbl_lock);
-		if (e->compl_result) {
+		if (e->compl_result < 0) {
 			err =3D -EREMOTEIO;
 			goto out_err;
 		}
@@ -2950,6 +2953,7 @@ static int mlx5e_attach_encap(struct mlx5e_priv *priv=
,
 		e->compl_result =3D err;
 		goto out_err;
 	}
+	e->compl_result =3D 1;
=20
 attach_flow:
 	flow->encaps[out_index].e =3D e;
--=20
2.21.0

