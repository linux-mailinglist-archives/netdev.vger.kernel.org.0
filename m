Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6BD56D78
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfFZPSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:18:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18068 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726104AbfFZPSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:18:14 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QF9EjE014445;
        Wed, 26 Jun 2019 08:17:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=YJqw9cKMVm6BOGcK45C2bDDBSoqFjWjBuCz1Lr47d6c=;
 b=KKDmcSKCXTC+TKEZzweCHMaeD2tng6Z98sQ4V+ZIMBaAyVAaKCXuYcbaF1ZzNBnWMT0n
 DQfdvlDeptQVjd+5cONIrJXqIZyeqpTk1iTFOAEwIhl7N7G9ARMK0hvwKDMu1/lnm6v/
 nbWmoRCxDUey88zQzC7buW+XQR9gq7jygkM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tca1vr9qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jun 2019 08:17:49 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Jun 2019 08:17:49 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 08:17:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJqw9cKMVm6BOGcK45C2bDDBSoqFjWjBuCz1Lr47d6c=;
 b=b3KQk+hT8xuKAHD9usXT+ssETkj2v7T2QeNgLZbTGWcwJlUGw51UzrtRV0bvqh8daJFgYo+lZgGCokAPJIp5pyVtu+Ox81FOupD0TxtclLJti48BIwhY8JrNSJuG0hVvC2PBiqcykT3ZoFwxh+FXdVqjJAs+QLpCs7UddFPGXnY=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1694.namprd15.prod.outlook.com (10.175.141.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 15:17:47 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::400e:e329:ea98:aa0d%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 15:17:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "jannh@google.com" <jannh@google.com>
Subject: Re: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Index: AQHVK4MfT15tn2gAREGxInrd8zK0eaat8CiAgAAdbwA=
Date:   Wed, 26 Jun 2019 15:17:47 +0000
Message-ID: <5A472047-F329-43C3-9DBC-9BCFC0A19F1C@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
 <20190625182303.874270-2-songliubraving@fb.com>
 <9bc166ca-1ef0-ee1e-6306-6850d4008174@iogearbox.net>
In-Reply-To: <9bc166ca-1ef0-ee1e-6306-6850d4008174@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:6898]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e624aa75-6c65-4c75-2df7-08d6fa49723e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1694;
x-ms-traffictypediagnostic: MWHPR15MB1694:
x-microsoft-antispam-prvs: <MWHPR15MB1694929C8405AC235AD31AC6B3E20@MWHPR15MB1694.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(6436002)(64756008)(6916009)(6486002)(478600001)(6512007)(53936002)(2906002)(229853002)(6506007)(53546011)(102836004)(186003)(6116002)(46003)(68736007)(76116006)(446003)(11346002)(2616005)(476003)(486006)(66476007)(66446008)(5660300002)(66556008)(14454004)(86362001)(57306001)(33656002)(36756003)(73956011)(25786009)(76176011)(316002)(54906003)(50226002)(99286004)(8936002)(81166006)(81156014)(8676002)(71190400001)(71200400001)(6246003)(305945005)(4326008)(7736002)(256004)(14444005)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1694;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FDopqYsnnJqJWaviIvTJboX3tCwWWXazEIkyC90/NpNVgeTVKwu+jehekiRdWhlO+B7uf+sBtTUGbjuvCgP0VSSFkPhBqk7nc9WM5dcaJWpuwySUF776xdK2c8l+CbRi9ZqvsoCo/u+kKCuaowGEIiPJ8heNqg0Ftjwnfr08gd09PWhZR1DdOD01bbTenJ2QGTqUkzzGdcgPZ7J/RsectIC5Cv9MwDhnSIB0o/Tvy7KZWyoPqbsDfBv3a7xCgzMkZsxIvjRiEWqi1TWZ2487xNE0T7xmmmGnwZQnb+ncy1IiSSa2dwEvbsC1YK+RkbqxgGEIG4FFkX6Ye2xaT9+Le4KEJ6922+KRlEq6FeKftIXh7eGQHwl8uJJ2Fh3xYJ74LWE/lpIkaBCT4hxkFpHVx4lNDps6FCJae9WdlsZjO7M=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <573F6EFCC63D84488AA83DF29840D778@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e624aa75-6c65-4c75-2df7-08d6fa49723e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 15:17:47.4036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 26, 2019, at 6:32 AM, Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>=20
> On 06/25/2019 08:23 PM, Song Liu wrote:
>> This patch introduce unprivileged BPF access. The access control is
>> achieved via device /dev/bpf. Users with access to /dev/bpf are able
>> to access BPF syscall.
>>=20
>> Two ioctl command are added to /dev/bpf:
>>=20
>> The first two commands get/put permission to access sys_bpf. This
>> permission is noted by setting bit TASK_BPF_FLAG_PERMITTED of
>> current->bpf_flags. This permission cannot be inherited via fork().
>>=20
>> Helper function bpf_capable() is added to check whether the task has got
>> permission via /dev/bpf.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>=20
> [ Lets Cc Jann so he has a chance to review as he was the one who suggest=
ed
>  the idea. ]
>=20
>> ---
>> Documentation/ioctl/ioctl-number.txt |  1 +
>> include/linux/bpf.h                  | 12 +++++
>> include/linux/sched.h                |  8 ++++
>> include/uapi/linux/bpf.h             |  5 ++
>> kernel/bpf/arraymap.c                |  2 +-
>> kernel/bpf/cgroup.c                  |  2 +-
>> kernel/bpf/core.c                    |  4 +-
>> kernel/bpf/cpumap.c                  |  2 +-
>> kernel/bpf/devmap.c                  |  2 +-
>> kernel/bpf/hashtab.c                 |  4 +-
>> kernel/bpf/lpm_trie.c                |  2 +-
>> kernel/bpf/offload.c                 |  2 +-
>> kernel/bpf/queue_stack_maps.c        |  2 +-
>> kernel/bpf/reuseport_array.c         |  2 +-
>> kernel/bpf/stackmap.c                |  2 +-
>> kernel/bpf/syscall.c                 | 72 +++++++++++++++++++++-------
>> kernel/bpf/verifier.c                |  2 +-
>> kernel/bpf/xskmap.c                  |  2 +-
>> kernel/fork.c                        |  4 ++
>> net/core/filter.c                    |  6 +--
>> 20 files changed, 104 insertions(+), 34 deletions(-)
>>=20
>> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/=
ioctl-number.txt
>> index c9558146ac58..19998b99d603 100644
>> --- a/Documentation/ioctl/ioctl-number.txt
>> +++ b/Documentation/ioctl/ioctl-number.txt
>> @@ -327,6 +327,7 @@ Code  Seq#(hex)	Include File		Comments
>> 0xB4	00-0F	linux/gpio.h		<mailto:linux-gpio@vger.kernel.org>
>> 0xB5	00-0F	uapi/linux/rpmsg.h	<mailto:linux-remoteproc@vger.kernel.org>
>> 0xB6	all	linux/fpga-dfl.h
>> +0xBP	01-02	uapi/linux/bpf.h	<mailto:bpf@vger.kernel.org>
>> 0xC0	00-0F	linux/usb/iowarrior.h
>> 0xCA	00-0F	uapi/misc/cxl.h
>> 0xCA	10-2F	uapi/misc/ocxl.h
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index a62e7889b0b6..dbba7870f6df 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -14,6 +14,10 @@
>> #include <linux/numa.h>
>> #include <linux/wait.h>
>> #include <linux/u64_stats_sync.h>
>> +#include <linux/sched.h>
>> +#include <linux/capability.h>
>> +
>> +#include <asm/current.h>
>>=20
>> struct bpf_verifier_env;
>> struct perf_event;
>> @@ -742,6 +746,12 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, co=
nst union bpf_attr *kattr,
>> int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
>> 				     const union bpf_attr *kattr,
>> 				     union bpf_attr __user *uattr);
>> +
>> +static inline bool bpf_capable(int cap)
>> +{
>> +	return test_bit(TASK_BPF_FLAG_PERMITTED, &current->bpf_flags) ||
>> +		capable(cap);
>> +}
>> #else /* !CONFIG_BPF_SYSCALL */
>> static inline struct bpf_prog *bpf_prog_get(u32 ufd)
>> {
>> @@ -874,6 +884,8 @@ static inline int bpf_prog_test_run_flow_dissector(s=
truct bpf_prog *prog,
>> {
>> 	return -ENOTSUPP;
>> }
>> +
>> +#define bpf_capable(cap) capable((cap))
>> #endif /* CONFIG_BPF_SYSCALL */
>>=20
>> static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 11837410690f..ddd33d4476c5 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1200,6 +1200,10 @@ struct task_struct {
>> 	unsigned long			prev_lowest_stack;
>> #endif
>>=20
>> +#ifdef CONFIG_BPF_SYSCALL
>> +	unsigned long			bpf_flags;
>> +#endif
>=20
> There are plenty of bits available here:
>=20
>        /* --- cacheline 14 boundary (896 bytes) --- */
>        unsigned int               in_execve:1;          /*   896:31  4 */
>        unsigned int               in_iowait:1;          /*   896:30  4 */
>        unsigned int               restore_sigmask:1;    /*   896:29  4 */
>        unsigned int               in_user_fault:1;      /*   896:28  4 */
>        unsigned int               no_cgroup_migration:1; /*   896:27  4 *=
/
>        unsigned int               frozen:1;             /*   896:26  4 */
>        unsigned int               use_memdelay:1;       /*   896:25  4 */
>=20
>        /* XXX 25 bits hole, try to pack */
>        /* XXX 4 bytes hole, try to pack */
>=20
> Given that bpf is pretty much enabled by default everywhere, I don't thin=
k we
> should waste so much space in task_struct just for this flag (pretty sure=
 that
> task_struct is the equivalent of sk_buff that rather needs a diet). Other=
 options
> could be to add to atomic_flags which also still has space.

Good point. Let me find a free bit for it.=20

>=20
>> 	/*
>> 	 * New fields for task_struct should be added above here, so that
>> 	 * they are included in the randomized portion of task_struct.
>> @@ -1772,6 +1776,10 @@ static inline void set_task_cpu(struct task_struc=
t *p, unsigned int cpu)
>>=20
>> #endif /* CONFIG_SMP */
[...]
>> +
>> +static long bpf_dev_ioctl(struct file *filp,
>> +			  unsigned int ioctl, unsigned long arg)
>> +{
>> +	switch (ioctl) {
>> +	case BPF_DEV_IOCTL_GET_PERM:
>> +		set_bit(TASK_BPF_FLAG_PERMITTED, &current->bpf_flags);
>> +		break;
>> +	case BPF_DEV_IOCTL_PUT_PERM:
>> +		clear_bit(TASK_BPF_FLAG_PERMITTED, &current->bpf_flags);
>=20
> I think the get/put for uapi is a bit misleading, first thought at least =
for
> me is on get/put_user() when I read the name.

I am not good at naming things. What would be better names here?=20

>=20
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +	return 0;
>> +}
>> +
>> +static const struct file_operations bpf_chardev_ops =3D {
>> +	.unlocked_ioctl =3D bpf_dev_ioctl,
>> +};
>> +
>> +static struct miscdevice bpf_dev =3D {
>> +	.minor		=3D MISC_DYNAMIC_MINOR,
>> +	.name		=3D "bpf",
>> +	.fops		=3D &bpf_chardev_ops,
>> +	.mode		=3D 0440,
>> +	.nodename	=3D "bpf",
>=20
> Here's what kvm does:
>=20
> static struct miscdevice kvm_dev =3D {
>        KVM_MINOR,
>        "kvm",
>        &kvm_chardev_ops,
> };
>=20
> Is there an actual reason that mode is not 0 by default in bpf case? Why
> we need to define nodename?

Based on my understanding, mode of 0440 is what we want. If we leave it=20
as 0, it will use default value of 0600. I guess we can just set it to=20
0440, as user space can change it later anyway.=20

I guess we really don't need nodename. I will remove it.=20

Thanks,
Song




