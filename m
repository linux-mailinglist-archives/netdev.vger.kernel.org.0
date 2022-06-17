Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A248654FFDD
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 00:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243885AbiFQW0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 18:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiFQW0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 18:26:19 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0C160DB7;
        Fri, 17 Jun 2022 15:26:16 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25HLhmbB007951;
        Fri, 17 Jun 2022 15:26:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Q6z8K7fqPdne4LyU9kOtPeODcUe1iQ33MkgGvt1gzHg=;
 b=giIEbMkTz/qP7UxLFLcB7sC0yGhnNNiaMkG3DKFlip8g3jSlsnJJzK2Q6qIZXKjgD4Gd
 tJGnmcddGpms/7k12qtdSFKyG/ThpaQI4/CE+LF1CK++h5HZRSVhw7c+wA1/0TlKQDNX
 f6qHoyex6O4DWY8e0JFG+p/AsW5bch4tVWM= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gr09vw03e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jun 2022 15:26:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0J2NWcexbAmFgZqTDCBOIvrX9+urC88N7SjPp559xaUwY1Q1e5106s0qCwDFJvb92JBgUP8xtiSVcTX6c0HnO1VsygKGU28sh0Md0N0UVi6zqo9TqcZPdwMrDclkpkKYpHDlkxu/6MIoOPnk/ZGNteFeONXKRNodLTzdLPQjsH4wcgDuNtytiZsWK6mA3uJ6Vh0oNZT5A/tpNgtS/LAJaB704Sz1ywQP+47bHB5+tvdxtMBhR0uniRrl7hGz7zW9MvCKFbgi7DsMl+2qhweqgMLf22ImZpusBjIwAFCpadJfUuOgJZAX8y8DGxNRQ/uoB2I890nPjgSnBSK/DoABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q6z8K7fqPdne4LyU9kOtPeODcUe1iQ33MkgGvt1gzHg=;
 b=SgXfICRc2wwP08uRflMrdx/HbYOapEt2Lc3RH+m6x+E/pimyh6DSzlLx+nfEgv8dU5FOP0N7df2uPdq6wWws9VMWXbhPDondpGfVJEqPVnfajQ8gxa5zaq48uI1oOr5KIg+cD/ehsCJO03N4x7V6JnpQ1UP78RohmzxVpTu9mLLghVzv29FT8nDzL1k8dU9chkFd0o0hq602HpK/zKlFWKjwT++WKeJJcv1Q2y9G3vwYRB4A6qffMPZ7l3tbI9M8LAcAVtXszDp7HJr+xGUodglS7EPVW2qJHzcib6645Mjo8LLRXXh04SrV+t0b6WiMPGNjiCbInT9bdtR8cFp8iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by MN2PR15MB2895.namprd15.prod.outlook.com (2603:10b6:208:ec::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 17 Jun
 2022 22:25:59 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%6]) with mapi id 15.20.5353.017; Fri, 17 Jun 2022
 22:25:59 +0000
Date:   Fri, 17 Jun 2022 15:25:58 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v9 03/10] bpf: per-cgroup lsm flavor
Message-ID: <20220617222558.gipxxl4mc5yd6sx3@kafai-mbp>
References: <20220610165803.2860154-1-sdf@google.com>
 <20220610165803.2860154-4-sdf@google.com>
 <20220616222522.5qsvsxlzxjkbfndu@kafai-mbp>
 <CAKH8qBu_zUJ0v59Bm0on-Aa_EzfH2y9RJ2pi=VNy5atzP+Tz7g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBu_zUJ0v59Bm0on-Aa_EzfH2y9RJ2pi=VNy5atzP+Tz7g@mail.gmail.com>
X-ClientProxiedBy: BYAPR05CA0084.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::25) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f3b5c28-eb60-4bbc-b9bc-08da50b05ad7
X-MS-TrafficTypeDiagnostic: MN2PR15MB2895:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB2895FDB78F4CC299F25C90E3D5AF9@MN2PR15MB2895.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdy2NkhFMN3I1oWySnqdq87YN94ttT9DeuHtvZ38m05qshgLLQgf+KzdHH+IZM6I9pPfC0X0K8G7HJJuAEr72U5I9bkah5fqLHdbRy9ukRA8G3pGDkDIJ3VScYkm2nGAcBXaHsm7T9F6Fig12p8udVXpggn/sH77Fj2LJIrX7jXAyuveSrps+P6j8uKZUZAimTK+HovC08h1Bw+ML1GiHfA/z7cQDMd55gIuDPLDXa9+ptiqyMkPQPX5BAFku+nw0JcikPwMnnPUcWWxELibvzE+qO2TiyCqxRvrdbih6637GyZfwqh7kYDwirwfFyObCayhdGQGXBUkHSj6YRb7fskO41nzoHjZOwXLXJCZLhYuUcOJdLLVpW5Jz3h1ST4Ezf2bjE33V8KXeGowuHD+Bk91ayC3pTrlEo4b+R1dhtiIfPE/DT4B3a3V7L70hmnZd7oJB8Ll7HWvF4gLSnJWjyeHQpl3cNtTzYt4b4VXHipkWxOq9dmIHrJ71uXIGZ1JOEilC5hnNcEvfth0/C88b39EjLZ3M1ARFx5/fiXzuPcage6L81PS1yl7Rp5Qti+mqNTS/EQccwXfLxxIHp6+d1e29DxsSeSZNypbP7bB9o9BTpQmFrI6SFT00dz4q4QL4ZdksoRJ7IsJail00EIMRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(86362001)(186003)(83380400001)(5660300002)(6916009)(33716001)(2906002)(8936002)(66556008)(6506007)(53546011)(8676002)(4326008)(66476007)(498600001)(1076003)(52116002)(6486002)(6512007)(316002)(38100700002)(9686003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dTFurE8x2eAgW1bQ2NIcAT8XqNTjcOnxBgNVneVNKdUg25f/O9vzmhWnzXwY?=
 =?us-ascii?Q?QpPxcvRnzlMw1MczhmnLNMmiT9Qo20wHf80mxAGW/nBlUc1oHhntCeYE46AZ?=
 =?us-ascii?Q?A80prjprF+JERYUuhH5iSx2SxFtc5Z6pnS3Ze1gtkLsZwQRe783y8Z+hlVA4?=
 =?us-ascii?Q?BnYcPNimmA5yz0fy0NLvxJ3+BWg9W+59vo8q2DBhWOFmDx8NGUoiDgP3QCXd?=
 =?us-ascii?Q?FIQTXpfMaftUuvnGNwyrYqA+tK5UVYgyrjG+fyrw2OK8glDxPOIV021YeHcp?=
 =?us-ascii?Q?FGjZ5jtgpQIWXCB3tV3CEJDzFfqpOGzLeritMhp0lgtJu9xbznj1lvj71dXC?=
 =?us-ascii?Q?Q7ENrif2COS73AkT2oc0x5o0410UYD6PXPisVxOXv9fzoVJSclCtR7o3fBnM?=
 =?us-ascii?Q?SYkUkDQRmBvbZHdsDBvto7dugkTg0ec9zOiSpB9/HOt4vB19UM1uCJ+jLENU?=
 =?us-ascii?Q?LjNU0FEaKCWpICy502D0+kZyS4FgGqEikFidliKQ8+ew+Gq5+KAb70pUjviJ?=
 =?us-ascii?Q?PnWyZGlgX4nSKqamF6KN1dIp7kXSpc5anGcwdC27y4DxdXktMLIY/Edc4tH4?=
 =?us-ascii?Q?Cbf4WkSkBCaKFzzu1yvGUb78583GwYft7adzg2agGP7GLFsUJzeMkEca8yuT?=
 =?us-ascii?Q?aJdIFSm01mqMkV1TmPFoDpcFMyAari3uRikmLLC7aXtg7TC6HcsRflRB0ko5?=
 =?us-ascii?Q?BKhOhm0lMATMfl3UCYEMIPL2rSYvcv+GTt+G9Iq/15zzENhO2XDbWg04e749?=
 =?us-ascii?Q?2IWRBWTcQ6TzszQx/Kk0nDjZMZqcHU+YFOxFo9Pn+B9oisN/u/LJCYzodZIT?=
 =?us-ascii?Q?Kske6P0Q1QPe/7sToSmaDetokdVBrBcFg2ppE56H4dKnpU5MgdZi6oHu1JFX?=
 =?us-ascii?Q?+gjy/HxqqH0LUCIXtkKnNAfM1bk75+uA39vEY1T266CTwLqTde1/euCRDHg9?=
 =?us-ascii?Q?HdEeU8QNDO8pfWKtCTPPk1T56NexhwFMkxTh/4aVVopJ6APN1VugGCZ/9l0e?=
 =?us-ascii?Q?tzYJHWpVqWy00eqy/xhVQlHkjA1hbfsqSSi21FMQabnEl2WFID1b4yONKg6i?=
 =?us-ascii?Q?9YNmXpZbI0/JxvsjlxiKnsGGCcELnWWBUN+hUY8xh6EPrWBXV9gr0gsYpGS+?=
 =?us-ascii?Q?/aIK8d3s6d0EKLGILzI/wHoK36JGuwUV3R6CobO+jmjk1nFmWzXD79d7aUfR?=
 =?us-ascii?Q?xxZHih10RdinCvYg7TCwykzUZNeR13Ph/JlS2r23y339rXuOIIX//P5aC/Ql?=
 =?us-ascii?Q?qVeZTnxbrcjekIqzsnPqzSCea63ZT9xgFHna7r2nrU5QKjxStjUUdegECz68?=
 =?us-ascii?Q?xGQ0DDjpWEgGgycsaGOsW6BjsOsTk0Jt8QicOVzUO4XyXFCMwZ8zZ6kV52f+?=
 =?us-ascii?Q?CffnZ/26NYZcx+B3MJE7dunaUOWBxLs22vddLPcwf774S/8ZBm8MxzzAKuw8?=
 =?us-ascii?Q?Vu268AhIGznYDbO/HW3ZboWhnKFM9rJW/s5h9th/CXLHCR5vJhmayas7peg9?=
 =?us-ascii?Q?ld56krD9oNSz1sIG1PC3Cnhb6UdXoGL4GQp9MTQowF3ZDYeKgmm7re5id0ne?=
 =?us-ascii?Q?dSC71HFO6DajuduUdWk2GA68iDsli4TA3E0FeCqsTlH4BvMJPw0/U6dihH7D?=
 =?us-ascii?Q?1030mGmWteJ1elDRqbjdcE5oIXwVtmtBEMbVWZuWhPPF6tErpTMG6PYnXnCN?=
 =?us-ascii?Q?sEZ89fsMUx4uIS12A3TiInM/vgHsar7QAKwOMQ7CvAHaRIvHEd1x2T5EXLb7?=
 =?us-ascii?Q?VfVNm2g4u83Wr/vsn1YM1HEpFZHe5lI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3b5c28-eb60-4bbc-b9bc-08da50b05ad7
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 22:25:59.7243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36pJjIi2zq7u+NZIL8K5Sipw9m143efKCg+v+gAliRRK/OU8170pkRntWQ3yKrkt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2895
X-Proofpoint-GUID: D6Sm1cEi6eO4PwQHqWgh91mh2RLzrrhy
X-Proofpoint-ORIG-GUID: D6Sm1cEi6eO4PwQHqWgh91mh2RLzrrhy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-17_14,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 11:28:15AM -0700, Stanislav Fomichev wrote:
> On Thu, Jun 16, 2022 at 3:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Fri, Jun 10, 2022 at 09:57:56AM -0700, Stanislav Fomichev wrote:
> > > Allow attaching to lsm hooks in the cgroup context.
> > >
> > > Attaching to per-cgroup LSM works exactly like attaching
> > > to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> > > to trigger new mode; the actual lsm hook we attach to is
> > > signaled via existing attach_btf_id.
> > >
> > > For the hooks that have 'struct socket' or 'struct sock' as its first
> > > argument, we use the cgroup associated with that socket. For the rest,
> > > we use 'current' cgroup (this is all on default hierarchy == v2 only).
> > > Note that for some hooks that work on 'struct sock' we still
> > > take the cgroup from 'current' because some of them work on the socket
> > > that hasn't been properly initialized yet.
> > >
> > > Behind the scenes, we allocate a shim program that is attached
> > > to the trampoline and runs cgroup effective BPF programs array.
> > > This shim has some rudimentary ref counting and can be shared
> > > between several programs attaching to the same per-cgroup lsm hook.
> > nit. The 'per-cgroup' may be read as each cgroup has its own shim.
> > It will be useful to rephrase it a little.
> 
> I'll put the following, LMK if still not clear.
> 
> This shim has some rudimentary ref counting and can be shared
> between several programs attaching to the same lsm hook from
> different cgroups.
SG.

> > > @@ -839,8 +953,11 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
> > >       if (hlist_empty(progs))
> > >               /* last program was detached, reset flags to zero */
> > >               cgrp->bpf.flags[atype] = 0;
> > > -     if (old_prog)
> > > +     if (old_prog) {
> > > +             if (type == BPF_LSM_CGROUP)
> > > +                     bpf_trampoline_unlink_cgroup_shim(old_prog);
> > I think the same bpf_trampoline_unlink_cgroup_shim() needs to be done
> > in bpf_cgroup_link_release()?  It should be done just after
> > WARN_ON(__cgroup_bpf_detach()).
> 
> Oooh, I missed that, I thought that old_prog would have the pointer to
> the old program even if it's a link :-(
> 
> Do you mind if I handle it in __cgroup_bpf_detach as well? Or do you
> think it's cleaner to do in bpf_cgroup_link_release?
> 
> if (old_prog) {
>   ...
> } else if (link) {
>   if (type == BPF_LSM_CGROUP)
>     bpf_trampoline_unlink_cgroup_shim(link->link.prog);
> }
I think this will be similar to the earlier revision.

I was thinking doing it in bpf_cgroup_link_release() for link
where I know the bpf_prog_put() will be handled by bpf_link_free()
as other link's release/detach functions do.  Otherwise, the first
reading impression is why there is no bpf_prog_put() in
__cgroup_bpf_detach() for the link case.

No strong opinion here.  Either way is fine.  Mostly personal impression
when reading the code in the first pass.  Reading it closely should be
able to figure out in either way.

> 
> > [ ... ]
> >
> > > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > > index aeb31137b2ed..a237be4f8bb3 100644
> > > --- a/kernel/bpf/syscall.c
> > > +++ b/kernel/bpf/syscall.c
> > > @@ -3416,6 +3416,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
> > >               return BPF_PROG_TYPE_SK_LOOKUP;
> > >       case BPF_XDP:
> > >               return BPF_PROG_TYPE_XDP;
> > > +     case BPF_LSM_CGROUP:
> > > +             return BPF_PROG_TYPE_LSM;
> > >       default:
> > >               return BPF_PROG_TYPE_UNSPEC;
> > >       }
> > > @@ -3469,6 +3471,11 @@ static int bpf_prog_attach(const union bpf_attr *attr)
> > >       case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> > >       case BPF_PROG_TYPE_CGROUP_SYSCTL:
> > >       case BPF_PROG_TYPE_SOCK_OPS:
> > > +     case BPF_PROG_TYPE_LSM:
> > > +             if (ptype == BPF_PROG_TYPE_LSM &&
> > > +                 prog->expected_attach_type != BPF_LSM_CGROUP)
> > Check this in bpf_prog_attach_check_attach_type() where
> > other expected_attach_type are enforced.
> 
> It was there initially but I moved it here because
> bpf_prog_attach_check_attach_type() is called from link_create() as
> well where the range of acceptable expected_attach_type(s) is larger.
Ah. ic.  Thanks for the explanation.

> > > diff --git a/tools/include/linux/btf_ids.h b/tools/include/linux/btf_ids.h
> > > index 57890b357f85..2345b502b439 100644
> > > --- a/tools/include/linux/btf_ids.h
> > > +++ b/tools/include/linux/btf_ids.h
> > > @@ -172,7 +172,9 @@ extern struct btf_id_set name;
> > >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)          \
> > >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)                    \
> > >       BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)                      \
> > > -     BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
> > > +     BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)                    \
> > > +     BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)                    \
> > The existing tools's btf_ids.h looks more outdated from
> > the kernel's btf_ids.h.  unix_sock is missing which is added back here.
> > mptcp_sock is missing also but not added.  I assume the latter test
> > needs unix_sock here ?
> 
> I haven't added mptcp_sock because I was added recently.
> 
> I don't think we really need to do the changes to tools/btf_ids.h, but
> it still might be worth trying to keep them in sync?
Yeah.  Other than this list, it seems other parts of this file is out of sync
also.  May be just do an individual patch in this series to do a
copy-and-paste update of the whole file.
